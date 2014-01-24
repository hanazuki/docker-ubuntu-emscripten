require 'spec_helper'

describe "Clang toolchain" do
  %w{clang clang++}.each do |cmd|
    describe file("/usr/bin/#{cmd}") do
      it { should be_file }
      it { should be_executable }
    end

    describe command("/usr/bin/#{cmd} --version") do
      it { should return_exit_status 0 }
      its(:stdout) { should match /clang version 3\.2/ }
    end

    describe command("which #{cmd}") do
      it { should return_exit_status 0 }
      its(:stdout) { should eq "/usr/bin/#{cmd}\n" }
    end
  end
end

describe "LLVM toolchain" do
  %w{llvm-link llvm-ar llvm-as llvm-dis llvm-nm opt lli llc}.each do |cmd|
    describe file("/usr/bin/#{cmd}") do
      it { should be_file }
      it { should be_executable }
    end

    describe command("which #{cmd}") do
      it { should return_exit_status 0 }
      its(:stdout) { should eq "/usr/bin/#{cmd}\n" }
    end
  end
end

describe "Pyhton interpreter" do
  describe file("/usr/bin/python2") do
    it { should be_file }
    it { should be_executable }
  end

  describe command("/usr/bin/python2 --version 2>&1") do
    it { should return_exit_status 0 }
    its(:stdout) { should match /^Python 2\.7\./ }
  end

  describe command("which python2") do
    it { should return_exit_status 0 }
    its(:stdout) { should eq "/usr/bin/python2\n" }
  end
end

describe "node.js" do
  describe file("/usr/bin/nodejs") do
    it { should be_file }
    it { should be_executable }
  end

  describe command("/usr/bin/nodejs --version") do
    it { should return_exit_status 0 }
    its(:stdout) { should match /^v0\.10\./ }
  end

  describe command("which nodejs") do
    it { should return_exit_status 0 }
    its(:stdout) { should eq "/usr/bin/nodejs\n" }
  end
end

describe file('/opt/emscripten') do
  it { should be_directory }
end

describe "emscripten toolchain" do
  %w{em++ emcc emmake emconfigure emar emranlib em-config}.each do |cmd|
    describe file("/opt/emscripten/#{cmd}") do
      it { should be_file }
    end

    describe file("/usr/local/bin/#{cmd}") do
      it { should be_linked_to "/opt/emscripten/#{cmd}" }
    end

    describe command("which #{cmd}") do
      it { should return_exit_status 0 }
      its(:stdout) { should eq "/usr/local/bin/#{cmd}\n" }
    end
  end

  %w{em++ emcc}.each do |cmd|
    describe command("/usr/local/bin/#{cmd} --version") do
      it { should return_exit_status 0 }
      its(:stdout) { should match /Emscripten/ }
    end
  end
end

describe file("/.emscripten") do
  it { should be_file }
  it { should be_readable }
  its(:content) { should match %r{^EMSCRIPTEN_ROOT\s*=.*'/opt/emscripten'} }
  its(:content) { should match %r{^LLVM_ROOT\s*=.*'/usr/bin'} }
  its(:content) { should match %r{^PYTHON\s*=.*'/usr/bin/python2'} }
  its(:content) { should match %r{^NODE_JS\s*=.*'/usr/bin/nodejs'} }
end

describe "emscripten library cache" do
  describe file("/.emscripten_cache") do
    it { should be_directory }
  end

  %w{libc.bc libcextra.bc libcxx.bc libcxxabi.bc sdl.bc}.each do |bc|
    describe file("/.emscripten_cache/#{bc}") do
      it { should be_file }
    end
  end

  describe file("/.emscripten_cache/relooper.js") do
    it { should be_file }
  end
end

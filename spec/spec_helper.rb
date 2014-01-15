require 'serverspec'

include SpecInfra::Helper::Docker
include SpecInfra::Helper::DetectOS

RSpec.configure do |c|
  c.docker_image = ::Docker::Image.build_from_dir('.').id
end

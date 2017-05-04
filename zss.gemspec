Gem::Specification.new do |spec|
  spec.name = 'zss'
  spec.version = '0.1.0'
  spec.authors = ['Weida Hong']
  spec.email = 'wdhongtw@gmail.com'
  spec.summary = 'Tree edit distance algorithm by Zhang and Shasha'
  spec.description = <<DESCRIPTION
This `zss` module provides a utility to compute tree edit distance between
two given trees.

The algorithm is provided by Kaizhong Zhang and Dennis Shasha.
DESCRIPTION

  spec.files = Dir.glob('lib/**/*')
  spec.files += Dir.glob('test/**/*')
  spec.files += Dir.glob('bin/**/*')
  spec.files += %w(Gemfile README.md Rakefile zss.gemspec)
end

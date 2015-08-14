

```
# The version requirements are optional.
# You can also specify multiple version requirements, just append more at the end
gem_name, *gem_ver_reqs = 'json', '~> 1.8.0'
gdep = Gem::Dependency.new(gem_name, *gem_ver_reqs)
# find latest that satisifies
found_gspec = gdep.matching_specs.sort_by(&:version).last
# instead of using Gem::Dependency, you can also do:
# Gem::Specification.find_all_by_name(gem_name, *gem_ver_reqs)
```

```
if found_gspec
  puts "Requirement '#{gdep}' already satisfied by #{found_gspec.name}-#{found_gspec.version}"
else
  puts "Requirement '#{gdep}' not satisfied; installing..."
  ver_args = gdep.requirements_list.map{|s| ['-v', s] }.flatten
  # multi-arg is safer, to avoid injection attacks
  system('gem', 'install', gem_name, *ver_args)
end
```

#!/usr/bin/env ruby

require 'yaml'

product_path = "#{ENV["BUILT_PRODUCTS_DIR"]}/#{ENV["PRODUCT_NAME"]}.app"

target_files = Dir.glob("#{product_path}/**/holo_target.{yaml,yml}")

all_targets = target_files.map do |path|
    YAML.load(File.open(path))
end.reduce(:merge)

File.open "#{product_path}/.HOLO_ALL_TARGETS.yaml", "w" do |file|
    file.write(all_targets.to_yaml)
end

#!/bin/bash

output=$(dotnet nuget locals global-packages -l)
packages_folder=${output#"global-packages: "}
folders=()

for package_folder in $packages_folder*; do
  count=$(ls -l $package_folder | grep "^d" | wc -l)
  if [ $count -gt 1 ]; then
    package_name=${package_folder##*/}
    echo ${package_name}
    for version_name in $(ls -1tr $package_folder | tail -n +2); do
      echo "\t$version_name"
      version_folder=${package_folder}/${version_name}
      folders+=($version_folder)
    done
    echo ""
  fi
done

if [ ${#folders[*]} = 0 ]; then
  echo "未找到多余的 nuget 包版本。"
  exit
fi

read -r -p "确认删除列表中的 nuget 包？(Y/n)" response

if [[ "$response" =~ ^([yY])$ ]]; then
  for folder in ${folders[*]}; do
    rm -r ${folder}
  done
fi

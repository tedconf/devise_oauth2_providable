base_dir=`dirname $(dirname "$0")`
ruby_version=`cat $base_dir/.ruby-version | tr -d '\n'`
ruby_versions='2.5.7 2.6.5 2.7.0'
ruby_gemset=`cat $base_dir/.ruby-gemset | tr -d '\n'`
for i in `ls $base_dir/gemfiles/Gemfile* | grep -v lock`
do
  for rb in $ruby_versions
  do
    export BUNDLE_GEMFILE=$i
    rvm "$rb@$ruby_gemset" exec ruby --version && bundle update && rails --version && rake spec
  done
done

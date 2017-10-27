for i in `ls gemfiles/Gemfile* | grep -v lock`
do
  for rb in '2.4.2@devise_oauth2_providable' '2.3.5@devise_oauth2_providable' '2.2.8@devise_oauth2_providable'
  do
    export BUNDLE_GEMFILE=$i
    rvm $rb exec ruby --version && rails --version && bundle check || bundle && rake spec
  done
done

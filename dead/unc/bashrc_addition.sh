#!/usr/bin/env  sh
# Everything is totally screwed up because of Bash.  You have to rig a gateway through bash to run a script which will change into another directory.
# for $HOME/.bashrc



unc ()
{
  if [ -z "$@" ]; then
    echo  'unc <filename>'
  else
    # TODO: This should run the script once, and then chop it apart..
    # this way the scripting can properly communicate to bash and its screen -- to print help screens or other useful information.
    # I could process things if I did something like this.
    #   test=`ruby ~/bin/unc "$*"`
    # then act on it intelligently...
    #   echo $1
    #   cd $2
    #   echo $3-$* (if that is possible)
    cd  "$( ruby ~/bin/unc "$*" )"  ||  return  $?
  fi
}

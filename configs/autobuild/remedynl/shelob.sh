#!/bin/sh
#
# $Id$
#
cd $HOME/ACE/autobuild

svn up

sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc110_64.sh
sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc101_64_v.sh
sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc101_32.sh
sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc101_64.sh
sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc91_32.sh
sh $HOME/ACE/autobuild/configs/autobuild/remedynl/shelob_icc91_64.sh

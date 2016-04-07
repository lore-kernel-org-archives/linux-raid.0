From: Anthonys Lists <antlists@youngman.org.uk>
Subject: Is mdadm.conf necessary? Is this the cause of my problems?
Date: Thu, 7 Apr 2016 22:55:03 +0100
Message-ID: <5706D737.1000604@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've never managed to fix the problem I have where my running system has 
root mounted on a "non-existent" partition. In other words, when I do a 
"mount" it tells me /dev/md127 is mounted at "/". Except /dev/md127 
doesn't actually exist ...

If I do an "ls -al" of /dev/md I get

drwx------  2 root root  100 Apr  7 18:48 .
drwxr-xr-x 18 root root 4500 Apr  7 17:49 ..
lrwxrwxrwx  1 root root   10 Apr  7 18:48 126_0 -> /dev/md127
lrwxrwxrwx  1 root root    8 Apr  7 18:48 126_1 -> ../md126
lrwxrwxrwx  1 root root   10 Apr  7 18:48 slackware:2 -> /dev/md127

So dev knows about 126_0, and slackware:2, which are presumably pointing 
at the initramfs /dev/md127 (which is why everything runs), but somehow 
it hasn't translated to the current /dev.

Okay, so let's look at mdadm.conf (last modified in 2014, which is I 
guess when I set the system up, and I've mucked about with it since, so 
we could have an old mdadm.conf which doesn't actually reflect the 
reality of the disks ...)

# mdadm configuration file
#
# mdadm will function properly without the use of a configuration file,
# but this file is useful for keeping track of arrays and member disks.
# In general, a mdadm.conf file is created, and updated, after arrays
# are created. This is the opposite behavior of /etc/raidtab which is
# created prior to array construction.
#
#
# the config file takes two types of lines:
#
#    DEVICE lines specify a list of devices of where to look for
#      potential member disks
#
#    ARRAY lines specify information about how to identify arrays so
#      so that they can be activated
#
# You can have more than one device line and use wild cards. The first
# example includes SCSI the first partition of SCSI disks /dev/sdb,
# /dev/sdc, /dev/sdd, /dev/sdj, /dev/sdk, and /dev/sdl. The second
# line looks for array slices on IDE disks.
#
#DEVICE /dev/sd[bcdjkl]1
#DEVICE /dev/hda1 /dev/hdb1
#
# If you mount devfs on /dev, then a suitable way to list all devices is:
#DEVICE /dev/discs/*/*
#
#
# The AUTO line can control which arrays get assembled by auto-assembly,
# meaing either "mdadm -As" when there are no 'ARRAY' lines in this file,
# or "mdadm --incremental" when the array found is not listed in this file.
# By default, all arrays that are found are assembled.
# If you want to ignore all DDF arrays (maybe they are managed by dmraid),
# and only assemble 1.x arrays if which are marked for 'this' homehost,
# but assemble all others, then use
#AUTO -ddf homehost -1.x +all
#
# ARRAY lines specify an array to assemble and a method of identification.
# Arrays can currently be identified by using a UUID, superblock minor 
number,
# or a listing of devices.
#
#    super-minor is usually the minor number of the metadevice
#    UUID is the Universally Unique Identifier for the array
# Each can be obtained using
#
#     mdadm -D <md>
#
#ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
#ARRAY /dev/md1 super-minor=1
#ARRAY /dev/md2 devices=/dev/hda1,/dev/hdb1
#
# ARRAY lines can also specify a "spare-group" for each array. mdadm 
--monitor
# will then move a spare between arrays in a spare-group if one array 
has a failed
# drive but no spare
#ARRAY /dev/md4 uuid=b23f3c6d:aec43a9f:fd65db85:369432df spare-group=group1
#ARRAY /dev/md5 uuid=19464854:03f71b1b:e0df2edd:246cc977 spare-group=group1
#
# When used in --follow (aka --monitor) mode, mdadm needs a
# mail address and/or a program.  This can be given with "mailaddr"
# and "program" lines to that monitoring can be started using
#    mdadm --follow --scan & echo $! > /run/mdadm/mon.pid
# If the lines are not found, mdadm will exit quietly
#MAILADDR root@mydomain.tld
#PROGRAM /usr/sbin/handle-mdadm-events
ARRAY /dev/md/126_0 metadata=1.2 name=root 
UUID=660afb13:150e817a:0cdd3647:6d5b2c51
ARRAY /dev/md/126_1 metadata=0.90 UUID=81f33aa2:c56b4118:14a75d6a:bbcc0774

Should I just delete mdadm.conf and the system will probably sort itself 
out, or am I better off updating the ARRAY lines to match current 
reality, namely changing 126_0 to 127, and 126_1 to plain 126?

Cheers,
Wol

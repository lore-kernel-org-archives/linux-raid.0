From: romualdo@solnet.ch
Subject: cannot write a new superblock
Date: Wed, 20 Apr 2005 13:09:10 -0000 (GMT)
Message-ID: <19839.212.101.18.92.1114002550.squirrel@212.101.18.92>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hy

The storry

I have changed my raid5 array from a PC with Debian Sarge -kernel2.4.26 to
an other  machine with a Debian Sarge -kernel 2.6.8

this has work but not so fine

the array in new machine doesn't run automaticaly
but if I make the command

raidstart /dev/md0

the array starts, but with errors like this

fatmama:~# raidstart /dev/md0
md: sda1 has invalid sb, not importing!
md: could not import unknown-block(8,1)!
md: autostart unknown-block(0,2049) failed!
/dev/md0: Invalid argument

but anyway I was able to mount the /dev/md0

but I did not want to have this errors, and I have updated from raidtools2
to mdadm

than i have read a message at the installation-progress that I should make
the command
mdadm --zero-superblock /dev/xxx

ok after installation I have do this

at first with the command
mdadm --zero-superblock /dev/md0

than I had a message like this
on /dev/md0 it has no superblock

ok I make this command
mdadm --zero-superblock /dev/sda1
mdadm --zero-superblock /dev/sdb1
and so one

this had work

but when I have make all this superblock-commands, the raidarray was not
active

and now I had the problem when I want start the raid-array with
mdadm --run /dev/md0
I had anyway an error like this

no superblock on /dev/md0

now I have removed the mdadm and reinstall the raidtools2
and test to start the array with
raidstart /dev/md0

it was the same >> no superblock

now I had want to write a new superblock with

fatmama:~# mkraid --upgrade /dev/md0
handling MD device /dev/md0
analyzing super-block
disk 0: /dev/sda1, 17920476kB, raid superblock at 17920384kB
cannot upgrade magic-less superblock on /dev/sda1 ...
mkraid: aborted, see the syslog and /proc/mdstat for potential clues.

this was the output

I have also tested the same with the
mdadm --assemble command

the same: cannot write superblock

what can I do that my raid-array works?
how can I write the superblocks, so that I can start the array,without
destroying the datas?
I'm sure that they are  on the not startable array, because I haven't make a
mkraid /dev/md0
and I also not formatet the disk

I was reading through all the web, and I have only found questions but no
answers about this problem

I would be very happy when I could start my raid-array

Thanks a lot for  your (I hope it) helpfull answer


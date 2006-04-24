From: dean gaudet <dean@arctic.org>
Subject: proactive raid5 disk replacement success (using bitmap + raid1)
Date: Sun, 23 Apr 2006 18:40:17 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0604231823560.22072@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i had a disk in a raid5 which i wanted to clone onto the hot spare... 
without going offline and without long periods without redundancy.  a few 
folks have discussed using bitmaps and temporary (superblockless) raid1 
mappings to do this... i'm not sure anyone has tried / reported success 
though.  this is my success report.

setup info:

- kernel version 2.6.16.9 (as packaged by debian)
- mdadm version 2.4.1
- /dev/md4 is the raid5
- /dev/sde1 is the disk in md4 i want to clone from
- /dev/sdh1 is the hot spare from md4, and is the clone target
- /dev/md5 is an unused md device name

here are the exact commands i issued:

mdadm -Gb internal --bitmap-chunk=1024 /dev/md4
mdadm /dev/md4 -r /dev/sdh1
mdadm /dev/md4 -f /dev/sde1 -r /dev/sde1
mdadm --build /dev/md5 -ayes --level=1 --raid-devices=2 /dev/sde1 missing
mdadm /dev/md4 --re-add /dev/md5
mdadm /dev/md5 -a /dev/sdh1

... wait a few hours for md5 resync...

mdadm /dev/md4 -f /dev/md5 -r /dev/md5
mdadm --stop /dev/md5
mdadm /dev/md4 --re-add /dev/sdh1
mdadm --zero-superblock /dev/sde1
mdadm /dev/md4 -a /dev/sde1

this sort of thing shouldn't be hard to script :)

the only times i was without full redundancy was briefly between the "-r" 
and "--re-add" commands... and with bitmap support the raid5 resync for 
each of those --re-adds was essentially zero.

thanks Neil (and others)!

-dean

p.s. it's absolutely necessary to use "--build" for the temporary raid1 
... if you use --create mdadm will rightfully tell you it's already a raid 
component and if you --force it then you'll trash the raid5 superblock and 
it won't fit into the raid5 any more...

From: sunruh@prismnet.com
Subject: please help - raid 1 degraded
Date: Wed, 11 Feb 2015 12:04:03 -0600
Message-ID: <20150211180403.GA14805@fnord.prismnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

centos 6.6
2x 240gig ssd in raid1
this is a live running production machine and the raid1 is for /u of
users home dirs.

1 ssd went totally offline and i replaced it after noticing the firmware
levels are not the same.  the new ssd has the same level firmware.

/dev/sdb is the good ssd
/dev/sdc is the new blank ssd

when working it was /u1 from /dev/md127p1 and /u2 from /dev/md127p2
p1 is 80gig and p2 is 160gig for the full 240gig size of the ssd

> ls -al /dev/md*
brw-rw---- 1 root disk   9, 127 Feb 11 11:09 /dev/md127
brw-rw---- 1 root disk 259,   0 Feb 10 20:23 /dev/md127p1
brw-rw---- 1 root disk 259,   1 Feb 10 20:23 /dev/md127p2

/dev/md:
total 8
drwxr-xr-x  2 root root  140 Feb 10 20:24 .
drwxr-xr-x 20 root root 3980 Feb 10 20:24 ..
lrwxrwxrwx  1 root root    8 Feb 11 11:09 240ssd_0 -> ../md127
lrwxrwxrwx  1 root root   10 Feb 10 20:23 240ssd_0p1 -> ../md127p1
lrwxrwxrwx  1 root root   10 Feb 10 20:23 240ssd_0p2 -> ../md127p2
-rw-r--r--  1 root root    5 Feb 10 20:24 autorebuild.pid
-rw-------  1 root root   63 Feb 10 20:23 md-device-map

> ps -eaf | grep mdadm
root      2188     1  0 Feb10 ?        00:00:00 mdadm --monitor --scan -f --pid-file=/var/run/mdadm/mdadm.pid

how do i rebuild /dev/sdc into the mirror of /dev/sdb?

and thanks much for the help!
steve

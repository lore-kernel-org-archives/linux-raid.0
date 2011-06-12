From: jeffs_linux@123mail.org
Subject: Re: Why do I get different results for 'mdadm --detail' & 'mdadm
 --examine' for the same array?
Date: Sat, 11 Jun 2011 18:42:46 -0700
Message-ID: <1307842966.26762.1462147225@webmail.messagingengine.com>
References: <1307840471.18429.1462140465@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1307840471.18429.1462140465@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sat, 11 Jun 2011 18:01 -0700, jeffs_linux@123mail.org wrote:
> I'm working on setting up my 1st Linux production server with RAID for
> our office.

I was digging through my logs and found these 'failed' notices,

grep mdadm /var/log/*
/var/log/boot.msg:udevd[360]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[363]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[364]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[366]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[367]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[377]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[382]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[383]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[426]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[427]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[428]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:udevd[431]: exec of program '/bin/grep -qs '^AUTO
-all' /etc/mdadm.conf' failed
/var/log/boot.msg:mdadm: /dev/md127 has been started with 4 drives.
/var/log/boot.msg:Starting MD Raid mdadm: /dev/md/0_0 has been started
with 4 drives.
/var/log/boot.msg:<notice -- Jun 11 16:52:56.214405000> mdadmd start
/var/log/boot.msg:Starting mdadmd
/var/log/boot.msg:<notice -- Jun 11 16:52:56.293717000> startproc:
execve (/sbin/mdadm) [ /sbin/mdadm -F -d 60 -m root@localhost -s -c
/etc/mdadm.conf ], [ DO_FASTBOOT=no CONSOLE=/dev/console SELINUX_INIT=NO
ROOTFS_FSTYPE=ext4 SHELL=/bin/sh TERM=dumb ROOTFS_FSCK=0 LC_ALL=POSIX
INIT_VERSION=sysvinit-2.89 DO_BLOGD=yes REDIRECT=/dev/ttyS0 COLUMNS=80
PATH=/bin:/sbin:/usr/bin:/usr/sbin vga=0x31a DO_CONFIRM=no RUNLEVEL=5
PWD=/
SPLASHCFG=/etc/bootsplash/themes/openSUSE/config/bootsplash-1280x1024.cfg
DO_QUIET=no PREVLEVEL=N LINES=24 HOME=/ SHLVL=2 DO_FORCEFSCK=no
SPLASH=yes ROOTFS_BLKDEV=/dev/VG0/ROOT0 _=/sbin/startproc
DAEMON=/sbin/mdadm ]
/var/log/boot.msg:'mdadmd start' exits with status 0

I also found this file,

cat /dev/.mdadm/map
---------------------------------------------------------------
md126 0.90 19f2b21c:e54f9e1a:be5ad16e:9754ab5e /dev/md/0_0
md127 1.2 79fb7ad4:289bfae5:86c535ff:202960f2 /dev/md127
---------------------------------------------------------------

which I think is created maybe by udevd that's complaining about all
those failures above?

What's unexpected is that 'map' files /dev/md0_0 UUID matches the
"--detail" scan, but the UUID for the /dev/md127 device is different !?

mdadm --detail --scan
        ARRAY /dev/md127 metadata=1.2 name=jeffadm:jeffadm1
        UUID=d84afb64:e6fa2b64:ff21c975:f9765431
        ARRAY /dev/md/0_0 metadata=0.90
        UUID=19f2b21c:e54f9e1a:be5ad16e:9754ab5e

I'm pretty confused about what IS versus what SHOULD BE happening, or
whether I should delete/modify something, so I'm going to hold-off any
changes and hope somebody can shed some light.

Jeff

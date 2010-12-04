From: Andrey Borzenkov <arvidjaar@gmail.com>
Subject: safe_mode_delay always zero after ddf container was assembled
Date: Sat, 4 Dec 2010 11:28:47 +0300
Message-ID: <AANLkTi=FoZaAFWr4C0Lzv45ryG6KJ86PLa=Xk4fBYjYn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I needed array with external metadata to test shutdown behaviour so I
created VM with DDF container and single RAID1 array on top of it.
Arrays was created manually using

mdadm -C -e ddf -n 2 /dev/md0 /dev/sdb /dev/sdc

(after autoassembly md0 becomes md127, but it does not matter)

The problem is, after assembling array safe_mode_delay is always set
to zero; so array always comes dirty after reboot:

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid1]
unused devices: <none>

[root@localhost ~]# mdadm --verbose -A -s
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/sda6: Device or resource busy
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: no RAID superblock on /dev/sda2
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sdc is identified as a member of /dev/md/ddf0, slot 1.
mdadm: /dev/sdb is identified as a member of /dev/md/ddf0, slot 0.
mdadm: added /dev/sdc to /dev/md/ddf0 as 1
mdadm: added /dev/sdb to /dev/md/ddf0 as 0
mdadm: Container /dev/md/ddf0 has been assembled with 2 drives
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/sda2
mdadm: looking for devices for further assembly
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: cannot open device /dev/sda6: Device or resource busy
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: no recogniseable superblock on /dev/sda2
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: looking in container /dev/md127
mdadm: found match on member /md127/0 in /dev/md127
mdadm: Started /dev/md/1 with 2 devices
mdadm: looking for devices for further assembly
mdadm: looking for devices for further assembly
mdadm: no recogniseable superblock on /dev/md/1
mdadm: cannot open device /dev/sdc: Device or resource busy
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: cannot open device /dev/sda6: Device or resource busy
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: no recogniseable superblock on /dev/sda2
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: looking in container /dev/md127
mdadm: member /md127/0 in /dev/md127 is already assembled

[root@localhost ~]# cat /sys/block/md*/md/safe_mode_delay
0.000
0.000

[root@localhost ~]# mdadm --version
mdadm - v3.1.4 - 31st August 2010

Is it expected? Where is safe_mode_delay is supposed to be set to
default (which should be 0.2s)?

TIA

-andrey

From: Scott Bisker <scott@bisker.com>
Subject: Problem with Raid 1/5 2.4.x kernel
Date: 06 Jun 2002 15:33:19 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1023392000.15766.0.camel@rnd-187-213.usae.bah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All

I'm having some strange problems creating raid arrays on my RedHat 7.2
machine.  When I run mkraid to try and create a RAID-1 or RAID-5 device,
the the disks grind for about 2 seconds and then the mkraid process goes
into a D state and /proc/mdstat always looks something like this (with
and incrementing finish time).

[root@feedback root]# cat /proc/mdstat 
Personalities : [raid5] 
read_ahead not set
md0 : active raid5 hdg1[2] hdf1[1] hde1[0]
      156301184 blocks level 5, 4k chunk, algorithm 2 [3/3] [UUU]
      [>....................]  resync =  0.0% (128/78150592)
finish=303612.3min speed=0K/sec
unused devices: <none>

Here's the ps aux output

root       908  0.0  0.4  1432  524 tty1     D    10:01   0:00 mkraid
--really-force /dev/md0
root       910  0.0  0.0     0    0 ?        SW<  10:01   0:00 [raid5d]
root       911  0.0  0.0     0    0 ?        DWN  10:01   0:00
[raid5syncd]



The only way (that I've found) to recover is to do a cold boot.  It
doesn't appear that the process is oopsing, it looks like it's waiting
for something to happen.  Occasionally, I can perform a reboot -fn and
it will reboot.

I've tried the process with 2.4.9 and 2.4.18 RedHat kernels as well as
2.4.19-pre10.  The machine is currently sitting with mkraid in a D
state, so if there is anything that I can do to get more valuable
information for you let me know.  One note, is that the creation of a
RAID-0 device worked fined.  I'm totally stumped on this.  Below are my
/etc/raidtab and the system specs.

Thanks,

Scott

/etc/raidtab

raiddev /dev/md0
        raid-level              5
        nr-raid-disks           3
        nr-spare-disks          0
        persistent-superblock   1
        parity-algorithm        left-symmetric
        chunk-size              4
        device                  /dev/hde1
        raid-disk               0       
        device                  /dev/hdf1
        raid-disk               1       
        device                  /dev/hdg1
        raid-disk               2       


Here are the specs:

Kernel 2.4.19-pre10
modutils 2.4.14-3
raidtools 1.00.2-1.3
glibc 2.2.4-19-3
kernel-utils 2.4-7.4


Dual Proc Celeron MB (one 500 Mhz Processor installed)
128 MB RAM
2 Onboard PIIX4 IDE Controllers
2 Onboard HPT366 Controllers

0S Drives
/dev/hda  WDC AC22100H  2GB Drive
/dev/hdc  WDC AC38400L  8GB Drive

Candidate RAID drives:
/dev/hde  WDC WD800AB-60CBA0  80 GB Drive
/dev/hdf  WDC WD800AB-00CBA0  80 GB Drive
/dev/hdg  WDC WD800AB-00CBA0  80 GB Drive




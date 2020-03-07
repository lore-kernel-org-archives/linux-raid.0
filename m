From: Chris Green <cl@isbd.net>
Subject: Failed SBOD RAID on old NAS, how to diagnose/resurrect?
Date: Sat, 7 Mar 2020 21:58:11 +0000
Message-ID: <20200307215811.GA27305@esprimo>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an old (well, fairly old) WD NAS which has two 1Tb disk drives
configured to be one big disk drive using RAID.  It's been sat on the
shelf for two or three years at least so I was actually quite
pleasantly surprised when it booted.

However the RAID is broken, the second disk drive doesn't get added to
the RAID array.  The NAS's configuration GUI says that both physical
disk drives are healthy/ok but marks the second half of the single
RAID virtual disk as 'failed'.

I have ssh access to the NAS (and root) and I'm quite at home on the
Unix/Linux command line and doing sysadmin type things but I'm a total
newbie as regards RAID.

So how can I set about diagnosing and fixing this?  I can't even find
anything that tells me how the RAID is configured at the moment.  At
the most basic level 'mount' shows:-

    ~ # mount
    /dev/root on / type ext3 (rw,noatime,data=ordered)
    proc on /proc type proc (rw)
    sys on /sys type sysfs (rw)
    /dev/pts on /dev/pts type devpts (rw)
    securityfs on /sys/kernel/security type securityfs (rw)
    /dev/md3 on /var type ext3 (rw,noatime,data=ordered)
    /dev/md2 on /DataVolume type xfs (rw,noatime,uqnoenforce)
    /dev/ram0 on /mnt/ram type tmpfs (rw)
    /dev/md2 on /shares/Public type xfs (rw,noatime,uqnoenforce)
    /dev/md2 on /shares/Download type xfs (rw,noatime,uqnoenforce)
    /dev/md2 on /shares/chris type xfs (rw,noatime,uqnoenforce)
    /dev/md2 on /shares/laptop type xfs (rw,noatime,uqnoenforce)
    /dev/md2 on /shares/dps type xfs (rw,noatime,uqnoenforce)
    /dev/md2 on /shares/ben type xfs (rw,noatime,uqnoenforce)
    ~ # 

... and fdisk:-

    ~ # fdisk -l

    Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
    255 heads, 63 sectors/track, 121601 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

       Device Boot    Start       End    Blocks   Id  System
    /dev/sda1               5         248     1959930   fd  Linux raid autodetect
    /dev/sda2             249         280      257040   fd  Linux raid autodetect
    /dev/sda3             281         403      987997+  fd  Linux raid autodetect
    /dev/sda4             404      121601   973522935   fd  Linux raid autodetect

    Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
    255 heads, 63 sectors/track, 121601 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes

       Device Boot    Start       End    Blocks   Id  System
    /dev/sdb1               5         248     1959930   fd  Linux raid autodetect
    /dev/sdb2             249         280      257040   fd  Linux raid autodetect
    /dev/sdb3             281         403      987997+  fd  Linux raid autodetect
    /dev/sdb4             404      121601   973522935   fd  Linux raid autodetect


There should be a /dev/md4. :-

    /proc # more mdstat
    Personalities : [linear] [raid0] [raid1] 
    md2 : active raid1 sda4[0]
          973522816 blocks [2/1] [U_]
          
    md1 : active raid1 sdb2[1] sda2[0]
          256960 blocks [2/2] [UU]
          
    md3 : active raid1 sdb3[1] sda3[0]
          987904 blocks [2/2] [UU]
          
    md4 : active raid1 sdb4[0]
          973522816 blocks [2/1] [U_]
          
    md0 : active raid1 sdb1[1] sda1[0]
          1959808 blocks [2/2] [UU]
          
    unused devices: <none>



Oh, and the kernel is:-

    Linux WDbackup 2.6.24.4 #1 Thu Apr 1 16:43:58 CST 2010 armv5tejl unknown

-- 
Chris Green

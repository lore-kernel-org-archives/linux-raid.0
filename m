From: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Subject: Re: RAID 1 / Power Loss / No SuperBlock
Date: Sun, 2 Feb 2003 13:15:23 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <014f01c2cb00$375d5fe0$6701a8c0@bc.hsia.telus.net>
References: <Pine.LNX.4.33.0302021621110.17543-100000@router.windsormachine.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mike Dresser <mdresser_l@windsormachine.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike,

errors included:
cannot determine md version: No such file or directory
and
mount: wrong fs type, bad option, bad superblock on /dev/md2,
       or too many mounted file systems

/etc/raidtab

raiddev             /dev/md2
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdd1
    raid-disk     0
    device          /dev/hdb1
    raid-disk     1
raiddev             /dev/md1
raid-level                  1
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdd2
    raid-disk     0
    device          /dev/hdb2
    raid-disk     1
raiddev             /dev/md0
raid-level                  0
nr-raid-disks               2
chunk-size                  64k
persistent-superblock       1
nr-spare-disks              0
    device          /dev/hdd3
    raid-disk     0
    device          /dev/hdb3
    raid-disk     1




----- Original Message -----
From: "Mike Dresser" <mdresser_l@windsormachine.com>
To: "Adam J Morand" <Adam.Morand@midnightmoon.ca>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, February 02, 2003 1:21 PM
Subject: Re: RAID 1 / Power Loss / No SuperBlock


On Sun, 2 Feb 2003, Adam J Morand wrote:

> Mike,
>
> I could not get the md0 to resync / reinitialize
> raidstop / raidstart / etc...
>
> so I am unable to do fsck /dev/md0
> I was thinking if I could get one drive to work I could wipe the other
one,
> and then rebuild the pair, no??
>
> aj

Can you list your /etc/raidtab, and what errors you were getting?

mike


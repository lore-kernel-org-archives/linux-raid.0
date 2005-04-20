From: Santeri Stolt <santtu@penti.org>
Subject: Re: cannot write a new superblock
Date: Wed, 20 Apr 2005 19:56:41 +0300 (EEST)
Message-ID: <Pine.LNX.4.60.0504201915030.8999@penti.org>
References: <19839.212.101.18.92.1114002550.squirrel@212.101.18.92>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19839.212.101.18.92.1114002550.squirrel@212.101.18.92>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: romualdo@solnet.ch
List-Id: linux-raid.ids


Hello,

On Wed, 20 Apr 2005 romualdo@solnet.ch wrote:

> md: sda1 has invalid sb, not importing!

I have this problem as well. I am trying to put together a RAID5 array 
consisting of 6*120GB disks - 4*P-ATA and 2*S-ATA. The controller is a 
cheap Sil3112-based PCI thingy. I use the serial-ata driver which is part 
of the SCSI subsystem, because it is faster than its deprecated IDE-SATA 
predecessor.

Symptoms: I can build the array, everything looks fine during the 
resync, when resync finishes the array is usable. But during resync 
completion the superblocks on the S-ATA disks get mangled:

tupolev root # mdadm --examine  /dev/hd[egik]1 /dev/sd[ab]1|grep Checksum
        Checksum : 70dcd999 - correct
        Checksum : 70dcd99c - correct
        Checksum : 70dcd9b4 - correct
        Checksum : 70dcd9b7 - correct
        Checksum : 70dcd97c - expected 70dcd90c
        Checksum : 70dcd98e - expected 70dcd91e

The array works fine though, until it is restarted or a reboot occurs:

[dmesg output]
md: raidstart(pid 5781) used deprecated START_ARRAY ioctl. This will not 
be supported beyond 2.6
md: invalid superblock checksum on sda1
md: sda1 has invalid sb, not importing!
md: autostart failed!
md: md0 stopped.

I use up-to-date Gentoo, and I've tried combinations of the following:

Kernels:
2.6.10-gentoo-r1
2.6.11-gentoo-r6
2.6.12-rc3-mm3

raidtools & mdadm: latest stable Gentoo builds

Seems possible to me that something is broken in how raidtools/mdadm talk 
to the SCSI subsystem. IIRC, kernel ver. 2.6.8 inroduced a hefty bunch of 
restrictions for system calls, and that caused trouble for applications 
like growisofs. Maybe for mdadm/raidtools also? Just guessing here...

I am lost here, like you! If someone finds this problem interesting, I'd 
be more than happy to provide logs, info etc.

> I was reading through all the web, and I have only found questions but no
> answers about this problem

Yup, I've been tweaking on this for quite a while, too... any help is 
appreciated!

-- 
santtu@penti.org

From: "David Lethe" <david@santools.com>
Subject: RE: Determining filename from absolute sector failure in raid0
Date: Tue, 7 Oct 2008 09:29:32 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C022DB5A5@34093-C3-EVS3.exchange.rackspace.com>
References: <48EB6C22.9060302@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48EB6C22.9060302@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Bryce
> Sent: Tuesday, October 07, 2008 9:03 AM
> To: Linux RAID Mailing List
> Subject: Determining filename from absolute sector failure in raid0
> 
> 
> I have a raid0 comprised of 4x identical 300Gb drives
> 
> Disk /dev/hdf: 300.0 GB, 300001443840 bytes
> 255 heads, 63 sectors/track, 36473 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x0009f25f
> 
>    Device Boot      Start         End      Blocks   Id  System
> /dev/hdf1   *           1       36473   292969341   fd  Linux raid
> autodetect
> 
> md1 : active raid0 hdk1[0] hdg1[2] hdf1[1] hde1[3]
>       1171876864 blocks 256k chunks
> 
> hdf recently wobbled and the kernel  happily dumped out the following
> message (about 20 odd times)
> 
> hdf: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> hdf: dma_intr: error=0x40 { UncorrectableError }, LBAsect=216521307,
> high=12, low=15194715, sector=216521303
> ide: failed opcode was: unknown
> end_request: I/O error, dev hdf, sector 216521303
> 
> terrific.
> smartctl shows
>   5 Reallocated_Sector_Ct   0x0033   252   252   063    Pre-fail
> Always       -       16
> 196 Reallocated_Event_Count 0x0008   251   251   000    Old_age
> Offline      -       2
> 197 Current_Pending_Sector  0x0008   253   253   000    Old_age
> Offline      -       1
> 198 Offline_Uncorrectable   0x0008   252   252   000    Old_age
> Offline      -       1
> 
> so while a few sectors have been remapped the sector remapping table
is
> barely used, so I'm reasonably confident the disk is 'ok' in terms of
> normal operation
> Now my question about all this is how the hell do I determine what
file
> it was trying to access? (I just want to be sure that whatever file it
> was fiddling with isn't a steaming pile of poo now)
> 
> normally if it were a single disk it would be reasonably
> straightforward
> to work out what file was being used from debugfs: icheck <block>,
> ncheck  <inode from previews operation>
> the issue I have with raid0 is, exactly what block should I be
pointing
> debugfs at since the kernel has given an absolute address on a
physical
> disk and no logical information as to where in the FS it was at the
> time ?
> 
> tune2fs -l /dev/md1
> Block count:              292969216
> Block size:               4096
> 
> mdadm --examine /dev/hdf1
> /dev/hdf1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 2132d2e6:a2955ac2:6ad2f3dc:52b3dfd6
>   Creation Time : Wed May 26 18:34:06 2004
>      Raid Level : raid0
>   Used Dev Size : 292969216 (279.40 GiB 300.00 GB)
>    Raid Devices : 4
>   Total Devices : 4
> Preferred Minor : 1
> 
>     Update Time : Wed May 26 18:34:06 2004
>           State : active
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : bd5e5781 - correct
>          Events : 0.5
> 
>      Chunk Size : 256K
> 
>       Number   Major   Minor   RaidDevice State
> this     1      33       65        1      active sync   /dev/hdf1
> 
>    0     0      33        1        0      active sync   /dev/hde1
>    1     1      33       65        1      active sync   /dev/hdf1
>    2     2      34        1        2      active sync   /dev/hdg1
>    3     3      34       65        3      active sync             <---
> empty. bug? (expected /dev/hdk1)
> 
> mdadm --version
> mdadm - v2.6.2 - 21st May 2007
> 
> Would I be correct in assuming that I start my offset from hde1? do I
> need some other funky math to account for striping/blocking?
> 
> Or I could just say 'to hell with it' and listen to elevator music all
> day.
> 
> 
> Phil
> =--=
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------------------------------------------------------------------------
--------------------
What you need is a utility program that translates a physical device &
offset and converts that into a logical block in md0. Then
Something that maps a logical block in md0 to a file in a filesystem.

Unfortunately, I am not aware of any off-the-shelf utility to do this,
but put me down for being very interested in such a solution myself.
David



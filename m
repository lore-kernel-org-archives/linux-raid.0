From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Poor RAID5 performance on new SMP system
Date: Mon, 18 Oct 2004 01:12:27 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410180512.i9I5CWN14411@www.watkins-home.com>
References: <20041018035915.M10156@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041018035915.M10156@liquid-nexus.net>
To: 'Marc' <linux-raid@liquid-nexus.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Since you had one disk that performs badly.  I would swap disks, exchange
hdg and hdk if you can.  You can put them back after the test.  If that
would prevent you from booting, boot from a knoppix CD.  Then test the
disks.

You may have a bad disk, cable or card.  Swap until you determine which it
is.

Label the disks!!!  It is easy to get confused about which is which!

Guy

-----Original Message-----
From: Marc [mailto:linux-raid@liquid-nexus.net] 
Sent: Monday, October 18, 2004 12:05 AM
To: Guy; linux-raid@vger.kernel.org
Subject: RE: Poor RAID5 performance on new SMP system

So much for my 'upgrade'! :(

I suspect some kind of hardware problem here... :( As a quick check I did 
the following tests:

hdparm -t /dev/hde - 38MB/sec
hdparm -t /dev/hdg - 9MB/sec (and it fluctates wildly)
hdparm -t /dev/hdi - 50MB/sec
hdparm -t /dev/hdk - 45MB/sec

/dev/hdg doesnt look too healthy - is there any way to check if there are 
IDE errors - say related to cabling etc? I might just swap this cable out 
and try again. 

--


---------- Original Message -----------
From: "Guy" <bugzilla@watkins-home.com>
To: "'Marc'" <linux-raid@liquid-nexus.net>, <linux-raid@vger.kernel.org>
Sent: Sun, 17 Oct 2004 23:37:49 -0400
Subject: RE: Poor RAID5 performance on new SMP system

> I have a P3-500 SMP system.  It performs better than your SMP 
> system.  So I don't think SMP is the issue.  This is a SCSI system 
> with 3 SCSI buses and 14 disks.
> 
> Version  1.03    ------Sequential Output------ --Sequential Input- --
> Random-                 -Per Chr- --Block-- -Rewrite- -Per Chr- -
> -Block-- --Seeks-- Machine     Size K/sec %CP K/sec %CP K/sec %CP 
> K/sec %CP K/sec %CP  /sec %CP watkins-home. 1G  3403  98 35480  86 
> 22074  47  3589  99 68735  63 512.6  11
> 
> Guy
> 
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Marc
> Sent: Sunday, October 17, 2004 10:12 PM
> To: linux-raid@vger.kernel.org
> Subject: Poor RAID5 performance on new SMP system
> 
> Hi,
> I recently upgraded my file server to a dual AMD 2800+ on a Tyan 
> Tiger MPX motherboard. The previous server was using a PIII 700 on 
> an Intel 440BX motherboard. I basically just took the IDE drives and 
> their controllers across to the new machine. The strange thing is 
> that the RAID-5 performance is worse than before! Have a look at the 
> stats below:
> 
> I've fiddled with hdparm making sure the drives are setup correctly 
> (dma,32bit,unmaskirq) but without much improvement.
> 
> As a comparison I ran the same benchmark against the -single- (root) 
> drive /dev/hda and it performed better than the raid array!!
> 
> I'm using kernel version 2.4.26 SMP. Do you think upgrading to 2.6.8 
> would improve matters?
> 
> The only guess I can make is that there is an issue with software 
> raid performance on an SMP system.
> 
> Any help/suggestions appreciated!
> 
> Thanks...
> 
> ----------------------------------------------------------
> Bonnie++ benchmarks:
> 
> Before (PIII 700/440BX):
> 
> 128k chunk
>               -------Sequential Output-------- ---Sequential Input-- --
> Random--
>               -Per Char- --Block--- -Rewrite-- -Per Char- --Block---
> --Seeks-
> --
> Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU 
>  /sec % CPU         1000  7594 85.1 36234 43.0 22728 31.1  8812 96.1 
> 58155 52.5 286.8  
> 5.6
> 
> After: (Dual AMD MP 2800+/Tiger MPX(AMD760)
> 
>               -------Sequential Output-------- ---Sequential Input-- --
> Random--
>               -Per Char- --Block--- -Rewrite-- -Per Char- --Block---
> --Seeks-
> --
> Machine    MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU 
>  /sec % CPU         1000 16707 97.7 20745 16.4  9633  9.8 17032 67.2 
> 24741 11.4 194.8  
> 2.1
> 
> /dev/md0:
>         Version : 00.90.00
>   Creation Time : Sat Apr 17 12:19:25 2004
>      Raid Level : raid5
>      Array Size : 234444288 (223.58 GiB 240.07 GB)
>     Device Size : 78148096 (74.53 GiB 80.02 GB)
>    Raid Devices : 4
>   Total Devices : 5
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Mon Oct 18 08:36:52 2004
>           State : dirty, no-errors
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>     Number   Major   Minor   RaidDevice State
>        0      33        1        0      active sync   /dev/hde1
>        1      34        1        1      active sync   /dev/hdg1
>        2      56        1        2      active sync   /dev/hdi1
>        3      57        1        3      active sync   /dev/hdk1
>            UUID : 775f1dcf:7cbc17ab:86e1e792:669b732f
>          Events : 0.82
> 
> lspci:
> 
> 0000:00:00.0 Host bridge: Advanced Micro Devices [AMD] AMD-760 MP 
> [IGD4-2P] System Controller (rev 20)
> 0000:00:01.0 PCI bridge: Advanced Micro Devices [AMD] AMD-760 MP 
> [IGD4-2P] AGP Bridge
> 0000:00:07.0 ISA bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] 
> ISA 
> (rev 05)
> 0000:00:07.1 IDE interface: Advanced Micro Devices [AMD] AMD-768 
> [Opus] IDE 
> (rev 04)
> 0000:00:07.3 Bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] 
> ACPI (rev 03)
> 0000:00:10.0 PCI bridge: Advanced Micro Devices [AMD] AMD-768 [Opus] 
> PCI 
> (rev 05)
> 0000:02:00.0 USB Controller: Advanced Micro Devices [AMD] AMD-768 
> [Opus] USB
> 
> (rev 07)
> 
> 0000:02:04.0 VGA compatible controller: NVidia / SGS Thomson (Joint 
> Venture)
> 
> Riva128 (rev 10)
> 0000:02:05.0 RAID bus controller: Silicon Image, Inc. (formerly CMD 
> Technology Inc) PCI0680 Ultra ATA-133 Host Controller (rev 02)
> 0000:02:06.0 RAID bus controller: Silicon Image, Inc. (formerly CMD 
> Technology Inc) PCI0649 (rev 02)
> 
> 0000:02:07.0 FireWire (IEEE 1394): Texas Instruments TSB12LV23 IEEE-
> 1394 Controller
> 0000:02:08.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M 
> [Tornado] 
> (rev 78)
> 
> --
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-
> raid" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------


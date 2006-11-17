From: "Timo Bernack" <timo.bernack@bernack.de>
Subject: raidreconf for 5 x 320GB -> 8 x 320GB
Date: Fri, 17 Nov 2006 16:33:51 +0100
Message-ID: <003301c70a5d$c8d1d6e0$0200a8c0@turalyon>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there,

i am running a 5-disk RAID5 using mdadm on a suse 10.1 system. As the array 
is running out of space, i consider adding three more HDDs. Before i set up 
the current array, i made a small test with raidreconf:

- build a 4-disk RAID5 /dev/md0 (with only 1.5gb for each partition) with 
4.5gb userspace in total
- put an ext3 filesystem on it
- copy some data to it -- some episodes of "American Dad" ;-)
- use raidreconf to add a 5th disk
- use resize2fs to make use of the new additional space
- check for the video-clips.. all fine (also compared checksums)

This test was a full success, but of course it was very small scaled, so 
maybe there are issues that only come up when there is (much) more space 
involved. That leads to my questions:

What are potential sources for failures (and thus, losing all data) 
reconfiguring the array using the method described above? Loss of power 
during the process (which would take quite some time, 24 hours minimum, i 
think) is one of them, i suppose. But are there known issues with 
raidreconf, concerning the 2TB-barrier, for example?

I know that raidreconf is quite outdated, but it did what it promised on my 
system. I heard of the possibility to achieve the same result just by using 
mdadm, but this required a newer version of mdadm, and upgrading it and 
using a method that i can't test beforehand scares me a little -- a little 
more than letting out raidreconf on my precious data does ;-).

All comments will be greatly appreciated!


Timo

P.S.:
I do have a backup, but since it is scattered to a huge stack of CDs / DVDs 
(about 660 disks) it would be a terrible pain-in-the-ass to be forced to 
restore it again. In fact, getting away from storing my data using a 
DVD-burner was the main reason to build up the array at all. It took me 
about 1 week (!) to copy all these disks, as you can easily imagine.

-----
Hardware:
- Board / CPU: ASUS M2NPV-VM (4 x S-ATA onboard) / AMD Sempron 3200+ AM2
- Add. S-ATA-Controller: Promise SATA300 TX4
- HDDs: 5 x Western Digital Caviar SE 320GB SATA II (WD3200JS)

Software (OpenSUSE 10.1 Default-Installation):
- Kernel: 2.6.16
- mdadm - v2.2 - 5 December 2005 


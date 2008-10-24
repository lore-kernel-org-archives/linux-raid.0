From: "Steve Evans" <jeeping@gmail.com>
Subject: Re: mdadm degraded RAID5 failure
Date: Fri, 24 Oct 2008 12:47:34 -0600
Message-ID: <6cc8e9ed0810241147t64682264n7d6fafde032499f3@mail.gmail.com>
References: <6cc8e9ed0810221350o2b8b3aedm3d1c229fe7e66163@mail.gmail.com>
	 <6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6cc8e9ed0810221352y7427cb7dmfc7c3fcefd495bb9@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

So it would appear the drive number has been remapped somehow on
/dev/sdb1 to be 3 instead of 0? Is there a way to reset/set these to
specific values?

3 8 17 - spare /dev/sdb1

Thanks
Steve..

On Wed, Oct 22, 2008 at 2:52 PM, Steve Evans <jeeping@gmail.com> wrote:
>
> Hi all..
>
> I had one of the disks in my 3 disk RAID5 die on me this week. When
> attempting to replace the disk via a hot swap (USB), the RAID didn't
> like it. It decided to mark one of my remaining 2 disks as faulty.
>
> Can someone *please* help me get the raid back!?
>
> More details -
>
> Drives are /dev/sdb1, /dev/sdc1 & /dev/sdd1
>
> sdc1 was the one that died earlier this week
> sdb1 appears to be the one that was marked as faulty
>
> mdadm detail before sdc1 was plugged in -
>
> root@imp[~]:11 # mdadm --detail /dev/md1
> /dev/md1:
> Version : 00.90.01
> Creation Time : Fri Nov 17 21:28:44 2006
> Raid Level : raid5
> Array Size : 586067072 (558.92 GiB 600.13 GB)
> Device Size : 293033536 (279.46 GiB 300.07 GB)
> Raid Devices : 3
> Total Devices : 2
> Preferred Minor : 1
> Persistence : Superblock is persistent
>
> Update Time : Sat Oct 18 20:06:34 2008
> State : clean, degraded
> Active Devices : 2
> Working Devices : 2
> Failed Devices : 0
> Spare Devices : 0
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> UUID : bed40ee2:98523fdd:e4d010fb:894c0966
> Events : 0.1474312
>
> Number Major Minor RaidDevice State
> 0 8 17 0 active sync /dev/sdb1
> 1 0 0 - removed
> 2 8 49 2 active sync /dev/sdd1
>
>
> then after plugging in the replacement sdc1 -
>
> root@imp[~]:13 # mdadm --add /dev/md1 /dev/sdc1
> mdadm: hot added /dev/sdc1
> root@imp[~]:14 #
> root@imp[~]:14 #
> root@imp[~]:14 # mdadm --detail /dev/md1
> /dev/md1:
> Version : 00.90.01
> Creation Time : Fri Nov 17 21:28:44 2006
> Raid Level : raid5
> Array Size : 586067072 (558.92 GiB 600.13 GB)
> Device Size : 293033536 (279.46 GiB 300.07 GB)
> Raid Devices : 3
> Total Devices : 3
> Preferred Minor : 1
> Persistence : Superblock is persistent
>
> Update Time : Sat Oct 18 22:13:13 2008
> State : clean, degraded
> Active Devices : 1
> Working Devices : 2
> Failed Devices : 1
> Spare Devices : 1
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> UUID : bed40ee2:98523fdd:e4d010fb:894c0966
> Events : 0.1480366
>
> Number Major Minor RaidDevice State
> 0 0 0 - removed
> 1 0 0 - removed
> 2 8 49 2 active sync /dev/sdd1
>
> 3 8 33 0 spare rebuilding /dev/sdc1
> 4 8 17 - faulty /dev/sdb1
>
> Shortly after this, subsequent mdadm --details stopped responding.. So
> I rebooted in the hope I could reset and problems with the hot add..
>
> Now, I'm unable to assemble the raid with the 2 working drives -
>
> mdadm --assemble /dev/md1 /dev/sdb1 /dev/sdd1
>
> doesn't work -
>
> mdadm: /dev/md1 assembled from 1 drive and 1 spare - not enough to
> start the array.
>
> mdadm --assemble --force /dev/md1 /dev/sdb1 /dev/sdd1
>
> doesn't' work either
>
> This -
>
> mdadm --assemble --force --run /dev/md1 /dev/sdb1 /dev/sdd1
>
> Did work partially -
>
> /dev/md1:
> Version : 00.90.01
> Creation Time : Fri Nov 17 21:28:44 2006
> Raid Level : raid5
> Device Size : 293033536 (279.46 GiB 300.07 GB)
> Raid Devices : 3
> Total Devices : 2
> Preferred Minor : 1
> Persistence : Superblock is persistent
>
> Update Time : Sat Oct 18 22:14:48 2008
> State : active, degraded
> Active Devices : 1
> Working Devices : 2
> Failed Devices : 0
> Spare Devices : 1
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> UUID : bed40ee2:98523fdd:e4d010fb:894c0966
> Events : 0.1521614
>
> Number Major Minor RaidDevice State
> 0 0 0 - removed
> 1 0 0 - removed
> 2 8 49 2 active sync /dev/sdd1
>
> 3 8 17 - spare /dev/sdb1
>
> Here's the output from mdadm -E on each of the 2 drives -
>
> /dev/sdb1:
> Magic : a92b4efc
> Version : 00.90.00
> UUID : bed40ee2:98523fdd:e4d010fb:894c0966
> Creation Time : Fri Nov 17 21:28:44 2006
> Raid Level : raid5
> Raid Devices : 3
> Total Devices : 3
> Preferred Minor : 1
>
> Update Time : Sat Oct 18 22:14:48 2008
> State : clean
> Active Devices : 1
> Working Devices : 2
> Failed Devices : 2
> Spare Devices : 1
> Checksum : e6dbf75 - correct
> Events : 0.1521614
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> Number Major Minor RaidDevice State
> this 3 8 33 3 spare /dev/sdc1
>
> 0 0 0 0 0 removed
> 1 1 0 0 1 faulty removed
> 2 2 8 49 2 active sync /dev/sdd1
> 3 3 8 33 3 spare /dev/sdc1
> /dev/sdd1:
> Magic : a92b4efc
> Version : 00.90.00
> UUID : bed40ee2:98523fdd:e4d010fb:894c0966
> Creation Time : Fri Nov 17 21:28:44 2006
> Raid Level : raid5
> Raid Devices : 3
> Total Devices : 3
> Preferred Minor : 1
>
> Update Time : Sat Oct 18 22:14:48 2008
> State : clean
> Active Devices : 1
> Working Devices : 2
> Failed Devices : 2
> Spare Devices : 1
> Checksum : e6dbf86 - correct
> Events : 0.1521614
>
> Layout : left-symmetric
> Chunk Size : 64K
>
> Number Major Minor RaidDevice State
> this 2 8 49 2 active sync /dev/sdd1
>
> 0 0 0 0 0 removed
> 1 1 0 0 1 faulty removed
> 2 2 8 49 2 active sync /dev/sdd1
> 3 3 8 33 0 spare /dev/sdc1
>
> root@imp[~]:28 # mdadm --version
> mdadm - v1.9.0 - 04 February 2005
> root@imp[~]:29 # uname -a
> Linux imp 2.6.8-3-686 #1 Tue Dec 5 21:26:38 UTC 2006 i686 GNU/Linux
>
>
> Is all the data lost, or can I recover from this?
>
> Thanks so much!
> Steve..

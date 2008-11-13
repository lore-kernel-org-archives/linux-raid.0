From: Michal Soltys <soltys@ziu.info>
Subject: Re: partitionable md partition size caps at 0.4TB
Date: Thu, 13 Nov 2008 14:12:39 +0100
Message-ID: <491C27C7.2040400@ziu.info>
References: <alpine.DEB.2.00.0811131350410.20263@kurp.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0811131350410.20263@kurp.hut.fi>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Wagner <jwagner@kurp.hut.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jan Wagner wrote:
> Hello,
> 
> is it possible to create md partitions larger than 0.4TB?
> 
> We have >=9TB RAID-0 systems, and I tried to create a partitionable 
> two-partition md with mdadm --auto=mdp2 and partition it into for 
> example 16MB and ~9TB. For partitioning /dev/md_d0 I have tried sfdisk, 
> fdisk, cfdisk, parted, ... Regardless of the partitioning tool, the ~9TB 
> partition always ends up as 455780.07MB i.e. 0.4TB.
> 
> There is no problem to create a large 9TB single partition on a 
> non-partitionable /dev/md0. Is the 445097720 blocks (0.4TB) "cropping" a 
> bug or a real limitation with mdp partitionable raid?
> 

I'm assuming you tried standard MBR layout - you can't go above ~ 2TB 
limit with it - you need either GPT, or use the device directly (as in 
md0 case). I have one 1.5TB partition running happily on one of my 
systems (still within limits of old MBR layout, but under GPT).

The old md superblock format you used has no such limitation (there're 
others though - maximum 28 components, and 2TB/component). It's really 
better to use one of the 1.x superblocks - check out mdadm's -e option.

If you plan to boot up from a GPT partition on a "legacy" system, you 
will need either syslinux/extlinux or patched grub (and possibly others 
- such as grub2). Not your case as far as I can see, but keep that in 
mind just in case.

- do you have any problems with creating a partition with size of let's 
say 1.8TB and within the first 2TB ?

- check if parted have any problems with creating GPT layout using sizes 
you require (and make sure your kernel is compiled with GPT support).



For a reference, one of my systems:

13:32 > mdadm -D /dev/md/d0p2
/dev/md/d0p2:
         Version : 01.00.03
   Creation Time : Sat Jul 28 12:44:34 2007
      Raid Level : raid5
      Array Size : 1438617600 (1371.97 GiB 1473.14 GB)
   Used Dev Size : 976060928 (465.42 GiB 499.74 GB)
    Raid Devices : 4
   Total Devices : 5
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Nov 13 13:32:41 2008
           State : clean
  Active Devices : 4
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            Name : d0
            UUID : acf9b8b0:95ba6218:bc4f9bff:67a1fe93
          Events : 2814

     Number   Major   Minor   RaidDevice State
        0       8        3        0      active sync   /dev/sda3
        1       8       19        1      active sync   /dev/sdb3
        2       8       35        2      active sync   /dev/sdc3
        4       8       51        3      active sync   /dev/sdd3

        5       8       67        -      spare   /dev/sde3

13:53 > parted /dev/md/d0
GNU Parted 1.8.8
Using /dev/md/d0
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: Unknown (unknown)
Disk /dev/md/d0: 1499GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt

Number  Start   End     Size    File system  Name  Flags
  1      17.4kB  25.8GB  25.8GB
  2      25.9GB  1499GB  1473GB  xfs


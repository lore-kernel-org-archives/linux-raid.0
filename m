From: Aaron Longfield <aaron@wire-head.org>
Subject: RESOLVED Re: Partitioning on RAID (Ref: Mounting Promise RAID0 w/
 Linux software RAID)
Date: Fri, 02 Jul 2004 04:04:50 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40E51722.2040306@wire-head.org>
References: <Pine.GSO.4.33.0407011230500.25702-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0407011230500.25702-100000@sweetums.bluetronic.net>
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks a bunch, piecing together what you told me, a bit of a few 
messages that I found from the mailing list a long while ago, and Neil's 
old patches, I think I have it working!

The trick seemed to be using mdadm to bring the array up:

mdadm -B /dev/md/d0 /dev/hdc /dev/hdd --level=raid0 --raid-devices=2

The node for the d0p1 block device was not auto-created even though I 
have devfs, but after creating one for "254,1", I was able to mount the 
partition.

This is wonderful, and hopefully I can get small bit of info in the RAID 
FAQ or HOWTO about it.  I didn't see anywhere a reference to being able 
to start a Promise Fasttrak array with just the Linux RAID code. :)

-Aaron Longfield

Ricky Beam wrote:
> On Thu, 1 Jul 2004, Aaron Longfield wrote:
> 
>>properly.  Problem is that now I have an array that has a partition
>>table and a partition that I can't seem to mount.  Is there any way to
>>coax the system into letting me do this?  I couldn't find any
>>documentation on it, but there seems to be support in the kernel code
>>for the md driver.
> 
> 
> It actually is documented... Documentation/md.txt.  The "magic" is the
> raid device's major number:
> 	[root:pts/8]spork:~/[12:36 PM]:cat /proc/devices |grep 'md\|Block'
> 	Block devices:
>   	9 md
> 	254 mdp
> 
> "mdp" is dynamically allocated, so booting to a partitioned soft-raid is
> tricky, but certainly do able.
> 
> Simply change your raid device from /dev/md0 (which is major #9) to something
> with a major number matching mdp.  In my case:
> 	[root:pts/8]spork:~/[12:36 PM]:ls -l /dev/md0
> 	brw-rw----  1 root disk 9, 0 Feb 23 16:04 /dev/md0
> 	[root:pts/8]spork:~/[12:38 PM]:ls -l /dev/md
> 	total 0
> 	brw-r--r--  1 root root 254, 0 Jun  9 21:04 d0
> 	brw-r--r--  1 root root 254, 1 Jun  9 21:04 d0p1
> 	brw-r--r--  1 root root 254, 2 Jun  9 21:04 d0p2
> 	brw-rw----  1 root disk 254, 3 Jun 17 15:09 d0p3
> 
> 	[root:pts/8]spork:~/[12:38 PM]:fdisk -l /dev/md/d0
> 
> 	Disk /dev/md/d0: 640.1 GB, 640167510016 bytes
> 	255 heads, 63 sectors/track, 77829 cylinders
> 	Units = cylinders of 16065 * 512 = 8225280 bytes
> 
> 	      Device Boot      Start         End      Blocks   Id  System
> 	/dev/md/d0p1               1       72606   583207663+   7  HPFS/NTFS
> 	/dev/md/d0p2   *       72607       77306    37752750   83  Linux
> 	/dev/md/d0p3           77307       77828     4192965   82  Linux swap
> 
> --Ricky
> 
> PS: The above naming scheme requires a small patch to grub to make it name
> the partitions correctly.  By default, it'll look for /dev/md/d01, etc.

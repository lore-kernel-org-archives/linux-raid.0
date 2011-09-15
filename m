From: Robert L Mathews <lists@tigertech.com>
Subject: Re: Bootable Raid-1
Date: Thu, 15 Sep 2011 12:33:45 -0700
Message-ID: <4E725319.7080809@tigertech.com>
References: <AANLkTikBM=BQ7Q3W7zX5o59i9DzDgqHMQvnxQoeXip6M@mail.gmail.com> <60.01.07087.808994D4@cdptpa-omtalb.mail.rr.com> <976829848.20110909125901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <976829848.20110909125901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> RAID1 under GRUB legacy takes some finagling.  Under GRUB2 it
>> should be straightforward as long as the partitioning is correct and one
>> employs a 0.90 superblock for the /boot array.

I'm using three-disk RAID-1 arrays ("it's not paranoia when they really 
are out to get you") with Debian squeeze and grub-pc.

My strategy:

  * Use version 1.0 metadata (0.9 is also okay; 1.1 and 1.2 aren't
    because the partition no longer looks identical to a non-RAID
    partition as far as grub is concerned).
  * Have a small (512 MB) separate ext3 /boot partition.
  * Wait until the new /boot partition fully syncs before messing
    with the MBR on the additional disks.
  * After it syncs, add the grub record to the other two disks with
    "grub-install /dev/sdb" and "grub-install /dev/sdc".

This definitely works correctly in that I can remove any one or two of 
the disks and it boots properly with the RAID degraded, just as it should.

What I haven't been able to fully test is how it copes with one of the 
disks being present but non-working. For example, a potential problem is 
that the MBR on /dev/sda is readable, but the /dev/sda1 "/boot" 
partition is not readable due to sector read errors. I assume that in 
that case, the boot will fail. Our disaster plan to deal with that 
situation is to physically pull /dev/sda out of the machine.

As an aside, using "grub-install" on the additional disks is much 
simpler than what I used to do under grub-legacy, which was something like:

  # grub
  grub> device (hd0) /dev/sdb
  grub> root (hd0,0)
  grub> setup (hd0)

The reason I did that for years instead of using "grub-install" was due 
to a belief that the "grub-install" method somehow made grub always rely 
on the original, physical /dev/sda drive even if it booted from the MBR 
of a different one. I'm not sure if this was ever true, but if it was, 
it doesn't seem to be true any more, at least on the hardware I'm using. 
Perhaps the fact that grub-pc now recognizes the /boot partition by file 
system UUID (which is the same across all members of the array) helps it 
find any of them that are working.


 > Guys, basing on your experience, can you tell us, how does Grub2 react
 > on degraded raid? Does it respect md's point of view which disk is bad
 > and which is not? Does it cooperate well with mdadm in general?

Keep in mind that grub is booting the system before the RAID array 
starts. It wouldn't know anything about arrays (degraded or otherwise) 
at boot time. It simply picks a single disk partition to start using the 
files from. This is why booting from RAID only works with RAID 1, where 
the RAIDed partitions can appear identical to non-RAID partitions.

For that reason, you want the metadata to be either 0.90 or 1.0 so that 
the partition looks like a normal, non-RAID ext3 /boot partition to grub 
(the beginning of the partition is the same). Your goal is to  make sure 
that your system would be bootable even if you didn't assemble the RAID 
array. That's possible because the file system UUIDs listed in the 
/boot/grub/grub.cfg file will match the file system UUIDs shown on the 
raw, non-mdadm output of "dumpe2fs /dev/sda1", etc.

For example, on one of my servers, grub.cfg contains:

  search --no-floppy --fs-uuid --set 0fa13d65-7e83-4e87-a348-52f77a51b3d5

And that UUID is the same one I see from:

  dumpe2fs /dev/sda1 | grep UUID
  Filesystem UUID:          0fa13d65-7e83-4e87-a348-52f77a51b3d5

  dumpe2fs /dev/sdb1 | grep UUID
  Filesystem UUID:          0fa13d65-7e83-4e87-a348-52f77a51b3d5

  dumpe2fs /dev/sdc1 | grep UUID
  Filesystem UUID:          0fa13d65-7e83-4e87-a348-52f77a51b3d5

Of course, mdadm was the magical thing that originally made an identical 
file system exist on all three of those partitions, but the point is 
that grub doesn't know or care about that: it simply searches for the 
matching UUID of the file system, finds it on a single one of the 
physical disks, and uses it without any RAID/mdadm stuff being involved 
at all. It wouldn't know if it had somehow found a degraded copy -- 
hence my philosophy of "if /dev/sda is messed up, it's better to just 
pull it out and rely on grub RAID 1 booting from a different physical disk".

-- 
Robert L Mathews, Tiger Technologies, http://www.tigertech.net/

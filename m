From: Chris Murphy <lists@colorremedies.com>
Subject: Re: restore 3disk raid5 after raidpartitions have been setup with xfs
 filesystem by accident
Date: Wed, 21 Sep 2016 09:38:39 -0600
Message-ID: <CAJCQCtR4NoCebcDLD-ovT+hZY=NKRtj1cP693wHQTbmiERDAXw@mail.gmail.com>
References: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKA=zHqbFv_RQvyR4o4HPS2UrP4xrRWLiy2nR+gudDguk+JLog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Becks <beckssimon5@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 21, 2016 at 4:39 AM, Simon Becks <beckssimon5@gmail.com> wrote:
> Dear Developers & Gurus & Gods,
>
> i had a 3 disk software raid 5 (mdadm) on a buffalo terrastation. By
> accident I reset the raid and the NAS put on a xfs filesystem on each
> of the 3 partitions.
>
> sda6 sdb6 and sdc6 have been the raid5 member partitions.
>
> Now sda6 sdb6 and sdc6 only contain a xfs filesystem with some empty
> default folder structure - my NAS created during the "reset".

OK that doesn't really make sense, if it's going to do a reset I'd
expect it to format all the other partitions and even repartition
those drives. Why does it format just the sixth partition on these
three drives? The point is, you need to make sure this "new" sda6 is
really exactly the same as the old one. As in, the same start and end
sector values. If this is a different partition scheme on any of the
drives, you have to fix that problem first.


>
> mdadm --examine /dev/sda6
> mdadm: No md superblock detected on /dev/sda6
> mdadm --examine /dev/sdb6
> mdadm: No md superblock detected on /dev/sdb6
> mdadm --examine /dev/sdc6
> mdadm: No md superblock detected on /dev/sdc6

mkfs.xfs doesn't write that much metadata but it does write a lot of
zeros, about 60MB of writes per mkfs depending on how many AG's are
created. So no matter what the resulting array is going to have about
200MB of data loss spread around. It's hard to say what that will have
stepped on, if you're lucky it'll be only data. If you're unluckly it
will have hit the file system in a way that'll make it difficult to
extract your data.

So no matter what, this is now a scraping operation. And that will
take some iteration. Invariably it will take less time to just create
a new array and restore from backup. If you don't have a backup for
this data, then it's not important data. Either way, it's not worth
your time.

However...

To make it possible to iterate mdadm metadata version, and chunk size,
and device order without more damage, you need to work on files of
these partitions, or use an overlay.
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file

The overlay file option is better because you can iterate and throw
them away and quickly start again. If you dd the partitions to files,
and you directly change those files, to start over you have to dd
those partitions yet again. So you're probably going to want the
overlay option no matter what.

Each iteration will produce an assembled array, but only one
combination will produce an array that's your array. And even that
array might not be mountable due to mkfs damage. So you'll need some
tests to find out whether you have a file system on that array or if
it's just garbage.  fsck -n *might* recognize the filesystem even if
it's badly damaged, and tell you how badly damaged it is, without
trying to fix it. You're almost certainly best off not fixing it for
starters, and just mounting it read only and getting off as much data
as you can elsewhere. i.e. making the backup you should already have.





>
> Disk /dev/sdc: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: gpt
> Disk identifier: FAB30D96-11C4-477E-ADAA-9448A087E124
>
> Device        Start        End    Sectors   Size Type
> /dev/sdc1      2048    2002943    2000896   977M Microsoft basic data
> /dev/sdc2   2002944   12003327   10000384   4.8G Microsoft basic data
> /dev/sdc3  12003328   12005375       2048     1M Microsoft basic data
> /dev/sdc4  12005376   12007423       2048     1M Microsoft basic data
> /dev/sdc5  12007424   14008319    2000896   977M Microsoft basic data
> /dev/sdc6  14008320 1937508319 1923500000 917.2G Microsoft basic data
>
> XFS-Log attached for reference.
>
> Am I screwed or is there a chance to recreate the raid with the 3
> disks end up with the raid and the filesystem i had before?

It's pretty unlikely you'll totally avoid data loss, it's just matter
of what damage has happened and that's not knowable in advance. You'll
just have to try it out.

If the file system can't be mounted ro; if the fsck can't make it
"good enough" to mount ro; then you will want to take a look at
testdisk which can scrape the array (not the individual drives) for
file signatures. So long as the files are in contiguous blocks, it can
enable you to scrape off things like photos and documents. Smaller
files tend to recover better than big files.

If that also fails, well yeah you can try test disk pointed at
individual partitions or the whole drives and see what it finds. If
the chunk size is 512KiB that sorta improves the chances you'll get
some files but they'll definitely only be small files that'll be
recognized. Any file broken up by raid striping will be on some other
drive. So it's a huge jigsaw puzzle, which is why raid is not a
backup, etc.


-- 
Chris Murphy

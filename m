From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Assembling array with missing members
Date: Mon, 01 Aug 2011 10:37:06 +0100
Message-ID: <4E3673C2.7070607@anonymous.org.uk>
References: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com> <CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/08/2011 05:51, Alex wrote:
> Hi,
> I have an old fedora server with a raid1 and raid5 array comprised of
> four disks. One of the disks just died, and in the process of trying
> to replace the disk, the server will for some reason no longer boot. I
> think it was a problem with my initrd. I've since replaced the
> defective disk (sdd) with a new one and created the fd partitions the
> same size as they were originally.

The usual way to do this is
   sfdisk -d /dev/originaldevice | sfdisk /dev/newdevice

But I usually do it as follows, to copy the rest of the boot sector and 
grub stuff:
   dd if=/dev/originaldevice of=/dev/newdevice bs=512 count=63
   blockdev --rereadpt /dev/newdevice

(If the original partitions started at 1MB instead of the second 
cylinder, it would have been count=2048 above.)

In both cases, originaldevice is a still-existing original RAID member disc.

> Booting from a current rescue CDROM
> and trying to use mdadm to reassmble the raid5 array, and I'm having a
> problem:
>
> % mdadm --assemble --auto=yes  /dev/md1 /dev/sd[abcd]2
> mdadm: no RAID superblock on /dev/sdd2
> mdadm: /dev/sdd2 has no superblock - assembly aborted

That's right, you shouldn't have asked it to include sdd2 as it doesn't 
yet have a RAID superblock on it.

[...]
> I'm really not sure what to do next and obviously would like to do
> everything possible to save the array.
>
> How can I either have mdadm rebuild the array using the new disk or
> start in degraded mode so I can rescue the data? Perhaps there's
> another option?

Assemble it without sdd2 which currently has no superblock, then add the 
new drive:

mdadm --stop /dev/md1
mdadm --assemble /dev/md1 --auto=yes /dev/sd[abc]2
mdadm --manage /dev/md1 --add /dev/sdd2

This will start the rebuild process and after a while (with 1TB drives, 
maybe a day) and assuming the rebuild goes well, you'll be fully 
operational again.

I imagine you will also want to add sdd1 to md0 in a similar manner.

Cheers,

John.


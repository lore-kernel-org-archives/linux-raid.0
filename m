From: Alex <mysqlstudent@gmail.com>
Subject: Re: Assembling array with missing members
Date: Mon, 1 Aug 2011 07:12:12 -0400
Message-ID: <CAB1R3siEvHsK9nYUpbe7_Z8B08cvXVX=xd-w0BVybsrO6NojBQ@mail.gmail.com>
References: <CAB1R3siG=FOXXq5kRx5N8O7ExCiM=0ic0xakYpfKZH1FOROXoQ@mail.gmail.com>
	<CAB1R3sjuUEVAPLgGNdnwnyHVir3bEGOT9iOSdYBz+QSs+2fhaA@mail.gmail.com>
	<4E3673C2.7070607@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3673C2.7070607@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

>> I have an old fedora server with a raid1 and raid5 array comprised o=
f
>> four disks. One of the disks just died, and in the process of trying
>> to replace the disk, the server will for some reason no longer boot.=
 I
>> think it was a problem with my initrd. I've since replaced the
>> defective disk (sdd) with a new one and created the fd partitions th=
e
>> same size as they were originally.
>
> The usual way to do this is
> =A0sfdisk -d /dev/originaldevice | sfdisk /dev/newdevice
>
> But I usually do it as follows, to copy the rest of the boot sector a=
nd grub
> stuff:
> =A0dd if=3D/dev/originaldevice of=3D/dev/newdevice bs=3D512 count=3D6=
3
> =A0blockdev --rereadpt /dev/newdevice
>
> (If the original partitions started at 1MB instead of the second cyli=
nder,
> it would have been count=3D2048 above.)
>
> In both cases, originaldevice is a still-existing original RAID membe=
r disc.

Should I do this in lieu of a rebuild, or in addition to the rebuild
process you've described below?

> Assemble it without sdd2 which currently has no superblock, then add =
the new
> drive:
>
> mdadm --stop /dev/md1
> mdadm --assemble /dev/md1 --auto=3Dyes /dev/sd[abc]2
> mdadm --manage /dev/md1 --add /dev/sdd2

I've tried this, but it complains about the system not being shut down
cleanly. Should I just force it?

% mdadm --assemble /dev/md1 --auto=3Dyes /dev/sd[abc]2
mdadm: /dev/md1 assembled from 3 drives - not enough to start the
array while not clean - consider --force.

Thanks again,
Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

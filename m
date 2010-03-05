From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Removing drives
Date: Fri, 5 Mar 2010 12:22:41 -0800
Message-ID: <4877c76c1003051222i584bdb19r65002981060a6360@mail.gmail.com>
References: <4B8F26AF.7080308@vorgon.com>
	 <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>
	 <4B9154C0.7060200@vorgon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9154C0.7060200@vorgon.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Timothy D. Lenz" <tlenz@vorgon.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 5, 2010 at 11:00 AM, Timothy D. Lenz <tlenz@vorgon.com> wro=
te:
> Current setup, 3 500gb sata drives, each with 3 partitions.
> The first partition of each drive make up raid1 md0 boot and most sof=
tware
> The next partition of each drive make up raid1 md1 swap
> The 3rd partition of each drive make up raid5 md2 main data storage
>
> There is also a 40gb ide drive with 2 partitions, boot/software and s=
wap. It
> was used for install and setup. But I never got boot changed over to =
md0. So
> currently md0 is not in use. md0 and md2 are mounted to folders on th=
e 40gb
> so a precopy to md0 could be made before booting with a cd and copyin=
g what
> ever is left that needs coping. and to use md2.
>
> Current
> # /etc/fstab: static file system information.
> #
> # <file system> <mount point> =A0 <type> =A0<options> =A0 =A0 =A0 <du=
mp> =A0<pass>
> proc =A0 =A0 =A0 =A0 =A0 =A0/proc =A0 =A0 =A0 =A0 =A0 proc =A0 =A0def=
aults =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
> /dev/hda1 =A0 =A0 =A0 / =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext3 =A0 =A0defau=
lts,errors=3Dremount-ro 0 =A0 =A0 =A0 1
> /dev/hda5 =A0 =A0 =A0 none =A0 =A0 =A0 =A0 =A0 =A0swap =A0 =A0sw =A0 =
=A0 =A0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 0
> /dev/md0 =A0 =A0 =A0 =A0/mnt/md0 =A0 =A0 =A0 =A0ext3 =A0 =A0defaults =
=A0 =A0 =A0 =A00 =A0 =A0 =A0 0
> /dev/md2 =A0 =A0 =A0 =A0/mnt/md2 =A0 =A0 =A0 =A0ext3 =A0 =A0defaults =
=A0 =A0 =A0 =A00 =A0 =A0 =A0 0
> /dev/hdb =A0 =A0 =A0 =A0/media/cdrom0 =A0 udf,iso9660 user,noauto =A0=
 =A0 0 =A0 =A0 =A0 0
> /dev/fd0 =A0 =A0 =A0 =A0/media/floppy0 =A0auto =A0 =A0rw,user,noauto =
=A00 =A0 =A0 =A0 0
>
> I want to change md0 and md1 from 3 drive mirriors to 2 drive mirrors=
=2E
>
> Finish changing over to booting from md0, move swap to md1 and move t=
he
> mount point for md2 to md0
>
> Remove the the ide drive to free up space for the 4th 500gb drive.
>
> Copy md2 over to the new 500gb temparally.
>
> Get rid of the current md2 freeing up the 3rd drive since it was alre=
ady
> taken out of the mirrors above.
>
> Make a new md2 raid1 with the remaining space of the first 2 sata dri=
ves.
>
> Move the data from the 4th drive back to the new md2
>
> Repartition the 3rd drive to 1 partition same as the 4th drive.
>
> Make raid1 md3 from the 3rd and 4th drives.
>
> It's the steps/commands to change md0 and md1 from 3 drive mirrors to=
 2
> drive mirrors that I'm not sure about. Though now looking at fstab I =
see I
> never even switched over the swap. So I guess, those to arrays would =
be
> rebuilt. So it's more how to do that without messing with md2.
>
> The computer is still on grub1. I haven't updated it it.
>

So you have:

[3-devices]
Raid 1: Unused
Raid 1: Unused
Raid 5: Used - 3 disks

[1-device]
Boot + swap

Just swapoff the raid-swap you want to re-create, then:
mdadm -S /dev/md(swap)
mdadm -S /dev/md(boot)
mdadm --zero-superblock /dev/devices in those arrays

Repartition those two areas of the disks as necessary.

Create new boot and swap partitions.
=46or boot make SURE you use either -e 0.90 OR -e 1.0 .   Given the
nature of /boot I'd say use -e 0.90 on it.
=46or everything else, including swap use -e 1.1 and optionally
write-intent bitmaps.

At this point you should be able to move /boot and your swap off of
the 40gb drive; just remember to re-install grub and that your BIOS
likely sets the boot drive as bios-drive 0 regardless of which SDA/HDA
linux sees it as.  This is what the device.map file is used to tell
grub.


I lost exactly what you wanted the result to look like amid a long
list of steps you /thought/ you needed to make to get there and
references to md numbers that only have meaning to you.  However it
seems that you were mostly stuck getting to this point, so you might
be able to determine a plan using the data you've yet to share with
the rest of us with that 40gb drive out of the equation.

Remember that you can't reshape raid10 yet, but you can start raid10
with 'missing' devices (and add in the spares later).
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

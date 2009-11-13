From: "Majed B." <majedb@gmail.com>
Subject: Re: Simple Raid-1 setup question
Date: Sat, 14 Nov 2009 00:02:15 +0300
Message-ID: <70ed7c3e0911131302o21bd47cbua1f2858c98edb201@mail.gmail.com>
References: <4AFDC2DD.9040002@lamer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AFDC2DD.9040002@lamer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Kurt Newman <kurt@lamer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

1) No need to sync if both disks are new (or have no data).
That can be accomplished using: --assume-clean

2) It shouldn't be a problem. If you still can't force mdadm, use dd
(be very sure you're writing to the correct disks!!)
dd if=3D/dev/zero of=3D/dev/sdx bs=3D10M count=3D1

That will write 10MB of zeros to the disk. It should corrupt any
filesystem laying there.

Remember to change the partition type to "FD" for RAID auto-detect.

Create your filesystem on the array after you create it & that's it.

On Fri, Nov 13, 2009 at 11:34 PM, Kurt Newman <kurt@lamer.org> wrote:
> My questions are as follows:
>
> 1) If you're creating a completely new array (e.g. raid-1) on new
> partitions that aren't formatted, do you still have to sync? =C2=A0I'=
m having
> difficulty finding information on why and when a sync is needed. =C2=A0=
I was
> under the impression a sync is only needed when there's existing
> information on one or more of the drives.
>
> 2) If there used to be information on each device, but has since been
> repartitioned, so that new partitions and a raid device can be
> created... is there any way to prevent mdadm from asking if you reall=
y
> want to create the array? =C2=A0Using `--force' doesn't seem to help.
>
> mdadm: /dev/sda1 appears to contain an ext2fs file system
> =C2=A0 size=3D1464840K mtime=3DFri Nov 13:04:09 2009
> mdadm: /dev/sdb1 appears to contain an ext2fs file system
> =C2=A0 size=3D1464840K mtime=3DFri Nov 13:04:09 2009
> Continue creating array?
>
> As a side note, there really isn't an existing ext3 fs on it, but the=
re
> used to be. =C2=A0To re-use the device, I issued the following comman=
ds:
> =C2=A0> parted -s /dev/sda mklabel msdos
> =C2=A0> parted -s /dev/sda mkpart primary ext3 0 1500
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

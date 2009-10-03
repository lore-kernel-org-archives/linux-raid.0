From: Tom Carlson <twigathy@gmail.com>
Subject: Re: RAID10 - migrating disks without failing/degrading array?
Date: Sat, 3 Oct 2009 09:42:51 +0100
Message-ID: <1f0f1a960910030142j44f3f11eica1381019ab186c9@mail.gmail.com>
References: <72dbd3150910021122r474c43f6m2f1d953b5af9c3e0@mail.gmail.com>
	 <7d86ddb90910021836h537e2af6h552b7c89af37d612@mail.gmail.com>
	 <72dbd3150910021953l67ecd8ffk3d80d2a3699b04c7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3150910021953l67ecd8ffk3d80d2a3699b04c7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Ryan Wagoner <rswagoner@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

You could also use mdadm..... :-)

Say you have raid10 array md0 with members sda1 sdb1 sdc1 sdd1 and you
wish to swap out sdd1 for sde1, with as little time for massive fail
as possible...:

Add a bitmap (bitmap chunk may need tweaking here depending on size of =
devices)
mdadm -Gb internal --bitmap-chunk=3D1024 /dev/md0

=46ail and remove device:
mdadm --fail /dev/md0 /dev/sdd1
mdadm --remove /dev/md

Build (NOT create) a new raid1:
mdadm --build /dev/13 -ayes --level=3D1 --raid-devices=3D2 /dev/sdd1 mi=
ssing

Add this new raid1 to md0:
mdadm /dev/md0 --re-add /dev/md32

Add the new disk to the temp raid1:
mdadm /dev/md32 --add /dev/sde1

[Now wait a while for md32 to resync. md0 should not have had to
resync at all if the array was not in use. Hurrah bitmap!]

Remove the raid1:
mdadm /dev/md0 --fail /dev/md32
mdadm /dev/md0 --remove /dev/md32
mdadm --stop /dev/md32

Re-add the new disk
mdadm /dev/md0 --re-add /dev/sde1

Zero superblock of old disk
mdadm --zero-superblock /dev/sdd1

2009/10/3 David Rees <drees76@gmail.com>:
> (Re-adding linux-raid to CC)
>
> On Fri, Oct 2, 2009 at 6:36 PM, Ryan Wagoner <rswagoner@gmail.com> wr=
ote:
>> On Fri, Oct 2, 2009 at 2:22 PM, David Rees <drees76@gmail.com> wrote=
:
>>> It seems like I should be able to add a drive as a directly
>>> replacement for one of the drives I'm pulling out (so I temporarily
>>> end up with 3-copies of that chunk instead of 2) until I pull
>>> fail/remove the older disk. =C2=A0If I was using RAID0 striped over=
 RAID1
>>> mirrors, for example, I know this is possible.
>>>
>>> Is this possible to do with RAID10?
>>
>> You could stop the array and use dd to copy the old disks to the new
>> ones. Then just start up the array on the new disks.
>
> Yeah, that would work, but the goal is to do the migration without an=
y downtime.
>
> eSATA hot-swap even in inexpensive enclosures works pretty well these
> days. =C2=A0There are slight hiccups as the drives get rescanned, but=
 it's
> not too noticable.
>
> -Dave
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

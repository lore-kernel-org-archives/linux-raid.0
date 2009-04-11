From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Mirroring Entire Drives Partition Type Clarification
Date: Sat, 11 Apr 2009 04:47:54 +0200
Message-ID: <873acfucrp.fsf@frosties.localdomain>
References: <68c007470904101351y7442396bla5366afbc7653e10@mail.gmail.com>
	<68c007470904101400s498b2d03w79e15072f1fa6605@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <68c007470904101400s498b2d03w79e15072f1fa6605@mail.gmail.com>
	(Jared Raddigan's message of "Fri, 10 Apr 2009 14:00:23 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Jared Raddigan <jraddigan@kfh.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jared Raddigan <jraddigan@kfh.org> writes:

> Playing with mdadm today I noticed it seems to allow full drive
> mirroring something I remember that raidtools would fail on.
>
>  Back in raidtools days I remember that even though it was possible t=
o
> mirror an entire drive with a single md volume (sda, sdb rather than
> sda1, sdb1) it really did not work and was not recommended.=A0 It loo=
ks
> like that is no longer the case with mdadm.   Here is what I did.
>
>  Took two hard drives and created a single partition that spans the
> whole drive.=A0 then do:
>
>  mdadm --create --level=3Dmirror --raid-devices=3D2 /dev/md1 /dev/sd[=
ab]1
>
>  Look using mdadm --detail and see
>  Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=
=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
>
>
>  I reboot and now using mdadm --detail I see:
>  Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb
>
>  So it would seem mdadm basically figured out what I wanted to do and
> no longer shows the partition number after a reboot.=A0 So next delet=
ed
> all partitions on the drives and recreated the raid set without
> referencing the partitions

Unless you configured your sda1 to actually start of block 0 of sda
instead of after the partitioning block then something went seriously
wrong there.

>  mdadm --create --level=3Dmirror --raid-devices=3D2 /dev/md1 /dev/sd[=
ab]
>
>  That worked just fine and now=A0 mdadm --detail gives me the same as
> before (but without rebooting)
>  Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
>  =A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=
=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda
>  =A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 16=A0=A0=A0=
=A0=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb
>
>
>  My questions are:
>
>  Is there anything wrong with doing this as this was not recommend
> with raidtools.=A0 This with LVM or partition the md directly (cool
> feature you added) seems like a hard combo to beat?
>
>  Does the MBR get synced across the drives when doing this?

If you write to /dev/mdX then it gets synced. if you write to /dev/sdX
then not.

Also be carefull to use a filesystem that leaves the first 63 sectors
of the device unused for the MBR or you will corrupt your filesystem
and MBR every now and then.

>  I know partition type does not seem to matter with mdadm compared to
> raidtools, but when creating partitions I use "da" rather than "fd",
> is that the recommended type or since it no longer seems to matter no
> one really cares what you use?

The kernel cares for raid auto detection. But that only works if all
drivers needed are compiled in and you have the right metadata format.
Starting raid from initramfs totaly ignores the type I blieve.

>  I am using version mdadm - v2.6.7.2 - 14th November 2008 from Debian=
 Lenny
>
>  Thanks and I am pretty excited how mdadm keeps getting better and be=
tter.
>
>  --
>  Jared

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

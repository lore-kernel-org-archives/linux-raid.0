From: Doug Dumitru <doug@easyco.com>
Subject: Re: partitions
Date: Fri, 28 Jan 2011 14:39:11 -0800
Message-ID: <AANLkTi=z7PxSrsPoh4gozv8sx2H416pqn=dEGBcciR2m@mail.gmail.com>
References: <AANLkTimGHtECH2oFdcWWmjXjzrFeRmDsXhfwg4FMR2a8@mail.gmail.com>
	<AANLkTim_16xzRaQJLd1QGd5Dx2LScNX-VUjxrN5uXZng@mail.gmail.com>
	<AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinjmGobHBtZxsz3Tv9US1-VKr32ODy4h=-9V1cO@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 28, 2011 at 1:45 PM, Roberto Spadim <roberto@spadim.com.br>=
 wrote:
>
> i read about lvm (not a lot), it work with grub and lilo right?

grub and lilo need a "plain" boot partition.  the raid setup is later
and your root partition can definitely be inside of an LVM volume.
This is the default install for many distros.

Doug Dumitru
EasyCo LLC

>
> 2011/1/28 Doug Dumitru <doug@easyco.com>:
> > This functionality already exists with two different solutions.
> >
> > The "normal" solution is to use LVM on top of /dev/md0.=C2=A0 LVM i=
s usually
> > considered "better" than partitions because it is a more flexible a=
pproach.
> >
> > If you have to have partitions, you can do this with:
> >
> > =C2=A0=C2=A0=C2=A0 ... create partitions 1,2,3,4
> > =C2=A0=C2=A0=C2=A0 kpartx -a /dev/md0
> > =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p1
> > =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p2
> > =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p3
> > =C2=A0=C2=A0=C2=A0 mkfs.ext4 /dev/mapper/md0p4
> >
> > This is not really a "linux-raid" issue, but just how to apply bloc=
k device
> > mapping tools.
> >
> > Doug Dumitru
> > EasyCo LLC
> >
> > On Fri, Jan 28, 2011 at 1:24 PM, Roberto Spadim <roberto@spadim.com=
=2Ebr>
> > wrote:
> >>
> >> hi guys, could we implement raid partitions?
> >> for example:
> >> mdadm --create /dev/md0 --level=3D1 --devices /dev/sda /dev/sdb
> >> fdisk /dev/md0
> >> create pratition 1,2,3,4
> >>
> >> mkfs.ext4 /dev/md0p1
> >> mkfs.ext4 /dev/md0p2
> >> mkfs.ext4 /dev/md0p3
> >> mkfs.ext4 /dev/md0p4
> >>
> >> ?? any idea? could we implement it?
> >> there=E6=84=80 a TODO list for linux software raid?
> >>
> >> --
> >> Roberto Spadim
> >> Spadim Technology / SPAEmpresarial
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
> >
> >
> >
> > --
> > Doug Dumitru
> > EasyCo LLC
> >
> >
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

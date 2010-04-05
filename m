From: Mark Knecht <markknecht@gmail.com>
Subject: Re: metadata and / and grub-static
Date: Sun, 4 Apr 2010 19:02:46 -0700
Message-ID: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
References: <j2u5bdc1c8b1004041234j715c0a3fi6bd89c2695f286ea@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j2u5bdc1c8b1004041234j715c0a3fi6bd89c2695f286ea@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Apr 4, 2010 at 12:34 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> Hi,
> =C2=A0 I'm trying to do my first RAID install that puts / on RAID1 bu=
t I'm
> having some trouble. Distro is Gentoo. I'm fairly certain the problem
> is in my kernel because grub finds my RAID enabled kernel and starts
> booting, but when it gets to the point where it is going to enable md=
0
> and mount / (or I think that's where it is) then it fails with a very
> standard message:
>
> VFS - Unable to mount root fs on unknown-block(9,0)
>
> =C2=A0 I know the machine works because I already have a non-RAID ins=
tall
> on sda. The new RAID install is on sdb & sdc and I'm booting to it
> from sda. However so far I cannot get past the point where it figures
> out what to do with /dev/md0 and moves on.
>
> =C2=A0 I just wanted to check that the messages below, which occurred=
 when
> I first built the RAID, aren't a real killer. I am not storing /boot
> on this device but I do want to store /. Is there any problem with
> recent versions of grub doing this? I chose metadata=3D1.0 as mdadm
> seemed happier with that choice, but I've been unable to mount this
> RAID either.
>
> =C2=A0 Again, if this is a kernel issue then I'll work it out. I've b=
uilt
> RAID0 and RAID1 support into the kernel, as well as other things, but
> maybe I've missed something else. I just wanted to be doubly sure tha=
t
> it's not a problem with grub as a boot loader.
>
> Thanks,
> Mark
>
> keeper ~ # mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2
> /dev/sdb3 /dev/sdc3
> mdadm: Note: this array has metadata at the start and
> =C2=A0 =C2=A0may not be suitable as a boot device. =C2=A0If you plan =
to
> =C2=A0 =C2=A0store '/' or '/boot' on this device please ensure that
> =C2=A0 =C2=A0your boot-loader understands md/v1.x metadata, or use
> =C2=A0 =C2=A0--metadata=3D1.0
> mdadm: Note: this array has metadata at the start and
> =C2=A0 =C2=A0may not be suitable as a boot device. =C2=A0If you plan =
to
> =C2=A0 =C2=A0store '/' or '/boot' on this device please ensure that
> =C2=A0 =C2=A0your boot-loader understands md/v1.x metadata, or use
> =C2=A0 =C2=A0--metadata=3D1.0
> Continue creating array? n
> mdadm: create aborted.
> keeper ~ # =C2=A0mdadm --create /dev/md0 --level=3D1 --raid-devices=3D=
2
> --metadata=3D1.0 /dev/sdb3 /dev/sdc3
> mdadm: array /dev/md0 started.
> keeper ~ # cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 sdc3[1] sdb3[0]
> =C2=A0 =C2=A0 =C2=A031463228 blocks super 1.0 [2/2] [UU]
> =C2=A0 =C2=A0 =C2=A0[>....................] =C2=A0resync =3D =C2=A03.=
9% (1241664/31463228)
> finish=3D5.2min speed=3D95512K/sec
>
> unused devices: <none>
> keeper ~ #
>

Answering self - putting / on RAID1 only seems to work using
--metadata=3D0.90. Tried it with higher versions and had no luck.

Anyway, the system is running well now.

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: metadata and / and grub-static
Date: Sun, 4 Apr 2010 21:26:51 -0500
Message-ID: <2D.29.28131.56A49BB4@cdptpa-omtalb.mail.rr.com>
References: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <u2u5bdc1c8b1004041902l9edc298dg6fb4774aaf8c22a6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > keeper ~ # mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2
> > /dev/sdb3 /dev/sdc3
> > mdadm: Note: this array has metadata at the start and
> > =A0 =A0may not be suitable as a boot device. =A0If you plan to
> > =A0 =A0store '/' or '/boot' on this device please ensure that
> > =A0 =A0your boot-loader understands md/v1.x metadata, or use
> > =A0 =A0--metadata=3D1.0
> > mdadm: Note: this array has metadata at the start and
> > =A0 =A0may not be suitable as a boot device. =A0If you plan to
> > =A0 =A0store '/' or '/boot' on this device please ensure that
> > =A0 =A0your boot-loader understands md/v1.x metadata, or use
> > =A0 =A0--metadata=3D1.0

	As the utility warns you, anything other than 0.9 or 1.0 may have
problems loading as / or /boot, because 1.1 and 1.2 both put the metada=
ta at
the start of the device, in your case a partition.

> > Continue creating array? n
> > mdadm: create aborted.
> > keeper ~ # =A0mdadm --create /dev/md0 --level=3D1 --raid-devices=3D=
2
> > --metadata=3D1.0 /dev/sdb3 /dev/sdc3
> > mdadm: array /dev/md0 started.
> > keeper ~ # cat /proc/mdstat
> > Personalities : [raid1]
> > md0 : active raid1 sdc3[1] sdb3[0]
> > =A0 =A0 =A031463228 blocks super 1.0 [2/2] [UU]
> > =A0 =A0 =A0[>....................] =A0resync =3D =A03.9% (1241664/3=
1463228)
> > finish=3D5.2min speed=3D95512K/sec
> >
> > unused devices: <none>
> > keeper ~ #
> >
>=20
> Answering self - putting / on RAID1 only seems to work using
> --metadata=3D0.90. Tried it with higher versions and had no luck.

	One may most certainly run a RAID1 / or /boot (or both) using other
than 0.9 metadata.  I'm running two servers with / on a 1.02 superblock=
 and
/boot on a 1.0 superblock, booting with grub 0.97.

	That said, if the restrictions of a 0.9 superblock are not an issue
for your system, then there is nothing particularly wrong with employin=
g a
0.9 superblock.

> Anyway, the system is running well now.

	Unless the restrictions of a 0.9 superblock will cause problems for
you in the future, that's the important thing.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

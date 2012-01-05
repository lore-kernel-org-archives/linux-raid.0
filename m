From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 fail did not work properly with SSDs
Date: Thu, 5 Jan 2012 13:37:45 +1100
Message-ID: <20120105133745.2c0797d0@notabene.brown>
References: <CALvtuFRKjcttSghvvKqOMKSgmAw8yCNkAipVVZD1hR=+qgpvqQ@mail.gmail.com>
	<CALvtuFSc3BfFrEA8JPjPcWEkkqg71Ni7wzr_15F9YqDt+1OV4A@mail.gmail.com>
	<20120105130047.6554e5f9@notabene.brown>
	<CALvtuFSK9GTRTguQXGqreL_njy72S8d+ExB+t1vT+wkjCNMbFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/FcfZj2tzRLYOIkp5uOCIeNN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALvtuFSK9GTRTguQXGqreL_njy72S8d+ExB+t1vT+wkjCNMbFg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Cal Leeming [Simplicity Media Ltd]" <cal.leeming@simplicitymedialtd.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/FcfZj2tzRLYOIkp5uOCIeNN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 5 Jan 2012 02:18:30 +0000 "Cal Leeming [Simplicity Media Ltd]"
<cal.leeming@simplicitymedialtd.co.uk> wrote:

> Hi Neil,
>=20
> Terribly sorry, I had pasted the wrong lines from mdstat, here is the
> correct info:
>=20
> md1 : active (auto-read-only) raid1 sdd1[0] sda1[1]
>       975860 blocks super 1.2 [2/2] [UU]

That makes more sense.

However the error message was:

[27087.234693] end_request: I/O error, dev sda, sector 6837128

md1 is only 975860 (1K) blocks, or 1951720 sectors.
So unless it starts a long way into the device, this error was from a
completely different location to the array....

There are 128GB devices - yes?  and md1 is 1 GB.  So what is using the
remaining 127GB?

>=20
> Also, I don't know if this is related and will probably sound crazy
> but, every single disk in the server (there was another unrelated
> RAID1 with non SDDs - sdb and sdc) were reporting this same error, but
> the moment I disabled the broken SSD in BIOS, it stopped doing this.

It isn't unknowns for one  bad device to confuse all the other devices on t=
he
same bus, or the same controller.

>=20
>  root@vicky [/sbin] > dmesg | grep sda | grep "I/O error" | wc -l
> 445
>=20
>  root@vicky [/sbin] > dmesg | grep sdb | grep "I/O error" | wc -l
> 2
>=20
>  root@vicky [/sbin] > dmesg | grep sdc | grep "I/O error" | wc -l
> 2
>=20
>  root@vicky [/sbin] > dmesg | grep sdd | grep "I/O error" | wc -l
> 2
>=20
>  root@vicky [/sbin] >
>=20
> And here's the really crazy thing.. the broken SSD was actually
> /dev/sdd, not /dev/sda.
>=20
> I did a badblocks check on both, sdd failed and sda worked fine.
> Removed sdd, and the I/O error problem disappeared on both sdd and
> sda.
>=20
> Could this be the reason why it ended up being placed into read-only
> mode? Because the kernel detected that the controller was saying that
> both SSDs were giving this same "I/O Error" (despite it being caused
> by a single drive)??

The devices aren't read-only.

"auto-read-only" means they are pretending to be read-only at the moment but
as soon as you write something they with automatically switch to read-write
mode.

While they are (pretending to be) read-only they won't do any resync/recove=
ry
etc.  i.e. they won't write to any device at all.  This is generally a safe
way to start md arrays as if a wrong array is started by mistake it won't be
written to until you e.g. try to mount it.

It really looks like nothing is trying to write to 'md1'.

Maybe you need to give us all the details...
  cat /proc/mdstat
  cat /proc/partitions
  cat /etc/fstab=20
 ....


NeilBrown


>=20
> Cal
>=20
>=20
> On Thu, Jan 5, 2012 at 2:00 AM, NeilBrown <neilb@suse.de> wrote:
> > On Thu, 5 Jan 2012 01:44:10 +0000 "Cal Leeming [Simplicity Media Ltd]"
> > <cal.leeming@simplicitymedialtd.co.uk> wrote:
> >
> >> Hi all,
> >>
> >> My apologies if this is the wrong mailing list for this issue, but I
> >> figured my email would be lost in volume if I sent to 'linux-kernel'.
> >
> > too true!!
> >
> >>
> >> In short, I had 2 SSDs in RAID 1, allocated as a single physical
> >> volume, which had a LVM logical volume mounted as the root partition.
> >>
> >> Six months later, one of the SSDs dies, and causes all of hell to brea=
k lose:
> >>
> >> [27087.234675] sd 0:0:0:0: [sda] Unhandled error code
> >> [27087.234686] sd 0:0:0:0: [sda] Result: hostbyte=3DDID_BAD_TARGET
> >> driverbyte=3DDRIVER_OK
> >> [27087.234688] sd 0:0:0:0: [sda] CDB: Read(10): 28 00 00 68 53 88 00 0=
0 08 00
> >> [27087.234693] end_request: I/O error, dev sda, sector 6837128
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ^^^^^=
^^^
> >
> > "sda".
> >
> >> ^^ repeated over 9000 times
> >>
> >> Instead of the disk being marked as failed and removed, the root
> >> partition was instead remounted as read-only, mdadm showed no
> >> problems,=C2=A0and required a reboot.
> >>
> >> Upon rebooting, RAID still hadn't marked the dying disk as failed or
> >> removed, and began to re-sync!
> >>
> >> =C2=A0root@vicky [/var/log] > cat /proc/mdstat
> >> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [rai=
d4]
> >> md0 : active (auto-read-only) raid1 sdb1[0] sdc1[1]
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0^^^^^^^^^^^^^=
^^
> >
> > "sdb" and "sdc".
> >
> > Something is missing in this picture.
> >
> > NeilBrown
> >
> >
> >> =C2=A0 =C2=A0 =C2=A0 78122967 blocks super 1.2 [2/2] [UU]
> >>
> >> On top of this, even though it was read-only, it kept giving this
> >> error for everything:
> >>
> >> =C2=A0root@vicky [/var/log] > shutdown
> >> bash: /sbin/shutdown: Input/output error
> >>
> >> I'm not sure if what I'm seeing here is normal, but thought I should
> >> at least try and ask - I can provide lots more info if needed (got a
> >> huge text file and several screenshots).
> >>
> >> Any feedback would be very much appreciated.
> >>
> >> Cal Leeming
> >> Simplicity Media Ltd
> >>
> >> ----------------------------
> >>
> >> Here is the short smartctl dump of the disk:
> >>
> >> =C2=A0root@vicky [/home/foxx] > smartctl -a /dev/sda
> >> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
> >> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge=
.net
> >>
> >> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> >> Device Model: =C2=A0 =C2=A0 M4-CT128M4SSD2
> >> Serial Number: =C2=A0 =C2=A000000000111603061D7B
> >> Firmware Version: 0001
> >> User Capacity: =C2=A0 =C2=A0128,035,676,160 bytes
> >> Device is: =C2=A0 =C2=A0 =C2=A0 =C2=A0Not in smartctl database [for de=
tails use: -P showall]
> >> ATA Version is: =C2=A0 8
> >> ATA Standard is: =C2=A0ATA-8-ACS revision 6
> >> Local Time is: =C2=A0 =C2=A0Tue Jan =C2=A03 13:54:46 2012 GMT
> >> SMART support is: Available - device has SMART capability.
> >> SMART support is: Enabled
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/FcfZj2tzRLYOIkp5uOCIeNN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTwUM+Tnsnt1WYoG5AQJKXRAAlXSeWlaXxx8wC7AO9BIYXSIr5MQb10wj
/ob9byBtjluKHe/L0iYwMag20JlE8F8HHb2Zsx82olLs6H1kKr9+WfxZqfOwDI9E
HnYz7Qgy28+zmu7RHFbRuU9L9Af8dY/8N5plKJrnmc6ot19nL38hgDRwivOJxsLu
0SoWw3u+cmcUGuIkjF4V3kCWlUP9yHL41kJrdcLHI/fN/4PNII4viI2nbqr0ION4
uwmrNTcjABo5AIUamj0Fgnki/z4hvhKRkknBzo4toNtos8SRtDDJy/jhfo2FEMh7
CnjD9/pIl2nuG+1partW0SH4RO68o+PSpVNaWfpyqfHq7pxjp5UwqRqN+laVjzI6
MbBzzGuPeFb31WoOBu5tIeCbcdme2hfNCp+1dMXqUXRoJS+VzkfHz7LUks/ttFVS
Y7Ocrx7nqnHD6k4lKQviR1nuZZRX20/onWyxboygVmG8Fdw5WOjJD/Grz645gyAO
+2aXA6nh8mUzHjsL33etP7ZIJpurr+IdlFkruZQ4t5PrrcGKubKdZYcgrUHkm3nV
uzi2h59JJrL+6DHkY14FpGTs7iEmgnKOVeQY2es1/cX9cZFpGmnW3afGv27fnQb/
XBtZm/AsfVA78FcTK2QpNNUt/RnLqo5GwjqV02HDHvcwIGQC94gDmiTe39uO379S
1kskrikIrz8=
=MU+b
-----END PGP SIGNATURE-----

--Sig_/FcfZj2tzRLYOIkp5uOCIeNN--

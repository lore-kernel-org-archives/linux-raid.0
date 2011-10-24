From: NeilBrown <neilb@suse.de>
Subject: Re: Converting from Raid 5 to 6
Date: Tue, 25 Oct 2011 07:14:43 +1100
Message-ID: <20111025071443.4c497656@notabene.brown>
References: <CAFsPQ_85omy81WkxKkFg+OCGmdD7A+UtyKo64qMLZBBVKpbBDw@mail.gmail.com>
	<CADNH=7H90HX58zh8mSH54FdFgh46umEscj89t372PZjj9DnHtg@mail.gmail.com>
	<CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tilvqsvhid8o2CBFUoBb8SH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ__G3j3CbMDJyYO7BaJrxnPi=MAZFiRfgbruzMhiCVQYag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tilvqsvhid8o2CBFUoBb8SH
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Oct 2011 17:03:46 +0100 Michael Busby <michael.a.busby@gmail.com>
wrote:

> should the speed be very slow when doing this progress, its a lot
> slower than a normal grow

Yes.
The array is being reshaped in-place.  i.e. data is being read from part of
the array, rearranged, and written back to the same part of the array.
As you can imagine, this is risky - a crash will leave an inconsistent stat=
e.
Hence the backup file.  Everything in the array is first written to the
backup file, then back to the array.  So it is slow.

A "normal" grow is writing to somewhere where there is no valid data, so it
doesn't need the backup.

I do have a plan to make this faster.... but I have lots of plans and little
time.

NeilBrown




>=20
> reshape =3D  1.2% (25006080/1953513984) finish=3D12481.8min speed=3D2574K=
/sec
>=20
> On 24 October 2011 15:11, Mathias Bur=E9n <mathias.buren@gmail.com> wrote:
> > On 24 October 2011 14:11, Michael Busby <michael.a.busby@gmail.com> wro=
te:
> >> At the moment i have a raid5 setup with 5 disks, i am looking=A0to add=
 a
> >> 6th disk and change from raid 5 to raid 6
> >>
> >> having looked at Neil's site i have found the following command, and
> >> just want to double check this is still the recommend way of
> >> converting
> >>
> >> mdadm --grow /dev/md0 --level=3D6 --raid-disks=3D6 --backup-file=3D/ho=
me/md.backup
> >>
> >> also would i need to add the extra disk before or after the command?
> >>
> >> cheers
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >>
> >
> > Hi,
> >
> > I grew my 6 disk RAID5 to a 7 disk RAID6. First, add the drive. Then
> > partition it as required. Then add the drive to the array (I think
> > it'll become a spare?). Then you can grow it.
> >
> > Make sure you're using the latest mdadm tools available.
> >
> > Regards,
> > Mathias
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/tilvqsvhid8o2CBFUoBb8SH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqXHOTnsnt1WYoG5AQKrkg//QdM/IaMtvnegV7WGZFRVbKF+342RO8Kc
z1pUvrH+1FDNWpzjIQ3/O0yp+bE3xHxJ2ZHt351f0GdrE1FAM6gGyLZIcd8+ruuL
vLIc/LYNh+XwKMI+IYFvnGp51Ht5/X/gOfCFyt/zLtnJ0nJnBU/SLoRLv+JZShjq
L+gMFsSLmh+/63Kn4Kn4ntj7+c/cjiF2+M0Osai298FbMK9xCbbhgpqCWj5IJ1QJ
/SLX6fgGIyufnXw4ay/gj8ZtMMRM8syaAt+JQa/yI7tPsjjJMtlgb9dWtxwlpL1K
6etQuMC/Kf/T3JT5mU1W68em+R8rujXfCgGtkqQqEXNDepKal9M6zONHOxL7radF
umAdIDYUv21mMEHEqBH8J03T8+0zj/EoBAdA41MN+3fUSE9892FDSpF65ZuAApkK
iuOgJ7Kn96OdW48i2+3VRtU2o9860YMnLMlrSy9AKpbjT/r6iJI36Sq8B6sILapQ
/f8quLnRHmbdgtTJdZdFgNKFVTNzUCvJbwBiu9Xv1WLcnyidX+COKJYi9xReIj2y
sNZZfCVmqvEpKhmnJ0sw7iiToHZuoVPM58VScUMHMwJcB8mEsuEO6X0FyI+Ubn97
czp+Zf0A2wW3P0qkDLjxwk3nUvhgzTGAV/2btbEs4UPWI2Fh7ZjboMd//9drQatB
I3ka3KzQWPI=
=4xaE
-----END PGP SIGNATURE-----

--Sig_/tilvqsvhid8o2CBFUoBb8SH--

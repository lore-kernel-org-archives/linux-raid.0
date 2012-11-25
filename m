From: NeilBrown <neilb@suse.de>
Subject: Re: Suggestion for hot-replace
Date: Mon, 26 Nov 2012 08:49:17 +1100
Message-ID: <20121126084917.0d9e447f@notabene.brown>
References: <50B1BCBD.70306@zytor.com>
	<50B25C77.4000502@shiftmail.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/P7AfK/Z5_JgUUHSFe9=vmXg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B25C77.4000502@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: joystick <joystick@shiftmail.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/P7AfK/Z5_JgUUHSFe9=vmXg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 25 Nov 2012 18:59:19 +0100 joystick <joystick@shiftmail.org> wrote:

> On 11/25/12 07:37, H. Peter Anvin wrote:
> > I was looking at the hot-replace (want_replacement) feature, and I had=
=20
> > a thought: it would be nice to have this in a form which *didn't* fail=
=20
> > the incumbent drive after the operation is over, and instead turned it=
=20
> > into a spare.  This would make it much easier and safer to=20
> > periodically rotate and test any hot spares in the system.  The main=20
> > problem with hot spares is that you don't actually know if they work=20
> > properly until there is a failover...
> >
> >     -hpa
> >
>=20
> Sorry I don't agree.
>=20
> Firstly, it causes confusion. If you want a replacement in 90% of cases=20
> it means that the current drive is defective. If you put the replaced=20
> drive into the spare pool instead of kicking it out then you have to=20
> remember (by serial number?) which one it was to actually remove it from=
=20
> the system. If you forget to note it down, then you are in serious=20
> troubles, because if that "spare" then gets caught in another (or the=20
> same) array needing a recovery, you will have a high probability of=20
> exotic and unexpected multiple failures situations.
>=20
> Also, if you are uncertain of the health of your spares, risking your=20
> array by throwing one into the array is definitely unwise. There are=20
> other tecniques to test a spare that don't involve risking you array on=20
> it: you can remove one spare from the spare pool (best if you have 2+=20
> spares but can also be done with 1), read/write all of it various times=20
> as a validation, then re-add it back to the spares pool. Even just=20
> reading it from beginning to end with dd could be enough and for this=20
> you don't even have to remove it from the spare pool. And this doesn't=20
> degrade the array performances, while your suggestion would.
>=20
> Thirdly, if you really want that (imho unwise) behaviour, it's easy to=20
> implement from userspace without asing the MD developers to do so:=20
> monitor the replacement process, as soon as you see it terminating and=20
> you see the target drive in Failed status, remove and re-add it back as=20
> a spare. That's it.

I tend to agree with this position.

However it might make sense to record the reason that a device is marked
faulty and present this via a sysfs variable.
  e.g.:  manual, manual_replace, write_error, read_error ...

Then mdadm --monitor could notice the appearance of manual_replace faulty
devices and could convert them to spares.

I'm not likely to write this code myself, but I would probably accept patch=
es.

NeilBrown

--Sig_/P7AfK/Z5_JgUUHSFe9=vmXg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBULKSZTnsnt1WYoG5AQJGWA//XULRinbwEhVcLyrsKZ7t7LJPhanK/OwS
CJvmI248lvH5eLtaRvwPu3VRxswNPvabxyr0QEv/iyKVillnWmZNWGtGV19g/eMN
KGq/QJNkBkmLObFXbWgvDa/JRrlr2o9cdBVe45LfuQxJxHusCUPrQw9cIP4A3bOW
Wqtnk0OKOuywCY7+rKNIL2iQqJB043MyBbVGpeqfDZfcxb4Q4bLyFs7OohbIhQOK
8KTHuxVKp6QxhVgjqaZ+89b4g6zwuI1KOsIPCjX1dWOinCUGesKPSvr8ftDhhgq3
pJTcjZI2zMl5gy1QG/DTXurt3NSq0PIXYsaFZCGrqWUnNJbsWqswDbEMckL4Evey
Jz6oBa9DGddG6/VwzhGRxPUL37RVG1tmfDLs/eFZs3Z+I4lrCCT5pUtvcPO4zpvZ
76aIIOEEJuKJJh6E95X2KmrdKAVhtqRU1KOAUx4IPaag5Rx2N2K4OotwGZJRQV95
PWpcviVYGXoAlvlb5TeuSK1J6eFs2YYYwHfvoSbxGQq7dVEHVFHWGyDYDVOR3Kw2
uiC6UTAcSuF8vsVu957Vbo/nMyMR0ItkU8TOTkaaydGiMsgCjCoVGfWMrBHsK5EV
0az5vLe0fEpX6fNKdjU2KEP90Hz6AAOCx9mieyabhHw1qx2mzb4R3vetfhfBcxnP
t6qGyqytYf0=
=lFmY
-----END PGP SIGNATURE-----

--Sig_/P7AfK/Z5_JgUUHSFe9=vmXg--

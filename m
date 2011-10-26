From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Wed, 26 Oct 2011 18:42:36 +1100
Message-ID: <20111026184236.3f82da2b@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<j88a5v$cnd$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9c2Q8uDRCW5u2NbRL46PRd6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j88a5v$cnd$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9c2Q8uDRCW5u2NbRL46PRd6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 08:38:00 +0200 David Brown <david@westcontrol.com> wrot=
e:

> On 26/10/2011 03:43, NeilBrown wrote:
> > The following series - on top of my for-linus branch which should appea=
r in
> > 3.2-rc1 eventually - implements hot-replace for RAID4/5/6.  This is alm=
ost
> > certainly the most requested feature over the last few years.
>=20
> Fantastic news - well done, and thanks for all your work (and to the=20
> other md developers too, of course).
>=20
> > I hope to submit this together with support for RAID10 (and maybe some
> > minimal support for RAID1) for Linux-3.3. By the time it comes out
> > mdadm-3.3 should exist will full support for hot-replace.
> >
>=20
> Hot-replace for RAID1 is surely just a normal "add", a resync, a "fail",=
=20
> and a "remove"?  So support here should be mainly about the consistency,=
=20
> such as supporting the same "replaceable" tag.  RAID10, I imagine, would=
=20
> be more complicated.

Zigactly.

The thing that particularly needs to work for RAID1 is if you have an array
with a spare and you have bad-block-logs enabled and you get a write error,
then the write error needs to be logged, but also recovery needs to start
onto the spare and when that completes the drive with the write error should
be failed.  I just need to add enough bit so that works, which shouldn't be
hard.

NeilBrown

--Sig_/9c2Q8uDRCW5u2NbRL46PRd6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqe57Dnsnt1WYoG5AQLy+RAAwQJT4qZLdT8E6a3u9ETq0kz2nTR9+fEx
sdiMGBTInSXYuxboCnwZLtWuxOJWiA1wGi3qDeapyaWUw/mPDZspjh6yETa8LJKr
l2zHtzjc953fy9l+hGzASgIJ+Z+zwWt0krXcS+0p8ii45ZsD5dVaeaRAZRqKIxez
0tvoRhLLnNemB20aKlDCS2g2URj6o17mn0TIPfxCxr7aL/IpUUtHNVog2DMb8hRI
JRvsqoDRnbgVTUYi+RrC5pCQFM3OwUDAHW1QWADlZO/O/NmRM6xYmypoQjtfTkM7
l2LPzbIzIq/XMLHIxHPL2OCODratAWINlWElEIwLesQYUyDvTOAaL+1ZXpPjT4jO
pb1GyXNcypKmKjnva0Rm2WwchzAL3Eqh8KOZjPQiwfpS9Z9ND5Vz9V33geMDf2r/
YBwyGJSm8KEHyvtesXybrAJ/gRoMvf2MttmjhOfxcMQGVYM1CtKnf9qIj9xuX/1E
CS0H851lPgFpDS/AOfIYYABe+5IPlLMUb9DWWXjaKTUR5f0C2LwainAPlq6gJOIA
HP4MSFEHssqwHXayq1m7oYuhT7zz2uD0E7eHwJqHUoePh+Ewwlr6yIunv3GPtVsB
+3irHoCp6biQbI8A0KaIFdKSTwWXa9bwGLx6oXnJYhWamou/eDXJYVbmIHQaYEyx
vvtrX5Xa/3E=
=Jj/Z
-----END PGP SIGNATURE-----

--Sig_/9c2Q8uDRCW5u2NbRL46PRd6--

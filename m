From: NeilBrown <neilb@suse.de>
Subject: Re: RAID partitions, or RAID disks and partition array?
Date: Sat, 23 Aug 2014 11:18:47 +1000
Message-ID: <20140823111847.724eabe2@notabene.brown>
References: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/onjULYxcSbHfMOtClrF6yKz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/onjULYxcSbHfMOtClrF6yKz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Aug 2014 09:52:11 -0700 Adam Talbot <ajtalbot1@gmail.com> wrote:

> I hope this is an easy one.  I have two drives I would like to mirror
> as my boot drive.
> 1) Should I mirror the drives, then partition the RAID device (md0)?
> 2) Should I partition the the drives then RAID the partitions?
>=20
> What is the best practice, and why?

I always do '1'.  I use 1.0 metadata so each drive can be used by itself qu=
ite
apart from RAID, or can be part of the array.
Boot sectors etc are mirrored so you don't need to be sure that grub writes
to both devices or whatever.

However this is "my" practice rather than "best" practice.  It is entirely
possible that grub might try to be too clever, see a RAID1 and want to do
something to the underlying drives - and then fail when they look wrong.

Ultimately this is a question about how your distro is configured and how
your boot loader works much more than it is a question about md/raid.

Once you choose a distro, you should see what that distro recommends and do
that, because that is the only configuration you can hope to get support fo=
r.

NeilBrown

--Sig_/onjULYxcSbHfMOtClrF6yKz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU/fr9znsnt1WYoG5AQJdQg/+MstMmxLLgKfikDcACBUJ2sUWCvPgkSF0
VOh7ajWzoprIgzH9sNgMiXUCVBxTdttkVlqOvBjhhXSYKKzl/JX3iCfIQCZyQd/a
7UKbQjPWyZwjB78QcJV8aXBY8Y6Bi4c+BJYJbFdXckXT7F/IhmQxfxDyFwfldqAk
Ki9ObtMSaEcSxryM78tix2Tx5nx6sccWk89i7/63CaVCGWH9Mqao1cW9LV9A4h1k
3GNrzObGLIL72uJkOP0ckhHnfy9PNYHhrGSajHqojhIDC73noby20SZ3UV/NFg8e
GBb/4OuN+k9m60CHEmBEGk5ipf1AWnPm54+DyUW4XLcFtzPhnyQpMqLC3P6f85r/
uS4EVayDVnxIYPYou19AScITPgCcejsS/ZsAPjY+Uwa8QpLlZvS2mgZFSo7f8uZm
AkjwOZ/h17BWGn+RLFUVPuTT0XRHYlBEIUMel+5DgIs4NCaL4fvt6+VzE8hVc1qx
5lG/BCxi4FNI/X9e5fPgzMd5057mSBejJ86+6eiq2/5ZIhhzdr0p9i//uEUdw6kx
Oz45xwUponKYRobfq15HCgKHIk9aoaGfCJDe5yczzKSdtMnI4qPb834cctuEak1S
3933QhckrsQnMsxJyWiTHrg3mCAdj1bS5pxZnT4UfCq5XFzODu/GoQtl9xsiBu9j
oFRY1IXBxkk=
=0UD8
-----END PGP SIGNATURE-----

--Sig_/onjULYxcSbHfMOtClrF6yKz--

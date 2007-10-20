From: Doug Ledford <dledford@redhat.com>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sat, 20 Oct 2007 10:24:36 -0400
Message-ID: <1192890276.1666.126.camel@firewall.xsintricity.com>
References: <18200.49267.763509.924873@stoffel.org>
	 <Pine.LNX.4.64.0710191109000.27246@p34.internal.lan>
	 <18200.53593.687483.120827@stoffel.org>
	 <1192810534.1666.68.camel@firewall.xsintricity.com>
	 <471A0C02.4030407@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9l8I9BRvSR2PD70rtTqf"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471A0C02.4030407@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: John Stoffel <john@stoffel.org>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-9l8I9BRvSR2PD70rtTqf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-20 at 18:09 +0400, Michael Tokarev wrote:
> Doug Ledford wrote:
> []
> > 1.0, 1.1, and 1.2 are the same format, just in different positions on
> > the disk.  Of the three, the 1.1 format is the safest to use since it
> > won't allow you to accidentally have some sort of metadata between the
> > beginning of the disk and the raid superblock (such as an lvm2
> > superblock), and hence whenever the raid array isn't up, you won't be
> > able to accidentally mount the lvm2 volumes, filesystem, etc.  (In wors=
e
> > case situations, I've seen lvm2 find a superblock on one RAID1 array
> > member when the RAID1 array was down, the system came up, you used the
> > system, the two copies of the raid array were made drastically
> > inconsistent, then at the next reboot, the situation that prevented the
> > RAID1 from starting was resolved, and it never know it failed to start
> > last time, and the two inconsistent members we put back into a clean
> > array).  So, deprecating any of these is not really helpful.  And you
> > need to keep the old 0.90 format around for back compatibility with
> > thousands of existing raid arrays.
>=20
> Well, I strongly, completely disagree.  You described a real-world
> situation, and that's unfortunate, BUT: for at least raid1, there ARE
> cases, pretty valid ones, when one NEEDS to mount the filesystem without
> bringing up raid.  Raid1 allows that.

Name one.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-9l8I9BRvSR2PD70rtTqf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHGg+jTzP9PM7pjw8RAj6zAJ9xysJnHBnE/RltYOif7cdgIUXYyQCbB7vF
VWXLoCgelf1ZICPQRkWiT7A=
=fevT
-----END PGP SIGNATURE-----

--=-9l8I9BRvSR2PD70rtTqf--


From: Andre Noll <maan@systemlinux.org>
Subject: Re: Minor mdadm fixes
Date: Tue, 12 Jan 2010 05:39:33 +0100
Message-ID: <20100112043933.GO21495@skl-net.de>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com> <20100112031027.GL7517@skl-net.de> <4B4BEE48.1000305@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SSjFkhywpXnVG+rz"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B4BEE48.1000305@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--SSjFkhywpXnVG+rz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22:36, Doug Ledford wrote:
> > I believe (Doug, please correct me if the following is wrong) the
> > advantage of storing mdmon's pid files in /dev is that in /dev they
> > remain visible after the switch to the new root. That's the "handoff
> > after pivotroot" in the subject.
>=20
> I'm a little fuzzy on this myself.  The original patch was from another
> Red Hatter that works on dracut, the new mkinitrd replacement in Fedora
> 12.  When integrating IMSM support in the md raid stack and dracut,
> there became a problem with starting mdmon in the initramfs filesystem
> and then transitioning it to the new filesystem.  It turns out that, as
> you point out, because /dev is moved from the initramfs to the new root
> (mainly because udev is now started in the initramfs), we could avoid a
> number of issues caused by mdmon's files being in /var/run instead of
> /dev.

One could also mount /var/run in the initramfs and move it over
like /dev, but that gets a bit messy because /var might be on a yet
another fs..

> This also allowed us to do the mdmon restart *after* the switchroot
> had taken place and solved a number of issues with getting mdmon
> support to work.

Just out of interest: Why does mdmon need the restart at all?

Thanks
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--SSjFkhywpXnVG+rz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFLS/0FWto1QDEAkw8RAqY1AJ9cOujwDJuo5ZE7cq7gu76LwWX8lACZAcdm
Jy6O4SYoJIKztGaI2ZT1GFg=
=rGEv
-----END PGP SIGNATURE-----

--SSjFkhywpXnVG+rz--

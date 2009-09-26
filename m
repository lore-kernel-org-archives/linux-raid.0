From: Andre Noll <maan@systemlinux.org>
Subject: Re: RAID1 assembled broken array
Date: Sat, 26 Sep 2009 11:58:34 +0200
Message-ID: <20090926095834.GP5174@skl-net.de>
References: <h8ophd$n8p$6@ger.gmane.org> <9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com> <65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name> <20090917082528.GO5174@skl-net.de> <19132.31575.349988.442763@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m46qSNjkc66Ye11q"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19132.31575.349988.442763@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--m46qSNjkc66Ye11q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18:12, Neil Brown wrote:
> > BTW: Why are new arrays still created with 0.90 metadata format by
> > default?
>=20
> Because I'm a chicken....
>=20
> I guess it probably is time ... but to we make the default 1.0, which
> is compatible with people's expectations, to 1.1 which is generally a
> safer approach (you cannot mount a bare device by mistake).

People will soon have to use 1.x anyway as drives are getting bigger
than 2T. I'd vote for making 1.1 or 1.2 metadata the default for the
reasons Doug pointed out. Failing to mount the bare device if there
is a partition table is IMHO more important than meeting (broken)
expectations.

Maybe we should depricate kernel-level autodetection at the same time
so that using an initramfs becomes mandatory for setups with / on md.

Best
Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--m46qSNjkc66Ye11q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFKveXKWto1QDEAkw8RAloaAKCOtiruIVriChx1at+gDK6OzCnxGwCfSmG1
Kgy7+ML9GiZ9tbcc5QISuAE=
=4wug
-----END PGP SIGNATURE-----

--m46qSNjkc66Ye11q--

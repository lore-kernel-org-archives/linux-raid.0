From: Roman Mamedov <roman@rm.pp.ru>
Subject: Re: [PATCH] Add optional round-robbin read balancing to RAID1
Date: Tue, 7 Sep 2010 08:43:47 +0600
Message-ID: <20100907084347.50e705df@natsu>
References: <Pine.LNX.4.64.1009061609170.11139@claw.oc9.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1/M.p5FWubZb+kW6LCGNQ=w"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.1009061609170.11139@claw.oc9.org>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Keene <rkeene@rkeene.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/1/M.p5FWubZb+kW6LCGNQ=w
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Sep 2010 16:14:17 -0500 (CDT)
Roy Keene <rkeene@rkeene.org> wrote:
=20
>  	Below is a patch that adds support for an alternate read balancing=20
> strategy that blindly performs read round-robbin to the MD RAID1 driver.=
=20
> This can be configure per array via sysfs.  The default behaviour is to=20
> preserve existing behaviour (biased read balancing)
>=20
> I am looking for comments and possible inclusion upstream.
>=20
> The motivation behind this is that during a sequential read, under some=20
> circumstances balancing the I/O through the paths produces better=20
> throughput than reading sequentially from one device.

The term is "round-robin", not "robbin", you may want to correct the word
everywhere, most importantly in the actual patch.
http://en.wikipedia.org/wiki/Round-robin

--=20
With respect,
Roman

--Sig_/1/M.p5FWubZb+kW6LCGNQ=w
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkyFpuMACgkQTLKSvz+PZwj25wCdGOoAxB8Lj7lOiUOeYn0vq2Iw
l2wAnj+ocV4NoTyDLREfNIdkRxLCg6hV
=8SFG
-----END PGP SIGNATURE-----

--Sig_/1/M.p5FWubZb+kW6LCGNQ=w--

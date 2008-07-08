From: Andre Noll <maan@systemlinux.org>
Subject: Re: [Patch 0/8] simple md.c cleanups
Date: Tue, 8 Jul 2008 11:48:12 +0200
Message-ID: <20080708094812.GH4981@skl-net.de>
References: <20080707075532.GA32617@skl-net.de> <18546.48558.451793.270407@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zrag5V6pnZGjLKiw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18546.48558.451793.270407@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Zrag5V6pnZGjLKiw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:06, Neil Brown wrote:
> On Monday July 7, maan@systemlinux.org wrote:
> > Hi
> >=20
> > here are eight simple cleanup patches to md.c against linus-current.git.
> > Please review.
>=20
> Thanks. I
>  - added "md: " to the start of the subject line
>  - fixed the conflicts with the first patch against my current tree:
>      I think I already fixed some of that indenting
>  - dropped the last patch....  I don't have a clear justification,
>    but I currently want to leave the 'mddev' parameter there to remind
>    me to review the implementation as I might want to do something
>    a bit different there ... not sure yet.
>=20
> They are now in my "for-next" branch which can be viewed at
>=20
>  http://neil.brown.name/git?p=3Dmd;a=3Dshortlog;h=3Drefs/heads/for-next

Thanks for including the changes so quickly.

I have some more patches which are also simple, but slighlty more
involved. I'll queue them up and send them to the list for review
later today.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Zrag5V6pnZGjLKiw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIczfcWto1QDEAkw8RAgypAJ4txvq+nT79xyfbTQcXyP7H41XBewCfStr6
H1s4BB6x759MKrNfY3oAcJM=
=I7O1
-----END PGP SIGNATURE-----

--Zrag5V6pnZGjLKiw--

From: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Strange md(_resync?) related paging errors on 2.6.29
Date: Fri, 17 Apr 2009 10:46:56 +0200
Message-ID: <20090417084656.GA13682@darkside.22.kls.lan>
References: <20090417074301.GA21290@darkside.22.kls.lan> <777409cc1e62236fdb44290fd539a19b.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <777409cc1e62236fdb44290fd539a19b.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2009 at 06:18:20PM +1000, NeilBrown wrote:
> This is a known problem that is fixed by
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3D303a0e11d0ee136ad8f53f747f3c377daece763b
> That patch should be in 2.6.29.1 when that gets released.

Hmmm, I guess you mean 2.6.29.2, do you?
All the 3 errors appeared on Debians linux-image-2.6.29-1-686-bigmem
2.6.29-2 which includes 2.6.29.1. And I can't find a commit for
303a0e11d0ee136ad8f53f747f3c377daece763b in ChangeLog-2.6.29.1.

--=20
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQEVAwUBSehCABS+e2HeSPbpAQICcgf+KsRobR60Kc51qyQfWUR2lFYhFRgqOI9Z
uwXA2Z+24Yw+6ogYLk7dRvZwFMZeSXvo4sdzvmX5WR3HifWoW1nc/hvYUyYAU28h
BV91DXI+41RcsHhkqRKQCOHE7awI90RgnhtVIntOT3DCDuqjrSc3gmEUqrwJzq3c
fCPsthLdtmjSjlgjZCB3Pkg8A2531eqsDB5D+3d/GfkxrZlaaXNNVu4L3XMw6PyF
f67pd7dw5JETeIPJ1kj6rBK53G0/4F/wEGys3Glw8FMIG0wTi37to4DDzWyLB0mE
LvVGxx6RxZsW2elWAh9s9DldGHqchsIF7ZK2mJPdhqAPLL+rHj7BtA==
=R1FK
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--

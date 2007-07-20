From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
Subject: Re: [RFH] Partion table recovery
Date: Fri, 20 Jul 2007 09:00:28 +0200
Message-ID: <20070720070028.GI22998@lug-owl.de>
References: <200707200813.03553.a1426z@gawab.com> <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BWWlCdgt6QLN7tv3"
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1764732AbXGTHAh@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <aa4c40ff0707192225r6b5e971fy59f78a525697f864@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Lamanna <jlamanna@gmail.com>
Cc: Al Boldi <a1426z@gawab.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


--BWWlCdgt6QLN7tv3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-19 22:25:49 -0700, James Lamanna <jlamanna@gmail.com> wrote:
> On 7/19/07, Al Boldi <a1426z@gawab.com> wrote:
> >
> > I tried parted, but it's not working out for me.  Does anybody know of a
> > simple partition recovery tool, that would just scan the disk for lost
> > partions?
>=20
> Tried gpart?
> http://www.stud.uni-hannover.de/user/76201/gpart/

Right, gpart should be the way to go. I used that several times and
it always worked great. You'll probably loose the first partition at
first (it searches for filesystem signatures and may fail to find the
first partition's filesystem), but it should find all the rest.

Once you've written the guessed partition table, just use cfdisk (or
any other fdisk you're comfy with) to create a maximum-sized partition
in the first free area. Depending on the filesystem used there, you
may even be able to get back the remaining data.

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:             God put me on earth to accomplish a certain numbe=
r of
the second  :            things. Right now I am so far behind I will never =
die.

--BWWlCdgt6QLN7tv3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoF2MHb1edYOZ4bsRAnV+AJ9do/SO0H7Hhih8Snm7G9BKsAkMvwCfZXRg
UjBO3SScnIc6hk2kP6Pznh4=
=iY3R
-----END PGP SIGNATURE-----

--BWWlCdgt6QLN7tv3--

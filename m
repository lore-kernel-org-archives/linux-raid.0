From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 6/6] mdmon: allow disabling "@dmon" command name at
 compile time
Date: Mon, 2 Sep 2013 11:07:03 +1000
Message-ID: <20130902110703.57cbf68a@notabene.brown>
References: <1376677320-12816-1-git-send-email-mwilck@arcor.de>
	<1376677320-12816-7-git-send-email-mwilck@arcor.de>
	<20130828151505.222eaa0a@notabene.brown>
	<5223774D.50405@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qpbhPJc=+zAqzazlI98mY1y"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5223774D.50405@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qpbhPJc=+zAqzazlI98mY1y
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 01 Sep 2013 19:20:13 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 08/28/2013 07:15 AM, NeilBrown wrote:
>=20
> > Can you help me understand?  What is anaconda even looking for mdmon?
> > Does it need exactly "mdmon" or would "@mdmon" be OK?
>=20
> To be precise, it's not anaconda but "loader", the C program that starts
> anaconda and cleans up after it. It looks exactly for "mdmon". See
> https://git.fedorahosted.org/cgit/anaconda.git/tree/loader/shutdown.c?h=
=3Drhel6-branch#n59
>=20
> > Does "started by systemd" mean that "systemctl start mdmon@mdXXX.servic=
e" was
> > used to start it?  In that case can't we put something in
> > systemd/mdmon@.service to make the right thing happen?
>=20
> Sorry for having explained unclearly. This is *not* a systemd
> environment. There is no regular "init" process running AFAICT, "loader"
> takes that role as far as necessary in the installation environment.
>=20
> >=20
> > I'm going to hold off on this one for the moment.
>=20
> If this isn't applied, in the RHEL/CentOS 6 installation environment,
> "loader" will kill mdmon, and a subsequent "mdadm --wait-clean" will
> hang forever.
>=20

Thanks for the details Martin.

I've taken a different approach which should solve the same problem.

If you can confirm that this still works I would appreciate it.

Thanks,
NeilBrown


=46rom 2f1bcf43d93a991845b2ebee76850bd4dc5bc7fc Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Mon, 2 Sep 2013 11:02:09 +1000
Subject: [PATCH] Make sure "mdmon" doesn't get called "@dmon".

The Anaconda installer (via its "loader" program) will try to kill
many processes at shutdown, but not "mdmon".

However when mdadm runs mdmon in the Anaconda environment, mdmon
sets argv[0][0] to '@' resulting in "@dmon" which confuses
"loader".

So change mdadm to set argv[0] to a path so that mdmon becomes e.g.
  "@usr/sbin/mdmon"
which "loader" will recognise as being "mdmon".

Reported-by: Martin Wilck <mwilck@arcor.de>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/util.c b/util.c
index 491a107..c12fb21 100644
--- a/util.c
+++ b/util.c
@@ -1691,7 +1691,7 @@ int start_mdmon(char *devnm)
 	char *paths[4] =3D {
 		pathbuf,
 		"/sbin/mdmon",
-		"mdmon",
+		"./mdmon",
 		NULL
 	};
=20
@@ -1759,7 +1759,7 @@ int start_mdmon(char *devnm)
=20
 		for (i =3D 0; paths[i]; i++)
 			if (paths[i][0]) {
-				execl(paths[i], "mdmon",
+				execl(paths[i], paths[i],
 				      devnm, NULL);
 			}
 		exit(1);

--Sig_/qpbhPJc=+zAqzazlI98mY1y
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUiPktznsnt1WYoG5AQJyFBAAj6D+gLkfV0XHvcku/ZgukRpyYRU1AMwP
LOzuiw01Zm2FcC6LVrV6jQs9Vvii69Dw4tFUrgIrMvm/b/AGJDKtXG6v0CFvfMyr
HQhk/d1t2FJBCTacA9lRdDLYi9mrZHDM03cJjb9ECEkit5wHadGXpvs4FZfO/0jM
F5IYn1siJRY/mc4sQYsI/8TyoIhgzCEju+auK59+v+DNRsnKNrtfbasj4V6fKYZN
qeFr1y6dvHxgnlKZX03WPJcSQ9tD+9b/OCRjMV1jdPD3uaYvTi5B9RSAY6ioOGUi
qUba/Di84lSs74BGiBTx5DCldwlslco54ljo4xKpT9pKn8hVfUoSZ+/SrtK6aVVU
eKbHTrb/wpulwV1FlChUFqph2tTMI7efS2kqsU/btevdUn1kg4cwMj9OPXxG0QEI
gnKg0dtEcA+jYhQtOMMR+03Fr5LdRNdhnXbFmZLtU6OcWEOzz7uXp+yebiBRmneH
2jwtvVYm5Kg28s2g24lb6g9ONr42Mny7brVcUPmaujP4IDPC9V0nWo1SFB/IBL11
Uz0rdsfPGH3oVRr75GB/CZJ1SHHJGbGwS8+yhEZn66+mNsjcE8Qho8PY2L6YvXfY
RfbYQaS8ke+TOC2uhLAenyL33Z/hcuiiQVfN2E/sm+0kDNOizRhxXM8xkMC08yze
bbPwQiKO7No=
=UUBg
-----END PGP SIGNATURE-----

--Sig_/qpbhPJc=+zAqzazlI98mY1y--

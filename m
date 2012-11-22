From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: error when using multiple ARRAY <ignore> lines in
 mdadm.conf
Date: Thu, 22 Nov 2012 16:28:48 +1100
Message-ID: <20121122162848.3a00f1f3@notabene.brown>
References: <201211110343.43052.vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/71vls/7YB40IF+DMzl=xuur"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201211110343.43052.vapier@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/71vls/7YB40IF+DMzl=xuur
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 11 Nov 2012 03:43:42 -0500 Mike Frysinger <vapier@gentoo.org> wrote:

> the mdadm.conf documentation indicates that <ignore> is special and can b=
e=20
> specified multiple times.  unfortunately, that is not the case:
> 	mdadm: Device <ignore> given twice in config file
> 	mdadm: Duplicate MD device names in conf file were found.
> -mike

Fix by following patch.

thanks,
NeilBrown


=46rom 13f2dd6be5618ff556f9a364903e4b95558115e1 Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 22 Nov 2012 16:28:00 +1100
Subject: [PATCH] conf: allow multiple arrays to be <ignore>d

We currently complain if mdadm.conf contains multiple
definitions for the same name.  Unfortunately this stops
multiple arrays  from being <ignored>d.

So exclude "<ignore>" from the duplicate-names test.

Reported-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/config.c b/config.c
index 656d4e2..8461309 100644
--- a/config.c
+++ b/config.c
@@ -1095,6 +1095,8 @@ int conf_verify_devnames(struct mddev_ident *array_li=
st)
 	for (a1 =3D array_list; a1; a1 =3D a1->next) {
 		if (!a1->devname)
 			continue;
+		if (strcmp(a1->devname, "<ignore>") =3D=3D 0)
+			continue;
 		for (a2 =3D a1->next; a2; a2 =3D a2->next) {
 			if (!a2->devname)
 				continue;

--Sig_/71vls/7YB40IF+DMzl=xuur
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUK24EDnsnt1WYoG5AQIu/g/+INrKPBJ1dkoMcMFlHNx3XfybPAbxvhfU
R1FYO1vLOqBkhySyv1SU/ij+H2hwIWX3HI22gt8x62AP6xzZ92gDLxPNPsBRGdIG
T5Nnk1/VDx8I/NwejqDF/M9Hsbwsb4m+AEQ70xC8U5MPe9MIE46neM3LazXoFmt/
fqYUusyE6J+YYbF+myV9MQzEFPFM9h6owlsiP1U6CpEXeZllcIalsMJRcLAE/H+G
hj3Kw5T59Y896+00VIoWjNBg7BFnJN7KEV5WN7DUKeU98aW6c4taJBxaoON0QHr/
wZNEz5xiDgr0cAQo7MQJRlhObIvWl/iC6nbuYWyJHjow5FlCqSNMeNasEC+xaLGg
WgDWS5LILvLs+gsgfszdkTXovtVW+LCptsAQRmfq3qa5wOgK5ZU9VFq1Th/iW33D
7VAqZFFaA7H/lpKBeDIdtlv/Ii5YiXSDJGXaL/CeUPbV7zMhMMtQH2Ljw09mUJzS
aWf5rVMnHzti69QB9l+a2ilBm2xdKZCB7zeYGGnottvYYSowraxoomANlhYh3smj
yzZzyH+UzL/aipbXZtXubg74oDG6hW//e6b97Rd1casMpCkLQIQTEKCqkT5QPQOd
3QGgXprljhdFZYC+JMH9v4yt6zTchd4NWxN9c/fa8kMAYUTiY957YWOmAOoS9XKs
xK3esriZcyU=
=UwkP
-----END PGP SIGNATURE-----

--Sig_/71vls/7YB40IF+DMzl=xuur--

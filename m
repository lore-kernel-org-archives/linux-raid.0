From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH v2] mdadm: make --update=homehost work again
Date: Thu, 7 Feb 2013 11:53:28 +1100
Message-ID: <20130207115328.6b07ade9@notabene.brown>
References: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+5HQBmxjc+U44ass.Lfz+w5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1360181237-11760-1-git-send-email-jmaggard10@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Maggard <jmaggard10@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/+5HQBmxjc+U44ass.Lfz+w5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed,  6 Feb 2013 12:07:17 -0800 Justin Maggard <jmaggard10@gmail.com>
wrote:

> Commit 1e2b276535cea41c348292a019bdda8a58cb1679 (Report error in --update
> string is not recognised) broke homehost updating functionality because it
> depended on each string comparison being done even after we already found
> a match.  Make it work again by using a goto instead.
>=20

Hi Justin,
thanks for the patch.  Unfortunately I really don't like gotos when they can
be easily avoided (though they do have their place sometimes).
So I restructured the code a bit instead - as below.

Thanks,
NeilBrown

=46rom 1fc34af916a7afd0b6a6b386973a6045579ee31a Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 7 Feb 2013 11:51:21 +1100
Subject: [PATCH] make --update=3Dhomehost work again

Commit 1e2b276535cea41c348292a019bdda8a58cb1679 (Report error in --update
string is not recognised) broke homehost updating functionality because it
depended on each string comparison being done even after we already found
a match.  Make it work again by restructuring code.

Reported-by: (and original version by) Justin Maggard <jmaggard10@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/super0.c b/super0.c
index 32a9f7b..1f4dc75 100644
--- a/super0.c
+++ b/super0.c
@@ -435,6 +435,18 @@ static int update_super0(struct supertype *st, struct =
mdinfo *info,
 	int rv =3D 0;
 	int uuid[4];
 	mdp_super_t *sb =3D st->sb;
+
+	if (strcmp(update, "homehost") =3D=3D 0 &&
+	    homehost) {
+		/* note that 'homehost' is special as it is really
+		 * a "uuid" update.
+		 */
+		uuid_set =3D 0;
+		update =3D "uuid";
+		info->uuid[0] =3D sb->set_uuid0;
+		info->uuid[1] =3D sb->set_uuid1;
+	}
+
 	if (strcmp(update, "sparc2.2")=3D=3D0 ) {
 		/* 2.2 sparc put the events in the wrong place
 		 * So we copy the tail of the superblock
@@ -551,12 +563,6 @@ static int update_super0(struct supertype *st, struct =
mdinfo *info,
 		/* make sure resync happens */
 		sb->state &=3D ~(1<<MD_SB_CLEAN);
 		sb->recovery_cp =3D 0;
-	} else if (strcmp(update, "homehost") =3D=3D 0 &&
-		   homehost) {
-		uuid_set =3D 0;
-		update =3D "uuid";
-		info->uuid[0] =3D sb->set_uuid0;
-		info->uuid[1] =3D sb->set_uuid1;
 	} else if (strcmp(update, "uuid") =3D=3D 0) {
 		if (!uuid_set && homehost) {
 			char buf[20];
diff --git a/super1.c b/super1.c
index c240b91..d0f1d5f 100644
--- a/super1.c
+++ b/super1.c
@@ -885,6 +885,21 @@ static int update_super1(struct supertype *st, struct =
mdinfo *info,
 	int rv =3D 0;
 	struct mdp_superblock_1 *sb =3D st->sb;
=20
+	if (strcmp(update, "homehost") =3D=3D 0 &&
+	    homehost) {
+		/* Note that 'homehost' is special as it is really
+		 * a "name" update.
+		 */
+		char *c;
+		update =3D "name";
+		c =3D strchr(sb->set_name, ':');
+		if (c)
+			strncpy(info->name, c+1, 31 - (c-sb->set_name));
+		else
+			strncpy(info->name, sb->set_name, 32);
+		info->name[32] =3D 0;
+	}
+
 	if (strcmp(update, "force-one")=3D=3D0) {
 		/* Not enough devices for a working array,
 		 * so bring this one up-to-date
@@ -1037,16 +1052,6 @@ static int update_super1(struct supertype *st, struc=
t mdinfo *info,
 			sb->bblog_shift =3D 0;
 			sb->bblog_offset =3D 0;
 		}
-	} else if (strcmp(update, "homehost") =3D=3D 0 &&
-		   homehost) {
-		char *c;
-		update =3D "name";
-		c =3D strchr(sb->set_name, ':');
-		if (c)
-			strncpy(info->name, c+1, 31 - (c-sb->set_name));
-		else
-			strncpy(info->name, sb->set_name, 32);
-		info->name[32] =3D 0;
 	} else if (strcmp(update, "name") =3D=3D 0) {
 		if (info->name[0] =3D=3D 0)
 			sprintf(info->name, "%d", info->array.md_minor);

--Sig_/+5HQBmxjc+U44ass.Lfz+w5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBURL7CDnsnt1WYoG5AQKpXQ//SFzFYbACunMmjNm3NQAD66kpUtSfZOl3
EqXs7qI6qXooBrgh+UC8YoAhL+h4ruF+NbyJIs91Hixkim+99351HYdH2wvwYiC2
2qlNFH8rmXs31ZXqzgvwy26YWjGFDPsg7S5FAh6mWKzjsG3obzijuXDUK/Po8dNN
rn0YSHNv7tu/NAJXFr0vAjvsYayQAWtoomp5C0SzR9ymBc8jOFX1D7ttgk94N+aq
fjOFiSy7vcPp3Vh2zdeZHa1dBgF4cKr+xqrL8KH0vZT9uxMh2+6RChITHbO0H6J8
CGNkOQf0p8JNsJycfStNQ80cUeQJ9/2NlsMopkGR76G4zwXEbCDMb9K+B/QVeRxo
dbzxvve02xTdrfnQAC39gonBAYVFfhKSiWON2bYtmW1O5+QRWojgfj3v9JTRXrR0
cTu4D/RapEqqx9ruGw8HuZiyxzhL23Lv781xVmTSwUSfKVa5B+kphNRuvRTBNmvC
mvAsLV0mVPWNgyVeLS4EQtA2+JeF6oOmJBbf6/mXwpwLBRlDZsZAQh7MtCzb9haw
eDkBDWBUAlUakYIHqgqN6HUYXth7pyBIvjlVCHyeh4knwO0yD0Gq1ghH9g7grJZP
00qsF2vXL0Qmi8aZFxjT14Jxp9ftWYjdQx6nnlUCv1NUpYh2srkpwKN7W3k/5kuc
x655WDhH3Bk=
=e19l
-----END PGP SIGNATURE-----

--Sig_/+5HQBmxjc+U44ass.Lfz+w5--

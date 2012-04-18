From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Wed, 18 Apr 2012 14:25:23 +1000
Message-ID: <20120418142523.25ca6a09@notabene.brown>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
	<20120223090412.2b14fb7f@notabene.brown>
	<4F7DEB91.4060306@redhat.com>
	<20120410094130.283195dc@notabene.brown>
	<4F84C5DA.2040501@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//qyXC60XP_JCgxpcSHYVkKM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F84C5DA.2040501@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Jes.Sorensen@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_//qyXC60XP_JCgxpcSHYVkKM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Hi Doug.

Thanks for your long reply.

I would like to propose the following patch.

It addresses the issues that I am concerned about, and I don't think it
interferes with the usage patterns that you are concerned about.

Does it seems reasonable to you?

My apologies for the frustration this has cause you and your customers.

NeilBrown

commit 0a999759b54f94fd63ac0ee298a549acef6f7d6f
Author: NeilBrown <neilb@suse.de>
Date:   Wed Apr 18 14:19:49 2012 +1000

    Relax restrictions on when --add is permitted.
   =20
    The restriction that --add was not allowed on a device which
    looked like a recent member of an array was overly harsh.
   =20
    The real requirement was to avoid using --add when the array had
    failed, and the device being added might contain necessary
    information which can only be incorporated by stopping and
    re-assembling with --force.
   =20
    So change the test to reflect the need.
   =20
    Reported-by: Doug Ledford <dledford@redhat.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Manage.c b/Manage.c
index 3767f01..95aa270 100644
--- a/Manage.c
+++ b/Manage.c
@@ -448,7 +448,7 @@ int Manage_subdevs(char *devname, int fd,
 		char *dnprintable =3D dv->devname;
 		char *add_dev =3D dv->devname;
 		int err;
-		int re_add_failed =3D 0;
+		int array_failed;
=20
 		next =3D dv->next;
 		jnext =3D 0;
@@ -851,9 +851,8 @@ int Manage_subdevs(char *devname, int fd,
 								continue;
 							goto abort;
 						}
-					skip_re_add:
-						re_add_failed =3D 1;
 					}
+				skip_re_add:
 					st->ss->free_super(st);
 				}
 				if (add_dev !=3D dv->devname) {
@@ -875,12 +874,30 @@ int Manage_subdevs(char *devname, int fd,
 						dv->devname, devname);
 					goto abort;
 				}
-				if (re_add_failed) {
-					fprintf(stderr, Name ": %s reports being an active member for %s, but=
 a --re-add fails.\n",
-						dv->devname, devname);
-					fprintf(stderr, Name ": not performing --add as that would convert %s=
 in to a spare.\n",
-						dv->devname);
-					fprintf(stderr, Name ": To make this a spare, use \"mdadm --zero-supe=
rblock %s\" first.\n",=09
+				if (array.active_disks < array.raid_disks) {
+					char *avail =3D calloc(array.raid_disks, 1);
+					int d;
+					int found =3D 0;
+
+					for (d =3D 0; d < MAX_DISKS && found < array.active_disks; d++) {
+						disc.number =3D d;
+						if (ioctl(fd, GET_DISK_INFO, &disc))
+							continue;
+						if (disc.major =3D=3D 0 && disc.minor =3D=3D 0)
+							continue;
+						if (!(disc.state & (1<<MD_DISK_SYNC)))
+							continue;
+						avail[disc.raid_disk] =3D 1;
+						found++;
+					}
+					array_failed =3D !enough(array.level, array.raid_disks,=20
+							       array.layout, 1, avail);
+				} else
+					array_failed =3D 0;
+				if (array_failed) {
+					fprintf(stderr, Name ": %s has failed so using --add cannot work and =
might destroy\n",
+						devname);
+					fprintf(stderr, Name ": data on %s.  You should stop the array and re=
-assemble it.\n",
 						dv->devname);
 					if (tfd >=3D 0)
 						close(tfd);

--Sig_//qyXC60XP_JCgxpcSHYVkKM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT45CMznsnt1WYoG5AQI0ZRAAoML5DipxI4DOkMyoQ6sHAu0UxtgarXZ2
DRHh5yH8iMwcrvmfAKCAXPY091zPlxXHj3nHXREkHE3FqUmCkVWisL+s/W3Bqpnn
hMETTLBj92Hb85+EwdYeYB1LPDDJmlY6v1FmhtOjh47EUJjEUwYWVIbBS9RHM64S
o7JX7g5GRFZcK6QmDVtaEyzX/b2r3DFtayjkANWqbZYjGlL3zXREZ6rCHAJ9bjsC
sNUtIyx4T7el4XytmH/9IWm4QQJYeQResfurr9mXg3sSQ/N6S6vXmc4ams/s4NzH
ayhKKLSkUXVCY8XwTrIQyWgs3PO6EJ5HbKY342QoTO70dxya6YvnjbncUhCZW4mp
XO8sGvCGioH63+MEyVRxz3EddGQFLIJCpSwRKIDib7s1AprY7VbTgo1eMwH7qpQ2
Rs8MhPXVkVk/YqXAI7ljAuVgYUo17ZJvyOmLQBx0CJad5msVhfxvz5TX61uciR8P
o67PV0TZDbJbIaNWxyr4Sb1pFPqaT7F4nED6S67gRWj1zZnXlFgQ+k1P+wJrG+r3
Xr6Pe2fr+Bauqti/T8tCsy/5HEf/4YeAXfCBuz5uUNjkAYgeEQ3vSuCDz3HkCfDP
oiIK/8OtlZUH+ODO9BBCUmywv2gfLi8xbMu3R3rr0/uBCLWgaEQ0HWEPHOSN82oq
oJJVW+Ieu+A=
=tXVK
-----END PGP SIGNATURE-----

--Sig_//qyXC60XP_JCgxpcSHYVkKM--

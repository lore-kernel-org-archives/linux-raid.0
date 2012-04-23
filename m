From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 crashed, need comments on possible repair solution
Date: Tue, 24 Apr 2012 09:01:22 +1000
Message-ID: <20120424090122.3d90b4a6@notabene.brown>
References: <4F955F80.80903@evilazrael.de>
	<20120424070044.707745b8@notabene.brown>
	<4F95CDE0.4070200@evilazrael.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/GFpTXznzWeJyoYzV.9Tt1q="; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F95CDE0.4070200@evilazrael.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Nelles <evilazrael@evilazrael.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/GFpTXznzWeJyoYzV.9Tt1q=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Apr 2012 23:47:12 +0200 Christoph Nelles
<evilazrael@evilazrael.de> wrote:

> Hello Neil,
>=20
>=20
> first thanks for the answer. I will happily provide any data or logs if
> it helps you to investigate this problem.
>=20
>=20
> Am 23.04.2012 23:00, schrieb NeilBrown:
> > This is really worrying.  It's about the 3rd or 4th report recently whi=
ch
> > contains:
> >=20
> >>      Raid Level : -unknown-
> >>    Raid Devices : 0
> >=20
> > and that should not be possible.  There must be some recent bug that ca=
uses
> > the array to be "cleared" *before* writing out the metadata - and that =
should
> > be impossible.
> > What kernel are you running?
>=20
> I switched kernel versions during that server rebuild. Last running
> system was with 3.2.5, then rebuild and switch to 3.3.1 ant with that it
> crashed. Kernel is vanilla selfcompiled, x86_64.
> mdadm is 3.1.5, selfcompiled, too.

Thanks.
This is suggestive that it is a very recently introduced bug, and your
earlier observation that the "update time" correlated with the machine being
rebooted was very helpful.
I believe I have found the problem and have reproduced the symptom
The sequence I used to reproduce it was a bit forced and probably isn't
exactly what happened in your case.  Maybe there is a race condition that c=
an
trigger it as well.

In any case, the following patch should fix the issue, and is strongly
recommended for any kernel to which it applies.

I'll send this upstream shortly.

Of course this doesn't help you with your current problem though at least it
suggests that it won't happen again.

I recall that you said you would be re-creating the array with a chunk size
of 64k.  The default has been 512K since mdadm-3.1 in late 2009.
Did you explicitly create with "-c 64" when you created the array? If not,
maybe you need to use "-c 512".

NeilBrown



diff --git a/drivers/md/md.c b/drivers/md/md.c
index 333190f..4a7002d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8402,7 +8402,8 @@ static int md_notify_reboot(struct notifier_block *th=
is,
=20
 	for_each_mddev(mddev, tmp) {
 		if (mddev_trylock(mddev)) {
-			__md_stop_writes(mddev);
+			if (mddev->pers)
+				__md_stop_writes(mddev);
 			mddev->safemode =3D 2;
 			mddev_unlock(mddev);
 		}

--Sig_/GFpTXznzWeJyoYzV.9Tt1q=
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5XfQjnsnt1WYoG5AQJumQ//QGrwNWAFqhBQ15sPUNDuNlX0p4TqBJKK
IUs8tMdckcv3z1H67Yc2SUGP/IN2TU7xPuo5bU8xMrQJmwbOJq47JB+1Co8GA4XT
jPPV8zIAnQYd0ILOb7AAGnvy2E/9gW0AoNmUG/xRqbmt/KKQcvdiPHtL/M38PCG2
CKGd4pjMM5GcSI/skCRqvcO3/6BNm1XrLlxLUKnxoHZCveEIBmWDlBsOKBRfy87v
kfS6MRJsSf/KqI9bcj204wEemo0eNwlTGZLoQeMUbZgore7F2SzvsdCkJgLfvmuE
S4nnCxhCX9WiAIe7uKl/GRK7s9NHrDFFkBsL4vcKIu5OtYP7cSb3akR3YUqR6J37
vRCa65HNiVcUUQJhaXaq0ddOayxZS2d169iU3lGvP74toeauNlOfjv1AdUk9YNFC
mDYyPixaSTQ1ZfJqt/GMYcg/TqXm5AT2JLLZJ7eNP9qpfcfN9uG9bxXagObB8en5
1jBFidP1LLb0doig0+m+tTt3TQ+vmcqr73VwL73SLkb7DrUd6SqFEAI7aQDjvrHv
AZ1i3aI2GkG8VLNovU69VpRpZ6xYW9gtdm2eIAltOTtHBZhsNsZSWJOzvhBUpES8
855w8oBWJGtXHwG4lW1wD86urpWfMVMatR0tv4jAywgKa0dy8jhxGRvBj5LN+dZD
JttDFW7fwp8=
=Oayb
-----END PGP SIGNATURE-----

--Sig_/GFpTXznzWeJyoYzV.9Tt1q=--

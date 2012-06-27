From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Choose to replacing or recoverying when  raid
 degraded and had a want_replacement disk at the same time.
Date: Wed, 27 Jun 2012 13:47:43 +1000
Message-ID: <20120627134743.42651028@notabene.brown>
References: <201206051532527348313@gmail.com>
	<20120606112803.359c62cc@notabene.brown>
	<201206061124295788941@gmail.com>
	<20120606135543.6b233ff9@notabene.brown>
	<201206061306494539772@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LOuUfzvb=curDuvvAUFQkoX"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206061306494539772@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/LOuUfzvb=curDuvvAUFQkoX
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Jun 2012 13:06:53 +0800 majianpeng <majianpeng@gmail.com> wrote:

> >On Wed, 6 Jun 2012 11:24:34 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> On  Tue, 5 Jun 2012 18:28:13 neil wrote:
> >> >On Tue, 5 Jun 2012 15:32:56 +0800 majianpeng <majianpeng@gmail.com> w=
rote:
> >> >
> >> >> In Commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3:
> >> >> "if there is a spare and a want_replacement device, start replaceme=
nt."
> >> >> But it did not consider the raid was degraded at the same time.
> >> >> When we add spare disk in order to recovery, unless raid was ok and=
 then
> >> >> started replacement or vice versa.
> >> >>=20
> >> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> >> ---
> >> >>  drivers/md/raid5.c |   48 +++++++++++++++++++++++++++++-----------=
--------
> >> >>  1 files changed, 29 insertions(+), 19 deletions(-)
> >> >>=20
> >> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> >> index d267672..f74c9a5 100644
> >> >> --- a/drivers/md/raid5.c
> >> >> +++ b/drivers/md/raid5.c
> >> >
> >> >Good point, but the code feels a little ... clumsy.
> >> >
> >> >How about this?
> >> >
> >> >NeilBrown
> >> >
> >> >
> >> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> >index d267672..4f0861e 100644
> >> >--- a/drivers/md/raid5.c
> >> >+++ b/drivers/md/raid5.c
> >> >@@ -5465,10 +5465,9 @@ static int raid5_add_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
> >> > 	if (rdev->saved_raid_disk >=3D 0 &&
> >> > 	    rdev->saved_raid_disk >=3D first &&
> >> > 	    conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
> >> >-		disk =3D rdev->saved_raid_disk;
> >> >-	else
> >> >-		disk =3D first;
> >> >-	for ( ; disk <=3D last ; disk++) {
> >> >+		first =3D rdev->saved_raid_disk;
> >> >+
> >> >+	for (disk =3D first; disk <=3D last; disk++) {
> >> > 		p =3D conf->disks + disk;
> >> > 		if (p->rdev =3D=3D NULL) {
> >> > 			clear_bit(In_sync, &rdev->flags);
> >> >@@ -5477,8 +5476,10 @@ static int raid5_add_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
> >> > 			if (rdev->saved_raid_disk !=3D disk)
> >> > 				conf->fullsync =3D 1;
> >> > 			rcu_assign_pointer(p->rdev, rdev);
> >> >-			break;
> >> >+			goto out;
> >> > 		}
> >> >+	}
> >> >+	for (disk =3D first; disk <=3D last; disk++) {
> >> > 		if (test_bit(WantReplacement, &p->rdev->flags) &&
> >> > 		    p->replacement =3D=3D NULL) {
> >> > 			clear_bit(In_sync, &rdev->flags);
> >> >@@ -5490,6 +5491,7 @@ static int raid5_add_disk(struct mddev *mddev, =
struct md_rdev *rdev)
> >> > 			break;
> >> > 		}
> >> > 	}
> >> >+out:
> >> > 	print_raid5_conf(conf);
> >> > 	return err;
> >> > }
> >> >
> >> >
> >> I tested and found a bug.I corrected it like this.
> >
> >You've added a test for 'p->rdev !=3D NULL' - is that all?
> >
> No, I also add=20
> >> +       for (disk =3D first; disk <=3D last; disk++) {
>  +               p =3D conf->disks + disk;
> >> +               if (p->rdev !=3D NULL &&
> >> +                       test_bit(WantReplacement, &p->rdev->flags) &&
> >> +                       p->replacement =3D=3D NULL) {
> You lost :
>  p =3D conf->disks + disk;
> in next loop.
> 											=09
Ahhh... yes, of course.
I've added that to that patch.

Thanks,
NeilBrown



--Sig_/LOuUfzvb=curDuvvAUFQkoX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+qCXznsnt1WYoG5AQJgmw/+K/x3WeBq7q88j1qYSFIS6zla1FJgvY/M
kh10LxIolTFtwVtxcVZSmajztbsep63YL8zOzcxqm9s13YRUY7MX79rxpeVx6pvu
tgXp3ITB1PEJCAEyZpsRc4kBWoIdIOH1gBNyb3Sa6BtwgC76uqyvPZAjReSu7Cq9
p+hghSwyuLAA3IyH7zCG39lwLWAMtJDMh1epj9GvIYOG3ywDGor3sO26MnnpQkv5
xbteeLN6C2gDb2BH7VoM9rbNKBzcwwu9BEUMTHqZ4mwDVGKvkRS2liEy2Fkuf2qO
g8qcVbX30CGP1tRcPbbuCyylEd0VIYpRxlYRjN5SQaFTOl8Lp3f6lBHohufKsf08
S+pJ7B/RUQYLDdlFFf0agYfT0QswJrEDPj7cXDgZn5HwnKXEHYDgxiwtGA3Xu8No
T5rS3j0ppD6hP4TITGEDp45ugBNcNYfpYrtmwF0oR9DkPCcGeiT8jJ0EVkPXfn+1
DJoGukU8xAEkIG5WB9dbxcrg/O9xZK6gqj5rwMZcAfuucMiK+ky+a3EtwkrqsLZt
IKrePmQseu0u8x7r1xhYCNE3n05NqY5j4HZWAap8wOcSWG6g0Y8ppWWdK3KqXURj
2ddfN9nL92KmYY3Mm2M8kyWgV7KHSEqayfhj0cmU2jGgT4I3qjzoAJIyoHtnqm2k
Uw9CqxCzNBQ=
=4rkG
-----END PGP SIGNATURE-----

--Sig_/LOuUfzvb=curDuvvAUFQkoX--

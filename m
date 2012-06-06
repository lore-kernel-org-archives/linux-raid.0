From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid5:Choose to replacing or recoverying when  raid
 degraded and had a want_replacement disk at the same time.
Date: Wed, 6 Jun 2012 13:55:43 +1000
Message-ID: <20120606135543.6b233ff9@notabene.brown>
References: <201206051532527348313@gmail.com>
	<20120606112803.359c62cc@notabene.brown>
	<201206061124295788941@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DGwbjHxYdujxLX+59S_P4qj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201206061124295788941@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/DGwbjHxYdujxLX+59S_P4qj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 6 Jun 2012 11:24:34 +0800 majianpeng <majianpeng@gmail.com> wrote:

> On  Tue, 5 Jun 2012 18:28:13 neil wrote:
> >On Tue, 5 Jun 2012 15:32:56 +0800 majianpeng <majianpeng@gmail.com> wrot=
e:
> >
> >> In Commit 7bfec5f35c68121e7b1849f3f4166dd96c8da5b3:
> >> "if there is a spare and a want_replacement device, start replacement."
> >> But it did not consider the raid was degraded at the same time.
> >> When we add spare disk in order to recovery, unless raid was ok and th=
en
> >> started replacement or vice versa.
> >>=20
> >> Signed-off-by: majianpeng <majianpeng@gmail.com>
> >> ---
> >>  drivers/md/raid5.c |   48 +++++++++++++++++++++++++++++--------------=
-----
> >>  1 files changed, 29 insertions(+), 19 deletions(-)
> >>=20
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index d267672..f74c9a5 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >
> >Good point, but the code feels a little ... clumsy.
> >
> >How about this?
> >
> >NeilBrown
> >
> >
> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >index d267672..4f0861e 100644
> >--- a/drivers/md/raid5.c
> >+++ b/drivers/md/raid5.c
> >@@ -5465,10 +5465,9 @@ static int raid5_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
> > 	if (rdev->saved_raid_disk >=3D 0 &&
> > 	    rdev->saved_raid_disk >=3D first &&
> > 	    conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
> >-		disk =3D rdev->saved_raid_disk;
> >-	else
> >-		disk =3D first;
> >-	for ( ; disk <=3D last ; disk++) {
> >+		first =3D rdev->saved_raid_disk;
> >+
> >+	for (disk =3D first; disk <=3D last; disk++) {
> > 		p =3D conf->disks + disk;
> > 		if (p->rdev =3D=3D NULL) {
> > 			clear_bit(In_sync, &rdev->flags);
> >@@ -5477,8 +5476,10 @@ static int raid5_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
> > 			if (rdev->saved_raid_disk !=3D disk)
> > 				conf->fullsync =3D 1;
> > 			rcu_assign_pointer(p->rdev, rdev);
> >-			break;
> >+			goto out;
> > 		}
> >+	}
> >+	for (disk =3D first; disk <=3D last; disk++) {
> > 		if (test_bit(WantReplacement, &p->rdev->flags) &&
> > 		    p->replacement =3D=3D NULL) {
> > 			clear_bit(In_sync, &rdev->flags);
> >@@ -5490,6 +5491,7 @@ static int raid5_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
> > 			break;
> > 		}
> > 	}
> >+out:
> > 	print_raid5_conf(conf);
> > 	return err;
> > }
> >
> >
> I tested and found a bug.I corrected it like this.

You've added a test for 'p->rdev !=3D NULL' - is that all?

That isn't necessary.  If any p->rdev were NULL then the first loop would
find it and the second loop would never be entered.


> But I had a question:why  p->rdev not protect by rcu_read_lock?
> I think it should be.

rcu is not necessary here.  We hold mddev->mutex as does the code which
removes devices, so we cannot race with it.  We only need rcu when not
holding the mutex, and when not performing resync/recovery/etc as that
prevents ->rdev from being removed too.

Thanks,
NeilBrown



>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index d267672..24162c1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5465,10 +5465,9 @@ static int raid5_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>         if (rdev->saved_raid_disk >=3D 0 &&
>             rdev->saved_raid_disk >=3D first &&
>             conf->disks[rdev->saved_raid_disk].rdev =3D=3D NULL)
> -               disk =3D rdev->saved_raid_disk;
> -       else
> -               disk =3D first;
> -       for ( ; disk <=3D last ; disk++) {
> +               first =3D rdev->saved_raid_disk;
> +
> +       for (disk =3D first; disk <=3D last; disk++) {
>                 p =3D conf->disks + disk;
>                 if (p->rdev =3D=3D NULL) {
>                         clear_bit(In_sync, &rdev->flags);
> @@ -5477,10 +5476,15 @@ static int raid5_add_disk(struct mddev *mddev, st=
ruct md_rdev *rdev)
>                         if (rdev->saved_raid_disk !=3D disk)
>                                 conf->fullsync =3D 1;
>                         rcu_assign_pointer(p->rdev, rdev);
> -                       break;
> +                       goto out;
>                 }
> -               if (test_bit(WantReplacement, &p->rdev->flags) &&
> -                   p->replacement =3D=3D NULL) {
> +       }
> +
> +       for (disk =3D first; disk <=3D last; disk++) {
> +               p =3D conf->disks + disk;
> +               if (p->rdev !=3D NULL &&
> +                       test_bit(WantReplacement, &p->rdev->flags) &&
> +                       p->replacement =3D=3D NULL) {
>                         clear_bit(In_sync, &rdev->flags);
>                         set_bit(Replacement, &rdev->flags);
>                         rdev->raid_disk =3D disk;
> @@ -5490,6 +5494,7 @@ static int raid5_add_disk(struct mddev *mddev, stru=
ct md_rdev *rdev)
>                         break;
>                 }
>         }
> +out:
>         print_raid5_conf(conf);
>         return err;
>  }
>=20


--Sig_/DGwbjHxYdujxLX+59S_P4qj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT87Uvznsnt1WYoG5AQLqHg/+Jpc2AcGyLHw0wvW95OjGnuUSA/NEOoo8
Isrut28XmisTcaxjSF5e9TQsP7y+k5VjFdPq950W8TkCahfmh4ut83jsXW8ZcBD1
7nXcvhJ21vKYkJvpx9qztPkPeTBe3wormtQuLDI71eHE43FQ8LsY9TekszHfGeQN
ovyJ1sgPq3Mzgsmq4QgtndH/vw/GbUR9p5p71Hl5rt11ett0r9fhk9EjJd2EZ1WP
ZhsYrVTkESgdUAzGzUyFEvoWYrWdJzTVvlkO7VmbyljdW6CDfUtu9L/RFxuw27IF
+lpscL6LNeDqbkcHQW+xF5dVUYHaF3WB3FputwI01t/0OBOoevP9yS488npeBgbJ
JJfUCb+Ch80VNHy73hLlgBeJ4SfpmyTuJcyaVttkP5jKDD9K+DiJpbLV0QsCOc0a
HUSr7S4XnoKI17clpXjKii4y08JJRTlxA1F3mCKEa+IrwH79RUlkGzPcQn9UHBDx
JsPNfGkzBmfJtopxJdna3lqPTMANPnTzhSxDAtpVCaBaHU+EYhSUQ2b7hSX/ogEm
8r+lZh/TTRL22lR1RMivXayF9GSRWlLU5WmxPgGH94FQCLC/j9VchZrufNMd+3kF
l+3/ETvwpSIXdC8DWFs9X/hrwdGP+/Q88LhEOGa5Hiijg/qz4u++I+r1LwEhhcLQ
zmRbXCziKgA=
=1Qna
-----END PGP SIGNATURE-----

--Sig_/DGwbjHxYdujxLX+59S_P4qj--

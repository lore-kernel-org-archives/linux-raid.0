From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 repair: sync_request() aborts if one of the drives has
 bad block recorded
Date: Tue, 17 Jul 2012 11:17:53 +1000
Message-ID: <20120717111753.178d53d5@notabene.brown>
References: <CAGRgLy6j3pEeXGXJbVc4Sz3gdShWWfaT7hyXnurgO-6N-_E_ZA@mail.gmail.com>
	<20120716133753.1a34e149@notabene.brown>
	<CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8t4QfkgVsEBweMX56.Cs5D_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6JZXiHFg11Z-_3krj8iKp_Wk7X_wz8OyikyvhLpxzcxg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/8t4QfkgVsEBweMX56.Cs5D_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jul 2012 11:45:12 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> thanks for your comments.
>=20
> > I don't see that MD_RECOVERY_REQUESTED is really an issue is it?
> > We the wrong thing happen in any case where there just one device with =
no bad
> > block, and at least one device with a bad block.  In that case we want =
to
> > skip forward by the number of bad blocks, not skip to the end of the ar=
ray.
>=20
> I think that MD_RECOVERY_REQUESTED has some meaning here. Because
> there are only two places where we increase "write_targets":
> Here:
> 		} else if (!test_bit(In_sync, &rdev->flags)) {
> 			bio->bi_rw =3D WRITE;
> 			bio->bi_end_io =3D end_sync_write;
> 			write_targets ++;
> and
> 	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) && read_targets > 0)
> 		/* extra read targets are also write targets */
> 		write_targets +=3D read_targets-1;
>=20
> So if we'll see a device that is not In_sync, we will increase
> write_targets and won't fall into that issue. That's why I was
> thinking to check for MD_RECOVERY_REQUESTED.

But neither of the code segements you have identified depend on
MD_RECOVERY_REQUESTED.

The problem occurs with resync/repair/check but not with recover.


>=20
> >
> > So this?
> >
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 240ff31..c443f93 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -2422,7 +2422,10 @@ static sector_t sync_request(struct mddev *mddev=
, sector_t sector_nr, int *skipp
> >                 /* There is nowhere to write, so all non-sync
> >                  * drives must be failed - so we are finished
> >                  */
> > -               sector_t rv =3D max_sector - sector_nr;
> > +               sector_t rv;
> > +               if (min_bad > 0)
> > +                       max_sector =3D sector_nr + min_bad;
> > +               rv =3D max_sector - sector_nr;
> >                 *skipped =3D 1;
> >                 put_buf(r1_bio);
> >                 return rv;
> >
>=20
> I tested it and it works. However, I have a question: shouldn't we try
> to clear bad blocks during "repair" in particular or during any
> kind-of-sync in general?

Thanks for testing.


>=20
> Because currently the following is happening:
> - In sync_request devices are selected as candidates for READs and for
> WRITEs (using various criteria)
> - Then we issue the READs and eventually end up in sync_request_write()
> - Here we schedule WRITEs (without consulting bad blocks or WriteErrorSee=
n bit)
> - In end_sync_write, we check if we can clear some bad blocks, and if
> yes, eventually we end up in handle_sync_write_finished(), where we
> clear bad blocks
>=20
> So getting back to sync_request(), the issue is this: if we consider a
> device for READs, we check for badblocks. If we find a badblock, we
> skip it and don't consider this device neither for READs nor for
> WRITEs. How about:
> - We consider a device for READs
> - If it has a bad block, we consider it for WRITEs instead (so we have
> a 3rd place where we consider the device for WRITE).
> - We may consult WriteErrorSeen bit as we do in normal make_request(),
> but not sure, because right now on sync path, we don't consult it

Good point.
I think we should consider WriteErrorSeen here.  We don't currently consult
it in sync because we avoid bad blocks completely.
So you patch would become:

  } else if (!test_bit(WriteErrorSeen, &rdev->flags)) {
         bio->bi_rw =3D WRITE;
         bio->bi_end_io =3D end_sync_write;
         write_targets++;
  }

If you could confirm that works and resubmit it with a 'Signed-off-by:' line
I'll apply it.
Thanks.
I've already included my previous patch in my queue and tagged it for -stab=
le.

NeilBrown

>=20
> So this patch:
> --- c:/work/code_backups/psp13/raid1.c  Sun Jul 15 16:39:07 2012
> +++ ubuntu-precise/source/drivers/md/raid1.c    Mon Jul 16 11:35:40 2012
> @@ -2385,20 +2385,25 @@
>                                         if (wonly < 0)
>                                                 wonly =3D i;
>                                 } else {
>                                         if (disk < 0)
>                                                 disk =3D i;
>                                 }
>                                 bio->bi_rw =3D READ;
>                                 bio->bi_end_io =3D end_sync_read;
>                                 read_targets++;
>                         }
> +                       else {
> +                               bio->bi_rw =3D WRITE;
> +                               bio->bi_end_io =3D end_sync_write;
> +                               write_targets ++;
> +                       }
>                 }
>                 if (bio->bi_end_io) {
>                         atomic_inc(&rdev->nr_pending);
>                         bio->bi_sector =3D sector_nr + rdev->data_offset;
>                         bio->bi_bdev =3D rdev->bdev;
>                         bio->bi_private =3D r1_bio;
>                 }
>         }
>         rcu_read_unlock();
>         if (disk < 0)
>=20
>=20
> I tested this patch (together with yours) and it cleared the bad
> blocks, but not sure what else I might be missing. My Linux kernel
> programming skills are still ... questionable.
>=20
> Thanks,
> Alex.
>=20
>=20
>=20
> >
> > Thanks,
> > NeilBrown
> >


--Sig_/8t4QfkgVsEBweMX56.Cs5D_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUAS9QTnsnt1WYoG5AQLGXRAAnn0nITH6lGrEkNvi05Xa58t6PVrAZ7x9
jKNV5etcxWZsf7R/Xiho1P5Lu6yWiEEbXDoutNaT23FeTjnDIkl4pFuBUgZr2ct+
3T51VNJN/U4CAdQh6+rX71HdqrYBwpa1IvZI6PSt93m1Lui6cXpa46CM4gCMPiaF
l+0SkAJjdyKsHeVDkxSkyVpMTnTay2UN05qjHjsbrKKdGJ4qehEDEWAFcg+s2LvZ
/oo70BFKIhvalQCFmUAfTRbvdv2BrDHpj2IYrEt+LDIEP+bht90OVvv7HVv4EW1Z
OR5pgxuuwFqpzM/xvB+EEGZrG+AYRZ8YZ4MBTI6InwCbW0h8NUDIZRczgSYTOLjW
zhgyvo21s2qQ/BPUTI2rF9lDqELCboO7WSJ/f/syA4Hon7MDW6ch7AkKV/5f57e1
iTgLWBraSJhrSAy6QCyHmsWyefaRwqCX6dbFzZZ8Tk5KlawHaoY4Ehngey6M+LjY
BxcRBEeKNubuwn7pFR2r1s4vo+uBW8yifl741E4ZNJtriewir7KYjRM+P1os9UeK
Jv8mAg/cpxRAW7liBCt+tuWWAVkFjeaA6mq/2seDbvYaVq/KpKPb89lSQwHtZjv5
MFSRsRmc2mEtpy1fADl03AAkP333aHqICNTqzWLXK+cdDX2hrQdtlgqo9tErxCZr
mbnUkPYxm5s=
=7pXY
-----END PGP SIGNATURE-----

--Sig_/8t4QfkgVsEBweMX56.Cs5D_--

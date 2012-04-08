From: NeilBrown <neilb@suse.de>
Subject: Re: doubt in chunk_aligned_read()
Date: Mon, 9 Apr 2012 09:29:44 +1000
Message-ID: <20120409092944.7765c281@notabene.brown>
References: <CANSbrrp_LByxog3q265ruHxJxxJRhE2SfvPgzx8EK4FyL-7KOg@mail.gmail.com>
	<20120405113800.4a1da21e@notabene.brown>
	<CANSbrrpP-Bt96NFRX5WO1QvVHsQciP2G1H+RoQi8NPJ-RF1JCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TwNiu4lwZT9XyWzfyw7bbBR"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSbrrpP-Bt96NFRX5WO1QvVHsQciP2G1H+RoQi8NPJ-RF1JCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anuj Goel <talk2anuj@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/TwNiu4lwZT9XyWzfyw7bbBR
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Apr 2012 15:47:01 -0400 Anuj Goel <talk2anuj@gmail.com> wrote:

> Thanks for the hint !!
>=20
> I have few more doubts in the function,
>=20
> static int chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio)
>=20
> if all the preliminary checks pass, we increment active_aligned_reads
> and call generic_make_request() which will add this bio to the
> "current->bio_list".
> This being an asynchronous read, chunk_aligned_read returns and the
> result of the read will be notified by the registered callback
> function "raid5_align_endio".
> Based on this understanding, I have some questions below:
>=20
> 1. How and when is the read from the disk initiated ?

When the original q->make_request_fn call into raid5 returns,
generic_make_request will notice the request on current->bio_list
(bio_list_pop will pop it off) and its ->make_request_fn will be called.


>=20
> 2. The bio passed to raid5_align_endio() is the one which was cloned
> in chunk_aligned read(). The below statement in raid5_align_endio()
> extracts the original bio :
> struct bio* raid_bi  =3D bi->bi_private;
> My doubt is in the assignment,
> rdev =3D (void*)raid_bi->bi_next;
> raid_bi is the original bio and its bi_next field should have been
> pointing to the next bio in the request queue "current->bio_list"  (if
> active_aligned_reads is > 0 ). How can this point to a rdev structure
> ? Or better put,  where do we make the bio->bi_next point to a rdev
> struct ?

When ->make_request_fn is called, bi_next must be NULL.  It will no longer =
be
on the current->bio_list (it was popped off if it was ever on).

See:
		raid_bio->bi_next =3D (void*)rdev;
in chunk_aligned_read.  Note that raid_bio doesn't get added to
current->bio_list, align_bi does.  So the rdev on raid_bi->bi_next is safe.


>=20
> 3. after this, we have,
>     i) mddev =3D rdev->mddev;
>     ii) conf =3D mddev->private;
>     iii) rdev_dec_pending(rdev, conf->mddev);
> In the call in line iii) we could have just sent the mddev retrieved
> in line i). I am curious if there is a specific reason for reading it
> again from the raid configuration struct "conf" ? Could there be a
> case when mddev in line i) can be different from the conf->mddev in
> line iii)  ??

No.  Just clumsy coding.
iii should be
       rdev_dec_pending(rdev, mddev);

NeilBrown


>=20
> On Wed, Apr 4, 2012 at 9:38 PM, NeilBrown <neilb@suse.de> wrote:
> > On Wed, 4 Apr 2012 21:25:53 -0400 Anuj Goel <talk2anuj@gmail.com> wrote:
> >
> >> HI Guys,
> >>
> >> Why is the below call needed in the function =A0chunk_aligned_read()
> >>
> >> =A0 =A0 =A0 align_bi =3D bio_clone_mddev(raid_bio, GFP_NOIO, mddev);
> >>
> >> Why do we need to create a clone of the bio passed to
> >> chunk_aligned_read(mddev_t *mddev, struct bio * raid_bio) ??
> >
> > Think about what happens if the read fails.
> >
> > NeilBrown
> >
> >
> >>
> >> --
> >> Best Regards,
> >> Anuj Goel
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
> >
>=20
>=20
>=20


--Sig_/TwNiu4lwZT9XyWzfyw7bbBR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4IfaDnsnt1WYoG5AQKgiQ/9HbxXmEKXpXEZOTxkgc01jUsdr3+QcBZN
fDAaJGviv4yViUbXe1ahQKhOSuoG+Wyk+22gNE5oLB+Yf86xGgBIL3INV9Al+1fh
JUYrzDmTJiw93FXxeYWH7zHFYaixEMCQt0Hn6DLSnVYoDHN3OhGbL1Vp9ahvbl62
2pa377jxfuQCJheEp5UxQnvW39GKI5409vIANWjVtCs6QDT7thTftUemu68D36zK
sjsUVXRiJpJkz5/I1UP0yuGSVrw+M2y0EljdyTGJY7TmTGVqEzmgwY1kwR7qSCap
rpE4VrCafeOaaGFukNanrRlPDFN1rrzBAK4sa0pjErUvNeUHdJBrhnm10/daJk9r
brGOkSYzJE0fA85VqH3PWBH4g+AotY0AiAS999gjwd4ckRYcDpJhUNDU/cimmRfi
Oo8IfWHHxGM5rUCD6mrSkijV0UKcY0Lm/W5gi+7+enDi0qXEASZCYnWQ/PVJU6bK
h/BA1c8/bh1o/PPZFqHipAfDBcHFy4irvc75f8Iz9lgpRMttSEll3951wNIIdK3R
jqv5EWT77EQU8fBQRj6T1QgEHJhfwN77ufFeJuwGLrbyr6HCpQn3LvgFqYM5eYFl
SlZX/yIqwZQCD3NaC0/Vr/rFibzbSQGbmUm7NVPitzY30c8KNSEnRZafyZ3Bk4oO
rXs2McFLfe0=
=6kMW
-----END PGP SIGNATURE-----

--Sig_/TwNiu4lwZT9XyWzfyw7bbBR--

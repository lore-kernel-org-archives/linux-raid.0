From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Thu, 15 Dec 2011 17:18:50 +1100
Message-ID: <20111215171850.335da016@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ofn8=lvhMdjrXMOe6sGfykp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfWEnLnvrShVp3BL+WsEApS+nsWBZfao-qM2_habqFCtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ofn8=lvhMdjrXMOe6sGfykp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Dec 2011 14:18:51 -0800 Dan Williams <dan.j.williams@intel.com>
wrote:

> On Tue, Oct 25, 2011 at 6:43 PM, NeilBrown <neilb@suse.de> wrote:
> > The following series - on top of my for-linus branch which should appea=
r in
> > 3.2-rc1 eventually - implements hot-replace for RAID4/5/6. =C2=A0This i=
s almost
> > certainly the most requested feature over the last few years.
> > The whole series can be pulled from my md-devel branch:
> > =C2=A0 git://neil.brown.name/md md-devel
> > (please don't do a full clone, it is not a very fast link).
>=20
> Some belated comments based on the commit ids at the time:
>=20
> 88eeb3d md: refine interpretation of "hold_active =3D=3D UNTIL_IOCTL".
> 9c22832 md: take a reference to mddev during sysfs access.
> a7d6ae4 md: remove test for duplicate device when setting slot number.
> 6deecf2 md: change hot_remove_disk to take an rdev rather than a number.
>=20
> last 4 reviewed-by.

Thanks.  I've annotated the two that haven't gone upstream yet.


>=20
> f248f8c md: create externally visible flags for supporting hot-replace.
>=20
> 'replaceable' just strikes me as a confusing name as all devices are
> nominally "replaceable", but whether you want it to be actively
> replaced is a different consideration.  What about "incumbent" to mark
> the disk as currently holding a position we want it to vacate and
> remove any potential confusion with 'replacement'.

Fair point.  I had wondered if I should not have the flag and just use the
"write_error" flag.  However the meaning is slightly different.

I don't really like "incumbent" as it gives no indication that there is a
desire to replace the device.  Maybe "want_replacement" ??

>=20
> ce8fd05 md/raid5: allow each slot to have an extra replacement device
> fd7557d md/raid5: raid5.h cleanup
> 15e9a58 md/raid5: remove redundant bio initialisations.
>=20
> last 3 reviewed-by.

Thanks.


>=20
> 37aebb5 md/raid5: preferentially read from replacement device if possible.
>=20
> +                       /* This flag does not apply to '.replacement'
> +                        * only to .rdev, so make sure to check that*/
> +                       struct md_rdev *rdev2 =3D rcu_dereference(
> +                               conf->disks[i].rdev);
> +                       if (rdev2 =3D=3D rdev)
> +                               clear_bit(R5_Insync, &dev->flags);
> +                       if (!test_bit(Faulty, &rdev2->flags)) {
>=20
> can't rdev2 be NULL here?

Uhm... probably.  I've added a test for rdev2 like I have in the "MadeGood"
case below.

Thanks.


>=20
> @@ -4201,7 +4241,6 @@ static int  retry_aligned_read(struct r5conf
> *conf, struct bio *raid_bio)
>                         return handled;
>                 }
>=20
> -               set_bit(R5_ReadError, &sh->dev[dd_idx].flags);
>                 if (!add_stripe_bio(sh, raid_bio, dd_idx, 0)) {
>                         release_stripe(sh);
>                         raid5_set_bi_hw_segments(raid_bio, scnt);
>=20
>=20
> Should this one liner be broken out for -stable?

Uhmm... maybe.  If the array is degraded we'll hit problems soon anyway, and
if it isn't, the read-errors will all soon be fixed up.

Do you see a particular problem that this fixes that is already possible
without hot-replace?

>=20
> 8e2c0f9 md/raid5: allow removal for failed replacement devices.
> 17df00a md/raid5: writes should get directed to replacement as well as or=
iginal.
>=20
> last 2 reviewed-by

Thanks.


>=20
> dba5a681 md/raid5:  detect and handle replacements during recovery.
>=20
> This one got me looking back to recall the rules about when
> rcu_deference must be used for an rdev (the ones outlined in commit
> 9910f16a "md: fix up some rdev rcu locking in raid5/6").  But the
> casual future reader may have a hard time finding that commit.  Maybe
> we could introduce our own rdev_deref() macro so that sparse and
> lockdep can automatically validate rdev derefences like below.
>=20
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 8d8e139..6023583 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -357,9 +357,14 @@ enum {
>=20
>=20
>  struct disk_info {
> -       struct md_rdev  *rdev, *replacement;
> +       struct md_rdev __rcu *rdev,
> +       struct md_rdev __rcu *replacement;
>  };
>=20
> +#define rdev_deref(p, md, sh) \
> +       rcu_dereference_check((p), (md) ? mddev_is_locked(md) : 1 || \
> +                                  (sh) ? test_bit(STRIPE_SYNCING,
> &(sh)->state) : 1)
> +
>  struct r5conf {
>         struct hlist_head       *stripe_hashtbl;
>         struct mddev            *mddev;
>=20
> ...but not sure if it's worth the code uglification.

No, I'm not sure either... If it comes up again I might...

>=20
>=20
> Nit, not sure if it's worth fixing but this one introduces some
> inconsistent line wrapping around logical operators... "at the end" vs
> "beginning of next line"
>=20
> +               if (rdev
> +                   && !test_bit(Faulty, &rdev->flags)
> +                   && !test_bit(In_sync, &rdev->flags)
> +                   && !rdev_set_badblocks(rdev, sh->sector,
> +                                          STRIPE_SECTORS, 0))
> +                       abort =3D 1;
> +               rdev =3D conf->disks[i].replacement;
> +               if (rdev
> +                   && !test_bit(Faulty, &rdev->flags)
> +                   && !test_bit(In_sync, &rdev->flags)
> +                   && !rdev_set_badblocks(rdev, sh->sector,
> +                                          STRIPE_SECTORS, 0))
>                         abort =3D 1;
>         }
>         if (abort) {
> @@ -2456,6 +2475,22 @@ handle_failed_sync(struct r5conf *conf, struct
> stripe_head *sh,
>         }
>  }
>=20
> +static int want_replace(struct stripe_head *sh, int disk_idx)
> +{
> +       struct md_rdev *rdev;
> +       int rv =3D 0;
> +       /* Doing recovery so rcu locking not required */
> +       rdev =3D sh->raid_conf->disks[disk_idx].replacement;
> +       if (rdev &&
> +           !test_bit(Faulty, &rdev->flags) &&
> +           !test_bit(In_sync, &rdev->flags) &&
> +           (rdev->recovery_offset <=3D sh->sector ||
> +            rdev->mddev->recovery_cp <=3D sh->sector))
> +               rv =3D 1;
> +
> +       return rv;

Thanks.
I almost always prefer 'at the start' as import things should be obvious.
So I have updated 'want_replace'.


>=20
> 2693b9e md/raid5: handle activation of replacement device when
> recovery completes.
>=20
> I questioned not needing a barrier in raid5_end_write_request after
> finding conf->disks[i].replacement =3D=3D NULL until I found the note in
> raid5_end_read_request about the rdev being pinned until all i/o
> returns.  Maybe a similar note to raid5_end_write_request?

I like adding explanatory notes ... but I'm not quite sure what you are
suggesting here.  Could you be a little more explicit?  Thanks.

>=20
> d6db3d0 md/raid5: recognise replacements when assembling array.
> 6cdb4fb md/raid5: If there is a spare and a replaceable device, start
> replacement.
> 0124565 md/raid5: Mark device replaceable when we see a write error.
>=20
> last 3 reviewed-by.

Thanks.


>=20
> 058c478..678a66d
> raid10 and raid1 patches not reviewed.

That's what a Christmas break is for, isn't it??

Thanks for all the review - I really appreciate it.

NeilBrown

--Sig_/ofn8=lvhMdjrXMOe6sGfykp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTumRSjnsnt1WYoG5AQIMrg/+JmqiFg7e9nw68QBi/3pM1irlHfvFccfS
FaIt/N2/PxRfxiXMoHEpERh9tGLAaZr7oD/ZU6ckO5aRqZVixGfDKKdam80myOah
BKivUtaDLbJxw7LNQxMw535TLb0HDCMy9o6gsWd+u7Mv1YAPDfoSMyoTHZRV8xy3
q54UFICNFwdQMSiovIJwV9OLNmKok3WOrlzGJeF0oOetNUT9p2FizhI3PIRPUSYI
D7kDZsXqIM3sRRGCva0e8TowYtYFg5knOTUmsFmvm/IaSRerG+5Xf8ln7GhVShfk
ft8tE9VRRP0EJ8izuU4CkqkEh6effV3xGyu7dWGdkLSM5y/GBZNCuNOvNJvYGUJ0
OFSQVX79C3D9Y1s2+NNaMWgZdoyBSS1TiCFMIfkq0jd62jcHqBUWj8JLPKu1ChV9
3+6qYGQFbAVD8Yu4i5a5hI1pZvZXKWCfLvPokO187zM/MloQgD3NetNoX7O1vXTl
ptBIebQu3SzgqqOIel1BWyePaFzb6Hz5IYASujMabNS7ueDOa6fETVcUS5tVAfj0
K2hi3cMQhzKl1AoeTEdEBj2ULkvh0iBCVefDjGqQDVoy369Q2RU3yYCei4jwvYE8
Sm9l+23vzWz7aExGidLRrDyBTBNy3ZU/9iUpA3cqIctBhsLXpkoW2A/Po83jOwHB
BOShFmvPL6M=
=s+tX
-----END PGP SIGNATURE-----

--Sig_/ofn8=lvhMdjrXMOe6sGfykp--

From: NeilBrown <neilb@suse.de>
Subject: Re: raid5: direct IO and md_wakeup_thread
Date: Mon, 8 Sep 2014 16:46:15 +1000
Message-ID: <20140908164615.0a7eb26d@notabene.brown>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735864357D@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/a_k0ANt_XPAW1vHKbtjpHVq"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD1735864357D@EXCHANGE.collogia.de>
Sender: linux-raid-owner@vger.kernel.org
To: Markus Stockhausen <stockhausen@collogia.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/a_k0ANt_XPAW1vHKbtjpHVq
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 5 Sep 2014 17:52:53 +0000 Markus Stockhausen
<stockhausen@collogia.de> wrote:

> Hi Neil,
>=20
> I hope you are doing better after the flu. Maybe you find some time=20
> to explain the following codings in raid5.c to me. At least one of
> the patchs seems to be signed off by you. The RAID5 I'm using has=20
> default settings.
>=20
> 1) Generally speaking of md_wakup_thread() calls. Does it make
> any sense to call them the from within raid5d()? Or when being=20
> implemented at locations that might be called from the=20
> make_request() path too - for simplicity no further caller destinction=20
> was programmed.

I doesn't make sense to all md_wakeup_thread() from somewhere that is *only*
called within raid5d().  However most of raid5d() is handle_stripe() and
handle_stripe() is called from other places.  So it could make sence to call
md_wakeup_thread from within handle_stripe().

make_request() very likely wants to call md_wakeup_thread().... though I'm
wondering if I understand that part of the question properly.

> =20
> 1) In case of a single direct I/O writer to the /dev/md0 device the=20
> following coding will always fire the md_wakeup_thread(). That
> is one reason for alternating raid5d loops one with data to=20
> process and the next without. Is that corner case wanted?

Is this a problem?  We often do things just in case they are needed,
providing the cost isn't too great.

If there was a measurable cost it might make sense to=20

    clear_bit(THREAD_WAKEUP, &mddev->thread->flags);

in raid5d() at the top of the while loop in raid5d().  We would need to move
the md_check_recovery() call to the end of the function then.

>=20
> static void handle_stripe(struct stripe_head *sh)
>         ...
>         ops_run_io(sh, &s);
>=20
>         if (s.dec_preread_active) {
>                 /* We delay this until after ops_run_io so that if make_r=
equest
>                  * is waiting on a flush, it won't continue until the wri=
tes
>                  * have actually been submitted.
>                  */
>                 atomic_dec(&conf->preread_active_stripes);
>                 if (atomic_read(&conf->preread_active_stripes) <
>                     IO_THRESHOLD)
>                         md_wakeup_thread(conf->mddev->thread); */
>         }
>=20
> 2) The wakeup_thread() in the following preread path seems
> to be unnecesary or will a double call wake the thread twice?

Unnecessary in some cases, necessary in others.  Tracking exactly when it is
necessary would be complex and error prone.

Are you just trying to understand the code, or is there something that you
think is a problem that could be fixed?

Thanks,
NeilBrown


>=20
> void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>                               struct list_head *temp_inactive_list, int m=
stwake)
> {
>         BUG_ON(!list_empty(&sh->lru));
>         BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>         if (test_bit(STRIPE_HANDLE, &sh->state)) {
>                 if (test_bit(STRIPE_DELAYED, &sh->state) &&
>                     !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
>                         list_add_tail(&sh->lru, &conf->delayed_list);
>                         if (atomic_read(&conf->preread_active_stripes)
>                             < IO_THRESHOLD)
>                                 md_wakeup_thread(conf->mddev->thread);
>                 } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>                         ...
>                 }
>                 md_wakeup_thread(conf->mddev->thread);
>                 ...
>=20
> Thanks in advance.
>=20
> Markus

--Sig_/a_k0ANt_XPAW1vHKbtjpHVq
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA1QuDnsnt1WYoG5AQK8Yg//WBCtjHcjCu+PH4SxDNnyFkkUQ0b7Txdl
hDbnUW5wAdRZGvhkmGpwbhUoad0aQXdjLwYFMsrUpGZLwxHozsP3Lp1KvE/+5lLr
XlSLmAvAL6LgHfX0lk2lOW9Vn5CK0JeuVu5XuXOypEdd5JSmt+EPdC3KQJu/qyg1
jEt3uACiTGM3h3XGZz2TDZlU16L4smzzpQaEkrZSDOEuu1fzX05MVqKstTTCm8Dd
3t7sydgcYDKRc1j5dFK0yApe9ks+bno41FzhdhJBcS3FE72iThRrDDE4ZtzT1Vj7
TMRfQEQq1yPDKYIVO4uEreDfEYnP3KO9OXc59ReBjcQM0ePnHk/jHVkCZUngPxjO
V88XxQDwhenT4nK6PEX3CgGa6vxOORRGbHyAzkDbRL/w103zNxX4PL+8J5PD6QUo
XH86OR0Ho8IyPDbCR3/QjlHwxtTvPZQGluf7d2rGXRRrfetBvs4Bdkbn5ARH7q11
3lPDpD9dFiGvtVQZo00b6C1oKR5pxBgdZjCAjrVPHnFq6zHAGXkh1i+86x6wSNNL
RoZffKYueEJfo3OKA0uJXNi6C59Jlqt12lDiFzj8krsXCOvw0OT9bCoTwRbRHl93
Q7OypKya4zOv5od4brSHNr22mHZuwF+NcKKvhkY1VpqYmGd8TGcmwZd98uXHZPRh
UhkzhhAxrVk=
=5TEo
-----END PGP SIGNATURE-----

--Sig_/a_k0ANt_XPAW1vHKbtjpHVq--

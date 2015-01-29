From: NeilBrown <neilb@suse.de>
Subject: Re: superfluous md_wakeup_thread()
Date: Thu, 29 Jan 2015 14:28:16 +1100
Message-ID: <20150129142816.32b1f7dc@notabene.brown>
References: <wrfjmw5s51gk.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/T_gqnf9pJ8/ellDcGFuqo2m"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmw5s51gk.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/T_gqnf9pJ8/ellDcGFuqo2m
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Jan 2015 17:53:15 -0500 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> Neil,
>=20
> I was looking over some md patches, and in
> commit 67f455486d2ea20b2d94d6adf5b9b783d079e321
> Author: NeilBrown <neilb@suse.de>
> Date:   Wed May 28 13:39:22 2014 +1000
>=20
>     md/raid56: Don't perform reads to support writes until stripe is read=
y.
>    =20
> You add the following:
>=20
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index ad1b9be..c1e8607 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -292,9 +292,12 @@ static void do_release_stripe(struct r5conf *conf, s=
truct stripe_head *sh,
>         BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
>         if (test_bit(STRIPE_HANDLE, &sh->state)) {
>                 if (test_bit(STRIPE_DELAYED, &sh->state) &&
> -                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
> +                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
>                         list_add_tail(&sh->lru, &conf->delayed_list);
> -               else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
> +                       if (atomic_read(&conf->preread_active_stripes)
> +                           < IO_THRESHOLD)
> +                               md_wakeup_thread(conf->mddev->thread);
> +               } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
>                            sh->bm_seq - conf->seq_write > 0)
>                         list_add_tail(&sh->lru, &conf->bitmap_list);
>                 else {
>=20
> However the additional md_wakeup_thread() seems unecessary as the
> resulting code now reads (pasted from current upstream):
>=20
> static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
>                               struct list_head *temp_inactive_list)
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
>                            sh->bm_seq - conf->seq_write > 0)
>                         list_add_tail(&sh->lru, &conf->bitmap_list);
>                 else {
>                         clear_bit(STRIPE_DELAYED, &sh->state);
>                         clear_bit(STRIPE_BIT_DELAY, &sh->state);
>                         if (conf->worker_cnt_per_group =3D=3D 0) {
>                                 list_add_tail(&sh->lru, &conf->handle_lis=
t);
>                         } else {
>                                 raid5_wakeup_stripe_thread(sh);
>                                 return;
>                         }
>                 }
>                 md_wakeup_thread(conf->mddev->thread);
>=20
> Is there a reason to wake the thread twice?

Nope.  No reason at all.  Clearly I need to find a way to get people to
review my patches *before* I commit them....
Maybe I should try posting them to the list more :-)

Would you like to send a patch to revert that pointless change?

Thanks,
NeilBrown

--Sig_/T_gqnf9pJ8/ellDcGFuqo2m
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVMmo0Dnsnt1WYoG5AQIN8RAAvxE+COUNeZJOwTh3jUT6t47MjWM596sh
vByyvjiKXoC8X9yt6GmCf83l8GL+/3vbjAcQtPhJZ8klILRIgk1WbBq9Z+yCmOjg
zBk1fSw2qQtWfUmiJal51UytwvYDBRvniz5LPbzt5z1eV8VTXVSWDobBcVoiFGVi
c98DLhjMkv4ri0Tt6Aqmr+jgzbbBnyIWpfgb+1Txvg7BXi9CbqWstZya4Ezs98/8
iy4urf3Ww6T7/HQLC7nLyB/sCImXM/2vGIbeJwpUBuxAbEVhbx0cFttXaGGJYvat
DYaKz8Xy27zoXgoPsBOUVVhuiPqheTdQOZRnv5TgtX1BKZcy1Xh13ZhY4g++zOUM
m53ZJ2A2zHHgTbgkANAFmTFJ9lA3PIvfXkGREhFZQvTnrDKsWwKYKR5JbWLLb43J
ZxVjzfDDGcViBM8J/FZVCc7nVN6ZMmtf77+qM0r+2t+Ze+XN8QVcCcd7aJ8WyUGh
LGGWIx/JPpIIZgVMapYN9iPUUapcL2yRUmRtix4BEDf4c90BziLEkTlu/hbdNMAx
M847u3kXFLYNkvVriE/TQgPeyTDuBds/1FQuKUEJxo+xJi4ykrFS3YSnKIAMpp0M
phKxTVPEnp7yPRSyox1gNzJwc4Blgfm9v/KZT5YjFcqHU7TyKQClOv/gD+gLoGfE
6a9PbGrfStE=
=BYeH
-----END PGP SIGNATURE-----

--Sig_/T_gqnf9pJ8/ellDcGFuqo2m--

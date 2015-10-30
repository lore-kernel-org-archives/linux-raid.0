From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Fri, 30 Oct 2015 09:25:32 -0700
Message-ID: <20151030162443.GA31413@kernel.org>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru>
 <87r3kebjgx.fsf@notabene.neil.brown.name>
 <30651446128148@webcorp02d.yandex-team.ru>
 <87ziz1w33r.fsf@notabene.neil.brown.name>
 <47541446213767@webcorp02e.yandex-team.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47541446213767@webcorp02e.yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 30, 2015 at 05:02:47PM +0300, Roman Gushchin wrote:
> > Isn't the 4.1 fix just:
> >
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index e5befa356dbe..6e4350a78257 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -3522,16 +3522,16 @@ returnbi:
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* no updated =
data, so remove it from hash list and the stripe
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0* will be rei=
nitialized
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0*/
> > - spin_lock_irq(&conf->device_lock);
> > =A0unhash:
> > + spin_lock_irq(conf->hash_locks + sh->hash_lock_index);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0remove_hash(sh);
> > + spin_unlock_irq(conf->hash_locks + sh->hash_lock_index);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (head_sh->bat=
ch_head) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0sh =3D list_first_entry(&sh->batch_list,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
struct stripe_head, batch_list);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0if (sh !=3D head_sh)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto unhash;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> > - spin_unlock_irq(&conf->device_lock);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0sh =3D head_sh;
> >
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (test_bit(STR=
IPE_SYNC_REQUESTED, &sh->state))
> >
> > ??
>=20
> In my opion, this patch looks correct, although it seems to me, that =
there is an another issue here.
>=20
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0if (head_sh->bat=
ch_head) {
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0sh =3D list_first_entry(&sh->batch_list,
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
struct stripe_head, batch_list);
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0if (sh !=3D head_sh)
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0goto unhash;
> > =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0}
> =20
> With a patch above this code will be executed without taking any lock=
s. It it correct?
> In my opinion, we need to take at least sh->stripe_lock, which protec=
ts sh->batch_head.
> Or do I miss something?
>=20
> If you want, we can handle this issue separately.

The batch_list list doesn't need the protection. Only the remove_hash()=
 need it.

Thanks,
Shaohua

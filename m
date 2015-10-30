From: Roman Gushchin <klamm@yandex-team.ru>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Fri, 30 Oct 2015 17:02:47 +0300
Message-ID: <47541446213767@webcorp02e.yandex-team.ru>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru> <87r3kebjgx.fsf@notabene.neil.brown.name> <30651446128148@webcorp02d.yandex-team.ru> <87ziz1w33r.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87ziz1w33r.fsf@notabene.neil.brown.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Shaohua Li <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Isn't the 4.1 fix just:
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e5befa356dbe..6e4350a78257 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3522,16 +3522,16 @@ returnbi:
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A* no updated da=
ta, so remove it from hash list and the stripe
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A* will be reini=
tialized
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A*/
> - spin_lock_irq(&conf->device_lock);
> =9Aunhash:
> + spin_lock_irq(conf->hash_locks + sh->hash_lock_index);
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aremove_hash(sh);
> + spin_unlock_irq(conf->hash_locks + sh->hash_lock_index);
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (head_sh->batch=
_head) {
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Ash =3D list_first_entry(&sh->batch_list,
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
struct stripe_head, batch_list);
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Aif (sh !=3D head_sh)
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Agoto unhash;
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A}
> - spin_unlock_irq(&conf->device_lock);
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Ash =3D head_sh;
>
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (test_bit(STRIP=
E_SYNC_REQUESTED, &sh->state))
>
> ??

In my opion, this patch looks correct, although it seems to me, that th=
ere is an another issue here.

> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (head_sh->batch=
_head) {
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Ash =3D list_first_entry(&sh->batch_list,
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
struct stripe_head, batch_list);
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Aif (sh !=3D head_sh)
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Agoto unhash;
> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A}
=20
With a patch above this code will be executed without taking any locks.=
 It it correct?
In my opinion, we need to take at least sh->stripe_lock, which protects=
 sh->batch_head.
Or do I miss something?

If you want, we can handle this issue separately.


Thanks,
Roman

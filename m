From: Roman Gushchin <klamm@yandex-team.ru>
Subject: Re: [PATCH] md/raid5: fix locking in handle_stripe_clean_event()
Date: Sat, 31 Oct 2015 15:25:42 +0300
Message-ID: <102381446294342@webcorp02e.yandex-team.ru>
References: <1446022340-1453-1-git-send-email-klamm@yandex-team.ru> <87r3kebjgx.fsf@notabene.neil.brown.name> <30651446128148@webcorp02d.yandex-team.ru> <87ziz1w33r.fsf@notabene.neil.brown.name> <47541446213767@webcorp02e.yandex-team.ru> <20151030162443.GA31413@kernel.org> <877fm4vw6j.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877fm4vw6j.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Shaohua Li <shli@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Ok, thank you for clarifications!

--
Roman


31.10.2015, 01:17, "Neil Brown" <neilb@suse.de>:
> On Sat, Oct 31 2015, Shaohua Li wrote:
>
>> =9AOn Fri, Oct 30, 2015 at 05:02:47PM +0300, Roman Gushchin wrote:
>>> =9A> Isn't the 4.1 fix just:
>>> =9A>
>>> =9A> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>> =9A> index e5befa356dbe..6e4350a78257 100644
>>> =9A> --- a/drivers/md/raid5.c
>>> =9A> +++ b/drivers/md/raid5.c
>>> =9A> @@ -3522,16 +3522,16 @@ returnbi:
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A* no upd=
ated data, so remove it from hash list and the stripe
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A* will b=
e reinitialized
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A*/
>>> =9A> - spin_lock_irq(&conf->device_lock);
>>> =9A> =9Aunhash:
>>> =9A> + spin_lock_irq(conf->hash_locks + sh->hash_lock_index);
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aremove_hash=
(sh);
>>> =9A> + spin_unlock_irq(conf->hash_locks + sh->hash_lock_index);
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (head_sh=
->batch_head) {
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9Ash =3D list_first_entry(&sh->batch_list,
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Astruct stripe_head, batch_list);
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9Aif (sh !=3D head_sh)
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Agoto unhash=
;
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A}
>>> =9A> - spin_unlock_irq(&conf->device_lock);
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Ash =3D head=
_sh;
>>> =9A>
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (test_bi=
t(STRIPE_SYNC_REQUESTED, &sh->state))
>>> =9A>
>>> =9A> ??
>>>
>>> =9AIn my opion, this patch looks correct, although it seems to me, =
that there is an another issue here.
>>>
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Aif (head_sh=
->batch_head) {
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9Ash =3D list_first_entry(&sh->batch_list,
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9Astruct stripe_head, batch_list);
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9Aif (sh !=3D head_sh)
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=
=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9Agoto unhash=
;
>>> =9A> =9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A=9A}
>>>
>>> =9AWith a patch above this code will be executed without taking any=
 locks. It it correct?
>>> =9AIn my opinion, we need to take at least sh->stripe_lock, which p=
rotects sh->batch_head.
>>> =9AOr do I miss something?
>>>
>>> =9AIf you want, we can handle this issue separately.
>>
>> =9AThe batch_list list doesn't need the protection. Only the remove_=
hash() need it.
>
> Yes, that's my understanding too. The key to understanding is that
> comment you (helpfully!) put in clear_batch_ready():
>
> =9A=9A=9A=9A=9A=9A=9A=9A/*
> =9A=9A=9A=9A=9A=9A=9A=9A=9A* BATCH_READY is cleared, no new stripes c=
an be added.
> =9A=9A=9A=9A=9A=9A=9A=9A=9A* batch_list can be accessed without lock
> =9A=9A=9A=9A=9A=9A=9A=9A=9A*/
>
> I'll wrangle some patches...
>
> Thanks,
> NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

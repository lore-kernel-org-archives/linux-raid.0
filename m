From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [patch 5/9 v2] raid5: reduce chance release_stripe() taking device_lock
Date: Wed, 20 Jun 2012 17:56:25 -0700
Message-ID: <CABE8wwuX3KT4ryd2MN9V9+DUaMraAOnyOSW9GdDxoyidhQjgRg@mail.gmail.com>
References: <20120619015941.891400722@kernel.org>
	<20120619020124.124186362@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120619020124.124186362@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jun 18, 2012 at 6:59 PM, Shaohua Li <shli@kernel.org> wrote:
> release_stripe() is a place conf->device_lock is heavily contended. W=
e take the
> lock even stripe count isn't 1, which isn't required. On the on the o=
ther hand,
> decreasing count first and taking lock if count is 0 can expose races=
:
> 1. bewteen dec count and taking lock, another thread hits the stripe =
in cache,
> so increase count. The stripe will be deleted from any list. In this =
case
> stripe count isn't 0.
> 2. between dec count and taking lock, another thread hits the stripe =
in cache
> and release it. In this case the stripe is already in specific list. =
We do
> list_move to adjust its position.
> So both cases are fixable to me.
>

These "1" and "2" comments no longer apply right?  atomic_dec_and_lock
is equivalently safe to lock+dec_and_test.


> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
> =A0drivers/md/raid5.c | =A0 79 ++++++++++++++++++++++++++++++--------=
---------------
> =A01 file changed, 45 insertions(+), 34 deletions(-)
>
> Index: linux/drivers/md/raid5.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/drivers/md/raid5.c =A0 =A0 =A0 2012-06-08 13:18:39.296=
561227 +0800
> +++ linux/drivers/md/raid5.c =A0 =A02012-06-08 13:38:38.209487084 +08=
00
> @@ -196,47 +196,61 @@ static int stripe_operations_active(stru
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 test_bit(STRIPE_COMPUTE_RUN, &sh->state);
> =A0}
>
> -static void __release_stripe(struct r5conf *conf, struct stripe_head=
 *sh)
> +static void handle_release_stripe(struct r5conf *conf, struct stripe=
_head *sh)
> =A0{
> - =A0 =A0 =A0 if (atomic_dec_and_test(&sh->count)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(!list_empty(&sh->lru));

Hmm, this BUG_ON does not get carried over?

> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(atomic_read(&conf->active_stripe=
s)=3D=3D0);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(STRIPE_HANDLE, &sh->state)=
) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(STRIPE_DEL=
AYED, &sh->state))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_ad=
d_tail(&sh->lru, &conf->delayed_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (test_bit(STRIP=
E_BIT_DELAY, &sh->state) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
sh->bm_seq - conf->seq_write > 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_ad=
d_tail(&sh->lru, &conf->bitmap_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_b=
it(STRIPE_BIT_DELAY, &sh->state);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_ad=
d_tail(&sh->lru, &conf->handle_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_wakeup_thread(conf->=
mddev->thread);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(stripe_operation=
s_active(sh));
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_and_clear_bit(=
STRIPE_PREREAD_ACTIVE, &sh->state))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ato=
mic_dec_return(&conf->preread_active_stripes)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 < IO_THRESHOLD)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 md_wakeup_thread(conf->mddev->thread);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&conf->activ=
e_stripes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!test_bit(STRIPE_EX=
PANDING, &sh->state)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_ad=
d_tail(&sh->lru, &conf->inactive_list);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up=
(&conf->wait_for_stripe);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (con=
f->retry_read_aligned)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 md_wakeup_thread(conf->mddev->thread);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Before we hold device_lock, other thread can hit t=
his stripe
> + =A0 =A0 =A0 =A0* in cache. It could do:
> + =A0 =A0 =A0 =A0* 1. just get_active_stripe(). The stripe count isn'=
t 0 then.
> + =A0 =A0 =A0 =A0* 2. do get_active_stripe() and follow release_strip=
e(). So the
> + =A0 =A0 =A0 =A0* stripe might be already released and already in sp=
ecific
> + =A0 =A0 =A0 =A0* list. we do list_move to adjust its position in th=
e list.
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);
> + =A0 =A0 =A0 if (test_bit(STRIPE_HANDLE, &sh->state)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_bit(STRIPE_DELAYED, &sh->state=
))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&sh->lru=
, &conf->delayed_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else if (test_bit(STRIPE_BIT_DELAY, &sh=
->state) &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0sh->bm_seq - con=
f->seq_write > 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&sh->lru=
, &conf->bitmap_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 clear_bit(STRIPE_BIT_DE=
LAY, &sh->state);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&sh->lru=
, &conf->handle_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_wakeup_thread(conf->mddev->thread);
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(stripe_operations_active(sh));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (test_and_clear_bit(STRIPE_PREREAD_A=
CTIVE, &sh->state))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (atomic_dec_return(&=
conf->preread_active_stripes)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 < IO_THRESHOLD)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_wake=
up_thread(conf->mddev->thread);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 atomic_dec(&conf->active_stripes);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!test_bit(STRIPE_EXPANDING, &sh->st=
ate)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 list_move_tail(&sh->lru=
, &conf->inactive_list);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 wake_up(&conf->wait_for=
_stripe);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (conf->retry_read_al=
igned)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 md_wake=
up_thread(conf->mddev->thread);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0}
>
> +static void __release_stripe(struct r5conf *conf, struct stripe_head=
 *sh)
> +{
> + =A0 =A0 =A0 if (atomic_dec_and_test(&sh->count))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_release_stripe(conf, sh);
> +}
> +
> =A0static void release_stripe(struct stripe_head *sh)
> =A0{
> =A0 =A0 =A0 =A0struct r5conf *conf =3D sh->raid_conf;
> =A0 =A0 =A0 =A0unsigned long flags;
>
> - =A0 =A0 =A0 spin_lock_irqsave(&conf->device_lock, flags);
> - =A0 =A0 =A0 __release_stripe(conf, sh);
> - =A0 =A0 =A0 spin_unlock_irqrestore(&conf->device_lock, flags);
> + =A0 =A0 =A0 local_irq_save(flags);
> + =A0 =A0 =A0 if (atomic_dec_and_lock(&sh->count, &conf->device_lock)=
) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 handle_release_stripe(conf, sh);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 spin_unlock(&conf->device_lock);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 local_irq_restore(flags);
> =A0}
>
> =A0static inline void remove_hash(struct stripe_head *sh)
> @@ -479,9 +493,6 @@ get_active_stripe(struct r5conf *conf, s
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!t=
est_bit(STRIPE_HANDLE, &sh->state))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0atomic_inc(&conf->active_stripes);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (lis=
t_empty(&sh->lru) &&
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 !test_bit(STRIPE_EXPANDING, &sh->state))
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 BUG();

Why are these checks removed?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

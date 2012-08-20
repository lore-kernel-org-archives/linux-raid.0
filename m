From: Dan Williams <djbw@fb.com>
Subject: Re: raid5: When add stripe_head to inactive_list, it should remove hash.
Date: Mon, 20 Aug 2012 10:51:19 -0700
Message-ID: <CAA9_cmePBesqWEpTfFOnajLuG355Po3X+52TpEvLoRD=DhCBFQ@mail.gmail.com>
References: <201208181053324376710@gmail.com>
	<201208201617046561993@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201208201617046561993@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jianpeng Ma <majianpeng@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 20, 2012 at 1:17 AM, Jianpeng Ma <majianpeng@gmail.com> wrote:
> On 2012-08-18 10:53 Jianpeng Ma <majianpeng@gmail.com> Wrote:
>>If it released stripe_head to inactive_list and soon get it from hash
>>list. So the stripe_head didn't call init_stripe, the dev.flags isn't
>>clear. So the debug info is error which printed the before info.
>>Although, i can't find logic error because this.I think it should be
>>correct.
>>
>>Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
>>---
>> drivers/md/raid5.c |   35 +++++++++++++++++++----------------
>> 1 file changed, 19 insertions(+), 16 deletions(-)
>>
>>diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>index adda94d..03d2f64 100644
>>--- a/drivers/md/raid5.c
>>+++ b/drivers/md/raid5.c
>>@@ -196,6 +196,24 @@ static int stripe_operations_active(struct stripe_head *sh)
>>              test_bit(STRIPE_COMPUTE_RUN, &sh->state);
>> }
>>
>>+static inline void remove_hash(struct stripe_head *sh)
>>+{
>>+      pr_debug("remove_hash(), stripe %llu\n",
>>+              (unsigned long long)sh->sector);
>>+
>>+      hlist_del_init(&sh->hash);
>>+}
>>+
>>+static inline void insert_hash(struct r5conf *conf, struct stripe_head *sh)
>>+{
>>+      struct hlist_head *hp = stripe_hash(conf, sh->sector);
>>+
>>+      pr_debug("insert_hash(), stripe %llu\n",
>>+              (unsigned long long)sh->sector);
>>+
>>+      hlist_add_head(&sh->hash, hp);
>>+}
>>+
>> static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
>> {
>>       BUG_ON(!list_empty(&sh->lru));
>>@@ -222,6 +240,7 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh)
>>               atomic_dec(&conf->active_stripes);
>>               if (!test_bit(STRIPE_EXPANDING, &sh->state)) {
>>                       list_add_tail(&sh->lru, &conf->inactive_list);
>>+                      remove_hash(sh);
>>                       wake_up(&conf->wait_for_stripe);
>>                       if (conf->retry_read_aligned)
>>                               md_wakeup_thread(conf->mddev->thread);
>>@@ -248,23 +267,7 @@ static void release_stripe(struct stripe_head *sh)
>>       local_irq_restore(flags);
>> }
>>
>>-static inline void remove_hash(struct stripe_head *sh)
>>-{
>>-      pr_debug("remove_hash(), stripe %llu\n",
>>-              (unsigned long long)sh->sector);
>>
>>-      hlist_del_init(&sh->hash);
>>-}
>>-
>>-static inline void insert_hash(struct r5conf *conf, struct stripe_head *sh)
>>-{
>>-      struct hlist_head *hp = stripe_hash(conf, sh->sector);
>>-
>>-      pr_debug("insert_hash(), stripe %llu\n",
>>-              (unsigned long long)sh->sector);
>>-
>>-      hlist_add_head(&sh->hash, hp);
>>-}
>>
>>
>> /* find an idle stripe, make sure it is unhashed, and return it. */
>>--
>>1.7.9.5
>>
> Hi neil:
>         Today, i found a problem about this.
> 1:mdadm -CR /dev/md0 -l5 -c4 -n4 /dev/sd[bcd] missing
> 2:dd if=/dev/zero of=/dev/md0 bs=4K count=1 oflag=direct
> 3:hdparm --make-bad-sector 2048 --yes-i-know-what-i-am-doing /dev/sdb
>   (2048 is the data-offset of sdb)
> 4:dd if=/dev/md0 of=/dev/zero bs=4K count=1 iflag=direct
>
> I think step4 maybe return ioerror.But it's success.

You would need to check that stripe0 got recycled between step2 and
step3.  If not then the uptodate stripe is in the cache and the read
can be serviced from the cached data.

...which seems to be the case because of:

> [19277.585936] locked=0 uptodate=4 to_read=0 to_write=0 failed=1 failed_num=3,-1

--
Dan

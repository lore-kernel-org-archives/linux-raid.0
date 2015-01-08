From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: superfluous md_wakeup_thread()
Date: Thu, 08 Jan 2015 17:53:15 -0500
Message-ID: <wrfjmw5s51gk.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I was looking over some md patches, and in
commit 67f455486d2ea20b2d94d6adf5b9b783d079e321
Author: NeilBrown <neilb@suse.de>
Date:   Wed May 28 13:39:22 2014 +1000

    md/raid56: Don't perform reads to support writes until stripe is ready.
    
You add the following:

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ad1b9be..c1e8607 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -292,9 +292,12 @@ static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
        BUG_ON(atomic_read(&conf->active_stripes)==0);
        if (test_bit(STRIPE_HANDLE, &sh->state)) {
                if (test_bit(STRIPE_DELAYED, &sh->state) &&
-                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state))
+                   !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
                        list_add_tail(&sh->lru, &conf->delayed_list);
-               else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
+                       if (atomic_read(&conf->preread_active_stripes)
+                           < IO_THRESHOLD)
+                               md_wakeup_thread(conf->mddev->thread);
+               } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
                           sh->bm_seq - conf->seq_write > 0)
                        list_add_tail(&sh->lru, &conf->bitmap_list);
                else {

However the additional md_wakeup_thread() seems unecessary as the
resulting code now reads (pasted from current upstream):

static void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,
                              struct list_head *temp_inactive_list)
{
        BUG_ON(!list_empty(&sh->lru));
        BUG_ON(atomic_read(&conf->active_stripes)==0);
        if (test_bit(STRIPE_HANDLE, &sh->state)) {
                if (test_bit(STRIPE_DELAYED, &sh->state) &&
                    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
                        list_add_tail(&sh->lru, &conf->delayed_list);
                        if (atomic_read(&conf->preread_active_stripes)
                            < IO_THRESHOLD)
                                md_wakeup_thread(conf->mddev->thread);
                } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&
                           sh->bm_seq - conf->seq_write > 0)
                        list_add_tail(&sh->lru, &conf->bitmap_list);
                else {
                        clear_bit(STRIPE_DELAYED, &sh->state);
                        clear_bit(STRIPE_BIT_DELAY, &sh->state);
                        if (conf->worker_cnt_per_group == 0) {
                                list_add_tail(&sh->lru, &conf->handle_list);
                        } else {
                                raid5_wakeup_stripe_thread(sh);
                                return;
                        }
                }
                md_wakeup_thread(conf->mddev->thread);

Is there a reason to wake the thread twice?

Cheers,
Jes

From: Zhengyuan Liu <liuzhengyuang521@gmail.com>
Subject: [PATCH] raid5: fix incorrectly counter of conf->empty_inactive_list_nr
Date: Wed, 20 Jul 2016 17:22:00 +0800
Message-ID: <CAOOPZo5B8EF0C3+Yg1WVYJx_jerR6zjNjbixpHhvQx4zOJqvxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "shli@kernel.org" <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: =?UTF-8?B?5YiY5LqR?= <liuyun01@kylinos.cn>, =?UTF-8?B?6IOh5rW3?= <huhai@kylinos.cn>
List-Id: linux-raid.ids

The counter conf->empty_inactive_list_nr is only used for determine if
the raid5 is congested which is deal with in function
raid5_congested(). It was increased in get_free_stripe() when
conf->inactive_list got emptied and decreased in
release_inactive_stripe_list() when  splice temp_inactive_list to
conf->inactive_list. However, this could cause to problem when
raid5_get_active_stripe was called, this function may call
list_del_init(&sh->lru) to delete sh from  "conf->inactive_list +
hash" which may cause  "conf->inactive_list + hash" to be empty when
atomic_inc_not_zero(&sh->count) got false.
 I have found conf->empty_inactive_list_nr to be negative number
during my random test.
Is there anything out of my thinking?

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -659,6 +659,7 @@ raid5_get_active_stripe(struct r5conf *conf,
sector_t sector,
 {
        struct stripe_head *sh;
        int hash = stripe_hash_locks_hash(sector);
+       int inc_empty_inactive_list_flag;

        pr_debug("get_stripe, sector %llu\n", (unsigned long long)sector);

@@ -703,7 +704,14 @@ raid5_get_active_stripe(struct r5conf *conf,
sector_t sector,
                                        atomic_inc(&conf->active_stripes);
                                BUG_ON(list_empty(&sh->lru) &&
                                       !test_bit(STRIPE_EXPANDING, &sh->state));
+
+                               inc_empty_inactive_list_flag = 0;
+                               if(!list_empty(conf->inactive_list + hash))
+                                       inc_empty_inactive_list_flag = 1;
                                list_del_init(&sh->lru);
+                               if(list_empty(conf->inactive_list +
hash) && inc_empty_inactive_list_flag)
+
atomic_inc(&conf->empty_inactive_list_nr);
+
                                if (sh->group) {
                                        sh->group->stripes_cnt--;
                                        sh->group = NULL;

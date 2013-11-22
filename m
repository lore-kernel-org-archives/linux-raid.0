From: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: md/raid5: Use conf->device_lock protect changing of
 multi-thread resources.
Date: Fri, 22 Nov 2013 16:10:49 +0000
Message-ID: <1385136649.1586.27.camel@bwh-desktop.uk.level5networks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Coverity reported a new defect after this change (commit 60aaf9338545) -
passing a singleton pointer as the worker_groups parameter to
alloc_thread_groups() which expects an array pointer.  But actually it
looks like it should still be a singleton pointer and
alloc_thread_groups() is broken:

-       conf->worker_groups = kzalloc(sizeof(struct r5worker_group) *
-                               conf->group_cnt, GFP_NOIO);
-       if (!conf->worker_groups || !workers) {
+       workers = kzalloc(size * *group_cnt, GFP_NOIO);
+       *worker_groups = kzalloc(sizeof(struct r5worker_group) *
+                               *group_cnt, GFP_NOIO);
+       if (!*worker_groups || !workers) {
                kfree(workers);
-               kfree(conf->worker_groups);
-               conf->worker_groups = NULL;
+               kfree(*worker_groups);
                return -ENOMEM;
        }
 
-       for (i = 0; i < conf->group_cnt; i++) {
+       for (i = 0; i < *group_cnt; i++) {
                struct r5worker_group *group;
 
-               group = &conf->worker_groups[i];
+               group = worker_groups[i];

This assignment should, I think, be:

		group = &(*worker_groups)[i];

or equivalently:

		group = *worker_groups + i;

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 30/54] md/raid5: Delete two error messages for a failed memory
 allocation
Date: Thu, 6 Oct 2016 11:30:16 +0200
Message-ID: <46ceb7a1-5b8e-989b-a896-9a6ff7fdf833@users.sourceforge.net>
References: <566ABCD9.1060404@users.sourceforge.net>
 <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>
List-Id: linux-raid.ids

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 5 Oct 2016 09:43:40 +0200

Omit extra messages for a memory allocation failure in this function.

Link: http://events.linuxfoundation.org/sites/events/files/slides/LCJ16-Refactor_Strings-WSang_0.pdf

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/md/raid5.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d864871..ef180c0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6613,12 +6613,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	memory = conf->min_nr_stripes * (sizeof(struct stripe_head) +
 		 max_disks * ((sizeof(struct bio) + PAGE_SIZE))) / 1024;
 	atomic_set(&conf->empty_inactive_list_nr, NR_STRIPE_HASH_LOCKS);
-	if (grow_stripes(conf, conf->min_nr_stripes)) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't allocate %dkB for buffers\n",
-		       mdname(mddev), memory);
+	if (grow_stripes(conf, conf->min_nr_stripes))
 		goto free_conf;
-	} else
+	else
 		printk(KERN_INFO "md/raid:%s: allocated %dkB\n",
 		       mdname(mddev), memory);
 	/*
@@ -6640,12 +6637,8 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 
 	sprintf(pers_name, "raid%d", mddev->new_level);
 	conf->thread = md_register_thread(raid5d, mddev, pers_name);
-	if (!conf->thread) {
-		printk(KERN_ERR
-		       "md/raid:%s: couldn't allocate thread.\n",
-		       mdname(mddev));
+	if (!conf->thread)
 		goto free_conf;
-	}
 
 	return conf;
 free_conf:
-- 
2.10.1


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AD86C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  6 Oct 2022 22:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiJFWLr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 Oct 2022 18:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbiJFWLo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 Oct 2022 18:11:44 -0400
Received: from resqmta-h1p-028589.sys.comcast.net (resqmta-h1p-028589.sys.comcast.net [IPv6:2001:558:fd02:2446::6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18A414298A
        for <linux-raid@vger.kernel.org>; Thu,  6 Oct 2022 15:11:42 -0700 (PDT)
Received: from resomta-h1p-028434.sys.comcast.net ([96.102.179.205])
        by resqmta-h1p-028589.sys.comcast.net with ESMTP
        id gPXnoFSLcPrBBgZ3FoiGcB; Thu, 06 Oct 2022 22:09:09 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=comcastmailservice.net; s=20211018a; t=1665094149;
        bh=4bReB5ysVuzj9J5Lw/ImRMSRjeBQ5PeaGd2KDieB5II=;
        h=Received:Received:From:To:Subject:Date:Message-Id:MIME-Version;
        b=msdzCPRskKAKUDZ3Fu/BbkkU8AV/Y1btWLP1fRafT/5c8F7i2ieWAWg9j8YaNuMmU
         gIv47+VKHhdyWCjd9W3tK25Gw7B953DuEBNgLHDn45xbgxNmMklLBZJreNnjx6h5zL
         osBCb98iLB3J+m3q+CfOUAfj4NpcqH3zEjm4+xJGJn4DvejyEsYsWmQqZmLr3aRE4N
         7sJ1DIDgUs8av5gQb4/Y90M5zi2zFBZtNhs8QbfJNLMYOlR2+y8lGadFN9pZc3NMd1
         2Y/Efj7dq/2mT21DnUVxRsODpjbF9/7IZ91XASvy6J8aYOgEYznoGcOGBiwRpJMYN+
         ZOorBEF+dM8IQ==
Received: from jderrick-mobl4.amr.corp.intel.com ([71.205.181.50])
        by resomta-h1p-028434.sys.comcast.net with ESMTPA
        id gZ2nocknTZjG3gZ2voEgxO; Thu, 06 Oct 2022 22:08:50 +0000
X-Xfinity-VAAS: gggruggvucftvghtrhhoucdtuddrgedvfedrfeeiiedgtdeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuvehomhgtrghsthdqtfgvshhipdfqfgfvpdfpqffurfetoffkrfenuceurghilhhouhhtmecufedtudenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheplfhonhgrthhhrghnucffvghrrhhitghkuceojhhonhgrthhhrghnrdguvghrrhhitghksehlihhnuhigrdguvghvqeenucggtffrrghtthgvrhhnpedtteeljeffgfffveehhfetveefuedvheevffffhedtjeeuvdevgfeftddtheeftdenucfkphepjedurddvtdehrddukedurdehtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopehjuggvrhhrihgtkhdqmhhosghlgedrrghmrhdrtghorhhprdhinhhtvghlrdgtohhmpdhinhgvthepjedurddvtdehrddukedurdehtddpmhgrihhlfhhrohhmpehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvhdpnhgspghrtghpthhtohepiedprhgtphhtthhopehsohhngheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrhgrihgusehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhonhgrthhhrghnrdguvghrrhhitghkse
 hsohhlihguihhgmhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhigrdhskhdruggvrhhrihgtkhesihhnthgvlhdrtghomhdprhgtphhtthhopehjohhnrghthhgrnhdruggvrhhrihgtkheslhhinhhugidruggvvh
X-Xfinity-VMeta: sc=-100.00;st=legit
From:   Jonathan Derrick <jonathan.derrick@linux.dev>
To:     Song Liu <song@kernel.org>
Cc:     <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        jonathan.derrick@solidigm.com, jonathanx.sk.derrick@intel.com,
        Jonathan Derrick <jonathan.derrick@linux.dev>
Subject: [PATCH 1/2] md/bitmap: Move unplug to daemon thread
Date:   Thu,  6 Oct 2022 16:08:39 -0600
Message-Id: <20221006220840.275-3-jonathan.derrick@linux.dev>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221006220840.275-1-jonathan.derrick@linux.dev>
References: <20221006220840.275-1-jonathan.derrick@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It's been observed in raid1/raid10 configurations that synchronous I/O
can cause workloads resulting in greater than 40% bitmap updates. This
appears to be due to the synchronous workload requiring a bitmap flush
with every flush of the I/O list. Instead prefer to flush this
configuration in the daemon sleeper thread.

Signed-off-by: Jonathan Derrick <jonathan.derrick@linux.dev>
---
 drivers/md/md-bitmap.c | 1 +
 drivers/md/raid1.c     | 2 --
 drivers/md/raid10.c    | 4 ----
 3 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6dffadbe6f..451259b38d25 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1244,6 +1244,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 			+ mddev->bitmap_info.daemon_sleep))
 		goto done;
 
+	md_bitmap_unplug(bitmap);
 	bitmap->daemon_lastrun = jiffies;
 	if (bitmap->allclean) {
 		mddev->thread->timeout = MAX_SCHEDULE_TIMEOUT;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 05d8438cfec8..42ba2d884773 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -793,8 +793,6 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 
 static void flush_bio_list(struct r1conf *conf, struct bio *bio)
 {
-	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-	md_bitmap_unplug(conf->mddev->bitmap);
 	wake_up(&conf->wait_barrier);
 
 	while (bio) { /* submit pending writes */
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 9117fcdee1be..e43352aae3c4 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -881,9 +881,6 @@ static void flush_pending_writes(struct r10conf *conf)
 		__set_current_state(TASK_RUNNING);
 
 		blk_start_plug(&plug);
-		/* flush any pending bitmap writes to disk
-		 * before proceeding w/ I/O */
-		md_bitmap_unplug(conf->mddev->bitmap);
 		wake_up(&conf->wait_barrier);
 
 		while (bio) { /* submit pending writes */
@@ -1078,7 +1075,6 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 
 	/* we aren't scheduling, so we can do the write-out directly. */
 	bio = bio_list_get(&plug->pending);
-	md_bitmap_unplug(mddev->bitmap);
 	wake_up(&conf->wait_barrier);
 
 	while (bio) { /* submit pending writes */
-- 
2.31.1


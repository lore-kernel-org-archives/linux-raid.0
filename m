Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FCEC77B61
	for <linux-raid@archiver.kernel.org>; Fri, 14 Apr 2023 02:28:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDNC26 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 13 Apr 2023 22:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDNC25 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 13 Apr 2023 22:28:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3844C9
        for <linux-raid@vger.kernel.org>; Thu, 13 Apr 2023 19:28:55 -0700 (PDT)
Received: from kwepemm600009.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PyKzc4ZNBznbbL;
        Fri, 14 Apr 2023 10:25:16 +0800 (CST)
Received: from [10.174.176.73] (10.174.176.73) by
 kwepemm600009.china.huawei.com (7.193.23.164) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:28:53 +0800
To:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, <logang@deltatee.com>,
        <guoqing.jiang@linux.dev>
From:   Yu Kuai <yukuai3@huawei.com>
Subject: [question] solution for raid10 configuration concurrent with io
Message-ID: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
Date:   Fri, 14 Apr 2023 10:28:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.176.73]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600009.china.huawei.com (7.193.23.164)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

rai10 support that add or remove conf->mirrors[].rdev/replacement can
concurrent with io, and this is handled by something like following
code:

raid10_write_request
  if (rrdev)
   // decide to write replacement
   r10_bio->devs[i].repl_bio = bio

  raid10_write_one_disk
         if (replacement) {
                 rdev = conf->mirrors[devnum].replacement;
                 if (rdev == NULL) {
                         /* Replacement just got moved to main 'rdev' */
                         smp_mb();
                         rdev = conf->mirrors[devnum].rdev;
                 }
         } else
                 rdev = conf->mirrors[devnum].rdev;

And this scheme is not complete and can cause kernel panic or data loss
in multiple places.

for example, null-ptr-dereference:

t1:				t2:
raid10_write_request:

  // read rdev
  rdev = conf->mirros[].rdev;
				raid10_remove_disk
				 p = conf->mirros + number;
				 rdevp = &p->rdev;
				 // reset rdev
				 *rdevp = NULL
  raid10_write_one_disk
   // reread rdev got NULL
   rdev = conf->mirrors[devnum].rdev
     // null-ptr-dereference
    mbio = bio_alloc_clone(rdev->bdev...)
				 synchronize_rcu()

for example, data loss:

t1:
// assum that rdev is NULL, and replacement is not NULL
raid10_write_request
  // read replacement
  rrdev = conf->mirros[].replacement

				t2: replacement moved to rdev
				raid10_remove_disk
				 p->rdev = p->replacement
				 p->replacement = NULL

				t3: add a new replacement
				raid10_add_disk
				 p->replacement = rdev
  raid10_write_one_disk
   // read again, and got wrong replacement
   // should write to rdev in this case
   rrdev = conf->mirros[].replacement

In order to fix these problems, I come up with two different solutions:

1) based on current solution, make sure rdev is only accessd once while
handling io, this can be done by changing r10bio:
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index 63e48b11b552..c132cba1953c 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -145,12 +145,12 @@ struct r10bio {
          */
         struct r10dev {
                 struct bio      *bio;
-               union {
-                       struct bio      *repl_bio; /* used for resync and
-                                                   * writes */
-                       struct md_rdev  *rdev;     /* used for reads
-                                                   * (read_slot >= 0) */
-               };
+               struct md_rdev  *rdev;
+
+               /* used for resync and writes */
+               struct bio      *repl_bio;
+               struct md_rdev  *replacement;
+
                 sector_t        addr;
                 int             devnum;
         } devs[];

And only read conf once, then record rdev/replacement. This requires to
change all the context to issue io and complete io.

2) add a new synchronization that configuration can't concurrent with
any io, however, I think this can work but I'm not 100% percent sure.
Code changes should be less, and this will allow some cleanups and
simplify logic.

Any suggestions?

Thanks,
Kuai

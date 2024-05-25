Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6A2381C2;
	Sat, 25 May 2024 11:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716634804; cv=none; b=MGRs9ClWBYYdXc3bjdcS2mapuG8XyhNWbFMejYGu2Hjs+LSQUVgUaNjZEp+RVnW/IDZCXb6cyljAxlNe04kAEgPJGeOpN47dsiEcA3nIDOEOO2B66ymGaIsek3CEHiHyqXOfhJ02JWfhvhMnNfNV75ujNWADkVySUGjm0nJbKbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716634804; c=relaxed/simple;
	bh=m0J889hhTWQgq7Si1mRD6KcsI53ca5q66Vyt1g470Ds=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C2DmgyF5p6ymZmIOteDXHtZwfIWwBgIHE+5oZBCO7GzvxWlpiDJdpETbO9hIdG/DuIipsqCJlHq574cguTOAMJS8Nk4Z63QONszwPNXru/RjYdrbGzwIUFFVhFg2UdZWtnQ7mWRHHK9U8SWkSVJm4+8yO0xA/jNuTC9wcBmmUGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vmf7R0tXFz4f3jkT;
	Sat, 25 May 2024 18:59:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 0AFA91A01A7;
	Sat, 25 May 2024 18:59:53 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ6mxFFm87GJNg--.25077S6;
	Sat, 25 May 2024 18:59:52 +0800 (CST)
From: linan666@huaweicloud.com
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linan666@huaweicloud.com,
	yi.zhang@huawei.com,
	houtao1@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH 2/2] md: fix deadlock between mddev_suspend and flush bio
Date: Sun, 26 May 2024 02:52:57 +0800
Message-Id: <20240525185257.3896201-3-linan666@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240525185257.3896201-1-linan666@huaweicloud.com>
References: <20240525185257.3896201-1-linan666@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHZQ6mxFFm87GJNg--.25077S6
X-Coremail-Antispam: 1UD129KBjvJXoWxZFWrXF4rCrW8uw18Gw4kWFg_yoWrZF1xpr
	Wxt3ZIyr48Xa98twsxJFy8Xrn5Wa1xAa4jqF4rA34fCr1qga1kG3y3Wry0qry5Gr1fJ398
	Ww4DXF1jva4jvrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUQIb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M280x2IEY4vEnII2IxkI6r1a6r45M2
	8IrcIa0xkI8VA2jI8067AKxVWUXwA2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK
	0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4
	x0Y4vE2Ix0cI8IcVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2
	z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4
	CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_
	Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x
	0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lw4CEc2x0rVAKj4xxMxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRKT5HtUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/

From: Li Nan <linan122@huawei.com>

Deadlock occurs when mddev is being suspended while some flush bio is in
progress. It is a complex issue.

T1. the first flush is at the ending stage, it clears 'mddev->flush_bio'
    and tries to submit data, but is blocked because mddev is suspended
    by T4.
T2. the second flush sets 'mddev->flush_bio', and attempts to queue
    md_submit_flush_data(), which is already running (T1) and won't
    execute again if on the same CPU as T1.
T3. the third flush inc active_io and tries to flush, but is blocked because
    'mddev->flush_bio' is not NULL (set by T2).
T4. mddev_suspend() is called and waits for active_io dec to 0 which is inc
    by T3.

  T1		T2		T3		T4
  (flush 1)	(flush 2)	(third 3)	(suspend)
  md_submit_flush_data
   mddev->flush_bio = NULL;
   .
   .	 	md_flush_request
   .	  	 mddev->flush_bio = bio
   .	  	 queue submit_flushes
   .		 .
   .		 .		md_handle_request
   .		 .		 active_io + 1
   .		 .		 md_flush_request
   .		 .		  wait !mddev->flush_bio
   .		 .
   .		 .				mddev_suspend
   .		 .				 wait !active_io
   .		 .
   .		 submit_flushes
   .		 queue_work md_submit_flush_data
   .		 //md_submit_flush_data is already running (T1)
   .
   md_handle_request
    wait resume

The root issue is non-atomic inc/dec of active_io during flush process.
active_io is dec before md_submit_flush_data is queued, and inc soon
after md_submit_flush_data() run.
  md_flush_request
    active_io + 1
    submit_flushes
      active_io - 1
      md_submit_flush_data
        md_handle_request
        active_io + 1
          make_request
        active_io - 1

If active_io is dec after md_handle_request() instead of within
submit_flushes(), make_request() can be called directly intead of
md_handle_request() in md_submit_flush_data(), and active_io will
only inc and dec once in the whole flush process. Deadlock will be
fixed.

Additionally, the only difference between fixing the issue and before is
that there is no return error handling of make_request(). But after
previous patch cleaned md_write_start(), make_requst() only return error
in raid5_make_request() by dm-raid, see commit 41425f96d7aa ("dm-raid456,
md/raid456: fix a deadlock for dm-raid456 while io concurrent with
reshape)". Since dm always splits data and flush operation into two
separate io, io size of flush submitted by dm always is 0, make_request()
will not be called in md_submit_flush_data(). To prevent future
modifications from introducing issues, add WARN_ON to ensure
make_request() no error is returned in this context.

Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfiguration")
Signed-off-by: Li Nan <linan122@huawei.com>
---
 drivers/md/md.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 14d6e615bcbb..9bb7e627e57f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -550,13 +550,9 @@ static void md_end_flush(struct bio *bio)
 
 	rdev_dec_pending(rdev, mddev);
 
-	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
-
+	if (atomic_dec_and_test(&mddev->flush_pending))
 		/* The pre-request flush has finished */
 		queue_work(md_wq, &mddev->flush_work);
-	}
 }
 
 static void md_submit_flush_data(struct work_struct *ws);
@@ -587,12 +583,8 @@ static void submit_flushes(struct work_struct *ws)
 			rcu_read_lock();
 		}
 	rcu_read_unlock();
-	if (atomic_dec_and_test(&mddev->flush_pending)) {
-		/* The pair is percpu_ref_get() from md_flush_request() */
-		percpu_ref_put(&mddev->active_io);
-
+	if (atomic_dec_and_test(&mddev->flush_pending))
 		queue_work(md_wq, &mddev->flush_work);
-	}
 }
 
 static void md_submit_flush_data(struct work_struct *ws)
@@ -617,8 +609,20 @@ static void md_submit_flush_data(struct work_struct *ws)
 		bio_endio(bio);
 	} else {
 		bio->bi_opf &= ~REQ_PREFLUSH;
-		md_handle_request(mddev, bio);
+
+		/*
+		 * make_requst() will never return error here, it only
+		 * returns error in raid5_make_request() by dm-raid.
+		 * Since dm always splits data and flush operation into
+		 * two separate io, io size of flush submitted by dm
+		 * always is 0, make_request() will not be called here.
+		 */
+		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
+			bio_io_error(bio);;
 	}
+
+	/* The pair is percpu_ref_get() from md_flush_request() */
+	percpu_ref_put(&mddev->active_io);
 }
 
 /*
-- 
2.39.2


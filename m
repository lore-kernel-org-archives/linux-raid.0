Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D16155CBD;
	Tue, 27 Aug 2024 11:07:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724756847; cv=none; b=s7taTHSON5ZApR+7VWkC9kwIh0zmNYPZHoNGkSAB/kucSdZZK0cCc+5K+ZY82Ldc/1DRIn2RExtwfEB7NkIFhRsHlH+HzgUnPN82FsoZxH0e+wPB8nPGPQRCJXWcLlgp0OKFtWj4VpKxz74Euq2D//dUyQqEbDabTJRvrB+ZnAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724756847; c=relaxed/simple;
	bh=hZYbKnMRQ4ZRw3Ch3SUH1S505+JaPC7GG/Fh0zy6qAE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Vpru5ua0htD20n7pBPda2FWiyq38/3DC7hqS0sXMrOSXWm9g1LO8A97BdH7Dps5W+uBrpmPLE6bYyDZzNLnVqsr/hcuZ4CytcG/8dWlvQ+E+F/SDzM6ibWokkwgYhW5ZdmtMQt/Cf33ELrqw6+SnlgeBG5AjuamUY/V2ECIbmqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WtPrZ2jNrz4f3l8F;
	Tue, 27 Aug 2024 19:07:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 455CE1A0359;
	Tue, 27 Aug 2024 19:07:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgB37IJms81m7+FwCw--.65433S4;
	Tue, 27 Aug 2024 19:07:20 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: pmenzel@molgen.mpg.de,
	song@kernel.org
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.12 v2] md: remove flush handling
Date: Tue, 27 Aug 2024 19:06:16 +0800
Message-Id: <20240827110616.3860190-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB37IJms81m7+FwCw--.65433S4
X-Coremail-Antispam: 1UD129KBjvJXoWxtF17Kw4xZFyfuFWxCryDKFg_yoWfWr4kp3
	yft3Zxtr48XFWYvw4DJFWkuryFgw17GayDtrW3u34xAw13Jrs8GayFqryFvry5C3s3urW5
	Ww4kt3yDurWjqFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWU
	AVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUBVbkUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

For flush request, md has a special flush handling to merge concurrent
flush request into single one, however, the whole mechanism is based on
a disk level spin_lock 'mddev->lock'. And fsync can be called quite
often in some user cases, for consequence, spin lock from IO fast path can
cause performance degradation.

Fortunately, the block layer already has flush handling to merge
concurrent flush request, and it only acquires hctx level spin lock. (see
details in blk-flush.c)

This patch removes the flush handling in md, and converts to use general
block layer flush handling in underlying disks.

Flush test for 4 nvme raid10:
start 128 threads to do fsync 100000 times, on arm64, see how long it
takes.

Test script:
void* thread_func(void* arg) {
    int fd = *(int*)arg;
    for (int i = 0; i < FSYNC_COUNT; i++) {
        fsync(fd);
    }
    return NULL;
}

int main() {
    int fd = open("/dev/md0", O_RDWR);
    if (fd < 0) {
        perror("open");
        exit(1);
    }

    pthread_t threads[THREADS];
    struct timeval start, end;

    gettimeofday(&start, NULL);

    for (int i = 0; i < THREADS; i++) {
        pthread_create(&threads[i], NULL, thread_func, &fd);
    }

    for (int i = 0; i < THREADS; i++) {
        pthread_join(threads[i], NULL);
    }

    gettimeofday(&end, NULL);

    close(fd);

    long long elapsed = (end.tv_sec - start.tv_sec) * 1000000LL + (end.tv_usec - start.tv_usec);
    printf("Elapsed time: %lld microseconds\n", elapsed);

    return 0;
}

Test result: about 10 times faster:
Before this patch: 50943374 microseconds
After this patch:  5096347  microseconds

BTW, commit 611d5cbc0b35 ("md: fix deadlock between mddev_suspend and flush
bio") claims to fix the problem introduced by commit fa2bbff7b0b4 ("md:
synchronize flush io with array reconfiguration"), which is wrong, the
problem is actually indroduced by commit 409c57f38017 ("md: enable
suspend/resume of md devices."), hence older kernels will be affected by
CVE-2024-43855.

What's worse, the CVE patch can't be backported to older kernels due to
a lot of relied patches, and this patch can be backported to olders
kernels to fix the CVE instead.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
Changes in v2:
 - fix some typo;
 - add test scrpit, and explain more about CVE in commit message;
 - add comment to explain why rcu portection is not needed, because we're
 planning to backport this patch to older kernels, and older kernels must
 still use rcu protection.

 drivers/md/md.c | 138 ++++++------------------------------------------
 drivers/md/md.h |  10 ----
 2 files changed, 15 insertions(+), 133 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a38981de8901..6c9c890dae8f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -546,137 +546,30 @@ static int mddev_set_closing_and_sync_blockdev(struct mddev *mddev, int opener_n
 	return 0;
 }
 
-/*
- * Generic flush handling for md
- */
-
-static void md_end_flush(struct bio *bio)
-{
-	struct md_rdev *rdev = bio->bi_private;
-	struct mddev *mddev = rdev->mddev;
-
-	bio_put(bio);
-
-	rdev_dec_pending(rdev, mddev);
-
-	if (atomic_dec_and_test(&mddev->flush_pending))
-		/* The pre-request flush has finished */
-		queue_work(md_wq, &mddev->flush_work);
-}
-
-static void md_submit_flush_data(struct work_struct *ws);
-
-static void submit_flushes(struct work_struct *ws)
+bool md_flush_request(struct mddev *mddev, struct bio *bio)
 {
-	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
 	struct md_rdev *rdev;
-
-	mddev->start_flush = ktime_get_boottime();
-	INIT_WORK(&mddev->flush_work, md_submit_flush_data);
-	atomic_set(&mddev->flush_pending, 1);
-	rcu_read_lock();
-	rdev_for_each_rcu(rdev, mddev)
-		if (rdev->raid_disk >= 0 &&
-		    !test_bit(Faulty, &rdev->flags)) {
-			struct bio *bi;
-
-			atomic_inc(&rdev->nr_pending);
-			rcu_read_unlock();
-			bi = bio_alloc_bioset(rdev->bdev, 0,
-					      REQ_OP_WRITE | REQ_PREFLUSH,
-					      GFP_NOIO, &mddev->bio_set);
-			bi->bi_end_io = md_end_flush;
-			bi->bi_private = rdev;
-			atomic_inc(&mddev->flush_pending);
-			submit_bio(bi);
-			rcu_read_lock();
-		}
-	rcu_read_unlock();
-	if (atomic_dec_and_test(&mddev->flush_pending))
-		queue_work(md_wq, &mddev->flush_work);
-}
-
-static void md_submit_flush_data(struct work_struct *ws)
-{
-	struct mddev *mddev = container_of(ws, struct mddev, flush_work);
-	struct bio *bio = mddev->flush_bio;
+	struct bio *new;
 
 	/*
-	 * must reset flush_bio before calling into md_handle_request to avoid a
-	 * deadlock, because other bios passed md_handle_request suspend check
-	 * could wait for this and below md_handle_request could wait for those
-	 * bios because of suspend check
+	 * md_flush_reqeust() should be called under md_handle_request() and
+	 * 'active_io' is already grabbed. Hence it's safe to get rdev directly
+	 * without rcu protection.
 	 */
-	spin_lock_irq(&mddev->lock);
-	mddev->prev_flush_start = mddev->start_flush;
-	mddev->flush_bio = NULL;
-	spin_unlock_irq(&mddev->lock);
-	wake_up(&mddev->sb_wait);
-
-	if (bio->bi_iter.bi_size == 0) {
-		/* an empty barrier - all done */
-		bio_endio(bio);
-	} else {
-		bio->bi_opf &= ~REQ_PREFLUSH;
+	WARN_ON(percpu_ref_is_zero(&mddev->active_io));
 
-		/*
-		 * make_requst() will never return error here, it only
-		 * returns error in raid5_make_request() by dm-raid.
-		 * Since dm always splits data and flush operation into
-		 * two separate io, io size of flush submitted by dm
-		 * always is 0, make_request() will not be called here.
-		 */
-		if (WARN_ON_ONCE(!mddev->pers->make_request(mddev, bio)))
-			bio_io_error(bio);
-	}
-
-	/* The pair is percpu_ref_get() from md_flush_request() */
-	percpu_ref_put(&mddev->active_io);
-}
+	rdev_for_each(rdev, mddev) {
+		if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags))
+			continue;
 
-/*
- * Manages consolidation of flushes and submitting any flushes needed for
- * a bio with REQ_PREFLUSH.  Returns true if the bio is finished or is
- * being finished in another context.  Returns false if the flushing is
- * complete but still needs the I/O portion of the bio to be processed.
- */
-bool md_flush_request(struct mddev *mddev, struct bio *bio)
-{
-	ktime_t req_start = ktime_get_boottime();
-	spin_lock_irq(&mddev->lock);
-	/* flush requests wait until ongoing flush completes,
-	 * hence coalescing all the pending requests.
-	 */
-	wait_event_lock_irq(mddev->sb_wait,
-			    !mddev->flush_bio ||
-			    ktime_before(req_start, mddev->prev_flush_start),
-			    mddev->lock);
-	/* new request after previous flush is completed */
-	if (ktime_after(req_start, mddev->prev_flush_start)) {
-		WARN_ON(mddev->flush_bio);
-		/*
-		 * Grab a reference to make sure mddev_suspend() will wait for
-		 * this flush to be done.
-		 *
-		 * md_flush_reqeust() is called under md_handle_request() and
-		 * 'active_io' is already grabbed, hence percpu_ref_is_zero()
-		 * won't pass, percpu_ref_tryget_live() can't be used because
-		 * percpu_ref_kill() can be called by mddev_suspend()
-		 * concurrently.
-		 */
-		WARN_ON(percpu_ref_is_zero(&mddev->active_io));
-		percpu_ref_get(&mddev->active_io);
-		mddev->flush_bio = bio;
-		spin_unlock_irq(&mddev->lock);
-		INIT_WORK(&mddev->flush_work, submit_flushes);
-		queue_work(md_wq, &mddev->flush_work);
-		return true;
+		new = bio_alloc_bioset(rdev->bdev, 0,
+				       REQ_OP_WRITE | REQ_PREFLUSH, GFP_NOIO,
+				       &mddev->bio_set);
+		bio_chain(new, bio);
+		submit_bio(new);
 	}
 
-	/* flush was performed for some other bio while we waited. */
-	spin_unlock_irq(&mddev->lock);
-	if (bio->bi_iter.bi_size == 0) {
-		/* pure flush without data - all done */
+	if (bio_sectors(bio) == 0) {
 		bio_endio(bio);
 		return true;
 	}
@@ -763,7 +656,6 @@ int mddev_init(struct mddev *mddev)
 	atomic_set(&mddev->openers, 0);
 	atomic_set(&mddev->sync_seq, 0);
 	spin_lock_init(&mddev->lock);
-	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1c6a5f41adca..5d2e6bd58e4d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -572,16 +572,6 @@ struct mddev {
 						   */
 	struct bio_set			io_clone_set;
 
-	/* Generic flush handling.
-	 * The last to finish preflush schedules a worker to submit
-	 * the rest of the request (without the REQ_PREFLUSH flag).
-	 */
-	struct bio *flush_bio;
-	atomic_t flush_pending;
-	ktime_t start_flush, prev_flush_start; /* prev_flush_start is when the previous completed
-						* flush was started.
-						*/
-	struct work_struct flush_work;
 	struct work_struct event_work;	/* used by dm to report failure event */
 	mempool_t *serial_info_pool;
 	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
-- 
2.39.2


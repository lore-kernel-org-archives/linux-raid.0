Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.224
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795501110;
	b=coywiworBH4SDEai1fOFw0MSnneA0w6EqGaxDazwipuaFErtLO943BFHWEZKQDwWt1Vu
	 1MTJvso55Dsj2uz+YI+Ns+aNRd3jBO2Lnx2U3C8TH9rJTXwRzhNds0tIGySOTleqyT7I7
	 7GNMXxSng6Cya2nI1s/9OACsMs1afql+ZYZRxH6Pq9y6OzLw5Ys1Hg7nNlrI+8QLtOvt3
	 pSOUKDNQ1jySbIANoexWmIo+UjtLJVwXXkGhRTQtY3yKU9QYZlqDHtNgSm0zYh+IrJ9S6
	 /ZWxuR5mWuuNF4irBhPZw5LSqUyLcqJRh1Ca3GI0OIa2/U9qMV4GfCZebcuDMMBAQtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795501110;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=vm4utfjk+7vibC6lj5Stb1WJbvYE3nc8MkZbPVVvBx4=;
	b=pG/F8Xi6EyyTkKtuxPIWtAvTf+LS5fkfask5s4kRA9MOqncwOzh5AsAl97YowMHv4X+Z
	 UphW8u/eOk4hfKZJ0lKH4sp1pPdklbZBt0sMLM1XTshPbrvpZWbVVCyVyMFcm0OjIQC8h
	 /RceGqVw9L1pxAg/eyBw5jElRrT7KmRWDhLa/Yon7qGHun09WYiB97MMqXLXEV16TRSxq
	 kCTW7IMHvnoQ7FfOoN1bhg5w3Fs2ZeGxxkmSKU5rDbOZPTDZKSEgUfLOzf7tu+mRROMXb
	 lhW8Fr1RfzwrPjxUXeQC8qVmfrWtunRNm8eqEBISqyq0CQWhbdLIgJESbozf6UwDG7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b="edyPyx/6";
	arc=none smtp.remote-ip=113.46.200.224
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1229606A31E
	for <linux-raid@vger.kernel.org>; Tue, 24 Nov 2026 06:18:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A1229606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=edyPyx/6
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vm4utfjk+7vibC6lj5Stb1WJbvYE3nc8MkZbPVVvBx4=;
	b=edyPyx/6MDCEO9KTh1MBhfTBAd4lp+nJh0oA2qoV21i+myfsyNmuxcDw14E639qPZi/3FL4PE
	jBuJVE0IDVMFA/1pydcDLTjMF6cnetMi4oWTc9CVfrKr1JyXLeABS65+pYoA7vZIJ8GttaIAbNM
	MATNCL29o4ZMXmWUGaXWopI=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4jYXfq2LC1z1cySV;
	Tue, 24 Nov 2026 14:17:55 +0800 (CST)
Received: from dggpemr100018.china.huawei.com (unknown [7.185.36.64])
	by mail.maildlp.com (Postfix) with ESMTPS id CE96E40565;
	Tue, 24 Nov 2026 14:18:18 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr100018.china.huawei.com
 (7.185.36.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Tue, 24 Nov
 2026 14:18:18 +0800
From: Zhou Minqiang <zhouminqiang2@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <neilb@suse.com>,
	<artur.paszkiewicz@intel.com>, <shli@kernel.org>, <axboe@kernel.dk>
CC: <linux-raid@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] md/raid10: reset bi_offset in sync_request_write()
Date: Tue, 24 Nov 2026 14:08:56 +0800
Message-ID: <20261124060856.559865-1-zhouminqiang2@huawei.com>
X-Mailer: git-send-email 2.52.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemr100018.china.huawei.com (7.185.36.64)

sync_request_write() reuses the bio that completed the resync read (fbio)
as the source bio of bio_copy_data(). Commit cc57858831e3 ("md/raid10:
fix data corruption and crash during resync") restored bi_iter.bi_size and
bi_iter.bi_idx, but missed bi_iter.bi_offset. When bi_offset is non-zero,
bio_copy_data() starts copying from the middle of the first bvec and
walks past the end of the bvec table:

    BUG: KASAN: wild-memory-access in bio_copy_data+0x3d4/0x8f0
    Read of size 1919 at addr 00050880ffff8881 by task md0_raid10/2674
    CPU: 7 UID: 0 PID: 2674 Comm: md0_raid10 Not tainted
    Call Trace:
      bio_copy_data
      raid10d
      md_thread

Commit d4aa57a1cac3 ("block: don't bother iter advancing a fully done bio")
added a fast path to bio_advance(): a bio that completes its full length
returns without calling __bio_advance(), which makes a stale bi_offset
possible and lets this bug be triggered.

The residue is produced when the block layer splits the resync bio inside
a merged bvec. The resync bio is built in raid10_sync_request() with a
series of bio_add_page() calls, and bio_add_page() merges physically
contiguous pages into one bvec. blk_mq_submit_bio() then passes the bio
to __bio_split_to_limits(), where bio_may_need_split() checks the merged
bvec against max_fast_segment_size (4096 bytes on loop), and exceeding
it forces bio_split_rw() to cut in the middle of the bvec and resubmit
the remainder. With all 16 resync pages merged into a single bvec:

split 1:  orig 65536 offset=0     -> frag 4096 | orig 61440 offset=4096
split 2:  orig 61440 offset=4096  -> frag 4096 | orig 57344 offset=8192
...
split 15: orig 8192  offset=57344 -> frag 4096 | orig 4096  offset=61440
no split: orig 4096  offset=61440

After these 15 splits, there is nothing left to cut, so the remaining
4096 bytes are submitted as the original bio itself. When it completes,
blk_update_request() calls bio_advance() with nbytes equal to bi_size,
which takes the fast path and skips __bio_advance():

    blk_mq_end_request
      blk_update_request
        bio_advance(bio, 4096)       /* 4096 == bi_size, fast path */
          bi_size = 0                /* bi_offset left at 61440 */

sync_request_write() then resets bi_idx to 0 but keeps bi_offset at
61440, so bio_copy_data() starts at offset 61440 of bvec 0 while claiming
to copy the full 64 KiB, and the crash above follows.

Reset bi_offset along with bi_idx so the reused iterator always starts at
the beginning of the first bvec.

Fixes: cc57858831e3 ("md/raid10: fix data corruption and crash during resync")
Fixes: d4aa57a1cac3 ("block: don't bother iter advancing a fully done bio")
Signed-off-by: Zhou Minqiang <zhouminqiang2@huawei.com>
---
 drivers/md/raid10.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154497..74e834246ca2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2330,6 +2330,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	fbio = r10_bio->devs[i].bio;
 	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
 	fbio->bi_iter.bi_idx = 0;
+	fbio->bi_iter.bi_offset = 0;
 	fpages = get_resync_pages(fbio)->pages;
 
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
-- 
2.52.0


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.218
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795680972;
	b=AkGHhCpnuamDx4Gvcn1zhi8fUosafYwe4XBC0GHmFb9DWR/10bblQ8oqvnlDQeChtpwo
	 fr5vrdWp+qlCJH6snYxLEh3jRg8LUD8p9LXutZeYMOKgA7OgLq96IBgpUO8b3hl/X0Vrz
	 nwlAAOPf2H6yFZgpbiXTqvBFQPKAWJscMzC5b7fnUn12XQy6RKEU+gSw8aJ6BR4O0Nchp
	 K8hDRAiCd8ssV2LXXuw4EeXKMjs/dmI+CiwAcYGDefjrshifqKI4B97Az41PcjdpBx23r
	 WaUDyKQvXvH4xtcOOUW6oBeExbwanb4PnN018/iVr9PmbxJBY9o9TJtRlTxJSBihk2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795680972;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=krkIgNedrxbGkGuJvGd1TsMeKPX5iQwMJXP9oifUXzk=;
	b=ejyYt6rXJSpNGQG/gEAUnc7TAXyTs/2JgHB7uRnPN93yuaeSI+jF/fm8nRPPJKVODc8u
	 Uk8tR4TO9hwTH+P5wXd3dhLCmGRHK0fWjVeRm8fpwYGeO3o54LxR9jMmHCQBuqGGUcvsQ
	 9M+gOLVe0pSAIN/zUImPWSm9Xs5+BqwrXK9u9a3Uj4SM8gCKy1EEsbSAPYVunr2JXSihz
	 FGX83jcFTRbLteVv6kOTvXhQ146PHK9+xykST8v0+SY+VPeoqJsQmlmJpvk9eAPWgAYft
	 WPqd77tZgo+5l+ULuQQpSKFbzCeVyHX4DYoXgf27cWpduOzcR43LAbz33x6aIC+vKqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=yEAvZUjI;
	arc=none smtp.remote-ip=113.46.200.218
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D1B606A31C
	for <linux-raid@vger.kernel.org>; Thu, 26 Nov 2026 08:16:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 51D1B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=yEAvZUjI
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=krkIgNedrxbGkGuJvGd1TsMeKPX5iQwMJXP9oifUXzk=;
	b=yEAvZUjI0cis3wRFmjf+cRviKwbqJ4mH3g9iQ23l7fOBSd9MBjIS8H3fvhzYtBoNX7yE8snCj
	z5s3KtQnf54B02BrMSZHAds/VQKLVtWeaqwSnzdo/N6w6GIOe84IiOArKV2Zh21KJU1dhrwtXmP
	sWMM0mFDqhS5smtq/omhJ7k=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4jZq8w72gqzpSy5;
	Thu, 26 Nov 2026 16:14:56 +0800 (CST)
Received: from dggpemr100018.china.huawei.com (unknown [7.185.36.64])
	by mail.maildlp.com (Postfix) with ESMTPS id 0F3C240561;
	Thu, 26 Nov 2026 16:16:01 +0800 (CST)
Received: from huawei.com (10.50.85.155) by dggpemr100018.china.huawei.com
 (7.185.36.64) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56; Thu, 26 Nov
 2026 16:16:00 +0800
From: Zhou Minqiang <zhouminqiang2@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <artur.paszkiewicz@intel.com>,
	<shli@kernel.org>, <neilb@suse.com>, <axboe@kernel.dk>
CC: <linux-raid@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2] md/raid10: fix stale bi_offset in sync_request_write()
Date: Thu, 26 Nov 2026 16:06:32 +0800
Message-ID: <20261126080632.1598653-1-zhouminqiang2@huawei.com>
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
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
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

Reuse fbio with bio_reuse() so the iterator always starts at the beginning
of the first bvec, and no other field is left stale.

Fixes: cc57858831e3 ("md/raid10: fix data corruption and crash during resync")
Fixes: d4aa57a1cac3 ("block: don't bother iter advancing a fully done bio")
Signed-off-by: Zhou Minqiang <zhouminqiang2@huawei.com>
---
v2:
  - use bio_reuse() instead of clearing bi_offset directly
v1: https://lore.kernel.org/all/20261124060856.559865-1-zhouminqiang2@huawei.com/

 drivers/md/raid10.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154497..085998fd35de 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2328,8 +2328,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 	first = i;
 	fbio = r10_bio->devs[i].bio;
-	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
-	fbio->bi_iter.bi_idx = 0;
+	bio_reuse(fbio, fbio->bi_opf);
 	fpages = get_resync_pages(fbio)->pages;
 
 	vcnt = (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
-- 
2.52.0


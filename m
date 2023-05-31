Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E2FFC7EE31
	for <linux-raid@archiver.kernel.org>; Wed, 31 May 2023 11:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235910AbjEaLxm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 May 2023 07:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbjEaLxM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 31 May 2023 07:53:12 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EA21721;
        Wed, 31 May 2023 04:52:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1685533944; x=1717069944;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eNep3j+omtdw7VUEVyvSEuMvQR4DwZ3logtHWgIlxjI=;
  b=V1NzkDyTGaOaAoedSbjSeTFBeiNIjV5rS3As5pWmuwagL8jbVhsyAJt2
   xTKEpwFrp2Pp3MWMpEOFOTXIshNaZqEigzbTWuI7Y5uzkPH6Cb7LSTmlo
   zNpSBWEVr5t+5Bh/RC6lLfELTA3KgThihfiGs8OgEqcgMS0FFoZbRstNi
   XbHz8Kec5QeF9b/4Zn8/McOVhqMLw3q0p7wW/gwKEVVc74BfVDQ9g7f1Z
   zaO7ZJuXK1hq2sIduHSSUPFX0gwPDo8GSVV1bzjwNJ9+M/wfUSFXtCAvr
   JTe5NIHqvej2jtnOqHffMo6dS2e8isxeCvRPUi9sUlv2W3u1B06e3YUw2
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,207,1681142400"; 
   d="scan'208";a="336547987"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2023 19:51:43 +0800
IronPort-SDR: 1Ai9P/U50XpiJv9tygco4ay/iMilVJAySofJ3x2QIgDfiPfBL+Tl6ZRb2WUf491ESxBRNI34WY
 vQm8iZgyFFZOSv+8e30mrfmNnIYPXIPOGoDJkF2NhwtPdvXO8N1eEoYih9WJM5xco4KZxDuOOH
 crOxmX32iNVr5q8CF0ZsTHLoyhXi7XECHsmIAEg/vb2qM3ra2cnSh1v1O5YcZf+AF/88eJvEV6
 CgnIx6pplrkRLeClG7cfUJh3YSzRaYIMw6Q73JcxfGDJniZsa5W7WVF0Kptp98frOl/RjHADmd
 IB8=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2023 04:00:54 -0700
IronPort-SDR: FCL2eubAZP5N9vA9HDK+m1l82gIsrfnKwR7xl5QF91RBemiBMgqeza4/jZiezHWUmx+A2BPvbg
 diAJW3D6qzTTjWDhUmm4+CPI/5Pg7yzgXHh3HJFIrkz3I6/YCxvrl5dZGpioD3FIrHJ11rp7ht
 I6HmAKaEKAajDqnW187jX1JXP1SwiHNqHZle9nVdQDpjjStKHttQk7X5nq4km22hnGrB8FLHbJ
 5GGj+z1T+oiCsX5btGRw34bpXv3+vXL9f6GlctCmHk5dzGi6sYWMqAROn6Jr2ed+EqoN495klc
 Cyk=
WDCIronportException: Internal
Received: from unknown (HELO redsun91.ssa.fujisawa.hgst.com) ([10.149.66.6])
  by uls-op-cesaip02.wdc.com with ESMTP; 31 May 2023 04:51:41 -0700
From:   Johannes Thumshirn <johannes.thumshirn@wdc.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        dm-devel@redhat.com, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, Mike Snitzer <snitzer@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Dave Kleikamp <shaggy@kernel.org>,
        jfs-discussion@lists.sourceforge.net, cluster-devel@redhat.com,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, gouha7@uniontech.com,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH v7 17/20] block: mark bio_add_page as __must_check
Date:   Wed, 31 May 2023 04:50:40 -0700
Message-Id: <7ae4a902e08fe2e90c012ee07aeb35d4aae28373.1685532726.git.johannes.thumshirn@wdc.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1685532726.git.johannes.thumshirn@wdc.com>
References: <cover.1685532726.git.johannes.thumshirn@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Now that all users of bio_add_page check for the return value, mark
bio_add_page as __must_check.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 include/linux/bio.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index b3e7529ff55e..ea2d937d3cba 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -465,7 +465,8 @@ extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
 
-int bio_add_page(struct bio *, struct page *, unsigned len, unsigned off);
+int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
+			      unsigned off);
 bool bio_add_folio(struct bio *, struct folio *, size_t len, size_t off);
 extern int bio_add_pc_page(struct request_queue *, struct bio *, struct page *,
 			   unsigned int, unsigned int);
-- 
2.40.1


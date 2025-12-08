Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D349F313E3B
	for <linux-raid@vger.kernel.org>; Mon,  8 Dec 2025 12:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765195871; cv=none; b=KEXD0Aiqdxi2+yig6YJzsMGjP3FIsHnVqfzvuJ+9d/MBzUIUIEW/4pS0G2p7cF9FyYmGbVXqcTS3Zt3pP70mqKIHu9DaFh2YULmxXk51euqwyD98mcbAw+1M75qWO6/YtKgJG96PHXNyE5ca9ElJGe8IHKjfOv5ACppjyw55dU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765195871; c=relaxed/simple;
	bh=VlZgUuAKsZkQhKNfzcqI5wh1dvmrS6O//2iahLfBSA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H0vUQhSuDv2e+2AzNKVxg0GYlTO+htZ+Qg+kxv84ZTLX2HIXiyqQd8kq5aO2aB52ET7DTodj+ie4Wr6zaq5F1kGkliVjHhJP4WXvdnIVldtcPamXshCRmSNoJLr0i0rm6FUz4H8OxokHs17tAIIiPHo4hP9vo+MX90iG/EokT8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CEahS092; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CEahS092"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765195868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+3g+DHtAfN0xhOXLyepP76BJ3LQslId9qvhKNR5qEE4=;
	b=CEahS092ZOGECggEAStPI5WB824BtWdx/zTeOm7dsX+URLH0symo/3gCpaJ8tDy+pm2GPj
	65tDJqidhABrFOv8D89okJqgng3fqZ/+x7lOVEZ4Vvf9wmN8F9SLL/HOZgCcpQ5ed4Hjfe
	1ZyDuSq0TuXcVJWFFJ9vFieZieP7pBs=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-316-YOFxhWDIMl2j-uVaNl9jVg-1; Mon,
 08 Dec 2025 07:11:03 -0500
X-MC-Unique: YOFxhWDIMl2j-uVaNl9jVg-1
X-Mimecast-MFC-AGG-ID: YOFxhWDIMl2j-uVaNl9jVg_1765195862
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECE9518001C6;
	Mon,  8 Dec 2025 12:11:01 +0000 (UTC)
Received: from pasta.fast.eng.rdu2.dc.redhat.com (unknown [10.44.34.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id CFF1F1955F24;
	Mon,  8 Dec 2025 12:10:58 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
To: Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [RFC 09/12] bio: switch to bio_set_status in submit_bio_noacct
Date: Mon,  8 Dec 2025 12:10:16 +0000
Message-ID: <20251208121020.1780402-10-agruenba@redhat.com>
In-Reply-To: <20251208121020.1780402-1-agruenba@redhat.com>
References: <20251208121020.1780402-1-agruenba@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In submit_bio_noacct(), call bio_endio() and return directly when
successful.  That way, bio_set_status(bio, status) will only be called
for actual errors and the compiler can optimize out the 'status !=
BLK_STS_OK' check inside bio_set_status().

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 block/blk-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4f7b7cf50d23..95cbb3ffcf9f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -816,8 +816,8 @@ void submit_bio_noacct(struct bio *bio)
 		if (!bdev_write_cache(bdev)) {
 			bio->bi_opf &= ~(REQ_PREFLUSH | REQ_FUA);
 			if (!bio_sectors(bio)) {
-				status = BLK_STS_OK;
-				goto end_io;
+				bio_endio(bio);
+				return;
 			}
 		}
 	}
@@ -882,7 +882,7 @@ void submit_bio_noacct(struct bio *bio)
 not_supported:
 	status = BLK_STS_NOTSUPP;
 end_io:
-	bio->bi_status = status;
+	bio_set_status(bio, status);
 	bio_endio(bio);
 }
 EXPORT_SYMBOL(submit_bio_noacct);
-- 
2.51.0


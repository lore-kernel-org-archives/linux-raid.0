Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BA33A257A;
	Wed, 15 Jul 2026 14:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784126933; cv=none; b=mR/0sVblvPreQwFcgiPCRsv5MVjwKgEzC+/sS3GyfOgiZE+WhzCexzLAUHPRRcrxynzCKdbNin1CQ+60WM2Mb9XgVhN4rBq0MKJ2FV9/gdSd5gWTvYWdT7Bf73rTwQihIS7f62JYUmAX19IFWo1ebDj/aFNltqOLx4ks225bd8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784126933; c=relaxed/simple;
	bh=rWcHv2AxkJJpq6uaSi4YWLKfRT4km1zme0oroIvCzcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oTnc2X51dQd58mKyTLf8MuR2Cs3lBDC+1K5t8ASMmvr++XmqgdbvGVU61nL2Iqb7pB7EzXGHEUOOMQWr7j8XRDEP3KCpLzPRlZT1RK9zCovXjUxa88opFvF5LRLV2n7yYFovuLK0ZP2g8OwpKHdmrZHutF29VZVnXNXR+hWdKXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=TX9vl53F; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="TX9vl53F"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=gVCF+ZyieLNZM6k+EBQ6kUMkk4dT0DZ2PNbiRabJUmI=; b=TX9vl53FwCMfh1VGN0o9bmP+z/
	xORpK4I77kOzilL8pAjB8Oik2MbNeWc393c6aTcrFkcjTMgU7JmwlzC6mw9baknq1dxkZfxjYghS4
	lUPsRuxpz64AXgkW9LKNBjC6sFgHFdrnMm44dJfOPVdbkkFH21j4USIODP195PW8QpcGzEJnVEseW
	mO5FK5K3je7OhBKN5F6kmG0qylVNoDSJEbZjqykYD6avThG9BXBTgMIazvBL0cvjbk9ICSJne8FXs
	Uaw71gFgZEQ+T0TUgu68NeiDnd1V4U2Ohhr9y8Goz3mEUYLmG/2OHlZrl5YgpHDqwc6WnXJBHoATa
	gM8Lzf0w==;
Received: from 2a02-8389-2301-9f00-b29a-36e9-8c1c-0994.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:b29a:36e9:8c1c:994] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk0un-0000000FDBQ-2PKF;
	Wed, 15 Jul 2026 14:48:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] raid6: defer implementation selection when built-in
Date: Wed, 15 Jul 2026 16:47:37 +0200
Message-ID: <20260715144825.95432-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715144825.95432-1-hch@lst.de>
References: <20260715144825.95432-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Don't hold up early boot and defer the selection just like we've been
doing for the RAID5 XOR code since commit 524ccdbdfb52 ("crypto: xor -
defer load time benchmark to a later time").

This will also allow full use of the timing subsystem for benchmarking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/raid/raid6/algos.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 6f5c89ab2b17..702e167a543a 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -239,10 +239,6 @@ static int __init raid6_select_algo(void)
 	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
 		pr_info("raid6: skipped pq benchmark and selected %s\n",
 			raid6_algos[raid6_nr_algos - 1]->name);
-		static_call_update(raid6_gen_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
-		static_call_update(raid6_xor_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
 		return 0;
 	}
 
@@ -329,13 +325,34 @@ static int __init raid6_init(void)
 	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
 	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
 
+	/*
+	 * Pick the last registered implementation as the temporary default until
+	 * calibration happens.
+	 */
+	static_call_update(raid6_gen_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
+	static_call_update(raid6_xor_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
+
+#ifdef MODULE
 	return raid6_select_algo();
+#else
+	return 0;
+#endif
 }
 
 static void __exit raid6_exit(void)
 {
 }
 
+/*
+ * When built-in we must register the default implementation before md
+ * initializes, but we don't want calibration to run that early as that
+ * would delay the boot process.
+ */
+#ifndef MODULE
+device_initcall(raid6_select_algo);
+#endif
 subsys_initcall(raid6_init);
 module_exit(raid6_exit);
 MODULE_LICENSE("GPL");
-- 
2.53.0


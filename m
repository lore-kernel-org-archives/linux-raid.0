Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436F7408023;
	Wed,  8 Jul 2026 09:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501621; cv=none; b=T0CmM+BlM2pyr5cRk7nsuDrlyokV55gOIMs9w7cf3Aa58v9lPmS/PRwfFtdFu1C4QkbIpHzfSH2LQIoLPfZQ1c4B34XBq2IC+RIEoRwJ9WHGJpgPkx1igRCMimSPU1weRbHwl4FiBim4evfLBWerK70XPyDAO03ccPAfzPLVOV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501621; c=relaxed/simple;
	bh=+cP2WVwexuC5UoqqKdMwzVPX8zfmNlabAALFQb4lkEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2cfZpWiUFks9aBPNWODzRQhT/VmiVIflJO1oTP5DubTehYYOewGc7ANAj82DGb/LeggdMfFK73kMucwLRUo/r2YdHueefxY5ERokQczSzIVQ+ggb64VQ/WnpS9nbOgv2zqqvcKoprJuyQqBq8dtwcVgB7DJaRofDhLPOBWrMLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=A/zMyA+a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="A/zMyA+a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gp98w6D3KlXrs0t+OeKoatgJmpe1WDrqOjQVUyffE6A=; b=A/zMyA+apAdDyO6djNbTokup3t
	3K1C68egFqZbIEVx+pyQ69SRYw/uMltLkzUU2MwvaAbgJnA2Sic4vN7UFezX/mQOspfTqSaitqJmW
	6KO392J3htOzWOEOhNiq+5k8oI0cj/a8YoTKsgnN0i4RMp9rhFXTyPYh03ADZpRb9LCD7Vj9YDP6J
	zAwNwH2N76hUBqhs1bEG81l1m4m9NpJIKTK3npWZoERYbU0imAHMjkZv3b3ojOkO6aaZJ4LZY/4ks
	rTsWRJilq5k3vYyMSyGJVchKZLyTX4hsbqqeF0VySzWUH/IK6pBLCl8x/OahuIuOSSgf+9Sxkd8c4
	MqdnSkNA==;
Received: from 213-147-165-125.nat.highway.webapn.at ([213.147.165.125] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whOF9-0000000Gi2h-1vZG;
	Wed, 08 Jul 2026 09:06:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] raid6: defer implementation selection when built-in
Date: Wed,  8 Jul 2026 11:05:20 +0200
Message-ID: <20260708090614.1431014-7-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260708090614.1431014-1-hch@lst.de>
References: <20260708090614.1431014-1-hch@lst.de>
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
 lib/raid/raid6/algos.c | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/lib/raid/raid6/algos.c b/lib/raid/raid6/algos.c
index 6f5c89ab2b17..e7984bde5157 100644
--- a/lib/raid/raid6/algos.c
+++ b/lib/raid/raid6/algos.c
@@ -236,16 +236,6 @@ static int __init raid6_select_algo(void)
 	int i, cycle;
 	int error;
 
-	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
-		pr_info("raid6: skipped pq benchmark and selected %s\n",
-			raid6_algos[raid6_nr_algos - 1]->name);
-		static_call_update(raid6_gen_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
-		static_call_update(raid6_xor_syndrome_impl,
-				raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
-		return 0;
-	}
-
 	/* prepare the buffer and fill it circularly with gfmul table */
 	disk_ptr = kmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);
 	if (!disk_ptr) {
@@ -329,13 +319,40 @@ static int __init raid6_init(void)
 	static_call_update(raid6_recov_datap_impl, raid6_recov_algo->datap);
 	pr_info("raid6: using %s recovery algorithm\n", raid6_recov_algo->name);
 
+	if (!IS_ENABLED(CONFIG_RAID6_PQ_BENCHMARK) || raid6_nr_algos == 1) {
+		pr_info("raid6: skipped pq benchmark and selected %s\n",
+			raid6_algos[raid6_nr_algos - 1]->name);
+		goto default_algo;
+	}
+
+#ifdef MODULE
 	return raid6_select_algo();
+#else
+	/*
+	 * Pick the last registered implementation as the temporary default until
+	 * calibration happens.
+	 */
+#endif
+default_algo:
+	static_call_update(raid6_gen_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->gen_syndrome);
+	static_call_update(raid6_xor_syndrome_impl,
+			raid6_algos[raid6_nr_algos - 1]->xor_syndrome);
+	return 0;
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


Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=109.224.244.107
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795739569;
	b=s0yx3EQYqrcFVvTemqYj3ZrmS5JIqq5UaxiUwrnEDyNjsLs5w0/C1nvtnBxiEpal5bK0
	 JB+v4yWIwERKN8vIPdeipx0M078EEF7WpSECItG2u5HCIxvx9KPbUoaKfcrCnhDaO16QC
	 eXQIcMGj2l9z4jd/6rPV0WlJMqe/PRdoIiPS0PfFB0rCnerZRfRYYgM5iWsPaONhvmZo/
	 uJ509KLVtlTeBaRtOcvMuB0Zqd+Ow3ABdD349BPaicOdFEmz74Zg0TRTM320ijR3BvfMh
	 tlV89Be1nVE3pllUD7TmEza54GN8a4n5HbksNzdPOrSkkcn6EpYrGMHxv8yigkenQcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795739569;
	h=DMARC-Filter:DKIM-Signature:X-Pm-Submission-Id:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=oWrY0IdcXuXHwDcND0NQDhZHR8oSU0v2rB+kuZqFIao=;
	b=kfgG2lKy6NvHaSWHBIkde+Syy+No7IkAlDHYpahqW6Q0HzAJOcD37JuQ1do6JZ3l+s0c
	 NNJsiHNp0rksH2g9ISF0Na8tzOjRyEbyJfoq6IHo55aCDaQpONl5/JbebtYEZ5+oCj9A7
	 J336tIjzpbgIx6RGY1hvSbD5GlfCrEzp9MVdX44bGNSbUFbakrhxpGdRodJRrcnknxCrM
	 RlztFAYiNlqneoshcXzLAnIOnsgaDgvZYqk1BlHfoXARblZq/qlWnBLMq8KzVDEOdZri5
	 C9n2sC67x0akso55QYARwXc/aGr9WrQ5o+liQR/HG81sOW2B21IWeV1U9YG0LIy1bkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=raidlab.org;
	spf=pass smtp.mailfrom=raidlab.org;
	dkim=pass header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Mg++24YK;
	arc=none smtp.remote-ip=109.224.244.107
Received: from mail-244107.protonmail.ch (mail-244107.protonmail.ch [109.224.244.107])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB729606A321;
	Fri, 27 Nov 2026 00:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB729606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=raidlab.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=raidlab.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=raidlab.org header.i=@raidlab.org header.a=rsa-sha256 header.s=protonmail header.b=Mg++24YK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=raidlab.org;
	s=protonmail; t=1795739566; x=1795998766;
	bh=oWrY0IdcXuXHwDcND0NQDhZHR8oSU0v2rB+kuZqFIao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=Mg++24YKUqPtS0zOfnGz+4usH10kWlFfdSJB5BKn6U4hUdOIsqh9KOUZE7FgM1o9F
	 YsUUVVC0GCjI6htgZvwwdB6hsFAAWaNu7T7xn64T62+TYDSRbVbP0dDi+d3haj1VFK
	 /CApmRtcmI3TexjSCfnjwHC5NHDPux3Iti0aYDaAmPwV1gjaDmwN3vPw1WzW2NV3cA
	 tGkhQdwx+9bh87LN0L8mJHNYzm8dR/xshonL6f4cdSCDSP368EkvtmNnNGd5mFZZ61
	 rxkFH00CwQSQXsTaIm3oepiqAsA9ZSgIqI2CeiZmDP6ft7pBHSjV9StkbbBpC+ZIKQ
	 F42SaF12jkHVQ==
X-Pm-Submission-Id: 4jbDs82XXmz2ScQK
From: Miroslav Cimerman <mc@raidlab.org>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	NeilBrown <neil@brown.name>,
	Mariusz Tkaczyk <mtkaczyk@kernel.org>,
	Kenta Akagi <k@mgml.me>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] md/raid1,raid10: fail writes that waited while the array failed
Date: Fri, 27 Nov 2026 00:32:26 +0000
Message-ID: <20261127003231.1180197-4-mc@raidlab.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261127003231.1180197-1-mc@raidlab.org>
References: <20261127003231.1180197-1-mc@raidlab.org>
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

md_submit_bio() fails new writes once MD_BROKEN is set. A write that
arrives while a failed device is being recorded passes that check and
waits for the superblock update. If the update fails on the last
working device, MD_BROKEN is set during the wait. The write then
continues, reaches only the remaining device and completes with
success. After a restart, both devices assemble as in sync, and reads
can return the old data.

Check MD_BROKEN again after the wait, and fail the write. dm-raid does
not go through md_submit_bio(), so leave it unchanged. Large raid10
discards go through raid10_handle_discard() and are left as they are.

Fixes: 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10")
Cc: stable@vger.kernel.org
Signed-off-by: Miroslav Cimerman <mc@raidlab.org>
---
 drivers/md/raid1.c  | 12 ++++++++++++
 drivers/md/raid10.c | 11 +++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 37d120a63778..88bbe81c7798 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1489,6 +1489,18 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 
 	wait_blocked_rdev(mddev, bio);
 
+	/*
+	 * If the array failed while this write waited, the failed device
+	 * might not be recorded. Fail the write, as md_submit_bio() does,
+	 * except for dm-raid.
+	 */
+	if (unlikely(!mddev_is_dm(mddev) &&
+		     test_bit(MD_BROKEN, &mddev->flags))) {
+		bio_io_error(bio);
+		allow_barrier(conf, sector);
+		return false;
+	}
+
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_sectors;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a97831823c68..a38b95585e35 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1378,6 +1378,17 @@ static bool raid10_write_request(struct mddev *mddev, struct bio *bio,
 
 	wait_blocked_dev(mddev, r10_bio);
 
+	/*
+	 * If the array failed while this write waited, the failed device
+	 * might not be recorded. Fail the write, as md_submit_bio() does,
+	 * except for dm-raid.
+	 */
+	if (unlikely(!mddev_is_dm(mddev) &&
+		     test_bit(MD_BROKEN, &mddev->flags))) {
+		raid_end_bio_io(r10_bio);
+		return false;
+	}
+
 	max_sectors = r10_bio->sectors;
 
 	for (i = 0;  i < conf->copies; i++) {
-- 
2.53.0


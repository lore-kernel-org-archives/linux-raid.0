Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E598A3A9D8A
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065576; cv=none; b=DPNdarONRfePeLbOh9KJugnos0KSBckoLiByCWcANWdADmK8mLJJVPWFZv8vg6Ep4X+rAXMWujonhV8aunAq08Tu+OrfPChgHg2DmhgGgXP7TkIn8WLXsMeIaNDlJ6RQgVjqjE/nBq3+GywalsM9y91uFdo1hqeYloMNdDqVG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065576; c=relaxed/simple;
	bh=5VbqgoxnpZ25+DAS/Bu8wOeDLmqQ+TGKyYgc7R7RYZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SqxSL0MQBg+u7fp71n7rBCmq1seD29wFmXFCc1XO14zSzVyzdjFEKNhxBEnWe0l0YYPH2tPuUB3n8MFCkx6CITTWAAmUH1qwMYzvvFHCPAhAAaOjByVQ5K/y+nM5PMmarjOAwOk/bEcpjTI48UJD5BJOX43jeOOUCmRVn2E57sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=I8CoToVg; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="I8CoToVg"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47c6e9a694bso1042036f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 04:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065573; x=1785670373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LVDrwHOShpJST2v1XpPaKOLt9RN1zMUNY9kPyJb4mps=;
        b=I8CoToVgnhfi6CD5hsnL1S5lf9veroblUqePdat1VA8hZao7t9o1XOYIWdG2BAtYD4
         Ewb+M6RPysjyjg7CefuJHYjobEuZqV2emlWsOXXoeu/xEY/qYUY0hwCelAB45Z5C+3Gf
         RktKAwkY83aALcsTcUf0a45zV5UwkBSiYGdvd7SFAPrEHhE9aDZR4oxZiU07zt7In8+l
         1KdKEsKN4x/Q7NOxsXaD5eM/3+O1fWWnZQnZ3EL9OqkuZ4TL0Se1jx5BmTusLCZpdeF8
         MWo9BVeOhdMwTqdpC1QGYm56Swe2twQGWP/dLqmEW0a5SpmP7xIddo3pdnbN8+jkA4/u
         KE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065573; x=1785670373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LVDrwHOShpJST2v1XpPaKOLt9RN1zMUNY9kPyJb4mps=;
        b=HqAUnAithaoKHv8LeR7BPsIv2drG3geOoICuxDQXRixMFa0Oay7QiI5ZHgOzdw7Hjp
         IYVZ2Z1isk2B4ITeCSYiLcQ0KOPjSk5SYyMv1Mw+T5Vxmz0gyGYRsOuZ3OKzKxII4MYA
         4efWBpQJTZKlrzbQTyGw0ZeN8RSYmI6li4PGMlh7z3+kFqigUevrtpGB7Cvh3U/oaoiU
         feYYI4JvIBh1zr/7orbic87uySanEvfgmSyQAImWL+Hh9kwQw6PkvnX/kt2YaKjRE0zX
         yF90wAAOxyPL/a4C4N6No4whv7+CZHDPKv+hkUZ/8PlZ29hSbvLrMMpOoALPkk5g6C2b
         hK9w==
X-Forwarded-Encrypted: i=1; AHgh+RrLrV/+pYTdM5Vv6JuMCeG081hMyOsJFwE0fPuLDtrBCJe0bFt4lLyFuO/Dt74iA0J/E88xp9LwApYh@vger.kernel.org
X-Gm-Message-State: AOJu0YytbD6H494FrlitcLRjuvk9E2puqjWoI4SkrO+/6McoS7ZQ8t9y
	PK9ZT6+jl+RcA7h033KUkreAfFUm7Ki9TvA5NOA34qxOotKFiXvkKuT9GuiX6gB5Lg==
X-Gm-Gg: AR+sD12wLis5zDXMQSgPRKmdzF20rpFVJKnriYhZXIO/o1839kMIdv0AA4MmjNU0B5E
	xFmRATFeBjTMNE3aexgcOd8AtEgUAEKyNDD27PIZtQaVuTZRTpkFJ/n8jNTPXSPSuaWwG4weSdQ
	FP2NLhh9e0GsFdFOxa6zpezONKisbosOFj2++LgwX/2oZ507fXzVMVc38cfN+x1wycfbwxrOROr
	C9EYLVlPRzMNkSeB1tKfuS3z/zMBcXVgUj4IAgZayBVnmTqlQDcuj5/9zMegFK5ThspGSSVbjfg
	6R3hJDPM+AjsfmFs5jIc2CApGebZccJP52S+fVmGvX5LBsTKdALwBjFA4DhG9da7mXIAEEQXnGe
	sdhIGOkkG+gGxngElvEnrqscGSj74Ul0ma16tKqQKwaiChkZzU9TevFnoAsahfvZsWpCBaxFoZ3
	RXuOeq3pj6BCitGvsq4oYUoUTBMtIAjsgfOg9itqtk99ioCNaDxFWPxfSVUBWRYjMY6JSurmq1R
	ApMGk8VBVNJsTevUiUUtd0A96wGomIuvY/72OjUtg==
X-Received: by 2002:a05:6000:40e1:b0:47f:8fb6:c32e with SMTP id ffacd0b85a97d-47f9fea93b1mr5573278f8f.46.1785065572724;
        Sun, 26 Jul 2026 04:32:52 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:52 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 08/12] md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
Date: Sun, 26 Jul 2026 13:32:25 +0200
Message-ID: <20260726113229.2154269-9-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A read that fails with BLK_STS_P2PDMA cannot succeed against that
member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
Skip the read-error machinery: there is nothing on the medium to fix,
fix_read_error()'s probe reads into host pages and would "succeed", and
charging the read-error budget would evict a healthy member under a P2P
read workload.  FailFast eviction is skipped for the same reason -- the
request never reached the wire.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-fable-5
Co-developed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1.c  | 4 +++-
 drivers/md/raid10.c | 7 ++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 83ebf40237d5..16a47568679f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2657,6 +2657,8 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 {
 	struct md_rdev *rdev = conf->mirrors[r1_bio->read_disk].rdev;
 	struct bio *bio = r1_bio->bios[r1_bio->read_disk];
+	/* evaluate before the bio_put() below */
+	blk_status_t status = bio->bi_status;
 	struct mddev *mddev = conf->mddev;
 	sector_t sector;
 
@@ -2674,7 +2676,7 @@ static void handle_read_error(struct r1conf *conf, struct r1bio *r1_bio)
 	 * read error.  This is all done synchronously while the array is
 	 * frozen.
 	 */
-	if (mddev->ro) {
+	if (mddev->ro || status == BLK_STS_P2PDMA) {
 		r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
 	} else if (test_bit(FailFast, &rdev->flags)) {
 		md_error(mddev, rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 77c7d8a59916..462f622556ed 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2847,7 +2847,9 @@ static void narrow_write_error(struct r10bio *r10_bio, int i)
 static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 {
 	int slot = r10_bio->read_slot;
-	struct bio *bio;
+	struct bio *bio = r10_bio->devs[slot].bio;
+	/* evaluate before the bio_put() below */
+	blk_status_t status = bio->bi_status;
 	struct r10conf *conf = mddev->private;
 	struct md_rdev *rdev = r10_bio->devs[slot].rdev;
 
@@ -2859,11 +2861,10 @@ static void handle_read_error(struct mddev *mddev, struct r10bio *r10_bio)
 	 * This is all done synchronously while the array is
 	 * frozen.
 	 */
-	bio = r10_bio->devs[slot].bio;
 	bio_put(bio);
 	r10_bio->devs[slot].bio = NULL;
 
-	if (mddev->ro)
+	if (mddev->ro || status == BLK_STS_P2PDMA)
 		r10_bio->devs[slot].bio = IO_BLOCKED;
 	else if (!test_bit(FailFast, &rdev->flags)) {
 		freeze_array(conf, 1);
-- 
2.52.0


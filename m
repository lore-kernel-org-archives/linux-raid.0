Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF653A641D
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065570; cv=none; b=NCyM38icRgwKzOd0MMXlbEhXqoF4EN3nJGYH3SmGY9f1u3ERLEdcfxWYp9lZw2Edzpjp4SN+xZjEBF917nsZ0WDAagzi6vnKXT2AIzDxw0qGs0SZSODPj7TTvfvBljH3GE+0bJr+HBag2KIaZIPi9naLqTi5EpqcLt+XaYRK+Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065570; c=relaxed/simple;
	bh=B1aIegApdgScj51bEIGVKX+FENfztmE4q/fjJ31TwzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8mw+wEcneUJ/6ux3LKLrSxrf4BYQG1PL+wLnezCltoYh2eK82KpUatLY+B41Lwyqoxk/GuwjrGi3xVWFnSc+NB5KNrPI764c85l4z8G0PB4EmOKrfBF2OBWth8vya3CCPs4LWQ8vYrubJh00wVfRNRakgoQSVu9IB8uUSS0kIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=DorYaqq6; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="DorYaqq6"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4728c12ba97so1097677f8f.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 04:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065566; x=1785670366; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=DorYaqq60eepV9rkw2WLxOal0xhjSKbGs9hrRJ1XPVYOI9kOpk/Dm3PiGoGNaPW3gz
         vci0JAfUL9vlKjkzhHyl+zoF95mf5S/QQiLXoEYXrj8UhDCqVUkl8/U+9AOHBYsCWLJV
         BRcirt+Gy3X+vnTRZ0QeYEx1ycOYLro84nFCm/kSGJZd8AwXJNi4NJoOz2F+FTYwYvuA
         +qHQTnbqhWoTz8J73z+OypD6SF6GbcWkjKmN6mv95758cWif1C5M+6kcL6eTApr0P0NE
         mQITvxApZyeGMyWb4hUJkXstxw/jbbZh/3czgPLxD1d/u+e9y9PjxrCW9EHfAFQ/BH8Y
         oakA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065566; x=1785670366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vP39KbYqkNNRmuPyaoPhdZlQ+sTmuJQGW6DJY4lSzaU=;
        b=DyONsuk94aIwCt47OvTifxf46MXCec6Dpd4VUdjQGQROUXvp+3tcjNGYUGjF0aPkG8
         q0G1BctueJTzI+LYMMz/JrH2ZxqD/fjQ3DPwtz88B73VMiAQDADhc4bCGWdKKbOf0KPN
         6eM3A7eS83aUyi7qos5iIeFfiNA50/Mo2a33zI9rIKiO/1v9yVkMlx4G3Wamf/WnO38g
         qJYeaSwC4EOudKXXjqdkDWnl0AX+CRJTxXEm8Hu0HNx9Die34nSXHecKpkfRPG1kTjyo
         hfe3kTrALdXTWm637DRMhPfgcRXavDV8WdvIy7wfu+YWrCDbvwU0vxdAlU9Al0P80HKu
         JKlw==
X-Forwarded-Encrypted: i=1; AHgh+RqK03Rulmr6RMboDMgP8Qc57JW7RpKdKjesEzaM/1DvZ/OZxxdXjQ49WEDqZ0/QNN/9bZigZdLZOwAA@vger.kernel.org
X-Gm-Message-State: AOJu0Yykg0neFmSmLxeECFl+rnoe/sEubNdHZRikcX7W30vgyb7/T4i+
	BxG9reR5ESJ8dholRA9rK9bA2+cjpaAIrAjLtV4Mki96jmaekNW43eTFqF5ZruCiog==
X-Gm-Gg: AR+sD13srK53IAQrdU3LK8hlzfVXQonefv4tVyJgai/aD0xzPfogr84WXOynz2Tu/zK
	t7Ho2R4ScU0Ch97yGA60cd15kiPnGrrI5k0VPDnPvfVQp+e2WWUXM+0L7ezQX7DwH0zogioxiSA
	t2fjmznc+Y6cOZvrnCXIkuu8X+vNP6PPQvYlALch9RJWx3C5bwScsrkUtiVUGoEcY4hqDboobTV
	ZaFe0ZwO81Oj64qhboQ8OzZ7UEWem2C4HARYljqrEWu2qoUJG/603EnTv2WZPf6sOoi3LmRiQ8Q
	ZgLFtlKNvVr5eYbww5D+zwh9eu4v8jG/cltU+mug5WxUWAhnOv7Hf4g2XShB/PBDlV2BFpUJT1n
	DsR6hHz9CQ/qYOvg8/P/6EWHgh6yBMpLAQNnDE7cgQOkiKfXYJjiQhlAqpijVomfq8Paxvz9bRY
	wONMzKHR/2IGamiANr2km+q882MWvQlP0FApcbx//dPwP9qog+KO9YtdR326iGenwXLlu/X8LAl
	5AroTRTVmJnkNY3YqbZz2ZRmmE5+fkFMhjc9HMGeA==
X-Received: by 2002:a05:6000:200f:b0:46e:c978:7ddc with SMTP id ffacd0b85a97d-47f9fe9bc91mr5809021f8f.24.1785065566081;
        Sun, 26 Jul 2026 04:32:46 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:45 -0700 (PDT)
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
Subject: [PATCH v6 05/12] md/raid1,raid10: factor out raid1_write_error() helper
Date: Sun, 26 Jul 2026 13:32:22 +0200
Message-ID: <20260726113229.2154269-6-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

Factor out a common raid1_write_error() helper from raid1.c and
raid10.c.

This will help reduce code duplication in subsequent patches.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1-10.c | 13 +++++++++++++
 drivers/md/raid1.c    | 13 ++-----------
 drivers/md/raid10.c   | 10 +---------
 3 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 56a56a4da4f8..cee21452e066 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -303,3 +303,16 @@ static inline bool raid1_should_handle_error(struct bio *bio)
 	return !(bio->bi_opf & (REQ_RAHEAD | REQ_NOWAIT)) &&
 		bio->bi_status != BLK_STS_INVAL;
 }
+
+static inline void raid1_write_error(struct mddev *mddev, struct md_rdev *rdev,
+				     struct bio *bio, bool allow_failfast)
+{
+	set_bit(WriteErrorSeen, &rdev->flags);
+
+	if (!test_and_set_bit(WantReplacement, &rdev->flags))
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+
+	if (allow_failfast && test_bit(FailFast, &rdev->flags) &&
+	    (bio->bi_opf & MD_FAILFAST))
+		md_error(mddev, rdev);
+}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7d769b6460ca..f07edeac6e5a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -483,17 +483,8 @@ static void raid1_end_write_request(struct bio *bio)
 	 * 'one mirror IO has finished' event handler:
 	 */
 	if (bio->bi_status && !ignore_error) {
-		set_bit(WriteErrorSeen,	&rdev->flags);
-		if (!test_and_set_bit(WantReplacement, &rdev->flags))
-			set_bit(MD_RECOVERY_NEEDED, &
-				conf->mddev->recovery);
-
-		if (test_bit(FailFast, &rdev->flags) &&
-		    (bio->bi_opf & MD_FAILFAST) &&
-		    /* We never try FailFast to WriteMostly devices */
-		    !test_bit(WriteMostly, &rdev->flags)) {
-			md_error(r1_bio->mddev, rdev);
-		}
+		raid1_write_error(conf->mddev, rdev, bio,
+				  !test_bit(WriteMostly, &rdev->flags));
 
 		/*
 		 * When the device is faulty, it is not necessary to
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..5b63175fb382 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -482,16 +482,8 @@ static void raid10_end_write_request(struct bio *bio)
 			 */
 			md_error(rdev->mddev, rdev);
 		else {
-			set_bit(WriteErrorSeen,	&rdev->flags);
-			if (!test_and_set_bit(WantReplacement, &rdev->flags))
-				set_bit(MD_RECOVERY_NEEDED,
-					&rdev->mddev->recovery);
-
 			dec_rdev = 0;
-			if (test_bit(FailFast, &rdev->flags) &&
-			    (bio->bi_opf & MD_FAILFAST)) {
-				md_error(rdev->mddev, rdev);
-			}
+			raid1_write_error(rdev->mddev, rdev, bio, true);
 
 			/*
 			 * When the device is faulty, it is not necessary to
-- 
2.52.0


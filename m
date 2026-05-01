Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B339D6C6
	for <linux-raid@vger.kernel.org>; Fri,  1 May 2026 11:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777636030; cv=none; b=CoceUMtZAWuyNd/gZbckC6lX/vHKE9zuSjY0sdUyDVaDxqPSwOvaBq2xppX/JDfB9L+ESR6dKWk8iAuAwholZLXumLvHPMTMH7THbPOHcBNCg3DCE+A630uHH1oI43h2CpbCtGpmxhBT/Dwn8J+Newc7r6U3Zo2XBpaZmkIM0So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777636030; c=relaxed/simple;
	bh=2tkshv6RNUHaw17n3hyMG/8cvdL2bnJSqh32+9Y18ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=by6yewtE1UPL0mHModtL2kYKB6bptugEoBwRCZNbR3qGjcT34+3UT5/XnDCDselrsuawYLbsY0KSHsyfvenK85FYmC+kmz4rNY3NBjhNHjcX0jrVB1Md5cPRMyHWHcaDkAA+ryefTw+kHhNxZXVmgCOT/elyziyyFLwkc0xe8Yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEwvxzYa; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEwvxzYa"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-488ad135063so15509835e9.0
        for <linux-raid@vger.kernel.org>; Fri, 01 May 2026 04:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777636027; x=1778240827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/AQMFflzu8Awj9MuV1XBDZv36TqZfHy0cYYLO/nHMK8=;
        b=AEwvxzYaJ3PvUKKxKXH45HrIib2Y5iuF0tmEoQc+/Na8fzU0q0vJ6oTJDzs/zReMRv
         nvoKGeE/ZfBYUtY2YvA40HSjxR+Ee/J223RbyMopsz4MSAm1/fQ5LWVcGXKuh7iqFRkO
         YTP27y7+Qt+tkOgEcwO0QekfVa5nQnOcF/XNP2wI/DLhn97ZQsuPWIWt32navimOIpMg
         PzjSEpe9PcNxBwdwv3sLi1MUxnfHQUG0BKfp9eqzpGAFupWrbfpF6+9AclN/cWHuB8hM
         rvYqaaObp2Y9cXn2UXpwBurDpp7XKbEsMkx6ZBpUSezZh2tR0gwF7Xxa0XGpMYUTVyRR
         02ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777636027; x=1778240827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/AQMFflzu8Awj9MuV1XBDZv36TqZfHy0cYYLO/nHMK8=;
        b=TzkwmPOkXX4UVBtqFsdtuPGa2iL+sJNuZo7VvGKpCft4E2RMG13l/HzJRG5V+/6cqA
         Id09w5bwQULWG3Ujz5vcrl23XsAtDSLUf+5UweDMVhWutV/bsep/jhz+GeL+D2Us07lU
         6PXNnMtnqK9p6ee9SnpkKIhMeURLXCC7u949FKfuWvYexJdU/qLB05VLDXYy8ZzWMnq9
         m11FockOrrqn1i+GWrv5RGqOc406CaUOd1UNt9X3PIRXV/wLb18FM0kjFHFQzyRHqRzf
         pFDeJBTyrY/BOX8sgs0CfijTu5NWJKJrMy0PYCLg9SGmi/CptThCSWKIM3WEv0voC7be
         bClA==
X-Gm-Message-State: AOJu0Yxv4AF8qHTT1KhfvDOcnDwSUzbJLpe+5FvcCKxm8fGcW1acymRl
	jSFspXTPoNNo5m1bR5ss4H5iMhqXRLfn2yhzZOTBi4hR3x35HX9GvRdy
X-Gm-Gg: AeBDieslamQIkToKhBv3HIMciAXliX/MHqAblZka2KAzoizzX8HTNysiyjLopxPNDu/
	vDX3siYbfsw3ckSCvA/sl4+cT1pD0xwubDqw0E3/z7HAredm0MB+ypoUNmBncDYtSs7IBKJ1HxR
	ynnX7DCOgMTIubzkcM2bMBCIooqHn7LD8Uiyh0JzeErxqly/VwMhQhpbX4qYVYUZg8cpExdmOI9
	CiXzqP9ubrX/JsubZyq+xB4guPnjHNhQFpch4uOhKlmAs3w8XrsdId/eSipFvndMR4iMd4SL83F
	tZ+U3KKnR67Pjk7FlJQNNkwWQyWC1cFWuNMksuo2Y9deOKEMf+G9Y/FqoIcCEoMC/zhIL/A9FZ3
	Kc+6KqeI1iCnHCdT9E7kl2a/+8IStzicdUbaNQ69taFTW4/5NY5JPOJ8O6WVATrGXrvjllAwJjo
	xlvxjk15E4HmYWUUefhEVDm9LH+TrompoUKIVCJUroscze
X-Received: by 2002:a05:600c:a40e:b0:488:fd7e:1063 with SMTP id 5b1f17b1804b1-48a84468524mr93816275e9.29.1777636026974;
        Fri, 01 May 2026 04:47:06 -0700 (PDT)
Received: from yocto.. ([2a02:3037:621:7039:f080:d03a:2ee1:37d9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8fee5033sm11797005e9.22.2026.05.01.04.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 04:47:06 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	xni@redhat.com,
	neilb@suse.com,
	shli@fb.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH v2 1/3] md/raid1,raid10: fix deadlock in read error recovery path
Date: Fri,  1 May 2026 13:46:49 +0200
Message-ID: <20260501114652.590037-2-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260501114652.590037-1-abd.masalkhi@gmail.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

raid1d and raid10d may resubmit a split md cloned bio while handling
a read error. In this case, resubmitting the bio can lead to a deadlock
if the array is suspended before md_handle_request() acquires an
active_io reference via percpu_ref_tryget_live().

Since the cloned bio already holds an active_io reference,
trying to acquire another reference via percpu_ref_tryget_live()
can lead to a deadlock while the array is suspended.

Fix this by using percpu_ref_get() for md cloned bios.

Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io accounting")
Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io accounting")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
Changes in v2:
 - Use md_cloned_bio() consistently to detect cloned bios.
 - Recognize that raid10 has the same issue and fix it in this series	
 - Allow splitting bios.
 - Handle md cloned bios explicitly in md_handle_request()
 - Link v1: https://lore.kernel.org/linux-raid/20260427103446.300378-1-abd.masalkhi@gmail.com/

Please let me know if I should add a Suggested-by tag for Yu Kuai,
as the solution approach was suggested during review.

Link to Yu Kuai' email: https://lore.kernel.org/linux-raid/m2lde74dtw.fsf@gmail.com/T/#m714020a38b60fc5f84b9a24f0c46acbe5d7342d6

Thanks
Abd-alrhman
---
 drivers/md/md.c | 25 ++++++++++++++++---------
 drivers/md/md.h |  5 +++++
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e926aef9ec43..96db1e7850e9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -396,17 +396,24 @@ static bool is_suspended(struct mddev *mddev, struct bio *bio)
 bool md_handle_request(struct mddev *mddev, struct bio *bio)
 {
 check_suspended:
-	if (is_suspended(mddev, bio)) {
-		/* Bail out if REQ_NOWAIT is set for the bio */
-		if (bio->bi_opf & REQ_NOWAIT) {
-			bio_wouldblock_error(bio);
-			return true;
+	if (unlikely(md_cloned_bio(mddev, bio))) {
+		/*
+		 * This bio is an MD cloned bio and already holds an
+		 * active_io reference, so percpu_ref_get() is safe here.
+		 */
+		percpu_ref_get(&mddev->active_io);
+	} else {
+		if (is_suspended(mddev, bio)) {
+			/* Bail out if REQ_NOWAIT is set for the bio */
+			if (bio->bi_opf & REQ_NOWAIT) {
+				bio_wouldblock_error(bio);
+				return true;
+			}
+			wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
 		}
-		wait_event(mddev->sb_wait, !is_suspended(mddev, bio));
+		if (!percpu_ref_tryget_live(&mddev->active_io))
+			goto check_suspended;
 	}
-	if (!percpu_ref_tryget_live(&mddev->active_io))
-		goto check_suspended;
-
 	if (!mddev->pers->make_request(mddev, bio)) {
 		percpu_ref_put(&mddev->active_io);
 		if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 3bfbee595156..e44074d30cf9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -1038,6 +1038,11 @@ void mddev_update_io_opt(struct mddev *mddev, unsigned int nr_stripes);
 
 extern const struct block_device_operations md_fops;
 
+static inline bool md_cloned_bio(struct mddev *mddev, struct bio *bio)
+{
+	return bio->bi_pool == &mddev->io_clone_set;
+}
+
 /*
  * MD devices can be used undeneath by DM, in which case ->gendisk is NULL.
  */
-- 
2.43.0


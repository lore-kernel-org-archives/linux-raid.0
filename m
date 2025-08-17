Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E3D242D84;
	Sun, 17 Aug 2025 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755451681; cv=none; b=Nw/FVNaNRMOo1/MiQYPBOaEjPLpk0VwBWSX8BdsFVZz0ePh55gyzvwoHu8/OOlO3ACtLCuT/P+qlY9Igi5ad/5ZdS9IY2Eb6HPkrsjRIhaJHyAVp1k0nsIzysOlWlu8yqG47yzv+7XSFoH6zN81UfnRDo+sWbZpcgXb97EVldL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755451681; c=relaxed/simple;
	bh=Z16A6wKb+5CHTlVaTuyUFV50HSm+dWWmnF3HuqM63DA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3ZKnXhMTJO21/T+6LFxVziGBQUX34IZ2RKQ0ShwBHiDc0bvRI2Rw4QhxlvoIZqjB0cCEoq5j3TE9YYi01Qjlk2rMj+/i+48o7HSMDR/iqgJ1YinS/1ly788SqLvmZn4aFAnmlxrO4qNLcVW2uL4XBo+jC4synaGaGDq33l5tdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=pTOCppvm; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="pTOCppvm"
Received: from fedora (p3174069-ipxg00b01tokaisakaetozai.aichi.ocn.ne.jp [122.23.47.69])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57HHRM9b012978
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 18 Aug 2025 02:27:26 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=SpsUpQPeMzW/cxQhOdPmoTs3YX3IGDY7sgb6At41/9k=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1755451646; v=1;
        b=pTOCppvmnd7ydH3NsS5cxXXYIUIJwXrnjrmkMhcsbKf2Gbf/xALRlJOlzsqQOOSh
         s0MO0yi36Xr/i6W47sUlT95rFjW8yxam4lmjHIxWxo3AwRhXFKIUgzH84KGss/SC
         dvo49hNjtXcp57Fa/GULnK89Hj6I5knnRdRs7L2FA3ECrDLpoWmPObXDt+npur+h
         5hbT1tAyU8Q+cOBvNje5n/oPGsmOpYWp34rfjVm49MBOYF/zFuOj6wpF5TzXCtf9
         cFK7Hed9NA7CYiiaaCCWegFaOiBgDXDxndi8RrfplvEAungTgpXJzLG9D1MRdoeg
         dJGjtszrapMAaGCEI0kLkg==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v2 2/3] md/raid1,raid10: Add error message when setting MD_BROKEN
Date: Mon, 18 Aug 2025 02:27:09 +0900
Message-ID: <20250817172710.4892-3-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250817172710.4892-1-k@mgml.me>
References: <20250817172710.4892-1-k@mgml.me>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once MD_BROKEN is set on an array, no further writes can be
performed to it.
The user must be informed that the array cannot continue operation.

Signed-off-by: Kenta Akagi <k@mgml.me>
---
 drivers/md/raid1.c  | 5 +++++
 drivers/md/raid10.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index fc7195e58f80..007e825c2e07 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1766,7 +1766,12 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
 		}
+
 		set_bit(MD_BROKEN, &mddev->flags);
+		pr_crit("md/raid1:%s: Disk failure on %pg, this is the last device.\n"
+			"md/raid1:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), mddev->degraded + 1, conf->raid_disks);
 
 		if (!mddev->fail_last_dev) {
 			conf->recovery_disabled = mddev->recovery_disabled;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ff105a0dcd05..07248142ac52 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2014,7 +2014,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 			spin_unlock_irqrestore(&conf->device_lock, flags);
 			return;
 		}
+
 		set_bit(MD_BROKEN, &mddev->flags);
+		pr_crit("md/raid10:%s: Disk failure on %pg, this is the last device.\n"
+			"md/raid10:%s: Cannot continue operation (%d/%d failed).\n",
+			mdname(mddev), rdev->bdev,
+			mdname(mddev), mddev->degraded + 1, conf->geo.raid_disks);
 
 		if (!mddev->fail_last_dev) {
 			spin_unlock_irqrestore(&conf->device_lock, flags);
-- 
2.50.1


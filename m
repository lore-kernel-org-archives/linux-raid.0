Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4303431E4;
	Thu, 28 Aug 2025 16:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756398800; cv=none; b=ADfPWjFAjHwTl2vCbDWqnmijdD2PN/fRau73AlNzaMct/agIzSMyb7jZpVzTsaDCpUUBCDNDzLpovS9zRVobril2WlaE9xHOjHR2zW24YapMJOdwkbtTgaokKBL8zhDVMk6S14mwsMg3yYUerTkKuEJzBHq2ARMUmv2tyC79H7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756398800; c=relaxed/simple;
	bh=zwxlB4NHdpJ317nvOoUTW/V+1l4i/m0wQ1sOiFWWfGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVUXRAUPvKxnhOyBppV2NSl6r3VT3zzQpr40bbOcgmmkWC4ET7E1aUDaGH5WMV2FO+1HeeuBepIfem6W+SNN9+Bb8P1uUbVn3O7+Hy94wveaqKvKpQ3h/oAiaxgqdDekimZ2uecd7lPS3JHKXazKCkNKBsoq+XkpnmZm+a6i6nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=Ve2hYYbf; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="Ve2hYYbf"
Received: from fedora (p4276017-ipxg00p01tokaisakaetozai.aichi.ocn.ne.jp [153.201.109.17])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 57SGWlxO041448
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 29 Aug 2025 01:32:52 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=D4d2C6k/b7gGby0RfXhwAkjk+uALIq/RYOX5bSf8zBY=;
        c=relaxed/relaxed; d=mgml.me;
        h=From:To:Subject:Date:Message-ID;
        s=rs20250315; t=1756398772; v=1;
        b=Ve2hYYbfJrFXhw5ky3dsguXLgKiAkDtgK2E6KylUAPUfM0kd74S3EqF0WW829Mch
         HZFrCUnEmkoGIOT9wuyJyZpjdKdpQvm460BV/vhEq18JtXDi0z/vi687eXIht2VE
         YjuJyV/kfzyo0d2t7QspV8NwA5V+nZdgGAkPnXn+OnRQ9t1LWHHjOjDXfh145UeP
         OFJlXMWUXNO/zT9AGUQbnZMLQytksmDNH4DzYVVahfqdCYEXaEzq3S3viSM8NhHN
         vAcM73E11zj4Kq0zAeQ501hH3Uwle+6TFuWftG7bjkVwI/JSYAcfKdPj8dxJmDm2
         X7qBbZYMjAtTwQ+uLIvxsw==
From: Kenta Akagi <k@mgml.me>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>,
        Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kenta Akagi <k@mgml.me>
Subject: [PATCH v3 2/3] md/raid1,raid10: Add error message when setting MD_BROKEN
Date: Fri, 29 Aug 2025 01:32:15 +0900
Message-ID: <20250828163216.4225-3-k@mgml.me>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250828163216.4225-1-k@mgml.me>
References: <20250828163216.4225-1-k@mgml.me>
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
index 8a61fd93b3ff..547635bcfdb9 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1770,7 +1770,12 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
 				mdname(mddev), rdev->bdev);
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
index 530ad6503189..b940ab4f6618 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2018,7 +2018,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
 				mdname(mddev), rdev->bdev);
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


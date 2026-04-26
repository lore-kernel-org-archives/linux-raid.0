Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6715234973
	for <linux-raid@vger.kernel.org>; Sun, 26 Apr 2026 09:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777196114; cv=none; b=FlNEPDQLK69dQq/1cleVnpfEbZHodG7yeD1JIwxDxUb6c7OuuQRlDmQ6Rl4Mi+kaLEiIaXKD9DCbd8wDnWFU31vTFKBeAeTD6Rt4mBUj7Z1ooJotcQ4+IMe9avdngsYEaVWl0mpthhyX9UCsNsdFSrH3IysrS012s3kBhUWab0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777196114; c=relaxed/simple;
	bh=zo624SWXuhPM4Qqrrddsot980vhyyvBwEm1SghzN+zk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jGb5T+7eKTUKWWcqPZNR3SlmLVQLyediL3FhFBck4uT3OyRvkZdc6JvL1DeAsr2nXbmOGEWxXBSxanL/BjuAqJ8ECBi940oySXBBYmiVBI7JDl6vXSF23FGcx+azKUq28JTFS7dXyc7yE1IK0bkeGJgQVeaKbHfJvQXdD24XHPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OMlHaW5s; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OMlHaW5s"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4852b81c73aso76515115e9.3
        for <linux-raid@vger.kernel.org>; Sun, 26 Apr 2026 02:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777196111; x=1777800911; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xxoJ7/yROVN+x+XZWhCqJyIdDhBLXxU+umFFNtD2wEg=;
        b=OMlHaW5sphs4ZbaVoT/qgmK3Z/UEaNrm6Ljo6tXPihrBuhD92yA49cXXro6nHwcBaZ
         S2P+YoXrD2dfgPgzCkX8sWY34vGwPlkNWXILu0/1Q4RRyBpMNktLJCb05epbE8+hVSo8
         MQnlCzL7DanIdH2mb/gAHtw0WUT/N88dK4G8+dx2DdA9RRWC5uHwATcCg5Qzgbw/v1Pu
         F5yB2t3fl//eshF+qgEckyAunty8uTwNvHlAS15/vNpXChmayq/kFVfWZtdRbIpKFBCH
         c7Sdv7F7UNM5MKlFSfINsUoknnslS1yPuCznJ/O/EHRtjFuSnDwFEDuh7P1tpy6aFLuI
         1Xqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777196111; x=1777800911;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xxoJ7/yROVN+x+XZWhCqJyIdDhBLXxU+umFFNtD2wEg=;
        b=sV44UWsI62nnREcOd3LTu8K98xDPYCDywGi2HxZynFozvjvfnFKKnvsiqFoijVIJVL
         yQ4BUZAqBfLe5uv46HKKcil23sPqrPDflk73Dj8WUHKIjmkvsph2LwIUdfFBM8syah+j
         vztNcPAIcyTZ140N6xDmcX3KVbZZ/KTOb2giRiHfQBXOy7w5Wx9ydDRbrQcdnpH5hFVT
         xNy65tlvZPWDcUs8sbrrZHKO2+e5NjcH5gpmW5K7JNTQjaoYS/oGXEvvVM/DRNfUexFS
         cEbtleyB02l4Pwxx38hkUVLRSOeTsfm1WA1S5SAwXyxUvP0CASVwAHBVjQP8ORaIIE9v
         oxBQ==
X-Gm-Message-State: AOJu0Yyx7omPQ6F5doNpnK65Fl11n69erIHorbC0Ki0Jc11eezRKXjtZ
	tqXiWnFBKXkyYOD9lmbzx4up8mIWEZqydku595ovb2X03Ukm91MpVqlL
X-Gm-Gg: AeBDieslB2jjUHx5ZnBk/i2TRLc3qQCjm1L/QPiYC3IMc8cyxwc+znJ0U8ghPrPPUmG
	Eh8e80Z8CqlAEGp2beYupHZLkCsKYad+whlQingh1K3/+uDI/IM94wQjlGzfiTH/7Oumq/fSqL7
	vEGS/DkVR17b+4S1akDFApzFilld+qX8Qslw/Wac811p0wz0QkYUYETFc94cmNDs0tbj4HhIaQ/
	NjIucSsPl3kTxSCkOVvlGOW43hbuX5l15wk6wv4wPo8uu4fSGJdSMJkAb9Xz7JQkZDQaqcFsBpH
	h8bzsqLsoJx5Li38eVez8WiZs3KJEHmdWjP8SdOs3GXgW1LuX8PFwdhyMHUKWNfYhoWE5F+ECWz
	1a1n1AVIST+JODzHKeC6sXQRujm6H3LnvPs5cfqWOX74XsBJKyQOHTonjPj4vDQRzBI/GR1UUtF
	BdvAtnBR2VM/qYlRlgM8KO7HQY5POaSTvM+g==
X-Received: by 2002:a05:600c:1389:b0:485:9a50:338d with SMTP id 5b1f17b1804b1-488fb739d3amr518469975e9.3.1777196111138;
        Sun, 26 Apr 2026 02:35:11 -0700 (PDT)
Received: from yocto.. ([2a02:3037:62d:99ab:d73c:851e:2ff6:71a5])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488fb74c7a2sm224904625e9.1.2026.04.26.02.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 02:35:10 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: song@kernel.org,
	yukuai@fnnas.com,
	paul.e.luse@linux.intel.com,
	xni@redhat.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: [PATCH] md/raid1: fix len reuse across rdevs in choose_first_rdev()
Date: Sun, 26 Apr 2026 11:35:06 +0200
Message-ID: <20260426093506.14316-1-abd.masalkhi@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

choose_first_rdev() initializes the variable len before iterating over
all rdevs, but passes it by reference to raid1_check_read_range(), which
it might update *len and return 0 depending on the layout of the bad
block region. As a result, 'len' can be modified during the first
iteration and reused for subsequent rdevs, causing later devices to be
evaluated with an incorrect length value.

Fixes: 31a73331752d3 ("md/raid1: factor out read_first_rdev() from read_balance()")
Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
---
 drivers/md/raid1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index b549be9174bb..5f5dbf79c903 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -591,12 +591,12 @@ static int choose_first_rdev(struct r1conf *conf, struct r1bio *r1_bio,
 			     int *max_sectors)
 {
 	sector_t this_sector = r1_bio->sector;
-	int len = r1_bio->sectors;
 	int disk;
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		struct md_rdev *rdev;
 		int read_len;
+		int len = r1_bio->sectors;
 
 		if (r1_bio->bios[disk] == IO_BLOCKED)
 			continue;
-- 
2.43.0


Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5C164A8D
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 04:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784261873; cv=none; b=c1MYSx/Pht92AtZXjbGci9GfjJjMc7/L6ptQ6xsjq+aDv82FbzgnB7y5GW5DSgsGQp/drTOKN3cucoMPf3Z3BfR1xlx0eKd2fmLF59b0bY1R3j2yTpsH4/c2q/UoT8kgIu5Vh2ojV1psjEty7cO2EteOgso+P1H4yJJHd4TwF60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784261873; c=relaxed/simple;
	bh=dVNNEjvGRGwxZ0rPFMU+qppV0VANItg4LPC7IgZKlGs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LHd8YLBD832jk22vq8XE0u0j2+FFp6WF4LQEEM6gsud6q4q5acYc688QqYrZAzUAZ+QC11jq15YgnGIH86/QFhrc64MFyVXmBWdf/AyiW+GwTxQhkx1dfl098qUmFhd11l5Q/glU3/v+0fQjpZlHbun8jACVeWqW2HOOjRL/biA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=CTuh3Ls4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="CTuh3Ls4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490791a3e92so8795225e9.0
        for <linux-raid@vger.kernel.org>; Thu, 16 Jul 2026 21:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1784261869; x=1784866669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t7Hk9xvoL94RzAPbfH+98NinjfHTN98HykUdlbzjvRo=;
        b=CTuh3Ls4F/8LU0k96X4nPk19czxr894aB43w8wq2kk/5tuoiLiGcdaXJO++XF16i/d
         iFzWGbg3r/zPgoLvzY/1v9RCr9/JU/9wIWn4/qr8Ele7hgza5xpRBkJskBhREtgMeLp1
         pg7CN031FDCWOjyuo53MPM5YgxqKCQ32OI7k868lLzBu1WvGoSsbPf6ZWieHowzkePtI
         aZ692Zf1eYqraNPdlwU4TyY5DAwp6TWNSJdOAwOq62YiTcQkdqD58yynQqhDfDKLcRkF
         8J3Z7sSJqMlXRShcrUF7nvW+CW8sJgZOghKBMVP/FbNvmabGsJ8xoaJwJq7Ks7yftwEz
         6qCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784261869; x=1784866669;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t7Hk9xvoL94RzAPbfH+98NinjfHTN98HykUdlbzjvRo=;
        b=N0xPAGmlUguKYWU3ZavMQiTuWoCiUVqhzig2T0HcrsXdhTRskl3mG4duB/+6ldhPQg
         K07YPQQnHsZY38n9zNYlhPxiTkqYcxmra3Xz2wC4zruUG7CcbS3l0bxmuV+xiQTX/NTB
         tYhipgncyHvBXUGZCXI2pNMOGmeoAZeg37IJci915SgDNI54huW6ujMmyPdD9jrpW9lj
         iBrlEk7sH2tLALmQaRWKoqCHbzJtn1FqW4Oc17lXrUDKvI/3dE5vtdUarH1WMrjxETn8
         LmZwoUB0vgxUJox5OoX43avQaUINy9Vovrk/9YsbzzY6yD/dnlGdzkd/qAl7suMJuRrh
         KQUA==
X-Forwarded-Encrypted: i=1; AHgh+RqU/IFerNfS/mwGF8aiZtoinuYM5w+3JoKTOEvuNzNwlc+rzJWHJizxvtWfHNTydGcSPJDcWsBejqT+@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ZK31YkgVfz49vamMfDzqghouukSBeA4GjjUkjMi5FYWeFMG4
	LrELkvx8spKmOVXUUvqZ2zBn2gD5WswLSLQDkBXrmQ4IVvO3c/bEa7PfCrjOd/hSiDo=
X-Gm-Gg: AfdE7cnBtMNAuPkBZQ5SgHMfoGGfJy3IVZF/9pZQNq0qT6vF4peWly9Y8u1xMdXU3Nf
	Fq6yPN5E5uWx1EmrVOcsUMvsZKeB2OXD03/wsbiuK7Hai9WZeMPAFLCFwXA8l4vJHsgejOK7oIP
	4BOmFL3pq56TkLoq9AP2eTsr7mhL8uGIMQtzNYTTdozvgSmi1eh09q/xKphM20X8ChoFsWqlEYv
	QgE/STwseaApCdpvi0FbAiSHSEY7c3b+asRx2N0ZDYdatXnF9dkDSAhsv8xrg/55SuYqmlC6a2Z
	fQRjc/4r0WHVU2ZRUGmsv+khhTJs1CvqO+g1QCNYC93d17Zu4GdA8ahxmAkKuz0AH12qPKbyxuj
	33JivD23x7qs0VKDPWsNI8Irqz+jE9KiJ8m/qmB4B8aBx9oAU89QmOjaQdoPhj6ZZrnEJnuMKVL
	XQwgcoTqrHeJ7YDpWU5Dhl3T9De4clteeX2w==
X-Received: by 2002:a05:600c:3506:b0:492:5113:9beb with SMTP id 5b1f17b1804b1-4954a50bcfemr5612765e9.7.1784261869106;
        Thu, 16 Jul 2026 21:17:49 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fritz.box ([2001:9e8:1455:9e00:bd6c:f8b2:6d2:3372])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm15743245e9.3.2026.07.16.21.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 21:17:48 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Date: Fri, 17 Jul 2026 06:17:46 +0200
Message-ID: <20260717041746.363740-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Writing "clear", "readonly", "inactive" or "read_auto" to array_state
calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING so the
array cannot be reopened while it is being torn down. The flag is only
cleared again at the tail of array_state_store() (for readonly, read_auto,
inactive, or the failed-clear case).

Between setting the flag and reaching that tail there is an early return:

	err = mddev_lock(mddev);
	if (err)
		return err;

mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
writing task is signalled while blocked there - easy to hit when the mutex
is held for a long time by a running resync/recovery or reshape - it
returns -EINTR and array_state_store() returns with MD_CLOSING still set.
do_md_stop()/md_set_readonly() never ran, so the array keeps working
internally, but every subsequent md_open() now returns -ENODEV for all
callers: the device still shows up in /proc/mdstat and sysfs is fully
populated, yet it cannot be opened and cannot be recovered without a
reboot (the remaining clear paths either need the device open or re-enter
test_and_set_bit(MD_CLOSING) and bail with -EBUSY before the clear).

Route the interrupted-lock exit through the existing MD_CLOSING clearing
logic instead of returning directly, mirroring the goto-out pattern
md_ioctl() already uses for the same flag. mddev_unlock() is correctly
skipped since the lock was never acquired.

Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting readonly")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..c4de2053593a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4696,7 +4696,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	err = mddev_lock(mddev);
 	if (err)
-		return err;
+		goto out_clear_closing;
 
 	switch (st) {
 	case inactive:
@@ -4769,6 +4769,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	mddev_unlock(mddev);
 
+out_clear_closing:
 	if (st == readonly || st == read_auto || st == inactive ||
 	    (err && st == clear))
 		clear_bit(MD_CLOSING, &mddev->flags);
-- 
2.43.0


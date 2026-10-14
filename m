Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786964BD790
	for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 11:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791978524; cv=none; b=rVbkMN4UxpJPp3QoLgALuSdUsRlJCQsiXFkEvAnH01QLGtpmGZvQ+8uJdKBREjuQB4hCyYDGqUuvGHVtPaM7lSZV0lWTkxYZHtIFGWMG+Dd2x8XL3LQeP0SR9c9QPbMf2a51xGj7tlggeeoZTqzlWTWwmwghXHsL3N1WUFHYKXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791978524; c=relaxed/simple;
	bh=O3hUQ9wkN3PDzZXypiNJPFT+hkyn8LRRyRlW5Amtr+0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qm2NRZ9iHQoztcA9Nu6f00DykRSAguT9yjrWzPkbggBS563kGKs7/API5dozJvL5Pex0jORfrdHG3WNDkg9GdoGt3wk10MVwngSDy+gzWAytyYqhH1CgHDlHBBAYIe5HXV6xvWgDAevnCqBaoV+zk1RgwbN77/o0J8DIScKRjoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=SR1k0paz; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="SR1k0paz"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1bb9aa6bcso342595e9.2
        for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 04:48:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791978511; x=1792583311; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2pf/TLCcQJhqlTchdZFX67WuchZUIfnvCuciK1Vq26k=;
        b=SR1k0pazlYMIbazA+YFZl8tHimlXCZpCNoQLdV8wwo14nT5QOF9gDKN7pwZ93jp6sO
         4sR+a6AYX96Mjz/OQecUAcSzYGLoGIjyzegmST/DuEH3csq61NMAuQfl4yf0NNF9uGRs
         mHbHj1kPuW5jBFYbfBhA77/i+M/XheBDNmxRrskGSCvuKsOoWUugUn1OU2czOox9u5A9
         qudCINxrqQNj5aLMAwDFfBvPOU3SSuHozjPFbjegL3MSq4e2raStVs95jwAC87zCoQJI
         zniyYDpgkiHgh78ea2R3nxKtaHYHL7ar/dc65PUpEQYIYQSxV1PxfI0H5xtO8PzntiI6
         ooYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791978511; x=1792583311;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2pf/TLCcQJhqlTchdZFX67WuchZUIfnvCuciK1Vq26k=;
        b=Vc51ReWHhhbc0m6YpfVQGWfYHj0dQMq/L2aWIZNmocHyJ7PcxkyRPWGCVs6UOuyLma
         hKzeBwbcmEcpeiWu7oQKTFyFAjuXSXVHv8h9LyRAyWSJ5a3dZ2PyfsTWfKZJzi91lOKQ
         bCisEonmtI4N2nCmGlrxaqXVOFrd5EgdC7+rR3+sbl3b+C20eETU9qWmjJxId4/juyzJ
         UKC0PuXdSutbHolt7kK2pCFSxh45LD/h0Mum5507XTcMs5DBVJahf1kWkKMo3NslnsI5
         8iFi3TeBtgrOl3RSf0br9PcnqpeeatR/SDB6/Pz6eSbRANmQ0Eiqf7KelVZtn6WlFFNs
         XIYQ==
X-Forwarded-Encrypted: i=1; AKwUvBwJkVCdtD99JljDIZBwHWRW+x1IrOe/uVIDGWe4dX25Vb4VNi3MZdWgQEvw7FacI3uq22OMr6gbZZoP@vger.kernel.org
X-Gm-Message-State: AFq9FYJbl1Kkcfbg5X9YnqQTB+uxuprO0bntqtVoAGjB9QuWuLZOwFuB
	r8tiZ8eiU7nuBVuZLO2eE9+ioXt71x5Vh/CSZE5wiYmK8devJZ5eedfyNdrmOh3aLbE=
X-Gm-Gg: AYBFou3Ay/Au7j1PYPBFe7TqtEbh2iAFgQ/PLbKGkCoDXLqs3tClVBispyxUzTIfv5g
	XLPcY07P0/96XFnb/cbsob9DS1TAEjpWz7fv3ANlybgjuBt6CEVEEDmAJLJ4pQzvBhx+GuWAVQl
	PM330FS418sw1+orKMBxQotKWJ10M5Q4+B0jVgWdNzLSl/wDVvWuOtwZysCHOnh7gVa8vXj3a9Z
	T0PFe7O6T9hsLYTxeQGt2dx3O3vFPV5fhbN8qAXLWPSMWC02kKHcY5Bt1Utksi31592FRwyEfU1
	QAWmXwcEyF7XtzHMdq3iexZPWp1kSHnXkYXhvzX0Dm0S1imuuXdZerTCDAoK0tIF+KcSTJsmKU8
	ONhM2vCEDi7VyL5UMY98v7HJ6mvYvWOPOrwfLCI8V2IGBR4dU6ANjqooHX2dhB0Ai1xL/f9jopb
	CKpx99H39WZfaChO+c52CtzBMT69pYBT66rLiZraEf7bUTkGJDmjgXS+aeAiy/I+7ndwZC2WHhX
	+E4VeienAtml9WsaJ7ARDiWOXIQxQ7b1N+1lVHKzOk=
X-Received: by 2002:a05:600c:a48d:b0:4a1:9a97:c67 with SMTP id 5b1f17b1804b1-4a19a971230mr156001285e9.1.1791978511353;
        Wed, 14 Oct 2026 04:48:31 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1b4836858sm42925635e9.5.2026.10.14.04.48.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:48:31 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Subject: [PATCH] md: allow growing logical_block_size on a running array
Date: Wed, 14 Oct 2026 13:48:23 +0200
Message-ID: <20261014114830.615589-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Growing logical_block_size on a running array required stopping it
first. Handle it directly in lbs_store(), similar to
mddev_set_closing_and_sync_blockdev(): under open_mutex, refuse with
-EBUSY if the array is closing or has openers, otherwise apply the
bigger LBS.

mddev_lock() is not taken on this path, to avoid holding reconfig_mutex
while blocking on the queue limits lock.

md_release() drops openers without open_mutex, so a bio of a just-closed
opener may not yet be accounted in active_io. Commit the limits with
queue_limits_commit_update_frozen() to drain it. Also take open_mutex
around the existing "enable LBS" branch so it cannot race with the grow
path on mddev->logical_block_size.

Suggested-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 40 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 35 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..cd9c73f46786 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6013,12 +6013,12 @@ static int mddev_set_logical_block_size(struct mddev *mddev,
 	lim.logical_block_size = lbs;
 	pr_info("%s: logical_block_size is changed, data may be lost\n",
 		mdname(mddev));
-	err = queue_limits_commit_update(mddev->gendisk->queue, &lim);
+	err = queue_limits_commit_update_frozen(mddev->gendisk->queue, &lim);
 	if (err)
 		return err;
 
 	mddev->logical_block_size = lbs;
-	/* New lbs will be written to superblock after array is running */
+	/* New lbs will be written to superblock on the next update */
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
 	return 0;
 }
@@ -6046,8 +6046,36 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 	if (mddev->pers) {
 		unsigned int curr_lbs;
 
-		if (mddev->logical_block_size)
+		/*
+		 * open_mutex serialises both paths below on
+		 * mddev->logical_block_size and keeps new openers out.
+		 * MD_CLOSING means a stop is under way. mddev_lock() is not
+		 * taken, to avoid holding reconfig_mutex while blocking on
+		 * the queue limits lock.
+		 */
+		mutex_lock(&mddev->open_mutex);
+		curr_lbs = queue_logical_block_size(mddev->gendisk->queue);
+		if (lbs > curr_lbs) {
+			/*
+			 * A bigger LBS can be applied to a running array if
+			 * nobody has it open, as there is no I/O through the
+			 * MD gendisk queue without openers. The queue is
+			 * still frozen for the limits update to drain a bio
+			 * of an opener that has just closed.
+			 */
+			if (test_bit(MD_CLOSING, &mddev->flags) ||
+			    atomic_read(&mddev->openers) > 0)
+				err = -EBUSY;
+			else
+				err = mddev_set_logical_block_size(mddev, lbs);
+			mutex_unlock(&mddev->open_mutex);
+			return err ?: len;
+		}
+
+		if (mddev->logical_block_size) {
+			mutex_unlock(&mddev->open_mutex);
 			return -EBUSY;
+		}
 		/*
 		 * To fix forward compatibility issues, LBS is not
 		 * configured for arrays from old kernels (<=6.18) by default.
@@ -6055,12 +6083,14 @@ lbs_store(struct mddev *mddev, const char *buf, size_t len)
 		 * enable LBS by writing current LBS — to prevent data
 		 * loss from LBS changes.
 		 */
-		curr_lbs = queue_logical_block_size(mddev->gendisk->queue);
-		if (lbs != curr_lbs)
+		if (lbs != curr_lbs) {
+			mutex_unlock(&mddev->open_mutex);
 			return -EINVAL;
+		}
 
 		mddev->logical_block_size = curr_lbs;
 		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+		mutex_unlock(&mddev->open_mutex);
 		pr_info("%s: logical block size configured successfully, array will not be assembled in old kernels (<= 6.18)\n",
 			mdname(mddev));
 		return len;
-- 
2.43.0


Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2845D8F0
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720521691; cv=none; b=MIEfaUs44AZRcwN7rw8FvonshDaJYz/KlR5I8ba3Z0DD5R6lg34YoIstPsH3ubvgi/F7nnC/pyqz+mJISHfDTqHvWicEQf9MWXIMX3pLdatJMupH7cEJVLqj2qJw+0V7z7jYqPQIi4SdkiQH43zvUU8XX0FQpkhBsIbcBbc/PMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720521691; c=relaxed/simple;
	bh=ZZL5jJS1ytHIMdhIS8ARtvgHBDjCSuyyyNpTUCZRoOE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=f/UitqZXBPDVoTUvvbvRoz8MxLiXyUc62KvYeDPJ8kaxno8OE/oT0E86V9TlDVg92IkJikSKbUOiK3hemRelV8IfJC2hOSHyEtJL5HPtBhsRFrVEEHp9IK9fVF3sS9zTBThhxgBet/4Yy/5+Q/JWwWluEDrSTQhgXHnOYeV3WRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fx1GKw+p; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fx1GKw+p"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-52e99060b41so5322642e87.2
        for <linux-raid@vger.kernel.org>; Tue, 09 Jul 2024 03:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720521687; x=1721126487; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y1fY0BMPnkkyXuDyT+9BIefx9+OknIDFM5iCkaAok1Q=;
        b=Fx1GKw+prUlPDG1eyiSjP4dS2ExWJ8po6UojkQxyyxHZIF3pBRdfo54ruwVVVPPULz
         A5g8kG5nn8D+kncc2kveDU+k/lYgKTq/nrbl+sam/Fg2LsTSU+wrRKWBhqNrpP/iTDL4
         2nK8VXTOdTOpj0DJLPLRa7VV4Ty1sV+huBGAtIYFvRTiXqNaofCkB3FUKhCg2DpcApNK
         Pca7GLucjOXKX6p5WeAvgUNR0fuV/taXO/VMRugfdqRU0GdTlutIdGEzTTrji1tZmzBI
         l1JsaufA+1Hw4fkLvBMu3EaTaaoWH0etIWripaq0H1VyZWYFY7X8qdIU4+Q7ub0wFqbg
         dgYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720521687; x=1721126487;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y1fY0BMPnkkyXuDyT+9BIefx9+OknIDFM5iCkaAok1Q=;
        b=IY/H5tcz83enRLvL3oA7nhoF7SyvrZ3zAQLVgbD9RE9jMJre2OvwZu/XZloUpkkIMM
         C5vebO35/d9iRoGcpWwQPglmC6WkRXfsSYuUSkJWxgVIHyp5qVhNB9nqUwRWCJm8lyVo
         Kf9hWxrVfRQEFW5FDl3h6MyLUW2etqhCD4J1hTFW4vMGYzizuTlM/lNpehrTDsuasa0C
         LKmS0RvO87CHzHysEc8hoqMFVWrbdwLYhVejTfdZQeCNnu7qL85rQ+REiF0h6jxKl60L
         biE8lh2KWte0Ul29FlOo4BlOyizq+dUHgMOBaIBANHEVY3MA/k6my9fzn6Sw1GpeYym5
         ebiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRgEVDrbK4zBmq/DwDT8WNeLyQrmE3dwnZDcc6qfRoYTXl8Bzl2XuU3Pz0XVkXERd/FKen1R8z3MSVfCvBdMyyZW4u3XmeCs0+kg==
X-Gm-Message-State: AOJu0YyCpovFb1pNmtWusSE5m8UpbrxAehKRlY9ZUsMfBl0i92UQHt3p
	5FgP5d3BOtv2TRM3cAcVVThVQ9JT3mPoNN4UYUT6G4hAHJuTyyqANVD06nqD9h/nORXdrgNgNzT
	E+ValOSXC
X-Google-Smtp-Source: AGHT+IGAhMIZKu6WldJuWIfOlF7mhK+9Dq2X/u7VOBMRxiuU/3emTVH5yMDQONDDwwi0RnMkr1cfuQ==
X-Received: by 2002:a05:6512:3e0a:b0:52c:e1cd:39be with SMTP id 2adb3069b0e04-52eb9990eb3mr1529578e87.8.1720521687509;
        Tue, 09 Jul 2024 03:41:27 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a2a623sm13212475ad.69.2024.07.09.03.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 03:41:26 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com,
	xni@redhat.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	glass.su@suse.com,
	linux-raid@vger.kernel.org
Subject: [PATCH v2 1/2] md-cluster: fix hanging issue while a new disk adding
Date: Tue,  9 Jul 2024 18:41:19 +0800
Message-Id: <20240709104120.22243-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit 1bbe254e4336 ("md-cluster: check for timeout while a
new disk adding") is correct in terms of code syntax but not
suite real clustered code logic.

When a timeout occurs while adding a new disk, if recv_daemon()
bypasses the unlock for ack_lockres:CR, another node will be waiting
to grab EX lock. This will cause the cluster to hang indefinitely.

How to fix:

1. In dlm_lock_sync(), change the wait behaviour from forever to a
   timeout, This could avoid the hanging issue when another node
   fails to handle cluster msg. Another result of this change is
   that if another node receives an unknown msg (e.g. a new msg_type),
   the old code will hang, whereas the new code will timeout and fail.
   This could help cluster_md handle new msg_type from different
   nodes with different kernel/module versions (e.g. The user only
   updates one leg's kernel and monitors the stability of the new
   kernel).
2. The old code for __sendmsg() always returns 0 (success) under the
   design (must successfully unlock ->message_lockres). This commit
   makes this function return an error number when an error occurs.

Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk adding")
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
v1 -> v2:
- use define WAIT_DLM_LOCK_TIMEOUT instead of hard code
- change timeout value from 60s to 30s
- follow Kuai's suggestion to use while loop to unlock message_lockres
---
 drivers/md/md-cluster.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 8e36a0feec09..b5a802ae17bb 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -15,6 +15,7 @@
 
 #define LVB_SIZE	64
 #define NEW_DEV_TIMEOUT 5000
+#define WAIT_DLM_LOCK_TIMEOUT (30 * HZ)
 
 struct dlm_lock_resource {
 	dlm_lockspace_t *ls;
@@ -130,8 +131,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 			0, sync_ast, res, res->bast);
 	if (ret)
 		return ret;
-	wait_event(res->sync_locking, res->sync_locking_done);
+	ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
+				WAIT_DLM_LOCK_TIMEOUT);
 	res->sync_locking_done = false;
+	if (!ret) {
+		pr_err("locking DLM '%s' timeout!\n", res->name);
+		return -EBUSY;
+	}
 	if (res->lksb.sb_status == 0)
 		res->mode = mode;
 	return res->lksb.sb_status;
@@ -743,7 +749,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
  */
 static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 {
-	int error;
+	int error, unlock_error;
 	int slot = cinfo->slot_number - 1;
 
 	cmsg->slot = cpu_to_le32(slot);
@@ -751,7 +757,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
 	if (error) {
 		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
-		goto failed_message;
+		return error;
 	}
 
 	memcpy(cinfo->message_lockres->lksb.sb_lvbptr, (void *)cmsg,
@@ -781,14 +787,10 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	}
 
 failed_ack:
-	error = dlm_unlock_sync(cinfo->message_lockres);
-	if (unlikely(error != 0)) {
+	while ((unlock_error = dlm_unlock_sync(cinfo->message_lockres)))
 		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
-			error);
-		/* in case the message can't be released due to some reason */
-		goto failed_ack;
-	}
-failed_message:
+			unlock_error);
+
 	return error;
 }
 
-- 
2.35.3


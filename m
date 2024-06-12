Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B2B3BB27
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 02:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718158765; cv=none; b=jfx868mgqNeFCnUfhBX+RuXRfG5OAnRnrpL4P0sfKOzpUwz5WEXxqw01pioHj1Tk01kYY+mo2V8w7jcL9nPA538j41SSx9fMKK7t/xtS5X3T8SKimSMSM8uP87PwaoqK1gZ3iX+HL1O2wvshXfbDvSJNhuvqjj8YQG0RUBJ/tuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718158765; c=relaxed/simple;
	bh=RSyXlVdtzeHWKB8lPo9xh6jRba45cNhb+mSzFAih3oc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=JgnEjw4aAKm9cGnUJV/EAZpuGR9OH/LyGpAIT//R3SZjZ6Lh68U3MYzjUU8bBR8KCgyeTkMX2BBWUqWT+HvjyF4z4wRh2fho+9Mu7oxP5AA3OVAVR9gNAi1hQODNNGSa7GnrIfUu2rcHK0TFF6gx1L/BnsYnIbKrcuI62o1/ta8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=IVt+OmA3; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="IVt+OmA3"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebeefb9a7fso29506531fa.0
        for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 19:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718158760; x=1718763560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jYV6Kh9etzS6RwvWE6W7QpaYWpUADLWzoG7CUtVroSs=;
        b=IVt+OmA3st+vQeBdPDa++y6Mecc69z5+CDvJDdbdKRk7zVQOzHJTm3mY0LL6a+mWQd
         OsTSkX20HhlwgSUNFyf5AXR9pAicc9TuakbEKNzJyLVVzikxkb2/MMQtCP6OwzfUV8zd
         fd/K+B+T2HP0gcXz7R4HFHBYXOotUb1GoLK/9gLHlUBQXGLAHEqq+ruaB/jHIdQUJ03H
         /mKgwW5GJI1q0pFSqznwg82K06GhUXZIb+ZSfJJRoOx2PknpNTerHB8flZdhWepxg5el
         b0OvEdVB288bo8Hu5vSfDj8JtkwHESiDNwBSqMArLM2EmeYm3+C5ElV2yDYGz19U2UqQ
         D0AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718158760; x=1718763560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jYV6Kh9etzS6RwvWE6W7QpaYWpUADLWzoG7CUtVroSs=;
        b=g1aJgJ7OS6VY+R3h49MbCxpKZ3LWSTyYWd6sBcGSVlvP6ZKetCxwnNhtQsXEIYGA41
         gwcePvuuwAzf7l3zkTjuDrqbaP3R6BAlA7jNlydq4UBHTkrhMjJPa7gBWmEh1e4oxQHZ
         WoYGbMZ0z+gAxNnevLBdZaAFAURFwSaaeyFmsgneKmtqIpw0Q1yCg0jXbmZS/54pM8/a
         ATsb4f5BZSMA6geMVYP3hNSCyKrV1SSir5rNDkduddWcaMxQ0MxDa/jU7NgQWv3FM59U
         /SFcIQqDCwl9NuxJJ93H1nZF4yp7trfwrEAqFtSooK/QP3N3S1k2dwdssEgnFnKIlfPl
         bsug==
X-Forwarded-Encrypted: i=1; AJvYcCU+eXujKELzLxtJvEvbDzdPhY97MHOoqjLJSW0+pfm9PYBu6G0K31FzquQVAZWX2cvl9AEwHcJqqbroOISBOvRZWnCJU1EivOg2eg==
X-Gm-Message-State: AOJu0YyTOX3c8HdqXQg2vHZqz8SH9w2lv8Cv50E40jAi1Sj+cnAq5sEt
	NWSHZMvkumgqU8kYiszeypqAoH3dFLKCezc+SbhUFqYempxZGW3Fwasa6qBdxN8=
X-Google-Smtp-Source: AGHT+IFcTwjWrkqO6YRG1SMjVOj2R/a74iG4KV1Hpd436di178Jx0g1G5GF9P2iyncJSBnWBA1DQ0g==
X-Received: by 2002:a2e:a792:0:b0:2eb:68d0:f1cc with SMTP id 38308e7fff4ca-2ebfc9ad36fmr2550581fa.43.1718158760324;
        Tue, 11 Jun 2024 19:19:20 -0700 (PDT)
Received: from p15.suse.cz ([114.254.76.16])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75f0afbsm353054a91.14.2024.06.11.19.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 19:19:19 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com,
	xni@redhat.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	glass.su@suse.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
Date: Wed, 12 Jun 2024 10:19:10 +0800
Message-Id: <20240612021911.11043-1-heming.zhao@suse.com>
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
 drivers/md/md-cluster.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 8e36a0feec09..27eaaf9fef94 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
 			0, sync_ast, res, res->bast);
 	if (ret)
 		return ret;
-	wait_event(res->sync_locking, res->sync_locking_done);
+	ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
+				60 * HZ);
 	res->sync_locking_done = false;
+	if (!ret) {
+		pr_err("locking DLM '%s' timeout!\n", res->name);
+		return -EBUSY;
+	}
 	if (res->lksb.sb_status == 0)
 		res->mode = mode;
 	return res->lksb.sb_status;
@@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info *cinfo)
 static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 {
 	int error;
+	int ret = 0;
 	int slot = cinfo->slot_number - 1;
 
 	cmsg->slot = cpu_to_le32(slot);
 	/*get EX on Message*/
 	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
 	if (error) {
+		ret = error;
 		pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", error);
 		goto failed_message;
 	}
@@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	/*down-convert EX to CW on Message*/
 	error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
 	if (error) {
+		ret = error;
 		pr_err("md-cluster: failed to convert EX to CW on MESSAGE(%d)\n",
 				error);
 		goto failed_ack;
@@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	/*up-convert CR to EX on Ack*/
 	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
 	if (error) {
+		ret = error;
 		pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
 				error);
 		goto failed_ack;
@@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 	/*down-convert EX to CR on Ack*/
 	error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
 	if (error) {
+		ret = error;
 		pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
 				error);
 		goto failed_ack;
@@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg)
 		goto failed_ack;
 	}
 failed_message:
-	return error;
+	return ret;
 }
 
 static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
-- 
2.35.3


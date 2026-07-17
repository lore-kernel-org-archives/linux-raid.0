Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A504B33AD99
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 05:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784265159; cv=none; b=seqPd0mqREKsHSxqrxpuxVvG4YePQwo/M86ybd58gHWo56anphnFxHnnKXX+U3w9jL3Q7ZtUJcUUL3/oBMoFDo7YLuM9ZxSjMH7S0BhAaD4UFT6LyjBUrcsWhzdsqiXGd1LpYaepfVwunPShQr0kLZ7UcB5PJsfea2yQcUZlTzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784265159; c=relaxed/simple;
	bh=7OgtVrX4qWjQ8RLN3/wCQTJOFkXr58vLLsN5TO3iZno=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GS63z04cJ8gI5fz/cLkUG/CfzCKwG9yqmQtkEsSmnTanIjCcJNrJJA7dECn9OxVt5TZQgZabsyXOcTcufKOLxFlSNgoS4QseaUbPLqdcWoxoY0QwvKTxtzA4dEJOZ13HzWLnRxfBqZ0JTb7VDT/E8N0vefaaiUyTSMDlw1TIFXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=CKtPvUVf; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="CKtPvUVf"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4925a778491so2782485e9.0
        for <linux-raid@vger.kernel.org>; Thu, 16 Jul 2026 22:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1784265155; x=1784869955; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hY/aWdSFnzVfY4ztJ2GhxxkEtTKsmz44EPQBjeTA3NA=;
        b=CKtPvUVfmh4N7lhGD4GuXTJAYYkH0UQTviGwufmtcoKnVoMA3eIfDPXvCUyCcA0/G5
         Ifm2lqKet+jDtDhIApZNzkVGLpDjp3PLt2T58C1MCi6MD4iSTYzPvr/kXBDjZ9SaPW7w
         5TrE8k1VxAodRtWH517wZCY1FUH6tFx+oL36aI30MPc3V0+ECflNiHSUyMy1+7TCpcS4
         jvf/SkSYjw2YtGFr2uaHl/0Ba3lEtHvIloPnQu21ckyqJ5PcIZZOmh0t4DfK2TizFyBK
         l7ROlqasolVkqg/ZSye2tR//1PrhwHoIfa/qRXBOC1oujdTpIbY8Kt/WqrpQVQdcWptE
         4w7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784265155; x=1784869955;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hY/aWdSFnzVfY4ztJ2GhxxkEtTKsmz44EPQBjeTA3NA=;
        b=BQ1MyOUDoTsSXiAFOoSeCjBIaMixu8WuKy/vMAoONfspl18H0y2KRPJWnwDnl8UKDx
         5P8xGEwZAM8ZZkAI7aZYRi/0uty27384yXK3Wvpe82HM49GmN0JVlt7dcCCyYGTBmHaB
         1v4OuRH31sC9cUgqLCTrwbTMKh8AtH/kE51vnWpOXULKix6R1i0erT0myZldRId86WsM
         0RfNpy2zwaZ6PMTLjs6Mp3PhJWn9QqS4xIYHZ/TNLpc/R0jCYaGHREsP12YMtrT/6Lzu
         mONGYl4q+eLnnl98iuZ15MUiOcFqZMUkYE5jeemo2LaF41yX0U7+LWhqLXzpkAaCxei6
         VaYg==
X-Forwarded-Encrypted: i=1; AHgh+RoFU7g709NzKaCFF2ssiCYUSYtO2Z/Hbt/NLyAzE+/rWRvlf3qmEL84nQyz6iKaZ0/zkDWZz/0VJBSR@vger.kernel.org
X-Gm-Message-State: AOJu0YzLvCgJS3I8z6CpRI2zMijOHfXeLbALWAnwIgBVlluPCKZqcVVx
	zOofW4HqhbkP6MWCChRFaMwhh303AEmP5q9jAO48NGFybE5w9gA71vz4+eaBFH9BkmI=
X-Gm-Gg: AfdE7cmWmC6ln8K41aKPbgo1evjXiWFWNHSVzo5vQpLnqgoZnbPP0x3pW4/t12tz3Ep
	r83Et1eKOA/xle9zIJOdY6kgjZy64fQvjRrReFysmTrOQSE9L6tni8Bcr6GCH+tFOuEoyE0dm03
	vfA2eHrPqre8UUanmiZc3Edl6++mtDXLilOgLwXGNVFlFDJzL9c0aE2WF4vRfLyY2xNB2HVoRkl
	8X+Pi5XAXUitpiXDcICftwUlbL+cR/qMN2P0+2xzwdobiGuSC5ORs20P3/R0FUJbTlj3sSrhGN+
	E9DVug4KZuMtR53K0A2/b0j32KXeFWbW76HIfvb0VpSk7GEmsQFXBBYXDYZasAulJ3eB6jXiMNu
	24RqCkyBUfRcvPASdjzLu8Z+CV0nDtp6LZG3cTkpK+4c/MRoEIi9suflOlbSEZ9rGSz4YxkQ3I9
	KQOse86piW1ezW71NtV4lLgyKQ19LoolW5Lw==
X-Received: by 2002:a05:600c:350a:b0:493:f13a:3f74 with SMTP id 5b1f17b1804b1-4954a51df12mr5245285e9.5.1784265154725;
        Thu, 16 Jul 2026 22:12:34 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fritz.box ([2001:9e8:1455:9e00:bd6c:f8b2:6d2:3372])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49549c96f19sm22952255e9.9.2026.07.16.22.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2026 22:12:34 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCHv2] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Date: Fri, 17 Jul 2026 07:12:33 +0200
Message-ID: <20260717051233.383373-1-jinpu.wang@ionos.com>
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

Route the interrupted-lock exit through a common label so the flag is
released. Guard the clear with a set_closing flag that records whether
this write actually set MD_CLOSING: when mddev->pers is already NULL (for
example a concurrent STOP_ARRAY is mid-teardown) this write skips the
mddev_set_closing_and_sync_blockdev() call above, so it must not clear a
MD_CLOSING that the other thread owns - doing so could let the array be
reopened while it is being destroyed. This also tightens the pre-existing
tail clear, which had the same unconditional behaviour.

mddev_unlock() is correctly skipped on the goto path since the lock was
never acquired.

Fixes: 99b902ac1725 ("md: sync blockdev before stopping raid or setting readonly")
Assisted-by: Claude:claude-opus-4-8 [Claude Code]
Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>
---
 drivers/md/md.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..7b7a4d925907 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4649,6 +4649,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
+	bool set_closing = false;
 
 	/* No lock dependent actions */
 	switch (st) {
@@ -4668,6 +4669,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
 		if (err)
 			return err;
+		set_closing = true;
 		break;
 	default:
 		break;
@@ -4696,7 +4698,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	err = mddev_lock(mddev);
 	if (err)
-		return err;
+		goto out_clear_closing;
 
 	switch (st) {
 	case inactive:
@@ -4769,8 +4771,17 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	mddev_unlock(mddev);
 
-	if (st == readonly || st == read_auto || st == inactive ||
-	    (err && st == clear))
+out_clear_closing:
+	/*
+	 * Only clear MD_CLOSING if this write actually set it. Otherwise a
+	 * concurrent teardown (e.g. STOP_ARRAY) may own the flag - this write
+	 * would have skipped setting it above when mddev->pers was already
+	 * NULL - and clearing it here would let the array be reopened while it
+	 * is being destroyed.
+	 */
+	if (set_closing &&
+	    (st == readonly || st == read_auto || st == inactive ||
+	     (err && st == clear)))
 		clear_bit(MD_CLOSING, &mddev->flags);
 
 	return err ?: len;
-- 
2.43.0


Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFDFA4BD352
	for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 11:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791978823; cv=none; b=VDaVaeS/PZuG2FMkWSdLCkNG+kE5SeNG+hqn9tczgDrfkp+9elw1WHFbuI88SGaiSw4+IlNLL+NHxIa4jRUfLyzkCru5ZdWrWN48XQ4RYKNM58CK4iR2G70WIAhPbVhmU6kfh9aLljSqZkqp/+Pc557g1wMBVtJH8H0jmybO9uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791978823; c=relaxed/simple;
	bh=fV5ckFoRMpL8tzwBk+b3CiDquISxyjYCfUTpMEycObs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qXd8xo26PKy9x/+/jxLOLsF9c3xrBOAiXGhsoSexhv9sMUZYlm0X0EihKWkbZrXjYeX4P57OyHOAs0wq/+BSTKN5ilhxi9LMVTyMWz0rk0OSByKnqjXSFiYN8tuSCGLE74FUjO2LvzyWXiYq08Z+Ug/MiU5M6YCk86YDpcpAmhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PF01V8Lz; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PF01V8Lz"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48dc1508191so505957f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 14 Oct 2026 04:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1791978816; x=1792583616; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DCCYXPUAIyRRMCD1jG1kgx8qgwOSRxTPQHP2nAo/2z8=;
        b=PF01V8LzcDCXCiBydvcgYAlUng6ofqrZNrw9pk2S08jHXsf5NosBg7AyHiQW6Rcg/s
         3HX6y7pt46wF0bOyffHd+ulfhg6yXKBrhFBltEG7Ub33GjW9Z8Tb7JN0Maj79lzuV3tW
         g8vrQyJTCEdCIIgbcvaROvvl88xe+qxsAyJtHGfzXD8KBUcsEiRm76xQqCfYskyGeJ+A
         wky3OF2/PUOpebbVyhNIUX4ryFVx5fpXavLP3VL6aiCJHg1NVvwK7zfXoFX8X94goBsn
         XVDE0j+ZWMg9R/qmBnK9kkpqwwPenxngs6h1/YnNwtLWXstOJr/WzgM/RoqW8touGqX4
         WZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791978816; x=1792583616;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DCCYXPUAIyRRMCD1jG1kgx8qgwOSRxTPQHP2nAo/2z8=;
        b=Ir2P4Efm/qYAiS8hDiKaRduxhkXIoalJr+VOCUYQgRSJxHlq8TVfkx+s5z2D9K3saI
         BI5z23FBGC6JQLMbjOEaga6Kd+6kFtjYta1Z8642iH3vIOtI5q7U/1DakVhB7QwVnHDy
         VhN2iuMNFPlzV1uzKcCkRAgrVVX4xcXBZ62dkFZZbb6DJlKeWdauf1GC88+sDbZODhLf
         rkP4sXrXC/Otq3TgmNIknf3uLwFOIp826vhtLkON/GkLAx6HxmJUsAZ3RpCrENvjpV1i
         lsf8/R++06dsOIs9mYC2djn6VU3mXzMsBKy1C9UShkEmbZOjvHeNzCH9tn6+5nxyturb
         dk3Q==
X-Forwarded-Encrypted: i=1; AKwUvBxnGo+hWvrdYO6Li0daZGE2cX64u0MOM6X5f4sftyg/bc959uYy9FjL6UuMuWRfjIJXUVn80SAAPu1w@vger.kernel.org
X-Gm-Message-State: AFq9FYIp0+dwIx+BoV2TQQgVT8lBHfJjqDvDYuX92ScL5SwHM4KGV3Dz
	Nl7lWxhC2PUmNteGdvqyFuE7sNlMqME1kOBe/RKf3Eh9oA2R44qRhg3zp8a/O/5ZMfc=
X-Gm-Gg: AYBFou1n6y8DHWpP0Nxx2EgaLS0CkOcQ6WZ+jQrumxrJz3xDFpN83BORF0KulC3PMey
	ZeplmmgbjYJVhGhna9/jkMw3/xWNO7YsQh7N+jM/ektE3pMdmyKVzwqdIhEDb92xNC9a5Ry+ZqV
	2RMgSoyNfDVXrS5udkCxK+McqOY1TwyUnCJACOOgf3ulNHcvWpxOXeEpcvVzkDHRGVxNSBUGAVW
	eFtgxo4dj8jq2/8JnIzxPMHqKwjdbL5c83zosa6bbQXiXDyYWbe9AeB5DRg+XPpWzjJk3U/qf2P
	wFhgrfyJF0apW8/RSTduKtrDOhOkndufaANE57C7v622NaXeH7jUBbm/p7wLCt5EG2SgtEnnrGF
	LsbnL77qySLQQAcY4J6vX/Du5bYPCnhHlo1w23NoRbgHzuKfap7V+Xr2XEGt3YKgWlD/ny5UxJg
	qqcrribCruKdsUNecpnOs133g9AH/WJSLb45o1Wec5QWsLga7Wr970NW46leRloW5ZKsIS4Nl5e
	YUFAwAl4D6+rDlCYMKzVXNNsyMWmxdOqk6CP0C06U8=
X-Received: by 2002:a05:6000:24c2:b0:48d:f102:aba5 with SMTP id ffacd0b85a97d-48df102acfbmr162515f8f.0.1791978815826;
        Wed, 14 Oct 2026 04:53:35 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de3f7f8b8sm10170728f8f.35.2026.10.14.04.53.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 04:53:35 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2] md: clear MD_CLOSING when array_state_store() bails on interrupted lock
Date: Wed, 14 Oct 2026 13:53:34 +0200
Message-ID: <20261014115334.619923-1-jinpu.wang@ionos.com>
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
calls mddev_set_closing_and_sync_blockdev(), which sets MD_CLOSING to
keep the array from being reopened while it is torn down. The flag is
only cleared again at the tail of array_state_store() (for readonly /
read_auto / inactive, or the failed-clear case).

Between setting the flag and reaching that tail there is an early return:

	err = mddev_lock(mddev);
	if (err)
		return err;

mddev_lock() is mutex_lock_interruptible() on reconfig_mutex. If the
writing task catches a signal while blocked there, it returns -EINTR and
MD_CLOSING is left set on a still-running array. do_md_stop() /
md_set_readonly() never ran, so the array keeps working internally, but
every subsequent md_open() now returns -ENODEV for all callers - the
device shows up in /proc/mdstat and sysfs is fully populated, yet cannot
be opened, and cannot be recovered without a reboot (all clear paths
either need the device open or re-enter test_and_set_bit(MD_CLOSING) and
bail with -EBUSY before the clear).

The window is easy to hit on a busy host: reconfig_mutex is held for long
stretches by a running resync/recovery, widening the interruptible wait,
and a userspace helper writing to array_state and then being killed or
timed out is enough to leak the flag.

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
v2: resend, rebased on md-7.4-20261013 (md/md-7.4), no code changes.
 drivers/md/md.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..f6dfd5d76199 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4671,6 +4671,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 {
 	int err = 0;
 	enum array_state st = match_word(buf, array_states);
+	bool set_closing = false;
 
 	/* No lock dependent actions */
 	switch (st) {
@@ -4691,6 +4692,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 		err = mddev_set_closing_and_sync_blockdev(mddev, 0);
 		if (err)
 			return err;
+		set_closing = true;
 		break;
 	default:
 		break;
@@ -4719,7 +4721,7 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	err = mddev_lock(mddev);
 	if (err)
-		return err;
+		goto out_clear_closing;
 
 	switch (st) {
 	case inactive:
@@ -4792,8 +4794,17 @@ array_state_store(struct mddev *mddev, const char *buf, size_t len)
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


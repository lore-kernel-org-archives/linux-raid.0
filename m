Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF294CA797
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788376; cv=none; b=g342KcYFO9kDhstXMCZ50JikCFC9Nzs0T7l0ft+IK7qEA61drvpIwwltROeMxdvvsRfiOpUHpWtsn5GQFwuFNiOO+N/HjkXeuzWaI3UppD/5tJbBzoEHYJe6QTuSYc8rI3670wTq5KteUcZhVBj/WvAGe5BRaXxWFQPAsBaZAKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788376; c=relaxed/simple;
	bh=//7eSrSROQ1S6s3fnZBiYbUSuvFg2wwvGxVMRZPYtGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz4EJZER0z4RomZ9RLKyWrwoRnptJ5DLYNdqGfly3zn7NOERhvu6Z69YJomqIBO4yCeD4JG3R1reDqn5iblqg+Q89Yr824MBZ7/O8wlj+OOaNKTvabTRWHIcpOIca/ftd1Q1B0Gb8dVmN5j8qEhD0b40+CIZXPffq/t0N6yeXq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=PKCeVc8F; arc=none smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="PKCeVc8F"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2507a618e1so36364766b.0
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 06:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1788788373; x=1789393173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hdM378QxLre0SWIJr0HaM8kMGhNtJLC5f+4nD7MVyXk=;
        b=PKCeVc8FKvA1tykp9xrVr0zTPnxeaGxjYXaj4gAMTCOfKuw0U0QuBqzwhlJ8Hmc38/
         iHnwZS686jA/5Z13DXcLjgJF6XKWodFzJTv0+vCgoNQdsu4+06fhz/Y9c9OB9naF81p3
         cMax+s0eTDoRQ5EPOLzKwkMQtp2+L8IlsRb71Qzf7WR+0RrdMXZ7aJ5ryl8cJreINcEh
         tr0G7pxarE7qBVZhqdkx2MtzWPjLxaoLgl1eIb5Laes0lS/JgVMhhHrEEJVaHUVIvSqr
         uIBAj7FeWAfvfpz9SiRiAfIa66sndW7xMSO5gkg4XurCgNyAE0+u/raejWGtvo/9yUMT
         aRfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788788373; x=1789393173;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=hdM378QxLre0SWIJr0HaM8kMGhNtJLC5f+4nD7MVyXk=;
        b=Fh7DXyv6q+Sfbaig/hD4O4t26YhtFzANr+AYDf4h6+w/D0ugSKYYaP/4lbGoklXjq4
         USa1xZ+p5DU7quYwyCDuPMi8VWlUESYkQBDSq0/NcEkcIyicMeALAoNzElhhe7lCcpA1
         QifnDM2prmAqt3HMqj94RhfLp+mFHj/nk1LKxWinN+HQ9QQKWlvLde1sjk4dnQl4WcNF
         m2Pprn9rdgyDob6tIAqRe9wi6529eimupeYKxFrj22F3W271EkZLNFW6lGvkNcc06pdy
         H8cgof+uzVVnmtewT56x1GFyf8RoJGYD14+1WPVuu3txetIqeooTMg/ZOTW8y2ZD/jDz
         by1A==
X-Gm-Message-State: AFuF++mdQUfpry2/a3itpyxXfHMMoGTvndlx/5R4psiWWdDfFeaL9OQq
	FroerIcjqwXHFEsqIqFlBoZQpGeWG8nPjp3NzCoezfCzIgeY7PicR+kPNWeXFrOX1+o=
X-Gm-Gg: AYBFou3LV3RQwWgnWDvCskKfXnwM+VkKkr7YmHcidKWJk00KDZL8cd/Ww6yL0fgNPX3
	hHreXrw6FMaYr4vwJum+jXzR1jj6Q4F9WEN7Hjy14THK9jVAA0FJ5ozfD+/fU3wJkHaoYVwcOr7
	T0xZC4bWs9tbzSSHm7hsAF8FZZHAVv/XlTibpsO9dej3PT6NtaSb3Q5pWsLOQY4Em/7+dFvZwNp
	GRNO7WryXx5UGXryp4q3zJHe7WsReqZGkRaHNPjV5aspg2JNcwo5vGdQ9TPDuUXYbYWB+nkNp9u
	H8zvG7ixK3RmI5/Bb7yad5O1rkWjWXa9dcikBW9AIgcrzpjDB0H++i6+hn99rmpxXfM20Vqk9Tw
	hNvKU196hfoUP7trLBL7+wVa2m1JLBz25e/52s3deHP/1SwUaT1L/P/fOAhUCei8KxD6nMIwbSQ
	b2FWFl1nTA3eI+wpST7LGdw5p5uFJBjtp+5yBjo5r+zLrAJhfqZZCf6Gg1pYh13Ty5/VpAWgHeR
	V9hoYmUowA3S7DJOmL/0o6TZ0cbQjHOHKI=
X-Received: by 2002:a17:907:7209:b0:c16:604a:b2bd with SMTP id a640c23a62f3a-c261277db4fmr745784866b.3.1788788372780;
        Mon, 07 Sep 2026 06:39:32 -0700 (PDT)
Received: from jwang-ThinkPad-T14-Gen-6.fkb.profitbricks.net ([212.227.34.98])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c262c770678sm314301866b.53.2026.09.07.06.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:39:32 -0700 (PDT)
From: Jack Wang <jinpu.wang@ionos.com>
To: Nilay Shroff <nilay@linux.ibm.com>,
	abd.masalkhi@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>,
	linux-block <linux-block@vger.kernel.org>,
	Song Liu <song@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	tom.leiming@gmail.com,
	Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 1/6] block: add queue_limits_start_update_trylock()
Date: Mon,  7 Sep 2026 15:39:24 +0200
Message-ID: <20260907133929.1081540-2-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260907133929.1081540-1-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jack Wang <jinpu.wang@cloud.ionos.com>

Some callers must not wait for q->limits_lock, because they hold
something the current holder waits for.  md is one: its
check_sb_changes() runs with reconfig_mutex held, while a
queue_attr_store() holding limits_lock waits in blk_mq_freeze_queue()
for I/O that can be waiting for a superblock update needing that mutex.

Add a trylock variant of queue_limits_start_update() for them.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 include/linux/blkdev.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4f7905c3412b..b75e85291e29 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1101,6 +1101,32 @@ queue_limits_start_update(struct request_queue *q)
 	mutex_lock(&q->limits_lock);
 	return q->limits;
 }
+
+/**
+ * queue_limits_start_update_trylock - try to start an atomic update of queue
+ *	limits
+ * @q:		queue to update
+ * @lim:	returns a snapshot of the current limits on success
+ *
+ * Like queue_limits_start_update(), but fails instead of waiting when another
+ * update is in flight.  For callers that must not block on q->limits_lock
+ * because they hold something its current owner is waiting for.
+ *
+ * Context: process context.
+ */
+static inline bool
+queue_limits_start_update_trylock(struct request_queue *q,
+				  struct queue_limits *lim)
+	__cond_acquires(true, &q->limits_lock)
+{
+	if (!mutex_trylock(&q->limits_lock))
+		return false;
+
+	*lim = q->limits;
+
+	return true;
+}
+
 int queue_limits_commit_update_frozen(struct request_queue *q,
 		struct queue_limits *lim) __releases(&q->limits_lock);
 int queue_limits_commit_update(struct request_queue *q,
-- 
2.43.0


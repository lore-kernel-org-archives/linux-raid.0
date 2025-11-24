Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D1B298CC4
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 02:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953069; cv=none; b=Ik6Cwhf7d1j+j5v0k2Ja9qEZcCpDHuCIbibJAfT4aCZh+kejHYBhho8XKtgMqkbJEsqUKY2PQSj5Z4oXHcgDVWQZG3itR51+GSK8vu6iy9lw6hwxpde4hqvthmeeYzKoEvERH9mRpkckwrTZot41NWHv+0jyAmIOKrPD/nT9ano=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953069; c=relaxed/simple;
	bh=2HTt3IkiR546p3idCOAeAAYwiLr2TwU90SfwMF9g4b8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kwtDq3lElsFpRsUnmGRNJSxodn9ZUoHPoCQN3cAZh357KAc/Bpo8uQB2f7pRbTLU7zhItGF4Ez8xb/ToQTZQXkYxkt90FExfouJiHfWzlOOD4kqTPclTSUHFjDogtUtUq4ipVg2BBjyzpArtJ7XedQWCjJytgIZL29Sr+Yhs0oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yeo6oPz5; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yeo6oPz5"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b98a619f020so3045124a12.2
        for <linux-raid@vger.kernel.org>; Sun, 23 Nov 2025 18:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953066; x=1764557866; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4v5MRSjdziMsNVvfMkn8flY57vC+Pu/WImeTNAJo+ww=;
        b=Yeo6oPz584vBtJ6zPEdZMLt7QUMuLgPNXUpBZWa4vqP5bhFW6ju30vZxyUw8e+VSpT
         S+97vu6RoK8+qjTZcjTZdER0e5proYP/mbsKrW8RJpgN9JXG1bJOFdQoso4Na0wJBfZ7
         G2Q9fr7WhvVHWQSUuN0sZVze5DQ/08SZhH98mRLeJcMM8VjGVJoDEhXx7zAtCu9BJ4tc
         VnRelf7Hu8l/uL7c8pSKWXhE4OT9W2206sEzVECcVvP/Tz4u/Oho37s4OeN/RuFkrnSl
         rFUEFE4f9L1Md9walOzbYtdjtUf9LZhDZcVFO79oH1RQaDHzAMSBD+g01704RJGpWdti
         8B0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953066; x=1764557866;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4v5MRSjdziMsNVvfMkn8flY57vC+Pu/WImeTNAJo+ww=;
        b=sDF2dY2cCs9VXi12DzJOQl8GjFsGXCzx2jMW4kWyl9Ut8cC4t5IhdWZpmpCtfmJ9Qs
         nbqRjNVcAP45MA6HJST4ALR5azmBPl14F24fDEJMTTbfMcycP8SOd87JtM2p4MC0Ogrk
         R8OS4q21S+V/ESVIYTEBYAT2IrRJXWt+FE22B9Ww2z4u5HfWWe2w28eRv7Z8mB4EOc+j
         3u0jCDM5r2mz6fQKbVd80JTNRUaF7cW+kJj+Dyf9gkM/1F50WBqPLC6AYHH3VrpIPsax
         UA15T+nSLeZv9sLmjZukNoGfJG49S5YHDEBeIA/1J/Eg/DXHycwxEjUlHTDXHJwlABP6
         HoGQ==
X-Forwarded-Encrypted: i=1; AJvYcCX26UkQLY1k0vyTC1CPJzeAYZUUh1ZClmL4Y657bDH8n5vrzbjmL34+4XCWMUoTJfmz8vGT+ovcFNQC@vger.kernel.org
X-Gm-Message-State: AOJu0YzqPhX0umYjtx9hVUU6ceimQxho3kekxyAcDEmX/KMK5po46v75
	u597fzTJXJUvW0uk1zmTndfRKJu5UotqJ4IlOWV9F7jvs5DDNI2jgKQi
X-Gm-Gg: ASbGncuoqcLoaJVqqiclVpZTyGZoSgKPS40TlIld81tA6NTcZHqppWRS4+fFi+NQ+sD
	Cds69eCIRKpd5fSwJkHLW5MgnTn9TPp9XBRuDlLs1sGuw7U+q3kaO/zae7WpzMsVHkVfeH+xGjj
	Yg1wN5/+j2BAstLF5kahMmezL/9uHDv4DO2XXcStqKKRluul3iqZv5n/xoVpwHtf1UX4dpsCyCY
	K79tDzyX5DBy8eWFlNhOYQBdZRAh41aL91MkYc7IlG2GxI0T8x/UeoaKUPsTVeCJJrCf4VEDMOK
	ySBFTrsNQjcYJgmiBOYNfrYjX9ge5+iFlggWqyT7HEKU0wtsRTbbGM4RWWM9xN7dfvppmkfXaqi
	L7QBT94+yeC0oH2Vd2uRCtu16vWpPmWquOmYZglEshAI8I2wvrkBw9IVlrRbEDTfwzSSzavK5Bo
	0FQdI2FzJeQ+Z8tdUyvtiUjgB62aZXAvCoiVyBkzMD4gGa5/w=
X-Google-Smtp-Source: AGHT+IE2F0nLiNeIHq2g4zMVJnIfiBv34S3msVGeqkx0u3CUtdU5YuLkC01czcghjZ+E6ydM6GCvrQ==
X-Received: by 2002:a05:7022:6391:b0:11b:79f1:847 with SMTP id a92af1059eb24-11c9d712bd4mr5835461c88.12.1763953065943;
        Sun, 23 Nov 2025 18:57:45 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11c93de6d5csm43367228c88.4.2025.11.23.18.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:45 -0800 (PST)
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
To: axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai@fnnas.com,
	hch@lst.de,
	sagi@grimberg.me,
	kch@nvidia.com,
	jaegeuk@kernel.org,
	chao@kernel.org,
	cem@kernel.org
Cc: linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-xfs@vger.kernel.org,
	bpf@vger.kernel.org,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Subject: [PATCH V2 2/5] dm: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:34 -0800
Message-Id: <20251124025737.203571-3-ckulkarnilinux@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
References: <20251124025737.203571-1-ckulkarnilinux@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__blkdev_issue_discard() always returns 0, making all error checking
at call sites dead code.

For dm-thin change issue_discard() return type to void, in
passdown_double_checking_shared_status() remove the r assignment from
return value of the issue_discard(), for end_discard() hardcod value
of r to 0 that matches only value returned from
__blkdev_issue_discard().

md part is simplified to only check !discard_bio by ignoring the
__blkdev_issue_discard() value.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 drivers/md/dm-thin.c | 12 +++++-------
 drivers/md/md.c      |  4 ++--
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c84149ba4e38..77c76f75c85f 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -395,13 +395,13 @@ static void begin_discard(struct discard_op *op, struct thin_c *tc, struct bio *
 	op->bio = NULL;
 }
 
-static int issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
+static void issue_discard(struct discard_op *op, dm_block_t data_b, dm_block_t data_e)
 {
 	struct thin_c *tc = op->tc;
 	sector_t s = block_to_sectors(tc->pool, data_b);
 	sector_t len = block_to_sectors(tc->pool, data_e - data_b);
 
-	return __blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
+	__blkdev_issue_discard(tc->pool_dev->bdev, s, len, GFP_NOIO, &op->bio);
 }
 
 static void end_discard(struct discard_op *op, int r)
@@ -1113,9 +1113,7 @@ static void passdown_double_checking_shared_status(struct dm_thin_new_mapping *m
 				break;
 		}
 
-		r = issue_discard(&op, b, e);
-		if (r)
-			goto out;
+		issue_discard(&op, b, e);
 
 		b = e;
 	}
@@ -1188,8 +1186,8 @@ static void process_prepared_discard_passdown_pt1(struct dm_thin_new_mapping *m)
 		struct discard_op op;
 
 		begin_discard(&op, tc, discard_parent);
-		r = issue_discard(&op, m->data_block, data_end);
-		end_discard(&op, r);
+		issue_discard(&op, m->data_block, data_end);
+		end_discard(&op, 0);
 	}
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b5c5967568f..aeb62df39828 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9132,8 +9132,8 @@ void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
 {
 	struct bio *discard_bio = NULL;
 
-	if (__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO,
-			&discard_bio) || !discard_bio)
+	__blkdev_issue_discard(rdev->bdev, start, size, GFP_NOIO, &discard_bio);
+	if (!discard_bio)
 		return;
 
 	bio_chain(discard_bio, bio);
-- 
2.40.0


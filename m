Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793201316;
	b=vLE7xSBUwpCGjaJW1IjBXN6dC3wZxX7CtUiwsGl0x4Din0TsNkoro9oAewzvaV7rcEip
	 IrtaJrX1GLN9wGFfphPoHK0CD3eA1fObSp44RtyOEl0PHGFuHwhDH1Cb80b3+D9kHKEhl
	 G0I7LcB75l0J3lAu2xgmI60692Xj61XygvDS5NmByAMTDN8BNvsjEorjC/4/SDhFG+rCm
	 XHetH8t0l7ok7GCgqfcob4HfjGgevvkVPnodhg2eDGW7AVSfZoGyvZhwnzEX3govdBfBF
	 HftakEfz8WnA4iclQr063zPj4oVqM2c6TLfImctQ8vq9Ad8Cqo942XwNyWajd+EJr2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793201316;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3EFnvh6M4nOfo//zmUowr8B+BehGN6D7OuDC+mfDQMA=;
	b=RSaGcl4MQ1w9PgW/VboLFP0XkvKxX2M9U+JIv1cImDBnW+8VSC/N7e9TfKJTNEh/S7q6
	 LU2DpAVPr17cHGG+c5qCDKQJV2S45Tq+6mhtzeFH8tpLRJreMfBo7UkEHsVWzNHxGcGNV
	 5ynUXM3ZveBLs1BiYu+9A0QFObWEprthjH99uKvMVI+NBIX09+a+L7I/tpYzlOtuoRn3L
	 N7+O4j39ZkbFsmAr3p2a4nYOaVLUIV1kT+StzYHkDTw6Q1TsVOF9Vj86tewjtkxvS2fVr
	 RDzu/STM5kAjAj+KQJ32vab61MawLiwP7qyLxEqk6br1LYi+CIqFidVPpSxgsTN1AvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="kpm/IOYq";
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D763360A260D
	for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 15:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D763360A260D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kpm/IOYq
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ae57dc1ea9so492634a91.2
        for <linux-raid@vger.kernel.org>; Wed, 28 Oct 2026 08:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793201315; x=1793806115; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3EFnvh6M4nOfo//zmUowr8B+BehGN6D7OuDC+mfDQMA=;
        b=kpm/IOYqo+7GqMVydqZfXf3rnJJTuYH1+qm3m2pLTRv75gikPP66iIbuBbx1Y6PNnv
         C6lyWrdTrj0S+aonvY15svJzwqeK74XMt0QjRRK3VgNAPM2l8osz/bXluVR6FKfr4ngB
         P/RbmkzJTISw6aiu7gNJxgodbWiY/woHTdPvadWGLVBhQOE6SW2Z7O0INuCxJk0HhK+z
         peuearw8wWupxSrOMfsHK5qpj6PI5PlMeqTGNh85b2noNxwAQH1Xg3Ehup8wRVYDEuU9
         rrmwY9cTpusi3QqywHV8Mesgjh7fILq13Zohicc/uuQ336iCEvoF4jYMxiI1kQPrkjr8
         /EnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201315; x=1793806115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3EFnvh6M4nOfo//zmUowr8B+BehGN6D7OuDC+mfDQMA=;
        b=NJgCgQS/mXPIJvnG48kPVOc2YFUv08Q9hTF0vZhhefRjWOU8mTXERkttLHoMVEtFWL
         D09MMt3xJLv+g/oTXAv6W4bY0XIE/YVW+Y3iHoQRf7hg4wDeK/GyorGVopAZRJQjsLUf
         C66mVhjguyINz2iSczIH1TFyT5PJjg8zT+LinfO7wti8x6E41kntOgd5rAmGD1lsDozH
         0eSPGDqk1iVL0AWWcP0rZSI5kqU7UuT0NIPpAsbbcYOjIFEwCWsf9fSML8r+8xoc1/Q+
         ZVSquL4JV/uewHaFkOv12/qtxto/R1i8jVqyUhCtJ5DFIk4l6NIcHs/EZBfMRCVzsjSm
         BtLA==
X-Forwarded-Encrypted: i=1; AKwUvByjG71BeKHQUFRVxPcqq9+nubQ2dmgw/UWKLXdtsOzfbwMHX2WssUWEgP056FQtyUQOprTtuCeWalYA@vger.kernel.org
X-Gm-Message-State: AFq9FYIYzSuQ4gVry2PgT+SHqq+WGk7fcLsG8drI+t7Dyp7LasZGsixf
	HcbUq48pRHh40eIl5s+wIZHX39vIkfbNnWBiJ61w8g9rtfomQsJFfWIa
X-Gm-Gg: AYBFou3EweHBPHfbwyutOJM27nu/NL3D4FDVPehpYyuYR7Qlo2Yxwg0A9j4mU7Hij14
	yORrWMLMfM/gsEdOnrT2G8oIUHD8HF0k/obydJlFIKd3FAWdXXES5Ph+bg40N0F543lgCA643tX
	8zz760FRTyILgN0lVF/tJRwUJfF8wWfBcDVdiN3ZFhLE8tcf4gn2xAMruzpDixRwhZgvVQv12vC
	03hnWO3E8Etj/4GiP7qvCspIdBf+kmCLSJGoxpe1Bd6KCcdveOhqa6XV1UvpaYplb7w0KejaLz4
	2ZKN3Qd4CA/xjV1eOIctXEGhUyUEvc5k02SI5MaW9Gtu6IgEEtFOg+Gn22i0pD1aQKLqD2N/gXB
	jkhJ6vuMOgj8Z+U6QzCIfoIY3zKEqDCbpo5e2F8rTV1tyrybkHwqE0SwH/CtLE6SeF7kL089V/c
	Fe1zzwQNN2jy7irp8zxvF4TZiByzOZQPiDRJbQ9kQYnXFxsVKyB3ST9CYy+sS0mbR1G4xiG9KUo
	YwKdxKHIy87uI3w9Si4epdFCO6lzCuY8UQtBf7aOrCwLSfLBDOYoTSWzC8FF3/ztuojlW8zIh7U
	hxydus/dL8vG2tzuTKC+NVvDz2eaPBMr0XPg8BIlUp6fm5u7
X-Received: by 2002:a17:90b:2e48:b0:3a4:a592:4cfa with SMTP id 98e67ed59e1d1-3ae58250508mr2028733a91.45.1793201315127;
        Wed, 28 Oct 2026 08:28:35 -0700 (PDT)
Received: from spidy ([2401:4900:e01c:35d:d4a0:a769:c60:258c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae5a9f286fsm3445533a91.15.2026.10.28.08.28.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:28:34 -0700 (PDT)
From: Gowtham S Bhushan <gowtham398gs@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fc26c366038b54261e53@syzkaller.appspotmail.com,
	Gowtham S Bhushan <gowtham398gs@gmail.com>,
	syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: [PATCH] md/raid1: Prevent excessively large memory allocations
Date: Wed, 28 Oct 2026 20:57:55 +0530
Message-ID: <20261028152755.383821-1-gowtham398gs@gmail.com>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Validate mddev->raid_disks before memory allocation to prevent integer
wrap-around or allocating an unreasonably large chunk of memory that
exceeds KMALLOC_MAX_SIZE boundaries.

Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Tested-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Cc: syzkaller-bugs@googlegroups.com

Signed-off-by: Gowtham S Bhushan <gowtham398gs@gmail.com>
---
 drivers/md/raid1.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..88038d535727 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3050,6 +3050,16 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	struct md_rdev *rdev;
 	size_t r1bio_size;
 	int err = -ENOMEM;
+	size_t calculated_size;
+
+	/* prevent baseline integer wrap-around anomalies first*/
+	/* Safely calculate size; overflows automatically saturate to SIZE_MAX */
+
+	calculated_size = size_add(sizeof(struct r1conf),
+				   size_mul(mddev->raid_disks, sizeof(struct r1bio)));
+
+	if (mddev->raid_disks <= 0 || calculated_size >= KMALLOC_MAX_SIZE)
+		return ERR_PTR(-EINVAL);
 
 	conf = kzalloc_obj(struct r1conf);
 	if (!conf)
-- 
2.56.0


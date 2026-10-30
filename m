Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793335221;
	b=Ui4HG7wY8Cu9GWrM3ZoMjU3OniX7ryCqWenbN5wMBLJzLmbJRqSy4HoN5P60XjC7B5C+
	 OcEmA8n7dwTkWqifNsVFXC7dBtrH+183KjsMZaNrkJD8t9I7RBLI0SrIOz57D81k0FPcZ
	 tPxinBqG6x4AZjoym/U/ygxtzVJ4v4ZZLLa+VwGnf2aCG4tKz9vwNjFAqAN4BANiIuLYj
	 VCZG0gPQIymoNADd4N+qTEmNzlxaNEdHhBn47MscoLMzwACPsKphPKzwqxsMZnpbdVWdM
	 H/301F1qch2dcxUt6XxLhoZSc1kTIjBY40emGHxCSUzb0C/vC6KgyAfvFIw520DgT/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793335221;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0pxIDWqNP9QlFHJneHeVIH00VqBfWsrjURorHdYn0cc=;
	b=o6R4BoXV+9ZKBSBwX1sFcpHTE1hdZRyellhQkLY3ZRfvQhiPepULHQHoAJM2MIOfEVPy
	 SuWqy/oq2kfSvK4bl+0MFOFVe9ANvAlJdU9o4gA+a+Wd2pQEApNcbqGbnjcV29VuLxQJK
	 gBFUDEcN6m8LA4kvcKkRHA1taE7ghy5gicefWerzUy/qUBn+MbueRr33AusFAUAF+uqeK
	 sNPIT8gjzPQvXTCiYFTZI6QDKoPk97yVuBhTFZsn5b7KXf1bButR2e6uHwozsRldCnwxm
	 W+tEMZZvBUfMSUcjaqiQAORcmdltFWeuwuid4Jsxh9WVIxpxOUfOx+TBoYFT0df5Lkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wsyE4d4u;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A76606A31A
	for <linux-raid@vger.kernel.org>; Fri, 30 Oct 2026 04:40:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4A76606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wsyE4d4u
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-3535bf8b3e0so548352eec.0
        for <linux-raid@vger.kernel.org>; Thu, 29 Oct 2026 21:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793335220; x=1793940020; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0pxIDWqNP9QlFHJneHeVIH00VqBfWsrjURorHdYn0cc=;
        b=wsyE4d4u2kSup272juIJcOdXxrmp3tLhWNSx5Dxjau/usYM/LbvXq/R3mOrtj0JkF2
         uHyMzBA0bvVhH0sBF+4GeZM6iP/EMQA/H2jG4HxSHFlzUNKBXAYr3nyoT35OK1VEDTyT
         2ovsznb8q/PeZ66P1ry3PXuisJ3fq8uHzPkzwZDDYPBbGrszjQ3/AH2+4CiXMhfU6znf
         Gy3NI9EBrrLpq2ECd8B3XJOQl5Q8s+kVF+aEFVjU1rZCsTlaJGSQQ23kRpqX/7Mysl/N
         2NvpK2c9hmp29lOuAklEr63DDDwQrSJimmi2boLoXa080ycUfhg+HpPqfh59OJ9gmsnU
         NIpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793335220; x=1793940020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0pxIDWqNP9QlFHJneHeVIH00VqBfWsrjURorHdYn0cc=;
        b=nGQ/SPUbbu29PxqqcWQS/rg5hVfMwtm6fCenGZfnqp/IQNIHoeozKY4gjTbafYC5p2
         VgxGq7GeQnPPJGReiAi4CDg0RLdmnYpCfeTle2sa3T4UE3FxfzBdu0gVkQs+VBb71T+4
         L4m8jozviG/4ui2uhca3O5dAoxICBowOTXnDngtiR3r8TBHdy0AEVQCBX38UvhYG03Cz
         +v1+E4Tk39AYuhaFEhbd2lLt9y0lwVMMB/xZZB63tWatQmfI2gilV5KM3Sym02BXRVfs
         WarvA6Mn8eramB3/rTqYaGpWwLS7HyUUJDE7SAc5mHCHfCyTVLyWNPDkvhxvagnlPWmf
         6CJQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2zqS3ZkMlvmo8GXTwfFnWR+wnVq6g2QEsCT6o+DEsbnR/fPJo5WM5kS7itx//KW4XLf0FEGUGFTc1@vger.kernel.org
X-Gm-Message-State: AFq9FYK3d3SurFQdLyG1FEMgaFFuFG3FEq9w2cR1DYzJhNdcb0F/Dvdc
	mOvJ2MUVMO/g0gXUHR5/7og4SJjmKMsb0N8Pxv8JoQDQA13eO3i0acss
X-Gm-Gg: AYBFou0b5eMzqGc/bjundJiRammjEdkSjPnGoTxQ88lcFpVqY6JziXSXM6KpUZ/2CfJ
	UsRgZke0doI5yCX+mZw8E1TN+p9BHbwQB62SQ2d38XgEy4HEyr+VDZkPqWM7jwKbK/YLbhjFPBs
	YAwzC/ayCCyb+gvlCHQu0CgO6a6HSUG3j52yI27wXENFpTF0KNbLM/Toui69hZoH6KLypdLKsVE
	zL6+4nv6Kn3bSOYeTCD/QLMrsAyU1HW7sTYIPaHpGXD/sq3QeY+L7v5Njv2tS1z9UsUB7t/fMvA
	guLKSgthd2jbdIxlQU7azRwX9IFtgPvzZZiGNOpyqWkSizhjKk4L+rpmYdgfC12PyNaoZBQ8fls
	s8UX9lI9p5olo9EtYNl68/eHjiV+8AEJWn+NSszDJH8Rqv/BCAl/ckx2sotTz5xWbyHCTVcWT1r
	C51QRziQso4BUE2uAayBqB/4wbFHl6O2/5fqwYxWJOnkMipDPamUHaO4Q2mHMqptYtFlITJ2jwa
	nFX+qI4q0SV6z+MA2H6pUb6oKqEUomkEoe3wyApD1OCTGKo5YSDZkQu2wGl7RsUXkGiHQnLP1cz
	ZZIF5vAU2ajq0RoJb2TUIkpog2Q0MqiSHLkGaHEqDKj3bqMf
X-Received: by 2002:a05:7301:640b:b0:33c:16f1:2e11 with SMTP id 5a478bee46e88-36a42363ef8mr1827511eec.7.1793335219596;
        Thu, 29 Oct 2026 21:40:19 -0700 (PDT)
Received: from spidy ([2401:4900:51d6:8e8c:242c:3f96:88a:43dc])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42669128sm3710509eec.3.2026.10.29.21.40.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 21:40:19 -0700 (PDT)
From: Gowtham S Bhushan <gowtham398gs@gmail.com>
To: song@kernel.org,
	yukuai@fygo.io
Cc: magiclinan@didiglobal.com,
	xiao@kernel.org,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fc26c366038b54261e53@syzkaller.appspotmail.com,
	Gowtham S Bhushan <gowtham398gs@gmail.com>,
	syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
Subject: [PATCH v2] md/raid1: reject out-of-range raid_disks in setup_conf()
Date: Fri, 30 Oct 2026 10:10:08 +0530
Message-ID: <20261030044008.34293-1-gowtham398gs@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028152755.383821-1-gowtham398gs@gmail.com>
References: <20261028152755.383821-1-gowtham398gs@gmail.com>
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

mddev->raid_disks can be set from user space with SET_ARRAY_INFO and
is not bounded before RUN_ARRAY reaches raid1_run(). With a very large
value, setup_conf() asks the allocator for more than KMALLOC_MAX_SIZE
when allocating conf->mirrors, and the allocator warns:

  WARNING: mm/slub.c:5459 at ___kmalloc_large_node
   setup_conf+0x15d/0x700
   raid1_run+0x109/0x250
   md_run+0x6c3/0xec0
   do_md_run+0x27/0x3b0
   md_ioctl+0x163f/0x1ca0

The array fails to start, but machines running with panic_on_warn
crash and syzbot keeps reporting it.

Fail early instead. Version 1.x metadata can describe at most 1920
devices, so use that as the upper bound, and test the sign before the
value is used. At that limit the allocations that scale with
raid_disks (conf->mirrors, the r1bio mempool element and the resync
buffers) stay well below KMALLOC_MAX_SIZE.

Reported-by: syzbot+75f49ec552cc74d9d69b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75f49ec552cc74d9d69b
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

Signed-off-by: Gowtham S Bhushan <gowtham398gs@gmail.com>
---
 drivers/md/raid1.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f0646fb24371..1cfe983167de 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -48,6 +48,13 @@ static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
 static void raid1_free(struct mddev *mddev, void *priv);
 
+/*
+ * Version 1.x md metadata keeps a 256-byte header and then 2 bytes per
+ * device in a 4096-byte block, so no array described by it can have more
+ * devices than this. Arrays created through the ioctl alone have no
+ * on-disk limit, so apply the same cap to them.
+ */
+#define RAID1_MAX_DISKS	((4096 - 256) / 2)
 #define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"
 
@@ -3051,6 +3058,11 @@ static struct r1conf *setup_conf(struct mddev *mddev)
 	size_t r1bio_size;
 	int err = -ENOMEM;
 
+	/* raid_disks comes from user space and sizes the allocations below */
+
+	if (mddev->raid_disks <= 0 || mddev->raid_disks > RAID1_MAX_DISKS)
+		return ERR_PTR(-EINVAL);
+
 	conf = kzalloc_obj(struct r1conf);
 	if (!conf)
 		goto abort;
-- 
2.56.0


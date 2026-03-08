Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31EEB35BDC4
	for <linux-raid@vger.kernel.org>; Sun,  8 Mar 2026 23:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773013328; cv=none; b=kb4W6TNt4SOP9pzUAfyftdItXfMgIVnMjywjYHJpjXSziaY0+D/DAcpQO6WY5OW7JZepoUhBde1j2dhURZG4IrjS6l/6WEkHWi0wM+9zSdnLERYIbid4WGXUg8yPonjD2EA5Tx4xzHwv6iA/fXVwo/omsy/47YjHJx03frT4B7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773013328; c=relaxed/simple;
	bh=wHJAniRbTXFA/kXgLdxBYZpgK05gUiJhfuJo+0HgIZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0SeR7I9GCWhDjyNQJ/KDn7u1xOwaWq4zcZRbSUszQ0sd2hFk4smyYnNyOBWfIX4Ewv2a7q/tPjbsNbnKapU8DZBQCH2eJseqaXBSpfAahO+w/N4ty8SMze2PJJc4RX6UfbZSy+0MRjzgGtq/e0aWeiJcmi3gIvNrn7jgbNYq5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=KnDVH+Ay; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="KnDVH+Ay"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8cb38e86cf2so1180380085a.1
        for <linux-raid@vger.kernel.org>; Sun, 08 Mar 2026 16:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1773013325; x=1773618125; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qlkFR3V+9+r85GbTD5lGukkDRcDlJZS4UesWjQfxFuo=;
        b=KnDVH+AyQAAPjrwdxjnIggzekCMrI3PeqShFioi2psBOlyYcrcHEke8iriji1Ht3NL
         uyd+prQa27kpuhw2m8NDWcfUHYl8u+POhJDkwz3xETJ+n/KpIpGqmynAKf2+sfwvXmOA
         im+MqpdoHXa6ydBa76k9I4rN1sThnu/39VjM5dPcL/ueg7504PoMX8985M+C/7GX40mP
         Sl79JAYGtz+hYozR6J+b7i6BRMJcwAVLQtz/bJ6ibJ8DB2j+D6p7ht8mFY/o3rxpQDOp
         hVg+m60wmHza+5bAM5p/K2myob7i3HgXe2MCFTDIqy/WbDEK79M8TDOtiiLHvzWXLEIt
         hDLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773013325; x=1773618125;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qlkFR3V+9+r85GbTD5lGukkDRcDlJZS4UesWjQfxFuo=;
        b=qK+S9ggTLICaAgXFvm6HbGswfOz2ebFnLKVXfQMTJG6z2KUSaKbJEgQMuYK7uTO2qy
         hiLq8iFf4juAjUuH+XUf/fgfiJH+zlS+/2Zj4tFq2nrwRh9c8/cs1TS9QACKcwXpS0Om
         Oc0QjgiWRIzD6XCbooTPgoH0lvXWztXrNaZd2ATRqmYNWUxFADQGDP9L/OesV4uPqIjT
         xCfjsgZtJFJIj2kSuFOFXhLC2FFNasB16YVLsf8uK8FuSOH1im1yLvXvCi5AnHKwEnoE
         VbFDLZsZl2lg0lYumNp8P8SJoTVt6ETUNDwxA5QCqDu0H2unBiax0zKkXHN7kwP9oIDY
         5VVg==
X-Gm-Message-State: AOJu0YzQP8tmu50LGFzMNYBGPEa8Xua7fXe3eO3eEKeT8urG543sHMgu
	6+da5sB1Q/gOrP2K/q8ll4NPZPCkvdaAqLt1JpBhA2UGNKt4KV248+uQIZlWCVeugSs=
X-Gm-Gg: ATEYQzyuoVF4OcrFzIKUMdDw5MigWIPKGiGQzFLqxO0F7pCLVCle6iEYjQAaws1NG+e
	eblKzxQnRtw0BynhDzXg45ER/kFgT/lzKvBwSfgzPniOcfxDBIvzPKo3NSEzRTyCaCwlntHp7Qj
	6w6AtvSCQM+c9wXJsze7TW44H0y/H7WGwA0T9+3MChiFQiETaMF11V52so/igr7VmZCZKdZRA1F
	WgvCLSBrfzBgh8CqC2N7JFPLD37JHI9iEkf5sw6pOWleX7dVVirb30px7mKvxeS4QzsAyH2ScIY
	662DQVDqqODba3Qt79lXyKp2wwoDzHlxhcO3pv1pVOorGJj3BPVkjdhaTFKRGvkpPzmNtIYFyXh
	QsUAyWyD1AISASFEWwra3lf0MXBCBCKiV1sPwiF8zH3nFlvEDXABrcqUDRc9acxtN06/eFmoHMm
	VBYo3Y5limSeL/FIw283HoeM/nBRcgsIRFm4hBb+0ddZA8TkIrrkNvljpb5Uc5Baqb5GzBftl/E
	HeReryyhijelY4=
X-Received: by 2002:a05:620a:1921:b0:8c7:10a0:167d with SMTP id af79cd13be357-8cd6d4418f5mr1162364485a.39.1773013324993;
        Sun, 08 Mar 2026 16:42:04 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd81aa2eefsm211312385a.42.2026.03.08.16.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2026 16:42:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: song@kernel.org,
	yukuai@fnnas.com,
	linan122@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
	akpm@linux-foundation.org
Subject: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist allocations
Date: Sun,  8 Mar 2026 19:42:02 -0400
Message-ID: <20260308234202.3118119-1-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <69adaba8.a00a0220.b130.0005.GAE@google.com>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
triggered by create_strip_zones() in the RAID0 driver.

When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).

Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
__GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
corresponding kfree calls to kvfree.

Both arrays are pure metadata lookup tables (arrays of pointers and zone
descriptors) accessed only via indexing, so they do not require physically
contiguous memory.

Reported-by: syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/md/raid0.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index ef0045db409f..5e38a51e349a 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -143,13 +143,13 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	}
 
 	err = -ENOMEM;
-	conf->strip_zone = kzalloc_objs(struct strip_zone, conf->nr_strip_zones);
+	conf->strip_zone = kvzalloc_objs(struct strip_zone, conf->nr_strip_zones);
 	if (!conf->strip_zone)
 		goto abort;
-	conf->devlist = kzalloc(array3_size(sizeof(struct md_rdev *),
-					    conf->nr_strip_zones,
-					    mddev->raid_disks),
-				GFP_KERNEL);
+	conf->devlist = kvzalloc(array3_size(sizeof(struct md_rdev *),
+					     conf->nr_strip_zones,
+					     mddev->raid_disks),
+				 GFP_KERNEL);
 	if (!conf->devlist)
 		goto abort;
 
@@ -291,8 +291,8 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 
 	return 0;
 abort:
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 	*private_conf = ERR_PTR(err);
 	return err;
@@ -373,8 +373,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
+	kvfree(conf->strip_zone);
+	kvfree(conf->devlist);
 	kfree(conf);
 }
 
-- 
2.53.0


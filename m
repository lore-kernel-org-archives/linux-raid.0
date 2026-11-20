Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.53
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173519;
	b=CJ8Qo0sACjOTEGtTpKEghlO7I1GJ6axoMFC7PVN2cJIDps7eMyaVi8IrtcWgaRivQ/Ec
	 O7B6ClBW5zHSucJ/yJ7jIgyPfWvMafNz44+0/B0+D6rg2UW6duH+5VYl3ns/adF25p/LB
	 Gh+170Vm2O/8L85CP0GptkGpWkM+WKzjnt40FsONEkIk0gwKFGKm9LpfMeyQ6pHGwgOQG
	 Bh4WOqwDJNDc9M5p1FYxGmueTtS3xKN0jx9vqmZBIBO6vENTlH9g91xEu0asFxcPusEwd
	 dwAfDwES9p2wInk/0gMkJYu4PWZO4ndH2xTFbzmE3X3cNJWnlryKEWex6OwYPN/BLmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
	b=cTdqe7zarweCxBAEHnrTX0e6htL0sTUCDEPr0RH+Sj+2bTOdgw1oqEPU0f3ReTWya6OW
	 W/WdC2YXBuJmdjvBiWVrZmlGxA7Q8EthtpCfPeHulU/p7r+OeUVMYS555I4P5P5/cRgle
	 s3xEc/RCTTjFeI1T0k+4Uvs9fzUxscfuJx5+5PbhjEHCpLS7ulmZAW3ops1TEWwsbQkqk
	 qlnAYtrB/hVXbJY+rHcj+hZ9ln6Qyaw/hOtOhsZPzMmGWzfWz62zXgbJoOoBGmjJlr1nL
	 v9Fm3GH3fBoelijPhxTrdUFfcMi+piN8EN5A+A8hmu59fM5KxDJXe82BLFXamIfCuSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uGOHyzOW;
	arc=none smtp.remote-ip=209.85.218.53
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C313606A334
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 11:18:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7C313606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=uGOHyzOW
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c445c95d553so112195766b.1
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 03:18:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173517; x=1795778317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
        b=uGOHyzOWSEfWiJZ6I//Si1S/pmEbouLICKWn1MjChSpAZh4B8Baz/rLRknV5o+0qMO
         w2TW4T6dlC7tzu68PhL0ENiSSI2Bb/PsKkzzOTZ71bl1ahqLORphGSduFy5sVVRGRn1o
         Jf8kf4XRy2hLegP1DS98x0prWoQSVyoFKftinR38xifZPVaxvuWVWTDD2NSW7Pxlzbt8
         HxuTkMNp12+GSK6uBCvu+vEsP7BzLdlOIrHGZqwIDqvG9EP3wlBKmjP9brw2u/JqEL7h
         7SdQSkTnX11aFU3P3o7KPEcaYd3XYDwkZL5IJMUofTvcNNoMKfq6rQiBF3R7JnYsGBWz
         g69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173517; x=1795778317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GVuAUaZMskqzeiLFr56cuMAxOEFeqJFepRj8B7tYuqg=;
        b=ndF50X/hj9ZLSdn9R3DzObhOud7dZ3U1cZOFNCpOQOB7/sVD26vt24r81KzzvFUI1Z
         z/g47m3q9HKUfAeExCtMejSO/hEfK6h2419j8Lt4R4b4XQFuUYsY1OIWhNE1UBc1qqWz
         ijHAiT2gi26I9PKojcxPS0cBMH4d3SCECsnEJasnJhPUTWnbtW+korXXC/GLUjjOdXC2
         cVAmUiaXgmi7X1S7wHxgwcy+bI3WcjEgkE/UQoO6jHFhc94Q5txa/b7S/xrMo2xbAAFR
         9noi69PrJUdlX7cWA5mkHSWw5xZzFrpXOBhzkrjnBdUPW2R9UHeHDkut3xc23u5lvLQH
         SpDA==
X-Gm-Message-State: APuU4Z8QSPhnS11W/Fss9blfprD6b3usonpDBvPAtv79FxypsLluYku1
	t/uf55jnGmYJu5RyBNTvu8Ax+MMwiyVLuGht5pL8GWVcr9cO/ZO4szT0ddsqDY5jnqPKoA1z
X-Gm-Gg: AYBFou0qb1km9VYo31CxP0F1IfbriLv62A6aW3ZrilGDlh1aJ+PQ75xdrWLMyEZG2Ar
	k1Rwx9DLx0x0ipbiKL5v57lGzvzMvhkqOoA5/zaR7nagH6za1kq++6nMwmHP5fr6e7TeAVmlcfr
	g30074iTAF28ENGkMws9G7H0ShZZiFRhhYp7N7zVAvyVjDa8rneyx1AXden3nAJowlaybFjac8d
	WA8Mu+geZsE5CoeF6dA91WvPKEkXfMH3aZGAmHUkT++IPmqMwFarJN0ByLfMgj/0lc43vcSPBV+
	aFLusl2REv9NBs/pks1w6NUjlW8BCGwgfMm2XAEgb3T8FFxWBYijheOYlf+TYMXiAdvlW0vg6J7
	JZ+L8TLCMHQR+C8WfnZsYpGh59Jit6ILvvBgh5HakRmQHdDrflQQ2ovyhPmmQjXNcJ603+7zFGD
	5nGpoEKfzdZRHeodzDfSMjOGRqaW0c2JG0+9o6CdCNjgTRFvO5CLLY3xYZbNgbfN199f/SwOVG5
	aHmz5mIY9nOexHT8RdmFx7qL7FcAclZ60emAeKKFaIt20KZP72KauRZ2tWzeOeVIylcC2/93iGb
	G7wzi/DgLBCguuzzHaykKRjErM0Oz0zdHxNs65dP++bx57DgsxNqPg==
X-Received: by 2002:a17:907:6095:b0:c51:24eb:4de9 with SMTP id a640c23a62f3a-c513ac634admr257163466b.34.1795173516536;
        Fri, 20 Nov 2026 03:18:36 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:36 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 1/2] dm raid: Clear MD_RECOVERY_WAIT on reshape setup failure
Date: Fri, 20 Nov 2026 12:17:56 +0100
Message-ID: <20261120111757.4705-2-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120111757.4705-1-nenkov2004@gmail.com>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
 <20261120111757.4705-1-nenkov2004@gmail.com>
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

From: Hristos Nenkov <nenkov2004@gmail.com>

rs_start_reshape() sets MD_RECOVERY_WAIT to keep the sync thread
from running before the table reload. If setup, check_reshape() or
start_reshape() fails, raid_preresume() logs the error and continues
without a reshape. There is no reshape-related table reload to wait for.

Clear MD_RECOVERY_WAIT on those error paths. Keep the bit set when
reshape setup succeeds.

Suggested-by: Yu Kuai <yukuai@fygo.io>
Link: https://lore.kernel.org/r/4d13edef-f454-437b-8910-3a905697303e@fygo.io
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/dm-raid.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index ac019a0f5..e132951f3 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4004,7 +4004,7 @@ static int rs_start_reshape(struct raid_set *rs)
 
 	r = rs_setup_reshape(rs);
 	if (r)
-		return r;
+		goto clear_recovery_wait;
 
 	/*
 	 * Check any reshape constraints enforced by the personalility
@@ -4014,7 +4014,7 @@ static int rs_start_reshape(struct raid_set *rs)
 	r = pers->check_reshape(mddev);
 	if (r) {
 		rs->ti->error = "pers->check_reshape() failed";
-		return r;
+		goto clear_recovery_wait;
 	}
 
 	/*
@@ -4025,7 +4025,7 @@ static int rs_start_reshape(struct raid_set *rs)
 		r = pers->start_reshape(mddev);
 		if (r) {
 			rs->ti->error = "pers->start_reshape() failed";
-			return r;
+			goto clear_recovery_wait;
 		}
 	}
 
@@ -4037,6 +4037,10 @@ static int rs_start_reshape(struct raid_set *rs)
 	rs_update_sbs(rs);
 
 	return 0;
+
+clear_recovery_wait:
+	clear_bit(MD_RECOVERY_WAIT, &mddev->recovery);
+	return r;
 }
 
 static int raid_preresume(struct dm_target *ti)

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794074348;
	b=PqrIdKjIQoDDfqIWhfD6dcxHhPa3XrwHbrGRCdMgZn7PkGNRyBLl7+n2sVqzxQByXr/W
	 sD7CKMQfnfOejnvqEIqbPOQ091GigH7ICDonyC245vXQkuJ1uObwIz27VOkiPAs2YA/RZ
	 piT+N57zjtZOI+YNQ5MY5GLYeP6pJRdu/CezLFVPYkGU6zs/f+HIK8ahorfZwoYbavnar
	 r28j3EhtzGsHQXblpC9IIwoxkZ4vxluq2zXd71B6yc42jwoLdES5ErTHvmZUWqN7DY07H
	 vxeWFA6A2uaNIh9VUXSXQ4UZRkrxexDOcpCLVUHt/Jo8urhwXNlAzuDFDioc/BEWgAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794074348;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=zyJeVbIylLraJ2Myhq2ortYzjqn4IY1ybAfIUyodYNA=;
	b=bn2U5GQEulZkep51MdPFtd7tORnGcusandyrhRu5tCokAxUzUFFLkcrNclfEBQJZ/4rr
	 RuXrTQApJxsfNAb/awcMOzlV0fRpOpdBVu3nTzf2JRJyxn5Ny2/hLYqTSEhR1gQjeCk3O
	 XSG41UGB30tHnYEE69FITJlA8vmfPEAVjPzrDXCBhDCTQ+LFUCZWG6wfcoAdNTdX+sBfT
	 Q0dfW3bFjhpVUGfxNnFxGW/BFidK98SXSwg3V87FBkDnLESG6v0sOL37/5gDpRmLc5bla
	 yLDoiQLNRQLDXTVPVDsCEBVcCtDpWF8X+RympHytt5Ybj3KCtx/9naoGq4o+QJfikrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QlP5C+uT;
	arc=none smtp.remote-ip=74.125.82.44
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3036606A326
	for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2026 17:59:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3036606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QlP5C+uT
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1430eec0070so51667c88.3
        for <linux-raid@vger.kernel.org>; Sat, 07 Nov 2026 09:59:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794074347; x=1794679147; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zyJeVbIylLraJ2Myhq2ortYzjqn4IY1ybAfIUyodYNA=;
        b=QlP5C+uTjgSHFjFkU44etWZWOpHP4+H06TKMEbzaSKTKQ/c0Gb6o40xH42ivxGfKJQ
         5PBkAkiFgxcC5jrOGreQPnmdHboH7UWJLSiHx67sf486vwQmoPmbslq8L4vvdBpbN3Yr
         dX5tomlHM+k1Bhz3JNDxlu+BqAI/Nzm/F5I4t69PD79y8KlwYssRm1/cQ8AWNR7ZEJzT
         +oGZLrbqrxGUcf4sgjfn3sJyIitMeFt9gyQycNtQnHlYUpCdMi1L6UfmNnkzyIexqD10
         MLhOiFa8ceWdIdi2xtUDRLnx1bmPLalkWYO3C6SwfptavGf7vvyYoR7HKxlTujxBy9Sf
         +dFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794074347; x=1794679147;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zyJeVbIylLraJ2Myhq2ortYzjqn4IY1ybAfIUyodYNA=;
        b=sfeAFc1YVW1t1Sc51F2grCT8rHR0bZKRc3/Bl4092RRO6orJMp7JmVXhF38mjNeJoD
         XPA7NQX+pTyF1uEoVkue0J0mdfhAVRaAp+DVfQthPvMpaZxgJtoSs62XymSFx+bZQM04
         Yql+7kDJR+JmHanixN2JkUhvklHTnW+Xo8bEs9T4PrElj4VWdpxx8UjDFlGZKTastlt+
         l2Gak+HhwDz3BaN8YndKNsTmvvA8wtb12CVdBwLYjIKtMQdGkVJPXzjG/14MieSbBsKa
         WFy3KYFxXiKh9oNSzjKYIYf5vNrO6Yw/38jd+GJeerf93ISQo8ZWIO1LpefrUZAyn81/
         P6Vw==
X-Gm-Message-State: APuU4Z8aMTVyWmmSApnYIboX0xUTYH82IIykzzer55B7vGgPEm/ARAOf
	THstEuSleexyN1yvBQoEuv2rEnfhs6M73V+PpJLVyXyhoEBr8Bl6CcrmwLHUZeW4nXY=
X-Gm-Gg: AYBFou2RI5PxqYLa+Y6XWAneNU3VoyU5ElRmdJ7MuM7A4T/76mePIGI/G3Cm7fG8y2K
	SqEDsCz6YmqnwtLxEXjkysoEKcETPqXnsPvE2wAyL1Nczv/myMZXvrDwA9mrJ+tmZ8Ga3RrlNN2
	T7xi7VGsZs2IHqscDiEhi83Xu/kA7JO7meE/Gks3+cuWeAiDCBhsGfdQT8yx0zyMxp3yY1IyLnp
	CPIJe6MUG2t8o1rT3toTtvnetNVVllQtFuYijKNf2j2BAoNBBJOOElJAVuIEFzwhQiSHqxcuCaJ
	y++3EvxakMQMpk542Dm1p4FDIRLTUTh+Lwwkauarbvy1zgvSdKas3mQn7H1ry+2XdEYnbDgz6VZ
	Z3TZlCt/S1K3HJLS1nzn3eLzxot7rlLvF62bz/CdSjdriJIyHetA9BfQvllSLM8co7nALXz920R
	9BANrNJQvTfVF+8ODRwt68X7UeSLXNVvFTTNAnZF6y2enhJWuVzQBaj63QZmZIwsyry/tjLU47n
	w06DCsi7TrtTaMT5EyO5Mwdeye2lL4FPEdxY6m/TDqbfXDWu7/tP42iqyenyHvvZLceflt8X4BL
	+kC3hH8LQ/qOgbL8PxKsaNSdm94CNBZ05APwwFzD
X-Received: by 2002:a05:7022:4591:b0:144:fd17:3b21 with SMTP id a92af1059eb24-1b25d1dc9f5mr12715241c88.0.1794074346483;
        Sat, 07 Nov 2026 09:59:06 -0800 (PST)
Received: from localhost.localdomain ([142.249.36.161])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b37314626dsm56423c88.1.2026.11.07.09.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 09:59:06 -0800 (PST)
From: Chengyu Liu <lui2012qwq@gmail.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai@fygo.io,
	Chengyu Liu <lui2012qwq@gmail.com>
Subject: [PATCH v2] md/bitmap: fix missing_pages restore in resize rollback
Date: Sun,  8 Nov 2026 01:57:34 +0800
Message-Id: <20261107175734.25918-1-lui2012qwq@gmail.com>
X-Mailer: git-send-email 2.25.1
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

The rollback for a failed clustered-raid bitmap preallocation copies
old_counts.pages into missing_pages instead of old_counts.missing_pages.
The counter then reports every page as missing and can grow past the
page count as pages are freed later, making the used_pages stat in
/proc/mdstat wrap around.  Accounting only, no corruption.

Fixes: c9d650322829 ("md-cluster: always setup in-memory bitmap")
Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
---
v2: add Fixes tag (spotted by sashiko)
v1: https://lore.kernel.org/linux-raid/20261107164305.11476-1-lui2012qwq@gmail.com/

 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a37..66ed92a0715b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2495,7 +2495,7 @@
 				/* restore some fields from old_counts */
 				bitmap->counts.bp = old_counts.bp;
 				bitmap->counts.pages = old_counts.pages;
-				bitmap->counts.missing_pages = old_counts.pages;
+				bitmap->counts.missing_pages = old_counts.missing_pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
 				bitmap->mddev->bitmap_info.chunksize =
-- 
2.25.1

Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED151DF72
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 23:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789343197; cv=none; b=A8eecWtAgn0XAfe/eFIsgT2yvjQHnNXQg1KG9BMc07pH1v+rcT/WAmzvxE5Qc3Yg3B0el00+RBX4RvGZD7SCuRjNm/7p4gCqDV5nkMLC0ivuWvv/mAvnBbrSIoiYynjAmlMsyCS4w1t37A/CwJMNs5Qm8tYM852oFzIuzp1OI2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789343197; c=relaxed/simple;
	bh=WRPW08qN4Z7ENr/EBX6OlBlbqf6jxcaslNk3s9/JqXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0Cb38BSO6Uc1T9CN0H7zLQw23bl9qdXkC3PYmUihsYf/5324MUhRPLcBGXDVSS58vIqigldz/xBjwPwZ4o4XWE1U5Cf/CBsMX/yLu53O5cqbwRpYfAAZoyfq4HF7swmIiDicGNq7FEQs2dezm9FUNza9Zj20artmCkBVA0HK1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=s9Yla2Ku; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s9Yla2Ku"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd4ef687f5so2266775ad.1
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 16:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789343195; x=1789947995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wO8TTB1dHiLyNH2VdgHKTV78AfoTPHUBlmSwP1GpCws=;
        b=s9Yla2KuM2ndrBh5NRxOfV4yuRleYJfyoJoWVZURZs9BRYLbRkmdUjXt7KkM+lSIRP
         /uo4gDACaQJGlKIarY6Rk4cT9OziUqZEOd2QSRP+FLNDLjh0vv5wv7YssmXbNotYhmcz
         MFivj72Ui7iDWAs6Rcc1yq2STKFJkyuMax4fMNRpKEjH+2jA4yrBoQ4sCVcnSqX90wty
         HglYTn2FLREBhV1Y21G6GYDcWZnFUtYj6b0TnLJOgy3ZIH4AhvTZxO9FUvCFT1d0f8sJ
         P5ES0A5Kp9vLDhfncOl/qBnDI4A25K22fgts9MxBE3EBVWoXY04lrgYW5V0IwE43zjTq
         tYRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789343195; x=1789947995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wO8TTB1dHiLyNH2VdgHKTV78AfoTPHUBlmSwP1GpCws=;
        b=UUSurdvQfTR4wcennT5Z9BEV08iCmVuuh5Zj6bGhxdWhoyaKAfx1o0ULKXZpdtsF1b
         epEr5VeniVF3PJ1Vb3OiLstYt6wSsvr0XYJNh0hwjrUSpzECmRZxfKvgDB+LAbcJigAp
         yFmslLBAkujSRTZX1JEVAfCPhUdIMNzs1VJCNSoCD1tYVPhz9xv3V8m/byKSOQvSusj/
         ilZj3x+X5XWkdYsuapQLzoYWegpB/A89Qto2ptis49n7ZX8DS5uIGqkbqHv6gSMnODdq
         vvNwjf9UA3sgXSlORglBTou6OQsv8hbT7QK14bWF1Gc/UJmlOLWNAnFNeK9hwqnvc2Gl
         gGzw==
X-Gm-Message-State: AFuF++kxEYCpRK5WMPYH74/CrpkY6l0I8sL3oN7Pzh6MFZK6cwQH0kL9
	6Pbo7T/5vK5C6vxerEYO31+dDJQvgcaXawN1b5ogjf+RzX/kyxiVCib4f8NRFjoT
X-Gm-Gg: AYBFou1l8t/ejsuk6FWkO9AFsLuYArjvi2mVkIKQwCMOpKoKL3E6H36kiHNPVV8pv9R
	W8MfOOTONUxqo15LAUSaFWMEQjrbeFyFsT3cVKcR2KfCs26aNNDE1FVUJ4A7LZVJqafy7JtFgAh
	3EksvSYKmDikiL8IUaKxS8T7hSnxsEpZkMphR14jpvJar+utpGEe6Wkl5nq8zMGEw2QB2+X0NqF
	c2Y3g1SpHxdY93J7xF2En9NmlDMl0PIIv1nq9xzGsIv6QvxlEQrZ+h8C71M+SA+FOmNodi+0kdk
	pImiCYurjtbRIrmWavV7jwu9aJ/BSyskkMzBmnSGqa5yJ7q0JfS/PQIfaOabXqq9bFNothHsQO8
	ENaI7jAsNjRzbq1cPT75Oc1ZfVHOIha2B1H5C4qBBpOc7Fv46kEwFMIj+G1i7nM5UQZKukgaGUR
	H7xYPQpRWIHee+gWId65IWpxyCQS4lcnEz1cmFrYSiNlM3WPZcjah0ekmaA5ISay3cSfbKT4PeV
	SxRQ+I8SUoFKkmuPlM0InoDQzEfyQ==
X-Received: by 2002:a17:90b:55cf:b0:38e:480b:99a5 with SMTP id 98e67ed59e1d1-39debfb1b55mr285441a91.2.1789343195257;
        Sun, 13 Sep 2026 16:46:35 -0700 (PDT)
Received: from morax ([49.36.138.18])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d9587c157sm17395174a91.16.2026.09.13.16.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Sep 2026 16:46:34 -0700 (PDT)
From: Aaditya Kansal <aadityakansal390@gmail.com>
To: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
Cc: linux-raid@vger.kernel.org,
	Aaditya Kansal <aadityakansal390@gmail.com>
Subject: [PATCH] md: add max_disks bound check in older version
Date: Mon, 14 Sep 2026 05:14:38 +0530
Message-ID: <20260913234627.465492-1-aadityakansal390@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
References: <6aa6deac.f670cee1.72fc4.0013.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..f5fce41637f1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1693,6 +1693,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			desc_nr = rdev2->raid_disk;
 		else
 			desc_nr = next_spare++;
+
+		if (desc_nr >= MD_SB_DISKS) {
+			pr_warn("md: raid_disks = %d exceeds max_disks = %d for version 0.90\n",
+					desc_nr, MD_SB_DISKS);
+			continue;
+		}
 		rdev2->desc_nr = desc_nr;
 		d = &sb->disks[rdev2->desc_nr];
 		nr_disks++;
@@ -1722,7 +1728,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
 			d->state |= (1<<MD_DISK_FAILFAST);
 	}
 	/* now set the "removed" and "faulty" bits on any missing devices */
-	for (i=0 ; i < mddev->raid_disks ; i++) {
+	for (i = 0; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
 		mdp_disk_t *d = &sb->disks[i];
 		if (d->state == 0 && d->number == 0) {
 			d->number = i;
--
2.55.0


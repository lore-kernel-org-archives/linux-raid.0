Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8C2443AAD
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 11:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784806082; cv=none; b=RlCpCeHUNFnS1l4IjKKUDL/vfYRaeDIoOVggUzsa+MsywEAozEqWqE8Bv5O93v72gFq5Qung2m/d+T7UvnzCGXsjb/FtqxOgVhbje+r5ZYbjqoHeKeRZrpVCThQ8VXUIznpqGWLkE2225my7OfD1WafUsXiiqfUfV5/kGsgCyZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784806082; c=relaxed/simple;
	bh=odyyg+HPT8/8Rbv0fSnbNWFS2RKUju0DtQyJ04gVCME=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j2mKhkFfBnd+ZUcR35p51V4bpKiFb2vQnsy4qv2fw+KMAfYdKUJamA0a4CzsmKePyaLybCR95ov/KKMytq36jMTEsr6Xl8f4DaHixXcFSGtkwxN4Xy9OVZqHjjL9v9qglCZ9EAfZzzHcqE/N+Muu+amStLqsOMMprMx6gLgQNCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Idaa5Ug9; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Idaa5Ug9"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49548e01d02so3025315e9.0
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 04:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784806079; x=1785410879; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DaeaoMFhGhjg/ZgMyu5VolNB8j2MUtp7YENXxIH2a+Y=;
        b=Idaa5Ug9jRTwOCDeiLsFlt9dRPRdzAwmtsZRigYdCDmfOntuIznpEt1srchhjBOq5H
         pLCfAIwUoCmGaM3qp2yzuK3VIn4OfSyDdq3aofwJlAiDD0h/otdZ934mhl1yBGTGl0G2
         frog2xBL4b+EHpLiSpgnAlYV6t9sRoaIvWtG7cC+oL85JC+wXAxww61LHRZXG75tXxHB
         /UQXcqyA7Ygdeah5GSJ9IM/4smh18mjVo/UHhrTSusjfVW3bktJeERUMMzxTys9KSVUd
         IycK5YuDaj4kcSivxoNniF3jRf2GBvHFy71zKE9l2RXfB41XEO6wyWkmAwKLbcTTPA38
         ekmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784806079; x=1785410879;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DaeaoMFhGhjg/ZgMyu5VolNB8j2MUtp7YENXxIH2a+Y=;
        b=GyesNT5chhy8wWiAlvFAGiFj9n+U6nrOESkXm9M79KBaxE7El8/GvaVLSsnEeyzSex
         aAdcZ651h7FUzCK+G+y3p4I2ZSQJ/Hf9rJdwK738ewHrKo33D/AVdAd/VOjaKry7i6s0
         ADRBA50Y69zMV4OwADVk7lASL2KtmTFtyIWI+WZfGzbmL8aOj2XI4oEg6rgpByctRSHo
         A3EcavJCbLyOpUcFpOaXFzFF+n9PGFdhFzXc06n2WgY9yIgOBVolSsBwPEmqnJ3UbrL1
         GvGopBJElaiEn8cwqVoKYOJ8wBAfrtWN4uns7HBWyQVn3YnsJu6PYaKb/hiZDlo6bvDa
         gkeQ==
X-Forwarded-Encrypted: i=1; AHgh+RrL6Vok+OjorX0VQzpRW70CXhHfrnUU/6DI7ccm1tQ6+3yYma3dJ6J8H71zC4qS41D5oGIK6I8hXCVH@vger.kernel.org
X-Gm-Message-State: AOJu0YyuhjOOBNl4xiSxNwEmktey9deSoCXVqie08BGzWgetGJdISDKa
	FKBPQH+OGwXX+c66g6pV1ttFBCJYoiTD2mFbsWZu4VmVMpykzdHFO2fpgNySPnfvuiM=
X-Gm-Gg: AR+sD10pB3PdTSHAj7j7d+VwT+2kCfy6azVDtW5s0MAg6+8GPaOHZqHW7ChkCZ17pik
	rvP0Rp8hkVXGUrdLrZu1wKeMk5dZxgXlxD3G2jFLK7a7g8cPRqf28R7WfnSwPY3P9TjMr8d+ZJp
	UqId+o169KLMsluRFfCRdinRc757Scyl1kMQ/fIuMI66y8VEd2GI8GLyKZrn5G0myItUdu0F4ob
	nPAp4vxnrW7zlDW80N4dnxRJjKc7tr352sguLSVSnL0yDtPSuaVCn2NJE0vuTkfJzOawPzunbx5
	zXrccnOXE7E1i28rYWnZx+w1qWzaq5Vygt3XQT7EER8J8qRfeYO7tjOaZUpFudSCEELnVq0bbpl
	2xbcENJgAfybCkzWgH393kDV8uLHW0Y1aDtTojwc7ZgZ2gK3rn1c1j8/spWbMlG1J8U3OKfL5BU
	jwITXVoLFYo9YM3s0ArT/xNEFDmNSSiqBdVUX0Mr0CxRD158SZGAAfp7/g+Ioxe8dD1g==
X-Received: by 2002:a05:600c:1f92:b0:495:4c62:9d43 with SMTP id 5b1f17b1804b1-49573d1ff7bmr28170775e9.34.1784806078926;
        Thu, 23 Jul 2026 04:27:58 -0700 (PDT)
Received: from localhost (p200300de37461100f390c52e1c249082.dip0.t-ipconnect.de. [2003:de:3746:1100:f390:c52e:1c24:9082])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4956a509901sm249432115e9.8.2026.07.23.04.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 04:27:58 -0700 (PDT)
From: Martin Wilck <martin.wilck@suse.com>
X-Google-Original-From: Martin Wilck <mwilck@suse.com>
To: Yu Kuai <yukuai@kernel.org>,
	Song Liu <songliubraving@fb.com>
Cc: Xiao Ni <xni@redhat.com>,
	Li Nan <linan122@huawei.com>,
	linux-raid@vger.kernel.org,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH] md/raid1: create serial pool adding rdev to array with serialize_policy=1
Date: Thu, 23 Jul 2026 13:27:41 +0200
Message-ID: <20260723112741.1206836-1-mwilck@suse.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The following bug has been observed with kernel 7.1.3 after adding a new
rdev to an existing RAID1 array that had enabled serialize_policy:

[ 1754.091836][T19639] Oops: Oops: 0002 [#1] SMP NOPTI
[ 1754.092679][T19639] CPU: 0 UID: 0 PID: 19639 Comm: ext4lazyinit Not tainted 7.1.3-1-default #1 PREEMPT(full) openSUSE Tumbleweed  b041a6527f6e58424f4cd3de0fade8d408b378fd
[ 1754.095245][T19639] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
[ 1754.096772][T19639] RIP: 0010:_raw_spin_lock_irqsave+0x27/0x50
[ 1754.097769][T19639] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 53 9c 58 0f 1f 40 00 48 89 c3 fa 0f 1f 44 00 00 65 ff 05 c0 bc d8 01 31 c0 ba 01 00 00 00 <3e> 0f b1 17 75 09 48 89 d8 5b e9 85 8d fc fe 89 c6 e8 c3 08 00 00
[ 1754.100996][T19639] RSP: 0018:ffffcfbbc0a5bab8 EFLAGS: 00010046
[ 1754.102037][T19639] RAX: 0000000000000000 RBX: 0000000000000212 RCX: 61c8864680b583eb
[ 1754.103367][T19639] RDX: 0000000000000001 RSI: 000000000000092a RDI: 0000000000004960
[ 1754.104723][T19639] RBP: ffff8efae2b12700 R08: 00000000ffffffff R09: 0000000000000000
[ 1754.106038][T19639] R10: ffffffffa0605ac0 R11: 0000000000000001 R12: ffff8efad4199400
[ 1754.107343][T19639] R13: 0000000000004950 R14: ffff8efaf9164600 R15: 000000000004043e
[ 1754.108697][T19639] FS:  0000000000000000(0000) GS:ffff8efbdc754000(0000) knlGS:0000000000000000
[ 1754.110190][T19639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1754.111280][T19639] CR2: 0000000000004960 CR3: 000000000d830001 CR4: 0000000000770ef0
[ 1754.112580][T19639] PKRU: 55555554
[ 1754.113182][T19639] Call Trace:
[ 1754.113754][T19639]  <TASK>
[ 1754.114256][T19639]  wait_for_serialization+0xb9/0x260 [raid1 9ad4618e4becc97c5a7140f7aa35cc4730d97dd9]
[ 1754.115869][T19639]  raid1_make_request+0x762/0xaff [raid1 9ad4618e4becc97c5a7140f7aa35cc4730d97dd9]
[ 1754.118368][T19639]  md_handle_request+0x1c9/0x2e0 [md_mod a261f96e3d61eb9d00ceb34dc9439cf6487db185]

The raid1.c code calls wait_for_serialization() if the MD_SERIALIZE_POLICY
is set, and wait_for_serialization assumes that rdev->serial is
initialized. Normally this will be the case for arrays that have
the serialize_policy sysfs attribute set to 1.

But when a new rdev is added to an existing array in bind_rdev_to_array(),
the condition at mddev_create_serial_pool() causes creation of rdev->serial
to be skipped. Fix it.

Fixes: 69b00b5bb235 ("md: introduce a new struct for IO serialization")
Signed-off-by: Martin Wilck <mwilck@suse.com>
---
 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..baf79c501c9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -234,7 +234,8 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
 
-	if (rdev && !rdev_need_serial(rdev) &&
+	if (!test_bit(MD_SERIALIZE_POLICY, &mddev->flags) &&
+	    rdev && !rdev_need_serial(rdev) &&
 	    !test_bit(CollisionCheck, &rdev->flags))
 		return;
 
-- 
2.51.0


Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A74A261C
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 17:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270033; cv=none; b=JdSYlkv4knqUqOVjEeXOP0KlB0Wtm1rEXqHRXZDqWdYXex1znh6JhEViITFep21pe3FZtRWC14ScVYOpY5+obyiB7qiB4BL4jNfQ6vSZ3FqN9k15yqxVGqZyoRTuZ8amGAtWCn3oFpTWU5L9VP2iBbs14BqUX5dbhqogT4IOxFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270033; c=relaxed/simple;
	bh=yatFOlQEHKM1idOKtsPRhNKJVegoQq4WnaecfRgvFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TkVzaydvelN7oErFPOu/Q+9IqWJaPpn4c9sMU8DvBh+/HLE6k4dl93363iIx1+bNwS36PbRe6klqLNeGcpPpggk5ah0m8dILCkMF5XG1+odTgOz3IadxqJa/aej0k0ABRuLqUNJhIpgvF8kCq8DFKfDPmJruJx3N+L/uh8wD50M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oIXp1dPo; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oIXp1dPo"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2db22383fe8so11178535ad.2
        for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 10:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790270031; x=1790874831; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s03RzckkbfOoT3ESdTeh9le+Yb+Ao44F5P5+Eyv2U3o=;
        b=oIXp1dPoeDTbTCUB6HkskrDERRFI8tkIwZ01V9/krgpGIg/vAYJHdiyLt8rRuq9a2b
         vl7q36QgafPL6co1wBx2odfaIjdvlkpT7FhKx/PeWd5SXWCgWmsaUgOG7yWw2T+lppqL
         ZMQEwPyFD5YS4ty5r1eYTd7csVnd+gF8KMV7OlPcXYNx0ujPXe4DqH7X79dAWWjw0IuI
         8EdtFcNSV07P4YlSyAcSw7XFfXvvTClzSkn5nr6P+1QCTxZBl3316B9TAkNQTXt77cQK
         7xTPthbcrFAzPQaGYp37iqcxNFWShYKBMC0ev6d4iFAK5UqGaCr5IVPKsbsYHKAnyUuy
         V3lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270031; x=1790874831;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s03RzckkbfOoT3ESdTeh9le+Yb+Ao44F5P5+Eyv2U3o=;
        b=G2W5CxuHkVikmV25PJLchITMSp+IQQuQLEf9IckbIbO1/gPpj+jNfkVI5DcS89M7b7
         hHqYbs0AnoMgOPt4z7uwnzu7Jgo7Pq7W9KfBTJmjmhQvGrXDDhbjuSV0Lb8xJtz0ZbhJ
         qIoH24XyvQxC0jyp1zS4blO8ig2wN/7IZ7wY04GNbnvmYA7vaNzhnADl64LcC07YGGZp
         pl6PBgFyv4/wiUCj5PfYkBmsyCyEceiBYd680fPs4uCBuku1sb42wnCfHZIFkTjpNEH7
         S6igDsvww4zZOSW/Ph4nik3HkZtI274tTpXesvPXFqXjuWK9PXDfWsmUc+0dUSGEj91d
         eekQ==
X-Forwarded-Encrypted: i=1; AKwUvBxLRIzOQPmWbhWIXaxHvryU2TNpn5FJDaaSGmJyImm+lUKeGcQGXEE/+fExnJVcgO31ldnXEqDCrJ0A@vger.kernel.org
X-Gm-Message-State: AFuF++ljxTXEuzbXu53mykusEZ834NVbu8E/+uLwl3m1YWLMTO0bb86H
	VYtBo7zkb19ZJ4b9/W44YfYtPpd+LNHuRjT4mNXjEGuJTl+HSKYkYNey
X-Gm-Gg: AYBFou3m3UkWVwXg34aZ8mpdsDJzS7mjn7/GvxzdBvpe8DrsnfDoE2J6TKCkGzlt152
	U0Qjicqa9XFGA5Z+ZsH0BsHXXodOsPxVXlsD1YKMvnu9bBCKFMP55O/np0MkhT/PjLLvVCDnggZ
	kV4y5GyDiPx2gxBzTC2f6r9KEhtZhQyvETp3nVM8jaKhq/ENQHxNSZNlBWaX0+bvHLYLbP4cNPv
	TufbbVBxg7Z+9Zvkjyqc+9bO2mK3LmoHEM5erP5858J/J2/02hQQ2ExaOeoNRSeEpOLlEtUHks5
	/X6wBLkOn6YZ9FqbZVUBrX48QKmk8WX76c8b4o6XJrV/GJGRW36Fnp/D1+6yEMr+cE32OLZfAre
	Yl5FpgnshdE47zXbyTI+uDnOlXEf/95sY9JDmvnsAhVVBK/YwCukh1C8cSqmaW2mdkeJISNKo5o
	1MkkHRZyVZBYHfEVtzeZhAcUHn9ntLNmUJJBFTr2O18Mu+ZIIw1VNFPfRIeVeOmGFmJ/V7fAhS+
	zbI4y0GqukIbtmW
X-Received: by 2002:a17:902:c40e:b0:2dd:c0ff:e72e with SMTP id d9443c01a7336-2df7e0069ecmr24891975ad.64.1790270030888;
        Thu, 24 Sep 2026 10:13:50 -0700 (PDT)
Received: from thangnn-ASUS.. ([2405:4802:1d4a:e90:e904:a39d:67df:e3c5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5f965esm30940275ad.75.2026.09.24.10.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 10:13:50 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>,
	syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Subject: [PATCH] md: take reconfig_mutex when enabling PPL on an inactive array
Date: Fri, 25 Sep 2026 00:13:45 +0700
Message-ID: <20260924171345.75894-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

consistency_policy_store() sets MD_HAS_PPL for an external-metadata array
that is not running yet, without holding reconfig_mutex.  But ->pers is
only assigned after pers->run() returns, so "not running" also covers an
md_run() that is in progress under the lock.

If the write lands inside raid5_run() after log_init() has decided not to
set up PPL, or after a failed ppl_init_log() has cleared the flag, the
flag ends up set with conf->log_private still NULL.  The next idle pass
of raid5d() then does:

  raid5d() -> handle_active_stripes() -> log_flush_stripe_to_raid()
    -> ppl_write_stripe_run()

and dereferences the NULL ppl_conf:

  Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002
  KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
  RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538

Take reconfig_mutex around the update and refuse it with -EBUSY once the
array is running, in which case ->change_consistency_policy() is the
right interface.

Fixes: 664aed04446c ("md: add sysfs entries for PPL")
Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=75d7e96ad03ac2dbbd9f
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Notes:

This differs from the NULL check in ppl_write_stripe_run() that is being
patch-tested on the syzbot page: that hides the symptom but leaves
MD_HAS_PPL inconsistent with conf->log_private for the other PPL entry
points.  md_attr_store() has not taken reconfig_mutex for every store since
6791875e2e53, so the store has to take it itself.

Testing (QEMU, KASAN, x86_64): one loop assembles raid5/external/ram0 while
a second loop keeps writing "ppl" to consistency_policy.  Without a delay the
window is only a few microseconds, so I used a debug-only patch in
raid5_run() (clear MD_HAS_PPL and mdelay(50) before log_init()) that is not
part of this submission.
  - without the fix: the syzbot oops on the first assembly,
    ppl_write_stripe_run+0x5d in md0_raid5;
  - with the fix and the same delay: 100/100 assemblies, no KASAN report.
The unmodified syz repro only ended with -ENOSPC ("PPL space too small") in
my setup.

 drivers/md/md.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 680b34a63cb3..5b2add94631b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5884,7 +5884,15 @@ consistency_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (mddev->external && strncmp(buf, "ppl", 3) == 0) {
-		set_bit(MD_HAS_PPL, &mddev->flags);
+		/* md_run() holds the lock until ->pers is set */
+		err = mddev_lock(mddev);
+		if (err)
+			return err;
+		if (mddev->pers)
+			err = -EBUSY;
+		else
+			set_bit(MD_HAS_PPL, &mddev->flags);
+		mddev_unlock(mddev);
 	} else {
 		err = -EINVAL;
 	}
-- 
2.43.0


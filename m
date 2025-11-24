Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06CF29B8DD
	for <linux-raid@vger.kernel.org>; Mon, 24 Nov 2025 02:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763953072; cv=none; b=EYDSWjw+gi3PVin+NQeEVc9UOsX616MEBxpqxWTMDIv9jwigJry0KP3mHvUv/cq9WTCQVrYqWoPZ3K7VHv73uHx9BrBMQLjVJFMQBex52TZ1yORJDlQYTQeBnVjDyUxOqe9Yaycp93BfyjhfeH6AcaRfg/KPXQQ9uKrcjBNKvUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763953072; c=relaxed/simple;
	bh=1rxomFQWvF3IATN9kucOuHHGa2FB/YCgzDqnGWQM12I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eBdfwADcVzRLNaNMMdsaVwPrAoqOuO4FiKx6dHCkguCo/++aU2RVSzu0ZSeLHS0CY0OPG4gTWrPH4wn/PdxTzGfWeK91suq7MHt14hUE5I5j4eapFko30Skq75UlHjdOpMPQVYcOwhgsXKZNKSrjMHx5rTmigH6cwnG7PPPeWVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=azIjdVI3; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="azIjdVI3"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-bd610f4425fso2279005a12.3
        for <linux-raid@vger.kernel.org>; Sun, 23 Nov 2025 18:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763953069; x=1764557869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=azIjdVI34KdCDfW4btCpFmAICXA7gD8DN3FA10SiAzUACJZ146vWSjuI6oEtkye28F
         zJIhsxt3btUYjxbiupNX8VLujqiH7qQ2s9iaxtoHfHD/6jlG+sirrXUWQp5LF7PFoNSR
         sIipqOcsR9kEA9S+/+D2kRyJNdccpwTsNS1UIqzy0d43FO7DQ5t8DzqkICEBy8S/obNF
         5SO3ILAiFwWwKmiBuG5py/BU0pKzvRIlDoOclvB0EEnA4YPIlUU+TfO9j755NT5OzLAA
         ofABhdoKpj3fzVuWJtdCkZkLZYFw0fy25FF3M2Gj6hcbHEdCp28wEVQ95thYDK9TSo9H
         Mp7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763953069; x=1764557869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7A/o1KMdHnERZPkaP005IU3nW52A8GrE+BEL9651kiM=;
        b=wIcff4Rhfcw2j1MDySrM0B5oyyAgPvSZAbhCXQyMyV1kETAjAdX8gxw0POOiWQnmxr
         Ydd5CZKnikzxo+hcAVgOR01wXjf0q3ixD5cgzuhxJgjdTO6tj0G2qtmbCsua2kWx8yeQ
         9H8kkVOnOHF8cDPMEHpz3PlOm+4GfG0V1/e4mbsHXO2lh1M1M7EyNf1Q6ZpMZkARqGLO
         f964m6fx1M1oH4H4h5/bY7Aq/eZGO8wVIsrFYVpnDnzNAz3kbJmW+dTn+Uo/L5ULvMea
         H/7wVOVFejMIjuO+Bxtx+v1WXpIWVaHi+wXIFnsj1WrFtZ0/WwQbZhV7+vlPyZkqIFCs
         cQVg==
X-Forwarded-Encrypted: i=1; AJvYcCWfyGjU46hio2TQnEBTuZO3DKmnW7okMPVydC9wMAnc9JvAToAJYvbTT+TSXDXWy+SVV4Khs1j27FyZ@vger.kernel.org
X-Gm-Message-State: AOJu0YykuMuvmq9y+Zu8P+LiPIIbo8OcSJ/4HsUA+CkDOaUtghJb4T8W
	nWyfLlPQ4vKBDcCFzey60b9emCVLuTga/43NiGkzYxzYkubf0YJCvNnT
X-Gm-Gg: ASbGncuIUdbMBLchAxoMVqiKFniOACvcpBop5ZjryGBbm6Ac/BnokRJueCdmsFVomhW
	8q+B0BdMVgey4MR+PQpH4kNfXi/jkOqlw9tK2UfLkk+XQUtCY/zM1Q/nzEXthyulbGDSanv8BVr
	4lvgIRIE2rZ3WQjPyXGi/Hk2Y7WbG5LJMeMzErXLpBXoFA6SfnV0fOdDcx7SEONsTmzvKCiR1Eq
	E9lK6nzNwnGu6VvYUO3ytQkVQ0pY+viTDZDOW5SMm2K+nEyCLNVlMHslq/0tRbcqzHgyAW/VdqZ
	IFnf0xNzL/eB75da34MSgpDvc5ujtVRWNkNmDG35RpCWPLrj89hBw3aeXK6VbVFGzxwHpHxwBmu
	MU+UOcUlAEQRb6iemjdRU38deCITdW6C9/znIFyCbUuSA2cTCJ6fFM/XtBGQ4+TGAT+ebmVPohR
	X4DFtlbHEN8p4U9LG7ZGTEMNRPkscHXy7eNTsSl295yGdDJwM=
X-Google-Smtp-Source: AGHT+IEmMLANDAnmsBNCneTvCZSlRusetXy+m9HCywmHN66AM/499qf8PoyOZ4xW94y10CRf7NdkQA==
X-Received: by 2002:a05:7300:538c:b0:2a4:7cb9:b7da with SMTP id 5a478bee46e88-2a71927d85amr6563682eec.25.1763953068821;
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
Received: from localhost (ip70-175-132-216.oc.oc.cox.net. [70.175.132.216])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2a6fc3d0bb6sm67532109eec.2.2025.11.23.18.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 18:57:48 -0800 (PST)
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
Subject: [PATCH V2 4/5] f2fs: ignore discard return value
Date: Sun, 23 Nov 2025 18:57:36 -0800
Message-Id: <20251124025737.203571-5-ckulkarnilinux@gmail.com>
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

__blkdev_issue_discard() always returns 0, making the error assignment
in __submit_discard_cmd() dead code.

Initialize err to 0 and remove the error assignment from the
__blkdev_issue_discard() call tp err. Move fault injection code into
already present if branch where err is set to -EIO.

This preserves the fault injection behavior while removing dead error
handling.

Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
---
 fs/f2fs/segment.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index b45eace879d7..3dbcfb9067e9 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1343,15 +1343,9 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 
 		dc->di.len += len;
 
+		err = 0;
 		if (time_to_inject(sbi, FAULT_DISCARD)) {
 			err = -EIO;
-		} else {
-			err = __blkdev_issue_discard(bdev,
-					SECTOR_FROM_BLOCK(start),
-					SECTOR_FROM_BLOCK(len),
-					GFP_NOFS, &bio);
-		}
-		if (err) {
 			spin_lock_irqsave(&dc->lock, flags);
 			if (dc->state == D_PARTIAL)
 				dc->state = D_SUBMIT;
@@ -1360,6 +1354,10 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
 			break;
 		}
 
+		__blkdev_issue_discard(bdev,
+				SECTOR_FROM_BLOCK(start),
+				SECTOR_FROM_BLOCK(len),
+				GFP_NOFS, &bio);
 		f2fs_bug_on(sbi, !bio);
 
 		/*
-- 
2.40.0


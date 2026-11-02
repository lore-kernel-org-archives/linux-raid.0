Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793622544;
	b=K26I/g/57gAKAa5to+ovN1hDnvEI0MAGm0l96RrHaRHX5dVoPG52W3TX/cBZTJOHCoXc
	 4s5LxiS4fhnb0tQghKF0tmGlWVVoNMMQE6lruRu0vOpejnXkRVupLIamw/n1Eg/lTBpx/
	 0F4GUERuqZ5fRF0xWAya9MwPCzkj2/f0ri0+6WvN5u5w8+t5H+i3Mxjhm6EXVnhzJ6jq8
	 dx84RFRB2rO/aNa9iyDPog7Raix6vFwdMM/gCxEZN+80uS3IOITSJnZuM9nknH0K0lKbZ
	 /j//97VFpNVtpnmpJrJLnxgpvyp6LtlnE8M/8hex/C8mRk7UMWZTb0b+JztanOsFHZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793622544;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=GyZdeAbOtqkzbSkUpNh0d1h4qY0XMF49rbWHS3d1uig=;
	b=jjTQ7gvOWTjhSbr4Sfj6bYcWfaNJjJKOaq1sKdFeM/Nefo6gAN3F+wBYWoG+gAyXvODV
	 kzJNF8zO8/Um53eFN2Bj8IknJ2sjWFb3w7HEkFFzx7gTTGprT1NjxxES9zq1L1IzD9RdE
	 /Uq/Xo9J5PvwthfkbCRzO3ydTqbzlFoFTGRCLmKu0PaoNXL8FwrLr8GWMsp54z0TBlank
	 5Kw4fzFt4LqC9uttnCQrd12iBb/1FlcfG1azWvd9bkaMfMIkIR5Cr7eIqyxgjPLlC1zkd
	 5ihc1zyg+1xHLJ4mAOAcStwjJj++f/Ph/sUVA4F9Z1gHWeS2dJ+7e1eAQ2bqD80UueA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="pyHd//ED";
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5547606A324
	for <linux-raid@vger.kernel.org>; Mon,  2 Nov 2026 12:29:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D5547606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=pyHd//ED
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91c67992ce5so22331376d6.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Nov 2026 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793622543; x=1794227343; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=GyZdeAbOtqkzbSkUpNh0d1h4qY0XMF49rbWHS3d1uig=;
        b=pyHd//EDO6sMRs2Eyv6ArIF0S4T1nBQcyGYd18mQA307hK6Vimkn+eYDIKYPOIJBAM
         LXZfltIBDZVl7x4q3WusCqF3CP58tgow3o+jZy+rK3khMQ+Vnrwv0BVkNxxbF39M9aD7
         vHghu+6nvAkoMwcA0FuvwarhhzR0NdsijfTDW8yLPjfqYIxVTMY/Ep/iCM0rdWpOlxR1
         X7NIasuPZommqxVzEg89TaBP/rn/oRXufZRevaEHVbzgmy+3RhWUxrseqyK6h47Kp9i7
         eqszrKLDltlBtWJaTGy6m043A+ad2DVnUhbO9nK6qRcKN6wdOUR76EPbqIsAePqvmiHh
         5W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793622543; x=1794227343;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GyZdeAbOtqkzbSkUpNh0d1h4qY0XMF49rbWHS3d1uig=;
        b=ACYEq9BputCq4i9qdiN8AHPz72G5GGjPJU/awxAm8ZX4MW5zJMAfianumdLRZjEgYZ
         TwuwXz+4D/RnLc/wwO3yFtT1JraLgK87ruxg4BsQa0GKZwkxqvv6UXKVe7Z+iRI4KrGl
         Vklh1nGH0gv2v9NubpSuqQr1QArKwgEzWzX+qKjkeqQn0TljvRLP+rIYND6YW39maS7n
         Snt+Sf2WTWyKHM1n1yHgAmTmDctHNSfm4pCUQtsRsZmu74SSNcjWUgwI5iEi+YRL020l
         Y3FwH8LWdepg5VYyOc+62d23t8xy9qmuN0WtFEpeZio5zfX6TVGRhGQM1y/zlov61Nev
         7zgg==
X-Forwarded-Encrypted: i=1; AKwUvBx73j994XPq94BWSnB6d6msS7Qmoehur5do6cYrJjYGOm1Oj1+GclLOvcH4wybllVAqxX3B37pkxr7B@vger.kernel.org
X-Gm-Message-State: AFq9FYLnB9d+uHiRoo78hntAzRk8/M0HSbqPbdCCFDJQUtMhlk6nBzun
	KME7kwOYZxPeTEpAlMQ0j5b3AFZ96jvqMeANG8sbb9aTKD4D1bNeEWFuFDtv/AON
X-Gm-Gg: AYBFou0rHuWpr6IYHsNziXim6IyNpRruoajAvjqoHA8PnCCbsbtT4j0i6QX5t9QFPvR
	uEiCUx54zG3L1VEQikl4woaVM04KOzhsB7KPFufA8k6gkMChoyaimKWn9rSYUWkpt+vruFuMl8/
	AFYs62aETeiD2DdeEJ1pxMPVFjPj1xFZcXlorzDiwkKM1eOmAqPZC9tObsNfCCCTRUiD5rcCXnA
	3OJHJIuNWr6VFmoNy3IOputqaTJ/rqZyqGwBrbo6RyGIFnZJQZ8vSzTb+wSGT5vDGnbsbLr5SUL
	KW2amr446ZmKzJySH8wy0txEeZ4uCguvXzKETbvvA7h7kBVJhDlbxpw05FgolbWAU7ALNoR13lJ
	9TNDFM5D4HWDEzrM4RiI+gpmAhvwkRkD4R9TrIF++f+Rfd/s4KxLEO/Lux4hl4R+p5JFAkFSnaN
	pWqqCEwZHYEL20uKNoHbtgFa3Vn39BxgynwA/vN/AGQEwct+nHOiHDe+Dmpb05T5y+w5e5uzwEC
	8SrdoebgeZvgBzL3QXTEKq100gJ8RymWWWCbXem2w95DaClxmZFzZmphgCvYs/+7pKqYMY0c2+z
	FA9gGyoKf+Yd1XPqHxdRijMSHyZmc4XF
X-Received: by 2002:a05:620a:801c:b0:93e:c12c:fbcd with SMTP id af79cd13be357-944217a3ad0mr1573777385a.73.1793622542751;
        Mon, 02 Nov 2026 04:29:02 -0800 (PST)
Received: from fedora ([2409:40d2:102d:42fe:94:1c18:1e05:91ee])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-94425852274sm825390585a.19.2026.11.02.04.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 04:29:02 -0800 (PST)
From: Sajal Gupta <sajal2005gupta@gmail.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com
Subject: [PATCH] md: fix use-after-free in md_attr_store()
Date: Mon,  2 Nov 2026 17:53:04 +0530
Message-ID: <20261102122430.39209-1-sajal2005gupta@gmail.com>
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

md_attr_store() calls sysfs_break_active_protection() for a "clear"
write to array_state before it calls mddev_get().
sysfs_break_active_protection() does kobject_get() on the mddev
kobject. If the array is concurrently being deleted, the kobject
refcount can already be zero, which triggers "refcount_t: addition on 0;
use-after-free".

Fix by calling mddev_get() first. If the array is being deleted it
fails with -EBUSY before the kobject is touched, and if it succeeds the
array cannot be freed until mddev_put(). The -EBUSY path no longer
needs to call sysfs_unbreak_active_protection().

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Reported-by: syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dcad997ed2b5bd95cc5e
Tested-by: syzbot+dcad997ed2b5bd95cc5e@syzkaller.appspotmail.com
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
---
 drivers/md/md.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 03e35386a802..26f17dd24bdf 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6163,17 +6163,16 @@ md_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	if (entry->store == array_state_store && cmd_match(page, "clear"))
-		kn = sysfs_break_active_protection(kobj, attr);
-
 	spin_lock(&all_mddevs_lock);
 	if (!mddev_get(mddev)) {
 		spin_unlock(&all_mddevs_lock);
-		if (kn)
-			sysfs_unbreak_active_protection(kn);
 		return -EBUSY;
 	}
 	spin_unlock(&all_mddevs_lock);
+
+	if (entry->store == array_state_store && cmd_match(page, "clear"))
+		kn = sysfs_break_active_protection(kobj, attr);
+
 	rv = entry->store(mddev, page, length);
 
 	/*
-- 
2.56.0


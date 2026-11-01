Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=160.30.148.34
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793535004;
	b=qOITYUjx6Ljj+lx0v8RoQQPNbciEcrA176CBLiKobftj3vfTsjtSePztDKdDLd/ZfOS0
	 3ViSEf9bJLEwqXgN0GxQZL4BeEVyiCnM1PsVRhnwiTLN8NTJWPfvYy4x3tiHLVVeKTNxS
	 ZD05mAfbuHMxybZtD8r81qt4Vhd+QmHtaIjAlmII01sLk/RbJjSQbaXnA+8rPO/rLuAku
	 6Y8xBFQ+78BDrmLEq/Ffw5G9mCVmrZRUDWwzAOLTOGlprZZdRGJYiUsJmtDwTVHIYDf9g
	 OnZ+Ncuuq3HcBQ1lT1EVeyE4Wr9pmLumY/yGRqeP33YxQN+q9jMeY+85q5n5cDDOFGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793535004;
	h=DMARC-Filter:Received:Received:Received:X-Zmail-TransId:X-Mailer:
	 Message-ID:Date:Mime-Version:From:To:Cc:Subject:Content-Type:X-MAIL:
	 X-TLS:X-ENVELOPE-SENDER:X-SOURCE-IP:X-CLEAN:
	 X-Fangmail-Anti-Spam-Filtered:X-Fangmail-MID-QID;
	bh=28v7zKMA0QC3u4309Ch10ZxYVg6RgZ3COat7tgKLjNo=;
	b=B8WZ2d/XyZnWecLdEhZjVN3QiCmn6DlDjUx7VF14KZKCGUh1PJ/9EpAtX4EwQjsOh8Ao
	 1P9Bw+Ftu184HTyisVM2Fb3h0Ni/KRAR42DZ5YLTizvdxj+QQakCvfOz81nT6GMfZsNl3
	 sBFC7wEWUVFL/G2GyzuLftLvhnV24Ilt4QeqzCuDXa4/EqvtrCYh2XJLG4aB8/sWJXVIF
	 qtfUbrUO9XianNa7uAUlmz7nMBpiP/r/paG6RE7ejfb+UgeIj4/a+F8/Lngg6NMLv0xmd
	 xZ2LOH+WecbFZt/Lcn2PkNzOV1OQ7hv/VLjJuFpPn2im/xOJSofFY1RWbUUzrveBNhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=zte.com.cn;
	spf=pass smtp.mailfrom=zte.com.cn;
	arc=none smtp.remote-ip=160.30.148.34
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C7606A324;
	Sun,  1 Nov 2026 12:10:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 045C7606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zte.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jHYYh6VTPz5B111;
	Sun, 01 Nov 2026 20:10:00 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6A1C9td1094258;
	Sun, 1 Nov 2026 20:09:55 +0800 (+08)
	(envelope-from shao.mingyin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 1 Nov 2026 20:09:58 +0800 (CST)
X-Zmail-TransId: 2afa6ae72c1679c-63d42
X-Mailer: Zmail v1.0
Message-ID: <20261101200958563ZkI79UKy510arbmzZJPzd@zte.com.cn>
Date: Sun, 1 Nov 2026 20:09:58 +0800 (CST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
From: <shao.mingyin@zte.com.cn>
To: <song@kernel.org>, <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSBtZC9yYWlkMTogZHJvcCB0aGUgcmVkdW5kYW50IHN5c2ZzX3VubGlua19yZGV2KCk=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6A1C9td1094258
X-TLS: YES
X-ENVELOPE-SENDER: shao.mingyin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Sun, 01 Nov 2026 20:10:00 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AE72C18.000/4jHYYh6VTPz5B111

raid1_reshape() unlinks the old "rd{d}" link, assigns the new
raid_disk, then unlinks again.  The second call targets "rd{d2}", a slot
that has no sysfs link yet, so it is a no-op; sysfs_link_rdev() below
creates it.

Signed-off-by: Shao Mingyin <shao.mingyin@zte.com.cn>
---
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 894efb50c6d5..25b80ad52f00 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3351,7 +3351,6 @@ static int raid1_reshape(struct mddev *mddev)
 		if (rdev && rdev->raid_disk != d2) {
 			sysfs_unlink_rdev(mddev, rdev);
 			rdev->raid_disk = d2;
-			sysfs_unlink_rdev(mddev, rdev);
 			if (sysfs_link_rdev(mddev, rdev))
 				pr_warn("md/raid1:%s: cannot register rd%d\n",
 					mdname(mddev), rdev->raid_disk);

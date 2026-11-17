Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=111.22.67.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794959842;
	b=loVEYHCt86alu+yWusTlPgJ3qLTRPdcuvEAi/lVjQsjXNAGSts39BSa+phbXwdOSF2yD
	 mSu8bcKpk9qS8vkbZHMM77aHngV5DJMy2lUu9uvRYoPN5XBcOE8AE1Q6JYzZIrx9b0EZo
	 QZZ68ykvWjSig/gVHpUfyhYC2ZyW/WHOsWq92/Vd5RlLP97Eu67uGFkPr9Wq0ssLvPOjw
	 LmbUkWKxIH8CnEtenDLT7oPPbB4FdmdEHHic69p3GLGIXJ2pj9QAMzv83FjfT0uFyJbRG
	 4bZRCjpptlR0vesq2FMBZ70UZsCBRq2OONaTsETERL5F1ZKPw4SzVDhuR0IjLO0mSPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794959842;
	h=DMARC-Filter:DKIM-Signature:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:
	 X-RM-TRANSID:X-RM-TagInfo:X-RM-SPAM-FLAG:Received:X-RM-TRANSID:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=KhAoBwf3NWu02gsp0vLrpOhmhFlMWeezHYPZ/IdY1+U=;
	b=2FLoXqW56yF2jhVowQexTjaCjHp0fwuzHiMPUOlLDrt9Kq1GqUfD3BkztZzUUHEJLPA8
	 8IIvsNS7QJZwGMBMgomFydv5jfNOQRCLzq3+jcXeuVM0F3K7MOqJDcDJnjSDB7enc1vuA
	 kYr/gyl49Xr2a7ZGSe3bKUeL15h1ITXxxHx3emqZ4Rfvin3iD/eGifi0WTU9t/jzk3SNL
	 nYDE0OoTe9ZlIMLZ2XjU6+unyAFHL22TLO4FP0oOr4U/HdCXhXDoscRCVHk3fnRSD1YPO
	 DzQjOnjuKtDXTgEvdzOKR7wSX7lQSLDpPJrqAK+RbEk9l5CcyAxDhkzkihh7LQ0POmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cmss.chinamobile.com;
	spf=pass smtp.mailfrom=cmss.chinamobile.com;
	dkim=pass header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=cJ+VtMF4;
	arc=none smtp.remote-ip=111.22.67.139
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC08B606A32A;
	Tue, 17 Nov 2026 23:57:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC08B606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmss.chinamobile.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=cJ+VtMF4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=cJ+VtMF4X8JMTGsdEvij3xRcmj1mOrfv2v0dFxj6Cod/4jlr/cuNp75JKLpBVaFae8Y5PgC0tK5xl
	 GeYZS3/Pm6XCMJxDxDaRHXce5AH0tRk3J5bzix0MBIThpKKRQ4JpvOaMNBd3YjwVTHOBt5Gxq9/ZK3
	 sNalKw4qAzQhnrVc=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee56afce9d8601-0a0d7;
	Wed, 18 Nov 2026 07:57:17 +0800 (CST)
X-RM-TRANSID:2ee56afce9d8601-0a0d7
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHD-W7400297 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr08-12008 (RichMail) with SMTP id 2ee86afce9da33a-296bd;
	Wed, 18 Nov 2026 07:57:17 +0800 (CST)
X-RM-TRANSID:2ee86afce9da33a-296bd
From: Aibing Chen <chenaibing@cmss.chinamobile.com>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] md/raid1: reject oversized raid_disks values
Date: Wed, 18 Nov 2026 07:57:14 +0800
Message-ID: <20261117235714.1101-1-chenaibing@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
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

r1buf_pool_alloc() allocates an array of struct resync_pages with
conf->raid_disks * 2 entries.  raid_disks is set from the user through
the SET_ARRAY_INFO ioctl and is unbounded, so a large value makes that
allocation exceed KMALLOC_MAX_SIZE: kmalloc emits a WARN_ON_ONCE_GFP()
splat (syzbot: WARNING in r1buf_pool_alloc) and returns NULL, after
which the resync fails to start.

The same disk count is used to size the mirrors array and the r1bio
pool during setup_conf(), so reject it in raid1_run() before any of
those allocations happen.

Reported-by: syzbot+c0e700c08ee88f60e54d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c0e700c08ee88f60e54d
Signed-off-by: Aibing Chen <chenaibing@cmss.chinamobile.com>
---
 drivers/md/raid1.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 894efb50c..875c98552 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3169,6 +3169,18 @@ static int raid1_run(struct mddev *mddev)
 		return -EIO;
 	}
 
+	/*
+	 * The resync and r1bio pools are sized from raid_disks * 2.  A
+	 * raid_disks value large enough to make those allocations exceed
+	 * KMALLOC_MAX_SIZE would only trigger a kmalloc WARN_ON() when the
+	 * resync starts, see r1buf_pool_alloc(), and the resync would not
+	 * run at all.  Reject such a value before anything is allocated.
+	 */
+	if (mddev->raid_disks <= 0 ||
+	    mddev->raid_disks > KMALLOC_MAX_SIZE /
+				(2 * sizeof(struct resync_pages)))
+		return -EINVAL;
+
 	/*
 	 * copy the already verified devices into our private RAID1
 	 * bookkeeping area. [whatever we allocate in run(),



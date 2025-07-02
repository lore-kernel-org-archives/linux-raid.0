Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002B02E498D
	for <linux-raid@vger.kernel.org>; Wed,  2 Jul 2025 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751480909; cv=none; b=bzhcGao0W48d08ixsOqfGW2kaCzemy9QPs2RB8nWVZLxkJoZqEQ0EK9R5MpUgO5A8w6sGMhkwWeaauiGGQ64q7cz3JZ7DFXQcOKTcHFD6rsnnjCppsueFQwBGDqCdVzIEKrKW8YHIBucxFqxqejKb5EIKdgpGtzVsGIt4tE4S9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751480909; c=relaxed/simple;
	bh=mT8LGrarZCsEEl0CogjrVaViuaUNoEmgariwyjakdU4=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=Rnn+iykVK25ap+bEBTM1TKD6hhkHBJ+jPXmyZrbrhHwfXSxo/wWpXNRDC5pkbCKqWtq3gkgptC9Pt9UIUmScjXvEUe+U7xi9jqHYMlGEMngSuYJ6gXoGVmQhcZF17j1z07PIeFav1Y65lCDYtSyUXIziRa0EsPdoOFiKHACthQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PWNmhUOu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PWNmhUOu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751480906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R+/zMPinPKOm1/k8UglTKgWKdtQQ3NShMOhvU2Ow5Nw=;
	b=PWNmhUOuEN4HqrsjH4Ges4o02dzRfrqUB2YM8bOIBgBygM+Fk1pkUyC2Qn39xqpCy7OeLp
	t/m4nTTI1hYX1FhISp4aNkj7NpwqIOZcnEi/Kk27IPz2QRXSFNcvVIhAGzxDDsphSWkzIY
	JixIru66lJipJbdRGtriSvy/hFY27Uo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-392-ia4kELQhMz273LAC7AgVJw-1; Wed, 02 Jul 2025 14:28:25 -0400
X-MC-Unique: ia4kELQhMz273LAC7AgVJw-1
X-Mimecast-MFC-AGG-ID: ia4kELQhMz273LAC7AgVJw_1751480905
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fb50d92061so69291936d6.3
        for <linux-raid@vger.kernel.org>; Wed, 02 Jul 2025 11:28:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751480905; x=1752085705;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=R+/zMPinPKOm1/k8UglTKgWKdtQQ3NShMOhvU2Ow5Nw=;
        b=tGDe3VUbfOPVjp7ni8qU4T5mMjC9dm0CmOSnbC2FE/yOjPY8zv7X9oizAEQw87cUPG
         nxqowKkmQ2uflITL7IG1eXjjSxM/As+dfTUwH2eu2LxkayHXXcDXnZJ6CzOllTXY8ec3
         sjWCouiSGaqjysdXk2RFOzSbyTnv6TREVMV3ADNM2NfRCy/sODMvz8/ImOThxUAibd4b
         iZb1eQKSVyznNuObez+RG5p7FzpWP99O2MLXH4YgM3zxPaPkafBkbwIKchS2N1XYh7li
         am4kJDHMuR9JAhuyyEEXyoVgWtzwXdofsrlu1Vlq0AfKxvNpWW3/ide/UdgEF+zGxKq5
         psvw==
X-Forwarded-Encrypted: i=1; AJvYcCVsg08UKZiyW+9LEC8pZ/oilT9yQ1rNkpVx7/rQJEjZz38OFk+mQdFnzTQW9EAhcV0sqKhw9Duy0Pqc@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwbc9u+GYe+3Nh1uGVXVHLeDtNYboHlqusLpvDAQ4gYq9pa9Jc
	jKG2zJr6oE7FV95yDh0ySl4xjMSKkJTwzWg07hiX6UgiZn1EjVAsRxdOFqf5savRd1jMuC7jXrF
	IWy6UqqcCKgQNUhBrPKi1hhv5VdL3Ox18qO+Cy04C/Fb0MUB8lRbPbKouuQTzIn14JHt3g5Y=
X-Gm-Gg: ASbGncs5m+6S6gq/TAY1/cTiD7tNf5YEXR1laU+1JT+5xLOQbSl6UUcYwA0hEod+o+N
	7kxQGXy89cpBoeedk3me23IKsGBmQVFvv2L3L6i1U7ffMmohBujM+ra2ThshjoFrYmaGZyXkfUh
	kqDPrHEKUMkqUyICXnuJvTHqAlFOVRkpTjDgeCvVhxw6RPkBBJ0492X6qFchULbs8HK9N2MaRtl
	mjl/MHXD7dr6Jdmb6fRHGGifXMC77vYQ6whENuffqbp2hfgTahyEKI0u4mlmErfsQeBykz7ohM8
	TU5feUM/SOtiTiiDOc0vEjGZJDNtC5doNIPu
X-Received: by 2002:a05:6214:4412:b0:6fd:1d60:50b5 with SMTP id 6a1803df08f44-702bc90d717mr5836946d6.22.1751480905040;
        Wed, 02 Jul 2025 11:28:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHVulUTitBLkW1AiyXuaZEnWvAI00SB1ALMEDaTDUYg8+epXwtz76w3v8N+A0oIuPbc2ufhFg==
X-Received: by 2002:a05:6214:4412:b0:6fd:1d60:50b5 with SMTP id 6a1803df08f44-702bc90d717mr5836536d6.22.1751480904573;
        Wed, 02 Jul 2025 11:28:24 -0700 (PDT)
Received: from [192.168.50.77] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd771dcd5dsm104005286d6.51.2025.07.02.11.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jul 2025 11:28:24 -0700 (PDT)
Message-ID: <0b1a86f0-0cb1-469a-8ecd-29dfdf851401@redhat.com>
Date: Wed, 2 Jul 2025 14:28:23 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: yukuai1@huaweicloud.com, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, yukuai3@huawei.com
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH v3] raid10: cleanup memleak at raid10_make_reques
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

If raid10_read_request or raid10_write_request registers a new
request and the REQ_NOWAIT flag is set, the code does not
free the malloc from the mempool.

unreferenced object 0xffff8884802c3200 (size 192):
   comm "fio", pid 9197, jiffies 4298078271
   hex dump (first 32 bytes):
     00 00 00 00 00 00 00 00 88 41 02 00 00 00 00 00  .........A......
     08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace (crc c1a049a2):
     __kmalloc+0x2bb/0x450
     mempool_alloc+0x11b/0x320
     raid10_make_request+0x19e/0x650 [raid10]
     md_handle_request+0x3b3/0x9e0
     __submit_bio+0x394/0x560
     __submit_bio_noacct+0x145/0x530
     submit_bio_noacct_nocheck+0x682/0x830
     __blkdev_direct_IO_async+0x4dc/0x6b0
     blkdev_read_iter+0x1e5/0x3b0
     __io_read+0x230/0x1110
     io_read+0x13/0x30
     io_issue_sqe+0x134/0x1180
     io_submit_sqes+0x48c/0xe90
     __do_sys_io_uring_enter+0x574/0x8b0
     do_syscall_64+0x5c/0xe0
     entry_SYSCALL_64_after_hwframe+0x76/0x7e

V3: backed against Linus' tree.
There is no fix tag, as this is a new issue found.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/raid10.c | 8 ++++++--
  1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b74780af4c22..798001ebb48c 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1182,8 +1182,10 @@ static void raid10_read_request(struct mddev 
*mddev, struct bio *bio,
  		}
  	}

-	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
+	if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
+		raid_end_bio_io(r10_bio);
  		return;
+	}
  	rdev = read_balance(conf, r10_bio, &max_sectors);
  	if (!rdev) {
  		if (err_rdev) {
@@ -1370,8 +1372,10 @@ static void raid10_write_request(struct mddev 
*mddev, struct bio *bio,
  	}

  	sectors = r10_bio->sectors;
-	if (!regular_request_wait(mddev, conf, bio, sectors))
+	if (!regular_request_wait(mddev, conf, bio, sectors)) {
+		raid_end_bio_io(r10_bio);
  		return;
+	}
  	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
  	    (mddev->reshape_backwards
  	     ? (bio->bi_iter.bi_sector < conf->reshape_safe &&
-- 
2.43.5


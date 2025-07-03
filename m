Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0455F22B8AB
	for <linux-raid@vger.kernel.org>; Thu,  3 Jul 2025 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556192; cv=none; b=QYbMi1A3Fw2sISfDYljfKkZQRaWMDabzDOOsbFCfgddCUBULx/SgQoVZX3WC/Z91zTZGfpzkN7lVyLlqZVb6rH2pgFWXnhdFAx56weF6Jm5uZfa2eGSam70z7qvpG0A0gzNLfxJ2jeBImxy7UKnki2SwhpF7dVphd46McWCF8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556192; c=relaxed/simple;
	bh=o++TI/D8RX3d9nnz6Fpw0EBNUsC+7MAq5UbM23z+J60=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=UOIroXPOBaFwwKW6MAgB8Fg1IPLX5cnGqYwTmNML4qJd/PjEiWuRmaS/InV5xf9IsaCkLXLSrzXIVrsQqsEpeZJ6nHzkg68C9EWN6pMBzrSCcGs/OMJ7rsBQq2vDoDMKbBMVd+vwwb0SJcMcP5WWyQNyokz1GQ0O/N2Y7y7qIWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GMP8MKne; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GMP8MKne"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751556190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+UKfu2MJiv5vss/7PzAacT2r/jLEOpOBR3G6Yi0mwYM=;
	b=GMP8MKnemfxTpmc5SoRyqEfRgXqChMCka0VCgoWKTewy+THvxNgmEywOf2oisarqt9FrZK
	W9WoLz2LXb4AULP6vJIQ+/pOrhOyTr5nMojnyBRF9BAv0u/EaSQOdPJZhwJbgAyk5QumUs
	jaC2UZTtiGHmfRmVCbG8oqZjplJEDMU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-JR6dCeC4MaiSwGXTV4CL5w-1; Thu, 03 Jul 2025 11:23:06 -0400
X-MC-Unique: JR6dCeC4MaiSwGXTV4CL5w-1
X-Mimecast-MFC-AGG-ID: JR6dCeC4MaiSwGXTV4CL5w_1751556186
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7d45e0dbee2so837181285a.3
        for <linux-raid@vger.kernel.org>; Thu, 03 Jul 2025 08:23:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751556186; x=1752160986;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+UKfu2MJiv5vss/7PzAacT2r/jLEOpOBR3G6Yi0mwYM=;
        b=XmdfkwlQzxmtLySCX5tlEy71GF1s+AEcqWLC4ImAnLeAq/ne/BerzvbDLA/KymZZt5
         hA5GTBM96rzC6nPujagYthQMQCJhfWDwhMEGX2qEVV9Gs7z+B7kEZM5mqTYxkkDicI/N
         Rk2OnNFmTirSn/vp2y45nX8KL3kAs9NWGe1Y3L48MOXYspO81fR93g3Y7tg0K+Hi5IPe
         PVcuVT3VjeqBRMGfjU1JcCCff3oD/UG6m5tf6Hvvt9Li3DY1BDZK438B93UQT/CRR40e
         Et3BeUa+KgjpGl2/XSILzqDSrlXTCb1ZUHISCBxiSBbnAG/6U8WkAO3MsgFIWNKxdouH
         agFg==
X-Forwarded-Encrypted: i=1; AJvYcCV+7Y6ctII3mC59b6luUTRKWvKobMW5II5aaCHXTwLcuvPIy8qrQbEZ2xDzTYiJefK9vsjXzGB4hCPF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8tDWtlwb1O/h0iofbFIkn0KF3zC1ep8ix4hLJ5+a2BpkrJ7E6
	7Ojrn9jvhJs/5+Vfwgq3+NIAHVVJgRDEmucpnJioEpdTpHtjR++37nyvbahTR6rryU4cU13/QHA
	BYz01M0RaZTtmYjE6BGqK73A4nfExIi5IpQv5gfbm4Igq98Vs7/HhUJYZUNcK34M=
X-Gm-Gg: ASbGncsLCZgMs3IEbDpZ0Gv/n1g0m30+DHTm3b4mLBxfMHCnEkLQRdxpfH6k060lJAC
	sUpLeG/Ooooui7TBoOyUWexEy3IlV/SFpWfHGRN+EyfGWGMYCWR7++CXAgNRZFcsEkW+gYCuQlk
	SVvm0Ojl1It9je2hoZq0F2XoJ6q1Rf8S1Pof6U2TY8Zc6N/3CVM/ve8hp+99AZhfCevXgEuJDM4
	5/jwQoF1kL5zswMXYn4Cl1m8wp20YCA4Wvb0O8CLiwY5Vn/L2lZcWlc25+d3AxJJT4ypXSKh5NL
	VkISmuUSvngI9m3NJeoKhiS7BMWZdk2f+upW
X-Received: by 2002:a05:620a:4486:b0:7d0:9847:ff06 with SMTP id af79cd13be357-7d5c47624b8mr1081821285a.57.1751556186083;
        Thu, 03 Jul 2025 08:23:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGIV7q4oR990ofrw8zC9AgsvrL2a2ymd72JLIBh8SGtjDZU9Z2mtB4GluoXRIvyrkyNcZSQvQ==
X-Received: by 2002:a05:620a:4486:b0:7d0:9847:ff06 with SMTP id af79cd13be357-7d5c47624b8mr1081814785a.57.1751556185577;
        Thu, 03 Jul 2025 08:23:05 -0700 (PDT)
Received: from [192.168.50.77] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d5dbe8f87fsm3223285a.80.2025.07.03.08.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 08:23:05 -0700 (PDT)
Message-ID: <c0787379-9caa-42f3-b5fc-369aed784400@redhat.com>
Date: Thu, 3 Jul 2025 11:23:04 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: yukuai1@huaweicloud.com, yukuai3@huawei.com, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH v4] raid10: cleanup memleak at raid10_make_request
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

V4: changing backing tree to see if CKI tests will pass.
The patch code has not changed between any versions.

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/raid10.c | 8 ++++++--
  1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 862b1fb71d86..4945e9e9a4a7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1186,8 +1186,10 @@ static void raid10_read_request(struct mddev 
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
@@ -1373,8 +1375,10 @@ static void raid10_write_request(struct mddev 
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


Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC8979D2
	for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 19:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751313121; cv=none; b=VIHZiVcDN5SyS8nLdVgFH9q+3UsQPY25aZEX1i5xKmYloTMEJ9NlezMhH+iINewAXkZmkCh/IOxqWndLYr6F9KM9lf9KW1jF6T/lprt97d1ZnVC594VV0mIPjLjHN2nbYbKYdh4kgC9ACf9TXqRftyCeYuSHqJNtsNFxEbZ0fJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751313121; c=relaxed/simple;
	bh=AOm8MtctcdM7MQlh5qQ5uLXAXnP3lS9FWKdH7Y5vJCw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=IGeoNu3YSRMWWD/56SrtnY7ynAezV1zR/hgqnYpIoXio+bIUMI7lInGxd7Tcie5xFN1nPLkTitmXTeJz1VjM47O6AVdJelF/NzQGhiNEd0X8Ld1H/M/cs2ThSRuc3KbkWMpIival321dBwgM/UjvMLkGpqeY97Ilx5lPUBtLgd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AZQEqJQ2; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AZQEqJQ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751313119;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OkdFWOGiwvKCAQoZEY7RCVB4vukiYzJQpwMqx28Veew=;
	b=AZQEqJQ2JnxvUjsrw/5qwq0+y1fFizSCeU6N17pEdoXB7sW5ntf+S75x8/NvB9naCqFka4
	xEzVbH/hEM10BwOAKkmfKTxVSoJ4lynKLgAM81A+W8jd9fIgM1/b1gLL6bELmncTUzIBe6
	9DfZ/mL2mc9/mUXHev4QP8rBUYK3PCs=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-282-6fQ93gKDPBO9b1ctb8Navw-1; Mon, 30 Jun 2025 15:51:57 -0400
X-MC-Unique: 6fQ93gKDPBO9b1ctb8Navw-1
X-Mimecast-MFC-AGG-ID: 6fQ93gKDPBO9b1ctb8Navw_1751313117
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-7d4133a2081so715087485a.3
        for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 12:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751313117; x=1751917917;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OkdFWOGiwvKCAQoZEY7RCVB4vukiYzJQpwMqx28Veew=;
        b=GS2nEMZRsBRSlIS8p0AG1uU1jgeKAK9z79V1RZJn5se1MFeizZJhx20dqwcgFeDMyO
         x5LbahStXpQixv5O79hdOGCvdKRqxI/9jNOQEV4WkqGZTvtZ1l7fjnwWpFN/GzPGbHu9
         tFA2GnaEpLbHu3NYozOV1G+onx36aCjwsBx8DfoU7VkXGXTpBmSQsdP6SaIJdj3BcHnr
         Eo0TK8IxUyve62xOnqsozsIVPiThtF9QAU+g2MIhNrKuESSL+V4mpFL7w914qKWoftPj
         9pYO5u1VDhZ5h9ByJqdvk8V5z17h37rRvRwDhLWIe6oczSc+nFD/MXjSYCwJf2GtrEqb
         baww==
X-Forwarded-Encrypted: i=1; AJvYcCVORJJ6KMIsUnQYYnv2JhdMMNJBEbw64WH6PqYe+9RugWxeOgOVwTR/8EfQ3BUVT7o/SEar6sejvhOh@vger.kernel.org
X-Gm-Message-State: AOJu0YyrkQSy+2yCKB87SN/QBkjo2+RDH7lAVEnHY92sE1uiIvWK74MK
	z5QdD/XVVsTH85CZGOte7suXgihVSsC4lPb5hUZw+kOuSoqmWV1iafSWN/uKIpROba6LrdbMtEl
	UNUXEHBYEpShMd6scanv+CfWfaOxFRlVOPqBSm4G8hy2Xuh+ViQ8ZuxQGCmU7gQZnP1/1U+M=
X-Gm-Gg: ASbGnctNmvlUnN9SFhZG4HbaSGYS9kXHdPM6rHHCV+zCTHBKVNzGLk+scNiuIZPKt3B
	ZC6lA8CyzUP5ApEMHD1+/1VaSid7FxFH4U+OoK2pE/yxsyFclADGB8xHEEpJhActqwhwUqYNdEk
	iVPbBcRl7wnOEOo3cOonH/5xaPZ6jiDTXijVxQ+jLYrg3OTYfeWRr6aD1byGzHD2aNiabLrsXnE
	UhzSBbvA+B+hxSXRwDLwgVecfu+PhGQA9uDWDp2Qw+xD3gDEbvM8ws/WN0lZ3JNhha/MWC4PFx/
	IKXvT5sJtwyoVNpZjIdpfKkSJn4ScuEgTpoG
X-Received: by 2002:a05:620a:44d3:b0:7c5:50ab:de07 with SMTP id af79cd13be357-7d44392669amr1792896985a.21.1751313116847;
        Mon, 30 Jun 2025 12:51:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELjv7wJzujO0JObzt+Ptz9SUiS5/H/YWzcxUvm6sSt4Tx1m8Y2x8vsYhzfgcdlK6RBSAtCxA==
X-Received: by 2002:a05:620a:44d3:b0:7c5:50ab:de07 with SMTP id af79cd13be357-7d44392669amr1792894985a.21.1751313116530;
        Mon, 30 Jun 2025 12:51:56 -0700 (PDT)
Received: from [192.168.50.77] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7d443134f32sm656144985a.12.2025.06.30.12.51.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jun 2025 12:51:56 -0700 (PDT)
Message-ID: <ae2830d3-5f71-4c32-9259-9ce2f952cf3d@redhat.com>
Date: Mon, 30 Jun 2025 15:51:54 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 yukuai1@huaweicloud.com
From: Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH] raid10: cleanup memleak at raid10_make_request
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

Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
---
  drivers/md/raid10.c | 8 ++++++--
  1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.cl
index 975fba8bdf17..acedc0481f1d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1181,8 +1181,10 @@ static void raid10_read_request(struct mddev 
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
@@ -1369,8 +1371,10 @@ static void raid10_write_request(struct mddev 
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


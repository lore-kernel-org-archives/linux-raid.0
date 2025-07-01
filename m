Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DE71465A1
	for <linux-raid@vger.kernel.org>; Tue,  1 Jul 2025 21:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751406388; cv=none; b=iElX315l3skioc5u1RmAAlLgWenYsplrwlrYMCXqOpu84s3ei6TrFU64WIIB48SXj+jVOdmYi0EA6/GDz/WAqdEPSITu+ND8bf4TWODW5hnzdkBEh/fXFss0Ta15Ha+qhHYlcCCyOr4cSHb/y/UZGzsKFpKmvYePG8me2jYBk7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751406388; c=relaxed/simple;
	bh=5gF2Nn4tP4rU6k/rpJVGe4AvNBXJhxYoS/UC9Lf7KOY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Fzv4eHyd+g/3Q3jcHf4H11rWzmlUD60n0ztAj4asBi/hFwpqOswJywLhExfx5EBDvANVgRDiGDQ7UYbpwXwWKgPz5ukdAwTVmwGGM1+Vk6Vaf9XI28jP5jimFGvq+TDZu3ZJE7ZgNGvR0Hpgj8eDm4JDaxwwEhYhBNCsNlTFMnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IRBICKFp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IRBICKFp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751406385;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tXedwkq8JHWvIAgc4EwevuxUqAIe5gWG2b3WjlohBfg=;
	b=IRBICKFpOKeDTn38uvQ2GYC5gqAeNRRpyzKl9vCsK5oabBjurcScl1HJuzF3iVhRikydH7
	H9ttVe2bOhi5agWexLLQ7x0YPFzuXDS5QR4uOR0nhZ+7VCLqFnKSMSCvMH2xeT5rsBt1kS
	9X1NE2MSiEBbAbdjfy7VyrLyG1NVmHU=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-lWf2E-cKOgGBk7fhNRdasg-1; Tue, 01 Jul 2025 17:46:24 -0400
X-MC-Unique: lWf2E-cKOgGBk7fhNRdasg-1
X-Mimecast-MFC-AGG-ID: lWf2E-cKOgGBk7fhNRdasg_1751406384
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-6fb3466271fso109791726d6.0
        for <linux-raid@vger.kernel.org>; Tue, 01 Jul 2025 14:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751406384; x=1752011184;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tXedwkq8JHWvIAgc4EwevuxUqAIe5gWG2b3WjlohBfg=;
        b=WantszjU3wobZwdtvUxp7NqAAN1wmNIy99NgCQwunSANr6SH4u9SdbW1CxHU81BNnr
         mPgwdyWES1SOubRGNROIDRUtvSBeMaWBBIWbD+Z7XpEr8DVp9ffMGqKfl0c2pzKLfOTz
         Cy8bajcxzLdC1bICh83H+XUEZ6+Jr+SPj66zg+ti/i72kfqC3l51VsnZlhr6BWds+ReE
         DXNOlytN+ziUFa1LWbe7CUPORugatng85Hnk0ML4n2iJusze4EUHqk6Rrnl6Inwd3z7I
         RqT0qHaiGTu2nAG1iEEA5/8jlpEWPta+/7EgC7N3Rs+qS2JlIVwZIj41xH6x6idtaY2Y
         jFvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCWll7N5g9A7X2VbVSj1m/pWtohOCzGWyTi8isy8trgk8lvZiSHAExFx5hqs7Igqn2RYUD9kcJIZWC@vger.kernel.org
X-Gm-Message-State: AOJu0YwAzbbF0okLG1wnb3Hc28v71dQ0r9iVRWHjuaxeADAQpC9ld33P
	v1j4NF3v2EuDkqt4DJQM700p6/uP09gdpwCoTNp+MYFRSXUn2KdKHy0DUR3vXUIcYK/Seos6N4c
	WXoMl7qqSgkFH1Z4kSaryOThFAlkolKoheFhPFB2LdPI7RDnp41jxHDt1CDDoBKw=
X-Gm-Gg: ASbGnctMu1Kj+RDz6rzIIJWJ7UtaIuVnzenQhUg/zGKqLNZNBdEtw1vovuXcB8bnHY/
	MPDDW5DC4oQavfX0ttcf0+Cg5mMU2s/133tGG4byvkQrE/UWRo5wGtAiJNCg/V/GmDfzSwHYq6L
	+FUaNe4Yy2eQV8wj4AQjqo/75kTu5b0MDWrQojXQjPE5EVbYvvujir7bM+gfyVp6y9aIik9U4q8
	/hLzoiiblV2Cux/e4lZoRPsQml28TkwUNdfmwpichBjqB2BEvog6FD3XtHQhfGSdl+MbHls4PaP
	1pOD798lARE/bq6SS6+7/RmQWkVcsfPiaVBY
X-Received: by 2002:a05:6214:458c:b0:6fd:364f:a2db with SMTP id 6a1803df08f44-702b2003ce0mr2113476d6.9.1751406383745;
        Tue, 01 Jul 2025 14:46:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1ATJln46Sp3CfE+2WMk8ZMXhk7kKH7camB+wrH1pt5f/TxBDO2L0Nm6UQY7VfvGIBT1xP6A==
X-Received: by 2002:a05:6214:458c:b0:6fd:364f:a2db with SMTP id 6a1803df08f44-702b2003ce0mr2113196d6.9.1751406383253;
        Tue, 01 Jul 2025 14:46:23 -0700 (PDT)
Received: from [192.168.50.77] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6fd7718dd53sm90889616d6.16.2025.07.01.14.46.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 14:46:22 -0700 (PDT)
Message-ID: <b7a5e548-3d67-42bd-8328-04987f4fa9b2@redhat.com>
Date: Tue, 1 Jul 2025 17:46:21 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH v2] raid10: cleanup memleak at raid10_make_request
From: Nigel Croxon <ncroxon@redhat.com>
To: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
 yukuai1@huaweicloud.com
References: <ae2830d3-5f71-4c32-9259-9ce2f952cf3d@redhat.com>
Content-Language: en-US
In-Reply-To: <ae2830d3-5f71-4c32-9259-9ce2f952cf3d@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 6/30/25 3:51 PM, Nigel Croxon wrote:
> If raid10_read_request or raid10_write_request registers a new
> request and the REQ_NOWAIT flag is set, the code does not
> free the malloc from the mempool.
> 
> unreferenced object 0xffff8884802c3200 (size 192):
>    comm "fio", pid 9197, jiffies 4298078271
>    hex dump (first 32 bytes):
>      00 00 00 00 00 00 00 00 88 41 02 00 00 00 00 00  .........A......
>      08 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>    backtrace (crc c1a049a2):
>      __kmalloc+0x2bb/0x450
>      mempool_alloc+0x11b/0x320
>      raid10_make_request+0x19e/0x650 [raid10]
>      md_handle_request+0x3b3/0x9e0
>      __submit_bio+0x394/0x560
>      __submit_bio_noacct+0x145/0x530
>      submit_bio_noacct_nocheck+0x682/0x830
>      __blkdev_direct_IO_async+0x4dc/0x6b0
>      blkdev_read_iter+0x1e5/0x3b0
>      __io_read+0x230/0x1110
>      io_read+0x13/0x30
>      io_issue_sqe+0x134/0x1180
>      io_submit_sqes+0x48c/0xe90
>      __do_sys_io_uring_enter+0x574/0x8b0
>      do_syscall_64+0x5c/0xe0
>      entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>   drivers/md/raid10.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.cl
> index 975fba8bdf17..acedc0481f1d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1181,8 +1181,10 @@ static void raid10_read_request(struct mddev 
> *mddev, struct bio *bio,
>           }
>       }
> 
> -    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors))
> +    if (!regular_request_wait(mddev, conf, bio, r10_bio->sectors)) {
> +        raid_end_bio_io(r10_bio);
>           return;
> +    }
>       rdev = read_balance(conf, r10_bio, &max_sectors);
>       if (!rdev) {
>           if (err_rdev) {
> @@ -1369,8 +1371,10 @@ static void raid10_write_request(struct mddev 
> *mddev, struct bio *bio,
>       }
> 
>       sectors = r10_bio->sectors;
> -    if (!regular_request_wait(mddev, conf, bio, sectors))
> +    if (!regular_request_wait(mddev, conf, bio, sectors)) {
> +        raid_end_bio_io(r10_bio);
>           return;
> +    }
>       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
>           (mddev->reshape_backwards
>            ? (bio->bi_iter.bi_sector < conf->reshape_safe &&


V2 backed against the latest upstream.


[PATCH v2] raid10: cleanup memleak at raid10_make_request

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

V2: rebuild against latest upstream.

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


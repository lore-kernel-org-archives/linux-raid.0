Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7454315C
	for <linux-raid@vger.kernel.org>; Tue, 25 Feb 2025 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740497569; cv=none; b=CeKSyce6COMZl5x6b81aK7+W8wZh/nacIgKgMR3nBoDp7kib8bIz5DRiiXvpv43IPSccnzIVATLg4p5pDcaPfBnsD8julc4J7PMrSFhDrwfRjjvgPqskd/z8pt6ic6as9x4P6aJ0fqKgCOfDJu8bBKPVVQcEOOdnaW2cj+Km63I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740497569; c=relaxed/simple;
	bh=u4kXq7sq5pWqfCFK82SUO3vjU76SH2tPYIiwz8Nrigg=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=H79GBrNg+duFUprE3aB9sBrLQHTx+FJ25LqHIwIgow0eMNGUL1hOi2hW+6Nu4ZN4dh4zENI8Z4wYelHhbNQ0s3cVZ3PZIPvU9WQSkyzsq4M2niznBfr0t9ESe1hXj8Ne0Xrvj8QuXrGxdcqQnpvn4qg4liHGL0v9p8F9DilkL+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZLaeFF2B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZLaeFF2B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740497566;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=m5n+ioms33I3wSLaqKwBkCw1+vASSWpSVdbqlXXU+3I=;
	b=ZLaeFF2BKePGOHHMnChEthhXzs4XO0n14DUbKYGhhuFeQbpPyaBeCzp5/P62vbEVrOW07U
	sJwHfDqhqzRUtGumeqdOdGG+C2d9tq7dO2z3pv0Z9zBkw814DQPpKBRvGwmTz30eQNCyk9
	wtwuMy85kOZ+t/x/+XDRhK+ToD1zYUs=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-441-or9RsYnaNKCMroJwD2mY3Q-1; Tue, 25 Feb 2025 10:32:44 -0500
X-MC-Unique: or9RsYnaNKCMroJwD2mY3Q-1
X-Mimecast-MFC-AGG-ID: or9RsYnaNKCMroJwD2mY3Q_1740497564
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3f4165b5849so5776393b6e.2
        for <linux-raid@vger.kernel.org>; Tue, 25 Feb 2025 07:32:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740497562; x=1741102362;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=m5n+ioms33I3wSLaqKwBkCw1+vASSWpSVdbqlXXU+3I=;
        b=PQL1aeraRGGnRdN5zClRL7/aB84hMhEbMQifatnwnT+ZMC3a4czQEnL8/G5R3C0xPZ
         qeSqBfDVPc2Dg4MjpP3MvPlS5LDoFxOJuDgMm6lc/trrg5BrmIRccIuzeWl8wB9P6SKg
         AZIrdsYupb+DrTsXW5UzhO9lLJH3nZIkxG3DoxjBOov5BPKB65Q8JHp0LTEGchVQPxfc
         nIRH4IFqkAmCxfdYvxIHMYhsU3K02yNKzb7xtcEYzYzzEsnFLsY850f+BfBoIelWHkRy
         bVVUCPhSbU70La/v/c3TGN4l0Sk8JhAFwP9XjPyFc0N7NFD+ZhS043dcH1Vbmixi49D0
         eOHQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlanfW7qb6XxN7FOdC2qYrCVhhLJFlVc4sNOJdw1m8Bu3/9SQmzNYk8z9/n/SG/esqcMAZPXCV6CGo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8p9fuprHpl4UxR8Y00wc0XWVIIIB84X/V6qze3bD/iZwzE8zS
	N+Aba9QxXu4coW+TQwU/xqucZs2IPehMn27d2yHSjl1vZLrnv9eUl2APQylqlv16O6d/1hOmJGG
	ykjLJ0FoN58CFKMHzOoy6L+TvtEy4BMIkPaEeU/3pZxSme7ybLjd6QZ/40D9Qd9CU+PA=
X-Gm-Gg: ASbGncvPExNrEmYskq0Lrip6qzBWK3RU/rF2DLjuszBjTq8TkjunsdM9ldchhKYqaWX
	cJIWAmLZwM5S4hHDxzTzTKgRnZTJBrev1mLJOsCFG/HZvpgL7SFnRCi6+NzHw+jDT1VWDi1iVCw
	Ai4vRvrmGOda21DeaWboQpe6USnBR73+nIbouGw4NiZ6L17Mb30IPgpkFsGKvAq5BXsgLqKSMYX
	Uc9R2nFtNO3t/sjeq0iBHG4lM1n55VtR1AJbFkpXneZnbGnCHIvil0oeJqdf+HLMNEyC2nBzUCI
	j4RCcqIfLec7PNUv3fCwaaXM7LSY3EI=
X-Received: by 2002:a05:6808:3442:b0:3f4:a91:2524 with SMTP id 5614622812f47-3f4247a1569mr13540017b6e.35.1740497562248;
        Tue, 25 Feb 2025 07:32:42 -0800 (PST)
X-Google-Smtp-Source: AGHT+IED4xK11TbYSXtWVQkknlCHWnHg24sHqMZEAswwBuOAHCkdqdpSXp5lIwFS43LC/K65R19HOg==
X-Received: by 2002:a05:6808:3442:b0:3f4:a91:2524 with SMTP id 5614622812f47-3f4247a1569mr13539951b6e.35.1740497561326;
        Tue, 25 Feb 2025 07:32:41 -0800 (PST)
Received: from [192.168.50.192] ([23.160.248.161])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f541c5bce1sm328417b6e.46.2025.02.25.07.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2025 07:32:40 -0800 (PST)
Message-ID: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com>
Date: Tue, 25 Feb 2025 10:32:38 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: yukuai3@huawei.com, yukuai1@huaweicloud.com, linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>
From: Nigel Croxon <ncroxon@redhat.com>
Subject: md bitmap writes random memory over disks' bitmap sectors
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On a aarch64 system with an md device using a bitmap, the system would 
crash when using nvme-tcp, logging


usercopy: Kernel memory exposure attempt detected from SLUB object 
'kmalloc-512' (offset 440, size 24576)!

crash> bt
PID: 28       TASK: ffff1c9882038700  CPU: 2    COMMAND: "kworker/2:0H"
  #0 [ffff800009d4f4d0] machine_kexec at ffffdf7f6bb20b94
  #1 [ffff800009d4f530] __crash_kexec at ffffdf7f6bc597a4
  #2 [ffff800009d4f6c0] crash_kexec at ffffdf7f6bc598c0
  #3 [ffff800009d4f6f0] die at ffffdf7f6bb0ec60
  #4 [ffff800009d4f7a0] bug_handler at ffffdf7f6bb0f0dc
  #5 [ffff800009d4f7c0] bug_handler at ffffdf7f6bb0f13c
  #6 [ffff800009d4f7e0] call_break_hook at ffffdf7f6bb06838
  #7 [ffff800009d4f800] brk_handler at ffffdf7f6bb06d54
  #8 [ffff800009d4f820] do_debug_exception at ffffdf7f6bb23690
  #9 [ffff800009d4f870] el1_dbg at ffffdf7f6c5b60b0
#10 [ffff800009d4f8a0] el1h_64_sync_handler at ffffdf7f6c5b6328
#11 [ffff800009d4f9e0] el1h_64_sync at ffffdf7f6bb0233c
#12 [ffff800009d4fa00] usercopy_abort at ffffdf7f6be2a158
#13 [ffff800009d4fa40] __check_heap_object at ffffdf7f6bdf8b84
#14 [ffff800009d4fa70] __check_object_size at ffffdf7f6be2a034
#15 [ffff800009d4fab0] simple_copy_to_iter at ffffdf7f6c3a93ec
#16 [ffff800009d4fae0] __skb_datagram_iter at ffffdf7f6c3a9168
#17 [ffff800009d4fb60] skb_copy_datagram_iter at ffffdf7f6c3a9334
#18 [ffff800009d4fba0] tcp_recvmsg at ffffdf7f6c484b90
#19 [ffff800009d4fc90] inet_recvmsg at ffffdf7f6c4bb1a8
#20 [ffff800009d4fce0] sock_recvmsg at ffffdf7f6c393270
#21 [ffff800009d4fd10] nvmet_tcp_io_work at ffffdf7f16412248 [nvmet_tcp]
#22 [ffff800009d4fdc0] process_one_work at ffffdf7f6bb9a1c4
#23 [ffff800009d4fe10] worker_thread at ffffdf7f6bb9a584
#24 [ffff800009d4fe70] kthread at ffffdf7f6bba3fbc

The system tried to access the memory for page ffffffe726027980, which 
was a kmalloc-512 slab, and the area accessed was on contained in a 
single, valid slab object.

Tracking the origin of this page, the sk_buff was pointing to the page 
before, but using offsets so large it used the problem page 
ffffffe726027980, even with aarch64 using 64kB pages.

crash> struct sk_buff.head,end ffff1c9885e4e8c0 -x
   head = 0xffff1c99635a9000 
"\250\363\204\225\230\034\377\377\b\220Zc\231\034\377\377\b\220Zc\231\034\377\377\030\254\362\217\230\034\377\377",
   end = 0x2c0,

crash> struct skb_shared_info.nr_frags,frags 0xffff1c99635a92c0
   nr_frags = 1 '\001',
   frags = {{
       page = {
         p = 0xffffffe726027940
       },
       page_offset = 73656,
       size = 24576
     }, {
       page = {
         p = 0xffffffe72603f600
...

Tracking the page usage back, md sent the leading page in a bio with a 
size in the bio_vec equal to 2 pages.

crash> struct bio ffff1c9895707100
struct bio {
   bi_next = 0x0,
   bi_disk = 0xffff1c9899052000,
   bi_opf = 133121,
   bi_flags = 3072,
   bi_ioprio = 0,
   bi_write_hint = 0,
   bi_status = 0 '\000',
   bi_partno = 0 '\000',
   bi_phys_segments = 0,
   bi_seg_front_size = 0,
   bi_seg_back_size = 0,
   bi_iter = {
     bi_sector = 16,
     bi_size = 131072,
     bi_idx = 0,
     bi_bvec_done = 0,
     rh_bi_reserved = 0
   },
   __bi_remaining = {
     counter = 1
   },
   bi_end_io = 0xffffdf7f6c2e8710 <super_written>,
   bi_private = 0xffff1c98915cf600,
   bi_blkg = 0xffff1c989e235800,
   bi_issue = {
     value = 576469020341855351
   },
   {
     bi_integrity = 0x0
   },
   bi_vcnt = 1,
   bi_max_vecs = 4,
   __bi_cnt = {
     counter = 1
   },
   bi_io_vec = 0xffff1c98957071a0,
   bi_pool = 0xffff1c9898474650,
   {
     bi_iocost_cost = 0,
     rh_kabi_hidden_241 = {
       rh_reserved1 = 0
     },
     {<No data fields>}
   },
   rh_reserved2 = 0,
   rh_reserved3 = 0,
   bi_inline_vecs = 0xffff1c98957071a0
}

crash> bio_vec 0xffff1c98957071a0
struct bio_vec {
   bv_page = 0xffffffe726027940,
   bv_len = 131072,
   bv_offset = 0
}

This bio struct was writing super block data for an md device, and used 
the size of the device's io_opt value in the bio_vec instead of a valid 
page size:

crash> p ((struct request_queue *)0xffff1c9896ed34f8)->limits.io_opt
$1 = 131072

Mapping this bio back to the origin md device and its bitmap configuration:

crash> struct md_rdev.mddev 0xffff1c98915cf600
   mddev = 0xffff1c9898474000,

crash> struct mddev.bitmap 0xffff1c9898474000
   bitmap = 0xffff1c9969902400,

We find an md bitmap configured with 1 page, with only part of the page 
used:

crash> struct bitmap.storage 0xffff1c9969902400
   storage = {
     file = 0x0,
     sb_page = 0xffffffe726027940,
     filemap = 0xffff1c9895bd6b00,
     filemap_attr = 0xffff1c9895bd3300,
     file_pages = 1,
     bytes = 13064
   },

This looks to be a rhel8 variation of bugs fixed in RHEL9 with backports 
like RHEL-75639. However, the patch used to fix this issue in RHEL9 
appears flawed and still contains part of the same flaws and only works 
sanely when the bitmap is contained in a single page.

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0a2d37eb38ef..08232d8dc815 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -227,6 +227,8 @@ static int __write_sb_page(struct md_rdev *rdev, 
struct bitmap *bitmap,
         struct block_device *bdev;
         struct mddev *mddev = bitmap->mddev;
         struct bitmap_storage *store = &bitmap->storage;
+       unsigned int bitmap_limit = (bitmap->storage.file_pages - 
pg_index) <<
+               PAGE_SHIFT;
         loff_t sboff, offset = mddev->bitmap_info.offset;
         sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
         unsigned int size = PAGE_SIZE;
@@ -269,11 +271,9 @@ static int __write_sb_page(struct md_rdev *rdev, 
struct bitmap *bitmap,
                 if (size == 0)
                         /* bitmap runs in to data */
                         return -EINVAL;
-       } else {
-               /* DATA METADATA BITMAP - no problems */
         }

-       md_super_write(mddev, rdev, sboff + ps, (int) size, page);
+       md_super_write(mddev, rdev, sboff + ps, (int)min(size, 
bitmap_limit), page);
         return 0;

This patch still will attempt to send writes greater than a page using 
only a single page pointer for multi-page bitmaps. The bitmap uses an 
array (the filemap) of pages when the bitmap cannot fit in a single 
page. These pages are allocated separately and not guaranteed to be 
contiguous. So this patch will keep writes in a multi-page bitmap from 
trashing data beyond the bitmap, but can create writes which corrupt 
other parts of the bitmap with random memory.

The opt using logic in this function is fundamentally flawed as 
__write_sb_page should never send a write bigger than a page at a time. 
It would need to use a new interface which can build multi-page bio and 
not md_super_write() if it wanted to send multi-page I/Os.


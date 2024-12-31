Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4111136E;
	Tue, 31 Dec 2024 03:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735616858; cv=none; b=f52sLrmSSgv17pv3gnsHfm4TM0Wtux0vwDwBuXtQmgVvsDv+L4AbxBSfL6WDOfG2JJFKlpzYWdC6Os/fkxGr+WO2dLId9h3oiLorFaXpoiO4wslLYhNuzROanfMCmUfEK4G9GLnwnvddcjTngCn5pZO3ctPBkc5b9CulzxyMx5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735616858; c=relaxed/simple;
	bh=Jreyil6JN/uVwfhqC6FI7+cPYgO1TyTH0SYTyuNTeRs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gu418VveIUbW+OzoORafYOjAM1UWjmFGX/EsJORadKXnQsHwtVeZlxP5QCoen96QE9A7J1kzUQfvs1X5Qw83ew9Lex4eY9UxSDNqL0G4OXIikHfIATHck/s3akOd0b/ue+BElg3PZxsvmS8cHBnLriVajpUz2Tn13MM0AMLyBmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YMf6d5klnz4f3jJL;
	Tue, 31 Dec 2024 11:47:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B17571A1030;
	Tue, 31 Dec 2024 11:47:25 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4dMaXNnohx7GA--.26060S3;
	Tue, 31 Dec 2024 11:47:25 +0800 (CST)
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ebbec264-7669-03fd-7ffd-3c728168cdd5@huaweicloud.com>
Date: Tue, 31 Dec 2024 11:47:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4dMaXNnohx7GA--.26060S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JFy3WFW7Aw4DKrWxAFy7KFg_yoWxWr4fpF
	42qr1fKws8AFZxWr1xWw18Ka45Jws3AasxKry8G345CFy5KryfAw1kWF9Yq34kXrZxAr1k
	Za15Wr98uayqvrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU80fO7
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/12/31 11:09, Tomas Mudrunka Ð´µÀ:
> When working on software that manages MD RAID disks from
> userspace. Currently provided headers only contain MD superblock.
> That is not enough to fully populate MD RAID metadata.
> Therefore this patch adds bitmap superblock as well.
> 

Thanks for the patch, however, Why do you want to directly manipulate
the metadata instead of using mdadm? You must first provide an
explanation to convince us that what you're doing makes sense, and
it's best to show your work.

Thanks,
Kuai

> Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
> ---
>   drivers/md/md-bitmap.h         | 42 +-------------------------------
>   include/uapi/linux/raid/md_p.h | 44 +++++++++++++++++++++++++++++++++-
>   2 files changed, 44 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 662e6fc14..6050d422b 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -7,7 +7,7 @@
>   #ifndef BITMAP_H
>   #define BITMAP_H 1
>   
> -#define BITMAP_MAGIC 0x6d746962
> +#include <linux/raid/md_p.h>
>   
>   typedef __u16 bitmap_counter_t;
>   #define COUNTER_BITS 16
> @@ -18,46 +18,6 @@ typedef __u16 bitmap_counter_t;
>   #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
>   #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
>   
> -/* use these for bitmap->flags and bitmap->sb->state bit-fields */
> -enum bitmap_state {
> -	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
> -	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
> -	BITMAP_HOSTENDIAN  =15,
> -};
> -
> -/* the superblock at the front of the bitmap file -- little endian */
> -typedef struct bitmap_super_s {
> -	__le32 magic;        /*  0  BITMAP_MAGIC */
> -	__le32 version;      /*  4  the bitmap major for now, could change... */
> -	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
> -	__le64 events;       /* 24  event counter for the bitmap (1)*/
> -	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
> -	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
> -	__le32 state;        /* 48  bitmap state information */
> -	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
> -	__le32 daemon_sleep; /* 56  seconds between disk flushes */
> -	__le32 write_behind; /* 60  number of outstanding write-behind writes */
> -	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
> -				  * reserved for the bitmap. */
> -	__le32 nodes;        /* 68 the maximum number of nodes in cluster. */
> -	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
> -	__u8  pad[256 - 136]; /* set to zero */
> -} bitmap_super_t;
> -
> -/* notes:
> - * (1) This event counter is updated before the eventcounter in the md superblock
> - *    When a bitmap is loaded, it is only accepted if this event counter is equal
> - *    to, or one greater than, the event counter in the superblock.
> - * (2) This event counter is updated when the other one is *if*and*only*if* the
> - *    array is not degraded.  As bits are not cleared when the array is degraded,
> - *    this represents the last time that any bits were cleared.
> - *    If a device is being added that has an event count with this value or
> - *    higher, it is accepted as conforming to the bitmap.
> - * (3)This is the number of sectors represented by the bitmap, and is the range that
> - *    resync happens across.  For raid1 and raid5/6 it is the size of individual
> - *    devices.  For raid10 it is the size of the array.
> - */
> -
>   struct md_bitmap_stats {
>   	u64		events_cleared;
>   	int		behind_writes;
> diff --git a/include/uapi/linux/raid/md_p.h b/include/uapi/linux/raid/md_p.h
> index 5a43c23f5..8131e7713 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>   /*
>      md_p.h : physical layout of Linux RAID devices
> -          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
> +          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman, Peter T. Breuer
>   
>      This program is free software; you can redistribute it and/or modify
>      it under the terms of the GNU General Public License as published by
> @@ -426,4 +426,46 @@ struct ppl_header {
>   	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
>   } __attribute__ ((__packed__));
>   
> +#define BITMAP_MAGIC 0x6d746962
> +
> +/* use these for bitmap->flags and bitmap->sb->state bit-fields */
> +enum bitmap_state {
> +	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
> +	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
> +	BITMAP_HOSTENDIAN  =15,
> +};
> +
> +/* the superblock at the front of the bitmap file -- little endian */
> +typedef struct bitmap_super_s {
> +	__le32 magic;        /*  0  BITMAP_MAGIC */
> +	__le32 version;      /*  4  the bitmap major for now, could change... */
> +	__u8  uuid[16];      /*  8  128 bit uuid - must match md device uuid */
> +	__le64 events;       /* 24  event counter for the bitmap (1)*/
> +	__le64 events_cleared;/*32  event counter when last bit cleared (2) */
> +	__le64 sync_size;    /* 40  the size of the md device's sync range(3) */
> +	__le32 state;        /* 48  bitmap state information */
> +	__le32 chunksize;    /* 52  the bitmap chunk size in bytes */
> +	__le32 daemon_sleep; /* 56  seconds between disk flushes */
> +	__le32 write_behind; /* 60  number of outstanding write-behind writes */
> +	__le32 sectors_reserved; /* 64 number of 512-byte sectors that are
> +				  * reserved for the bitmap. */
> +	__le32 nodes;        /* 68 the maximum number of nodes in cluster. */
> +	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
> +	__u8  pad[256 - 136]; /* set to zero */
> +} bitmap_super_t;
> +
> +/* notes:
> + * (1) This event counter is updated before the eventcounter in the md superblock
> + *    When a bitmap is loaded, it is only accepted if this event counter is equal
> + *    to, or one greater than, the event counter in the superblock.
> + * (2) This event counter is updated when the other one is *if*and*only*if* the
> + *    array is not degraded.  As bits are not cleared when the array is degraded,
> + *    this represents the last time that any bits were cleared.
> + *    If a device is being added that has an event count with this value or
> + *    higher, it is accepted as conforming to the bitmap.
> + * (3)This is the number of sectors represented by the bitmap, and is the range that
> + *    resync happens across.  For raid1 and raid5/6 it is the size of individual
> + *    devices.  For raid10 it is the size of the array.
> + */
> +
>   #endif
> 


Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32054C9F;
	Tue, 18 Feb 2025 02:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739845987; cv=none; b=hu8dibaPXq/DTg1oD4qCcPqZ5NiXZsdQBBT5RmSc5V0x8wkUazgL+hpi5T9pPPsDO+beKkfl4E5pD0hP4n2POicwWNvArlzT9MpCcrWceX3t5ZwpwMp+7hLoD98ws9lsEPio7TXroJ6XJ2WvjT2TewYc8u+r5vT9fvxvixf9jC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739845987; c=relaxed/simple;
	bh=kVFDQLrwBz6/w4jbcFWfuXnpbej/CPofQc4TeZhDOF4=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=m9DmB/oKuSOVJHjCOEJ2wq96+Kj5TYcMRFgotYYMzzoEqSr3gIHB2mVYRnSw0MH0uDjRu/6Zd1enxhPAwX7mtKYP0NB+QiRCU4Atp68nvkZ8t2IcApEBYKgIDfsc421Vqmi+2PGVtwmDtJuu7hYr40TsVlrjGu2wAtV66ibTpq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Yxk550fyjz22vtY;
	Tue, 18 Feb 2025 10:30:01 +0800 (CST)
Received: from kwepemk500007.china.huawei.com (unknown [7.202.194.92])
	by mail.maildlp.com (Postfix) with ESMTPS id 0752B1400DD;
	Tue, 18 Feb 2025 10:33:00 +0800 (CST)
Received: from [10.174.179.143] (10.174.179.143) by
 kwepemk500007.china.huawei.com (7.202.194.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 18 Feb 2025 10:32:59 +0800
Subject: Re: [PATCH v3] Export MDRAID bitmap on disk structure in UAPI header
 file
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<song@kernel.org>, Mariusz Tkaczyk <mtkaczyk@kernel.org>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
 <20250206223005.1759192-1-tomas.mudrunka@gmail.com>
From: Yu Kuai <yukuai3@huawei.com>
Message-ID: <bead708f-b901-18df-f461-c5324fbe2555@huawei.com>
Date: Tue, 18 Feb 2025 10:32:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250206223005.1759192-1-tomas.mudrunka@gmail.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemk500007.china.huawei.com (7.202.194.92)

Hi, Tomas

ÔÚ 2025/02/07 6:30, Tomas Mudrunka Ð´µÀ:
> When working on software that manages MD RAID disks from
> userspace. Currently provided headers only contain MD superblock.
> That is not enough to fully populate MD RAID metadata.
> Therefore this patch adds bitmap superblock as well.
> 
> Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
> ---

Can you fix the checkpatch warning and send a new version?

Thanks,
Kuai

> V1 -> V2: Also exported stuff needed by mdadm according to Mariusz Tkaczyk
> V2 -> V3: Fixed checkpatch errors
> 
>   drivers/md/md-bitmap.c         |  9 ------
>   drivers/md/md-bitmap.h         | 42 +--------------------------
>   include/uapi/linux/raid/md_p.h | 53 +++++++++++++++++++++++++++++++++-
>   3 files changed, 53 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index ec4ecd96e..247610f9a 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -32,15 +32,6 @@
>   #include "md.h"
>   #include "md-bitmap.h"
>   
> -#define BITMAP_MAJOR_LO 3
> -/* version 4 insists the bitmap is in little-endian order
> - * with version 3, it is host-endian which is non-portable
> - * Version 5 is currently set only for clustered devices
> - */
> -#define BITMAP_MAJOR_HI 4
> -#define BITMAP_MAJOR_CLUSTERED 5
> -#define	BITMAP_MAJOR_HOSTENDIAN 3
> -
>   /*
>    * in-memory bitmap:
>    *
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 31c93019c..75bbe6b84 100644
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
> index ff47b6f0b..2995528f9 100644
> --- a/include/uapi/linux/raid/md_p.h
> +++ b/include/uapi/linux/raid/md_p.h
> @@ -1,7 +1,7 @@
>   /* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
>   /*
>      md_p.h : physical layout of Linux RAID devices
> -          Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman
> +	Copyright (C) 1996-98 Ingo Molnar, Gadi Oxman, Peter T. Breuer
>   
>      This program is free software; you can redistribute it and/or modify
>      it under the terms of the GNU General Public License as published by
> @@ -426,4 +426,55 @@ struct ppl_header {
>   	struct ppl_header_entry entries[PPL_HDR_MAX_ENTRIES];
>   } __attribute__ ((__packed__));
>   
> +#define MD_BITMAP_SUBERBLOCK_EXPORTED 1	/* Notify that kernel provides it */
> +#define BITMAP_MAGIC 0x6d746962		/* This is actually "bitm" in ASCII :-) */
> +#define BITMAP_MAJOR_LO 3
> +/* version 4 insists the bitmap is in little-endian order
> + * with version 3, it is host-endian which is non-portable
> + */
> +#define BITMAP_MAJOR_HI 4
> +#define BITMAP_MAJOR_CLUSTERED 5
> +#define BITMAP_MAJOR_HOSTENDIAN 3
> +
> +/* use these for bitmap->flags and bitmap->sb->state bit-fields */
> +enum bitmap_state {
> +	BITMAP_STALE	   = 1,  /* the bitmap file is out of date or had -EIO */
> +	BITMAP_WRITE_ERROR = 2, /* A write error has occurred */
> +	BITMAP_HOSTENDIAN  = 15,
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
> +				  * reserved for the bitmap.
> +				  */
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

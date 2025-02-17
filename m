Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2901F1802DD
	for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787633; cv=none; b=Pj8YK3ZNJ+XKCZWzgsDatxIlgOXtxlIv9eOqQr9iQzOK0fO0MUUZeVWnuGus1+hcn6SdwQG8sY1yTp5EMCiUKBy/jOA8ASEUWMMmi0keYAfJZOHI/b9OdzZiFMzUQlLnEQA+psyz1Ilxs5Oa2rMmK4CFfDrzI03oavf10l4v4EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787633; c=relaxed/simple;
	bh=Ni8XhWFL3JofyQtJuW4RPnrReMge+P3PaWcygEu16Ig=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=k57/Bc+Zb8PYJROjPLSYFKoR+jD0J65igmbSP/FolyWO1pbBlzYl04zEYPU8VODYi7tgL/jriA+PRsPg5sxTONUClL17SbyjYqmJhbX6cOGz/t2KnSheyll6Nw9gCnPz5d1sRNwLdID2DOHKPf8o3awObIB8fXcsJc7Z9ueZ4gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ki4cB+0V; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ki4cB+0V"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4396f579634so9313605e9.1
        for <linux-raid@vger.kernel.org>; Mon, 17 Feb 2025 02:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1739787629; x=1740392429; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6DTmgyKwXyxupGvGcbs4sr/KU+osTL6h5aaa2lsjPg=;
        b=Ki4cB+0VBMFa1ZOjWkEycQB/VzeiIsPaG6sRuoaLWD4bXM4WsKbbYRlMBBrHqEAi/Y
         IKXL22ekOc+nY2FlexSyPr4trtisG5GNJ569klNnS5AA3o4kLIW2z00/NGjWrXlI6ySJ
         60HcBsRYF95iqnEwGBV3M+mrxzziR7RagKynBjVNZdyZPuPwMsQTLexAalr8Bb41qZNR
         6ltt63Ol3I0dTXcsLUAIzmr4XByUNFawXvFYgU3vtClJIYjA8r+dcTleil22qVTmmlH9
         jHCrENqTk3HFSNKwWq3pacLckSkoX0lZxPQUvX66bYfAWitFlZmv2O6AJ8CeArlRXC4h
         GrBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739787629; x=1740392429;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L6DTmgyKwXyxupGvGcbs4sr/KU+osTL6h5aaa2lsjPg=;
        b=lnoHFYwfiV1ziAiA+TmDgUCL9wIw8YHlnUsIGCGPXZxAOQM2DODejE/lmKvX+Hr8Ks
         zq+igrVWQ9EEPRJ2ShqbU0NxZ4ZJqa2USdGy1HuN+N5IX7M59ED5y6WJRzc6xiXmX8D/
         U+0axUdtCoJaz3Vdc62Nqv3t+bTWTTYCzp5spWS3misnHA9nJGypxY9YgMo1QEekyeyA
         iOPV1aw08DPukJ2tULAB6jPo63WP5jetCpYoO49vaE4ThPmGtU/iGrt8/WVhEY0FYXH2
         /VABxGlifXSOfNsko6Z680wkpIPafqCUbJlbVaB/zev2gEKNjUljB670OtX3VsKMAk8u
         Xxvg==
X-Forwarded-Encrypted: i=1; AJvYcCWtkPNoQ48aDVY8qNOn4mmfzwRErZ0PjjBNa/aOT79qpV349GqwQPaXN4h9v4XfDdS0kMG7UqDzIfuH@vger.kernel.org
X-Gm-Message-State: AOJu0YzlhASgz33nfcW1EZ/Qd1IHDc7wLUtJeDwFhN/zlwjH/fCKJDfg
	Zgzap4FgXYPpMwT/Nv4kz8xs8/guBUvrq9nUqF9hTY1TBV1ZSBbsRv7s8K96bL0=
X-Gm-Gg: ASbGncucQyogfZwDqq/bvJbQZkYCvJv2lkG0BNDWjHiHJaHqD2wz9ych8Knm+QgWPPz
	WllmlpA2iR3mjUPFbKkVUCJA97ULM9GaRIqBBMlfRuWwI3n+Matu0ibv8mAxKf1VqELrsYHuQ9J
	UkAzRXXlXC8zuy0jEnDEMSRZFQzJtLxU7u0Le/gXo9zBAVuxSkF3BARS7ZHkg7cafzTK9BITwPt
	l7AZnDwdoF5OBqvXdYY+h17Iv5tZE/qd+9QZGPfRI9QQqjc8Q/0QLYy9mUx9E0/KFVYPT43tDzD
	MetAHgUZL/EV3NErAA==
X-Google-Smtp-Source: AGHT+IGviKjWNxy/sgElxSlyaT5/wAb+sw7oOQppRq5E3qnNTYAp1n89b2Fs/XnmQnd+QyM2KMyDaA==
X-Received: by 2002:a05:6000:1787:b0:38f:443b:48f4 with SMTP id ffacd0b85a97d-38f443b4aefmr2784345f8f.49.1739787629473;
        Mon, 17 Feb 2025 02:20:29 -0800 (PST)
Received: from smtpclient.apple ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c07c5f357dsm516160885a.23.2025.02.17.02.20.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2025 02:20:29 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH md-6.15 2/7] md: only include md-cluster.h if necessary
From: Glass Su <glass.su@suse.com>
In-Reply-To: <20250215092225.2427977-3-yukuai1@huaweicloud.com>
Date: Mon, 17 Feb 2025 18:20:11 +0800
Cc: song@kernel.org,
 yukuai3@huawei.com,
 linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <E136E905-430C-40B4-B69A-7FC9B8CF3C47@suse.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
 <20250215092225.2427977-3-yukuai1@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)



> On Feb 15, 2025, at 17:22, Yu Kuai <yukuai1@huaweicloud.com> wrote:
>=20
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> md-cluster is only supportted by raid1 and raid10, there is no need to
> include md-cluster.h for other personalities.
>=20
> Also move APIs that is only used in md-cluster.c from md.h to
> md-cluster.h.
>=20
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Su Yue <glass.su@suse.com>
> ---
> drivers/md/md-bitmap.c  | 2 ++
> drivers/md/md-cluster.h | 7 +++++++
> drivers/md/md.h         | 7 -------
> drivers/md/raid1.c      | 1 +
> drivers/md/raid10.c     | 1 +
> 5 files changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 23c09d22fcdb..71aa7dc80e26 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -29,8 +29,10 @@
> #include <linux/buffer_head.h>
> #include <linux/seq_file.h>
> #include <trace/events/block.h>
> +
> #include "md.h"
> #include "md-bitmap.h"
> +#include "md-cluster.h"
>=20
> #define BITMAP_MAJOR_LO 3
> /* version 4 insists the bitmap is in little-endian order
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 470bf18ffde5..6c7aad00f5da 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -35,4 +35,11 @@ struct md_cluster_operations {
> void (*update_size)(struct mddev *mddev, sector_t old_dev_sectors);
> };
>=20
> +extern int register_md_cluster_operations(const struct =
md_cluster_operations *ops,
> + struct module *module);
> +extern int unregister_md_cluster_operations(void);
> +extern int md_setup_cluster(struct mddev *mddev, int nodes);
> +extern void md_cluster_stop(struct mddev *mddev);
> +extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> +
> #endif /* _MD_CLUSTER_H */
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index def808064ad8..c9bc70e6d5b4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -19,7 +19,6 @@
> #include <linux/wait.h>
> #include <linux/workqueue.h>
> #include <trace/events/block.h>
> -#include "md-cluster.h"
>=20
> #define MaxSector (~(sector_t)0)
>=20
> @@ -845,11 +844,6 @@ static inline void safe_put_page(struct page *p)
>=20
> extern int register_md_personality(struct md_personality *p);
> extern int unregister_md_personality(struct md_personality *p);
> -extern int register_md_cluster_operations(const struct =
md_cluster_operations *ops,
> - struct module *module);
> -extern int unregister_md_cluster_operations(void);
> -extern int md_setup_cluster(struct mddev *mddev, int nodes);
> -extern void md_cluster_stop(struct mddev *mddev);
> extern struct md_thread *md_register_thread(
> void (*run)(struct md_thread *thread),
> struct mddev *mddev,
> @@ -906,7 +900,6 @@ extern void md_idle_sync_thread(struct mddev =
*mddev);
> extern void md_frozen_sync_thread(struct mddev *mddev);
> extern void md_unfrozen_sync_thread(struct mddev *mddev);
>=20
> -extern void md_reload_sb(struct mddev *mddev, int raid_disk);
> extern void md_update_sb(struct mddev *mddev, int force);
> extern void mddev_create_serial_pool(struct mddev *mddev, struct =
md_rdev *rdev);
> extern void mddev_destroy_serial_pool(struct mddev *mddev,
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9d57a88dbd26..e55db07e43d4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -36,6 +36,7 @@
> #include "md.h"
> #include "raid1.h"
> #include "md-bitmap.h"
> +#include "md-cluster.h"
>=20
> #define UNSUPPORTED_MDDEV_FLAGS \
> ((1L << MD_HAS_JOURNAL) | \
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index efe93b979167..3df39b2399b2 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -24,6 +24,7 @@
> #include "raid10.h"
> #include "raid0.h"
> #include "md-bitmap.h"
> +#include "md-cluster.h"
>=20
> /*
>  * RAID10 provides a combination of RAID0 and RAID1 functionality.
> --=20
> 2.39.2
>=20
>=20


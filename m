Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF4B2206B8
	for <linux-raid@vger.kernel.org>; Mon, 28 Jul 2025 05:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753681071; cv=none; b=SQtVO1mCg/ZigZkm7gQnVqUwHzIinGg2R8k7QcGmrPfjNyN+KtfO4si56aGtEYIzrSFSD6s3Qi7srV11wqFzoKBB5gcmSycxS5VcydhXM+F5/KcaDW23OiBVwcKuLfaKWkhpZE0Aafpwm44AqS0rrj/nPZNekNExKLGywpfHwaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753681071; c=relaxed/simple;
	bh=F6+QWuSBv4x0flC5kCOLgZCDZBDLrrJSNad59jJWIXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R2gOy+eVefjY/q8WLzEcmFpci/1K1wObwUyVupkSLEziRBm3joDciQbf/BreMhvvG9kxo04U+xWbiJ262j/oImm0hQlZxX2AL9G8WpPnifh179NcWC+/1tjwAbfcMNePqUPDqsXPv/5qPFitiRanphCfL4OCUXchZsQ/QbUkrHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AkbJbE3c; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AkbJbE3c"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753681068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A3ZcHukYN2mERp1bM6H5ADsDeN+lEekE5S6YNzRDaYg=;
	b=AkbJbE3c29U7fglk28WJpwF34hsrYQ7Rlv6+oiQFnY9nbf1aFOecoE6mstdm9kcicxusjw
	86cQMg6g8ij81PlOulY6QprQV68Y8ClSrNNdqcYZf5aDFhQ7lHI8P9teVlaMJWDqlIafsa
	BgFLP/F3MoGBiFrn+ePPMxo7rBy7uOI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-Q41XTu-GPE2zhho5VdAEyg-1; Mon, 28 Jul 2025 01:37:46 -0400
X-MC-Unique: Q41XTu-GPE2zhho5VdAEyg-1
X-Mimecast-MFC-AGG-ID: Q41XTu-GPE2zhho5VdAEyg_1753681065
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-553b70a3592so2215561e87.2
        for <linux-raid@vger.kernel.org>; Sun, 27 Jul 2025 22:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753681065; x=1754285865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A3ZcHukYN2mERp1bM6H5ADsDeN+lEekE5S6YNzRDaYg=;
        b=uWyQi+c6x78SnxUG/jj7GpWXioN0mIrrgoJfOQ+nKZJYza8sbzTjTzTkP//FPH6k8N
         soO1dLwcq308tuiE7I9IHans4rS6A9OwkLfTuXUASBLUTPZJir6ZcfN4XA2SA+41/qJm
         dEYasJV9no/jFOmyTPEhzyOBPb2ykWmbW4s3cwx0Sw5laA4YbfaM8iwb5kWAgUpsYBtz
         hkqFj7/334FdVFut8a5a8SzLZDD5sTRNXBCH7U06vcwVjshNs6quZrIECN07sxB3XsNM
         B9ioI72PIKZ9//TMr5bn38D/KzhMNZQkGDBaUucdUb8UociDhYhPBocWwuTABh7MvBLo
         uRZQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5DFWiA+7l+OvQVoUgU2LfVYHppmYwjIrUrTVnVB7xMgGFNmkQ17DrO6uf8LaA2jlWUeMKYZOObpjJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzFrKrXazogBm607tluoxHV7OkKc6ucbjwU9TJ5Sxuw+VN4qM6j
	swxr0GLz2u7ScH8rzj8rb2fI2gybeyBQikruwq1jWFcMLIyUUGFUtnqwPSleqJNUWcTC4LN923I
	c6EvvO0y+AQgoY1pkzRcwcD8OxnO0CyeZHy3D51y1FYELuSsZR4JHTaqSVTdKyVpAqPrpVu3ohG
	nMVKMzicIc9PG9qQJOAmm3PWmgizTkSwMSBA5mdw==
X-Gm-Gg: ASbGncuUWsIkrn4ObTU+57DPYVE4NkB9GwHrWgR6phj+pSXW8Pv4SAhf/pmUZwyCY6b
	Mi6Jw2F0TRmi9YJCmsWscqHGx7oLZtq/JK4khpl2maBRc13MmqDm4r8Hvd6Fy9iGSAkIF/64ozP
	yOHuFEn0XUBwlZRPOj2i1ktw==
X-Received: by 2002:a05:6512:3b27:b0:553:2311:e1f6 with SMTP id 2adb3069b0e04-55b5f5108e1mr2258757e87.49.1753681065129;
        Sun, 27 Jul 2025 22:37:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFI50RUEgVEsbUPURKdr+Af1xURU2ypwa5U8DXHcP3qcvjYhyT8ZEOIfYPgmUHjIs80WfcHSAg+EtTcDwffmoI=
X-Received: by 2002:a05:6512:3b27:b0:553:2311:e1f6 with SMTP id
 2adb3069b0e04-55b5f5108e1mr2258750e87.49.1753681064683; Sun, 27 Jul 2025
 22:37:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 28 Jul 2025 13:37:32 +0800
X-Gm-Features: Ac12FXySLN7PhCOHMXZw9NiWDQhg8QHeiGJTOKoWSPWjL40hTbHCR75P9KZGKo0
Message-ID: <CALTww2_nfqeoR+h6rLCtCvr3Gh-b-tqpDhg4QimaZcC9AbUsnA@mail.gmail.com>
Subject: Re: [PATCH v5 00/15] md/md-bitmap: introduce CONFIG_MD_BITMAP
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:36=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v5:
>  - rebase on the top of md-6.17;
>  - fix compile problem if md-mod is build as module;
>  - fix two problems for lvm2 dm-raid tests, patch 5,13
>  - other cleanups;
> Changes in v4:
>  - rebase on the top of other patchset;
> Changes in v3:
>  - update commit message.
> Changes in v2:
>  - don't export apis, and don't support build md-bitmap as module
>
> Due to known performance issues with md-bitmap and the unreasonable
> implementations like following:
>
>  - self-managed pages, bitmap_storage->filemap;
>  - self-managed IO submitting like filemap_write_page();
>  - global spin_lock
>  ...
>
> I have decided not to continue optimizing based on the current bitmap
> implementation, and plan to invent a new lock-less bitmap. And a new
> kconfig option is a good way for isolation.
>
> However, we still encourage anyone who wants to continue optimizing the
> current implementation
>
> Yu Kuai (15):
>   md/raid1: change r1conf->r1bio_pool to a pointer type
>   md/raid1: remove struct pool_info and related code
>   md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
>   md/md-bitmap: merge md_bitmap_group into bitmap_operations
>   md/md-bitmap: add a new parameter 'flush' to bitmap_ops->enabled
>   md/md-bitmap: add md_bitmap_registered/enabled() helper
>   md/md-bitmap: handle the case bitmap is not enabled before
>     start_sync()
>   md/md-bitmap: handle the case bitmap is not enabled before end_sync()
>   md/raid1: check bitmap before behind write
>   md/raid1: check before referencing mddev->bitmap_ops
>   md/raid10: check before referencing mddev->bitmap_ops
>   md/raid5: check before referencing mddev->bitmap_ops
>   md/dm-raid: check before referencing mddev->bitmap_ops
>   md: check before referencing mddev->bitmap_ops
>   md/md-bitmap: introduce CONFIG_MD_BITMAP
>
>  drivers/md/Kconfig      |  18 +++++
>  drivers/md/Makefile     |   3 +-
>  drivers/md/dm-raid.c    |  18 +++--
>  drivers/md/md-bitmap.c  |  74 +++++++++---------
>  drivers/md/md-bitmap.h  |  62 ++++++++++++++-
>  drivers/md/md-cluster.c |   2 +-
>  drivers/md/md.c         | 112 +++++++++++++++++++--------
>  drivers/md/md.h         |   4 +-
>  drivers/md/raid1-10.c   |   2 +-
>  drivers/md/raid1.c      | 163 +++++++++++++++++++---------------------
>  drivers/md/raid1.h      |  22 +-----
>  drivers/md/raid10.c     |  49 ++++++------
>  drivers/md/raid5.c      |  30 ++++----
>  13 files changed, 330 insertions(+), 229 deletions(-)
>
> --
> 2.39.2
>
>

The patch set looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>


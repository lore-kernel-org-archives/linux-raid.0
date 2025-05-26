Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63201A8401
	for <linux-raid@vger.kernel.org>; Mon, 26 May 2025 07:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748243099; cv=none; b=dO4BG3lOi9KrW6JPoAq8exDBvLNkrAZ+HOl8TOK6OwNRWTOYrhBU4k45s8mSgoGAwraCn8K23no1awa4UVa70WczyxWp3KpIfa+MuRmMdS8Wgg1rC0kL9GK4nfVJ7PCq9e/0J0GmirQn1riTG7YULXTE58PLgwYsDOp6W4ph6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748243099; c=relaxed/simple;
	bh=/KjtSwvPWJ1jRSl2ED9yyTGBt2MsUlLauotMZbELXeI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HAqsitB1moQN4dn1MIbE/+KCpTD3PiPralybTAaDL92/0S91/ZoO49tWKD9xlpWtULfvOmnMj3AlxWdve+ANZ22wqrCbBqFnWIwAlK1cx2xKZsLDs0VDUsBy3RG54No+MjFRDc0aQK0IT6pmAJzajhepMWb/ywM5YZ52QJHBuZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FD9xo7FY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FD9xo7FY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748243096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZsSqa4El9fWisOjdIZpyGfNCohIxqbRRIDaHJl1MAcg=;
	b=FD9xo7FYjbQWs8KFhU5o2GblViGKDzkP8bu71+9eNRCqNPNqnNhmjDMjtz3eR34kUvS7ru
	0xi0LnAsvzWsECF7pz1c37Ikrf6OY2HfJsHi5qqVblJSlxS/YfIBmE5HnLjm8gTg398AKu
	XcpGhELg+UPcDsWr7Axt5Qv9AbD5bCA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-T2cArqRwM-iiEue4MxbNFA-1; Mon, 26 May 2025 03:03:49 -0400
X-MC-Unique: T2cArqRwM-iiEue4MxbNFA-1
X-Mimecast-MFC-AGG-ID: T2cArqRwM-iiEue4MxbNFA_1748243028
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5532355ed2fso214762e87.1
        for <linux-raid@vger.kernel.org>; Mon, 26 May 2025 00:03:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748243028; x=1748847828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZsSqa4El9fWisOjdIZpyGfNCohIxqbRRIDaHJl1MAcg=;
        b=v50tVL1DoH+FxE8XIxwgE5ToPfI1RdOmgniiyZq7oebptmsjeA+O50IT1VAeC85zRK
         yBaUlUbkJNVFTk6GcHr4UyWR92L1dhQWLfoDVY2uWcX4pHR9Au6eD17NTDIP4wRBpazH
         +WU0CgV+FwH9xuisSIjQknabUxDXHcWuL/S3CE5IUE0OvUPx1A6kNVfK9xOMZW32kdgn
         Qw64lVC6R5uJkAmlu6qi+Q3KFEVETreAKzqtbbvCvBp+MpYAnYuTxE7W7/7DUDSlYtgv
         6hR6XvHVnnrZoqqTKt6Rjz3LeQ4wfPtfmCdEXH/kmt5fPYiO0QdLjXyaxAPRX5wydtVl
         Y/Fg==
X-Forwarded-Encrypted: i=1; AJvYcCXw8voKmVQTje7vxrp4AKcnjsmKDJgFE33Z7bK9ozwQd8tkKUR+y+/XjQ1owR9vdIFPMsZ/ho2aTVhU@vger.kernel.org
X-Gm-Message-State: AOJu0YxDJZE9bNepsPygYOhXzdX7WbmOkuDUD9CSVo+gwnjYu7qerHg/
	QvjKEzUA2RS+UMQZDHS+jMWcOYKbO9cVovLMUPeonHEcVLGtvnnwZ4WVHRIpVytV13BoCpdTwKr
	3FdPpSFdun/L6zBOVvxg+ONapm6fFOKiPAVL4DmkS/Fe12SWWYopaeOzjG9aW8LnujKjTzI30iB
	hWUkx6iH26sYW8gmgU2rK09dDPUn1LCvh3hp80pg==
X-Gm-Gg: ASbGncshk/yd/FxW4Mh6V7CH7vk0zgOqJHoo4x4yvaLdD60aemr1MhepKuU54df8koP
	PZUEWNtzLutBcLIeEk2VJpEQhfcUjllH+/qR+wbkEok+JAp8tomlt1bWAb7DtvAq/ZMyjow==
X-Received: by 2002:a05:6512:e81:b0:54a:c4af:29 with SMTP id 2adb3069b0e04-5521c9b49c3mr2194378e87.52.1748243027683;
        Mon, 26 May 2025 00:03:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiI1Yk6wtJQGChMVRuaINop3PCJafppboQa8n3wGOEjdM+iFjM89BfGUysLGx/bSchoPaUn/ub/pVQf6fAwJQ=
X-Received: by 2002:a05:6512:e81:b0:54a:c4af:29 with SMTP id
 2adb3069b0e04-5521c9b49c3mr2194360e87.52.1748243027250; Mon, 26 May 2025
 00:03:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-9-yukuai1@huaweicloud.com>
In-Reply-To: <20250524061320.370630-9-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 May 2025 15:03:33 +0800
X-Gm-Features: AX0GCFvwXVzrH9q1dPb-evKEBo6AYWl9O-76qs7DSfOVQGYh8gvgg_A7YC7NPKI
Message-ID: <CALTww2-bZ83SjNntJOmKmY8J8+8b2tE3JMTXbzcRr3K8yCj9xQ@mail.gmail.com>
Subject: Re: [PATCH 08/23] md/md-bitmap: add a new method skip_sync_blocks()
 in bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, yukuai3@huawei.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2025 at 2:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> This method is used to check if blocks can be skipped before calling
> into pers->sync_request(), llbiltmap will use this method to skip

type error: s/llbiltmap/llbitmap/g

> resync for unwritten/clean data blocks, and recovery/check/repair for
> unwritten data blocks;
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/md-bitmap.h | 1 +
>  drivers/md/md.c        | 7 +++++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 2b99ddef7a41..0de14d475ad3 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -98,6 +98,7 @@ struct bitmap_operations {
>         md_bitmap_fn *start_discard;
>         md_bitmap_fn *end_discard;
>
> +       sector_t (*skip_sync_blocks)(struct mddev *mddev, sector_t offset=
);
>         bool (*start_sync)(struct mddev *mddev, sector_t offset,
>                            sector_t *blocks, bool degraded);
>         void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *=
blocks);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index dc4b85f30e13..890c8da43b3b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9362,6 +9362,12 @@ void md_do_sync(struct md_thread *thread)
>                 if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>                         break;
>
> +               if (mddev->bitmap_ops && mddev->bitmap_ops->skip_sync_blo=
cks) {
> +                       sectors =3D mddev->bitmap_ops->skip_sync_blocks(m=
ddev, j);
> +                       if (sectors)
> +                               goto update;
> +               }
> +
>                 sectors =3D mddev->pers->sync_request(mddev, j, max_secto=
rs,
>                                                     &skipped);
>                 if (sectors =3D=3D 0) {
> @@ -9377,6 +9383,7 @@ void md_do_sync(struct md_thread *thread)
>                 if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>                         break;
>
> +update:
>                 j +=3D sectors;
>                 if (j > max_sectors)
>                         /* when skipping, extra large numbers can be retu=
rned. */
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>


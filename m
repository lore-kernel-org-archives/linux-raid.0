Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDAA3859F3
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 09:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763147; cv=pass; b=TsQNUVJWuf7ZXdCU/0ze2hzKMi3VCH0+w0ZT6k6B66iFxBp06zoc1RT4PRtLBenAYRCX9WqgkxIeRmyK7t416NtCCSqmH7EfOy0kCfToW80wREzUosL6tybYngBwi8bMSZdyIF13eMIdRuGGlVm4x90jEk8VckLgZ4lNrqIfEUI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763147; c=relaxed/simple;
	bh=Uz1C0T12Tse1ACUU71iged57euvqUW4PZLN4od/cxxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OozfKCyocRXgfGbjtsoN0zuxuaK+SWccYHcQ9aTl57ltTR5Qu42eT/tQPk3OXvQXGty1Z8AdFatsJT1DUgO+UfWuH2IR4pYdZCrNxAc7QTBl05icmjVHssbfBpfd87ruwBXxDx+k9C7fP3YoZX0hhckioAaLONh3lYZ9dS/9IgA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PytQVEfh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbuOabYb; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PytQVEfh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbuOabYb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776763144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W6rJ+0VXi49xCQrxNs2KSyNZeKpDvLDF1B14DRPmB84=;
	b=PytQVEfh35x9BkvZuRd9nfSjsud+aKZAOrBDzS2YVzGHPLWjh6k30d3uPI9Jo34VjhQXLb
	gRsyf5trJO784GZtuIHbiDAMua5+BELr/NypRsKB4CvZUgLUDbFvHiYOqRS/tkNkyGkEEx
	f5UiR2GVjqFLd0jC+23PaMN1jDzXZD4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-Lqu0XGt7Mmia5I0pU-hr3A-1; Tue, 21 Apr 2026 05:19:02 -0400
X-MC-Unique: Lqu0XGt7Mmia5I0pU-hr3A-1
X-Mimecast-MFC-AGG-ID: Lqu0XGt7Mmia5I0pU-hr3A_1776763141
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38e83f0482eso17282891fa.3
        for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 02:19:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776763141; cv=none;
        d=google.com; s=arc-20240605;
        b=Wv5tRVrikdtGDskv8UEntgPfEzcCRpbrsXxuL12xnxHAKoBcscKyzsHXgp6mGsl8gy
         jJPIqMQN0AoXoPLBWgAsr2Wtjjk5SJBPvgIULVRHsKZFOj5u4y23X6aLXFHU4xEjPGKw
         EPP4jp+bPNef4xtH65fQ3nNocCNgqLORDoKCfAS6rz+bUg5uhkvGOQs2zBVOn60ClAD2
         clSY+LmlI/rBCheZo9EE9uWL+L8o7BRIxfuZkceq5ldGiiWSo2dwZoXhMt0vhXyKL/dB
         R+97+LjpHJHBSggZ2t90e8t2LaTFz3J2tiJrNJAI4ASP1xp1TtWk2C7cNhAF9oZ878F/
         W6Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=W6rJ+0VXi49xCQrxNs2KSyNZeKpDvLDF1B14DRPmB84=;
        fh=oJGMxc32xAxMh2ApZk2VjGlpt84ndDrxuuBZH7olRWk=;
        b=NAj88ZWsLrPFipeJCGjgmRwqt9TzqRIIBBdb02mmVjqDB2vJqwQmRK3ec+/OTG0x66
         2p57eTUHIX7EhdroAFTXba4VI9EQX81qqYmf8P4jBeR7nJ0uOssrij0aWynJ+gOkWw+0
         uf/rqbcvps2B43ab1H9717q4e9JECrDpGot6lDhj70jPws9n7v5kMy+9IjZeByAxnTzV
         5/xBTpCGfy0DrsGi+U3XqLMFBZmoelV3cxl15OmkOGA7Di66F/T96/HdYErHRRIbTxIC
         25TzvkcA0mVrNDLXe/cJZ1/5lgbecq4cJ+UADVF56ntJcALZN5Ad874++p8VHizOQPoP
         UzLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1776763141; x=1777367941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6rJ+0VXi49xCQrxNs2KSyNZeKpDvLDF1B14DRPmB84=;
        b=XbuOabYbRkAtFRyJmBdpSKfSQroP0wO5d4ahowabdpxbIwxOQTtPCFaVEZTNCSefKh
         hxbaf24iePpLskfsTiVVhPaK48QAmcrfVttEMqVnuSM+5FHuuv0QU+9clThnuIyOJUMI
         7oQFPtM+Rzrouu0vZ65YfDvdU+OkKKwYAUdFxm1QFJI0BKYbCVfNpyaL9q4n+Xc8JfbI
         vt3cDmIARcjieRvjq5vcnniuo2X9Qpp5YFcQVVOfva/iXHLT8HE1gczpYp79fVEdaw4g
         4VVMUzyDwAQuwa7b8pc0eb21xx74nGv1r1DaXPmhsy1xnGwjit1INwQJnMO6ZLxgrCZY
         w7gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763141; x=1777367941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W6rJ+0VXi49xCQrxNs2KSyNZeKpDvLDF1B14DRPmB84=;
        b=KvTdxU8Bu8lzADXwE6j5VYNL2NxSKy331zUfYDExhsNuCPl3Ix4GJmwMwH+t1X7b7Y
         cCDSs9vfbUefG8oLfBpENVZFfT0cjLhz626WCkPOtxCBdjygmhRKOBQPRR7WLvzSbsfD
         6MQEW5JmsBHPzmU75yszIle/TnPw52xeI824NEkSiKHhFwWDenufVykMMl3KldMmypks
         9Ro5h/NT08j72CSgjQ3pUpQUaztHAal6G/mWUGWo/81B1wlOZSLcfLQCs+fcQPvPQOQk
         qm6LQ9ttVLEQjdmZiuMX/KO8WPo58/bo75FZ9AvabZixZNLdVqc43zVVOiVCMIe9+4H2
         cIng==
X-Forwarded-Encrypted: i=1; AFNElJ+usVoB8AyKGDW+e1b7LU/PFgaYGFhpmawnWQmD68aJU1Qz3SExOxbYc9Ct+O8AHEN88ayIBCWfYfwG@vger.kernel.org
X-Gm-Message-State: AOJu0YwOb/ORyzYAQ4lnSswTMTCcdSrGwy4g3IkDOa+IUTJjiz2t6PET
	YoByK4paVd/DcFxoqRJr55DiQbkakKJAfZcHce79QNyCHNwFgvvbuqtXKwOah071GVLYNLlpaFB
	EPEnKwbR8SJ4lEMefYNO1XUgl/EUncjmImPXgE2p8flhdvILTV8720/0QvO5OxGX+doVewG/0si
	12SiJBAfS6rUAu2nayhJ/A6jcL7Jx60VvHJ2Zh+g==
X-Gm-Gg: AeBDiesoXCPqATPbvlDuQpTgCa7Az4hPzx3xuEV5BsQUFl8O78U93WPKnvAgjqkCCXm
	PxQWeUSrjUn3a5EuHsJjCJI+cCIjzfXy6sh8drl0gABMRqfhtCE9XTnpfa8U+qOT9Ml7NrQfg/l
	61GvKFfGNC3PNPfOfRHP3HCkL4RTDatnFkr+wUH15O2JLoKXQGA2YZRVKUtXR7svU6xeuUE43IZ
	yUFoLXPCVhcC39iH7hLfaycxgRQX2H9hRNtIEuhsOORP0RLRfyr6Lw6JNgZ/lqd3g2Y98UjKknZ
	Dd12Sbaw1HyFnvB4
X-Received: by 2002:a05:6512:3ba6:b0:5a3:ff60:b72e with SMTP id 2adb3069b0e04-5a4172eac66mr5550784e87.39.1776763140946;
        Tue, 21 Apr 2026 02:19:00 -0700 (PDT)
X-Received: by 2002:a05:6512:3ba6:b0:5a3:ff60:b72e with SMTP id
 2adb3069b0e04-5a4172eac66mr5550766e87.39.1776763140398; Tue, 21 Apr 2026
 02:19:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-3-kch@nvidia.com>
In-Reply-To: <20260416212633.72650-3-kch@nvidia.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 21 Apr 2026 17:18:48 +0800
X-Gm-Features: AQROBzDf2tjvBa_f8b5LjqU6QJRyMegO5Ky2-PWAQkE5Cy7OI3M6rtbRfAnWzKI
Message-ID: <CALTww2_bSwhqUnc-9Z7qL_-J3JtvhtGr3CmjUg-r-=zoaGt68g@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] md: propagate BLK_FEAT_PCI_P2PDMA from member
 devices to RAID device
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com, kbusch@kernel.org, 
	axboe@kernel.dk, hch@lst.de, sagi@grimberg.me, linux-raid@vger.kernel.org, 
	linux-nvme@lists.infradead.org, kmodukuri@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 5:27=E2=80=AFAM Chaitanya Kulkarni <kch@nvidia.com>=
 wrote:
>
> From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
>
> MD RAID does not propagate BLK_FEAT_PCI_P2PDMA from member devices to
> the RAID device, preventing peer-to-peer DMA through the RAID layer even
> when all underlying devices support it.
>
> Enable BLK_FEAT_PCI_P2PDMA unconditionally in raid0, raid1 and raid10
> personalities during queue limits setup.  blk_stack_limits() clears it
> automatically if any member device lacks support, consistent with how
> BLK_FEAT_NOWAIT and BLK_FEAT_POLL are handled in the block core.
>
> Parity RAID personalities (raid4/5/6) are excluded because they require
> CPU access to data pages for parity computation, which is incompatible
> with P2P mappings.
>
> Tested with RAID0/1/10 arrays containing multiple NVMe devices with
> P2PDMA support, confirming that peer-to-peer transfers work correctly
> through the RAID layer.
>
> Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/md/raid0.c  | 1 +
>  drivers/md/raid1.c  | 1 +
>  drivers/md/raid10.c | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 5e38a51e349a..2cdaf7495d92 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -392,6 +392,7 @@ static int raid0_set_limits(struct mddev *mddev)
>         lim.io_opt =3D lim.io_min * mddev->raid_disks;
>         lim.chunk_sectors =3D mddev->chunk_sectors;
>         lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
> +       lim.features |=3D BLK_FEAT_PCI_P2PDMA;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
>         if (err)
>                 return err;
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index ba91f7e61920..422ad4786569 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3215,6 +3215,7 @@ static int raid1_set_limits(struct mddev *mddev)
>         lim.max_hw_wzeroes_unmap_sectors =3D 0;
>         lim.logical_block_size =3D mddev->logical_block_size;
>         lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
> +       lim.features |=3D BLK_FEAT_PCI_P2PDMA;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
>         if (err)
>                 return err;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 4901ebe45c87..07a5b734c8f3 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3939,6 +3939,7 @@ static int raid10_set_queue_limits(struct mddev *md=
dev)
>         lim.chunk_sectors =3D mddev->chunk_sectors;
>         lim.io_opt =3D lim.io_min * raid10_nr_stripes(conf);
>         lim.features |=3D BLK_FEAT_ATOMIC_WRITES;
> +       lim.features |=3D BLK_FEAT_PCI_P2PDMA;
>         err =3D mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRIT=
Y);
>         if (err)
>                 return err;
> --
> 2.39.5
>
>

Thanks for enabling this feature. Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>


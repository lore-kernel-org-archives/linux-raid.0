Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F01832AAD1
	for <linux-raid@vger.kernel.org>; Mon,  9 Mar 2026 07:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773041558; cv=pass; b=Tzxp8exHVhjrtJeUbL4QEhm9G3qtaeL8JeZsxhtClncTzOax4Gl6L/08U6oAukNrMa7guXK4ztqxW6onbahMEmz963aqjx25vi/xaIkpytAKnBYgzfxcCsE0BRxPXmbbepO/WBUY2QSjA+3QPBPgv7NIpVFE2IM6Nhphs1H//nY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773041558; c=relaxed/simple;
	bh=95BppmzFcVsuZHrr9FOIJD8l71qmsImf1ojDT1eVIoc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OF/mL0aaUGmKg4t0WUrmHcs8OiC0VpHifGdUFf3qP6L+BXftBfZMxxRml4UPVEmhmsKGkadYsTjtJgmVM/50fAyrseF2dZldQ+0zT3uQgDUQzsTsKyogQ7QnokGVmsg5sNhyENUHpMXHiqMSvgW5wNmLMeYu7chCHm6wro06AbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Chb6rZjl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KR6UNnze; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Chb6rZjl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KR6UNnze"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773041555;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e0NUVwzPtDFEbrK2pD+yarilDmd/pglTvNF9eq/2V38=;
	b=Chb6rZjlHKlkPUlG9h37lYPtlnOOkoespesk/Bc597AJa9OmQuXdwtVN8WZvE3+oblxEbA
	188d2kUKsGpOajnKZt7JoSPIZlgkg9Ly8gtQX/LNyqXasAh3lJcG24eqsxGBUzTjnrc2/Q
	u+iFfX6CPxv0BQINYYKlqijlhfQxOyI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-UMwi0A6DM5CSpwOv7BzvpA-1; Mon, 09 Mar 2026 03:32:33 -0400
X-MC-Unique: UMwi0A6DM5CSpwOv7BzvpA-1
X-Mimecast-MFC-AGG-ID: UMwi0A6DM5CSpwOv7BzvpA_1773041552
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5a12ac54316so2274367e87.3
        for <linux-raid@vger.kernel.org>; Mon, 09 Mar 2026 00:32:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773041552; cv=none;
        d=google.com; s=arc-20240605;
        b=eJlOZCznJ+zsHq+mdFvj/FK6QjQwlKYgxXlyr4NbDj7/ezey93+NA0PqDBvBTFGovz
         GYWWILx/5KC+6M8qS4mR1UZ3lrXLF4KrWmfAKg61Vht/9ZbsF/xpZn3dIp8dDaYnT7pN
         Aay2Ipf8B2F/KKoJGvlJ8CrJJquGnkx7M/SQqkuGuxVPb9kdsHh7lcWLVOHiXYJjv4R/
         Is+4+vBTTKdZ2qRPhIrd2M2GAJHHvDcN+p/mrR8xxAaF0sf+6VhhIEIz1q1qmY161xbB
         rLRMdOz6cdKfI/sMcm9RvpeYWOLD2YzbiQ7U/AZeTeshtWfXwJAiVC0PBm9Y6VXd4D3Z
         zuzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e0NUVwzPtDFEbrK2pD+yarilDmd/pglTvNF9eq/2V38=;
        fh=x/txJ13h3fS1qIRf/mMuTmuGyCJsFPU+1h2ES2KpeCM=;
        b=FuwKoig62ZNn7InnMiIr4D8o2RN4K25Rd7jJ0/c7z7aqhblyQdlYXP/JZ+CfTi5EDj
         0GzAPKWLjHquqYag7dsTnod3aacY1ixxs69yLnnnT7ayJDIvSBpsWTe9kJievLGKOf9S
         Z7g2ODH8To8LG2Kgm6yUlwuZCdylPbJ2ZK1eM9YiviXygj9ltwNK9bTRPE+DJvBjOAjT
         KG/NkToCsm6V5aR2/mvf3EGvgmXWi+de4LZna3ndDNilvxSNCi0XKK+ErkXeVOak0L8h
         McJfQbZGaBmbjQ7fBdnKezGjDh0VUKFZ0TJll144Zv+9XMoWBArR6OleeUyoVUyg5MPq
         gf/g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773041552; x=1773646352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e0NUVwzPtDFEbrK2pD+yarilDmd/pglTvNF9eq/2V38=;
        b=KR6UNnze1pUFDgcZxi0jEnh8jCSs81T7dTgSzD36uI4K2S1PYyFRxNFUKv9zBMtF3J
         k98n4NktgPT+xQE9TnEhaA6yy87xh3BMVVhPou3M0D70ZuI3VOezsySjKxvWF+RY+xul
         HsMwvORsJwwGj1IkiBg2sWyDkv6Jup5wizqUAhK2VzwDUuADrUm8i7ltVx2XG/AT+xiz
         TpX+jIgafW6+fYl7q5Bk483yYGutK89SBWvYZ5mHIVxlzXJspXV+e9ckdXEmPnf6Wj7Q
         qfENKlbBg6Jy1yPhKSgaSXgrS/ZkZOXfQIShgLBSRwV26M7W8/4IFi9u/xHwhaF+aMb7
         S0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773041552; x=1773646352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e0NUVwzPtDFEbrK2pD+yarilDmd/pglTvNF9eq/2V38=;
        b=Xx2t7Heat3Qq/9/nadnSECakgGRT6QqTxW/EgSU5vG6/Mq+nk9/gP7ziPFyy9/eWMX
         YurW5Cm5BMIjoLDAgZ8BXeVMhqS9QR/68s3zXDzp2QfO9g2UU54Qs7bTuQ7KFyPy8Hcr
         k6cNLeJHyEUOewDU6zT1m31NWLLNmqDS2vwPL76rPx3vmJsioMA1aU977aq2eKVp3AXY
         BdmY3w1B9BDuMoHgZ3qmq6x4NYySEZkcrslfOejgfG9Jov4EP4zYuwKVVYF4GFt3CD4Q
         zM1wYevo7/vntT9SIKGQWzXmNbmjo0boN4d5GCcEynnT2PG2y7Crd16yhWQ0L8bn9qj9
         zOwg==
X-Forwarded-Encrypted: i=1; AJvYcCVqVaxBD0V6A8W7Gw7s6AVhiWiWzLPgAIbs1IMYsMUaS1vKbAYXLQ8txr2vbi/pEe6L4mXnKyzd2kXc@vger.kernel.org
X-Gm-Message-State: AOJu0YyUFhyNNAjDwJeoN8VDcdvASXCYLcRtVTxr9/SZYHQC+DO4A8R2
	cq1d4DJnW65g9GhC5bxIrb4xfp8GBVaFzTi9B7m+BP7ZG3ym8jttsGzwrWmjwC/XgE2HEbCToCV
	kDFsrQ8aUh1XtK2KgFjUHaWzvvwTxjt38H/F2618XVG+PpaPmz3NxUR/cm0G6CZHOKicWKOsE9k
	TFgq2loG9npgSgZqMZ3XoEXzbng1Gba6C77KeShQ==
X-Gm-Gg: ATEYQzxgMJKpl/L+TZxBKo8aalN7RXCp9ealmTXN814ixjO3iUAKpLKr9jnoUYUbLug
	DENo/pterTb6BV6wXO+HbgWJQaKbFq8dSi0Z9eDVBrddMutrUiOXuXpf2qBbzDD2nGULCk1LGUz
	UKf8uH8ZNsV2G5dIC8u93Rau0bpMRHQyE87vOlbLSqA9jQT3lNGKJy4hoJF0/W7gtcVVkKiJpd9
	gWLOxJdCz6FekpIiAlwCBSnklLNPAGWwNmwh2JR18j/BezgN0s/j+P25ycOGDMYj9rqbnLiKb9l
	zFY1bA==
X-Received: by 2002:a05:6512:610:10b0:5a1:2a4e:99fa with SMTP id 2adb3069b0e04-5a13ccb70eamr2542536e87.17.1773041552244;
        Mon, 09 Mar 2026 00:32:32 -0700 (PDT)
X-Received: by 2002:a05:6512:610:10b0:5a1:2a4e:99fa with SMTP id
 2adb3069b0e04-5a13ccb70eamr2542527e87.17.1773041551830; Mon, 09 Mar 2026
 00:32:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-2-yukuai@fnnas.com>
In-Reply-To: <20260223024038.3084853-2-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 9 Mar 2026 15:32:20 +0800
X-Gm-Features: AaiRm50qstcGN7mkIoEfeUXGSjTIXiAwl2X19u1yW2fCpAF23gL_8gphZzeR248
Message-ID: <CALTww29AzhFrygKoE6ZxW8xekkxP=TDN+yVM+vfxsbBxrm8Row@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] md/md-llbitmap: skip reading rdevs that are not in_sync
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:41=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> When reading bitmap pages from member disks, the code iterates through
> all rdevs and attempts to read from the first available one. However,
> it only checks for raid_disk assignment and Faulty flag, missing the
> In_sync flag check.
>
> This can cause bitmap data to be read from spare disks that are still
> being rebuilt and don't have valid bitmap information yet. Reading
> stale or uninitialized bitmap data from such disks can lead to
> incorrect dirty bit tracking, potentially causing data corruption
> during recovery or normal operation.
>
> Add the In_sync flag check to ensure bitmap pages are only read from
> fully synchronized member disks that have valid bitmap data.
>
> Cc: stable@vger.kernel.org
> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md-llbitmap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index cd713a7dc270..30d7e36b22c4 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -459,7 +459,8 @@ static struct page *llbitmap_read_page(struct llbitma=
p *llbitmap, int idx)
>         rdev_for_each(rdev, mddev) {
>                 sector_t sector;
>
> -               if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags)=
)
> +               if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags)=
 ||
> +                   !test_bit(In_sync, &rdev->flags))
>                         continue;
>
>                 sector =3D mddev->bitmap_info.offset +
> --
> 2.51.0
>
>

Reviewed-by: Xiao Ni <xni@redhat.com>


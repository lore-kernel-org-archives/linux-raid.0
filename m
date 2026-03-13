Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B73B34214F
	for <linux-raid@vger.kernel.org>; Fri, 13 Mar 2026 08:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773389593; cv=pass; b=m/LQN6reAwrdYO01i3hCwoWjfFz7IDza2L45KPcGApBD511+Hsc1YQLYydf3f0Avv2mSJpxQr0ZZOuw86dJ/JKcqbw3bb6l6W9vku56jL4PTSLzlDmdTSzTJJJRyWUQpbFZv6JrpcOYv86MoZwAQdBG03HkCyF7cQkximiQso9c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773389593; c=relaxed/simple;
	bh=vJVfB4m/rd2YxSC624TTbI7yxQF8h7CaB/ys+T+em8s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dQDJ9i8rfdpKMdcdlcGI325/EGss077S5mgAV8TT/OEvqynbek7cdbf/YP+ZNoEQkygmnwPqCXxR2vSspSXQoswIdbSJDdpIWXz4D0pug2K8/nM0EjITtH24Zq6I15NlLXdpuaJOTqFav7N5PCyP1BjAuRd+6VIm4XXvxPBe6dA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L3zenYZl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsfjdWET; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L3zenYZl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsfjdWET"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773389589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hq5FY1nDejnNWiCDlpPWBxEMj2bUgbp9R8zypXiRTQs=;
	b=L3zenYZljR9zdFRlTn78qSVvDj8cwC9A4Zkb/ueVGryyUjS1OXL4QRf4ZqKFCKAKIhmVXb
	vKXKIrzuhurruK0KFhkptcknWP8RjHOLFbVeeIaNu44SYBMXNWIqJiaXYqUQUelnoxC/iy
	8R/rsciatkQin3kX1OH7Bcb0UObTRno=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-ARfEWiDzN_uabFxza5DWRA-1; Fri, 13 Mar 2026 04:13:07 -0400
X-MC-Unique: ARfEWiDzN_uabFxza5DWRA-1
X-Mimecast-MFC-AGG-ID: ARfEWiDzN_uabFxza5DWRA_1773389586
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5a1324ae966so2474280e87.0
        for <linux-raid@vger.kernel.org>; Fri, 13 Mar 2026 01:13:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773389586; cv=none;
        d=google.com; s=arc-20240605;
        b=POZCR0yVnnAiPkq2dCyzg37KljYcWudbvGEGIjFqwnzjIuXQwahw+BFogzx7k0MZH5
         FLeNk9x3FXvIZBEFX7HNovKeEp59QyPqAWFSplvm5dZ1jQY2UquxkE3NycR8K+gfnYTA
         xUFxAHOXbchGnlNEX2x6JxBRB5cZOfuK4hCz4wI0erPDfFtvu2o/3/CETWu4KV1a0Mpa
         GqKwMcVtby/4yQf8G5xxwtGZ8KDuvNvkKxUgr1D4L+hPIrfV8ywaYN031+MH9RrKM5Fw
         2yySNuCKbCDTf5PKdbYrVwnoY+bAB8tCHyt9dXWRJW2fUvz5rWAmaXJnYidkjduJCuxN
         UQSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hq5FY1nDejnNWiCDlpPWBxEMj2bUgbp9R8zypXiRTQs=;
        fh=nIucUE6gwrYVEvGBeRk3ZZcHfUMhfpgqcwr3tYqgAv4=;
        b=AeOhGQEsCfaDpyCJfr37KoJ2NpHpdjqCXFN4cuGzahzu1KDirh+pyVdeJrc99HGYga
         uA0Gf6H7izW1ArznawrUhkreqbY+WccHW2885SqWCkHyrMCiT0LptmrzGOYy+LosfMw3
         pm01qA0O1rGKDduSnhhxFN6KyxCG73EJO/0PFXUGTJKzNUM12NlxRIlpZQI26Gkh8Vy2
         iFFRHmM6u7I1N45PPBobMx22veDPFz7mfj8KnySBRWL6YBjLmQgyRsqIU6u1gY5kS04k
         sIkcLm4eP76jYkF5NxFunU75KQqlxVipjjWLqvI16mRSdMBivkgbUk+J884LIMiXpKzO
         ifbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773389586; x=1773994386; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hq5FY1nDejnNWiCDlpPWBxEMj2bUgbp9R8zypXiRTQs=;
        b=LsfjdWETKL3wSqvVySwTIh8u1zDRtiHOwQqgoB9fqEZi5py3MNRXkkgvlW1i43OAxP
         oulo2lOKz4/tLeeqB5fuWnIw4mxMmDKMoomxYIllX1WTMXLMH3U16bqH+m/Dq8lH17dO
         j2xK2at5uTZ3wHKcOV+0A2O6Xa3oloPbRgFSSrXmmwuk44iGSIoWPB9pMU9/1CE00KA6
         J7vEHRlWfccBLQnGxCpCO7g54WpwKXiN03ls8bKRD5+RnqJ4q82gmXIaRnaUzOHKtqRX
         jP0acvXvgvc3v7MErRIHEaeJ+RV0CD6a7Czbl1ex9ypK9P76cNQh4MlJzNwU7CgExYK3
         FDrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773389586; x=1773994386;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hq5FY1nDejnNWiCDlpPWBxEMj2bUgbp9R8zypXiRTQs=;
        b=DnRKd6tnnwX3YAywIxrwpz3VgCon+E2Hks3onRa7nRXM0CA3BWv9tKZBRl+sPUOEsQ
         U6e4FSQTi0xh6UpsEdVUmU+/WIjb1GijxsnUslhVCuDiNKk9jVK+oxJV4CZYsoQ3sy4B
         86cG9I6ic8R5UId/1zPuzISqv89km8URRQuhsorryG/jEjdTV52GVeY6Fp/dy8gBy3Il
         /yrs00KFQmnWV7AOZuibta+ngtv2aS3Gs08HWNfDzs5P88ECm2sDAjCp7CnY4DdzFE4t
         JO10l0ZRQpI6MQ3H0CMqNFjgiWHlMZHuMCk1jNnmbDGBOXk4oItkkQQ7iJyrwGOXhHte
         vxkA==
X-Forwarded-Encrypted: i=1; AJvYcCXZdFAwvMoN0FgSrQGHUVxLnkXbiJ649rQ/dX+qqSHFKBpTiGCJf1HZM5SyNXDY1UIL6kTPxCGOxmCv@vger.kernel.org
X-Gm-Message-State: AOJu0YxFBSRvwkMKTcX/hisJ42loJdHYdr4MLMIr6+jwHDvp01Qq+KeN
	aV2TDcKpH7dNaBXSOI25+37KnVkP+RteYzN7ODfDO//WMJXCUpK54Y13vyDKwJ/ssQtadhsKQxO
	XLW5zQJX++G1y+ct8y+ohBPUzTGMLgoCgoW4c9aGONmcx0/bZeJZs/4Unk46xu/d0AiT1/Imk7b
	cc+4MVs+jl8KzJHh0x9lEiezIeQMWw+dB8/8FRH6aFVvgzeA==
X-Gm-Gg: ATEYQzwMV85IQXXj8wy63gOviERhMd0gw5eAWQzzvhrtWJgF8T3jzVCs2wAzJxo265T
	XW9cjSrZizt8jSsjOIRmNmivDWZV6gF+QJoyAc0DnW7aQ7G0kiiJuzS+2Jdp7NASKQ0SdBpuMep
	la6uTaVkAW4c4XAmarU4Fw0KR8URrRpCv4qv073+lc6ce6ksed8dEcA7lcmUzMGTVSynfzLueM5
	sMJHH2ojYmlFUj0H99VlJWwhyKTOdkm2tvsm8R0IIm4GVKcxOTND+rnUGRVGLNoM1gRBiuCrqrJ
	dYjtoA==
X-Received: by 2002:ac2:43d8:0:b0:5a1:4246:4168 with SMTP id 2adb3069b0e04-5a15a4b6c3dmr1463633e87.15.1773389585678;
        Fri, 13 Mar 2026 01:13:05 -0700 (PDT)
X-Received: by 2002:ac2:43d8:0:b0:5a1:4246:4168 with SMTP id
 2adb3069b0e04-5a15a4b6c3dmr1463628e87.15.1773389585190; Fri, 13 Mar 2026
 01:13:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-6-yukuai@fnnas.com>
In-Reply-To: <20260223024038.3084853-6-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 13 Mar 2026 16:12:53 +0800
X-Gm-Features: AaiRm51S9q46jkiK8CkVsJ87p_VpfhTZoyim__5-_GY9IQseJm16PBhXvzM3ESM
Message-ID: <CALTww2_zudwj_h8pOw-DWsfECWW6tiD7fVYcXr9TDRfh8Kbvjw@mail.gmail.com>
Subject: Re: [PATCH v2 5/5] md/md-llbitmap: optimize initial sync with
 write_zeroes_unmap support
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 23, 2026 at 10:41=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> For RAID-456 arrays with llbitmap, if all underlying disks support
> write_zeroes with unmap, issue write_zeroes to zero all disk data
> regions and initialize the bitmap to BitCleanUnwritten instead of
> BitUnwritten.
>
> This optimization skips the initial XOR parity building because:
> 1. write_zeroes with unmap guarantees zeroed reads after the operation
> 2. For RAID-456, when all data is zero, parity is automatically
>    consistent (0 XOR 0 XOR ... =3D 0)
> 3. BitCleanUnwritten indicates parity is valid but no user data
>    has been written
>
> The implementation adds two helper functions:
> - llbitmap_all_disks_support_wzeroes_unmap(): Checks if all active
>   disks support write_zeroes with unmap
> - llbitmap_zero_all_disks(): Issues blkdev_issue_zeroout() to each
>   rdev's data region to zero all disks
>
> The zeroing and bitmap state setting happens in llbitmap_init_state()
> during bitmap initialization. If any disk fails to zero, we fall back
> to BitUnwritten and normal lazy recovery.
>
> This significantly reduces array initialization time for RAID-456
> arrays built on modern NVMe SSDs or other devices that support
> write_zeroes with unmap.
>
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/md-llbitmap.c | 62 +++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 61 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 461050b2771b..48bc6a639edd 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -654,13 +654,73 @@ static int llbitmap_cache_pages(struct llbitmap *ll=
bitmap)
>         return 0;
>  }
>
> +/*
> + * Check if all underlying disks support write_zeroes with unmap.
> + */
> +static bool llbitmap_all_disks_support_wzeroes_unmap(struct llbitmap *ll=
bitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       struct md_rdev *rdev;
> +
> +       rdev_for_each(rdev, mddev) {
> +               if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags)=
)
> +                       continue;
> +
> +               if (bdev_write_zeroes_unmap_sectors(rdev->bdev) =3D=3D 0)
> +                       return false;
> +       }
> +
> +       return true;
> +}
> +
> +/*
> + * Issue write_zeroes to all underlying disks to zero their data regions=
.
> + * This ensures parity consistency for RAID-456 (0 XOR 0 =3D 0).
> + * Returns true if all disks were successfully zeroed.
> + */
> +static bool llbitmap_zero_all_disks(struct llbitmap *llbitmap)
> +{
> +       struct mddev *mddev =3D llbitmap->mddev;
> +       struct md_rdev *rdev;
> +       sector_t dev_sectors =3D mddev->dev_sectors;
> +       int ret;
> +
> +       rdev_for_each(rdev, mddev) {
> +               if (rdev->raid_disk < 0 || test_bit(Faulty, &rdev->flags)=
)
> +                       continue;
> +
> +               ret =3D blkdev_issue_zeroout(rdev->bdev,
> +                                          rdev->data_offset,
> +                                          dev_sectors,
> +                                          GFP_KERNEL, 0);
> +               if (ret) {
> +                       pr_warn("md/llbitmap: failed to zero disk %pg: %d=
\n",
> +                               rdev->bdev, ret);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
> +}
> +
>  static void llbitmap_init_state(struct llbitmap *llbitmap)
>  {
> +       struct mddev *mddev =3D llbitmap->mddev;
>         enum llbitmap_state state =3D BitUnwritten;
>         unsigned long i;
>
> -       if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags))
> +       if (test_and_clear_bit(BITMAP_CLEAN, &llbitmap->flags)) {
>                 state =3D BitClean;
> +       } else if (raid_is_456(mddev) &&
> +                  llbitmap_all_disks_support_wzeroes_unmap(llbitmap)) {
> +               /*
> +                * All disks support write_zeroes with unmap. Zero all di=
sks
> +                * to ensure parity consistency, then set BitCleanUnwritt=
en
> +                * to skip initial sync.
> +                */
> +               if (llbitmap_zero_all_disks(llbitmap))
> +                       state =3D BitCleanUnwritten;
> +       }
>
>         for (i =3D 0; i < llbitmap->chunks; i++)
>                 llbitmap_write(llbitmap, state, i);
> --
> 2.51.0
>
>

Hi Kuai

This patch looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>


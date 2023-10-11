Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4A06CD6E64
	for <linux-raid@archiver.kernel.org>; Wed, 11 Oct 2023 13:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235010AbjJKN0q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Oct 2023 09:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346857AbjJKN0o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 11 Oct 2023 09:26:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B86AF
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 06:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697030752;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmPvl73WetME6mCWuPQw9Xw20nB7Yjr0cwaL/rXZvcQ=;
        b=C95c3fuit5sPla8MQozpOYyL9aIBB6F5PaVdm7QQ92KhK2MmaIJtxVfjiRCARhDSuchAtT
        xOOK1RDacGqpP2++eDv0o56GitqqSs2rli77QVS5j35YixZO6eKHztomzHvoygZvUSzqE2
        06bFvEBq8rmG+lI/2DSHah2/GnoZ+B0=
Received: from mail-yb1-f200.google.com (mail-yb1-f200.google.com
 [209.85.219.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-JpiVmZmxNLStXT3UxMKwIA-1; Wed, 11 Oct 2023 09:25:51 -0400
X-MC-Unique: JpiVmZmxNLStXT3UxMKwIA-1
Received: by mail-yb1-f200.google.com with SMTP id 3f1490d57ef6-d9a4a89ab5fso2971965276.3
        for <linux-raid@vger.kernel.org>; Wed, 11 Oct 2023 06:25:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697030750; x=1697635550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PmPvl73WetME6mCWuPQw9Xw20nB7Yjr0cwaL/rXZvcQ=;
        b=G1Jyo000N4VeJdz+AXWr19/E+sz6cLnigH948SEuU0N6zT3Gk6db4K08lf2gHRg9Vl
         bIpRCj7DZF/+o8Fo27UmMIbyuD+ojCBNOUFI0gp+cOGz74sRngxgUjzei3TDpX/k1b1a
         pirb0bQ28gcWYy7JtynSyohgMVCO6jTBcKhFgKerCiDWYNIuR96CD0180FyhBP4uFxb8
         pn9gwOkqaI8iLCawbPdLrnm9JXRVPxTF+TBHIuwA0AWj5PLDKqA6JnonUOtgNMKYpUsZ
         OVnACIrgx9zOW5RCGUa8Um0Z3vSDBbUCfHRwSTXI77tmyp47EOLDVjbFIk9OMpUJsthX
         ghcA==
X-Gm-Message-State: AOJu0YxK5NVJg2E5ye7rMCv/OodxECHuicc1IJdyV8XFTB1dcro39lhv
        B+QfEQhBlc++I0KlKJUrjoJuRrbxWjamODMuu9I9SFMJotOQLIIwwqw9Hd6k23aqYl6P2ka+xaZ
        0p/Mlfo4WI6f8GIxG3/55kJHk8ur0fpNHV0c2bgU3uIOwahZusGQ=
X-Received: by 2002:a5b:408:0:b0:d81:8c74:8f88 with SMTP id m8-20020a5b0408000000b00d818c748f88mr19188562ybp.25.1697030749667;
        Wed, 11 Oct 2023 06:25:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJ+eXOwqd5fdKnnvJYhkgaLFnYrOU1+DgP0mZt7vg8uDQy5BBrpSRE41TOQakokbcsU6qCL62jK4KO5pH61Os=
X-Received: by 2002:a5b:408:0:b0:d81:8c74:8f88 with SMTP id
 m8-20020a5b0408000000b00d818c748f88mr19188543ybp.25.1697030749370; Wed, 11
 Oct 2023 06:25:49 -0700 (PDT)
MIME-Version: 1.0
References: <20231011130332.78933-1-xni@redhat.com>
In-Reply-To: <20231011130332.78933-1-xni@redhat.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Wed, 11 Oct 2023 21:25:37 +0800
Message-ID: <CALTww28hforasc+v3GUWPdoyFyvFZOK8KXeZBKykr_u-2T3K9A@mail.gmail.com>
Subject: Re: [PATCH 1/1] mdadm/ddf: Abort when raid disk is smaller in getinfo_super_ddf
To:     jes@trained-monkey.org
Cc:     mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sorry, the title should be [PATCH 1/1] mdadm/ddf: Abort when raid disk
is smaller than 0 in getinfo_super_ddf

If you want me to send v2, I can do it.

Best Regards
Xiao


On Wed, Oct 11, 2023 at 9:06=E2=80=AFPM Xiao Ni <xni@redhat.com> wrote:
>
> The metadata is corrupted when the raid_disk<0. So abort directly.
> This also can avoid a building error:
> super-ddf.c:1988:58: error: array subscript -1 is below array bounds of =
=E2=80=98struct phys_disk_entry[0]=E2=80=99
>
> Suggested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> Ackedy-by: Xiao Ni <xni@redhat.com>
> ---
>  super-ddf.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/super-ddf.c b/super-ddf.c
> index 7213284e0a59..7b98333ecd51 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1984,12 +1984,14 @@ static void getinfo_super_ddf(struct supertype *s=
t, struct mdinfo *info, char *m
>                 info->disk.number =3D be32_to_cpu(ddf->dlist->disk.refnum=
);
>                 info->disk.raid_disk =3D find_phys(ddf, ddf->dlist->disk.=
refnum);
>
> +               if (info->disk.raid_disk < 0)
> +                       return;
> +
>                 info->data_offset =3D be64_to_cpu(ddf->phys->
>                                                   entries[info->disk.raid=
_disk].
>                                                   config_size);
>                 info->component_size =3D ddf->dlist->size - info->data_of=
fset;
> -               if (info->disk.raid_disk >=3D 0)
> -                       pde =3D ddf->phys->entries + info->disk.raid_disk=
;
> +               pde =3D ddf->phys->entries + info->disk.raid_disk;
>                 if (pde &&
>                     !(be16_to_cpu(pde->state) & DDF_Failed) &&
>                     !(be16_to_cpu(pde->state) & DDF_Missing))
> --
> 2.32.0 (Apple Git-132)
>


Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85CD8E95A61
	for <linux-raid@archiver.kernel.org>; Sat,  7 Oct 2023 13:27:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343841AbjJGN1f (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 7 Oct 2023 09:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbjJGN1f (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 7 Oct 2023 09:27:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F9EAB
        for <linux-raid@vger.kernel.org>; Sat,  7 Oct 2023 06:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696685207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jVk91jCZG80G6Ap+fsWnwgFCZMNjkoIMSdD6yfrF+Ho=;
        b=D1YzXAJJsmemft4uWzDWAbyAmQ8vdcSjmc1I9O0FrAn7nhX2fjZq8CzCBBLtA735KaCdps
        3P5ORhzuqiyhA5d1bCEwGDu/HzBh/dcGgLyTyHgQ6GffNRXw2d8E2hGbr5uWR5XSUf/Z/Y
        NrTMaWQFJaz/WwEfoL1wKfdEkYxgFRo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-ShrFotFyNLCLXDi277yTRg-1; Sat, 07 Oct 2023 09:26:35 -0400
X-MC-Unique: ShrFotFyNLCLXDi277yTRg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2791b8181ffso2628449a91.3
        for <linux-raid@vger.kernel.org>; Sat, 07 Oct 2023 06:26:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696685194; x=1697289994;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVk91jCZG80G6Ap+fsWnwgFCZMNjkoIMSdD6yfrF+Ho=;
        b=cVJwGMXUnwMNVostLw5F4/79E0BjAV5Bwc+XY8GP7+OO095cJZv/SXHqJ4jaa6rOkV
         3id+V7f96nVBN+pg0+WTraBLIOLQ18viCW429nxp3RXTYMpgkQ9wmnUC1NRbkkhSGjy3
         58wvjKeQhzBHl61kZf7mI/7EI744SQrSybS1zyFw1drks3QZ3J3cOEf9LU2n6yrbMIW9
         4ycyxoHgZvkynvgCr4vaZGH9L2dkLyi0m4s6cG+o7FNeWXixBrzTAVx+EtQFsx0qQtw1
         SsuMzB4IuxgnK1EfIgbaVzKZfyRPvqS/SopGL8EfILrTmCr1Hasr78az3832Sl2mZlp0
         CQIg==
X-Gm-Message-State: AOJu0YxtTaCUHvFASD4NzuDjwyjjZUyus1hwDyM61WFHzJhQ/zRija8j
        kJFINkBagVfcHGxIqzugq091+m1eqfNtUlT+BWAWYxCwG1gflIrg1SuMJolvYd/nkSQKw4DB3FV
        cL9r31/O3U5IJzY8B2uN3PqZ9z++LUtG1XlvPc0mibU/of777
X-Received: by 2002:a17:90b:1241:b0:274:9a85:2596 with SMTP id gx1-20020a17090b124100b002749a852596mr10370813pjb.32.1696685193771;
        Sat, 07 Oct 2023 06:26:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrlHKxc2JfMxAAZ91SxRLX0h4HXtb+PaOWqJlk+Rzfs/LXatvkhZ8dy7KYz8UU1duZWsJKsRXVGO+L8F8a3I8=
X-Received: by 2002:a17:90b:1241:b0:274:9a85:2596 with SMTP id
 gx1-20020a17090b124100b002749a852596mr10370805pjb.32.1696685193424; Sat, 07
 Oct 2023 06:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230927025219.49915-1-xni@redhat.com> <20230927025219.49915-4-xni@redhat.com>
 <20230928114149.000016a1@linux.intel.com>
In-Reply-To: <20230928114149.000016a1@linux.intel.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Sat, 7 Oct 2023 21:26:22 +0800
Message-ID: <CALTww29bA29qPUR108O+JJ+rcwjrPqxG1oNA5ewKGGm_p7NApg@mail.gmail.com>
Subject: Re: [PATCH 3/4] mdadm: Avoid array bounds check of gcc
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 28, 2023 at 5:42=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 27 Sep 2023 10:52:18 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > With gcc version 13.2.1 20230918 (Red Hat 13.2.1-3) (GCC), it reports e=
rror:
> > super-ddf.c:1988:58: error: array subscript -1 is below array bounds of
> > =E2=80=98struct phys_disk_entry[0]=E2=80=99 [-Werror=3Darray-bounds=3D]
> > The subscrit is defined as int type. And it can be smaller than 0.
>
> If it can be smaller that 0 then it is something we need to fix.
> I think that it comes from here:
>                 info->disk.raid_disk =3D find_phys(ddf, ddf->dlist->disk.=
refnum);
>                 info->data_offset =3D be64_to_cpu(ddf->phys->
>                                                   entries[info->disk.raid=
_disk].
>                                                   config_size);
>
> find_phys can return -1.
> It is handled few lines bellow. I don't see reason why we cannot handle i=
t here
> too.
>
>                 if (info->disk.raid_disk >=3D 0)
>                         pde =3D ddf->phys->entries + info->disk.raid_disk=
;
>
> I think that it will be fair to abort because metadata seems to be corrup=
ted.
> We are referring to info->disk.raid_disk from many places. We cannot retu=
rn
> error because it is void, we can just return.

Hi Mariusz

You mean something like this?

diff --git a/super-ddf.c b/super-ddf.c
index 7213284e0a59..b6e514042055 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -1984,6 +1984,9 @@ static void getinfo_super_ddf(struct supertype
*st, struct mdinfo *info, char *m
                info->disk.number =3D be32_to_cpu(ddf->dlist->disk.refnum);
                info->disk.raid_disk =3D find_phys(ddf, ddf->dlist->disk.re=
fnum);

+               if (info->disk.raid_disk < 0)
+                       return;
+
                info->data_offset =3D be64_to_cpu(ddf->phys->
                                                  entries[info->disk.raid_d=
isk].
                                                  config_size);

>
> > To avoid this error, add -Wno-array-bounds flag in Makefile.
>
> If you want do it this way please provide strong justification. We are
> disabling check in all code to hide particular case. It will not prevent =
us
> from similar mistakes during development in the future.

As Paul and you suggested, I'll not choose this way

Regards
Xiao
>
> Thanks,
> Mariusz
>


Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94499C77B61
	for <linux-raid@archiver.kernel.org>; Thu, 27 Apr 2023 06:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242984AbjD0Gyx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 Apr 2023 02:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0Gyw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 Apr 2023 02:54:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7F3A44B0
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 23:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682578447;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RdeHzsV+Sn24Cc9iBoJHW/q9yDq5w+AekNpa/NPcROk=;
        b=ZmtV9SIOTeGLl5X7WitRpDdx36iB3d97tKgwycdYtb10FCSluuhozyEYqqRNFu/WAGIdcr
        rI3dmApDr7r/ky1Td7SwMWdelkqwZ6FHWPUhrRhCuNq/R5aj5ywumfQB7FpWkdS2ZWkzyj
        cehSDD+pY8tIEC8vPANl4qvt52Bk5s4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-gIF1J1uRPNyHH16x1jwENA-1; Thu, 27 Apr 2023 02:54:05 -0400
X-MC-Unique: gIF1J1uRPNyHH16x1jwENA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-63b63bd77a8so9212256b3a.2
        for <linux-raid@vger.kernel.org>; Wed, 26 Apr 2023 23:54:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682578444; x=1685170444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RdeHzsV+Sn24Cc9iBoJHW/q9yDq5w+AekNpa/NPcROk=;
        b=YmtdFhTgAaEtX1f3ub3nlB45rvNbRygnWBUf7a15uAPlsrTCBUWWbLqo95SnUMkZhd
         z2Pgs1RVmOKajzwbY764G4i7+P5dl7x7/FwWkWAhXMbiR65n9TfgLrt6GBQ4Yjn09IwG
         P9DKEQNo5N+iPKnoARa8xhQokNF1z8kM7Pzl8NFCZc2FVFHdfciHjSFT90bqepSWLeeh
         lio2sFzwRPM9LfAN+FO5rlNuA4jvg+iX0DKMhtllJhzkWsHLh2C1jbEP7CjuS8Wpn5VC
         vPLemXBPy2COLS1W2WNfc9BZFrnZfXT9/bJZ5r3yXLAQO/YSay6jUlPR+zkHIAgPupvm
         Zv3w==
X-Gm-Message-State: AC+VfDyiVqC8Lzcb6GXstof7HyGSPeAGHS2e3uJbvGAWHVBgmajwerat
        0DXTGRseZ5GcM5ID3ONqA4sZPBg2/sbuXWwUyuILdQ4TI/d9gcWPYn4Mi+eFMe8Eel1JscdwWd5
        P3Wljqp9Ir2Z21KIADHBvSyoMSaRgDaAl0xmrlD0UsefEnQ9iV/A=
X-Received: by 2002:a05:6a20:8e11:b0:f0:5d4:c4a with SMTP id y17-20020a056a208e1100b000f005d40c4amr876512pzj.8.1682578444049;
        Wed, 26 Apr 2023 23:54:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4FP7CKB3yCGy+lL7LtDjTgAUzrEmE9h6X463hg7vMXtoJmautMrcy8ctSu4FOv9XABR/QcWhUlDIspJkSEBbc=
X-Received: by 2002:a05:6a20:8e11:b0:f0:5d4:c4a with SMTP id
 y17-20020a056a208e1100b000f005d40c4amr876493pzj.8.1682578443752; Wed, 26 Apr
 2023 23:54:03 -0700 (PDT)
MIME-Version: 1.0
References: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
In-Reply-To: <cb390b39-1b1e-04e1-55ad-2ff8afc47e1b@huawei.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Thu, 27 Apr 2023 14:53:52 +0800
Message-ID: <CALTww2__S7y9zZ0Y2R6qOW4A_V0S0Z7Z_ixOvoe6BoGxqbnd4g@mail.gmail.com>
Subject: Re: [question] solution for raid10 configuration concurrent with io
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>, logang@deltatee.com,
        guoqing.jiang@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Apr 14, 2023 at 10:30=E2=80=AFAM Yu Kuai <yukuai3@huawei.com> wrote=
:
>
> Hello,
>
> rai10 support that add or remove conf->mirrors[].rdev/replacement can
> concurrent with io, and this is handled by something like following
> code:
>
> raid10_write_request
>   if (rrdev)
>    // decide to write replacement
>    r10_bio->devs[i].repl_bio =3D bio
>
>   raid10_write_one_disk
>          if (replacement) {
>                  rdev =3D conf->mirrors[devnum].replacement;
>                  if (rdev =3D=3D NULL) {
>                          /* Replacement just got moved to main 'rdev' */
>                          smp_mb();
>                          rdev =3D conf->mirrors[devnum].rdev;
>                  }
>          } else
>                  rdev =3D conf->mirrors[devnum].rdev;
>
> And this scheme is not complete and can cause kernel panic or data loss
> in multiple places.
>
> for example, null-ptr-dereference:
>
> t1:                             t2:
> raid10_write_request:
>
>   // read rdev
>   rdev =3D conf->mirros[].rdev;
>                                 raid10_remove_disk
>                                  p =3D conf->mirros + number;
>                                  rdevp =3D &p->rdev;
>                                  // reset rdev
>                                  *rdevp =3D NULL
>   raid10_write_one_disk
>    // reread rdev got NULL
>    rdev =3D conf->mirrors[devnum].rdev
>      // null-ptr-dereference
>     mbio =3D bio_alloc_clone(rdev->bdev...)
>                                  synchronize_rcu()

Hi Yu kuai

raid10_write_request adds the rdev->nr_pending with rcu lock
protection. Can this case happen? After adding ->nr_pending, the rdev
can't be removed.

>
> for example, data loss:
>
> t1:
> // assum that rdev is NULL, and replacement is not NULL

How can trigger this? Could you give the detailed commands?

Best Regards
Xiao Ni

> raid10_write_request
>   // read replacement
>   rrdev =3D conf->mirros[].replacement
>
>                                 t2: replacement moved to rdev
>                                 raid10_remove_disk
>                                  p->rdev =3D p->replacement
>                                  p->replacement =3D NULL
>
>                                 t3: add a new replacement
>                                 raid10_add_disk
>                                  p->replacement =3D rdev
>   raid10_write_one_disk
>    // read again, and got wrong replacement
>    // should write to rdev in this case
>    rrdev =3D conf->mirros[].replacement
>
> In order to fix these problems, I come up with two different solutions:
>
> 1) based on current solution, make sure rdev is only accessd once while
> handling io, this can be done by changing r10bio:
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index 63e48b11b552..c132cba1953c 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -145,12 +145,12 @@ struct r10bio {
>           */
>          struct r10dev {
>                  struct bio      *bio;
> -               union {
> -                       struct bio      *repl_bio; /* used for resync and
> -                                                   * writes */
> -                       struct md_rdev  *rdev;     /* used for reads
> -                                                   * (read_slot >=3D 0) =
*/
> -               };
> +               struct md_rdev  *rdev;
> +
> +               /* used for resync and writes */
> +               struct bio      *repl_bio;
> +               struct md_rdev  *replacement;
> +
>                  sector_t        addr;
>                  int             devnum;
>          } devs[];
>
> And only read conf once, then record rdev/replacement. This requires to
> change all the context to issue io and complete io.
>
> 2) add a new synchronization that configuration can't concurrent with
> any io, however, I think this can work but I'm not 100% percent sure.
> Code changes should be less, and this will allow some cleanups and
> simplify logic.
>
> Any suggestions?
>
> Thanks,
> Kuai
>


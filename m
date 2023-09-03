Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 982E8C83F3F
	for <linux-raid@archiver.kernel.org>; Sun,  3 Sep 2023 03:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbjICD1Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Sep 2023 23:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235644AbjICD1Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Sep 2023 23:27:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570D118C
        for <linux-raid@vger.kernel.org>; Sat,  2 Sep 2023 20:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693711594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TZR6UqSfyDVUdOMGlEnQu1srEV25P1bhKFmen9s1My0=;
        b=JHfNkXvcidMTlataxXdv6iU6RJiwQC5RJiyoDtw7cr0LFeeCymudioW2vKUezDVfJl5ut+
        YxOGZ8SKSh40KVliRc+pg0rKTYbkz/yMnCKQkId5knauC6f407ib1qh1Ethcdv2CyQe9dc
        bGgCfFEQRYjgsQVnVpm01IJ92+Rx6GE=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-668-J4DlzbViN1izfcgdVDRBfA-1; Sat, 02 Sep 2023 23:26:32 -0400
X-MC-Unique: J4DlzbViN1izfcgdVDRBfA-1
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-5733dfdddccso354574eaf.3
        for <linux-raid@vger.kernel.org>; Sat, 02 Sep 2023 20:26:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693711592; x=1694316392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZR6UqSfyDVUdOMGlEnQu1srEV25P1bhKFmen9s1My0=;
        b=ij7AhTobZbepD9UU907KIApOt/mFHkeLOf/hvO9UIc2J2+vsSV14pYZEQlyxRhPJAs
         Aj4AsZeUZ3JNR1Y30f83Wr6lJzImjdGtwZcUFJ6qusby6fS+gaLao46olv44eNKdIu62
         ynvN8TC7Fw8W8ut708Zk3ppDdiRg1wFBJ2n3KIcVHUG7JLAmTEF/nggfnSM9RIqAfS32
         4Dvr0SGOGzYN9PJ5Q6NieMZBAzovHpt97Kg+bCTwy6Lb21J7ZPegw/hZKUYOaOpcBeGs
         zV4k4yKkRtV2vyubGppdZkk1phKW8akM+6ICFQWI8mShdFHvmSEx95/VCuwdN1CZg0Dl
         t+Ww==
X-Gm-Message-State: AOJu0YyFJorpkxJt9EUJ2Oc8k9sPfAl4m9LvBB1JadFigGFU9ovU13Zd
        IuZd55JcXwQRrrAZN3fAZGdGowFfl6A14ErJUftikmjK1JQhw1/RZGYE+LwrOvTV1w8u9mNxRX9
        FSaTPSw1RQrWvo89mqxNg6i/PHud4l0WeWKwd3w==
X-Received: by 2002:a05:6808:1308:b0:3a7:b011:8960 with SMTP id y8-20020a056808130800b003a7b0118960mr9115794oiv.40.1693711592174;
        Sat, 02 Sep 2023 20:26:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuP0qOl/h2uTVtTEjYCVaD2ep5xs4NccB7TrUchHjD0APd8UhXTisae12wfggdA+s41YM4TUxDqv1DDjKyOrk=
X-Received: by 2002:a05:6808:1308:b0:3a7:b011:8960 with SMTP id
 y8-20020a056808130800b003a7b0118960mr9115777oiv.40.1693711591959; Sat, 02 Sep
 2023 20:26:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230811170513.2300-1-colyli@suse.de> <20230811170513.2300-6-colyli@suse.de>
In-Reply-To: <20230811170513.2300-6-colyli@suse.de>
From:   Xiao Ni <xni@redhat.com>
Date:   Sun, 3 Sep 2023 11:26:17 +0800
Message-ID: <CALTww2-KtrwjKSzMBwdgqwAcF5sSKNR3m=R2TMVuA7HscdeZqA@mail.gmail.com>
Subject: Re: [PATCH v7 5/6] badblocks: improve badblocks_check() for multiple
 ranges handling
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-block@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>,
        NeilBrown <neilb@suse.de>,
        Vishal L Verma <vishal.l.verma@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Aug 12, 2023 at 1:07=E2=80=AFAM Coly Li <colyli@suse.de> wrote:
>
> This patch rewrites badblocks_check() with similar coding style as
> _badblocks_set() and _badblocks_clear(). The only difference is bad
> blocks checking may handle multiple ranges in bad tables now.
>
> If a checking range covers multiple bad blocks range in bad block table,
> like the following condition (C is the checking range, E1, E2, E3 are
> three bad block ranges in bad block table),
>   +------------------------------------+
>   |                C                   |
>   +------------------------------------+
>     +----+      +----+      +----+
>     | E1 |      | E2 |      | E3 |
>     +----+      +----+      +----+
> The improved badblocks_check() algorithm will divide checking range C
> into multiple parts, and handle them in 7 runs of a while-loop,
>   +--+ +----+ +----+ +----+ +----+ +----+ +----+
>   |C1| | C2 | | C3 | | C4 | | C5 | | C6 | | C7 |
>   +--+ +----+ +----+ +----+ +----+ +----+ +----+
>        +----+        +----+        +----+
>        | E1 |        | E2 |        | E3 |
>        +----+        +----+        +----+
> And the start LBA and length of range E1 will be set as first_bad and
> bad_sectors for the caller.
>
> The return value rule is consistent for multiple ranges. For example if
> there are following bad block ranges in bad block table,
>    Index No.     Start        Len         Ack
>        0          400          20          1
>        1          500          50          1
>        2          650          20          0
> the return value, first_bad, bad_sectors by calling badblocks_set() with

s/badblocks_set/badblocks_check/g

> different checking range can be the following values,
>     Checking Start, Len     Return Value   first_bad    bad_sectors
>                100, 100          0           N/A           N/A
>                100, 310          1           400           10
>                100, 440          1           400           10
>                100, 540          1           400           10
>                100, 600         -1           400           10
>                100, 800         -1           400           10
>
> In order to make code review easier, this patch names the improved bad
> block range checking routine as _badblocks_check() and does not change
> existing badblock_check() code yet. Later patch will delete old code of
> badblocks_check() and make it as a wrapper to call _badblocks_check().
> Then the new added code won't mess up with the old deleted code, it will
> be more clear and easier for code review.
>
> Signed-off-by: Coly Li <colyli@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Geliang Tang <geliang.tang@suse.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> Cc: Xiao Ni <xni@redhat.com>
> ---
>  block/badblocks.c | 97 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
>
> diff --git a/block/badblocks.c b/block/badblocks.c
> index 4f1434808930..3438a2517749 100644
> --- a/block/badblocks.c
> +++ b/block/badblocks.c
> @@ -1270,6 +1270,103 @@ static int _badblocks_clear(struct badblocks *bb,=
 sector_t s, int sectors)
>         return rv;
>  }
>
> +/* Do the exact work to check bad blocks range from the bad block table =
*/
> +static int _badblocks_check(struct badblocks *bb, sector_t s, int sector=
s,
> +                           sector_t *first_bad, int *bad_sectors)
> +{
> +       int unacked_badblocks, acked_badblocks;
> +       int prev =3D -1, hint =3D -1, set =3D 0;
> +       struct badblocks_context bad;
> +       unsigned int seq;
> +       int len, rv;
> +       u64 *p;
> +
> +       WARN_ON(bb->shift < 0 || sectors =3D=3D 0);
> +
> +       if (bb->shift > 0) {
> +               sector_t target;
> +
> +               /* round the start down, and the end up */
> +               target =3D s + sectors;
> +               rounddown(s, bb->shift);
> +               roundup(target, bb->shift);

The same question here. It needs to set s and target?

> +               sectors =3D target - s;
> +       }
> +
> +retry:
> +       seq =3D read_seqbegin(&bb->lock);
> +
> +       p =3D bb->page;
> +       unacked_badblocks =3D 0;
> +       acked_badblocks =3D 0;
> +
> +re_check:
> +       bad.start =3D s;
> +       bad.len =3D sectors;
> +
> +       if (badblocks_empty(bb)) {
> +               len =3D sectors;
> +               goto update_sectors;
> +       }
> +
> +       prev =3D prev_badblocks(bb, &bad, hint);

Is it better to add check prev < 0 as setting and clearing badblocks?
If not, in the following overlap_front check, it'll have problems when
prev is -1. p[-1] will be the last one element of the array.

> +
> +       /* start after all badblocks */
> +       if ((prev + 1) >=3D bb->count && !overlap_front(bb, prev, &bad)) =
{
> +               len =3D sectors;
> +               goto update_sectors;
> +       }
> +
> +       if (overlap_front(bb, prev, &bad)) {
> +               if (BB_ACK(p[prev]))
> +                       acked_badblocks++;
> +               else
> +                       unacked_badblocks++;
> +
> +               if (BB_END(p[prev]) >=3D (s + sectors))
> +                       len =3D sectors;
> +               else
> +                       len =3D BB_END(p[prev]) - s;
> +
> +               if (set =3D=3D 0) {
> +                       *first_bad =3D BB_OFFSET(p[prev]);
> +                       *bad_sectors =3D BB_LEN(p[prev]);

Is it right to set bad_sectors with len?

> +                       set =3D 1;
> +               }
> +               goto update_sectors;
> +       }
> +
> +       /* Not front overlap, but behind overlap */
> +       if ((prev + 1) < bb->count && overlap_behind(bb, &bad, prev + 1))=
 {
> +               len =3D BB_OFFSET(p[prev + 1]) - bad.start;
> +               hint =3D prev + 1;
> +               goto update_sectors;
> +       }
> +
> +       /* not cover any badblocks range in the table */
> +       len =3D sectors;
> +
> +update_sectors:
> +       s +=3D len;
> +       sectors -=3D len;
> +
> +       if (sectors > 0)
> +               goto re_check;
> +
> +       WARN_ON(sectors < 0);
> +
> +       if (unacked_badblocks > 0)
> +               rv =3D -1;
> +       else if (acked_badblocks > 0)
> +               rv =3D 1;
> +       else
> +               rv =3D 0;
> +
> +       if (read_seqretry(&bb->lock, seq))
> +               goto retry;
> +
> +       return rv;
> +}
>
>  /**
>   * badblocks_check() - check a given range for bad sectors
> --
> 2.35.3
>

Reviewed-by: Xiao Ni <xni@redhat.com>


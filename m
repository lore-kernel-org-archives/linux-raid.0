Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA08C6FD18
	for <linux-raid@archiver.kernel.org>; Wed, 19 Apr 2023 15:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233554AbjDSPWe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 Apr 2023 11:22:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjDSPWc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 19 Apr 2023 11:22:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471177D87
        for <linux-raid@vger.kernel.org>; Wed, 19 Apr 2023 08:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681917587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tk4ILYUitykXDNv2nAhy0f5ydU+4a31pQqGhvmwhdPk=;
        b=MQyh0fUsEl95V78I8bk8Y1T6hmtsoiX3CxFKDjwvqrIlQ6To4e75tvKksorrlD/sDbgfDk
        nzucP2+xwPFzmt2xbz8yHdSMmMc8iWdpwPsaJ/v8xoPjLskQ2OVgDrhAfDniM8wNd1yG4/
        vHly6wGppWfgBBDmmORzbJ7nJ2hT5EE=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-vYeWiBSIPkWhSE1dOk_RmA-1; Wed, 19 Apr 2023 11:19:45 -0400
X-MC-Unique: vYeWiBSIPkWhSE1dOk_RmA-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-24b28355b5eso453971a91.0
        for <linux-raid@vger.kernel.org>; Wed, 19 Apr 2023 08:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681917584; x=1684509584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tk4ILYUitykXDNv2nAhy0f5ydU+4a31pQqGhvmwhdPk=;
        b=VxLFgIg7pEszzE1Ki9pCunujlY6oXishET98KrvkQZ8B557D8JfMT/RuMoZzn8oCPH
         Z7XRTvIaRGnd75Ted2Y+oBz/qDVufUQE8saSd54wR7eFrQ2Ew3nqDjGOnEhZr3x9DV2g
         qe2jFIPPe6ZsI0HLTnlNNk3ePZ2ZfeaVTpWY7/X8Nj6Lw031g+rS4JxBh53MeyLgzl9z
         8DG//vUkgK6ul05jnyCE4nOl8N2kT2bRxTwKm301yEkTsp1HLEhwDYMaU8BvuzbtM0k5
         r3qieeLmq0UwfsJz4KsRWE/5IaDVx908ltKHkBerS9Cxhe18qFaZ4rBy5c4iDcgWDZMZ
         O/zQ==
X-Gm-Message-State: AAQBX9ct9ZWzruAXjeEBE9DyuTv0t0iX64Y2Yyr/gK8U7a16Xa75xneF
        ryLARfKSylKZQiFNSzDn7c51EZLywXRQZ0n3WrrRZT9vE0H494XG29s7tVEna4+wmTqEV6N5Kdi
        GSVX5FDOz9AB30Dm7f+JtKgyjW8l8xpGMSGq7MA==
X-Received: by 2002:a17:90a:2ca4:b0:247:fec:3cf with SMTP id n33-20020a17090a2ca400b002470fec03cfmr1032472pjd.9.1681917584665;
        Wed, 19 Apr 2023 08:19:44 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZilzTP35l+fCVfSRmyAr7TA2z2HByJ2c77EoLXxjUVlBIE5WaJ/vbFqG27YJf1gGuB7p5La9B7yskBhiQ6yjg=
X-Received: by 2002:a17:90a:2ca4:b0:247:fec:3cf with SMTP id
 n33-20020a17090a2ca400b002470fec03cfmr1032449pjd.9.1681917584368; Wed, 19 Apr
 2023 08:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230419140929.5924-1-jth@kernel.org> <20230419140929.5924-12-jth@kernel.org>
In-Reply-To: <20230419140929.5924-12-jth@kernel.org>
From:   Andreas Gruenbacher <agruenba@redhat.com>
Date:   Wed, 19 Apr 2023 17:19:31 +0200
Message-ID: <CAHc6FU6U1yZguZGeCc7BUqd1Qm4+SSRK8xbNZWBUSXTk_jjvVQ@mail.gmail.com>
Subject: Re: [PATCH v3 11/19] gfs: use __bio_add_page for adding single page
 to bio
To:     Johannes Thumshirn <jth@kernel.org>
Cc:     axboe@kernel.dk, johannes.thumshirn@wdc.com,
        cluster-devel@redhat.com, damien.lemoal@wdc.com,
        dm-devel@redhat.com, dsterba@suse.com, hare@suse.de, hch@lst.de,
        jfs-discussion@lists.sourceforge.net, kch@nvidia.com,
        linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-raid@vger.kernel.org, ming.lei@redhat.com,
        rpeterso@redhat.com, shaggy@kernel.org, snitzer@kernel.org,
        song@kernel.org, willy@infradead.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Apr 19, 2023 at 4:10=E2=80=AFPM Johannes Thumshirn <jth@kernel.org>=
 wrote:
>
> From: Johannes Thumshirn <johannes.thumshirn@wdc.com>
>
> The GFS superblock reading code uses bio_add_page() to add a page to a
> newly created bio. bio_add_page() can fail, but the return value is never
> checked.

It's GFS2, not GFS, but otherwise this is obviously fine, thanks.

> Use __bio_add_page() as adding a single page to a newly created bio is
> guaranteed to succeed.
>
> This brings us a step closer to marking bio_add_page() as __must_check.
>
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>

> ---
>  fs/gfs2/ops_fstype.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> index 6de901c3b89b..e0cd0d43b12f 100644
> --- a/fs/gfs2/ops_fstype.c
> +++ b/fs/gfs2/ops_fstype.c
> @@ -254,7 +254,7 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sect=
or_t sector, int silent)
>
>         bio =3D bio_alloc(sb->s_bdev, 1, REQ_OP_READ | REQ_META, GFP_NOFS=
);
>         bio->bi_iter.bi_sector =3D sector * (sb->s_blocksize >> 9);
> -       bio_add_page(bio, page, PAGE_SIZE, 0);
> +       __bio_add_page(bio, page, PAGE_SIZE, 0);
>
>         bio->bi_end_io =3D end_bio_io_page;
>         bio->bi_private =3D page;
> --
> 2.39.2
>


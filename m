Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545FEC77B7C
	for <linux-raid@archiver.kernel.org>; Mon, 29 May 2023 02:09:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjE2CJN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 May 2023 22:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjE2CJM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 May 2023 22:09:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F29B8
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 19:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685326106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AbyioSjEjgCtreOl+SY/+6LyBBaGmfJDOkl2mVsy5Jc=;
        b=Dx+LIq2qw1uhRoE7FdZVJ8zFz4MrU8XKS20fkiHVQWCLi2R2e/Sjpf28ZJ1NzBwNcnE4pW
        YHD4GA8AlNJLYr9LzoGTHFsAWtVorBhxVuS//YWttCazg1lccniIHudEspV1WkBvOjFoXT
        P1BpNYzjbw0KD4Rw9qdO/rxj7P6B9cA=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-lRNKeLtnNuSzo4i8y-yB2Q-1; Sun, 28 May 2023 22:08:25 -0400
X-MC-Unique: lRNKeLtnNuSzo4i8y-yB2Q-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2534d7abebeso1717642a91.0
        for <linux-raid@vger.kernel.org>; Sun, 28 May 2023 19:08:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685326104; x=1687918104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AbyioSjEjgCtreOl+SY/+6LyBBaGmfJDOkl2mVsy5Jc=;
        b=ApNk1qF9gHlHuqgL3HWjn+PI00kbEffia8/Lon9DTimb8ebiTcw+cQRPwm0+lNf4zu
         2XtD6NTURCrRuit8qa8NUiPq00QXGP5tYHWXROtGvcLUOiX/XRsWzpiTbM/U6FTags7g
         gUtxuhBGzSciK2XrOQKM+l4q4cxWlQtbZVa1y89bSgGOdNiVwoWlU79DHJ+D+yxPbSyu
         cW4j2SFDnb3bH9sJgY0o0xi0vb5dT3+dP9JcUh0MrXhHyOuaxhqxYxMjJpFIuk/KBe3t
         ZaUb2rdPRTpYRaX/PS/d4ne+6rukDbmH0onaKNSVfVX/qBJnlwAWrrKBbe3neKlke3Fm
         PMOQ==
X-Gm-Message-State: AC+VfDxwRreMRym9SxdEWfaQRhNX2aYfZ4XquyeviU346TFnKdo4HVqn
        g3U2APIHXnBkDYgY7GgRfniqf1ePlRdHROQPKDg/lCC5r9AbynmMlmOviw2AYEMJ1Wtic6Q+h1i
        y/B+WNZyhosd5HamOCOe1RxXy7E8OvsLhMOtp6w==
X-Received: by 2002:a17:90a:cf04:b0:250:3bc3:2b09 with SMTP id h4-20020a17090acf0400b002503bc32b09mr10237964pju.12.1685326104472;
        Sun, 28 May 2023 19:08:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6XsC7IMaTvJIjrfmEIIl/rt2pxEygBKhwCfn5FHtdvn75nyBZMC6W8+Ko1uYXXwnl+R8u4bkyfKUv1kr3TUvs=
X-Received: by 2002:a17:90a:cf04:b0:250:3bc3:2b09 with SMTP id
 h4-20020a17090acf0400b002503bc32b09mr10237948pju.12.1685326104143; Sun, 28
 May 2023 19:08:24 -0700 (PDT)
MIME-Version: 1.0
References: <20230426082031.1299149-1-yukuai1@huaweicloud.com> <20230426082031.1299149-8-yukuai1@huaweicloud.com>
In-Reply-To: <20230426082031.1299149-8-yukuai1@huaweicloud.com>
From:   Xiao Ni <xni@redhat.com>
Date:   Mon, 29 May 2023 10:08:13 +0800
Message-ID: <CALTww2-yTsHXNFgkAVu0v++HHahZCnvXEUv2qJqbvcGUhKanDw@mail.gmail.com>
Subject: Re: [PATCH -next v2 7/7] md/raid1-10: limit the number of plugged bio
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     song@kernel.org, akpm@osdl.org, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Kuai

There is a limitation of the memory in your test. But for most
situations, customers should not set this. Can this change introduce a
performance regression against other situations?

Best Regards
Xiao

On Wed, Apr 26, 2023 at 4:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> bio can be added to plug infinitely, and following writeback test can
> trigger huge amount of plugged bio:
>
> Test script:
> modprobe brd rd_nr=3D4 rd_size=3D10485760
> mdadm -CR /dev/md0 -l10 -n4 /dev/ram[0123] --assume-clean
> echo 0 > /proc/sys/vm/dirty_background_ratio
> echo 60 > /proc/sys/vm/dirty_ratio
> fio -filename=3D/dev/md0 -ioengine=3Dlibaio -rw=3Dwrite -bs=3D4k -numjobs=
=3D1 -iodepth=3D128 -name=3Dtest
>
> Test result:
> Monitor /sys/block/md0/inflight will found that inflight keep increasing
> until fio finish writing, after running for about 2 minutes:
>
> [root@fedora ~]# cat /sys/block/md0/inflight
>        0  4474191
>
> Fix the problem by limiting the number of plugged bio based on the number
> of copies for original bio.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1-10.c | 9 ++++++++-
>  drivers/md/raid1.c    | 2 +-
>  drivers/md/raid10.c   | 2 +-
>  3 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 98d678b7df3f..35fb80aa37aa 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -21,6 +21,7 @@
>  #define IO_MADE_GOOD ((struct bio *)2)
>
>  #define BIO_SPECIAL(bio) ((unsigned long)bio <=3D 2)
> +#define MAX_PLUG_BIO 32
>
>  /* for managing resync I/O pages */
>  struct resync_pages {
> @@ -31,6 +32,7 @@ struct resync_pages {
>  struct raid1_plug_cb {
>         struct blk_plug_cb      cb;
>         struct bio_list         pending;
> +       unsigned int            count;
>  };
>
>  static void rbio_pool_free(void *rbio, void *data)
> @@ -127,7 +129,7 @@ static inline void md_submit_write(struct bio *bio)
>  }
>
>  static inline bool md_add_bio_to_plug(struct mddev *mddev, struct bio *b=
io,
> -                                     blk_plug_cb_fn unplug)
> +                                     blk_plug_cb_fn unplug, int copies)
>  {
>         struct raid1_plug_cb *plug =3D NULL;
>         struct blk_plug_cb *cb;
> @@ -147,6 +149,11 @@ static inline bool md_add_bio_to_plug(struct mddev *=
mddev, struct bio *bio,
>
>         plug =3D container_of(cb, struct raid1_plug_cb, cb);
>         bio_list_add(&plug->pending, bio);
> +       if (++plug->count / MAX_PLUG_BIO >=3D copies) {
> +               list_del(&cb->list);
> +               cb->callback(cb, false);
> +       }
> +
>
>         return true;
>  }
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 639e09cecf01..c6066408a913 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1562,7 +1562,7 @@ static void raid1_write_request(struct mddev *mddev=
, struct bio *bio,
>                                               r1_bio->sector);
>                 /* flush_pending_writes() needs access to the rdev so...*=
/
>                 mbio->bi_bdev =3D (void *)rdev;
> -               if (!md_add_bio_to_plug(mddev, mbio, raid1_unplug)) {
> +               if (!md_add_bio_to_plug(mddev, mbio, raid1_unplug, disks)=
) {
>                         spin_lock_irqsave(&conf->device_lock, flags);
>                         bio_list_add(&conf->pending_bio_list, mbio);
>                         spin_unlock_irqrestore(&conf->device_lock, flags)=
;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index bd9e655ca408..7135cfaf75db 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1306,7 +1306,7 @@ static void raid10_write_one_disk(struct mddev *mdd=
ev, struct r10bio *r10_bio,
>
>         atomic_inc(&r10_bio->remaining);
>
> -       if (!md_add_bio_to_plug(mddev, mbio, raid10_unplug)) {
> +       if (!md_add_bio_to_plug(mddev, mbio, raid10_unplug, conf->copies)=
) {
>                 spin_lock_irqsave(&conf->device_lock, flags);
>                 bio_list_add(&conf->pending_bio_list, mbio);
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> --
> 2.39.2
>


Return-Path: <SRS0=wQ6l=CG=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55418C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 07:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2382120CC7
	for <linux-raid@archiver.kernel.org>; Fri, 28 Aug 2020 07:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598598215;
	bh=ZFE72OFAgOrfVe5aXsNii1HXODaJ9DGQn8J2EMa5Ilc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=GkYbPxfsmIrDrY5gDnZVIvvbyuWHtg0eU3L5YBAl48VZALi4H/U7Ari65eLcCFVlR
	 p+Pcxb7iq2CtfTUmD/fMFJarUghbXnIKWULfx9KSqcRkF+Sr8opJX2F2m8sOuzg3Ui
	 kDwZCy4DOye51j2sOxOy1DT2doKGQPCAZCfnhzVU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgH1HDe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Aug 2020 03:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbgH1HDe (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 28 Aug 2020 03:03:34 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B22C20CC7
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 07:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598598213;
        bh=ZFE72OFAgOrfVe5aXsNii1HXODaJ9DGQn8J2EMa5Ilc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iDIE4kfiVnjVXdocZSkun62TbNUKG4b9oXIVz1Z6sbxNUPj96rMJWH0e+0w6x54+l
         jo4gynFd4j5VRfyxSt8qXB9gQgkKeeWYfFmfVTlRZBeKj5uPVM52dUUATnT1J6inlQ
         MN03Il8mVxSnunzgG1J8ennJVSjSp63skIC0Oyh4=
Received: by mail-lf1-f47.google.com with SMTP id s9so163015lfs.4
        for <linux-raid@vger.kernel.org>; Fri, 28 Aug 2020 00:03:33 -0700 (PDT)
X-Gm-Message-State: AOAM5324Jj527cLxihTXTIYjsEA3XqUSxagwXwxAvOlYICLI3L2vdYsM
        NK8jQSSR99UN0eM8OcV857pFj/kCmSAeZmnUR1o=
X-Google-Smtp-Source: ABdhPJzEgGYSjk55kAP8Wfro7UbWVg8mtUnegc+zUfterrejaZDNZVe6UYPpWfKnZ37/Oq58/b0V1wfYi98eJVaRbqo=
X-Received: by 2002:a19:6b1a:: with SMTP id d26mr115500lfa.138.1598598211823;
 Fri, 28 Aug 2020 00:03:31 -0700 (PDT)
MIME-Version: 1.0
References: <1598334183-25301-1-git-send-email-xni@redhat.com> <1598334183-25301-6-git-send-email-xni@redhat.com>
In-Reply-To: <1598334183-25301-6-git-send-email-xni@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 28 Aug 2020 00:03:20 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5X7XnNX9UHiEv5wUzCNUtXG36gWz+pgZ2HPNf7NFN5Sg@mail.gmail.com>
Message-ID: <CAPhsuW5X7XnNX9UHiEv5wUzCNUtXG36gWz+pgZ2HPNf7NFN5Sg@mail.gmail.com>
Subject: Re: [PATCH V5 5/5] md/raid10: improve discard request for far layout
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        Coly Li <colyli@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Aug 24, 2020 at 10:43 PM Xiao Ni <xni@redhat.com> wrote:
>
> For far layout, the discard region is not continuous on disks. So it needs
> far copies r10bio to cover all regions. It needs a way to know all r10bios
> have finish or not. Similar with raid10_sync_request, only the first r10bio
> master_bio records the discard bio. Other r10bios master_bio record the
> first r10bio. The first r10bio can finish after other r10bios finish and
> then return the discard bio.
>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  drivers/md/raid10.c | 87 +++++++++++++++++++++++++++++++++++++++--------------
>  drivers/md/raid10.h |  1 +
>  2 files changed, 65 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 257791e..f6518ea 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1534,6 +1534,29 @@ static struct bio *raid10_split_bio(struct r10conf *conf,
>         return bio;
>  }
>
> +static void raid_end_discard_bio(struct r10bio *r10bio)

Let's name this raid10_*

> +{
> +       struct r10conf *conf = r10bio->mddev->private;
> +       struct r10bio *first_r10bio;
> +
> +       while (atomic_dec_and_test(&r10bio->remaining)) {

Should this be "if (atomic_*"?

Thanks,
Song

[...]

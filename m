Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A31C4320E
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B454F60ED3
	for <linux-raid@archiver.kernel.org>; Thu, 26 Aug 2021 16:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243008AbhHZQR5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Aug 2021 12:17:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:43960 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232555AbhHZQR4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 26 Aug 2021 12:17:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7130361073;
        Thu, 26 Aug 2021 16:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629994629;
        bh=ys6he2EKXxTAf6clEHiF8vGsFUEvrMasLHaxf8mzwqU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qWlV8X3zhQL7ddx2KWYFTqr5EdBwa+JOIt5Zoj3+tMKIkib6ug1aLVBIxz0zIYdlX
         WSqNUL9oY5ZEhUvWAbD3izq/iRjGMNE/wjh0bK5bIjLcGo7iEjM3aolPoQnayp2Xea
         G5OXIlE/iCJ6JbArRdywGR3X2D5Hs1Pzh6xClcyyeN66xVWaj561t8N3q3c7yJjkIB
         LklFoKHJuNywIqH556gBKBvhiEP42a13pnpAIU8OutKN6/LKuyiXzo/Hzonh8rcXoM
         +grJ8wShIWw+05PCIObZFP/xumGzMuJdzTleqgFdaKgN7WZJMcorvKIoLu1GbAntZY
         I/OHk9Y4ScYYA==
Received: by mail-lj1-f174.google.com with SMTP id h1so6114718ljl.9;
        Thu, 26 Aug 2021 09:17:09 -0700 (PDT)
X-Gm-Message-State: AOAM530K7HhJvzbAUNEGyyLmTTGvoZLuuFQ+Owu6igg03r7afQtB1Rtf
        GR9h352eAvLhtED0aoEmEVkcKpVLwYPENF8iayQ=
X-Google-Smtp-Source: ABdhPJxyDEbUewF9N87rEwVKZgJsGCp9TEPJLavwLve9L9gaQWOUW1NNuSAlENQ1pmdyFn6c6Bslr/c0nv3m2rn5Pl4=
X-Received: by 2002:a2e:9247:: with SMTP id v7mr3837591ljg.97.1629994627859;
 Thu, 26 Aug 2021 09:17:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210824011654.3829681-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mivBeA0uYGT-Z9UR7h_B=4Mp+BGqzrAW9BmNysQcGTw@mail.gmail.com> <01dec1bc-5e3a-4237-6280-f0a480e6231f@linux.dev>
In-Reply-To: <01dec1bc-5e3a-4237-6280-f0a480e6231f@linux.dev>
From:   Song Liu <song@kernel.org>
Date:   Thu, 26 Aug 2021 09:16:56 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7jYhOCsTcoT54_y12RWLw-wj3iPGO1a=vd37L7khxn3g@mail.gmail.com>
Message-ID: <CAPhsuW7jYhOCsTcoT54_y12RWLw-wj3iPGO1a=vd37L7khxn3g@mail.gmail.com>
Subject: Re: [PATCH V4] raid1: ensure write behind bio has less than
 BIO_MAX_VECS sectors
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 24, 2021 at 5:44 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>
>
>
> On 8/25/21 5:55 AM, Song Liu wrote:
> > On Mon, Aug 23, 2021 at 6:17 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
> >> From: Guoqing Jiang <jiangguoqing@kylinos.cn>
> >>
> >> We can't split write behind bio with more than BIO_MAX_VECS sectors,
> >> otherwise the below call trace was triggered because we could allocate
> >> oversized write behind bio later.
> >>
> >> [ 8.097936] bvec_alloc+0x90/0xc0
> >> [ 8.098934] bio_alloc_bioset+0x1b3/0x260
> >> [ 8.099959] raid1_make_request+0x9ce/0xc50 [raid1]
> >> [ 8.100988] ? __bio_clone_fast+0xa8/0xe0
> >> [ 8.102008] md_handle_request+0x158/0x1d0 [md_mod]
> >> [ 8.103050] md_submit_bio+0xcd/0x110 [md_mod]
> >> [ 8.104084] submit_bio_noacct+0x139/0x530
> >> [ 8.105127] submit_bio+0x78/0x1d0
> >> [ 8.106163] ext4_io_submit+0x48/0x60 [ext4]
> >> [ 8.107242] ext4_writepages+0x652/0x1170 [ext4]
> >> [ 8.108300] ? do_writepages+0x41/0x100
> >> [ 8.109338] ? __ext4_mark_inode_dirty+0x240/0x240 [ext4]
> >> [ 8.110406] do_writepages+0x41/0x100
> >> [ 8.111450] __filemap_fdatawrite_range+0xc5/0x100
> >> [ 8.112513] file_write_and_wait_range+0x61/0xb0
> >> [ 8.113564] ext4_sync_file+0x73/0x370 [ext4]
> >> [ 8.114607] __x64_sys_fsync+0x33/0x60
> >> [ 8.115635] do_syscall_64+0x33/0x40
> >> [ 8.116670] entry_SYSCALL_64_after_hwframe+0x44/0xae
> >>
> >> Thanks for the comment from Christoph.
> >>
> >> [1]. https://bugs.archlinux.org/task/70992
> >>
> >> Reported-by: Jens Stutte <jens@chianterastutte.eu>
> >> Tested-by: Jens Stutte <jens@chianterastutte.eu>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >> Signed-off-by: Guoqing Jiang <jiangguoqing@kylinos.cn>
> > I am confused. Which tree does this apply to?
>
> Sorry, I forgot to mention it in this version (actually it is v4). It
> depends
> on commit 018eca456c4b4dca56aaf1ec27f309c74d0fe246 in block tree
> for-next branch, so it would be better to be picked by block tree for now
> to avoid compile issue,  or after you rebase md tree from block tree with
> that commit included.

 I replaced PAGE_SECTORS with (PAGE_SIZE >> 9). And applied it to md-next.

Thanks,
Song

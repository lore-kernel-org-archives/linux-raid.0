Return-Path: <SRS0=1EIv=EJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5613C388F7
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 20:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 624CB206F1
	for <linux-raid@archiver.kernel.org>; Tue,  3 Nov 2020 20:12:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=drivescale-com.20150623.gappssmtp.com header.i=@drivescale-com.20150623.gappssmtp.com header.b="O7zOsHoJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728527AbgKCUMP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Nov 2020 15:12:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCUMO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Nov 2020 15:12:14 -0500
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9C5C0617A6
        for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2020 12:12:13 -0800 (PST)
Received: by mail-ot1-x341.google.com with SMTP id y22so6687696oti.10
        for <linux-raid@vger.kernel.org>; Tue, 03 Nov 2020 12:12:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=drivescale-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=csm6WJIqkvgmHgjyFbVOCKjF/qQY6zaL8P5DbbzYf5w=;
        b=O7zOsHoJsyNmSctB0hK/p1kq9D4Cf8l1PE33c5vl9PD3ENNqc46es0CXlSAKn3elQC
         vBj7lEgL1EUxhewi8dyETj92Cp60JPR/ydwC9dZZY9SeebuEtot5UC2VXxo0s8f5s19r
         BHnOxC/7Qy5YMXKJZN6T7VR7RnDZKx3TBGvgYpyUuxNTyr9KBiylO77bEpg2S6v7ZeYW
         bqFHs81C5qtwfz82Twd7VX7U0z7vpmboXKwB57B7dSlCGVguiYWN7kJapx8OVNo5av+j
         yRf/JR9az66TlaVbxQLRlHn6OvCymaxY6I1Id7aHMXDai/L9xZwNrBuDf22FxSwqLFSg
         tNhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=csm6WJIqkvgmHgjyFbVOCKjF/qQY6zaL8P5DbbzYf5w=;
        b=AQ8yoWcTrDXq/fvhVtLlqWAl2kmf8+zR0TYOO5RHQ8vax+U4tajVikyaWNXsizU/GF
         ZG1sBn1t11gzfWprjl7FSB+x/O++H1jkp/NzsHt2Udeuf4MUFl1XhimWLFwc4Mk8K6SE
         AfShuNF4fUgk0J2sy9j7Ipam62C32kWt/DO4WfupTpjAT1sGK+yARS1bnYd5x2xLnQhu
         W8BUAm1WgJnROvTx+/FwKjIK7EapMotsY5QfezG9SRuH8PmCly8YJm5qqeXRyvZY33KW
         GV6I1w4f4WFW5ARWym7Xr5Fgi2nQEkByqJGzd3QpISNxVhJNmkFwrLj2K6yFdZga9wHe
         FgQQ==
X-Gm-Message-State: AOAM532vaqUnaOvdwSoeGQqtpHdYlL1jstGoSJ8YDI6uectjtnkYagVL
        mIGAUlXnHdDxEG4ryN0gRUJ4imWUjuhSpHikQiGb9w==
X-Google-Smtp-Source: ABdhPJz5PAXuw4nvCoOi2WMbeaAaYxFbUwsUxwUrIuKo9hsfaVXO5qZ3KTaQqFX7qJ+DkibTNBKBkh6JeDQfHPHfPac=
X-Received: by 2002:a9d:7cd7:: with SMTP id r23mr15671271otn.228.1604434332404;
 Tue, 03 Nov 2020 12:12:12 -0800 (PST)
MIME-Version: 1.0
References: <20201029201358.29181-1-cunkel@drivescale.com> <265efd48-b0c6-cba5-c77e-5efb0e6b9e00@redhat.com>
In-Reply-To: <265efd48-b0c6-cba5-c77e-5efb0e6b9e00@redhat.com>
From:   Chris Unkel <cunkel@drivescale.com>
Date:   Tue, 3 Nov 2020 12:12:00 -0800
Message-ID: <CAHFUYDo23BBq0R5mZBZgcCEzE=rN_ZYHCZp5WEs-nBZwYeyEnA@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] md superblock write alignment on 512e devices
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Thanks for the excellent feedback.  Since bitmap_offset appears to be
a free-form field, it wasn't apparent to me that the bitmap never
starts within 4K of the bitmap.

I don't think it's worth worrying about a logical block size that's
more than 4K here--from what I can see logical block size larger than
the usual 4K page isn't going to happen.

I do think that it makes sense to handle the case where the physical
block size is more than 4K.  I think what you propose works, but I
think in the physical block > MAX_SB_SIZE case it makes more sense to
align the superblock writes to the physical block size (as now) rather
than rejecting the create/assemble.  Mounting with the possible
performance hit seems like a better outcome for the user in that case
than refusing to assemble.
It's the same check that would have to be written to reject the
assembly in that case and so the code shouldn't really be any more
complex.

So basically what I propose is:  if the physical block size is no
larger than MAX_SB_SIZE, pad to that; otherwise pad to to
logical_block_size, that is, replace queue_logical_block_size()
with something equivalent to:

    queue_physical_block_size(...) > MAX_SB_SIZE ?
queue_logical_block_size(...) : queue_physical_block_size(...)

which is simple, safe in all cases, doesn't reject any feasible
assembly, and generates aligned sb writes on all common current
devices (512n,4kn,512e.)

What do you think?

Regards,

  --Chris

On Sun, Nov 1, 2020 at 11:43 PM Xiao Ni <xni@redhat.com> wrote:
>
>
>
> On 10/30/2020 04:13 AM, Christopher Unkel wrote:
> > Hello,
> >
> > Thanks for the feedback on the previous patch series.
> >
> > A updated patch series with the same function as the first patch
> > (https://lkml.org/lkml/2020/10/22/1058 "md: align superblock writes to
> > physical blocks") follows.
> >
> > As suggested, it introduces a helper function, which can be used to
> > reduce some code duplication.  It handles the case in super_1_sync()
> > where the superblock is extended by the addition of new component
> > devices.
> >
> > I think it also fixes a bug where the existing code in super_1_load()
> > ought to be rejecting the array with EINVAL: if the superblock padded
> > out to the *logical* block length runs into the bitmap.  For example, if
> > the bitmap offset is 2 (bitmap 1K after superblock) and the logical
> > block size is 4K, the superblock padded out to 4K runs into the bitmap.
> > This case may be unusual (perhaps only happens if the array is created
> > on a 512n device and then raw contents are copied onto a 4kn device) but
> > I think it is possible.
> Hi Chris
> For super1.1 and super1.2 bitmap offset is 8. It's a fixed value. So it
> should
> not have the risk?
>
> But for future maybe it has this problem. If the disk logical or
> physical block size
> is larger than 4K in future, it has data corruption risk.
> >
> > With respect to the option of simply replacing
> > queue_logical_block_size() with queue_physical_block_size(), I think
> > this can result in the code rejecting devices that can be loaded, but
> In mdadm it defines the max super size of super1 is 4096
> #define MAX_SB_SIZE 4096
> /* bitmap super size is 256, but we round up to a sector for alignment */
> #define BM_SUPER_SIZE 512
> #define MAX_DEVS ((int)(MAX_SB_SIZE - sizeof(struct mdp_superblock_1)) / 2)
> #define SUPER1_SIZE     (MAX_SB_SIZE + BM_SUPER_SIZE \
>                           + sizeof(struct misc_dev_info))
>
> It should be ok to replace queue_logical_block_size with
> queue_physical_block_size?
> Now it doesn't check physical block size and super block size. For
> super1, we can add
> a check that if physical block size is larger than MAX_SB_SIZE, then we
> reject to create/assmble
> the raid device.
> > for which the physical block alignment can't be respected--the longer
> > padded size would trigger the EINVAL cases testing against
> > data_offset/new_data_offset.  I think it's better to proceed in such
> > cases, just with unaligned superblock writes as would presently happen.
> > Also if I'm right about the above bug, then I think this subsitution
> > would be more likely to trigger it.
> >
> > Thanks,
> >
> >    --Chris
> >
> >
> > Christopher Unkel (3):
> >    md: factor out repeated sb alignment logic
> >    md: align superblock writes to physical blocks
> >    md: reuse sb length-checking logic
> >
> >   drivers/md/md.c | 69 +++++++++++++++++++++++++++++++++++++------------
> >   1 file changed, 52 insertions(+), 17 deletions(-)
> >
>

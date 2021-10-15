Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57A50C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45D30611CE
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 16:54:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbhJOQ4Q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241775AbhJOQ4K (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Oct 2021 12:56:10 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90479C06176A
        for <linux-raid@vger.kernel.org>; Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id y7so8847300pfg.8
        for <linux-raid@vger.kernel.org>; Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+MbYp/9I6HwSPkAmORgtqKp7aAXKpROAHsI0KkahVSk=;
        b=ikEdVtNf9eRQss1RELdYd+gQGtRkJJNUyxABmsyhavxmXS/GWW1GmjaIFqcZC+V7d0
         jxPVuirO3PDa+xeNqLrVJO8s8KcCPrKVcuz5mnU+QJTWjswUytrClmIjf52ECv87VZwj
         IWYURypnyInULxZ6QO8cmc8sNxz7IQsLEMu78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+MbYp/9I6HwSPkAmORgtqKp7aAXKpROAHsI0KkahVSk=;
        b=6R4FwyVcD88rz2t0nqkmwAXnlbSWSd0+LJfghykXL7M6wteId8b/EvDeb9YybX1Zip
         MZgWW+zCk4Z5NKmp74C8c/xiC7C+d5/Z6BQF57P+QscifaQy6z2xVVFImo3Zhu209KcG
         P0Qvdcaz7UpY5uYYRUemXlqBz+IiFXOjF39fSzALqU7MSMAMrmvPAmU+Q5QRqeqqv3mu
         nCIE+yLnv8SNyaotsKZuwwjUyNka56Bkd3r+5MWrBtdRyee22NsM7LfU3+nbvUv5YkNQ
         uJgauChZ5BfF5j3MJwlzaqM7l6koACcQTqYXlGsO/inpaBrr8bfSwfUj2U9rkYA41Cj3
         JLAw==
X-Gm-Message-State: AOAM531/0Iws3KNEjz89HlNaDiMMhlX61xLJa/pFzfuBI0CvooQ89UkV
        dW82ZOKfMjBCI6hfmz24bORkzA==
X-Google-Smtp-Source: ABdhPJxRzD0WBfqSsRnsWWctoiC4ZL/68Vbzs2wYW5pL6AgqTKpTz7zCXFAYZWzBRrc637AgBAl43A==
X-Received: by 2002:a63:7f0e:: with SMTP id a14mr3656783pgd.390.1634316842164;
        Fri, 15 Oct 2021 09:54:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b8sm5387267pfi.103.2021.10.15.09.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:54:01 -0700 (PDT)
Date:   Fri, 15 Oct 2021 09:54:01 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        Mike Snitzer <snitzer@redhat.com>, Song Liu <song@kernel.org>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net, linux-nfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ntfs3@lists.linux.dev, reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 18/30] nfs/blocklayout: use bdev_nr_bytes instead of open
 coding it
Message-ID: <202110150953.4A7CC49DC@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-19-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-19-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:31PM +0200, Christoph Hellwig wrote:
> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

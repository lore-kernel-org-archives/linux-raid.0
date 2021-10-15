Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B31C433FE
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 15:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5291F610E5
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 15:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbhJOPr7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Oct 2021 11:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241009AbhJOPr6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 15 Oct 2021 11:47:58 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B517C061570
        for <linux-raid@vger.kernel.org>; Fri, 15 Oct 2021 08:45:52 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id 21so6621060plo.13
        for <linux-raid@vger.kernel.org>; Fri, 15 Oct 2021 08:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XFM5WavD2dlHj0k2cmbjEUH7DswNvraUTvaUeecsFLI=;
        b=kI3cmovLUq4/7b3XdGijH4QV2pLukclN+qtvDChdq76oCBSEjB/PxJ/LWqXaiWG3Ff
         e4ufh94HB0JHTcED5LMZgB7kXmiVxJYf75rZOCTtrAggeGm0/wa2OqJYCFCBhzazIF7l
         udxg7lVjqVFbJpk0sBDk4exc+CKZoXIIyRuqU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XFM5WavD2dlHj0k2cmbjEUH7DswNvraUTvaUeecsFLI=;
        b=CKbB2THfwFABaIyRm+tWmJz79o6yYZqLbYTLr2FNBzzmO5xAYocjAUc4w7/3Cw6rIS
         BWsTroR1O/NQ6iEe8o/Mw+FIFyNCZ31X4UNqXjTdLVs0b1VfV1IvvG2iY1iNFZpwpj4m
         rBEnWavTQc+rwuRCrnSBygr7lg8xbFEcbuHbB5iEUHSUhwsKjwGGnpjQYumYcTjJG6V1
         6Ms4cPhog552stPzKiCV8NE1hI51+5w4QR5M8TbzxC87QwPp4sOhkgEkgxPFQ8ZtKq2l
         qooB2Il/fd2UVeWnqcXiNhPHPvh5650C5RtWt3snPqF8tED1Ig1Kc9KwqeSqCYg9jplb
         Tz8A==
X-Gm-Message-State: AOAM532YmaZB2JDnC8jsboLtAEwaQkh4v5SprPUDT9jq2cfcTDqDbcqX
        Ph1StwCr0NtfPMe/39f7sV0LTg==
X-Google-Smtp-Source: ABdhPJwzQs+V6r1hPLOTwtZOgiRq0ZYBjWTuzen8H9dNT74QaE01sJDiES/7Q1kbrrYk+yq2JOau2g==
X-Received: by 2002:a17:90a:86:: with SMTP id a6mr28243106pja.190.1634312751709;
        Fri, 15 Oct 2021 08:45:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g17sm5328859pfu.22.2021.10.15.08.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 08:45:51 -0700 (PDT)
Date:   Fri, 15 Oct 2021 08:45:50 -0700
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
Subject: Re: [PATCH 01/30] block: move the SECTOR_SIZE related definitions to
 blk_types.h
Message-ID: <202110150845.29BA04E647@keescook>
References: <20211015132643.1621913-1-hch@lst.de>
 <20211015132643.1621913-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211015132643.1621913-2-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Oct 15, 2021 at 03:26:14PM +0200, Christoph Hellwig wrote:
> Ensure these are always available for inlines in the various block layer
> headers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Awesome, yes. Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook

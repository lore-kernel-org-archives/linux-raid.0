Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24804C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0E9AA60E54
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 16:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236501AbhJMQpU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 12:45:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233774AbhJMQpT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 12:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634143395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DvE9A+LL2XADoLsMv/QT6HGglilUC7cXAXtJNsfa8lA=;
        b=IIypTiFYhWCZbUSA7VEpUQlZe+SKXR1aCyCxIeoqcvY99VskuswRyMMy2b0K556uJIiCjv
        Ox6qgb6HttmrXI9seTaJDYkZUlW9UeyOf+kL7QD/bz8MJ74DIoTbmWfaHbeNmatD8nYYnh
        K+JHChfxdua7U/XCkmmnTUNapGNrs3s=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-582-vabYohfMMUKVCS4HakC1sw-1; Wed, 13 Oct 2021 12:43:14 -0400
X-MC-Unique: vabYohfMMUKVCS4HakC1sw-1
Received: by mail-qt1-f199.google.com with SMTP id o14-20020a05622a138e00b002a79da5b350so1396072qtk.15
        for <linux-raid@vger.kernel.org>; Wed, 13 Oct 2021 09:43:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DvE9A+LL2XADoLsMv/QT6HGglilUC7cXAXtJNsfa8lA=;
        b=25G8wnqtbJN6RVrEszO0fI8gr/4oM5ki/XygfDKg45chBj9LI18noNwtfw6zsDI3yH
         K6s+oLsApJtRlySXU4RQ4Mto8qLcn37k3Rlg5Ni6CBDGHsvSTOLe64J+fLKTGG2FkKNE
         IL7wYJdAzlsryMTplW+vG+BqKASJ6qNXdWdgTH++LSrIgo5F2b17ey6d8WeDsC8mgmgU
         d9AKkzp+AfwOzJYzrqZUtQsSCEpAEbpk+MD+BaRn15rfApJ9mGqO+ovrb7xSIE3IAzXH
         eA8bZPmRlUWV1qlc3H4DB2W3zWjcuCA2dJlvJLJqu3ZXex79pv2I/3qoaMhFtuRes4Ou
         wJOA==
X-Gm-Message-State: AOAM533H+X3dKR2LAxRQo6vEcHG0wFe2REQEJIG50qubfSVcSHR7PWjW
        /lbFSQUJQXieBkpTeSMivPNsPympdCICL1sMmTb//fLxxqnMzDAmqYeQzQRNBKQYWt4j2BvTVwo
        cxCZJQVgt9mLcPkokssnw
X-Received: by 2002:ac8:7d02:: with SMTP id g2mr450225qtb.66.1634143393840;
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy4uQGBl82DdkygPL4oygkwPDtljuRYBV8+ESqW4tKnOahM7pZ+SYljUTQ3BKpa4FdVi33PjA==
X-Received: by 2002:ac8:7d02:: with SMTP id g2mr450159qtb.66.1634143393507;
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
Received: from localhost ([45.130.83.141])
        by smtp.gmail.com with ESMTPSA id q14sm77870qtl.73.2021.10.13.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:43:13 -0700 (PDT)
Date:   Wed, 13 Oct 2021 12:43:12 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Coly Li <colyli@suse.de>,
        David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Theodore Ts'o <tytso@mit.edu>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Ryusuke Konishi <konishi.ryusuke@gmail.com>,
        Anton Altaparmakov <anton@tuxera.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Kees Cook <keescook@chromium.org>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        dm-devel@redhat.com, drbd-dev@lists.linbit.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
        linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ntfs3@lists.linux.dev,
        reiserfs-devel@vger.kernel.org
Subject: Re: [PATCH 03/29] dm: use bdev_nr_sectors instead of open coding it
Message-ID: <YWcMoCZxfpUzKZQ+@redhat.com>
References: <20211013051042.1065752-1-hch@lst.de>
 <20211013051042.1065752-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013051042.1065752-4-hch@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Oct 13 2021 at  1:10P -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Use the proper helper to read the block device size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Mike Snitzer <snitzer@redhat.com>


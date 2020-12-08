Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797B3C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  8 Dec 2020 13:39:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51EF323A53
	for <linux-raid@archiver.kernel.org>; Tue,  8 Dec 2020 13:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729467AbgLHNiy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Dec 2020 08:38:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:37250 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728318AbgLHNiy (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 8 Dec 2020 08:38:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D7F11AD41;
        Tue,  8 Dec 2020 13:38:11 +0000 (UTC)
Date:   Tue, 8 Dec 2020 14:38:11 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Qian Cai <qcai@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: store a pointer to the block_device in struct bio (again)
Message-ID: <20201208133811.5versqznlcqvmkro@beryllium.lan>
References: <20201201165424.2030647-1-hch@lst.de>
 <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
 <20201208110403.GA22179@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201208110403.GA22179@lst.de>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Dec 08, 2020 at 12:04:03PM +0100, Christoph Hellwig wrote:
> can you send me details of your device mapper setup, e.g. which targets
> are used, are they used on top of whole device or partitions.  Do you
> use partitions on top of the dm devices?  Are any other stacking devices
> involved?

FWIW, I tried linux-next yesterday and got the root fs (btrfs)
corrupted. It is a very simple setup, just plain FS on SCSI device.

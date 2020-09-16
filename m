Return-Path: <SRS0=gUE6=CZ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A47C433E2
	for <linux-raid@archiver.kernel.org>; Wed, 16 Sep 2020 09:29:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC3F22226
	for <linux-raid@archiver.kernel.org>; Wed, 16 Sep 2020 09:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgIPJ3Z (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 16 Sep 2020 05:29:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:43094 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgIPJ3X (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 16 Sep 2020 05:29:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A4AFABD1;
        Wed, 16 Sep 2020 09:29:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 0C0D8DA7C7; Wed, 16 Sep 2020 11:28:09 +0200 (CEST)
Date:   Wed, 16 Sep 2020 11:28:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Minchan Kim <minchan@kernel.org>,
        linux-mtd@lists.infradead.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        drbd-dev@tron.linbit.com, linux-raid@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: Re: [PATCH 07/12] bdi: remove BDI_CAP_CGROUP_WRITEBACK
Message-ID: <20200916092809.GJ1791@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Song Liu <song@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Richard Weinberger <richard@nod.at>,
        Minchan Kim <minchan@kernel.org>, linux-mtd@lists.infradead.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, drbd-dev@tron.linbit.com,
        linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, cgroups@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
References: <20200910144833.742260-1-hch@lst.de>
 <20200910144833.742260-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910144833.742260-8-hch@lst.de>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 10, 2020 at 04:48:27PM +0200, Christoph Hellwig wrote:
> Just checking SB_I_CGROUPWB for cgroup writeback support is enough.
> Either the file system allocates its own bdi (e.g. btrfs), in which case
> it is known to support cgroup writeback, or the bdi comes from the block
> layer, which always supports cgroup writeback.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Acked-by: David Sterba <dsterba@suse.com>

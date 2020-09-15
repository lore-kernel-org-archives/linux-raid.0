Return-Path: <SRS0=ezIp=CY=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A9EBC2D0E0
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 07:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C945020897
	for <linux-raid@archiver.kernel.org>; Tue, 15 Sep 2020 07:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIOHHP (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:07:15 -0400
Received: from verein.lst.de ([213.95.11.211]:46699 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726073AbgIOHGO (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 15 Sep 2020 03:06:14 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9B14E68AFE; Tue, 15 Sep 2020 09:05:22 +0200 (CEST)
Date:   Tue, 15 Sep 2020 09:05:22 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        linux-block@vger.kernel.org, martin.petersen@oracle.com,
        Hans de Goede <hdegoede@redhat.com>,
        Song Liu <song@kernel.org>,
        Richard Weinberger <richard@nod.at>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        dm-devel@redhat.com, linux-mtd@lists.infradead.org,
        linux-mm@kvack.org, drbd-dev@tron.linbit.com,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 06/14] block: lift setting the readahead size into the
 block layer
Message-ID: <20200915070522.GA19974@lst.de>
References: <20200726150333.305527-1-hch@lst.de> <20200726150333.305527-7-hch@lst.de> <20200826220737.GA25613@redhat.com> <20200902151144.GA1738@lst.de> <20200902162007.GB5513@redhat.com> <20200910092813.GA27229@lst.de> <20200910171541.GB21919@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910171541.GB21919@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 10, 2020 at 01:15:41PM -0400, Mike Snitzer wrote:
> > I'll move it to blk_register_queue, which should work just fine.
> 
> That'll work for initial DM table load as part of DM device creation
> (dm_setup_md_queue).  But it won't account for DM table reloads that
> might change underlying devices on a live DM device (done using
> __bind).
> 
> Both dm_setup_md_queue() and __bind() call dm_table_set_restrictions()
> to set/update queue_limits.  It feels like __bind() will need to call a
> new block helper to set/update parts of queue_limits (e.g. ra_pages and
> io_pages).
> 
> Any chance you're open to factoring out that block function as an
> exported symbol for use by blk_register_queue() and code like DM's
> __bind()?

I agree with the problem statement.  OTOH adding an exported helper
for two trivial assignments seems a little silly..

For now I'll just keep the open coded ->io_pages assignment in
dm.  Note that dm doesn't currently update the ->ra_pages value
based on the underlying devices, so an incremental patch to do that
might be useful as well.

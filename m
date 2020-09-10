Return-Path: <SRS0=i/dv=CT=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74211C2D0A7
	for <linux-raid@archiver.kernel.org>; Thu, 10 Sep 2020 09:29:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C36821582
	for <linux-raid@archiver.kernel.org>; Thu, 10 Sep 2020 09:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbgIJJ2Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 10 Sep 2020 05:28:24 -0400
Received: from verein.lst.de ([213.95.11.211]:60174 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728936AbgIJJ2R (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 10 Sep 2020 05:28:17 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id C27726736F; Thu, 10 Sep 2020 11:28:13 +0200 (CEST)
Date:   Thu, 10 Sep 2020 11:28:13 +0200
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
Message-ID: <20200910092813.GA27229@lst.de>
References: <20200726150333.305527-1-hch@lst.de> <20200726150333.305527-7-hch@lst.de> <20200826220737.GA25613@redhat.com> <20200902151144.GA1738@lst.de> <20200902162007.GB5513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902162007.GB5513@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 02, 2020 at 12:20:07PM -0400, Mike Snitzer wrote:
> On Wed, Sep 02 2020 at 11:11am -0400,
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Wed, Aug 26, 2020 at 06:07:38PM -0400, Mike Snitzer wrote:
> > > On Sun, Jul 26 2020 at 11:03am -0400,
> > > Christoph Hellwig <hch@lst.de> wrote:
> > > 
> > > > Drivers shouldn't really mess with the readahead size, as that is a VM
> > > > concept.  Instead set it based on the optimal I/O size by lifting the
> > > > algorithm from the md driver when registering the disk.  Also set
> > > > bdi->io_pages there as well by applying the same scheme based on
> > > > max_sectors.
> > > > 
> > > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  block/blk-settings.c         |  5 ++---
> > > >  block/blk-sysfs.c            |  1 -
> > > >  block/genhd.c                | 13 +++++++++++--
> > > >  drivers/block/aoe/aoeblk.c   |  2 --
> > > >  drivers/block/drbd/drbd_nl.c | 12 +-----------
> > > >  drivers/md/bcache/super.c    |  4 ----
> > > >  drivers/md/dm-table.c        |  3 ---
> > > >  drivers/md/raid0.c           | 16 ----------------
> > > >  drivers/md/raid10.c          | 24 +-----------------------
> > > >  drivers/md/raid5.c           | 13 +------------
> > > >  10 files changed, 16 insertions(+), 77 deletions(-)
> > > 
> > > 
> > > In general these changes need a solid audit relative to stacking
> > > drivers.  That is, the limits stacking methods (blk_stack_limits)
> > > vs lower level allocation methods (__device_add_disk).
> > > 
> > > You optimized for lowlevel __device_add_disk establishing the bdi's
> > > ra_pages and io_pages.  That is at the beginning of disk allocation,
> > > well before any build up of stacking driver's queue_io_opt() -- which
> > > was previously done in disk_stack_limits or driver specific methods
> > > (e.g. dm_table_set_restrictions) that are called _after_ all the limits
> > > stacking occurs.
> > > 
> > > By inverting the setting of the bdi's ra_pages and io_pages to be done
> > > so early in __device_add_disk it'll break properly setting these values
> > > for at least DM afaict.
> > 
> > ra_pages never got inherited by stacking drivers, check it by modifying
> > it on an underlying device and then creating a trivial dm or md one.
> 
> Sure, not saying that it did.  But if the goal is to set ra_pages based
> on io_opt then to do that correctly on stacking drivers it must be done
> in terms of limits stacking right?  Or at least done at a location that
> is after the limits stacking has occurred?  So should DM just open-code
> setting ra_pages like it did for io_pages?
> 
> Because setting ra_pages in __device_add_disk() is way too early for DM
> -- given it uses device_add_disk_no_queue_reg via add_disk_no_queue_reg
> at DM device creation (before stacking all underlying devices' limits).

I'll move it to blk_register_queue, which should work just fine.

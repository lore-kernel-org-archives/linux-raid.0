Return-Path: <SRS0=HtB1=DB=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC295C4727D
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 15:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 660EF2311A
	for <linux-raid@archiver.kernel.org>; Thu, 24 Sep 2020 15:03:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eP3Z9KmG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbgIXPDe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Sep 2020 11:03:34 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728331AbgIXPDd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 24 Sep 2020 11:03:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600959811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CuPbzvXQosIYzpsTmyDB+PWCFgx3pRZznwdDq166LWs=;
        b=eP3Z9KmGOgHKsdc2egcKFmMEqUWOPS/355h58xDpBE45HyaDSMZNhofIlD/t/Uqhd633Tw
        Pjk8AQdt4Oup7qKiLogc4TKnNXLGKMfNDE7+5XQUc0Y0VMu3WPO2TldBeaOgBtsvqaBpDA
        c0C4sIuAmGj8+IGxQpULtmDqlUTAmQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-iUJ3YX6mN1eUqjWHfNMFxw-1; Thu, 24 Sep 2020 11:03:27 -0400
X-MC-Unique: iUJ3YX6mN1eUqjWHfNMFxw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5C924802B75;
        Thu, 24 Sep 2020 15:03:24 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 92FD35C1D7;
        Thu, 24 Sep 2020 15:03:19 +0000 (UTC)
Date:   Thu, 24 Sep 2020 11:03:19 -0400
From:   Mike Snitzer <snitzer@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-raid@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Justin Sanders <justin@coraid.com>,
        Minchan Kim <minchan@kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        cgroups@vger.kernel.org, linux-bcache@vger.kernel.org,
        Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-mtd@lists.infradead.org, Richard Weinberger <richard@nod.at>,
        drbd-dev@tron.linbit.com, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/13] block: lift setting the readahead size into the
 block layer
Message-ID: <20200924150318.GE13849@redhat.com>
References: <20200924065140.726436-1-hch@lst.de>
 <20200924065140.726436-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924065140.726436-8-hch@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Sep 24 2020 at  2:51am -0400,
Christoph Hellwig <hch@lst.de> wrote:

> Drivers shouldn't really mess with the readahead size, as that is a VM
> concept.  Instead set it based on the optimal I/O size by lifting the
> algorithm from the md driver when registering the disk.  Also set
> bdi->io_pages there as well by applying the same scheme based on
> max_sectors.  To ensure the limits work well for stacking drivers a
> new helper is added to update the readahead limits from the block
> limits, which is also called from disk_stack_limits.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Coly Li <colyli@suse.de>
> Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

Thanks for adding blk_queue_update_readahead()

Reviewed-by: Mike Snitzer <snitzer@redhat.com>


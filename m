Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061C9C43334
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jul 2022 08:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiGEIea (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jul 2022 04:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGEIe3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jul 2022 04:34:29 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99F5D2ACB;
        Tue,  5 Jul 2022 01:34:28 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D265E68BEB; Tue,  5 Jul 2022 10:34:24 +0200 (CEST)
Date:   Tue, 5 Jul 2022 10:34:24 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, agk@redhat.com,
        song@kernel.org, djwong@kernel.org, hch@lst.de, sagi@grimberg.me,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        viro@zeniv.linux.org.uk, javier@javigon.com,
        johannes.thumshirn@wdc.com, bvanassche@acm.org,
        dongli.zhang@oracle.com, ming.lei@redhat.com, willy@infradead.org,
        jefflexu@linux.alibaba.com, josef@toxicpanda.com, clm@fb.com,
        dsterba@suse.com, jack@suse.com, tytso@mit.edu,
        adilger.kernel@dilger.ca, jlayton@kernel.org, idryomov@gmail.com,
        danil.kipnis@cloud.ionos.com, ebiggers@google.com,
        jinpu.wang@cloud.ionos.com
Subject: Re: [PATCH 2/6] nvme: add support for the Verify command
Message-ID: <20220705083424.GB19123@lst.de>
References: <20220630091406.19624-1-kch@nvidia.com> <20220630091406.19624-3-kch@nvidia.com> <Yr3OLiEd+/6wryCx@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr3OLiEd+/6wryCx@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Jun 30, 2022 at 10:24:14AM -0600, Keith Busch wrote:
> On Thu, Jun 30, 2022 at 02:14:02AM -0700, Chaitanya Kulkarni wrote:
> > Allow verify operations (REQ_OP_VERIFY) on the block device, if the
> > device supports optional command bit set for verify. Add support
> > to setup verify command. Set maximum possible verify sectors in one
> > verify command according to maximum hardware sectors supported by the
> > controller.
> 
> Shouldn't the limit be determined by Identify Controller NVM CSS's 'VSL' field
> instead of its max data transfer?

Yes.

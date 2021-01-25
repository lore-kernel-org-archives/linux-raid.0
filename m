Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2A5CC433DB
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A53F922583
	for <linux-raid@archiver.kernel.org>; Mon, 25 Jan 2021 18:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731377AbhAYSP3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Jan 2021 13:15:29 -0500
Received: from verein.lst.de ([213.95.11.211]:45127 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731360AbhAYSOl (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 25 Jan 2021 13:14:41 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3CD5368B02; Mon, 25 Jan 2021 19:13:49 +0100 (CET)
Date:   Mon, 25 Jan 2021 19:13:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Coly Li <colyli@suse.de>, Song Liu <song@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache <linux-bcache@vger.kernel.org>,
        "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" 
        <linux-raid@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>
Subject: Re: [PATCH 05/10] block: do not reassig ->bi_bdev when partition
 remapping
Message-ID: <20210125181349.GA14432@lst.de>
References: <20210124100241.1167849-1-hch@lst.de> <20210124100241.1167849-6-hch@lst.de> <dfdff48c-c263-8e7c-cb52-28e7bee00c45@kernel.dk> <20210125175528.GA13451@lst.de> <2b600368-96fa-7caf-f05b-321de616f7c9@kernel.dk> <13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13667b22-029b-d7be-02da-96fce22cfd8f@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jan 25, 2021 at 11:03:24AM -0700, Jens Axboe wrote:
> Partition table entries are not in disk order.

And the issue shows up with the series just up to the this patch,
without any later patches?

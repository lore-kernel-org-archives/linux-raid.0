Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C2BC19437
	for <linux-raid@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A335238E3
	for <linux-raid@archiver.kernel.org>; Mon,  7 Dec 2020 19:02:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgLGTCd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 7 Dec 2020 14:02:33 -0500
Received: from verein.lst.de ([213.95.11.211]:43165 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLGTCd (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 7 Dec 2020 14:02:33 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 92C6168B02; Mon,  7 Dec 2020 20:01:49 +0100 (CET)
Date:   Mon, 7 Dec 2020 20:01:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qian Cai <qcai@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Coly Li <colyli@suse.de>,
        Song Liu <song@kernel.org>, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-block@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: store a pointer to the block_device in struct bio (again)
Message-ID: <20201207190149.GA22524@lst.de>
References: <20201201165424.2030647-1-hch@lst.de> <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <920899710c9e8dcce16e561c6d832e4e9c03cd73.camel@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks for the report.

Jens, can you revert the series for now?  I think waiting any longer
with a report like this is not helpful.  I'll look into it with
Qian in the meantime.

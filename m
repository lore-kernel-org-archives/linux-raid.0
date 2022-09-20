Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B3EC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 20 Sep 2022 14:15:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiITOPA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 20 Sep 2022 10:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbiITONy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 20 Sep 2022 10:13:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8C75E675;
        Tue, 20 Sep 2022 07:12:22 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 25B9968AA6; Tue, 20 Sep 2022 16:12:18 +0200 (CEST)
Date:   Tue, 20 Sep 2022 16:12:17 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Dusty Mabe <dusty@dustymabe.com>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Subject: Re: regression caused by block: freeze the queue earlier in
 del_gendisk
Message-ID: <20220920141217.GA12560@lst.de>
References: <017845ae-fbae-70f6-5f9e-29aff2742b8c@dustymabe.com> <YxBZ4BBjxvAkvI2A@T590> <20220907073324.GB23826@lst.de> <Yxr4SD4d0rZ9TZik@T590> <20220912071618.GA4971@lst.de> <Yx/jLTknQm9VeHi4@T590> <95cbd47d-46ed-850e-7d4f-851b35d03069@dustymabe.com> <f2c28043-59e6-0aee-b8bf-df38525ee899@leemhuis.info> <d39e9149-fcb6-1f7c-4c19-234e74f286f8@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d39e9149-fcb6-1f7c-4c19-234e74f286f8@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Sep 20, 2022 at 08:05:06AM -0600, Jens Axboe wrote:
> Christoph and I discussed this one last week, and he has a plan to try
> a flag approach. Christoph, did you get a chance to bang that out? Would
> be nice to get this one wrapped up.

I gave up on that as it will be far too much change so late in
the cycle and sent you the revert yesterday.

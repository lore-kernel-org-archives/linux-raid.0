Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85724C4332F
	for <linux-raid@archiver.kernel.org>; Wed, 30 Mar 2022 15:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238273AbiC3PTO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Mar 2022 11:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348086AbiC3PTM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Mar 2022 11:19:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C5F51557C2
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 08:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7B356150C
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 15:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8784FC340F2;
        Wed, 30 Mar 2022 15:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648653446;
        bh=hqgsBKvO0cgJ6r30LY9q4v9Q3FYVf2gCAOzwjCFO0MM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cN4Z/fQB3SKgg9SrTo+PO2kH+aak5qgWLJ37D069WmTJtdGDKdXj2ZITYCl4ZIp7y
         BcLzN5HgmV1aKSJDWtMqIj3FWSWOfTmk+l4QyEk2r1H63EA8S1yaFVxgpRmWSJNdgo
         NjfLhVzVRsumgvEeSGsmuOPhIsWDtfhJYT3F2j+0=
Date:   Wed, 30 Mar 2022 17:17:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Larkin Lowrey <llowrey@nuclearwinter.com>,
        Song Liu <song@kernel.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>,
        Roger Heflin <rogerheflin@gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Message-ID: <YkR0gvkIOONNYo/d@kroah.com>
References: <20220309064209.4169303-1-song@kernel.org>
 <9516f407-bb91-093b-739d-c32bda1b5d8d@kernel.dk>
 <CAPhsuW5zX96VaBMu-o=JUqDz2KLRBcNFM_gEsT=tHjeYqrngSQ@mail.gmail.com>
 <38f7aaf5-2043-b4f4-1fa5-52a7c883772b@kernel.dk>
 <CAPhsuW7zdYZqxaJ7SOWdnVOx-cASSoXS4OwtWVbms_jOHNh=Kw@mail.gmail.com>
 <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
 <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 30, 2022 at 08:49:07AM -0600, Jens Axboe wrote:
> On 3/30/22 8:39 AM, Larkin Lowrey wrote:
> > Thank you for investigating and resolving this issue. Your effort is
> > very much appreciated.
> > 
> > I am interested in when this patch will end up in a release. Is it
> > going to make it into a 5.17.x release or will it not come until 5.18?
> 
> The two patches are merged for 5.18, and I just checked and they apply
> directly to 5.17 as well.
> 
> Greg, care to queue up the two attached patches for 5.17-stable?

Now queued up, but shouldn't they also work for 5.16?  They don't apply
there, but the Fixes: tag says it should.

thanks,

greg k-h

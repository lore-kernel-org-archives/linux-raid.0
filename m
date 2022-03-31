Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F12C9C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 06:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiCaGQQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 02:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCaGQP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 02:16:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 383F543399
        for <linux-raid@vger.kernel.org>; Wed, 30 Mar 2022 23:14:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF2FAB81EF4
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 06:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D579DC340ED;
        Thu, 31 Mar 2022 06:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648707265;
        bh=YxM4jB7TW0Hykui0gouwI3s9jtCUKNoif9j6Wydyj8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=O0d2QKSwrqHdOjQvMzDgmxewhepYkLwvh6sKBLvjblU5Ar8eYRPiLQZT8rp+jGbnP
         sf9ftX/EchuqCdbHUR3Iyb4bWIiXVjrAnWYs1w45tzhEmikWbGdx+STGwpCjlTdxw4
         UIzD+rPbln26ONAKjvnIYHAWRD9wyHI+xJDw99kQ=
Date:   Thu, 31 Mar 2022 08:14:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Song Liu <song@kernel.org>, Roger Heflin <rogerheflin@gmail.com>,
        Larkin Lowrey <llowrey@nuclearwinter.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Wilson Jonathan <i400sjon@gmail.com>
Subject: Re: [PATCH] block: check more requests for multiple_queues in
 blk_attempt_plug_merge
Message-ID: <YkVGvgjOsLS8nDFk@kroah.com>
References: <2b437948-ba2a-c59c-1059-e937ea8636bd@kernel.dk>
 <84310ba2-a413-22f4-1349-59a09f4851a1@kernel.dk>
 <CAPhsuW492+zrVCyckgct_ju+5V_2grn4-s--TU2QVA7pkYtyzA@mail.gmail.com>
 <88ddb41a-75cb-df50-6679-6801e85dc196@nuclearwinter.com>
 <4a40d169-21c9-8292-7d0e-b68753265108@kernel.dk>
 <YkR0gvkIOONNYo/d@kroah.com>
 <46cb9609-ffb5-74aa-e4a1-598c86be9db9@kernel.dk>
 <CAAMCDefQQqwsLNmBjArTipLDnKzW2nQBW4MTHajrjKS4oi=JFg@mail.gmail.com>
 <CAPhsuW4XuW0Ejb5hL+vk7Vt=MTPgE3R2666bo1O2bJV7FoSZXw@mail.gmail.com>
 <2a5dab10-ce94-e0a5-1a83-70f318702e07@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5dab10-ce94-e0a5-1a83-70f318702e07@kernel.dk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 30, 2022 at 01:01:08PM -0600, Jens Axboe wrote:
> On 3/30/22 12:50 PM, Song Liu wrote:
> > On Wed, Mar 30, 2022 at 8:58 AM Roger Heflin <rogerheflin@gmail.com> wrote:
> >>
> >> If someone sends a patch that will apply for 5.16 I can patch and compile, and run normal IO and a few raid checks tests.
> >>
> >> On Wed, Mar 30, 2022 at 10:39 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 3/30/22 9:17 AM, Greg Kroah-Hartman wrote:
> >>>> On Wed, Mar 30, 2022 at 08:49:07AM -0600, Jens Axboe wrote:
> >>>>> On 3/30/22 8:39 AM, Larkin Lowrey wrote:
> >>>>>> Thank you for investigating and resolving this issue. Your effort is
> >>>>>> very much appreciated.
> >>>>>>
> >>>>>> I am interested in when this patch will end up in a release. Is it
> >>>>>> going to make it into a 5.17.x release or will it not come until 5.18?
> >>>>>
> >>>>> The two patches are merged for 5.18, and I just checked and they apply
> >>>>> directly to 5.17 as well.
> >>>>>
> >>>>> Greg, care to queue up the two attached patches for 5.17-stable?
> >>>>
> >>>> Now queued up, but shouldn't they also work for 5.16?  They don't apply
> >>>> there, but the Fixes: tag says it should.
> >>>
> >>> Yes, they should go to 5.16-stable as well. Song, do you have time to
> >>> port and test on 5.16?
> > 
> > I ported the two patches on top of 5.16.18 (attached). They look good
> > in my tests.
> 
> Thanks!

Thanks, both queued up now.

greg k-h

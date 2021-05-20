Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E709BC433ED
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 20:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8D961353
	for <linux-raid@archiver.kernel.org>; Thu, 20 May 2021 20:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhETUuu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 16:50:50 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35976 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhETUuu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 20 May 2021 16:50:50 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 14KKnQ1m025777
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Thu, 20 May 2021 21:49:26 +0100
From:   Nix <nix@esperi.org.uk>
To:     Leslie Rhorer <lesrhorer@att.net>
Cc:     antlists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: My superblocks have gone missing, can't reassemble raid5
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
        <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
        <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
        <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
        <60A55239.9070009@youngman.org.uk>
        <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
        <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
        <60de3096-95e8-ca32-3c83-982bf8409167@att.net>
Emacs:  don't cry -- it won't help.
Date:   Thu, 20 May 2021 21:49:26 +0100
In-Reply-To: <60de3096-95e8-ca32-3c83-982bf8409167@att.net> (Leslie Rhorer's
        message of "Wed, 19 May 2021 18:45:47 -0500")
Message-ID: <87a6opnnah.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-x.dcc-servers-Metrics: loom 104; Body=3 Fuz1=3 Fuz2=3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 20 May 2021, Leslie Rhorer outgrape:

> On 5/19/2021 3:01 PM, antlists wrote:
>> Yes you can explicitly specify everything, and get mdadm to recover the array if the superblocks have been lost, but it's nowhere
>> as simple as "there are only three possible combinations".
>
> 	The number of permutations of the order of three drives is precisely six.  The permutations are:
>
> 1, 2, 3
>
> 1, 3, 2
>
> 2, 1, 3
>
> 2, 3, 1
>
> 3, 1, 2
>
> 3, 2, 1
>
> 	The Examine stated it was 2, 3, 1, but the device order is not
> at all unlikely to have changed. Once again, I was very explicit in
> saying the simple create may not work and if not he is facing some
> much more serious issues. That was and is in no way incorrect. The
> odds one of them will work are not terrible, and if so, he is in good
> shape. Are you seriously implying there is no way any of them could
> possibly work?

Of course not, but it's *likely* none will work. mdadm's default chunk
size has probably changed since the array was created if it's more than
a few years old, for starters.

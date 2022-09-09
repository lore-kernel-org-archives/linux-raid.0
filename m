Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38200ECAAD3
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 15:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiIIPeB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 11:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiIIPdg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 11:33:36 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAEC146D0D
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 08:33:01 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 9DC7658F;
        Fri,  9 Sep 2022 15:31:32 +0000 (UTC)
Date:   Fri, 9 Sep 2022 20:31:30 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Jonmichael Hands <jm@chia.net>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
Message-ID: <20220909203130.71be302a@nvm>
In-Reply-To: <CABdXBANrJNWjq4237k9DPRoxLVmiAUoKMZxaaLUrcMHsODwvmA@mail.gmail.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
        <20220909115749.00007431@linux.intel.com>
        <20220909165417.4161b5a8@nvm>
        <CABdXBANrJNWjq4237k9DPRoxLVmiAUoKMZxaaLUrcMHsODwvmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 9 Sep 2022 07:40:00 -0700
Jonmichael Hands <jm@chia.net> wrote:

> Deterministic read zero after TRIM is standardized and can be reported by
> device. If the device supports these bits, they will always return zero
> after discard.

Point is that some/many devices do not report this capability properly, but
actually do read back zeroes after TRIM. Relying on the reporting alone would
exclude a lot of cases where the optimization could have been used. So it is
useful to verify the observed behavior and still allow the optimization in
those cases.

-- 
With respect,
Roman

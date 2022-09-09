Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A02C6FA82
	for <linux-raid@archiver.kernel.org>; Fri,  9 Sep 2022 12:02:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbiIIMCB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 9 Sep 2022 08:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230464AbiIIMBv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 9 Sep 2022 08:01:51 -0400
X-Greylist: delayed 426 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 05:01:35 PDT
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56684128C05
        for <linux-raid@vger.kernel.org>; Fri,  9 Sep 2022 05:01:34 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 54ACE524;
        Fri,  9 Sep 2022 11:54:18 +0000 (UTC)
Date:   Fri, 9 Sep 2022 16:54:17 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
Message-ID: <20220909165417.4161b5a8@nvm>
In-Reply-To: <20220909115749.00007431@linux.intel.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
        <20220909115749.00007431@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 9 Sep 2022 11:57:49 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> BTW. I'm not sure if discard ensures that data will be all zero. It causes that
> drive drops all references but I doesn't mean that data is zeroed. Could you
> please check it in documentation? Should we expect zeroes?

Indeed, the references are dropped, but the actual data is still on disk.
Physically wiping it would be time-consuming. Instead the "zeroing" is achieved
via the fact that trying to read back areas for which the drive has no
reference, makes the drive return all zeroes instead.

The behavior varies per SSD model. Some do not return zeroes after a discard,
but some binary garbage instead.

In the ATA layer there is the sysfs file "discard_zeroes_data", which tells
whether or not to expect zeroes after a discard. That flag does not appear to
be always correct, e.g. I have some SSDs which do observably read back zeroes
after a discard, but the flag still says "0". Rather than relying on that flag
Logan opted for a manual check, reading back the actual disk data to check for
zeroes, which I think could employ the optimization safely enough much more
often, than simply going per the flag value would allow.

-- 
With respect,
Roman

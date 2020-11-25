Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C074DC56201
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:16:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 794702065E
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:16:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728529AbgKYXQW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:16:22 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17324 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727281AbgKYXQW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:16:22 -0500
X-Greylist: delayed 648 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Nov 2020 18:16:21 EST
ARC-Seal: i=1; a=rsa-sha256; t=1606346179; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ZusvnmA3DRd4Gu/XtSGJaU1vlIRcrV4iduEeWk18zV0KZQPNJBvt7StEY/lHpVQxoA/3eWBmBBe6srj8+R0o8bQl5QZGCjrwko9TYwi9eDnxKmldbsfzlEvYTa9WHoBLgiFac+HW7c8AfhZKlFgufISB/QmtuxkDTHRED4qaYgE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606346179; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=Truc/+KRQw4RX7LMx4V7a3hartmXVxV5dlcjy6kA3lQ=; 
        b=ZaIP4bAkxhVl9kX3JBAgRuMQJ+7DG7ufU7420vWcU1jX5qAy8cnhMkh19tWTWnwTRCu+5O+di+mBuy2jfhuhkOdSSRtBDdSKfhewjZxxVOlVa/WBD1ndXJ1vi6ahJBxIV/kiIXzBTH0boYRsPueMuWxQGRLSoBYsi9SuJbWCucI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606346177856213.68586825860007; Thu, 26 Nov 2020 00:16:17 +0100 (CET)
Subject: Re: [PATCH] mdadm: Unify forks behaviour
To:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20201104090236.17146-1-mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <2ae4685f-86bc-466d-4e71-854bafa27bfd@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:16:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201104090236.17146-1-mariusz.tkaczyk@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/4/20 4:02 AM, Mariusz Tkaczyk wrote:
> If mdadm is run by udev or systemd, it gets a pipe as each stream.
> Forks in the background may run after an event or service has been
> processed when udev is detached from pipe. As a result process
> fails quietly if any message is written.
> To prevent from it, each fork has to close all parent streams. Leave
> stderr and stdout opened only for debug purposes.
> Unify it across all forks. Introduce other descriptors detection by
> scanning /proc/self/fd directory. Add generic method for
> managing systemd services.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
> ---
>  Grow.c        |  52 +++------------------
>  Incremental.c |   1 +
>  Monitor.c     |   5 +-
>  mdadm.h       |  10 ++++
>  mdmon.c       |   9 +---
>  util.c        | 124 ++++++++++++++++++++++++++++++++------------------
>  6 files changed, 100 insertions(+), 101 deletions(-)

Applied!

Thanks,
Jes



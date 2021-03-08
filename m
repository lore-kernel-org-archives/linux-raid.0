Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2969AC433E0
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BD065220
	for <linux-raid@archiver.kernel.org>; Mon,  8 Mar 2021 15:16:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhCHPPn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:15:43 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17246 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhCHPP3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 8 Mar 2021 10:15:29 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615216524; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Bm/8hrSESL/gK3myPmy77uJBO9u7cEVGhyOucSoPPgZsOMOdzMq3iPLfI70sNKKFVX2W6ScQ/lC1prO2/hoO9fWdcnD3bYvOwfLmJmBTUZMjI7gB5Hrst8C2FHgKNR3f7av5Un7mDi1t453kLV7Eg0qhv5we/EMWYz/1K3Xxrh0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1615216524; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=LV6vDCYSMLXhlB3R6u4kfRTjtjLglz0V+b1z3B3qgI0=; 
        b=VMf2cte+uvjDCwrQ/waXHH85Cff20Q5n/jjmAEHks8aejcPHPQ5mNqFNP0kXkdfVIotALdZFo8is0YkQJ9WGv0hwvJyAoUrnpGV3x5ZfYVL5m+e2i3DylwVSOw2bo4hUdMWTL7KVpcCwdgn6oHPoGdEYiEM756VZj+JXf/jyJPM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1615216523105900.3230272348816; Mon, 8 Mar 2021 16:15:23 +0100 (CET)
Subject: Re: [PATCH] imsm: use saved fds during migration
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210113085845.26881-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <e52f5f18-fad4-92bc-b63c-e1d0f48e3770@trained-monkey.org>
Date:   Mon, 8 Mar 2021 10:15:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113085845.26881-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/13/21 3:58 AM, Mariusz Tkaczyk wrote:
> IMSM super keeps open descriptors in super->disks structure, they are
> reliable and should be chosen if possible. The repeatedly called open
> and close during reshape generates redundant udev change events on
> each member drive.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  super-intel.c | 208 +++++++++++++-------------------------------------
>  1 file changed, 54 insertions(+), 154 deletions(-)

Applied!

Thanks,
Jes



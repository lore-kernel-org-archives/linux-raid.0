Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1FC9C7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 16:16:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjCSQQ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 12:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCSQQz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 12:16:55 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F23A812CD5
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 09:16:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679242606; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=bCUclp2kM2fDRaNlKvlSNrlcTPgk601QI2fbiod+/j5/dLH4HBp9P5fOswLdpM7EwwhOIQTwsuMD5ktVuUmnB8iYoMelvvP4Q7p9s+Xv+ZSSZeDkuL57x96KixUy0J3V7tcbgePJCW2mBCYDmCFIIX4wwb4Ep2w1rrSQxpaGbhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679242606; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=b1HOsDltGIfpHYgm/fnLviqMIvzKXTypbajjj8Ro3XE=; 
        b=X+/Ox1hEAkYJ58evDzLYj8sUvKEVB7b8enoe29ii1nme/kJtHl1xmIsbKYDfm4v0ANhcBinbFwk0payp/sbJd5RA3XFbn8o4Wbg7D/mIbNmdAcEqWxfElNasobkhfVYdr95t3A8rInssLLQi42+vSHIRxoe54yV/ldRRtWN08rE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679242602620490.7806541872608; Sun, 19 Mar 2023 17:16:42 +0100 (CET)
Message-ID: <8bf3b89c-83bd-8ba5-d3ab-cf17c6745e72@trained-monkey.org>
Date:   Sun, 19 Mar 2023 12:16:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] Define alignof using _Alignof when using C11 or newer
Content-Language: en-US
To:     Khem Raj <raj.khem@gmail.com>, linux-raid@vger.kernel.org
References: <20230118083236.24418-1-raj.khem@gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230118083236.24418-1-raj.khem@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/18/23 03:32, Khem Raj wrote:
> WG14 N2350 made very clear that it is an UB having type definitions
> within "offsetof" [1]. This patch enhances the implementation of macro
> alignof_slot to use builtin "_Alignof" to avoid undefined behavior on
> when using std=c11 or newer
> 
> clang 16+ has started to flag this [2]
> 
> Fixes build when using -std >= gnu11 and using clang16+
> 
> Older compilers gcc < 4.9 or clang < 8 has buggy _Alignof even though it
> may support C11, exclude those compilers too
> 
> [1] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2350.htm
> [2] https://reviews.llvm.org/D133574
> 
> Upstream-Status: Pending
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  sha1.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)

Applied,

Thanks,
Jes



Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E59F1C54EE9
	for <linux-raid@archiver.kernel.org>; Thu,  8 Sep 2022 16:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbiIHQ6C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Sep 2022 12:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIHQ5k (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Sep 2022 12:57:40 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD1C9D99C9
        for <linux-raid@vger.kernel.org>; Thu,  8 Sep 2022 09:57:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1662656228; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=i3muBrOMM+XILlZFB0bO9SuZXJRanmOvTJHLStdiQ1Jt1Vy5VyF9dU9vGCkFhcFs1yJTpkDzimm+7u1JPLeiYUWp6rUrj5ySOhfEsvBllGGZpYqzTI/4cmwIyy1EhGuO1oi43Cqz/CH+TD4dKLTLQLs/ibaMxZVkRGNhO0Db1EE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1662656228; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hBNAYcqT21lCDcJ1dDRW9/wia+0gH7vT+WSmGVYpHbo=; 
        b=L0MgDRHsgvcgKnWaLh0teV+y0vgVizr3osTX+lNp0KlVM6pHDC6fTfjZ8yg9vRwDViFtDMD23gZAFiIntAgpr6LscQdmWswh1GRF4g1dyTQzuSGp05N86xDGgSIlvXa5JlT+2BVDRheLtNbBogW/hqD0zttxZo5hluyrFdhR+f0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1662656226194553.9629196592293; Thu, 8 Sep 2022 18:57:06 +0200 (CEST)
Message-ID: <f19d83da-97a2-3431-3f4b-5fd2a900bed3@trained-monkey.org>
Date:   Thu, 8 Sep 2022 12:57:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 1/1] Monitor: Fix statelist memory leaks
Content-Language: en-US
To:     Pawel Baldysiak <pawel.baldysiak@intel.com>,
        linux-raid@vger.kernel.org
References: <20220901092031.3274605-1-pawel.baldysiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220901092031.3274605-1-pawel.baldysiak@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/1/22 05:20, Pawel Baldysiak wrote:
> Free statelist in error path in Monitor initialization.
> 
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Monitor.c | 40 +++++++++++++++++++++++++++++++---------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 

Nice catch!

Applied!

Thanks,
Jes



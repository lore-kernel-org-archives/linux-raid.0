Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C888C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 21:09:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BB9B61078
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 21:09:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbhEFVKt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 17:10:49 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17007 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbhEFVKt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 17:10:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1620335385; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ESN6Ic1dPvJKyWvOxVpy60c6nflQxOEu2LCS+2gtxDzfpVY+fwF/GLb27XrE664iMeAjDrkm0dt4jrrHrxzCzm20UyoGmfdGxnoaTaxv2roi8JZmEr5+13KS4ca/RbTC3/TM2kyYjazU9j7YcB4rJOvbBe6bGnY1MEPCERC4EBA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1620335385; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=k3ntHH7EpGpuLos1S0hoDiOHoeYVk9JdngZguuJG2U8=; 
        b=LRl+o1LEUDTKbvxwYDR908RYt31SqgKmVgxtjjISKqLnVXI+DCfFzxEWJ1pSwt9hqUj5eU9PhO8BPSWKnGkgpvdxBRIKL2Yjdxgfg+c5TT+6UcJgUlWuV1sagD4GSgndyUg5YOXbOkpN9cBOW9C2m8qwbC4aVwgyVRMXYVwWIXs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1620335384374935.6187716618942; Thu, 6 May 2021 23:09:44 +0200 (CEST)
Subject: Re: [PATCH] Prevent user from using --stop with ambiguous args
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210505110102.16947-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <91f6f3d8-1763-7244-c49b-96c4437a32b9@trained-monkey.org>
Date:   Thu, 6 May 2021 17:09:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210505110102.16947-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/5/21 7:01 AM, Mariusz Tkaczyk wrote:
> From: Norbert Szulc <norbert.szulc@intel.com>
> 
> When both --scan and device name is passed to --stop action,
> then is executed only for given device. Scan is ignored.
> 
> Block the operation when both --scan and device name are passed.
> 
> Signed-off-by: Norbert Szulc <norbert.szulc@intel.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  mdadm.c | 5 +++++
>  1 file changed, 5 insertions(+)

Applied!

Thanks,
Jes


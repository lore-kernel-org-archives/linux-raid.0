Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A93FC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 16:20:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233778AbiCCQUz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Mar 2022 11:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbiCCQUz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Mar 2022 11:20:55 -0500
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2425199D7C
        for <linux-raid@vger.kernel.org>; Thu,  3 Mar 2022 08:20:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=Soof3/++XSnUnQ3KKT9v4nghmSEVc3WNPP78zK1WNnI=; b=OnEE4NVgZ/mv1lhldvvJ5HOxKl
        iWLzGj8Baz9kJwGTq0eagCcuYivKB+kvxvK6hr6MnqXhLdki2S7QTz45SryaiBQcWLrix3HcHCCiD
        bDi7ijKZA/yOSdSoZa2l6/werMjYjUns66jMumtLhBw8hvnugANWWEaEtIn1GPV7XsNY0D/l5MigB
        MpfCnxBXdmN3CfFBL9bEzsyVNGFpp1q4cB3V1wG/gEynkR2aP8I4ri2nRdxWGIappA9EwHg8RuqKO
        TfECuF2mcM8JT71RnJaqwIqPprnQiuCsJ/cRiNeMRR1mOxcTP8nmXgqgRyJ7No5kt7u98k/+VoRR8
        Gjt5lU1Q==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nPoBR-00Djeb-3H; Thu, 03 Mar 2022 09:20:05 -0700
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, linux-raid@vger.kernel.org
Cc:     Shaohua Li <shli@kernel.org>, Shaohua Li <shli@fb.com>,
        Song Liu <song@kernel.org>
References: <11cfe3aa-b778-b3e5-a152-50abc6c054ac@deltatee.com>
 <34a8b64a-37d3-9966-1fe8-d57c432600d7@deltatee.com>
 <806cdd27-8633-09dd-6942-12437c8b9818@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ff15d173-277a-499e-d019-07f4d4ed9f19@deltatee.com>
Date:   Thu, 3 Mar 2022 09:20:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <806cdd27-8633-09dd-6942-12437c8b9818@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: song@kernel.org, shli@fb.com, shli@kernel.org, linux-raid@vger.kernel.org, guoqing.jiang@linux.dev
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: Raid5 Batching Question
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-03-02 6:40 p.m., Guoqing Jiang wrote:
> 
> 
> On 3/3/22 7:24 AM, Logan Gunthorpe wrote:
>> So I'm back to square one trying to find some performance improvements
>> on the write path.
> 
> Did you try with group_thread_cnt?
> 
> /sys/block/md0/md/group_thread_cnt

Yes, I've tried group_thread_cnt and raised stripe_cache_size and a few
other parameters. Still get limited write performance.

Thanks,

Logan

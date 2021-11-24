Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1633C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 16:29:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhKXQdD convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 11:33:03 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17269 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhKXQdD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 11:33:03 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637771388; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DnkbD3FxIzy4kUfYFjMSlRucRyLrx6CVXn3a4P67Ob39nGrpae3HgWB8HlciqYrc++ux0xLvRPN86qJcIVt0ujbexfNFbd/eh7ZjdONsSn8OE/PZ/zNbZ3lBTPM0RL2MTMmDaBCFGsOekgYzSBwvRl1Yu5TXTAhl9jTHrLVU1f8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637771388; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=i8CZjWJs7gPp/l7az5/A7hA82HZHhSDL+v4zl8AdCss=; 
        b=Q+MGPFMB5dA2bma3xmFroYPqkzkaSLLYcjZuMdXu7Ng/bs5nDGzrHWNK8+tTyEODSwH7jxpArjeoCi2KAMxwBM0mSn6gcNJB6H5uqzR0IzmU+AbtSPZxL4Mm5DyY3iYdP+gd/FVfctKQgZAQpHZXTI+BnHKL7jw0zChWMuF3bb0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 163777138498046.847552643352515; Wed, 24 Nov 2021 17:29:44 +0100 (CET)
Subject: Re: [PATCH v2] Incremental: Fix possible memory and resource leaks
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>,
        Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20211124115819.7568-1-mateusz.grzonka@intel.com>
 <16c18e54-fb84-7b97-1aa7-f31979b87a9e@trained-monkey.org>
 <16d735b4-3ac9-44d9-af83-9f664c187cf0@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a0e7a55f-ffab-f74e-c09c-0c13e4f7fb60@trained-monkey.org>
Date:   Wed, 24 Nov 2021 11:29:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <16d735b4-3ac9-44d9-af83-9f664c187cf0@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/21 8:27 AM, Tkaczyk, Mariusz wrote:
> On 24.11.2021 13:13, Jes Sorensen wrote:
>> On 11/24/21 6:58 AM, Mateusz Grzonka wrote:
>>> map allocated through map_by_uuid() is not freed if mdfd is invalid.
>>> In addition mdfd is not closed, and mdinfo list is not freed too.
>>>
>>> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
>>> ---
>>>   Incremental.c | 32 +++++++++++++++++++++++---------
>>>   1 file changed, 23 insertions(+), 9 deletions(-)
>>
>> I already applied the previous version. Could you please send an updated
>> version on top of current tree.
>>
>> Thanks,
>> Jes
>>
> 
> Hi Jes,
> I cannot see previous version in mdadm tree.
> Could you verify?

You may have been too quick and it hadn't propagated yet. Mind trying
one more time?

Thanks,
Jes



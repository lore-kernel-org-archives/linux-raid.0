Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C1B5C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 17:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241213AbiFTRON convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241046AbiFTROK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 13:14:10 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4CD1EACB
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 10:14:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655745216; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=gC9VndFMJVhFiKFmjBXfQiPY3aq1O45URdwQ7AhbiVWMAM1qHyc26fKgO4kFpEjP1UXgapW+l9FqPWNFzvQ4YZNoDuOQomhe68AUxOQiPKhP/eAg5ybQnaO35wgjhgbGVer7OsvHmcmTVp6Nch5AtB4RLFEWJJXlpN4jmf2LjMg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655745216; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7DF+GMpL7D8eP2maCUC3ABi75PfMf9MsHg50c93Guuk=; 
        b=L0440QZrGSPAdXsQH9AsP52LhomT2JflETyeT50gS1dCtWvZ+skqzaxOVDW6/GnAeUjq1NLfnqL3BfA2BpaEeHmNhSXydF6Ddi7QHXb9nyYUgHSb4/D4EtWmWd1FZjok/lw7JZxBKHFuGBoPjZoK4tWOY+u5ZDIqfYg8jG3fFNA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 165574521564125.010775211995906; Mon, 20 Jun 2022 19:13:35 +0200 (CEST)
Date:   Mon, 20 Jun 2022 13:13:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        wuguanghao3@huawei.com
References: <20220418174423.846026-1-ncroxon@redhat.com>
 <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
 <62ec6c6e-76b7-e705-7326-a82b59f337b8@redhat.com>
 <5f9a4417-d044-a87e-3945-2c6b29278d8c@trained-monkey.org>
 <94FEEB40-1A39-4590-88CC-A3352366A541@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <c4413e5d-b676-d7b1-8846-4fc253b536c3@trained-monkey.org>
In-Reply-To: <94FEEB40-1A39-4590-88CC-A3352366A541@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/20/22 12:13, Coly Li wrote:
> 
> 
>> 2022年6月18日 03:35，Jes Sorensen <jes@trained-monkey.org> 写道：
>>
>> On 6/17/22 13:09, Nigel Croxon wrote:
>>> On 6/14/22 10:11 AM, Nigel Croxon wrote:
>>>> On 4/18/22 1:44 PM, Nigel Croxon wrote:
>>>>> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
>>>>>
>>>>> The change from commit mdadm: fix coredump of mdadm
>>>>> --monitor -r broke the printing of the return message when
>>>>> passing -r to mdadm --manage, the removal of a device from
>>>>> an array.
>>>>>
> [snipped]
> 
>>>>
>>>> Jes, That is the status of this patch?
>>>>
>>>> Thanks, Nigel
>>>
>>>
>>> Jes, Is there an issue with reverting this patch?
>>
>> The fact that I am swamped with my regular work and it hadn't made it
>> into patchworks. It's applied now.
> 
> Hi Jes,
> 
> Since I don’t see this patch applied, so I send it again in my “mdadm-CI for-jes/20220620: patches for merge” series with my Acked-by.
> 
> Just for your information. Thank you in advance for taking care of them.

Hi Coly,

Thanks, I just forgot to push it on Friday. I'll need to look through
the rest soon.

Cheers,
Jes



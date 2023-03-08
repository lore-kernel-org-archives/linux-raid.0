Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F948C678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 19:35:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjCHTfI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Mar 2023 14:35:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjCHTfH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Mar 2023 14:35:07 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05855BA876
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 11:35:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678304095; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=YSf+5LaGMFfAzYFRwHYaZaPendRrN97cvyAG2qeMeTZT6C0JKpKHFtmqDoBPT6r1FpXd4tmxhgY1MTC01zDq4kfIDQp9VnTfo3hN9vkvo5Q/2J5+OyLj4iYOsrw86O7W+zGJDZ3uuWZRmodicK3kVO4gpbkhBPp9GBU4pTd3uag=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678304095; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6RZ/GylOLxz/r3nFJ+256JFsDEgwb6LIWbMz7Vy+nhg=; 
        b=CcUoBOvTw2pYCisXDn3QLhKyMf6fCTguIMcdy7JlRebFd2Yj4UjJBp/ox6E6U+ef3r2FB5zAhy8ARK4uslit+5uK99eTMu5+nkzRZMXnOVgmuiglp596xfmPSceAJFg/7GUykZNepvAU0u/16SJYH1mNPq+/U3b/94731lQ1lLU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 167830409311478.87253504624277; Wed, 8 Mar 2023 20:34:53 +0100 (CET)
Message-ID: <9accf1a9-190c-de9a-a4bc-86fda00735dc@trained-monkey.org>
Date:   Wed, 8 Mar 2023 14:34:51 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] mdadm reshape hangs on external grow chunk
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Cc:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@intel.com, kinga.tanska@intel.com
References: <20220923142635.470305-1-ncroxon@redhat.com>
 <20220929113521.000012af@intel.linux.com>
 <20221117150525.00002743@linux.intel.com>
 <20230201143709.00001086@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230201143709.00001086@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/1/23 08:37, Mariusz Tkaczyk wrote:
> Hi Nigel,
> Ping?

..... crickets ..... I'll close this one in patchwork if we don't hear
anything soon.

Thanks,
Jes

> Thanks,
> Mariusz
> 
> On Thu, 17 Nov 2022 15:07:41 +0100
> Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:
>> On Thu, 29 Sep 2022 11:35:21 +0200
>> Kinga Tanska <kinga.tanska@linux.intel.com> wrote:
>>
>>> On Fri, 23 Sep 2022 10:26:35 -0400
>>> Nigel Croxon <ncroxon@redhat.com> wrote:
>>>   
>>>> After creating a raid array on top of a imsm container. Try to
>>>> grow the chunk size and the reshape will hang with zero progress.
>>>> The reason is the computation of sync_max_to_set value:
>>>
>>> Hi Nigel,
>>>
>>> I was trying to retest with your patch but still have the defect. I
>>> analyzed it and found another reason, which causes this defect. In
>>> validate_geometry_imsm function freesize and super is being checked and
>>> return 1 if any of those is NULL. In my opinion 0 shall be returned
>>> here, because it is an error and reshape should be stopped here. I will
>>> prepare proper patch and send to review immediately.
>>>   
>> Hi Nigel,
>> I agree with Kinga.
>> https://patchwork.kernel.org/project/linux-raid/patch/20221028025117.27048-1-kinga.tanska@intel.com/
>> Could you please retest the proposed patch on your side and provide feedback?
>>
>> Thanks,
>> Mariusz
> 


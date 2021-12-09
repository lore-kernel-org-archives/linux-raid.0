Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7631C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 14:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238640AbhLIOfC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 09:35:02 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17259 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbhLIOe6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 09:34:58 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1639060276; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=W/kP5hVEwFuCBdVbe9s/21obhG0CYkCy8+OhC1u6K9mtRYl/1etRmbC2q54E5VaX93RihAQFuSlpmOXPTKyTq3B0hB16sFfeWGqjBS9f9Tb+eDCIwabOjX07w1uqhplMtt3XHzH/pl5Q0jDdOwCXP1mLYv9tjd/3gSNg/jxs9m0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1639060276; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=f7E47xSc1Mc3o+zmr+qWXrTtQeuP/1Cs5PI2eKZFeoU=; 
        b=Tnt1RoYfVXJzXBvD4wzQ2kOO6lE5ApIMzyN9j5+9LdFLflQk/qF6RfvIxU78ZH4ETrOpEd9XBnIWi33PaqHTmAajoRCfJj5ZWiGv6z0npatZIotczoHPht8oxMjxBk+3PQhIIAhXECEX+nPueFElebu6RPHpJqveiylDN1EC74E=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (72.69.75.15 [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1639060273546825.4196679152558; Thu, 9 Dec 2021 15:31:13 +0100 (CET)
Subject: Re: [PATCH v3] Monitor: print message before quit for no array to
 monitor
To:     Coly Li <colyli@suse.de>
Cc:     George Gkioulis <ggkioulis@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20210902073220.19177-1-colyli@suse.de>
 <c9e5b8af-1a1d-82c0-1ca0-af4bd1182d75@suse.de>
 <46d238f5-0757-b876-4a41-6f89605b7d8a@trained-monkey.org>
 <0cb02d8d-e74a-19e7-09df-09553397f4d5@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <f8f7703e-be1e-29dd-e51f-73702f867d7f@trained-monkey.org>
Date:   Thu, 9 Dec 2021 09:31:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <0cb02d8d-e74a-19e7-09df-09553397f4d5@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/8/21 8:18 PM, Coly Li wrote:
> On 12/8/21 10:45 PM, Jes Sorensen wrote:
> 
> Hi Jes,
> 
>> Hi Coly,
>>
>> Didn't see this one as it was only copied to my work email. Sorry.
> 
> It should be my fault, I didn't notice that jes@trained-monkey.org was
> the proper email address :-)
> 
>> Applied!
>>
> 
> Thanks. I will post patches to the trained-monkey.org address in future.

Great, thanks!

Anything else we want for 4.2?

Jes


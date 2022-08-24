Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58832C00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 15:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238816AbiHXP7O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 11:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238958AbiHXP7M (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 11:59:12 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E767D1CF
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 08:59:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661356720; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=KoGYMlYNm3kjLH/YoqIeusVV0DVWU+38YpnxsxC4ZeDN3L6ZSU5uqhoc7oOd0pIiDbLAZYSu432Zb2GGR+5QThEbiV4BlZM++o13uZhct8P0HmgHzuo3G5DHKDjgsf/CKR+pu+btUsdNF0+gkUlAceak+2E+xKwMWJGhS5XvuvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661356720; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=fxnvuKBo0T1FSLfs3uCQhaAsKW0up3VHwqXdGPTHfH8=; 
        b=ibK2/B2EC9E+Bo3R7KmMRb0MWE70j/BxIyhcprl/Qa+VT3Q+wFRuFCvdd1uSj9y96w6T2OYo4u1wCt0yfUWrLsPRlP6gUbSA0hxv+MBYGeW/CuffJPa+n8u2corGrsz8P/Yl0e8sS15UgqrG1b3sDOsao9G9gC+UcOOuA1fZNAE=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1661356718870546.0960070186601; Wed, 24 Aug 2022 17:58:38 +0200 (CEST)
Message-ID: <1c04ce1c-cf02-2891-cb88-c5f91a80f620@trained-monkey.org>
Date:   Wed, 24 Aug 2022 11:58:37 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH mdadm v2] super1: report truncated device
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        NeilBrown <neilb@suse.de>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>, linux-raid@vger.kernel.org
References: <165758762945.25184.10396277655117806996@noble.neil.brown.name>
 <cff69e79-d681-c9d6-c719-8b10999a558a@molgen.mpg.de>
 <165768409124.25184.3270769367375387242@noble.neil.brown.name>
 <20220721101907.00002fee@linux.intel.com>
 <165855103166.25184.12700264207415054726@noble.neil.brown.name>
 <20220725094238.000014f0@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220725094238.000014f0@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/25/22 03:42, Mariusz Tkaczyk wrote:
> On Sat, 23 Jul 2022 14:37:11 +1000
> "NeilBrown" <neilb@suse.de> wrote:
> 
>> On Thu, 21 Jul 2022, Mariusz Tkaczyk wrote:
>>> Hi Neil,
>>>
>>> On Wed, 13 Jul 2022 13:48:11 +1000
>>> "NeilBrown" <neilb@suse.de> wrote:
....
>>> why not just:
>>> if (__le64_to_cpu(super->data_offset) + __le64_to_cpu(super->data_size) >
>>> dsize) from my understanding, only this check matters.  
>>
>> It seemed safest to test both.  I don't remember the difference between
>> ->size and ->data_size.  In getinfo_super1() we have  
>>
>> 	if (info->array.level <= 0)
>> 		data_size = __le64_to_cpu(sb->data_size);
>> 	else
>> 		data_size = __le64_to_cpu(sb->size);
>>
>> which suggests that either could be relevant.
>> I guess ->size should always be less than ->data_size.  But
>> load_super1() doesn't check that, so it isn't safe to assume it.
> 
> Honestly, I don't understand why but I didn't realize that you are checking two
> different fields (size and data_size). I focused on understanding what is going
> on  here, and didn't catch difference in variables (because data_offset and
> data_size have similar prefix).
> For me, something like:
> 
> unsigned long long _size;
> if (st->minor_version >= 1 && st->ignore_hw_compat == 0)
>     _size= __le64_to_cpu(super->size);
> else
>     _size= __le64_to_cpu(super->data_size);
> 
> if (__le64_to_cpu(super->data_offset) + _size > dsize)
> {....}
> 
> is more readable because I don't need to analyze complex if to get the
> difference. Also, I removed doubled __le64_to_cpu(super->data_offset).
> Could you refactor this part?

What is the consensus on this discussion? I see Coly pulled this into
his tree, but I don't see Mariusz's last concern being addressed.

Thanks,
Jes



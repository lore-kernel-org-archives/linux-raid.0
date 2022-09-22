Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56599C54EE9
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 18:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiIVSVE convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 14:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbiIVSVC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 14:21:02 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA556F8FA6
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 11:21:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663870848; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=be4fr9YQUuFAjzDSB4+XXRkpk4gJIpXcR/xrGgow4fhfx3qfu5V9wd86ye0U4TAWAtq7BefWjH+7dH9XHMc6icpEHsNtoZ+w+baZpOPf/NGETzHbSQYmNenagtTGm/tQk3f+GV6sqGZQaRhvXxHG8v2p3E3uN1YIwwPXplOf4SY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1663870848; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WKgkUeOj/fNySPEnYAcHposaH6V0m7fAkZo+WhX2Kdk=; 
        b=k9MuCiBeY3Ia+uABqSKpBc/QYanbxw3Cku1pU8YQoQwqdxHtaDYexCR6siTqVuCeZYGaIas+8bmwNV8881eDdkaSWSUuAMU07EkYnyFIG5o8Z4y1OIszwTjBmArAnWfWDUbVHKxAlVzi7mXyRJa8jaXK6NGDn2wDZKzSgPG6Yis=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1663870845985188.4155786059357; Thu, 22 Sep 2022 20:20:45 +0200 (CEST)
Date:   Thu, 22 Sep 2022 14:20:43 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH 05/10] super0: refactor the code for enum
To:     "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-6-mateusz.kusiak@intel.com>
 <4E9ADC20-2C7C-4438-A11A-766DF7078AC6@suse.de>
 <88af51e7-ebb3-679e-9ae8-f28813908626@linux.intel.com>
Content-Language: en-US
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <7cca99fb-0759-c758-6d28-de4ce4a4ac71@trained-monkey.org>
In-Reply-To: <88af51e7-ebb3-679e-9ae8-f28813908626@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/22/22 07:21, Kusiak, Mateusz wrote:
> On 14/09/2022 17:03, Coly Li wrote:
>>
>>
>>> 2022年8月18日 22:56，Mateusz Kusiak <mateusz.kusiak@intel.com> 写道：
>>>
>> [snipped]
>>> @@ -628,29 +659,15 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
>>> 		sb->disks[info->disk.number].minor = info->disk.minor;
>>> 		sb->disks[info->disk.number].raid_disk = info->disk.raid_disk;
>>> 		sb->disks[info->disk.number].state = info->disk.state;
>>> -	} else if (strcmp(update, "resync") == 0) {
>>> -		/* make sure resync happens */
>>> +		break;
>>> +	case UOPT_RESYNC:
>>> +		/**
>>> +		 *make sure resync happens
>>> +		 */
>>
>>
>> The above change doesn’t follow existing code style for comments. How about using the previous one line version?
>>
> Personaly, I'd rather change it from "/**" to "/*". I think we should
> gradually adapt the code to kernel coding style.
> Are you fine with that?

Kernel style is good, but that would be either

/* foo comment */

or

/*
 * bar comment
 */

Thanks,
Jes


>> [snipped]
>>
>> Thanks.
>>
>> Coly Li



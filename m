Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D583C4167B
	for <linux-raid@archiver.kernel.org>; Wed, 28 Dec 2022 14:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiL1OaF convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Dec 2022 09:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiL1OaE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 28 Dec 2022 09:30:04 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302C0E0E6
        for <linux-raid@vger.kernel.org>; Wed, 28 Dec 2022 06:30:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672237788; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=d4dWIojNCPfqOl4vzx3SxyQ7Kihe95NcM0QWNL7Ll4Yu/0LhvZ6+QC2kFYSSUj2VXb2jipgh8DxZ8HEKP7q0Q0eMFI2lgKPBm3ec11q9Wr9kgM7sH4DOoI25btwfnOKAw8BI48hkNAIfP2PcGjrOLcYC2BM69WlD92Kq/iSdw0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672237788; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cwkxQ+e/wITfVSqJ8wHPd8gHMSQJIyj2jwOsqIjQ2OA=; 
        b=PpyhtUqntYdLAJ+QTpnL8isYhYq49PB60AoPuI9FDY9V1qTZsxq7DWuDRjXsvOwIA/DJ9pkOjVHH1mfnjyQhyEW3kESzSMJBwaps0zcEpAM/4tBSHi6IPEy4IRVzlDoiE4PtWrfn2Nz/d9U3tK2A1JcWq2s+SuEhXVfSInxQapA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672237784829607.2900100413004; Wed, 28 Dec 2022 15:29:44 +0100 (CET)
Date:   Wed, 28 Dec 2022 09:29:42 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 06/10] super1: refactor the code for enum
Content-Language: en-US
To:     "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-7-mateusz.kusiak@intel.com>
 <79C06B27-C8DD-4E87-9C40-72160D26C641@suse.de>
 <0d8322fc-f457-ed65-811e-adc90b6a4970@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <e81aaac9-5f16-31ff-fbb6-78c8645e408d@trained-monkey.org>
In-Reply-To: <0d8322fc-f457-ed65-811e-adc90b6a4970@linux.intel.com>
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
>>> It prepares update_super1 for change context->update to enum.
>>> Change if else statements into switch.
>>>
>>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>>> ---
>>> super1.c | 149 ++++++++++++++++++++++++++++++++-----------------------
>>> 1 file changed, 87 insertions(+), 62 deletions(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 71af860c..6c81c1b9 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -1212,30 +1212,53 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>> 	int rv = 0;
>>> 	struct mdp_superblock_1 *sb = st->sb;
>>> 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
>>> +	enum update_opt update_enum = map_name(update_options, update);
>>>
>>> -	if (strcmp(update, "homehost") == 0 &&
>>> -	    homehost) {
>>> -		/* Note that 'homehost' is special as it is really
>>> +	if (update_enum == UOPT_HOMEHOST && homehost) {
>>> +		/*
>>> +		 * Note that 'homehost' is special as it is really
>>> 		 * a "name" update.
>>> 		 */
>>> 		char *c;
>>> -		update = "name";
>>> +		update_enum = UOPT_NAME;
>>> 		c = strchr(sb->set_name, ':');
>>> 		if (c)
>>> -			strncpy(info->name, c+1, 31 - (c-sb->set_name));
>>> +			snprintf(info->name, sizeof(info->name), "%s", c+1);
>>> 		else
>>> -			strncpy(info->name, sb->set_name, 32);
>>> -		info->name[32] = 0;
>>> +			snprintf(info->name, sizeof(info->name), "%s", sb->set_name);
>>> 	}
>>>
>>> -	if (strcmp(update, "force-one")==0) {
>>> +	switch (update_enum) {
>>> +	case UOPT_NAME:
>>> +		if (!info->name[0])
>>> +			snprintf(info->name, sizeof(info->name), "%d", info->array.md_minor);
>>> +		memset(sb->set_name, 0, sizeof(sb->set_name));
>>> +		int namelen;
>>> +
>>
>> The above variable ’namelen’ might be declared at beginning of this code block.
> 
> I'll fix this in v2.

Hi Mateusz,

Did you ever post a v2 of this?

Thanks,
Jes


>>> +		namelen = strnlen(homehost, MD_NAME_MAX) + 1 + strnlen(info->name, MD_NAME_MAX);
>>> +		if (homehost &&
>>> +		    strchr(info->name, ':') == NULL &&
>>> +		    namelen < MD_NAME_MAX) {
>>> +			strcpy(sb->set_name, homehost);
>>> +			strcat(sb->set_name, ":");
>>> +			strcat(sb->set_name, info->name);
>>> +		} else {
>>> +			namelen = min((int)strnlen(info->name, MD_NAME_MAX),
>>> +				      (int)sizeof(sb->set_name) - 1);
>>> +			memcpy(sb->set_name, info->name, namelen);
>>> +			memset(&sb->set_name[namelen], '\0',
>>> +			       sizeof(sb->set_name) - namelen);
>>> +		}
>>> +		break;
>>>
>> [snipped]
>>> @@ -1569,32 +1589,37 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>> 			}
>>> 		done:;
>>> 		}
>>> -	} else if (strcmp(update, "_reshape_progress") == 0)
>>> +		break;
>>> +	case UOPT_SPEC__RESHAPE_PROGRESS:
>>> 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
>>> -	else if (strcmp(update, "writemostly") == 0)
>>> -		sb->devflags |= WriteMostly1;
>>> -	else if (strcmp(update, "readwrite") == 0)
>>> +		break;
>>> +	case UOPT_SPEC_READWRITE:
>>> 		sb->devflags &= ~WriteMostly1;
>>> -	else if (strcmp(update, "failfast") == 0)
>>
>> Writemostly-setting is removed here, is it on purpose ?
> 
> No, thanks for noticing! I'll add this in v2.
>>
>> [snip]
>>
>> Thanks.
>>
>> Coly Li



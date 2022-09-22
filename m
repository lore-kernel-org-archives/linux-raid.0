Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D8DAC6FA82
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 11:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiIVLWD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 07:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiIVLWD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 07:22:03 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609A6DE0FD
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 04:22:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845722; x=1695381722;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=9XaaMHYjyYhOMgI83xkMLalcvU4hYM8CcgMnR6Rbh6w=;
  b=ACaH9cKj2XgsSUNyq02n36ec0qLyKTfdj3nyWTx1RaABYSOXXGbKhyUr
   d44AEUDJlAMAQGCOPckTBfv+PAv51NVu26D7nz3BqFqMEpSralfuF4edY
   4nhmzxOzhjWDk3hwyzg4PE8Vkp12QILXkkbh5tPOOlpR4Q0rGOPcJdMcl
   1AZTFkD2bpXNLhIZ+J1h4XB2Oxsd4hYmNifV4Mk1aAEtQSXlvQGUje81W
   JGD19a792vW08VFDCoPssV8JciAdtCEcwitOnblMFrMivnyUcD1YRTDCP
   W/FzaTaGKpdQXXaPB7Lx+h/qU/hvQfBYF12y9vxViGy7G1r2hw+hHmarp
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="297867899"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="297867899"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="597394976"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:00 -0700
Message-ID: <0d8322fc-f457-ed65-811e-adc90b6a4970@linux.intel.com>
Date:   Thu, 22 Sep 2022 13:21:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 06/10] super1: refactor the code for enum
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-7-mateusz.kusiak@intel.com>
 <79C06B27-C8DD-4E87-9C40-72160D26C641@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <79C06B27-C8DD-4E87-9C40-72160D26C641@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 14/09/2022 17:03, Coly Li wrote:
> 
> 
>> 2022年8月18日 22:56，Mateusz Kusiak <mateusz.kusiak@intel.com> 写道：
>>
>> It prepares update_super1 for change context->update to enum.
>> Change if else statements into switch.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>> super1.c | 149 ++++++++++++++++++++++++++++++++-----------------------
>> 1 file changed, 87 insertions(+), 62 deletions(-)
>>
>> diff --git a/super1.c b/super1.c
>> index 71af860c..6c81c1b9 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -1212,30 +1212,53 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>> 	int rv = 0;
>> 	struct mdp_superblock_1 *sb = st->sb;
>> 	bitmap_super_t *bms = (bitmap_super_t*)(((char*)sb) + MAX_SB_SIZE);
>> +	enum update_opt update_enum = map_name(update_options, update);
>>
>> -	if (strcmp(update, "homehost") == 0 &&
>> -	    homehost) {
>> -		/* Note that 'homehost' is special as it is really
>> +	if (update_enum == UOPT_HOMEHOST && homehost) {
>> +		/*
>> +		 * Note that 'homehost' is special as it is really
>> 		 * a "name" update.
>> 		 */
>> 		char *c;
>> -		update = "name";
>> +		update_enum = UOPT_NAME;
>> 		c = strchr(sb->set_name, ':');
>> 		if (c)
>> -			strncpy(info->name, c+1, 31 - (c-sb->set_name));
>> +			snprintf(info->name, sizeof(info->name), "%s", c+1);
>> 		else
>> -			strncpy(info->name, sb->set_name, 32);
>> -		info->name[32] = 0;
>> +			snprintf(info->name, sizeof(info->name), "%s", sb->set_name);
>> 	}
>>
>> -	if (strcmp(update, "force-one")==0) {
>> +	switch (update_enum) {
>> +	case UOPT_NAME:
>> +		if (!info->name[0])
>> +			snprintf(info->name, sizeof(info->name), "%d", info->array.md_minor);
>> +		memset(sb->set_name, 0, sizeof(sb->set_name));
>> +		int namelen;
>> +
> 
> The above variable ’namelen’ might be declared at beginning of this code block.

I'll fix this in v2.
> 
>> +		namelen = strnlen(homehost, MD_NAME_MAX) + 1 + strnlen(info->name, MD_NAME_MAX);
>> +		if (homehost &&
>> +		    strchr(info->name, ':') == NULL &&
>> +		    namelen < MD_NAME_MAX) {
>> +			strcpy(sb->set_name, homehost);
>> +			strcat(sb->set_name, ":");
>> +			strcat(sb->set_name, info->name);
>> +		} else {
>> +			namelen = min((int)strnlen(info->name, MD_NAME_MAX),
>> +				      (int)sizeof(sb->set_name) - 1);
>> +			memcpy(sb->set_name, info->name, namelen);
>> +			memset(&sb->set_name[namelen], '\0',
>> +			       sizeof(sb->set_name) - namelen);
>> +		}
>> +		break;
>>
> [snipped]
>> @@ -1569,32 +1589,37 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>> 			}
>> 		done:;
>> 		}
>> -	} else if (strcmp(update, "_reshape_progress") == 0)
>> +		break;
>> +	case UOPT_SPEC__RESHAPE_PROGRESS:
>> 		sb->reshape_position = __cpu_to_le64(info->reshape_progress);
>> -	else if (strcmp(update, "writemostly") == 0)
>> -		sb->devflags |= WriteMostly1;
>> -	else if (strcmp(update, "readwrite") == 0)
>> +		break;
>> +	case UOPT_SPEC_READWRITE:
>> 		sb->devflags &= ~WriteMostly1;
>> -	else if (strcmp(update, "failfast") == 0)
> 
> Writemostly-setting is removed here, is it on purpose ?

No, thanks for noticing! I'll add this in v2.
> 
> [snip]
> 
> Thanks.
> 
> Coly Li

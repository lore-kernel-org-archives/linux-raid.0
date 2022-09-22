Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B69E5C54EE9
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 11:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiIVLWQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 07:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiIVLWP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 07:22:15 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D75E8ABF21
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 04:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845734; x=1695381734;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=FDZLSEZP6D1nYTqFWyuTp/94rHW8R9KCS6bKwLycszg=;
  b=cb+jCaYRiUQzm8ciLeeoNLRCPsZeEyzfh7IlT+eW4RD2DNC1pP7NhX1F
   +bqJBkSt2mmN27WCG/cRmXzYE107TPs7H4sohTBYFo1QKHede3qC6YW/s
   QPdGXmdjBITEJPoXeVebd9YlT+yUCqVYlElccF+WJ+DR/MDFj7xTO3Obc
   0A0cEsX2mbPThtKYNWEjdFuH/Tv1niz0DeLJLpk0fUm7RpGXI7oH8USgu
   jULip4BMMPXP/kRqHrUcjXXjHifsieIY9XExbGn3LroKxYPzWKOSuJG18
   L9xZ/lfQ5cvG3p1c+/QehbtiK0GZo8WORtzY5NZT9Vk7NUT0fkFHXx9AO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280638955"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="280638955"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:14 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="948556107"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:22:13 -0700
Message-ID: <4c03c96d-8689-9a3b-e6aa-a2eb7bd06e2c@linux.intel.com>
Date:   Thu, 22 Sep 2022 13:22:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 07/10] super-intel: refactor the code for enum
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-8-mateusz.kusiak@intel.com>
 <78011938-BC68-4E12-BD0A-F49F1EE6FA65@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <78011938-BC68-4E12-BD0A-F49F1EE6FA65@suse.de>
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
>> It prepares super-intel for change context->update to enum.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>> ---
>> super-intel.c | 38 +++++++++++++++++++++++++-------------
>> 1 file changed, 25 insertions(+), 13 deletions(-)
>>
>> diff --git a/super-intel.c b/super-intel.c
>> index 672f946e..3de3873e 100644
>> --- a/super-intel.c
>> +++ b/super-intel.c
>> @@ -3930,7 +3930,8 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
>>
>> 	mpb = super->anchor;
>>
>> -	if (strcmp(update, "uuid") == 0) {
>> +	switch (map_name(update_options, update)) {
>> +	case UOPT_UUID:
>> 		/* We take this to mean that the family_num should be updated.
>> 		 * However that is much smaller than the uuid so we cannot really
>> 		 * allow an explicit uuid to be given.  And it is hard to reliably
>> @@ -3954,10 +3955,14 @@ static int update_super_imsm(struct supertype *st, struct mdinfo *info,
>> 		}
>> 		if (rv == 0)
>> 			mpb->orig_family_num = info->uuid[0];
>> -	} else if (strcmp(update, "assemble") == 0)
>> +		break;
>> +	case UOPT_SPEC_ASSEMBLE:
>> 		rv = 0;
>> -	else
>> +		break;
>> +	default:
>> 		rv = -1;
>> +		break;
>> +	}
>>
>> 	/* successful update? recompute checksum */
>> 	if (rv == 0)
>> @@ -7888,18 +7893,25 @@ static int kill_subarray_imsm(struct supertype *st, char *subarray_id)
>>
>> 	return 0;
>> }
>> -
>> -static int get_rwh_policy_from_update(char *update)
>> +/**
>> + * get_rwh_policy_from_update() - Get the rwh policy for update option.
>> + * @update: Update option.
>> + */
> 
> 
> The above comment format is not the existed code comments style.
> 
> For example for getinfo_super_disks_imsm() in same file,
> 
>  3862 /* allocates memory and fills disk in mdinfo structure
>  3863  * for each disk in array */
>  3864 struct mdinfo *getinfo_super_disks_imsm(struct supertype *st)
> 
I believe it matches kernel style descriptions, like in
imsm_get_free_size(). I can add "Return" part if you want me to.

I just noticed that empty line is missing before the function
description, I'll fix this in v2.
> 
> [snipped]
> 
> The rested part is fine to me.
> 
> Thanks.
> 
> Coly Li

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3664EC54EE9
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 11:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbiIVLVw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 07:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiIVLVv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 07:21:51 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 878CBABF21
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 04:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845710; x=1695381710;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1S1WisA7PpOUnsNrsqdTKkUdJin6nZx+MwbUGbF3LfM=;
  b=CnP8BIJC6CB/EesKQoj59zG6y9ylZ2YZXlPesXPn96J+L8+hFGlhor+F
   I5F1eiHVmM3pDLw0iMhZOGma0cg/35r0qC0pj8JDwR1wL9tdPp8nDea56
   ZWdAwhnLxJtl4hfwIkzW0mf5WZbpFvwXmvCSbGvZD31S830bkssN6BkrG
   vUedc/COHASXCSB4qBmozpy6+jGyx2cJ9TuhzFoWvZUOkc/uXPEwUwW0b
   O57skt50+Sko8LCD39YFsA4Dsc/oS7tZtKcoP1q8tskSk2l0Dj+V0rtKF
   hM9Uw6LTuuYnmcHY0A5k3+1uEXSJj45DPJbswxuvvK06cvDH6daFk3RG/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="287349529"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="287349529"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:21:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="597394923"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:21:47 -0700
Message-ID: <88af51e7-ebb3-679e-9ae8-f28813908626@linux.intel.com>
Date:   Thu, 22 Sep 2022 13:21:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 05/10] super0: refactor the code for enum
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-6-mateusz.kusiak@intel.com>
 <4E9ADC20-2C7C-4438-A11A-766DF7078AC6@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <4E9ADC20-2C7C-4438-A11A-766DF7078AC6@suse.de>
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
>> It prepares update_super0 for change context->update to enum.
>> Change if else statements to switch.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> 
> 
> This patch is fine to me almost, except for 2 questions I placed in line.
> 
> 
> 
>> ---
>> super0.c | 102 ++++++++++++++++++++++++++++++++++---------------------
>> 1 file changed, 63 insertions(+), 39 deletions(-)
>>
>> diff --git a/super0.c b/super0.c
>> index 37f595ed..4e53f41e 100644
>> --- a/super0.c
>> +++ b/super0.c
>> @@ -502,19 +502,39 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
>> 	int rv = 0;
>> 	int uuid[4];
>> 	mdp_super_t *sb = st->sb;
>> +	enum update_opt update_enum = map_name(update_options, update);
>>
>> -	if (strcmp(update, "homehost") == 0 &&
>> -	    homehost) {
>> -		/* note that 'homehost' is special as it is really
>> +	if (update_enum == UOPT_HOMEHOST && homehost) {
>> +		/*
>> +		 * note that 'homehost' is special as it is really
>> 		 * a "uuid" update.
>> 		 */
>> 		uuid_set = 0;
>> -		update = "uuid";
>> +		update_enum = UOPT_UUID;
>> 		info->uuid[0] = sb->set_uuid0;
>> 		info->uuid[1] = sb->set_uuid1;
>> 	}
>>
>> -	if (strcmp(update, "sparc2.2")==0 ) {
>> +	switch (update_enum) {
>> +	case UOPT_UUID:
>> +		if (!uuid_set && homehost) {
>> +			char buf[20];
>> +			memcpy(info->uuid+2,
>> +			       sha1_buffer(homehost, strlen(homehost), buf),
>> +			       8);
>> +		}
>> +		sb->set_uuid0 = info->uuid[0];
>> +		sb->set_uuid1 = info->uuid[1];
>> +		sb->set_uuid2 = info->uuid[2];
>> +		sb->set_uuid3 = info->uuid[3];
>> +		if (sb->state & (1<<MD_SB_BITMAP_PRESENT)) {
>> +			struct bitmap_super_s *bm;
>> +			bm = (struct bitmap_super_s *)(sb+1);
>> +			uuid_from_super0(st, uuid);
>> +			memcpy(bm->uuid, uuid, 16);
>> +		}
>> +		break;
>> +	case UOPT_SPARC22: {
>> 		/* 2.2 sparc put the events in the wrong place
>> 		 * So we copy the tail of the superblock
>> 		 * up 4 bytes before continuing
>> @@ -527,12 +547,15 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
>> 		if (verbose >= 0)
>> 			pr_err("adjusting superblock of %s for 2.2/sparc compatibility.\n",
>> 			       devname);
>> -	} else if (strcmp(update, "super-minor") ==0) {
>> +		break;
>> +	}
> 
> 
> Wondering there isn't compiler warning for unmatched case/break pair, since this break is inside the {} code block.
> 
> Should the ‘break’ be placed after {} pair to match key word ‘case’?
> 
Hi Coly,
I do not get compiler warning, what's more, this approach is commonly
used across the code.
I can change it in v2 if you want me to.
> 
>>
> [snipped]
>> @@ -628,29 +659,15 @@ static int update_super0(struct supertype *st, struct mdinfo *info,
>> 		sb->disks[info->disk.number].minor = info->disk.minor;
>> 		sb->disks[info->disk.number].raid_disk = info->disk.raid_disk;
>> 		sb->disks[info->disk.number].state = info->disk.state;
>> -	} else if (strcmp(update, "resync") == 0) {
>> -		/* make sure resync happens */
>> +		break;
>> +	case UOPT_RESYNC:
>> +		/**
>> +		 *make sure resync happens
>> +		 */
> 
> 
> The above change doesn’t follow existing code style for comments. How about using the previous one line version?
> 
Personaly, I'd rather change it from "/**" to "/*". I think we should
gradually adapt the code to kernel coding style.
Are you fine with that?

> [snipped]
> 
> Thanks.
> 
> Coly Li

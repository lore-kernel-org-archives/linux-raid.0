Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E467C6FA82
	for <linux-raid@archiver.kernel.org>; Thu, 22 Sep 2022 11:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiIVLVc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Sep 2022 07:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229911AbiIVLVa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 22 Sep 2022 07:21:30 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178E9E05D7
        for <linux-raid@vger.kernel.org>; Thu, 22 Sep 2022 04:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663845690; x=1695381690;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/1W8ydwmilWVVqr7m63/3xMD13JAFZIcsBOI66z0kGM=;
  b=Ap3gxTHwpCW2xDEH91v4eN5DXG7aNFPYr/O+/X+9ZJnhvtsneNJN326H
   wJD0LJUZ3GZwZyDIksX5G2PgQxvRjvYMeuM2LyT6TUW/u9Qvr/oChgWF8
   4Vh8s9c5xER+iiZXC+Hd0ZgiTKmJh1U8dGuRcA2GRH9aVo1stuhRUU2Nb
   1ATnPxWNg/RUPP1OwPasC6To26iTbwb9bJzuYDLylDlBIWsp13fLmAgaR
   mDtOEPw5a/m1gyONLxBHrWoxIX42GUtRVohqC+NMuUx3clApNkA3rb10T
   HhNI0cgytQWQJANJ27FKwwULQZHmyo/vyv7bbgmZh5OZbVsRCc2L/x6+V
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301116480"
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="301116480"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:21:29 -0700
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="597394847"
Received: from mkusiak-mobl.ger.corp.intel.com (HELO [10.213.5.202]) ([10.213.5.202])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 04:21:28 -0700
Message-ID: <c5ed7b25-97ae-21cd-c84a-a2595db869a2@linux.intel.com>
Date:   Thu, 22 Sep 2022 13:21:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 01/10] mdadm: Add option validation for --update-subarray
Content-Language: pl
To:     Coly Li <colyli@suse.de>, Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-2-mateusz.kusiak@intel.com>
 <D32199F4-907F-4B73-9D87-0DB0997A6739@suse.de>
From:   "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
In-Reply-To: <D32199F4-907F-4B73-9D87-0DB0997A6739@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 13/09/2022 17:12, Coly Li wrote:
> 
> 
>> 2022年8月18日 22:56，Mateusz Kusiak <mateusz.kusiak@intel.com> 写道：
>>
>> Subset of options available for "--update" is not same as for "--update-subarray".
>> Define maps and enum for update options and use them instead of direct comparisons.
>> Add proper error message.
>>
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> 
> 
> Hi Mateusz,
> 
> I place my questions in line with code,
> 
> 
>> ---
>> ReadMe.c | 31 ++++++++++++++++++
>> maps.c   | 31 ++++++++++++++++++
>> mdadm.c  | 99 ++++++++++++++++----------------------------------------
>> mdadm.h  | 32 +++++++++++++++++-
>> 4 files changed, 121 insertions(+), 72 deletions(-)
>>
>> diff --git a/ReadMe.c b/ReadMe.c
>> index 7518a32a..50e6f987 100644
>> --- a/ReadMe.c
>> +++ b/ReadMe.c
>> @@ -656,3 +656,34 @@ char *mode_help[mode_count] = {
>> 	[GROW]		= Help_grow,
>> 	[INCREMENTAL]	= Help_incr,
>> };
>> +
>> +/**
>> + * fprint_update_options() - Print valid update options depending on the mode.
>> + * @outf: File (output stream)
>> + * @update_mode: Used to distinguish update and update_subarray
>> + */
>> +void fprint_update_options(FILE *outf, enum update_opt update_mode)
>> +{
>> +	int counter = UOPT_NAME, breakpoint = UOPT_HELP;
>> +	mapping_t *map = update_options;
>> +
>> +	if (!outf)
>> +		return;
>> +	if (update_mode == UOPT_SUBARRAY_ONLY) {
>> +		breakpoint = UOPT_SUBARRAY_ONLY;
>> +		fprintf(outf, "Valid --update options for update-subarray are:\n\t");
>> +	} else
>> +		fprintf(outf, "Valid --update options are:\n\t");
>> +	while (map->num) {
>> +		if (map->num >= breakpoint)
>> +			break;
>> +		fprintf(outf, "'%s', ", map->name);
>> +		if (counter % 5 == 0)
>> +			fprintf(outf, "\n\t");
>> +		counter++;
>> +		map++;
>> +	}
>> +	if ((counter - 1) % 5)
>> +		fprintf(outf, "\n");
>> +	fprintf(outf, "\r");
> 
> 
> Why ‘\r’ is used here? I feel ‘\n’ should work fine as well.
> 
Hi Coly,
The reason is that '\n' leaves empty line after print.
> 
>> +}
>> diff --git a/maps.c b/maps.c
>> index 20fcf719..b586679a 100644
>> --- a/maps.c
>> +++ b/maps.c
>> @@ -165,6 +165,37 @@ mapping_t sysfs_array_states[] = {
>> 	{ "broken", ARRAY_BROKEN },
>> 	{ NULL, ARRAY_UNKNOWN_STATE }
>> };
>> +/**
>> + * mapping_t update_options - stores supported update options.
>> + */
>> +mapping_t update_options[] = {
>> +	{ "name", UOPT_NAME },
>> +	{ "ppl", UOPT_PPL },
>> +	{ "no-ppl", UOPT_NO_PPL },
>> +	{ "bitmap", UOPT_BITMAP },
>> +	{ "no-bitmap", UOPT_NO_BITMAP },
>> +	{ "sparc2.2", UOPT_SPARC22 },
>> +	{ "super-minor", UOPT_SUPER_MINOR },
>> +	{ "summaries", UOPT_SUMMARIES },
>> +	{ "resync", UOPT_RESYNC },
>> +	{ "uuid", UOPT_UUID },
>> +	{ "homehost", UOPT_HOMEHOST },
>> +	{ "home-cluster", UOPT_HOME_CLUSTER },
>> +	{ "nodes", UOPT_NODES },
>> +	{ "devicesize", UOPT_DEVICESIZE },
>> +	{ "bbl", UOPT_BBL },
>> +	{ "no-bbl", UOPT_NO_BBL },
>> +	{ "force-no-bbl", UOPT_FORCE_NO_BBL },
>> +	{ "metadata", UOPT_METADATA },
>> +	{ "revert-reshape", UOPT_REVERT_RESHAPE },
>> +	{ "layout-original", UOPT_LAYOUT_ORIGINAL },
>> +	{ "layout-alternate", UOPT_LAYOUT_ALTERNATE },
>> +	{ "layout-unspecified", UOPT_LAYOUT_UNSPECIFIED },
>> +	{ "byteorder", UOPT_BYTEORDER },
>> +	{ "help", UOPT_HELP },
>> +	{ "?", UOPT_HELP },
>> +	{ NULL, UOPT_UNDEFINED}
>> +};
>>
>> /**
>>  * map_num_s() - Safer alternative of map_num() function.
>> diff --git a/mdadm.c b/mdadm.c
>> index 56722ed9..3705d114 100644
>> --- a/mdadm.c
>> +++ b/mdadm.c
>> @@ -101,7 +101,7 @@ int main(int argc, char *argv[])
>> 	char *dump_directory = NULL;
>>
>> 	int print_help = 0;
>> -	FILE *outf;
>> +	FILE *outf = NULL;
>>
>> 	int mdfd = -1;
>> 	int locked = 0;
>> @@ -753,82 +753,39 @@ int main(int argc, char *argv[])
>> 				pr_err("Only subarrays can be updated in misc mode\n");
>> 				exit(2);
>> 			}
>> +
>> 			c.update = optarg;
>> -			if (strcmp(c.update, "sparc2.2") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "super-minor") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "summaries") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "resync") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "uuid") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "name") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "homehost") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "home-cluster") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "nodes") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "devicesize") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "bitmap") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "no-bitmap") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "bbl") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "no-bbl") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "force-no-bbl") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "ppl") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "no-ppl") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "metadata") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "revert-reshape") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "layout-original") == 0 ||
>> -			    strcmp(c.update, "layout-alternate") == 0 ||
>> -			    strcmp(c.update, "layout-unspecified") == 0)
>> -				continue;
>> -			if (strcmp(c.update, "byteorder") == 0) {
>> +			enum update_opt updateopt = map_name(update_options, c.update);
>> +			enum update_opt print_mode = UOPT_HELP;
>> +			const char *error_addon = "update option";
>> +
> 
> Could you please move the local variables declaration to the beginning of the case O(MISC,'U’) code block?
> 
Sure, I'll post it in v2.
> 
>> +			if (devmode == UpdateSubarray) {
>> +				print_mode = UOPT_SUBARRAY_ONLY;
>> +				error_addon = "update-subarray option";
>> +
>> +				if (updateopt > UOPT_SUBARRAY_ONLY && updateopt < UOPT_HELP)
>> +					updateopt = UOPT_UNDEFINED;
>> +			}
>> +
>> +			switch (updateopt) {
>> +			case UOPT_UNDEFINED:
>> +				pr_err("'--update=%s' is invalid %s. ",
>> +					c.update, error_addon);
>> +				outf = stderr;
>> +			case UOPT_HELP:
>> +				if (!outf)
>> +					outf = stdout;
>> +				fprint_update_options(outf, print_mode);
>> +				exit(outf == stdout ? 0 : 2);
> 
> 
> I tried to run update-subarray parameter but failed, obviously wrong command line format. Could you please give me a hint, on how to test the —update-subarray parameter? Then I can provide more feed back after experience the command.
>Sure, the exaple command is as follows:
# mdadm --update-subarray=0 --update=name --name=example
/dev/md/container

The command must be performed on a container, to succeed the volume must
be stopped.
All update options for update-subarray can be listed with:
# mdadm --update-subarray=0 --update=help
..and "global" update options with:
# mdadm -A --update=help

> The comments for rested patches will be posted after can I run and verify the change with my eyes.
> 
> Thanks.
> 
> Coly Li
> 

[Snipped]

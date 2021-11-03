Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4AE8C433F5
	for <linux-raid@archiver.kernel.org>; Wed,  3 Nov 2021 09:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD66B610FC
	for <linux-raid@archiver.kernel.org>; Wed,  3 Nov 2021 09:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231775AbhKCJLS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 3 Nov 2021 05:11:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:60537 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231435AbhKCJLR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 3 Nov 2021 05:11:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10156"; a="231307932"
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="231307932"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2021 02:08:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,205,1631602800"; 
   d="scan'208";a="729060349"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 03 Nov 2021 02:08:39 -0700
Received: from [10.249.152.91] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.152.91])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 7FEDE5805CB;
        Wed,  3 Nov 2021 02:08:38 -0700 (PDT)
Message-ID: <e6a6f841-1fe8-5cee-edf9-84a98d9b22c7@linux.intel.com>
Date:   Wed, 3 Nov 2021 10:08:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [PATCH] mdopen: use safe functions in create_mddev
Content-Language: en-US
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
References: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
 <c8239095-aec5-142f-77e8-d0e71e8caf3b@trained-monkey.org>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
In-Reply-To: <c8239095-aec5-142f-77e8-d0e71e8caf3b@trained-monkey.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

> The switch to using NAME_MAX has some side effects I am a little
> concerned about, however the code is also really tricky to get your head
> around (not your fault).
> 
My first idea was to rewrite it at all but there is more nits
(like --name parameter and config). It is not a task for rc stage.


>> @@ -160,10 +170,13 @@ int create_named_array(char *devnm)
>>    * /dev/mdXX in 'chosen'.
>>    *
>>    * When we create devices, we use uid/gid/umask from config file.
>> + *
>> + * Return: O_EXCL file descriptor or negative integer.
>> + *
>> + * Null terminated name for the volume is returned via *chosen.
>>    */
>> -
>> -int create_mddev(char *dev, char *name, int autof, int trustworthy,
>> -		 char *chosen, int block_udev)
>> +int create_mddev(const char *dev, const char *name, int autof, int trustworthy,
>> +		 char *chosen, const size_t chosen_size, int block_udev)
>>   {
>>   	int mdfd;
>>   	struct stat stb;
>> @@ -171,16 +184,24 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>>   	int use_mdp = -1;
>>   	struct createinfo *ci = conf_get_create_info();
>>   	int parts;
>> +	const size_t cname_size = NAME_MAX;
>>   	char *cname;
>> -	char devname[37];
>> -	char devnm[32];
>> -	char cbuf[400];
>> +	char devname[NAME_MAX + 5];
>> +	char devnm[NAME_MAX] = "\0";
>> +	static const char dev_md_path[] = "/dev/md/";
> 
> This is quite a lot of additional stack space used going from 32+37 to
> 512, however reducing the arbitrary 400 bytes size of cbuf is a good thing.
Just wanted to use one size for names, i understand that it can be too big
so if you have other proposal, let me know.

> 
>> @@ -188,35 +209,48 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>>   	parts = autof >> 3;
>>   	autof &= 7;
>>   
>> -	strcpy(chosen, "/dev/md/");
>> -	cname = chosen + strlen(chosen);
>> +	if (chosen_size <= strlen(dev_md_path) + cname_size) {
>> +		dprintf("Chosen buffer is to small.\n");
>> +		return -1;
>> +	}
> 
> cname_size = NAME_MAX = 255
> 
> Ie. if something calls create_mddev() with a chosen_size smaller than
> 263, this check will fail, which seems rather arbitrary. It does look
> like we always use a chosen_name[1024] which is silly wasteful, but
> there much be a better solution to this. Maybe malloc() and return the
> buffer instead of relying on those large stack frames?
> 
With malloc, I will need to add free() everywhere, I don't think
that it is good option.
I agree that this check can be removed, especially that now it is
always called with size 1024.

>> +	strncpy(chosen, dev_md_path, chosen_size);
>> +	cname = chosen + strlen(dev_md_path);
>>   
>>   	if (dev) {
>> -		if (strncmp(dev, "/dev/md/", 8) == 0) {
>> -			strcpy(cname, dev+8);
>> -		} else if (strncmp(dev, "/dev/", 5) == 0) {
>> -			char *e = dev + strlen(dev);
>> +		if (strncmp(dev, dev_md_path, 8) == 0)
>> +			strncpy(cname, dev+8, cname_size);
> 
> sizeof(dev_md_path) instead of the hardcoded 8?
> 
>> +		else if (strncmp(dev, dev_md_path, 5) == 0) {
>> +			const char *e = dev + 5 + strnlen(dev + 5, NAME_MAX);
>> +>  			while (e > dev && isdigit(e[-1]))
>>   				e--;>  			if (e[0])
>>   				num = strtoul(e, NULL, 10);
>> -			strcpy(cname, dev+5);
>> +			strncpy(cname, dev + 5, cname_size);
>>   			cname[e-(dev+5)] = 0;
>> +
>>   			/* name *must* be mdXX or md_dXX in this context */
>>   			if (num < 0 ||
>> -			    (strcmp(cname, "md") != 0 && strcmp(cname, "md_d") != 0)) {
>> +			    (strncmp(cname, "md", 2) != 0 &&
>> +			     strncmp(cname, "md_d", 4) != 0)) {
>>   				pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
>>   					dev, dev+5);
>>   				return -1;
>>   			}
>> -			if (strcmp(cname, "md") == 0)
>> +			if (strncmp(cname, "md", 2) == 0)
>>   				use_mdp = 0;
>>   			else
>>   				use_mdp = 1;
>>   			/* recreate name: /dev/md/0 or /dev/md/d0 */
>> -			sprintf(cname, "%s%d", use_mdp?"d":"", num);
>> +			snprintf(cname, cname_size, "%s%d",
>> +				 use_mdp ? "d" : "", num);
>>   		} else
>> -			strcpy(cname, dev);
>> +			strncpy(cname, dev, cname_size);
>> +		/*
>> +		 * Force null termination for long names.
>> +		 */
>> +		cname[cname_size - 1] = '\0';
>>   
>>   		/* 'cname' must not contain a slash, and may not be
>>   		 * empty.
> 
> My head started spinning by the time I got to here.
> 
> The more I think about it, the more I think we should allocate an
> appropriate buffer in here and return that, rather than play all those
> bounds checking games.
> 
> Thoughts?
> 
We need to return mdfd too, so cannot return from here.

First we need to determine how it should work.
The code now is quite unpredictable but it is working for
years. I just tried to fix static code analysis errors for
now. My concerns are here:
#mdadm -CR /dev/mdx --name=test ...
#mdadm -CR name --name=test ...
#mdadm -CR /dev/md/name --name=test ...

We can define volume by *dev and *name (--name=) and it
is not well defined how it should behave. I will need
to start with determining it first and later adapt
other stuff (assemble and incremental).

So, it requires separate discussion and will
be a release blocker.

Thanks,
Mariusz

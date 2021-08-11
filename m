Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54ECBC4338F
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 13:06:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C39260D07
	for <linux-raid@archiver.kernel.org>; Wed, 11 Aug 2021 13:06:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhHKNG4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Aug 2021 09:06:56 -0400
Received: from mga12.intel.com ([192.55.52.136]:56378 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhHKNG4 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Aug 2021 09:06:56 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="194705077"
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="194705077"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2021 06:06:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="526929423"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga002.fm.intel.com with ESMTP; 11 Aug 2021 06:06:30 -0700
Received: from [10.213.3.231] (mtkaczyk-MOBL1.ger.corp.intel.com [10.213.3.231])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id E9449580815;
        Wed, 11 Aug 2021 06:06:29 -0700 (PDT)
Subject: Re: [PATCH] Fix return value from fstat calls
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20210810151507.1667518-1-ncroxon@redhat.com>
 <ed1b0603-e523-6ca6-12ce-d30a85afe885@linux.intel.com>
Message-ID: <4d5a4bb0-e044-c225-f507-59d4167a8807@linux.intel.com>
Date:   Wed, 11 Aug 2021 15:06:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <ed1b0603-e523-6ca6-12ce-d30a85afe885@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

+ linux raid

Mariusz

On 11.08.2021 15:03, Tkaczyk, Mariusz wrote:
> On 10.08.2021 17:15, Nigel Croxon wrote:
>> To meet requirements of Common Criteria certification vulnerablility
>> assessment. Static code analysis has been run and found the following
>> errors:
>> check_return: Calling "fstat(fd, &dstb)" without checking return value.
>> This library function may fail and return an error code.
>>
>> Changes are to add a test to the return value from fstat calls.
>>
> 
> Hi Nigel,
> You introduce three different errors, repeated many times across code.
> Could you make it generic using function or macro?
> 
>> diff --git a/Assemble.c b/Assemble.c
>> index 0df46244..cae3224b 100644
>> --- a/Assemble.c
>> +++ b/Assemble.c
>> @@ -649,7 +649,14 @@ static int load_devices(struct devs *devices, char *devmap,
>>               /* prepare useful information in info structures */
>>               struct stat stb2;
>>               int err;
>> -            fstat(mdfd, &stb2);
>> +
>> +            if (fstat(mdfd, &stb2) != 0) {
>> +                pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
>> +                close(mdfd);
>> +                free(devices);
>> +                free(devmap);
>> +                return -1;
>> +            }
> another new case with direct error handling, could you use goto statement?
> 
> 
>> @@ -760,7 +767,17 @@ static int load_devices(struct devs *devices, char *devmap,
>>               tst->ss->getinfo_super(tst, content, devmap + devcnt * 
>> content->array.raid_disks);
>>           }
>> -        fstat(dfd, &stb);
>> +        if (fstat(dfd, &stb) != 0) {
>> +            pr_err("fstat failed for %s: %s - aborting\n",devname, 
>> strerror(errno));
>> +            close(dfd);
>> +            close(mdfd);
>> +            free(devices);
>> +            free(devmap);
>> +            tst->ss->free_super(tst);
>> +            free(tst);
>> +            *stp = st;
>> +            return -1;
>> +        }
> Same here, I know that it is implemented this way, but we should take care about
> code quality, this is our common interest.
> 
>> diff --git a/Dump.c b/Dump.c
>> index 736bcb60..d1a8bb86 100644
>> --- a/Dump.c
>> +++ b/Dump.c
>> @@ -112,7 +112,14 @@ int Dump_metadata(char *dev, char *dir, struct context *c,
>>       }
>>       if (c->verbose >= 0)
>>           printf("%s saved as %s.\n", dev, fname);
>> -    fstat(fd, &dstb);
>> +
>> +    if (fstat(fd, &dstb) != 0) {
>> +        pr_err("fstat failed from %s: %s\n",fname, strerror(errno));
>> +        close(fd);
>> +        close(fl);
>> +        free(fname);
>> +        return 1;
>> +    }
> Same here.
> 
>> @@ -200,7 +207,11 @@ int Restore_metadata(char *dev, char *dir, struct context 
>> *c,
>>           char *chosen = NULL;
>>           unsigned int chosen_inode = 0;
>> -        fstat(fd, &dstb);
>> +        if (fstat(fd, &dstb) != 0) {
>> +            pr_err("fstat failed for %s: %s\n",dev, strerror(errno));
>> +            close(fd);
>> +            return 1;
>> +        }
>>           while (d && (de = readdir(d)) != NULL) {
>>               if (de->d_name[0] == '.')
>> diff --git a/Grow.c b/Grow.c
>> index 7506ab46..4c3ec9c1 100644
>> --- a/Grow.c
>> +++ b/Grow.c
>> @@ -1163,9 +1163,17 @@ int reshape_open_backup_file(char *backup_file,
>>        * way this will not notice, but it is better than
>>        * nothing.
>>        */
>> -    fstat(*fdlist, &stb);
>> +    if (fstat(*fdlist, &stb) != 0) {
>> +        pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
>> +        close(*fdlist);
>> +        return 0;
>> +    }
>>       dev = stb.st_dev;
>> -    fstat(fd, &stb);
>> +    if (fstat(fd, &stb) != 0) {
>> +        pr_err("fstat failed for %s: %s\n",devname, strerror(errno));
>> +        close(*fdlist);
>> +        return 0;
>> +    }
>>       if (stb.st_rdev == dev) {
>>           pr_err("backup file must NOT be on the array being reshaped.\n");
>>           close(*fdlist);
> Same error handling duplicated.
> 
> Thanks,
> Mariusz
> 


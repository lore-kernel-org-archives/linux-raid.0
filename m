Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D385414E2F2
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 09:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756288048; cv=none; b=sznuEl2xcJ6VXBhYV/hTL/ly7x6s3w68ZBXfVSbs05QGSZEePiygATDh5B0ei2auP6RZ505kIWOvzTLtzRGtHMam6xeZ3ptYY1nXQCNv4vSfEBe9UhAuR0XVNOEzFEG5HpKlE6fRJceRroS14OZyQ8HQ46+lHv7LVHXyjV/24J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756288048; c=relaxed/simple;
	bh=sLqwcs9+/XLCr3hdbH8c9vp4wsqx5dFWckC8pJMajv4=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=VjLm0BhaaACkFf1ICwPVOfoyrcETrLPgfdbzxud4iFyhA9kenkA4HCvuWvCeTxdzuDBmMHgbuPm4MRrtMpBr8i6pMBh7+NoDik6a4DlcEMn8J24/m6MKTfDJ8Au/hlKP7m39yiVcNek4Wjm1KVAv8v/aPjAy9uOmKa+htRrYU5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cBfp531vKzYQtGt
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 17:47:25 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EDE301A15AC
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 17:47:23 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY4r1K5oQWHXAQ--.55666S3;
	Wed, 27 Aug 2025 17:47:23 +0800 (CST)
Subject: Re: [PATCH v3] md: Allow setting persistent superblock version for
 md= command line
To: Yu Kuai <yukuai1@huaweicloud.com>, jeremias@jears.at,
 Linux Raid <linux-raid@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250825144029.2924-1-jeremias@jears.at>
 <cb9539bb95a2cbfc723a96d7ff31c1dd@jears.at>
 <7618b3df-87e6-b522-489b-d04bf87a06f1@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9ecaee59-ce3b-7bf6-d9fc-af054a430a55@huaweicloud.com>
Date: Wed, 27 Aug 2025 17:47:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <7618b3df-87e6-b522-489b-d04bf87a06f1@huaweicloud.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY4r1K5oQWHXAQ--.55666S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWUCr4fKr4xtF1xZF1kKrg_yoW3XF4rpr
	1kJFW5Gry8Grn3Jr18Jr18ZFy5tr1xJ3Z7Jr1xXF1UJr47Ar1jgryUXr1qgr1UJr48Jr1U
	AF1UXr13ur17JrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkG14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4U
	MIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdEfOUUU
	UU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/27 15:26, Yu Kuai 写道:
> Hi,
> 
> 在 2025/08/25 22:53, jeremias@jears.at 写道:
>> This allows for setting a superblock version on the kernel command 
>> line to be
>> able to assemble version >=1.0 arrays. It can optionally be set like 
>> this:
>>
>> md=vX.X,...
>>
>> This will set the version of the array before assembly so it can be 
>> assembled
>> correctly.
>>
> 
> You should explain that current autodetect is only supported for 0.90
> array.
> 
>> Also updated docs accordingly.
>>
>> v2: Use pr_warn instead of printk
>>
>> v3: Change order of options so it stays with past pattern
>>
>> Signed-off-by: Jeremias Stotter <jeremias@jears.at>
>> ---
>>   Documentation/admin-guide/md.rst |  8 +++++
>>   drivers/md/md-autodetect.c       | 59 ++++++++++++++++++++++++++++++--
>>   2 files changed, 65 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/md.rst 
>> b/Documentation/admin-guide/md.rst
>> index 4ff2cc291d18..f57ae871c997 100644
>> --- a/Documentation/admin-guide/md.rst
>> +++ b/Documentation/admin-guide/md.rst
>> @@ -23,6 +23,14 @@ or, to assemble a partitionable array::
>>
>>     md=d<md device no.>,dev0,dev1,...,devn
>>
>> +if you are using superblock versions greater than 0, use the following::
>> +
>> +  md=<md device no.>,v<superblock version no.>,dev0,dev1,...,devn
>> +
>> +for example, for a raid array with superblock version 1.2 it could 
>> look like this::
>> +
>> +  md=0,v1.2,/dev/sda1,/dev/sdb1
>> +
>>   ``md device no.``
>>   +++++++++++++++++
>>
> 
> What about md_autostart_arrays()? where 0.90 is still the only default
> choice.
>> diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
>> index 4b80165afd23..67d38559ad50 100644
>> --- a/drivers/md/md-autodetect.c
>> +++ b/drivers/md/md-autodetect.c
>> @@ -32,6 +32,8 @@ static struct md_setup_args {
>>       int partitioned;
>>       int level;
>>       int chunk;
>> +    int major_version;
>> +    int minor_version;
>>       char *device_names;
>>   } md_setup_args[256] __initdata;
>>
>> @@ -63,6 +65,7 @@ static int __init md_setup(char *str)
>>       char *pername = "";
>>       char *str1;
>>       int ent;
>> +    int major_i = 0, minor_i = 0;
>>
>>       if (*str == 'd') {
>>           partitioned = 1;
>> @@ -109,6 +112,49 @@ static int __init md_setup(char *str)
>>       case 0:
>>           md_setup_args[ent].level = LEVEL_NONE;
>>           pername="super-block";
>> +
>> +        if (*str == 'v') { /* Superblock version */
>> +            char *version = ++str;
>> +            char *version_end = strchr(str, ',');
>> +
>> +            if (!version_end) {
>> +                pr_warn("md: Version (%s) has been specified wrongly, 
>> no ',' found, use like this: md=<md dev. no.>,X.X,...\n",
>> +                    version);
>> +                return 0;
>> +            }
>> +            *version_end = '\0';
>> +            str = version_end + 1;
>> +
>> +            char *separator = strchr(version, '.');
>> +
>> +            if (!separator) {
>> +                pr_warn("md: Version (%s) has been specified wrongly, 
>> no '.' to separate major and minor version found, use like this: 
>> md=<md dev. no.>,vX.X,...\n",
>> +                    version);
>> +                return 0;
>> +            }
>> +            *separator = '\0';
>> +            char *minor_s = separator + 1;
>> +
>> +            int ret = kstrtoint(version, 10, &major_i);
>> +
>> +            if (ret != 0) {
>> +                pr_warn("md: Version has been specified wrongly, 
>> couldn't convert major '%s' to number, use like this: md=<md dev. 
>> no.>,vX.X,...\n",
>> +                    version);
>> +                return 0;
>> +            }
>> +            if (major_i != 0 && major_i != 1) {
>> +                pr_warn("md: Major version %d is not valid, use 0 or 
>> 1\n",
>> +                    major_i);
>> +                return 0;
>> +            }
>> +            ret = kstrtoint(minor_s, 10, &minor_i);
>> +            if (ret != 0) {
>> +                pr_warn("md: Version has been specified wrongly, 
>> couldn't convert minor '%s' to number, use like this: md=<md dev. 
>> no.>,vX.X,...\n",
>> +                    minor_s);
>> +                return 0;
>> +            }
>> +        }
>> +
>>       }
>>
>>       printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
>> @@ -116,6 +162,8 @@ static int __init md_setup(char *str)
>>       md_setup_args[ent].device_names = str;
>>       md_setup_args[ent].partitioned = partitioned;
>>       md_setup_args[ent].minor = minor;
>> +    md_setup_args[ent].minor_version = minor_i;
>> +    md_setup_args[ent].major_version = major_i;
>>
>>       return 1;
>>   }
>> @@ -200,6 +248,9 @@ static void __init md_setup_drive(struct 
>> md_setup_args *args)
>>
>>       err = md_set_array_info(mddev, &ainfo);
>>
>> +    mddev->major_version = args->major_version;
>> +    mddev->minor_version = args->minor_version;
> 
> I would expect to fix md_set_array_info() to hanlde this new case, to
> make code more readable.
> 
>> +
>>       for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
>>           struct mdu_disk_info_s dinfo = {
>>               .major    = MAJOR(devices[i]),
>> @@ -273,11 +324,15 @@ void __init md_run_setup(void)
>>   {
>>       int ent;
>>
>> +    /*
>> +     * Assemble manually defined raids first
>> +     */
>> +    for (ent = 0; ent < md_setup_ents; ent++)
>> +        md_setup_drive(&md_setup_args[ent]);
>> +

And BTW, take a closer look at autodetect code, although you set
mddev->major_version to 1, however, md_set_array_info() will set
mddev->raid_disks while mddev->pers is still NULL, hence from
md_add_new_disk(), -EINVAL will be returned directly:

md_add_new_disk
	if (!mddev->raid_disks)
		......
		return;
	if (mddev->pers)
		......
		return;

         /* otherwise, md_add_new_disk is only allowed
         ┊* for major_version==0 superblocks
         ┊*/
         if (mddev->major_version != 0) {
                 pr_warn("%s: ADD_NEW_DISK not supported\n", mdname(mddev));
                 return -EINVAL;
         }

What am I missing?

Thanks,
Kuai

> 
> You just explain what you did in comment, Why do you change the order?
> 
> Thanks,
> Kuai
> 
>>       if (raid_noautodetect)
>>           printk(KERN_INFO "md: Skipping autodetection of RAID arrays. 
>> (raid=autodetect will force)\n");
>>       else
>>           autodetect_raid();
>>
>> -    for (ent = 0; ent < md_setup_ents; ent++)
>> -        md_setup_drive(&md_setup_args[ent]);
>>   }
>>
>> .
>>
> 
> .
> 

And BTW, take a closer look at autodetect code, alouth


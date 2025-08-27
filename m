Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC773164BC
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 07:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756279581; cv=none; b=ahSbSl/ObZe34o+QPhaYOcG2d391fQf0kKoMf8X5N1ZYEHR7/vqfT9tN39u/OEHCCmMj59LVzAJ+97zg4U71K/3hVAVBTcaqskzSVV6H4B7ZIXeuO1BQwCbocysy75P9KoOApiM4CJswE7eDQQVRedN3PktDnB8bdWUV9MCJzJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756279581; c=relaxed/simple;
	bh=zycLLlNHwGYy+QHz8Ddqil6EH4JKtgp708SG9aoriW8=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=cebFB6mlalhGJhlk0Q+O3cZZ+Oog9XNotpNfWuHtLfkMLrjqqzPtbIZf7nx+RlmLsuSkcxesjwsf7g/nCQd0yy+WhWy5OCbfHdvcnuJ3yMprap2D6uXcaipHTymMvK/SzXlRvdpnQUurt2QypeZe/d3yibNMKlzL0bGnTgAF9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cBbgC1wPyzYQvgV
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 15:26:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C43D81A0841
	for <linux-raid@vger.kernel.org>; Wed, 27 Aug 2025 15:26:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY0Us65odiTMAQ--.53024S3;
	Wed, 27 Aug 2025 15:26:13 +0800 (CST)
Subject: Re: [PATCH v3] md: Allow setting persistent superblock version for
 md= command line
To: jeremias@jears.at, Linux Raid <linux-raid@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250825144029.2924-1-jeremias@jears.at>
 <cb9539bb95a2cbfc723a96d7ff31c1dd@jears.at>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7618b3df-87e6-b522-489b-d04bf87a06f1@huaweicloud.com>
Date: Wed, 27 Aug 2025 15:26:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <cb9539bb95a2cbfc723a96d7ff31c1dd@jears.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY0Us65odiTMAQ--.53024S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKr4UuF1fCryUJw4rCr4kWFg_yoWxAr47pr
	48JrWUGry8Jrn3Jr18Jr18ZFy5Jr1xJw17Xr4xXF1UGr1UJr4jqryUXr1qgr1UJr48Jr4U
	XF1UXr15ur17Jr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/25 22:53, jeremias@jears.at 写道:
> This allows for setting a superblock version on the kernel command line 
> to be
> able to assemble version >=1.0 arrays. It can optionally be set like this:
> 
> md=vX.X,...
> 
> This will set the version of the array before assembly so it can be 
> assembled
> correctly.
> 

You should explain that current autodetect is only supported for 0.90
array.

> Also updated docs accordingly.
> 
> v2: Use pr_warn instead of printk
> 
> v3: Change order of options so it stays with past pattern
> 
> Signed-off-by: Jeremias Stotter <jeremias@jears.at>
> ---
>   Documentation/admin-guide/md.rst |  8 +++++
>   drivers/md/md-autodetect.c       | 59 ++++++++++++++++++++++++++++++--
>   2 files changed, 65 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/md.rst 
> b/Documentation/admin-guide/md.rst
> index 4ff2cc291d18..f57ae871c997 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -23,6 +23,14 @@ or, to assemble a partitionable array::
> 
>     md=d<md device no.>,dev0,dev1,...,devn
> 
> +if you are using superblock versions greater than 0, use the following::
> +
> +  md=<md device no.>,v<superblock version no.>,dev0,dev1,...,devn
> +
> +for example, for a raid array with superblock version 1.2 it could look 
> like this::
> +
> +  md=0,v1.2,/dev/sda1,/dev/sdb1
> +
>   ``md device no.``
>   +++++++++++++++++
> 

What about md_autostart_arrays()? where 0.90 is still the only default
choice.
> diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
> index 4b80165afd23..67d38559ad50 100644
> --- a/drivers/md/md-autodetect.c
> +++ b/drivers/md/md-autodetect.c
> @@ -32,6 +32,8 @@ static struct md_setup_args {
>       int partitioned;
>       int level;
>       int chunk;
> +    int major_version;
> +    int minor_version;
>       char *device_names;
>   } md_setup_args[256] __initdata;
> 
> @@ -63,6 +65,7 @@ static int __init md_setup(char *str)
>       char *pername = "";
>       char *str1;
>       int ent;
> +    int major_i = 0, minor_i = 0;
> 
>       if (*str == 'd') {
>           partitioned = 1;
> @@ -109,6 +112,49 @@ static int __init md_setup(char *str)
>       case 0:
>           md_setup_args[ent].level = LEVEL_NONE;
>           pername="super-block";
> +
> +        if (*str == 'v') { /* Superblock version */
> +            char *version = ++str;
> +            char *version_end = strchr(str, ',');
> +
> +            if (!version_end) {
> +                pr_warn("md: Version (%s) has been specified wrongly, 
> no ',' found, use like this: md=<md dev. no.>,X.X,...\n",
> +                    version);
> +                return 0;
> +            }
> +            *version_end = '\0';
> +            str = version_end + 1;
> +
> +            char *separator = strchr(version, '.');
> +
> +            if (!separator) {
> +                pr_warn("md: Version (%s) has been specified wrongly, 
> no '.' to separate major and minor version found, use like this: md=<md 
> dev. no.>,vX.X,...\n",
> +                    version);
> +                return 0;
> +            }
> +            *separator = '\0';
> +            char *minor_s = separator + 1;
> +
> +            int ret = kstrtoint(version, 10, &major_i);
> +
> +            if (ret != 0) {
> +                pr_warn("md: Version has been specified wrongly, 
> couldn't convert major '%s' to number, use like this: md=<md dev. 
> no.>,vX.X,...\n",
> +                    version);
> +                return 0;
> +            }
> +            if (major_i != 0 && major_i != 1) {
> +                pr_warn("md: Major version %d is not valid, use 0 or 1\n",
> +                    major_i);
> +                return 0;
> +            }
> +            ret = kstrtoint(minor_s, 10, &minor_i);
> +            if (ret != 0) {
> +                pr_warn("md: Version has been specified wrongly, 
> couldn't convert minor '%s' to number, use like this: md=<md dev. 
> no.>,vX.X,...\n",
> +                    minor_s);
> +                return 0;
> +            }
> +        }
> +
>       }
> 
>       printk(KERN_INFO "md: Will configure md%d (%s) from %s, below.\n",
> @@ -116,6 +162,8 @@ static int __init md_setup(char *str)
>       md_setup_args[ent].device_names = str;
>       md_setup_args[ent].partitioned = partitioned;
>       md_setup_args[ent].minor = minor;
> +    md_setup_args[ent].minor_version = minor_i;
> +    md_setup_args[ent].major_version = major_i;
> 
>       return 1;
>   }
> @@ -200,6 +248,9 @@ static void __init md_setup_drive(struct 
> md_setup_args *args)
> 
>       err = md_set_array_info(mddev, &ainfo);
> 
> +    mddev->major_version = args->major_version;
> +    mddev->minor_version = args->minor_version;

I would expect to fix md_set_array_info() to hanlde this new case, to
make code more readable.

> +
>       for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
>           struct mdu_disk_info_s dinfo = {
>               .major    = MAJOR(devices[i]),
> @@ -273,11 +324,15 @@ void __init md_run_setup(void)
>   {
>       int ent;
> 
> +    /*
> +     * Assemble manually defined raids first
> +     */
> +    for (ent = 0; ent < md_setup_ents; ent++)
> +        md_setup_drive(&md_setup_args[ent]);
> +

You just explain what you did in comment, Why do you change the order?

Thanks,
Kuai

>       if (raid_noautodetect)
>           printk(KERN_INFO "md: Skipping autodetection of RAID arrays. 
> (raid=autodetect will force)\n");
>       else
>           autodetect_raid();
> 
> -    for (ent = 0; ent < md_setup_ents; ent++)
> -        md_setup_drive(&md_setup_args[ent]);
>   }
> 
> .
> 


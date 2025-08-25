Received: from q64jeremias.jears.at (unknown [62.240.152.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AE31A9F89
	for <linux-raid@vger.kernel.org>; Mon, 25 Aug 2025 13:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.240.152.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756128905; cv=none; b=eJsfFHjN8RTw60sXRrt3c0WIp0XL0zlLDNB+sl55shLNerkaW+dcOr3aiQjhc94PcPTjOltZ+CE/TvfNV3Xstki953I6aMqvjHoRSGMtoVM/xUDxZX26Lp7hg/48aY5ErRXWcs3hSfT0nJ/RSuEzoWUYW++SLaBKPIfIroBRDdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756128905; c=relaxed/simple;
	bh=7iGlJ6nUh2QMZMcuUxsh89uuTMt/mic/tWEmOhUh+us=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=jJI44ZF2dnESiDe43l1T9BqOEvOLyrxfIMHwEkzvHvfAYhyw87O43a+g67We3xMEuKYfr62DifAvOXXUDzQbNPGGMUiunFUk1pL314JGwJMECG7QTGzAbNYuxsEAcVWbMZ9IiRfOkKN2E9INZOZyfpW2wxyopQnGX8T+QB6cNe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at; spf=pass smtp.mailfrom=jears.at; dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b=ECZKmDSX; arc=none smtp.client-ip=62.240.152.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jears.at
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jears.at
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=jears.at header.i=@jears.at header.b="ECZKmDSX"
Received: from mail.jears.at (localhost [127.0.0.1])
	by q64jeremias.jears.at (Postfix) with ESMTPA id 8DF80E5694;
	Mon, 25 Aug 2025 15:34:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jears.at; s=mail;
	t=1756128890; bh=Z8gzCNjZVencIudRVY33G4r4mURi5EpSvW/W+8OtqdQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ECZKmDSXrHr6ZUv+Ppc95PUcUicHth4mRpbNa2QhnFgPgTIHWV0K5iGF6eR4TPQYe
	 CGAt8WSYri7eeRLGKWXF59gqU3THm8+btW0nAmy9bdEQfKQZTE3X3KC7Y39kOHvpPE
	 C1j7zU4+A2mvDcCQYs1HuKDcQk1/onwVfX47NIPI=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 25 Aug 2025 15:34:48 +0200
From: jeremias@jears.at
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2] md: Allow setting persistent superblock version for
 md= command line
In-Reply-To: <41d00b1b-035b-4128-b83b-534c50c1907e@molgen.mpg.de>
References: <20250825113549.1461-1-jeremias@jears.at>
 <41d00b1b-035b-4128-b83b-534c50c1907e@molgen.mpg.de>
Message-ID: <57b75bb6c566b9495f50fc24f041da28@jears.at>
X-Sender: jeremias@jears.at
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit

On 2025-08-25 13:58, Paul Menzel wrote:
> Dear Jeremias,
> 
> 
> Thank you very much for your patch, and welcome to the Linux kernel 
> community!
> 
> Am 25.08.25 um 13:34 schrieb Jeremias Stotter:
>> This allows for setting a superblock version on the kernel command 
>> line to be
>> able to assemble version >=1.0 arrays. It can optionally be set like 
>> this:
> 
> Could you start by describing the problem. I am using several systems, 
> where arrays with version ≥ can be assembled. What am I missing?
> 
>> 
>> md=vX.X,...
>> 
>> This will set the version of the array before assembly so it can be 
>> assembled
>> correctly.
>> 
>> Also updated docs accordingly.
>> 
>> v2: Use pr_warn instead of printk
>> 
>> Signed-off-by: Jeremias Stotter <jeremias@jears.at>
>> ---
>>   Documentation/admin-guide/md.rst |  8 +++++
>>   drivers/md/md-autodetect.c       | 61 
>> ++++++++++++++++++++++++++++++--
>>   2 files changed, 67 insertions(+), 2 deletions(-)
>> 
>> diff --git a/Documentation/admin-guide/md.rst 
>> b/Documentation/admin-guide/md.rst
>> index 4ff2cc291d18..7b904d73ace0 100644
>> --- a/Documentation/admin-guide/md.rst
>> +++ b/Documentation/admin-guide/md.rst
>> @@ -23,6 +23,14 @@ or, to assemble a partitionable array::
>>       md=d<md device no.>,dev0,dev1,...,devn
>>   +if you are using superblock versions greater than 0, use the 
>> following::
>> +
>> +  md=v<superblock version no.>,<md device no.>,dev0,dev1,...,devn
>> +
>> +for example, for a raid array with superblock version 1.2 it could 
>> look like this::
>> +
>> +  md=v1.2,0,/dev/sda1,/dev/sdb1
>> +
> 
> Why not keep the pattern of the other options to specify <md device 
> no.> first?
> 
>>   ``md device no.``
>>   +++++++++++++++++
>>   diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
>> index 4b80165afd23..4c4775c33963 100644
>> --- a/drivers/md/md-autodetect.c
>> +++ b/drivers/md/md-autodetect.c
>> @@ -32,6 +32,8 @@ static struct md_setup_args {
>>   	int partitioned;
>>   	int level;
>>   	int chunk;
>> +	int major_version;
>> +	int minor_version;
>>   	char *device_names;
>>   } md_setup_args[256] __initdata;
>>   @@ -56,6 +58,9 @@ static int md_setup_ents __initdata;
>>    * 2001-06-03: Dave Cinege <dcinege@psychosis.com>
>>    *		Shifted name_to_kdev_t() and related operations to 
>> md_set_drive()
>>    *		for later execution. Rewrote section to make devfs compatible.
>> + * 2025-08-24: Jeremias Stotter <jeremias@jears.at>
>> + *              Allow setting of the superblock version:
>> + *              md=vX.X,...
> 
> I believe since git (and BitKeeper before) being used, these headers 
> are not updated any more.
> 
>>    */
>>   static int __init md_setup(char *str)
>>   {
>> @@ -63,6 +68,49 @@ static int __init md_setup(char *str)
>>   	char *pername = "";
>>   	char *str1;
>>   	int ent;
>> +	int major_i = 0, minor_i = 0;
>> +
>> +	if (*str == 'v') {
>> +		char *version = ++str;
>> +		char *version_end = strchr(str, ',');
>> +
>> +		if (!version_end) {
>> +			pr_warn("md: Version (%s) has been specified wrong, no ',' found, 
>> use like this: md=vX.X,...\n",
> 
> s/wrong/incorrectly/?
> 
> Or wrong*ly*. Same below.
> 
>> +				version);
>> +			return 0;
>> +		}
>> +		*version_end = '\0';
>> +		str = version_end + 1;
>> +
>> +		char *separator = strchr(version, '.');
>> +
>> +		if (!separator) {
>> +			pr_warn("md: Version (%s) has been specified wrong, no '.' to 
>> separate major and minor version found, use like this: md=vX.X,...\n",
>> +				version);
>> +			return 0;
>> +		}
>> +		*separator = '\0';
>> +		char *minor_s = separator + 1;
>> +
>> +		int ret = kstrtoint(version, 10, &major_i);
>> +
>> +		if (ret != 0) {
>> +			pr_warn("md: Version has been specified wrong, couldn't convert 
>> major '%s' to number, use like this: md=vX.X,...\n",
>> +				version);
>> +			return 0;
>> +		}
>> +		if (major_i != 0 && major_i != 1) {
>> +			pr_warn("md: Major version %d is not valid, use 0 or 1\n",
>> +				major_i);
>> +			return 0;
>> +		}
>> +		ret = kstrtoint(minor_s, 10, &minor_i);
>> +		if (ret != 0) {
>> +			pr_warn("md: Version has been specified wrong, couldn't convert 
>> minor '%s' to number, use like this: md=vX.X,...\n",
>> +				minor_s);
>> +			return 0;
>> +		}
>> +	}
>>     	if (*str == 'd') {
>>   		partitioned = 1;
>> @@ -116,6 +164,8 @@ static int __init md_setup(char *str)
>>   	md_setup_args[ent].device_names = str;
>>   	md_setup_args[ent].partitioned = partitioned;
>>   	md_setup_args[ent].minor = minor;
>> +	md_setup_args[ent].minor_version = minor_i;
>> +	md_setup_args[ent].major_version = major_i;
>>     	return 1;
>>   }
>> @@ -200,6 +250,9 @@ static void __init md_setup_drive(struct 
>> md_setup_args *args)
>>     	err = md_set_array_info(mddev, &ainfo);
>>   +	mddev->major_version = args->major_version;
>> +	mddev->minor_version = args->minor_version;
>> +
>>   	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
>>   		struct mdu_disk_info_s dinfo = {
>>   			.major	= MAJOR(devices[i]),
>> @@ -273,11 +326,15 @@ void __init md_run_setup(void)
>>   {
>>   	int ent;
>>   +	/*
>> +	 * Assemble manually defined raids first
>> +	 */
>> +	for (ent = 0; ent < md_setup_ents; ent++)
>> +		md_setup_drive(&md_setup_args[ent]);
>> +
>>   	if (raid_noautodetect)
>>   		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. 
>> (raid=autodetect will force)\n");
>>   	else
>>   		autodetect_raid();
>>   -	for (ent = 0; ent < md_setup_ents; ent++)
>> -		md_setup_drive(&md_setup_args[ent]);
>>   }
> 
> 
> Kind regards,
> 
> Paul
Hello Paul,

thanks for the feedback! This is my first patch, please excuse me for 
not being familiar with the kernel development process yet.
This is relevant, for example, when using an array with version 1.2 as 
root.
When assembling an array without an initrd that is version 1.2 for 
example, you get an invalid version 0.0 superblock error as the kernel 
tries to assemble the array with that version. There is no way right now 
to specify the superblock version from the kernel command line alone, so 
the array is just never assembled. Or am I missing something?

I will be sending you a patch taking into account your other concerns.

Kind regards,

Jeremias

Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290172C3745
	for <linux-raid@vger.kernel.org>; Mon, 25 Aug 2025 11:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756123116; cv=none; b=T23sbNnvGud7pm85y8dn7FJxMF59N5ODegijdaCVmfSda7sqVsQhF3KEKIru8UjBi1Ejde4Wn9bxoVysZFYzOZN/aLEPwG918qu2ap7nCLgyASa4vVJu4zwYPPn4mr21VqsUjJLihiJTY/qegNYiMioQkUZe6Ca6qDF0ji01LGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756123116; c=relaxed/simple;
	bh=OFHV+0viy7dIAuWXB19XyzozI1Kq0xFpiOVGOcdi58o=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=Ila00cLRx6wz8jUGYpEuWtrlFyQ1mbO9ijR2qEAN+D1ilO8IE5pt3qO184R8oofG8opmuoxoK0bujTVlzlair6y0L7OqtjyWvF3nfFAyLKMWH7CmKgFmNyTx+5LIkDLtKXdmCH7GdNzXrrl0rHI2aGHfrwkrEMavx/GLEQ2EHwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id EE8926028825F;
	Mon, 25 Aug 2025 13:58:26 +0200 (CEST)
Message-ID: <41d00b1b-035b-4128-b83b-534c50c1907e@molgen.mpg.de>
Date: Mon, 25 Aug 2025 13:58:26 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md: Allow setting persistent superblock version for
 md= command line
To: Jeremias Stotter <jeremias@jears.at>
References: <20250825113549.1461-1-jeremias@jears.at>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org
In-Reply-To: <20250825113549.1461-1-jeremias@jears.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Jeremias,


Thank you very much for your patch, and welcome to the Linux kernel 
community!

Am 25.08.25 um 13:34 schrieb Jeremias Stotter:
> This allows for setting a superblock version on the kernel command line to be
> able to assemble version >=1.0 arrays. It can optionally be set like this:

Could you start by describing the problem. I am using several systems, 
where arrays with version ≥ can be assembled. What am I missing?

> 
> md=vX.X,...
> 
> This will set the version of the array before assembly so it can be assembled
> correctly.
> 
> Also updated docs accordingly.
> 
> v2: Use pr_warn instead of printk
> 
> Signed-off-by: Jeremias Stotter <jeremias@jears.at>
> ---
>   Documentation/admin-guide/md.rst |  8 +++++
>   drivers/md/md-autodetect.c       | 61 ++++++++++++++++++++++++++++++--
>   2 files changed, 67 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/md.rst b/Documentation/admin-guide/md.rst
> index 4ff2cc291d18..7b904d73ace0 100644
> --- a/Documentation/admin-guide/md.rst
> +++ b/Documentation/admin-guide/md.rst
> @@ -23,6 +23,14 @@ or, to assemble a partitionable array::
>   
>     md=d<md device no.>,dev0,dev1,...,devn
>   
> +if you are using superblock versions greater than 0, use the following::
> +
> +  md=v<superblock version no.>,<md device no.>,dev0,dev1,...,devn
> +
> +for example, for a raid array with superblock version 1.2 it could look like this::
> +
> +  md=v1.2,0,/dev/sda1,/dev/sdb1
> +

Why not keep the pattern of the other options to specify <md device no.> 
first?

>   ``md device no.``
>   +++++++++++++++++
>   
> diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
> index 4b80165afd23..4c4775c33963 100644
> --- a/drivers/md/md-autodetect.c
> +++ b/drivers/md/md-autodetect.c
> @@ -32,6 +32,8 @@ static struct md_setup_args {
>   	int partitioned;
>   	int level;
>   	int chunk;
> +	int major_version;
> +	int minor_version;
>   	char *device_names;
>   } md_setup_args[256] __initdata;
>   
> @@ -56,6 +58,9 @@ static int md_setup_ents __initdata;
>    * 2001-06-03: Dave Cinege <dcinege@psychosis.com>
>    *		Shifted name_to_kdev_t() and related operations to md_set_drive()
>    *		for later execution. Rewrote section to make devfs compatible.
> + * 2025-08-24: Jeremias Stotter <jeremias@jears.at>
> + *              Allow setting of the superblock version:
> + *              md=vX.X,...

I believe since git (and BitKeeper before) being used, these headers are 
not updated any more.

>    */
>   static int __init md_setup(char *str)
>   {
> @@ -63,6 +68,49 @@ static int __init md_setup(char *str)
>   	char *pername = "";
>   	char *str1;
>   	int ent;
> +	int major_i = 0, minor_i = 0;
> +
> +	if (*str == 'v') {
> +		char *version = ++str;
> +		char *version_end = strchr(str, ',');
> +
> +		if (!version_end) {
> +			pr_warn("md: Version (%s) has been specified wrong, no ',' found, use like this: md=vX.X,...\n",

s/wrong/incorrectly/?

Or wrong*ly*. Same below.

> +				version);
> +			return 0;
> +		}
> +		*version_end = '\0';
> +		str = version_end + 1;
> +
> +		char *separator = strchr(version, '.');
> +
> +		if (!separator) {
> +			pr_warn("md: Version (%s) has been specified wrong, no '.' to separate major and minor version found, use like this: md=vX.X,...\n",
> +				version);
> +			return 0;
> +		}
> +		*separator = '\0';
> +		char *minor_s = separator + 1;
> +
> +		int ret = kstrtoint(version, 10, &major_i);
> +
> +		if (ret != 0) {
> +			pr_warn("md: Version has been specified wrong, couldn't convert major '%s' to number, use like this: md=vX.X,...\n",
> +				version);
> +			return 0;
> +		}
> +		if (major_i != 0 && major_i != 1) {
> +			pr_warn("md: Major version %d is not valid, use 0 or 1\n",
> +				major_i);
> +			return 0;
> +		}
> +		ret = kstrtoint(minor_s, 10, &minor_i);
> +		if (ret != 0) {
> +			pr_warn("md: Version has been specified wrong, couldn't convert minor '%s' to number, use like this: md=vX.X,...\n",
> +				minor_s);
> +			return 0;
> +		}
> +	}
>   
>   	if (*str == 'd') {
>   		partitioned = 1;
> @@ -116,6 +164,8 @@ static int __init md_setup(char *str)
>   	md_setup_args[ent].device_names = str;
>   	md_setup_args[ent].partitioned = partitioned;
>   	md_setup_args[ent].minor = minor;
> +	md_setup_args[ent].minor_version = minor_i;
> +	md_setup_args[ent].major_version = major_i;
>   
>   	return 1;
>   }
> @@ -200,6 +250,9 @@ static void __init md_setup_drive(struct md_setup_args *args)
>   
>   	err = md_set_array_info(mddev, &ainfo);
>   
> +	mddev->major_version = args->major_version;
> +	mddev->minor_version = args->minor_version;
> +
>   	for (i = 0; i <= MD_SB_DISKS && devices[i]; i++) {
>   		struct mdu_disk_info_s dinfo = {
>   			.major	= MAJOR(devices[i]),
> @@ -273,11 +326,15 @@ void __init md_run_setup(void)
>   {
>   	int ent;
>   
> +	/*
> +	 * Assemble manually defined raids first
> +	 */
> +	for (ent = 0; ent < md_setup_ents; ent++)
> +		md_setup_drive(&md_setup_args[ent]);
> +
>   	if (raid_noautodetect)
>   		printk(KERN_INFO "md: Skipping autodetection of RAID arrays. (raid=autodetect will force)\n");
>   	else
>   		autodetect_raid();
>   
> -	for (ent = 0; ent < md_setup_ents; ent++)
> -		md_setup_drive(&md_setup_args[ent]);
>   }


Kind regards,

Paul

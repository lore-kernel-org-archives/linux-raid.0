Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C8EC433FE
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 661E760524
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 16:52:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhKBQyp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:54:45 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17274 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235426AbhKBQyK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 12:54:10 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635871890; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=jTiR2v0vZF+DNE87KsBZLIgWinl1Ic0QCeA33E8s4HZzptdfQn5fW2y03Hmfgm1hErzsVn7j8sYNognpJbij9aVhg9FFRyI7IxgIuFfyQN84IPVsH3Cg4BcjYkW6tV2RteP1zbNQXnWzRNOk/SL3ltUkHeTqTOOIminq3xNdghc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635871890; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=6b3Pve2rS1q1E5sx+S7kaVdnM3nQlZwhQ6wNJ9/tEcg=; 
        b=Jk7FAcup3xriGq/NPfje2Cfq/75Hh0WT0KU+kookhOe6jKhwpQdsEoi6m4tRGI9Oyi9G+UtMEKognuyocx4sVM7nJQI4EXL63MpoJexBy2RFPGZcrR/Ig4AY9u86D1teoDQHX5dafzNr+gFFrSCStyYUeSaKE2qpK2msIHmiDIU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635871888153878.6686351856453; Tue, 2 Nov 2021 17:51:28 +0100 (CET)
Subject: Re: [PATCH] mdopen: use safe functions in create_mddev
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <c8239095-aec5-142f-77e8-d0e71e8caf3b@trained-monkey.org>
Date:   Tue, 2 Nov 2021 12:51:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/21/21 3:52 AM, Mariusz Tkaczyk wrote:
> To avoid buffer overflows, add sizes and use safe functions.
> Buffers are now limited to NAME_MAX. Potentially, it may
> cause regression in non-standard usecases.
> Adapt description to kernel-doc standard.
> Add verification for name and dev to ensure that at least one of them
> is set.
> Remove redundant chosen update after verification. It is set already.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Assemble.c    |   2 +-
>  Build.c       |   2 +-
>  Create.c      |   3 +-
>  Incremental.c |  10 ++--
>  mdadm.h       |   5 +-
>  mdopen.c      | 132 ++++++++++++++++++++++++++++++++------------------
>  6 files changed, 96 insertions(+), 58 deletions(-)

I've been wanting to get back to this one for a while. Sorry it's taken
so long.

The switch to using NAME_MAX has some side effects I am a little
concerned about, however the code is also really tricky to get your head
around (not your fault).

> @@ -160,10 +170,13 @@ int create_named_array(char *devnm)
>   * /dev/mdXX in 'chosen'.
>   *
>   * When we create devices, we use uid/gid/umask from config file.
> + *
> + * Return: O_EXCL file descriptor or negative integer.
> + *
> + * Null terminated name for the volume is returned via *chosen.
>   */
> -
> -int create_mddev(char *dev, char *name, int autof, int trustworthy,
> -		 char *chosen, int block_udev)
> +int create_mddev(const char *dev, const char *name, int autof, int trustworthy,
> +		 char *chosen, const size_t chosen_size, int block_udev)
>  {
>  	int mdfd;
>  	struct stat stb;
> @@ -171,16 +184,24 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>  	int use_mdp = -1;
>  	struct createinfo *ci = conf_get_create_info();
>  	int parts;
> +	const size_t cname_size = NAME_MAX;
>  	char *cname;
> -	char devname[37];
> -	char devnm[32];
> -	char cbuf[400];
> +	char devname[NAME_MAX + 5];
> +	char devnm[NAME_MAX] = "\0";
> +	static const char dev_md_path[] = "/dev/md/";

This is quite a lot of additional stack space used going from 32+37 to
512, however reducing the arbitrary 400 bytes size of cbuf is a good thing.

> @@ -188,35 +209,48 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>  	parts = autof >> 3;
>  	autof &= 7;
>  
> -	strcpy(chosen, "/dev/md/");
> -	cname = chosen + strlen(chosen);
> +	if (chosen_size <= strlen(dev_md_path) + cname_size) {
> +		dprintf("Chosen buffer is to small.\n");
> +		return -1;
> +	}

cname_size = NAME_MAX = 255

Ie. if something calls create_mddev() with a chosen_size smaller than
263, this check will fail, which seems rather arbitrary. It does look
like we always use a chosen_name[1024] which is silly wasteful, but
there much be a better solution to this. Maybe malloc() and return the
buffer instead of relying on those large stack frames?

> +	strncpy(chosen, dev_md_path, chosen_size);
> +	cname = chosen + strlen(dev_md_path);
>  
>  	if (dev) {
> -		if (strncmp(dev, "/dev/md/", 8) == 0) {
> -			strcpy(cname, dev+8);
> -		} else if (strncmp(dev, "/dev/", 5) == 0) {
> -			char *e = dev + strlen(dev);
> +		if (strncmp(dev, dev_md_path, 8) == 0)
> +			strncpy(cname, dev+8, cname_size);

sizeof(dev_md_path) instead of the hardcoded 8?

> +		else if (strncmp(dev, dev_md_path, 5) == 0) {
> +			const char *e = dev + 5 + strnlen(dev + 5, NAME_MAX);
> +>  			while (e > dev && isdigit(e[-1]))
>  				e--;>  			if (e[0])
>  				num = strtoul(e, NULL, 10);
> -			strcpy(cname, dev+5);
> +			strncpy(cname, dev + 5, cname_size);
>  			cname[e-(dev+5)] = 0;
> +
>  			/* name *must* be mdXX or md_dXX in this context */
>  			if (num < 0 ||
> -			    (strcmp(cname, "md") != 0 && strcmp(cname, "md_d") != 0)) {
> +			    (strncmp(cname, "md", 2) != 0 &&
> +			     strncmp(cname, "md_d", 4) != 0)) {
>  				pr_err("%s is an invalid name for an md device.  Try /dev/md/%s\n",
>  					dev, dev+5);
>  				return -1;
>  			}
> -			if (strcmp(cname, "md") == 0)
> +			if (strncmp(cname, "md", 2) == 0)
>  				use_mdp = 0;
>  			else
>  				use_mdp = 1;
>  			/* recreate name: /dev/md/0 or /dev/md/d0 */
> -			sprintf(cname, "%s%d", use_mdp?"d":"", num);
> +			snprintf(cname, cname_size, "%s%d",
> +				 use_mdp ? "d" : "", num);
>  		} else
> -			strcpy(cname, dev);
> +			strncpy(cname, dev, cname_size);
> +		/*
> +		 * Force null termination for long names.
> +		 */
> +		cname[cname_size - 1] = '\0';
>  
>  		/* 'cname' must not contain a slash, and may not be
>  		 * empty.

My head started spinning by the time I got to here.

The more I think about it, the more I think we should allocate an
appropriate buffer in here and return that, rather than play all those
bounds checking games.

Thoughts?

Jes

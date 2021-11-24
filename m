Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0B4FC4332F
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 12:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242198AbhKXMTT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:19:19 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17229 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241808AbhKXMRA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 07:17:00 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637756027; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Ez9uV+SLJyI+kpmw2z981Wfr2P+dGNyL9XFFqadqhM0HOqFxevuUFYCwTJL6cXh3QmuaKyaG8tJBFVdJLDnrhbscewfGJnN82ATHsimnbBNF3QH0B0sEEgf8705f/LNjvqoh0MMuhCr9VSavDfAzxkf1OsSNpRYeTOhKY3kK0ww=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637756027; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=m83kgdzap49ZeVLF3KXE45Q42z1kM1ieHlcX9MMwrDM=; 
        b=WbOGSDSvignqHFR5x/V/UPSHqLWwMcvTeZFIwyEiGvMBVnbHJ9mL0AMvPxXyWm2IgLXlLhe1454U6Agy1EDd0kJc0/3QELwi5qLiPq/lSESf9eWyzMvo0UshLFKnTaR4BMtfVjmJ3CFPYfhwFHX3il2HtGrq9tnxayhINsRrseM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1637756024854262.91289151494925; Wed, 24 Nov 2021 13:13:44 +0100 (CET)
Subject: Re: [PATCH v2] Incremental: Fix possible memory and resource leaks
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20211124115819.7568-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <16c18e54-fb84-7b97-1aa7-f31979b87a9e@trained-monkey.org>
Date:   Wed, 24 Nov 2021 07:13:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211124115819.7568-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/21 6:58 AM, Mateusz Grzonka wrote:
> map allocated through map_by_uuid() is not freed if mdfd is invalid.
> In addition mdfd is not closed, and mdinfo list is not freed too.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Incremental.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)

I already applied the previous version. Could you please send an updated
version on top of current tree.

Thanks,
Jes


> diff --git a/Incremental.c b/Incremental.c
> index cd9cc0fc..01554efc 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1498,7 +1498,7 @@ static int Incremental_container(struct supertype *st, char *devname,
>  		return 0;
>  	}
>  	for (ra = list ; ra ; ra = ra->next) {
> -		int mdfd;
> +		int mdfd = -1;
>  		char chosen_name[1024];
>  		struct map_ent *mp;
>  		struct mddev_ident *match = NULL;
> @@ -1513,6 +1513,12 @@ static int Incremental_container(struct supertype *st, char *devname,
>  
>  		if (mp) {
>  			mdfd = open_dev(mp->devnm);
> +			if (!is_fd_valid(mdfd)) {
> +				pr_err("failed to open %s: %s.\n",
> +				       mp->devnm, strerror(errno));
> +				rv = 2;
> +				goto release;
> +			}
>  			if (mp->path)
>  				strcpy(chosen_name, mp->path);
>  			else
> @@ -1572,21 +1578,25 @@ static int Incremental_container(struct supertype *st, char *devname,
>  					    c->autof,
>  					    trustworthy,
>  					    chosen_name, 0);
> +
> +			if (!is_fd_valid(mdfd)) {
> +				pr_err("create_mddev failed with chosen name %s: %s.\n",
> +				       chosen_name, strerror(errno));
> +				rv = 2;
> +				goto release;
> +			}
>  		}
> -		if (only && (!mp || strcmp(mp->devnm, only) != 0))
> -			continue;
>  
> -		if (mdfd < 0) {
> -			pr_err("failed to open %s: %s.\n",
> -				chosen_name, strerror(errno));
> -			return 2;
> +		if (only && (!mp || strcmp(mp->devnm, only) != 0)) {
> +			close_fd(&mdfd);
> +			continue;
>  		}
>  
>  		assemble_container_content(st, mdfd, ra, c,
>  					   chosen_name, &result);
>  		map_free(map);
>  		map = NULL;
> -		close(mdfd);
> +		close_fd(&mdfd);
>  	}
>  	if (c->export && result) {
>  		char sep = '=';
> @@ -1609,7 +1619,11 @@ static int Incremental_container(struct supertype *st, char *devname,
>  		}
>  		printf("\n");
>  	}
> -	return 0;
> +
> +release:
> +	map_free(map);
> +	sysfs_free(list);
> +	return rv;
>  }
>  
>  static void run_udisks(char *arg1, char *arg2)
> 


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BCBCC433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:30:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6C17660FF2
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:30:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhJHKcO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:32:14 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17279 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbhJHKcN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 06:32:13 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633689010; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=eJCfEPfZ61G89iMJevWIwMvFBMWHhHeJkO7Zy0gIwhibCDilUyRjY7nLPjqXx95QL9OQ5/Mh4XVb7Wdq0MiLSW6v0dh2Y1NeVI9I6lOoPY5hcCt6O+YUfp5UBp8E18CSOvavyNL7k8oGnflhSjXHxNxk8mlXhmYl/lnhC4Xweeg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633689010; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8czNxJNxgihxv37CmPt9YvyKcb0HiDpralCm/NifoF0=; 
        b=iyaDuuuOxBbjY/KQ5BlQQsSlKrX1j8NT2bSOPoR+mR0hVM/JVU+zobqlAuWUN+JsDXhUQQm4/mIK5FVB69stlYns83G2hNj4yYIBpWQCJolQ3Mdf9aPp14h83jNqhyiQ6oqBb904/nTN3YDNmKCFX7WzXmSYGyEgqp09TTdiN+Y=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 163368893431184.98705208025876; Fri, 8 Oct 2021 12:28:54 +0200 (CEST)
Subject: Re: [PATCH] Incremental: Fix possible memory and resource leaks
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210826094040.30118-1-mateusz.grzonka@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <b1b89215-d15f-c22f-b4e8-52576a454007@trained-monkey.org>
Date:   Fri, 8 Oct 2021 06:28:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210826094040.30118-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/26/21 5:40 AM, Mateusz Grzonka wrote:
> map allocated through map_by_uuid() is not freed if mdfd is invalid.
> It is also not freed at the end of Incremental_container().
> In addition mdfd is not closed, and mdinfo list is not
> freed too.
> Fix it.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Hi Mateusz,

Sorry for the late feedback.

Looking through this change, I would prefer to have had this done in
multiple patches that are easier to review individually. Like the first
close is obviously correct and the last change too, but they are
independent of the middle changes.

I also feel the second set of changes relying on doclose could be less
convoluted if we just check the return value from open_dev() and
create_mddev() immediately instead of trying to handle it in a catch all
case. This would help make the code easier to read.

Please see comments below.

Thoughts?

Thanks,
Jes


>  Incremental.c | 27 +++++++++++++++++++++------
>  1 file changed, 21 insertions(+), 6 deletions(-)
> 
> diff --git a/Incremental.c b/Incremental.c
> index cd9cc0fc..6678739b 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1416,6 +1416,7 @@ restart:
>  			}
>  			sysfs_free(sra);
>  		}
> +		close(mdfd);
>  	}
>  	map_free(mapl);
>  	return rv;
> @@ -1499,6 +1500,7 @@ static int Incremental_container(struct supertype *st, char *devname,
>  	}
>  	for (ra = list ; ra ; ra = ra->next) {
>  		int mdfd;
> +		int doclose = 0;
>  		char chosen_name[1024];
>  		struct map_ent *mp;
>  		struct mddev_ident *match = NULL;
> @@ -1513,6 +1515,7 @@ static int Incremental_container(struct supertype *st, char *devname,
>  
>  		if (mp) {
>  			mdfd = open_dev(mp->devnm);
> +			doclose = 1;

Check mdfd >= 0 here and jump to release.

>  			if (mp->path)
>  				strcpy(chosen_name, mp->path);
>  			else
> @@ -1572,22 +1575,30 @@ static int Incremental_container(struct supertype *st, char *devname,
>  					    c->autof,
>  					    trustworthy,
>  					    chosen_name, 0);
> +			doclose = 1;

Check mdfd >= 0 here and jump to release.

>  		}
> -		if (only && (!mp || strcmp(mp->devnm, only) != 0))
> -			continue;
>  
>  		if (mdfd < 0) {
>  			pr_err("failed to open %s: %s.\n",
>  				chosen_name, strerror(errno));
> -			return 2;
> +			rv = 2;
> +			goto release;
> +		}

We can then get rid of this block completely.

> +		if (only && (!mp || strcmp(mp->devnm, only) != 0)) {
> +			if (doclose)
> +				close(mdfd);
> +			continue;

And call close() here unconditionally.

>  		}
>  
>  		assemble_container_content(st, mdfd, ra, c,
>  					   chosen_name, &result);
>  		map_free(map);
>  		map = NULL;
> -		close(mdfd);
> +		if (doclose)
> +			close(mdfd);
>  	}

and get rid of the if() here
> +
>  	if (c->export && result) {
>  		char sep = '=';
>  		printf("MD_STARTED");
> @@ -1609,7 +1620,11 @@ static int Incremental_container(struct supertype *st, char *devname,
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
> @@ -1701,7 +1716,7 @@ int IncrementalRemove(char *devname, char *id_path, int verbose)
>  		return 1;
>  	}
>  	mdfd = open_dev_excl(ent->devnm);
> -	if (mdfd > 0) {
> +	if (mdfd >= 0) {

This part is also independent and fine by itself.

>  		close(mdfd);
>  		if (sysfs_get_str(&mdi, NULL, "array_state",
>  				  buf, sizeof(buf)) > 0) {
> 


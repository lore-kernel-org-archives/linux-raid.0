Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A150DC77B61
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjDJPz5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDJPz4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:55:56 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE3583
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:55:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681142129; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cbTHo4r29taPP4M86Wmta1XxXN8l0kWyxSGtP9QJ/zYyaTn2+b88tEnuAz2SWjxu9XnO4bFNshPQL/hGQs2FM+pnTtMhGImecrxYp7tbD6PL5w+yeUfL6J+jVU6X9lvMcACx4x+d4s0YdGdtsmxIb0L11V0KqbgRRj9oGv9ilp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681142129; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9HS9UIYKN2LzbZBIxE8Vnbzv1DFMXlN1X3rMi7VloI4=; 
        b=Hwcgusc380Goor0jEsgw/GbdPp8dosdFGk21PuVrT++eulEv87h4X+kxbJ+oyRIeSRJU7IhYA/jrZ1/iz0e2NHY5NaIG+70okTFmRAmNz5lEBCngLt/f0ZRy9NXj0992Kxz02bR9X9jgLsiVaPIPSVNJExQwPO3K3S2l4GwXiP8=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681142128920354.12274879224765; Mon, 10 Apr 2023 17:55:28 +0200 (CEST)
Message-ID: <857e5b3b-c548-fb42-c7e9-6f2c26d0b1d7@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:55:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 3/4] Fix memory leak in file Manage
Content-Language: en-US
To:     Guanqin Miao <miaoguanqin@huawei.com>,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        louhongxiang@huawei.com
References: <20230406114011.3297545-1-miaoguanqin@huawei.com>
 <20230406114011.3297545-4-miaoguanqin@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230406114011.3297545-4-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/6/23 07:40, Guanqin Miao wrote:
> When we test mdadm with asan, we found some memory leaks in Manage.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---
>  Manage.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/Manage.c b/Manage.c
> index fde6aba3..82bcb255 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -222,6 +222,8 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
>  		if (verbose >= 0)
>  			pr_err("Cannot get exclusive access to %s:Perhaps a running process, mounted filesystem or active volume group?\n",
>  			       devname);
> +		if (mdi)
> +			sysfs_free(mdi);
>  		return 1;
>  	}
>  	/* If this is an mdmon managed array, just write 'inactive'
> @@ -818,8 +820,15 @@ int Manage_add(int fd, int tfd, struct mddev_dev *dv,
>  						    rdev, update, devname,
>  						    verbose, array);
>  				dev_st->ss->free_super(dev_st);
> -				if (rv)
> +				if (rv) {
> +					free(dev_st);
>  					return rv;
> +				}
> +			}
> +			if (dev_st) {
> +				if (dev_st->sb)
> +					dev_st->ss->free_super(dev_st);
> +				free(dev_st);
>  			}
>  		}
>  		if (dv->disposition == 'M') {
> @@ -1716,6 +1725,8 @@ int Manage_subdevs(char *devname, int fd,
>  			break;
>  		}
>  	}
> +	if (tst)
> +		free(tst);

free(NULL) is valid

>  	if (frozen > 0)
>  		sysfs_set_str(&info, NULL, "sync_action","idle");
>  	if (test && count == 0)
> @@ -1723,6 +1734,8 @@ int Manage_subdevs(char *devname, int fd,
>  	return 0;
>  
>  abort:
> +	if (tst)
> +		free(tst);

Same here

>  	if (frozen > 0)
>  		sysfs_set_str(&info, NULL, "sync_action","idle");
>  	return !test && busy ? 2 : 1;


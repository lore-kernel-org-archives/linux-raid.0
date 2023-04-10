Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9646AC76196
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjDJPzE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjDJPzD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:55:03 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EDBD171C
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:55:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681142069; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=D+rX8oLyYrnz6u4WCNfyvfMQiHrw9RS5D5Fvch2D84rALJ68Xcp17dQbNMW21qB8ENmXV6I8G+Jgv6pFY6mAqEpQ69mE3QYaBujKANIYiMFpybspgHYVFQVJWQyx+iJPYxh3XVs9i+FfjXlda0XJCtZbg7Bz0XrWf4VbqVdirB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681142069; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=trWVKkADpKEbJPlmOWuKx3HHyXA4L03UlG7akKGT/r8=; 
        b=CkOPF4Vl3CMkKHI3D539E7/oGg3/RfXNsqBKUXW3chAk8zx1FMr9p+WBmQ0Y8YLiUOOyp6IDtfNtsu7gY5Top0jmvUibVERPJ0TS1UGIlsfSTLUiYxoPYanh2RXJqYMpwfeGFmAD7z7OAd0ArpgripsWhRcpIs6F9lqz4e9uQ5o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681142068058414.94606975644854; Mon, 10 Apr 2023 17:54:28 +0200 (CEST)
Message-ID: <11cb6526-1848-bffb-f847-d856e7742777@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:54:26 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/4] Fix memory leak in file Assemble
Content-Language: en-US
To:     Guanqin Miao <miaoguanqin@huawei.com>,
        mariusz.tkaczyk@linux.intel.com, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
Cc:     linfeilong@huawei.com, lixiaokeng@huawei.com,
        louhongxiang@huawei.com
References: <20230406114011.3297545-1-miaoguanqin@huawei.com>
 <20230406114011.3297545-2-miaoguanqin@huawei.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230406114011.3297545-2-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/6/23 07:40, Guanqin Miao wrote:
> When we test mdadm with asan, we found some memory leaks in Assemble.c
> We fix these memory leaks based on code logic.
> 
> Signed-off-by: Guanqin Miao <miaoguanqin@huawei.com>
> Signed-off-by: Li Xiao Keng <lixiaokeng@huawei.com>
> ---
>  Assemble.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 49804941..574865eb 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -341,8 +341,10 @@ static int select_devices(struct mddev_dev *devlist,
>  				st->ss->free_super(st);
>  			dev_policy_free(pol);
>  			domain_free(domains);
> -			if (tst)
> +			if (tst) {
>  				tst->ss->free_super(tst);
> +				free(tst);
> +			}
>  			return -1;
>  		}
>  
> @@ -417,6 +419,7 @@ static int select_devices(struct mddev_dev *devlist,
>  				st->ss->free_super(st);
>  				dev_policy_free(pol);
>  				domain_free(domains);
> +				free(st);
>  				return -1;
>  			}
>  			if (c->verbose > 0)
> @@ -425,6 +428,8 @@ static int select_devices(struct mddev_dev *devlist,
>  
>  			/* make sure we finished the loop */
>  			tmpdev = NULL;
> +			if (st)
> +				free(st);

free(NULL) is valid

>  			goto loop;
>  		} else {
>  			content = *contentp;
> @@ -533,6 +538,7 @@ static int select_devices(struct mddev_dev *devlist,
>  				st->ss->free_super(st);
>  				dev_policy_free(pol);
>  				domain_free(domains);
> +				free(tst);
>  				return -1;
>  			}
>  			tmpdev->used = 1;
> @@ -546,8 +552,10 @@ static int select_devices(struct mddev_dev *devlist,
>  		}
>  		dev_policy_free(pol);
>  		pol = NULL;
> -		if (tst)
> +		if (tst) {
>  			tst->ss->free_super(tst);
> +			free(tst);
> +		}
>  	}
>  
>  	/* Check if we found some imsm spares but no members */
> @@ -839,6 +847,7 @@ static int load_devices(struct devs *devices, char *devmap,
>  				close(mdfd);
>  				free(devices);
>  				free(devmap);
> +				free(best);
>  				*stp = st;
>  				return -1;
>  			}
> @@ -1950,6 +1959,8 @@ out:
>  	} else if (mdfd >= 0)
>  		close(mdfd);
>  
> +	if (best)
> +		free(best);

Same here

>  	/* '2' means 'OK, but not started yet' */
>  	if (rv == -1) {
>  		free(devices);


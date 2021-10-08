Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E25E8C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 16:05:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C036A6101E
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 16:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhJHQHZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 12:07:25 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17213 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhJHQHY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 12:07:24 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633709127; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=J8jJAAl7NPaXInLDKt4EFEmxebxg2Ayqd5eVkJTOZD1nlIKbAIJi3o018XbuFdoUl6WnHFQsGshHfFHoxJZIU9+twPfqq3zaSVW4VLLTf2k5fDjEzSXzV7IAM/pRb5DYm7LfYQiGsgiJPAVab3xDpGiEYXVfuGU+QtCH5H3SN+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633709127; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nnq74MwNiYY5vsSWBA+YlZOkeICWTbFDAwmjnrVTW2w=; 
        b=h8za5gUNZBgMRlU9YhB1aOmBCrtcGDhSy70s8KSHX5l06aFOasmDc8mxRM4PKWcjgy7OCdYQBulX8mmIcLyzhacIG3CCORx3Mr5fHH9WOP1ufCFGK8oL+L05nFE+5hyYcMgv44QyzKfzca9Z3YlmxytWA6YjCYjdOOGaPxiznUA=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633709125689351.0454373800611; Fri, 8 Oct 2021 18:05:25 +0200 (CEST)
Subject: Re: [PATCH] imsm: Remove possibility for get_imsm_dev to return NULL
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210920111032.19195-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <be5f8bd5-9434-a403-a982-fd41cf1fe9a2@trained-monkey.org>
Date:   Fri, 8 Oct 2021 12:05:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210920111032.19195-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/20/21 7:10 AM, Mateusz Grzonka wrote:
> Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
> Guarantee that it never happens.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  super-intel.c | 122 +++++++++++++++++++-------------------------------
>  1 file changed, 46 insertions(+), 76 deletions(-)
> 
> diff --git a/super-intel.c b/super-intel.c
> index 83ddc000..2c3df58a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -858,30 +858,29 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 index)
>  	void *_mpb = mpb;
>  
>  	if (index >= mpb->num_raid_devs)
> -		return NULL;
> +		goto error;
>  
>  	/* devices start after all disks */
>  	offset = ((void *) &mpb->disk[mpb->num_disks]) - _mpb;
>  
> -	for (i = 0; i <= index; i++)
> +	for (i = 0; i <= index; i++, offset += sizeof_imsm_dev(_mpb + offset, 0))
>  		if (i == index)
>  			return _mpb + offset;
> -		else
> -			offset += sizeof_imsm_dev(_mpb + offset, 0);
> -
> -	return NULL;
> +error:
> +	pr_err("matching failed, index: %u\n", index);
> +	abort();
>  }

Can we please fix the error handling properly instead of throwing in
abort() and assert() to avoid it. That's really sloppy in my book.

Thanks,
Jes

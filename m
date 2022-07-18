Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA87FCCA481
	for <linux-raid@archiver.kernel.org>; Mon, 18 Jul 2022 20:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbiGRUCQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbiGRUCA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 18 Jul 2022 16:02:00 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C121277A;
        Mon, 18 Jul 2022 13:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=dqqiOAkwZKWLAfBPNmYQ8C8Kab6PgQLcjAUhRl9OfyU=; b=ZIUzaKHf2wtjg5ISLb5EK/2tsu
        5SOx5QHIwPMWtLf3DHuoDQJij3Roz4Fs/ql8ZclAqnXLsY/ybUMrH073mgnkX6funOfXybHpd7eiw
        JYX8J0c774rCw3uOWdmZ/9LutTLSla90NYfnFsbcfQhU7AbmyoMsOLAVFGHaUmU1OETel1MYncYV+
        6zKuDjYmeIIJlmd6fVz+HK2XPuMiCtgrlJ0HQKzEoHxUPB3bzUF62nK0ipRDtJGLe3b6TkrfRQz6Q
        RLVssvoQO4KZCRsVzIXR9Ei13u4A/e7t06zekaUaiU5XWqLozmtX7QmjJUDriRHjpaBs4mU8OofTY
        VFEulN5w==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1oDWwF-000iH2-Rt; Mon, 18 Jul 2022 14:01:56 -0600
Message-ID: <58e54a6c-40c8-e936-dc4b-7218b7d0ddd0@deltatee.com>
Date:   Mon, 18 Jul 2022 14:01:55 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-CA
To:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>
Cc:     linux-raid@vger.kernel.org, linux-block@vger.kernel.org
References: <20220718063410.338626-1-hch@lst.de>
 <20220718063410.338626-4-hch@lst.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <20220718063410.338626-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: hch@lst.de, song@kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH 03/10] md: implement ->free_disk
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-07-18 00:34, Christoph Hellwig wrote:
> Ensure that all private data is only freed once all accesses are done.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/md.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 64c7c24d267bc..1e658d5060842 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5602,11 +5602,6 @@ static void md_free(struct kobject *ko)
>  		del_gendisk(mddev->gendisk);
>  		blk_cleanup_disk(mddev->gendisk);
>  	}

Looks like, with the previous patch, we can now remove the conditional
on gendisk. Other than that it looks good:

Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Logan

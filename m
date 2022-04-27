Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C542AC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 27 Apr 2022 16:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242342AbiD0QQq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Apr 2022 12:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241771AbiD0QNP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 27 Apr 2022 12:13:15 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483D448387C;
        Wed, 27 Apr 2022 09:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=hQoXPJPquqTb2kGaaKxCiuhimB4ekAN7xqBn0QNyaIQ=; b=UVxvYoMfT1vstULD4aRMpZehu9
        RUBZ7/wz2W723JIdfjGXwMMJAI9xgxn7ytl+ozmyWnrvUO6BfKQOT0N6FrUqfmHBROUoWp0VjK3ws
        aB5ztde2c7VPF4WvEp/UhnVdawFz9KyJ0u54Z0YjnlQOObmCN293Ez7rYgfLvqC5EIr4QcOpIc48p
        CqA3tFX6S0dg0+AlpjB90XZvdB/UrvEN/FRQBp97GfOoG2kkzTI/ZBjWeDjbDMOU00Mwkaz/UATmh
        jAdwCqoRiE/6gpFdRRvlqi+2LLpcmu6kuP/+UgzddB3Yl9U2+4j3cKi0wEvIpxkUtJYopy03PJXsU
        CdQHwv0A==;
Received: from s0106ac1f6bb1ecac.cg.shawcable.net ([70.73.163.230] helo=[192.168.11.155])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1njkCl-000K8X-FT; Wed, 27 Apr 2022 10:07:52 -0600
Message-ID: <fe7f6d8a-8c66-3e90-1c52-140fe9d4cf1a@deltatee.com>
Date:   Wed, 27 Apr 2022 10:07:48 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-2-logang@deltatee.com>
 <2a6d5554-4f71-6476-6d14-031da52005f5@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <2a6d5554-4f71-6476-6d14-031da52005f5@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 70.73.163.230
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, hch@lst.de
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2 01/12] md/raid5: Factor out ahead_of_reshape() function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-04-26 19:28, Guoqing Jiang wrote:
>>   +static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
>> +                 sector_t reshape_sector)
>> +{
>> +    if (mddev->reshape_backwards)
>> +        return sector < reshape_sector;
>> +    else
>> +        return sector >= reshape_sector;
>> +}
> 
> I think it can be an inline function.

Marking static functions in C files as inline is not recommended. GCC
will inline it, if it is appropriate.

https://yarchive.net/comp/linux/inline.html
https://www.kernel.org/doc/local/inline.html

Logan

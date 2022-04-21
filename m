Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E231C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 21 Apr 2022 16:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390446AbiDUQIO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 21 Apr 2022 12:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346240AbiDUQIN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 21 Apr 2022 12:08:13 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1FDDD7;
        Thu, 21 Apr 2022 09:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=Yo/kFI+BSfldD1V/KUKvSXECNFfrV5oLt6IFn1wNU9Q=; b=JcGWzJ7VcxQJJqc9+OF8ur1idR
        wchgmE+8ce0wMT7T6S0qgdOdwUJX+lhg1kJAP4L+aDqhPb/+UJ51j+Ici4TRvHTypRTDTce+2Ksbl
        u8IOSnjhKMXbHVIRoApwE/Z8WcpNHObd9BZskXIuUj1SnP0prTn+rqUA+iEWVFyp3o3h3NEbOfGR8
        RFx+LOsYgK6nHUOQuge4wQzQHEQTbDxxfvpdfMzdJ85rzbedk6Fa2UVyWtly+PjmqC8LAHwaLlNO7
        3BMVhJNGNeyOlQ3vyOERFbgL9zxnClXER9V1Q78SH9TMZXIniFHanEhsHzsVfrmsd/iaow6TkUslI
        OTqX1Szw==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nhZJ3-00DBQI-QP; Thu, 21 Apr 2022 10:05:22 -0600
Message-ID: <3252df44-5856-c1ed-174e-18748387cdd2@deltatee.com>
Date:   Thu, 21 Apr 2022 10:05:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-CA
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Christoph Hellwig <hch@lst.de>
References: <20220420195425.34911-1-logang@deltatee.com>
 <20220420195425.34911-2-logang@deltatee.com>
 <b0bd9204-1f76-aba3-b754-464e28763f59@molgen.mpg.de>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <b0bd9204-1f76-aba3-b754-464e28763f59@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: pmenzel@molgen.mpg.de, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org, hch@infradead.org, guoqing.jiang@linux.dev, sbates@raithlin.com, Martin.Oliveira@eideticom.com, David.Sloan@eideticom.com, hch@lst.de
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH v2 01/12] md/raid5: Factor out ahead_of_reshape() function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-04-21 03:17, Paul Menzel wrote:
> Dear Logan,
> 
> 
> Thank you for these patches.
> 
> 
> Am 20.04.22 um 21:54 schrieb Logan Gunthorpe:
>> There are a few uses of an ugly ternary operator in raid5_make_request()
>> to check if a sector is a head of a reshape sector.
>>
>> Factor this out into a simple helper called ahead_of_reshape().
>>
>> This appears to fix the first bio_wouldblock_error() check which appears
>> to have comparison operators that didn't match the check below which
>> causes a schedule. Besides this, no functional changes intended.
> 
> If there is an error, could that be fixed in a separate commit, which
> could be applied to the stable series?

Yes, sure. Though, I'm not 100% sure there's an error or noticeable bug.
It's just that the logic didn't match and it made cleaning up the code
overly complicated.


> 
>> Suggested-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
>> ---
>>   drivers/md/raid5.c | 29 +++++++++++++++++------------
>>   1 file changed, 17 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 7f7d1546b9ba..97b23c18402b 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5787,6 +5787,15 @@ static void make_discard_request(struct mddev
>> *mddev, struct bio *bi)
>>       bio_endio(bi);
>>   }
>>   +static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
>> +                 sector_t reshape_sector)
>> +{
>> +    if (mddev->reshape_backwards)
>> +        return sector < reshape_sector;
>> +    else
>> +        return sector >= reshape_sector;
> 
> I like the ternary operator. ;-)
> 
>     return mddev->reshape_backwards ? (return sector < reshape_sector) :
> (sector >= reshape_sector)
> 
> Sorry, does not matter.

Yeah, I think plenty of people do not, though; it's harder to read with
the long line and awkward to wrap.

> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

Thanks,

Logan

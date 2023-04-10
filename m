Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D199C76196
	for <linux-raid@archiver.kernel.org>; Mon, 10 Apr 2023 15:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjDJPZk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Apr 2023 11:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjDJPZh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Apr 2023 11:25:37 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455705580
        for <linux-raid@vger.kernel.org>; Mon, 10 Apr 2023 08:25:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681140313; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cwkYsPCr7UqQ9WsfR0FV3mgrG4SK19ys2giTH0ObmPR1BTczjDxJ5H6cBrGrStd1BLT1W4RI9t3K62eewFMXzbGh5bwSF0plGyuUqsNCzFKfHSko3QcI1CBc7LEACUABZqS28+F0Ahd+iIZusYLUk8H8DL5eeSK1PbKOMFl/Sks=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1681140313; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=WgBWzO8Sji0MmjXxKbvkgSNSiaI3cRK7MnGdRFnqXdo=; 
        b=ISvvSuTJp1hkp14zMNL78mVEXqKbFhcaAX5BIqKkYJzYZVvUJGwr4y1cX7nOLVkmFcwINRwn8fTBYylmNhHcDyiA0H90C6FfhKJ/eET2O0bsATK5ZQo80T+6uks8ut3LwVvz+iSvaUbxFsmll1OlxomQj8sEmiUhi7+B3TvmiVI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1681140311406349.75791765787983; Mon, 10 Apr 2023 17:25:11 +0200 (CEST)
Message-ID: <f45d7d66-0758-6ace-0775-c83dfdbbc58f@trained-monkey.org>
Date:   Mon, 10 Apr 2023 11:25:10 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] super1: fix truncation check for journal device
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>, Hristo Venev <hristo@venev.name>
Cc:     linux-raid@vger.kernel.org
References: <20230401200134.6688-1-hristo@venev.name>
 <168047977245.14629.9624022647798760855@noble.neil.brown.name>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <168047977245.14629.9624022647798760855@noble.neil.brown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/2/23 19:56, NeilBrown wrote:
> On Sun, 02 Apr 2023, Hristo Venev wrote:
>> The journal device can be smaller than the component devices.
>>
>> Fixes: 171e9743881e ("super1: report truncated device")
>> Signed-off-by: Hristo Venev <hristo@venev.name>
>> ---
>>  super1.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/super1.c b/super1.c
>> index f7020320..44d6ecad 100644
>> --- a/super1.c
>> +++ b/super1.c
>> @@ -2359,8 +2359,9 @@ static int load_super1(struct supertype *st, int fd, char *devname)
>>  
>>  	if (st->minor_version >= 1 &&
>>  	    st->ignore_hw_compat == 0 &&
>> -	    (dsize < (__le64_to_cpu(super->data_offset) +
>> -		      __le64_to_cpu(super->size))
>> +	    ((role_from_sb(super) != MD_DISK_ROLE_JOURNAL &&
>> +		  dsize < (__le64_to_cpu(super->data_offset) +
>> +		      __le64_to_cpu(super->size)))
> 
> You need to have extra unnecessary ( and ) in here.  But that doesn't
> make the patch wrong.
> Thanks for the fix.
>  Reviewed-by: NeilBrown <neilb@suse.de>

Applied!

Thanks,
Jes



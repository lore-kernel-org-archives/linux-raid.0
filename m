Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E185C433F5
	for <linux-raid@archiver.kernel.org>; Sat, 16 Apr 2022 12:53:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbiDPM4I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 16 Apr 2022 08:56:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiDPM4I (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 16 Apr 2022 08:56:08 -0400
Received: from mallaury.nerim.net (smtp-106-saturday.noc.nerim.net [178.132.17.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E55DC35DFE
        for <linux-raid@vger.kernel.org>; Sat, 16 Apr 2022 05:53:33 -0700 (PDT)
Received: from [192.168.0.252] (plouf.fr.eu.org [213.41.155.166])
        by mallaury.nerim.net (Postfix) with ESMTP id EB75ADB17C;
        Sat, 16 Apr 2022 14:53:25 +0200 (CEST)
Message-ID: <251b98d6-2ea3-4668-6cdc-1dd99ba4707a@plouf.fr.eu.org>
Date:   Sat, 16 Apr 2022 14:53:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2] md/raid0: Ignore RAID0 layout if the second zone has
 only one device
Content-Language: en-US
To:     Song Liu <song@kernel.org>, NeilBrown <neilb@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <7ffe1f1e-1054-6119-83a8-53edd89a902b@plouf.fr.eu.org>
 <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
From:   Pascal Hambourg <pascal@plouf.fr.eu.org>
Organization: Plouf !
In-Reply-To: <CAPhsuW5+Y4K+fNSgx5AYwHkAHPw8i9z01LWrXM5qOP8qvvzuCg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Le 14/04/2022 à 21:02, Song Liu a écrit :
> On Tue, Apr 12, 2022 at 11:54 PM Pascal Hambourg <pascal@plouf.fr.eu.org> wrote:
>>
>> The RAID0 layout is irrelevant if all members have the same size so the
>> array has only one zone. It is *also* irrelevant if the array has two
>> zones and the second zone has only one device, for example if the array
>> has two members of different sizes.
>>
>> So in that case it makes sense to allow assembly even when the layout is
>> undefined, like what is done when the array has only one zone.
>>
>> Reviewed-By: NeilBrown <neilb@suse.de>
>> Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
> 
> Thanks for the patch and thanks Neil for the review. >
> Applied to md-next with two minor changes:

Do you think this patch qualifies for -stable too ?

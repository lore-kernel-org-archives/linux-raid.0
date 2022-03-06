Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36D21C433EF
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 15:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiCFPzC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 10:55:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiCFPzB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 10:55:01 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8181F6540C;
        Sun,  6 Mar 2022 07:54:09 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 3B2741F38E;
        Sun,  6 Mar 2022 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1646582048; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwLgyVPeezhFPq9TdyJby/Hw7+ux7pROjFqKx9nR6Lg=;
        b=tchtdCsdHZ7LZrJv4/QD21Wct/oStNSqIbFH+DB/if2rxgDHQjhOD+lK7JJHr89d4Q46vr
        6jPmTbe1dJhr5D9rvbkw+mqZGkfW1WS2VlAxWu228SNmcHGqW5ALWT2FBMZKq5zDC6mXqX
        CFHgBcN0uNGH0jZVHM539doCAOO3Ajo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1646582048;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwLgyVPeezhFPq9TdyJby/Hw7+ux7pROjFqKx9nR6Lg=;
        b=QWm/oX/IEKmhtuDHksHW3EsnPV3+HxC5OI068OjI5dY0Q20lybggv7jEtGf+mgUzPqyuNa
        DzY4rCoQgiJSwkAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B4859132C1;
        Sun,  6 Mar 2022 15:54:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XZvdLBnZJGKCXwAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 06 Mar 2022 15:54:01 +0000
Message-ID: <c86d5162-8b80-8a98-c059-dad02b55c395@suse.de>
Date:   Sun, 6 Mar 2022 23:53:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: bcache patches for Linux v5.18
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
 <c94f9c70-7052-0bae-ca0e-9b9ccc48c46b@kernel.dk>
 <3b93c0db-316e-d227-e98e-be7a6f4e2907@suse.de>
 <0143c7fe-6cdb-fb7f-ff94-97eec64ec3e8@kernel.dk>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <0143c7fe-6cdb-fb7f-ff94-97eec64ec3e8@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/6/22 11:15 PM, Jens Axboe wrote:
> On 3/6/22 7:55 AM, Coly Li wrote:
>> On 3/6/22 10:17 PM, Jens Axboe wrote:
>>> On 3/6/22 3:35 AM, Coly Li wrote:
>>>> Hi Jens,
>>>>
>>>> I have technical problem to send patches via email this time, please
>>>> consider to pull the bcache changes from my bcache tree. They can be
>>>> applied on top of your for-5.18/drivers branch.
>>>>
>>>> We have 2 patches for Linux v5.18, both of them are from Mingzhe Zou.
>>>> The first patch improves bcache initialization speed by avoid
>>>> unnecessary cost of cache consistency, the second one fixes a
>>>> potential NULL pointer deference in bcache initialization time,
>>>>
>>>> Please take them for Linux v5.18, thanks in advance.
>>> I can take a git pull, but don't base it on something that isn't a tree
>>> of mine. If I pull your branch right now, I'll get a ton of unrelated
>>> changes.
>> I see, my for-next branch is not 100% clone the for-5.18/drivers
>> branch, although the patches are verified on top of it.
> It doesn't have to be a clone, but you can't sell a pull request that
> ends up meaning the person pulling will get a lot more than the stuff
> you just committed. Which means it should've been based on
> for-5.18/drivers, or some earlier point there depending on when you
> pulled it.


Copied. Keep in mind for the hint.


>
>>> If you want to do a git pull vs sending patches, base it on
>>> for-5.18/drivers instead.
>>>
>> Copied. Now I pull my for-next branch from your for-5.18/drivers
>> branch, and they are same, and the two patches are added on top of it.
> Thanks, pulled.
>
Thanks.


Coly Li



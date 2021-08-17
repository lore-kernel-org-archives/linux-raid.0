Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04E37C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 07:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAE760FA0
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 07:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbhHQHsa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 03:48:30 -0400
Received: from out2.migadu.com ([188.165.223.204]:28593 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239326AbhHQHr6 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 17 Aug 2021 03:47:58 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629186444;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3bkUQwsvWkb9wD53bg43GRj4wh4isgcHFsEI7ZMI6KY=;
        b=g8OjWctrm9NdV+vlPNqCtqzdSOhADEGWnOqXlM5gdbFn8yzUsyp+M4YghOnjNarhWMNdNn
        nzpSgPVO/e8NMI5gtKprpkHa2mVFVBXxXw4DRMVc/AKOD8OOAkNdgve+/apRHEafKlAwwj
        4ms5QLhU2NpiltRdoKxuPVn9VNIcIRU=
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Subject: Re: [PATCH] drivers:md:fix a potential use-after-free bug
To:     Song Liu <song@kernel.org>, lwt105 <3061522931@qq.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <tencent_888910D6F881B3D8BD9C3DFED667A5009806@qq.com>
 <CAPhsuW7cC+d5mhNjJb0AiHDKCUb5WzYPNzZ5UPOSScdtFuNzww@mail.gmail.com>
Message-ID: <6b4c8938-a8a9-1a14-87bd-f30e4eda2b3d@linux.dev>
Date:   Tue, 17 Aug 2021 15:47:16 +0800
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7cC+d5mhNjJb0AiHDKCUb5WzYPNzZ5UPOSScdtFuNzww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/14/21 12:16 AM, Song Liu wrote:
> On Thu, Aug 12, 2021 at 8:46 PM lwt105<3061522931@qq.com>  wrote:
>> In line 2867, "raid5_release_stripe(sh);" drops the reference to sh and
>> may cause sh to be released. However, sh is subsequently used in lines
>> 2869 "if (sh->batch_head && sh != sh->batch_head)". This may result in an
>> use-after-free bug.
>>
>> It can be fixed by moving "raid5_release_stripe(sh);" to the bottom of
>> the function.
>>
>> Signed-off-by: lwt105<3061522931@qq.com>
> The fix looks reasonable.

I am not sure this is needed unless there is real calltrace to prove it. 
Because raid5_release_stripe
doesn't mean it will release the sh's memory,  pls see the comment 
before clear_batch_ready in
handle_stripe, and the path handle_stripe -> handle_stripe_clean_event 
-> break_stripe_batch_list.

Thanks,
Guoqing

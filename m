Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B19EC433FE
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 10:43:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiEIKrp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 06:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiEIKrn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 06:47:43 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801841FB565
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 03:42:05 -0700 (PDT)
Subject: Re: [Update PATCH V3] md: don't unregister sync_thread with
 reconfig_mutex held
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652092648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wv43Hd5gzHFOX5l6YF9caAue8BsDa1BaE/OQvOyZBXg=;
        b=C3Okcuep8gJNZausnHVCZYWdiLy/PCPUMXfqJsVjFm1+On0pQ5PxrPLj8GX6STtiI6MiWW
        l2Wk1GRGWAKA4xqqvi80DlKd17E2NpTP9013AO53rg1XkA8HnUxz8XeOTqK3VLZYXhy298
        /c/fxuq8rtsPEDXLQv5jKE6c3sjx0H0=
To:     Wols Lists <antlists@youngman.org.uk>, Song Liu <song@kernel.org>
Cc:     Donald Buczek <buczek@molgen.mpg.de>,
        linux-raid <linux-raid@vger.kernel.org>
References: <20220505081641.21500-1-guoqing.jiang@linux.dev>
 <20220506113656.25010-1-guoqing.jiang@linux.dev>
 <CAPhsuW6mGnkg4x5xm6x5n06JXxF-7PNubpQiZNmX0BH9Zo1ncA@mail.gmail.com>
 <141b4110-767e-7670-21d5-6a5f636d1207@linux.dev>
 <c2917c23-c218-e600-7e10-31a504c844e2@youngman.org.uk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f3c2ea9a-2dd4-52be-cd3d-a8c994213fd4@linux.dev>
Date:   Mon, 9 May 2022 18:37:23 +0800
MIME-Version: 1.0
In-Reply-To: <c2917c23-c218-e600-7e10-31a504c844e2@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/9/22 5:32 PM, Wols Lists wrote:
> On 09/05/2022 09:09, Guoqing Jiang wrote:
>> I can switch back to V2 if you think that is the correct way to do 
>> though no
>> one comment about the change in dm-raid.
>
> DON'T QUOTE ME ON THIS
>
> but it is very confusing, as I believe dm-raid is part of Device 
> Managment, which is actually nothing to do with md-raid


No, dm-raid (I mean dm-raid.c here) is a bridge between dm framwork and 
md raid, which
makes dm can reuse md raid code to avoid re-implementation raid logic 
inside dm itself.
> (apart from, like many block layer drivers, md-raid uses dm to manage 
> the device beneath it.)

The above statement is very confusing.

Thanks,
Guoqing

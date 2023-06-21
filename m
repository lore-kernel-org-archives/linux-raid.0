Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8D9EB64D7
	for <linux-raid@archiver.kernel.org>; Wed, 21 Jun 2023 19:34:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjFUTee (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Jun 2023 15:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjFUTed (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Jun 2023 15:34:33 -0400
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 611CC10DB
        for <linux-raid@vger.kernel.org>; Wed, 21 Jun 2023 12:34:31 -0700 (PDT)
Received: from host86-148-163-5.range86-148.btcentralplus.com ([86.148.163.5] helo=[192.168.1.99])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1qC3b2-0002KW-CF;
        Wed, 21 Jun 2023 20:34:29 +0100
Message-ID: <e1097397-e477-0449-7579-348eecc81a18@youngman.org.uk>
Date:   Wed, 21 Jun 2023 20:34:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
 <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
 <20231606122233@laper.mirepesht> <20231606152106@laper.mirepesht>
 <cbc45f91-c341-2207-b3ec-81701a8651b5@huaweicloud.com>
 <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
Content-Language: en-GB
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CALTww2-Wkvxo3C2OCFrG9Wr_7RynjxnBMtPwR4GppbArZYNzsQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 21/06/2023 09:05, Xiao Ni wrote:
> Cool. And I noticed you mentioned 'fast path' in many places. What's
> the meaning of 'fast path'? Does it mean the path that i/os are
> submitting?

It's a pretty generic kernel term, used everywhere. It's intended to be 
the normal route for whatever is going on, but it must ALWAYS ALWAYS 
ALWAYS be optimised for speed.

If it hits a problem, it must back out and use the "slow path", which 
can wait, block, whatever.

So the idea is that all your operations normally complete straight away, 
but if they can't they go into a different path that guarantees they 
complete, but don't block the normal operation of the system.

Cheers,
Wol

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1832BC4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 09:33:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F07FD61AFA
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 09:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232260AbhHPJdw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 05:33:52 -0400
Received: from out2.migadu.com ([188.165.223.204]:12210 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230506AbhHPJdu (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 05:33:50 -0400
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629106397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6vKddxcvuqgOA5s2mFXquTaR5ywAqvgu83AKcJE6DtQ=;
        b=e+vTCH5Q0OQhVWpWRPy+Bskbmlj19fTRK+Al+q/V1l31qf3scn5hEV2bKfsNSUU4o1O9Ru
        sYFoC6pE0KDbem8vDQU6munHChTlmj3GbIuOK8OLNybKYcaItImEmJVjFA0u+L7cnIc1iO
        S74G8YRK4rs+3CjJOLdJid13wZ46lBQ=
To:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
References: <1628481709-3824-1-git-send-email-xni@redhat.com>
 <f8d6871b-c586-a572-4c78-ad5adafc2a6e@linux.dev>
 <CALTww2-YhNyKCyMjjviWJ4XmELNUZJonryrJfXtrwP4DU-C1zg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <4398469c-571e-ae00-99df-6e46d2edb3a7@linux.dev>
Date:   Mon, 16 Aug 2021 17:33:00 +0800
MIME-Version: 1.0
In-Reply-To: <CALTww2-YhNyKCyMjjviWJ4XmELNUZJonryrJfXtrwP4DU-C1zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

On 8/16/21 5:01 PM, Xiao Ni wrote:
> On Mon, Aug 16, 2021 at 2:36 PM Guoqing Jiang <guoqing.jiang@linux.dev> wrote:
>> Can rdev be removed between the first loop and the second loop?
>>
> Hi Guoqing
>
> As the patch's commit message says, it adds rdev->nr_pending already.
> So we can guarantee the rdev
> can't be removed during the first loop and the second loop.

I missed that, thanks for clarification. Maybe mention it in description 
that  nr_pending is incremented
which means rdev can't disappear.

Thanks,
Guoqing

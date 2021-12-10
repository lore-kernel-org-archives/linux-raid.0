Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1C5AC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 01:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhLJBe3 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 20:34:29 -0500
Received: from out1.migadu.com ([91.121.223.63]:60699 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhLJBe2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 9 Dec 2021 20:34:28 -0500
Subject: Re: [PATCH 2/2] md: Move alloc/free acct bioset in to personality
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639099853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lmL31ek4YWAITOfYOpN0kSu1qd9uPJteALlsGUoPLOM=;
        b=DzgvVGF3Idob7pBxpGERc9GjGPFbNLlt1hyDiJXEADm7i8RR53jgbjB+JIASIEVwEPsECX
        DTc1b9H84JuFrGrUoGWIaEKStguqrLGUlWGl4b5ecOP3TgCySYph65P/017kqPzDM49WGG
        fhsLm5FmWIiKnVG+q2x0SNZI86veGaE=
To:     Xiao Ni <xni@redhat.com>, song@kernel.org
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org
References: <1639029324-4026-1-git-send-email-xni@redhat.com>
 <1639029324-4026-3-git-send-email-xni@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <271afe73-b75c-0106-7906-11a40ca1a9dc@linux.dev>
Date:   Fri, 10 Dec 2021 09:30:48 +0800
MIME-Version: 1.0
In-Reply-To: <1639029324-4026-3-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/9/21 1:55 PM, Xiao Ni wrote:
> Now it alloc acct bioset in md_run and only raid0/raid5 need acct
> bioset. For example, it doesn't create acct bioset when creating
> raid1. Then reshape from raid1 to raid0/raid5, it will access acct
> bioset after reshaping. It can panic because of NULL pointer
> reference.

Thanks, I think the previous commit didn't think of the reshape scenario.
Could you paste the relevant info into commit header?

> We can move alloc/free jobs to personality. pers->run alloc acct
> bioset and pers->clean free it.

In the reshape case,  the caller of pers->run is level_store, so.

Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>

Thanks,
Guoqing

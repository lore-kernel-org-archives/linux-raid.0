Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B089C4338F
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 06:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01A89619E1
	for <linux-raid@archiver.kernel.org>; Mon, 16 Aug 2021 06:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhHPGgd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Aug 2021 02:36:33 -0400
Received: from out0.migadu.com ([94.23.1.103]:27689 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230442AbhHPGgb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Aug 2021 02:36:31 -0400
Subject: Re: [PATCH 1/1] md/raid10: Remove rcu_dereference when it doesn't
 need rcu lock to protect
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1629095759;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a9VBFvW/KSBwCkWxjgccN/9xcnZ6bj4Hr/XeFhd74wk=;
        b=w5/95A5VxsBfozKne1AKwc6RATsmcrPU8sRF4XE58qBt2ZvFkKIXfdrFjBOOREBQ9O0SxN
        MeAO47i47YK18oe5ITKs8Z0bC4ADrH08FUAxbB5FMSxhEv3juhcLaWd8mOPx9ytCYFwTPE
        47P5jeAKnZvyRpN4TfnkH/SQhIvsZ7U=
To:     Xiao Ni <xni@redhat.com>, songliubraving@fb.com
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org
References: <1628481709-3824-1-git-send-email-xni@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <f8d6871b-c586-a572-4c78-ad5adafc2a6e@linux.dev>
Date:   Mon, 16 Aug 2021 14:35:56 +0800
MIME-Version: 1.0
In-Reply-To: <1628481709-3824-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: guoqing.jiang@linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 8/9/21 12:01 PM, Xiao Ni wrote:
> In the first loop of function raid10_handle_discard. It already
> determines which disk need to handle discard request and add the
> rdev reference count. So the conf->mirrors will not change until
> all bios come back from underlayer disks. It doesn't need to use
> rcu_dereference to get rdev.

Can rdev be removed between the first loop and the second loop?

Thanks,
Guoqing

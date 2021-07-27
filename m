Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1D3FC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 20:05:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79AF760F9B
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 20:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhG0UF1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 16:05:27 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17059 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbhG0UF0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jul 2021 16:05:26 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627416319; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=d4vL6moeyldPyvC6tqBhmGSy5Jeit1zD4jwfKLMKSajKfMmksKoNiJURodYsByLJ4hPUEmOmPu95gD3qt54Kbm/gk4cqGMpjPPXoqfLbgg7GBCrh6/Vy09/9yDAdPCAaixPymlOVbzPaXNLSWoOyXVjkMh93l3iNHPal0DeR5iQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627416319; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=D4r3TNxVX1+ztTeO3cPqct/6wqTlZ7uAjVnSA+stgaE=; 
        b=PIzC3HD6cSPHrNS2krb4kfhI1uzldh+G1EuBf1XfenH+EgJQkKfY0Ckc0x3Fu1SOQly8VRK2UiuB5Jb9R6ldGMWCNXbWfI/N1uzjycaNxKdZ6mNpQ1C8Hu8rCRB8mVYgPs/mRyZQVSPWjSdIxX0h+k3wcJgkZ3GCmZUnJrXuNAU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627416317966869.5572101380953; Tue, 27 Jul 2021 22:05:17 +0200 (CEST)
Subject: Re: [PATCH] imsm: fix num_data_stripes after raid0 takeover
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210721114220.19399-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <1922ca0d-370c-8d99-20fa-591e76fd4844@trained-monkey.org>
Date:   Tue, 27 Jul 2021 16:05:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210721114220.19399-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/21/21 7:42 AM, Mariusz Tkaczyk wrote:
> After raid1 to raid0 migration num_data_stripes value is
> incorrect because was additionally divided by 2.
> 
> Create dedicated setters for num_data_stripes and num_domains
> and propagate it across the code to unify alghoritms and
> eliminate similar mistakes.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---

Applied!

Thanks,
Jes



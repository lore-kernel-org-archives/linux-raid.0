Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C21C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 20:47:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 020F16113D
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 20:47:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhEFUsf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 16:48:35 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17066 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhEFUsf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 16:48:35 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1620334047; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=SbaGzDWZVv1zqXMGLoErhJxlnR9gjm0AWtwpcqRlceOJy2Bmdt0xY/NaodHcg54VMBnods8D+IsBZBcuMHyU46W2nNYZaGr0LwUai2HQOxhMlz4Se1Y47lEkPoXsQzU3UD9YWoJlpwwQknpUZDeeuft6RY5L4jn9HSfhWPErRWE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1620334047; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=/Nr6yCqHJlXIqq9G9VHF6IMm9Hpg8GpYLXhAE/8ISlM=; 
        b=exMBS+WTHVVkS9bUlE18wgjbpOd9tWxZWgnUGJaslZoF4N5TcdU8mIwVeHTuXch3Wo0tmo4tE4hv3baPE8w6yr/FZ7tvhMkoP6opDLC+ZWruohXbbtcgtUJKNn6Snp36ps9vaKfeqDu7iMR3HJ2pts0mFilrVJQ0FfttWZLP0+c=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.80] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1620334044526481.6405739360948; Thu, 6 May 2021 22:47:24 +0200 (CEST)
Subject: Re: [PATCH 1/1] Fix some building errors
To:     Xiao Ni <xni@redhat.com>, jes.sorensen@gmail.com
Cc:     ncroxon@redhat.com, linux-raid@vger.kernel.org,
        mariusz.tkaczyk@linux.intel.com
References: <1619157690-5443-1-git-send-email-xni@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <b6514c89-97fb-a8f9-0924-7573a1e007a9@trained-monkey.org>
Date:   Thu, 6 May 2021 16:47:23 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1619157690-5443-1-git-send-email-xni@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/23/21 2:01 AM, Xiao Ni wrote:
> There are some building errors if treating warning as errors.
> Fix them in this patch.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>  super-intel.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Applied!

Thanks,
Jes


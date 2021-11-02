Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EED52C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB6A361050
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 17:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhKBRPd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 13:15:33 -0400
Received: from sender12-1.zoho.eu ([185.20.211.225]:17282 "EHLO
        sender12-1.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhKBRPd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 13:15:33 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1635873173; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=f4Yu4tBt4MvdQOgdvKgOyCHtOk5r3679biZdILCZeRxqYLA1abS2qAN/x7CZPHJUuvCfnxkJ8X6cyuhgymUr/ZH0m1CYpqhBK/g6GmGZL6ROoIELbant+06h5ULgk8l9AtXaXyTNDOqGmv3CyMxRMFG639QdVVRtWDstHAo465E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1635873173; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hFpeRb78dMRPeTxukbwAnevUO6SqTOmJHUfR1ryHRIw=; 
        b=Ct63XQS8r0uZ6NAE71YRumPnYmTWYvRS4R2KmA5vWuWMMIkQ7b0fv7p+/oE38bfd3WCFXOtwGQ0NfeDwRgml9pe4AB5UEMEk80Qbbz0mjswjOPegEJ5uKG+K+vzUzBXWYxNjan2XSpzwwc+B8ulAVp5jam1v54O4DSdurOdOOs4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1635873172431819.9396610237224; Tue, 2 Nov 2021 18:12:52 +0100 (CET)
Subject: Re: [PATCH] mdopen: use safe functions in create_mddev
To:     "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210921075257.10668-1-mariusz.tkaczyk@linux.intel.com>
 <4fe0ce47-cc8a-88b3-d5f8-e1377eec4688@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <701b49ba-ebc1-3f85-01d1-912a9af2f6c7@trained-monkey.org>
Date:   Tue, 2 Nov 2021 13:12:51 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <4fe0ce47-cc8a-88b3-d5f8-e1377eec4688@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/2/21 12:51 PM, Tkaczyk, Mariusz wrote:
> Hi Jes,
> If you considering it as risky, let me know.
> It can wait to 4.2.
> 
> Thanks,
> Mariusz

Sounds good, I'll ignore it for now.

I'll try and cut -rc3 tomorrow hopefully. If anyone has something really
important, now would be a good time to nag me.

Cheers,
Jes

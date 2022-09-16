Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21263ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 19:27:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiIPT1p (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 15:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiIPT1n (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 15:27:43 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E3CB2DAC
        for <linux-raid@vger.kernel.org>; Fri, 16 Sep 2022 12:27:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663356449; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=hdMU1P6MulvoDpmb39bhTH7uLQV+jFzl1aTAvghqZlSiGLHOMhEW/xOQ/xOcrih/Sg5bIarhcAiDGGC+WkWd4m/e4o/NeGFQQUA5vFJi1ph5TVw+SiSk7lO2ONE4C9ifFprz9BrqmgDr5Ldnbm8IT0OdauwmkJeBXMDzxvjGE0Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1663356449; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=9y4jeEHR6YiSOsY6lzkPAtBFBqfNA0IJl6+ztMh8mBs=; 
        b=C9bEyLVfuogugX69NSX+2hurWbW0LLFDyT16tKUYaMMnRhlb9FVQPrh48TLaXVYVnfNcEKXYpPnlO4RqBr4nPQCELzk8lM0HLc5QLdHypYQdxmp+vsfTQIsY82d8QtinL/pjKf9FsD3E0P9GaBSQHrJ/fz9eHgyO3MlztoWcF6o=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1663356446717721.9452003178606; Fri, 16 Sep 2022 21:27:26 +0200 (CEST)
Message-ID: <5f493463-6e69-419f-affc-b0de8424fa1a@trained-monkey.org>
Date:   Fri, 16 Sep 2022 15:27:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 0/2] Small fixes from Debian
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, colyli@suse.de
Cc:     felix.lechner@lease-up.com, linux-raid@vger.kernel.org
References: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/9/22 09:50, Mariusz Tkaczyk wrote:
> Hi Jes and Coly,
> Here we have small Debian customizations worth to be integrated.
> 
> Changes:
> - Commit title updated, suggested by Paul.
> 
> Mariusz Tkaczyk (2):
>   mdadm: Add Documentation entries to systemd services
>   ReadMe: fix command-line help
> 
>  ReadMe.c                             | 2 +-
>  systemd/mdadm-grow-continue@.service | 1 +
>  systemd/mdadm-last-resort@.service   | 1 +
>  systemd/mdcheck_continue.service     | 3 ++-
>  systemd/mdcheck_start.service        | 1 +
>  systemd/mdmon@.service               | 1 +
>  systemd/mdmonitor-oneshot.service    | 1 +
>  systemd/mdmonitor.service            | 1 +
>  8 files changed, 9 insertions(+), 2 deletions(-)
> 

Applied!

Thanks,
Jes


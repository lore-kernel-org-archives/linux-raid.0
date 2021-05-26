Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 398CCC2B9F7
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 11:29:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1469B613CD
	for <linux-raid@archiver.kernel.org>; Wed, 26 May 2021 11:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhEZLao (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 May 2021 07:30:44 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17031 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234658AbhEZL2t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 26 May 2021 07:28:49 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622028426; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=kNEBW7PT+/lT/DimeSHJbsB6EU5gDqGsBrZ82D2PA6KmypHcL+D4xLnXyqODr0s4KnxUA8OLqi58UZxjpDCJXBitBUFjgHAU3wd5KjvUhyHu+EozCIJuocARhedCDDI3uzF1iWPWutdwQGYSU4pvuznqqMlB88b8aF6LTmkpL+c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1622028426; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=KfcEfC4R8YfY6Y//IrBcaY71vlp5PTHys+geKN2aUUU=; 
        b=i/wJqjB59YCp4W9YIDV46M4iS0UTWo7Y4k/kWrndPIDrrKAex6ov3Lb4DZFDJIqw9XtlhITvr74PmVpayAjt2kSMj+X8fVGEPjcml1y3rP4cecx8ZeOGVifZagOq3dAGjKz2Jsgy0frNZLAMTb0/eyTSytKtPx5D4ugtGUgDPgQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1622028424344714.148785876924; Wed, 26 May 2021 13:27:04 +0200 (CEST)
Subject: Re: [PATCH 0/4] imsm: lowest namespace support
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
References: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <beae1052-ee1e-c42f-5cde-24fd28586aa2@trained-monkey.org>
Date:   Wed, 26 May 2021 07:27:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210517143903.10077-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/17/21 10:38 AM, Mariusz Tkaczyk wrote:
> Nvme specification doesn't guarantee the first namespace existence.  
> Imsm shall use lowest one instead of first. In this patchset imsm parts
> responsible for reading sysfs attrs were refactored and simplified to
> generic routines. Imsm compatibility checks were moved to
> validate_geometry_imsm_container. This prevents from writing metadata
> to rejected drive.
> 
> Mariusz Tkaczyk (4):
>   imsm: add generic method to resolve "device" links
>   imsm: add devpath_to_char method
>   imsm: Limit support to the lowest namespace
>   Manage: Call validate_geometry when adding drive to external container
> 
>  Manage.c         |   7 ++
>  platform-intel.c | 179 +++++++++++++++++++++++++++---------
>  platform-intel.h |   8 +-
>  super-ddf.c      |   9 +-
>  super-intel.c    | 233 +++++++++++++++++++++--------------------------
>  5 files changed, 256 insertions(+), 180 deletions(-)
> 

Applied!

Thanks,
Jes


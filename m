Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4A12CA0FE4
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 16:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239490AbjIAQOr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232030AbjIAQOm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 12:14:42 -0400
Received: from sender-op-o11.zoho.eu (sender-op-o11.zoho.eu [136.143.169.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C39BCE5F
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 09:14:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693584863; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ccBl/N2FKUDpxqrWy2IrH5S7hJp3BvW1QobghSgApCciIHm6/3zfeF+YeDZXs5j6dQ6DF0Bvgnrk3CtTw2HaUnKbeJpOwMz/ts2tjN7xoUp3O7YAISfOJ9oPGIDpDjYPijruNDYAxnyhfJiQQER0Ko+VAMcx/rr2EgPovZMgMTk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693584863; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=YlMUvVRs4ZD3XFwQBd2MkH2GfOF9G+VgRaJGlbbBSwA=; 
        b=OVp4N4uEnvWlRsTGs1RXc92HTf4KdAUAGGK0maVmqc3hBRRWkuzUNdsaiI0rVBChlEBvKIYcEHeR10t2gQpbM7cbUZLCEXjpe5+Ncx6dIz4v7Lwmht3p/EZ38494UvKIrdxmmC+arpxCh4uPHcH81RaVojt7nOKJU3azyTWu/K4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1693584860959449.28046645673396; Fri, 1 Sep 2023 18:14:20 +0200 (CEST)
Message-ID: <3a6a41ba-3bee-cb21-c7eb-53f4e54138fe@trained-monkey.org>
Date:   Fri, 1 Sep 2023 12:14:19 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] imsm: Add reading vmd register for finding imsm
 capability
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230705142317.13981-1-mateusz.grzonka@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230705142317.13981-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/5/23 10:23, Mateusz Grzonka wrote:
> Currently mdadm does not find imsm capability when running inside VM.
> This patch adds the possibility to read from vmd register and check for
> capability, effectively allowing to use mdadm with imsm inside virtual machines.
> 
> Additionally refactor find_imsm_capability() to make assignments in new
> lines.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  platform-intel.c | 114 ++++++++++++++++++++++++++++++++++++++++++++++-
>  platform-intel.h |  11 ++++-
>  super-intel.c    |  11 +++--
>  3 files changed, 130 insertions(+), 6 deletions(-)

Applied!

Thanks,
Jes



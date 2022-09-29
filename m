Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 331A6C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 15:14:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbiI2POL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235811AbiI2POG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 11:14:06 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0079114C066
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 08:14:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1664464425; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=ZYhb5dTHImEipm0SxqDZFAgv0Vyn6qzrkQHR5yt679C22U0kaRIPugcNgwuB2XdHz5Apy2GnTvkqZHLPaGm5pBF04CgA2TcQDX6AL1VR+iqYhiqYLmbHv//kEuFjSOTyuU1hdUuUN1Fnzdu1iWnYpbgIRRs8mY5DsniuT4apHKw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1664464425; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JmTyYNui3MmF5df9I5LmtWLbQkT+b5ecqYGQz5MSO+Q=; 
        b=PwtL2j+tFljz76k3E/QmRsPBRvHDOXaruWYJomJIiNKnUGa0CfeI2R8IcmdXphm357OHP5m1D23/lTWM7nnkSiS5FCcMKII3pls96nSkA1/dvVYJ7gVA8RJ/c20sOjMCPwTEpa/yPo6SzeBtF0rILTGNNzzTMmd2FSbr6weIKYo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 166446412289111.561821615684494; Thu, 29 Sep 2022 17:08:42 +0200 (CEST)
Message-ID: <08caf2f3-2223-fd3b-82f6-44fee597ddc8@trained-monkey.org>
Date:   Thu, 29 Sep 2022 11:08:41 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v4 0/2] Mdmonitor improvements
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20220606103213.12753-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220606103213.12753-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/6/22 06:32, Kinga Tanska wrote:
> Changes in v4:
> - fix place where is_mddev is calling
> - no new changes in "Mdmonitor: Improve logging method" patch
> 
> Kinga Tanska (2):
>   Mdmonitor: Fix segfault
>   Mdmonitor: Improve logging method
> 
>  Monitor.c | 36 ++++++++++++++++++++++++------------
>  mdadm.h   |  1 +
>  mdopen.c  | 17 +++++++++++++++++
>  util.c    |  2 +-
>  4 files changed, 43 insertions(+), 13 deletions(-)
> 

Coly,

I am curious why these are marked Changes-requested in patchwork as
there are no replies in the thread.

https://patchwork.kernel.org/project/linux-raid/patch/20220907125657.12192-2-mateusz.grzonka@intel.com/

Thanks,
Jes



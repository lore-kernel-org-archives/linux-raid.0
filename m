Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C93CA0FE4
	for <linux-raid@archiver.kernel.org>; Fri,  1 Sep 2023 16:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344971AbjIAQQk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 1 Sep 2023 12:16:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345362AbjIAQQj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 1 Sep 2023 12:16:39 -0400
Received: from sender-op-o10.zoho.eu (sender-op-o10.zoho.eu [136.143.169.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CF010FA
        for <linux-raid@vger.kernel.org>; Fri,  1 Sep 2023 09:16:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1693584988; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=cnNd+8KKo7V7a/qGBalX/YD4R5zPDhhwugWxILQCl0clFik/vZeszxY/TKQRQFzp2bpshLHHsNrePY/GlbJgNtkdXDXNnFAE2ZkhEc6+mzQXJF6y9LswIPokfaO7dFspFrP2XaVA385ap613YC+QKr93chXCTVQxeKLAkOcRIFA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1693584988; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=AnRnXKr8cgAarVJ7VLvC4nm7tT0FFScWn4xEKt7gGi8=; 
        b=Gpn0dyuWBcOO6hVn95wMfp54vymAA0gdmB0neA3XUT1LL51lN0tepIAIseMqkTjXYREURkqBy9/ekAFoVyKFtH5wf1WYHAar3tKV6H9HmMc+k0Ays37buFm/AOzW1+vTuZVWvPsSTOC1bMyQ/eOr5avHonzcPauPM03gjCLzQkY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 169358498619037.95035511125877; Fri, 1 Sep 2023 18:16:26 +0200 (CEST)
Message-ID: <cd03eb71-8dc8-3c42-f5ad-1c6ad1ea4b8f@trained-monkey.org>
Date:   Fri, 1 Sep 2023 12:16:24 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] Add compiler defenses flags
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20230717131910.22713-1-mateusz.grzonka@intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230717131910.22713-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/17/23 09:19, Mateusz Grzonka wrote:
> It is essential to avoid buffer overflows and similar bugs as much as
> possible.
> 
> According to Intel rules we are obligated to verify certain
> compiler flags, so it will be much easier if they are added to the
> Makefile.
> 
> Add gcc flags for prevention of buffer overflows, format string vulnerabilities,
> stack protection to prevent stack overwrites and aslr enablement through -fPIE.
> Also make the flags configurable.
> 
> The changes were verified on gcc versions 7.5, 8.3, 9.2, 10 and 12.2.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Seems reasonable and fairly broad testing, so applied!

Thanks,
Jes



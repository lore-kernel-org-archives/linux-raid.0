Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7504EC25B48
	for <linux-raid@archiver.kernel.org>; Thu, 26 Oct 2023 21:53:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjJZVxE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjJZVxD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 26 Oct 2023 17:53:03 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90401129
        for <linux-raid@vger.kernel.org>; Thu, 26 Oct 2023 14:53:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1698357175; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=GMk2EctpoOEBq5o147rMmkc4X4aLGCoNLn52JrNHlFOKRa94q0tKnHtt0MEk0Wd43SBodrtbS7XdnC0Y60dtmWrA2SVDWk0XeQBMefUItK3smeECJEiPePXwGVHJj4bJ8w6jZMxLWr2eKYpc3AOyPeHPDIxYvKp3SrvkBIAtpB8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1698357175; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
        bh=9kRDOW5B5tPOlFlONpFogq+PkX0k9NYPtSyBIRkFFVY=; 
        b=ESTWeD7ZBUvR5GQWezH8/DhAOkvJnON97tkSI6Vdc2m43XO0mCnGU1ohufszSGvpGc6iatFyRZ2oG6lFa0SBd7EOxONca2gGmDoG8Tf0ntCGhQhf8ahMTvepV0y++zE0VHfPIQP0hOM85EBHppiXHZ4PCm2tPZYHfi4LCZH4/YQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1698357172937812.7293030501868; Thu, 26 Oct 2023 23:52:52 +0200 (CEST)
Message-ID: <09ffa570-57dc-e8f8-1ac8-2fbe32b6797a@trained-monkey.org>
Date:   Thu, 26 Oct 2023 17:52:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 0/2] Remove container_enough logic
Content-Language: en-US
To:     Pawel Piatkowski <pawel.piatkowski@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20231019143525.2086-1-pawel.piatkowski@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20231019143525.2086-1-pawel.piatkowski@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/19/23 10:35, Pawel Piatkowski wrote:
> Pawel Piatkowski (2):
>   mdadm: remove container_enough logic
>   Fix assembling RAID volume by using incremental
> 
>  Assemble.c    | 10 ++++------
>  Incremental.c | 11 -----------
>  mdadm.h       |  3 ---
>  super-ddf.c   |  1 -
>  super-intel.c | 32 +-------------------------------
>  5 files changed, 5 insertions(+), 52 deletions(-)
> 

Looks reasonable to me. If it breaks, we know where to find Intel :)

Applied

Thanks,
Jes


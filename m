Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3213C678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 18:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbjCHS4a (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Mar 2023 13:56:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbjCHS42 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Mar 2023 13:56:28 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0F4C3E3F
        for <linux-raid@vger.kernel.org>; Wed,  8 Mar 2023 10:56:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1678301759; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=FGasKoA2lgvLnUngnF5xDEfZBnC5I0De8CeTjGRom0voNGN5C8/nM3hCvKR7QyH4CQQMp+VYSkm3Rz4QMqADVVSGb4aPtH/vl8crK45wYh9KnZX7Vgb+t1pkiq0dcZNWcYRfU8CGjelHSDdcHaU7BGHFdQo3zUL4hEth4rh46c0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1678301759; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AWefr7bHM+tt266CgDPQbpRgoN3ZCq4ibNq+4f9Lr94=; 
        b=UaZLCahHJllPr5uc7s6/hl3Ht3kGPLyHX5c+mpsocLn25eRQBR5v/sBl/EFtgnqXNxTxEVaSV0mGX8wxyoIZdOpi6EGLHioMrmHSbBRGUS+R/+zKNVJdthmYhjKJZedk+LAcqgFEVu7aetpmUsqqwTAkr+4njlGsbuuZUz8A/tQ=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1678301756414226.87573245317367; Wed, 8 Mar 2023 19:55:56 +0100 (CET)
Message-ID: <a642df14-29f5-a2ec-cab8-e8db5bde1d35@trained-monkey.org>
Date:   Wed, 8 Mar 2023 13:55:53 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 0/6] rebased patch set from Wu Guanghao
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, mariusz.tkaczyk@linux.intel.com,
        pmenzel@molgen.mpg.de, Wu Guanghao <wuguanghao3@huawei.com>
References: <20230303162135.45831-1-colyli@suse.de>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230303162135.45831-1-colyli@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/3/23 11:21, Coly Li wrote:
> This is the rebased patch set from Wu Guanghao, all the patches can
> be applied on top of commit 0a07dea8d3b78 ("Mdmonitor: Refactor
> check_one_sharer() for better error handling") from the mdadm tree.
> 
> The patch from me is to solve conflict for the first patch of Guanghao.
> In order to make the commit logs to be more understandable, I recompose
> some patch subjects or commit logs.
> 
> The V2 series only changes the patch subject of mine by the suggestion
> from Paul Menzel. And nothing more changed from V1.
> 
> Thank you in advance for taking them.
> 
> Coly Li

All applied!

Thanks Coly rebasing these!

Jes



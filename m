Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF802C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 20:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiG1Uy6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 16:54:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiG1Uy5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 16:54:57 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1919867581
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 13:54:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1659041678; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=knyed3E+kfXLw4YyYSnSUUHd4a3PLez+TSgEpEJrgFbyd/F99hUJinWEjnz2TMLkln5+wzVEhqR9qzto10N1YiTDnmi6KbbXnZZBJkZ9DtxPiHVrQovpU9TAQgBPfRGgpNCcGYA982+DEvU91z4hW64Sc8f4KGFt+Tqm+Eeohhc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1659041678; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=nTiYKkPJfCNDv1wZKMQoIt7tlg72f9ixQ35sW/oJHqE=; 
        b=KkcH+LG+yrX17Pryq2WKE6z8WLPQiHie5xpDm0aKH9QJK0+0WorPMeKhfcAdX+tyR/aufsi54ej3rC67JijwBq3b2twqwX1sX+ZmYLzZ+yOU1wOB3sGiKzQUFDZl2I7y18v6qRnNDeUvQ5rR1h97RHuHPA3FYcZ/7u3PibJrzIY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 1659041676159650.539915946776; Thu, 28 Jul 2022 22:54:36 +0200 (CEST)
Message-ID: <95f1ed01-2d7f-a9c3-0a5c-bc26a1aafad2@trained-monkey.org>
Date:   Thu, 28 Jul 2022 16:54:34 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/2 RESEND] mdadm: Fix array size mismatch after grow
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220722064348.32136-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/22/22 02:43, Lukasz Florczak wrote:
> Changes in v2:
> - split commit into two,
> - explain dead code part,
> - reformat commit body to wrap text after 72 characters.
> 
> Lukasz Florczak (2):
>   mdadm: Fix array size mismatch after grow
>   mdadm: Remove dead code in imsm_fix_size_mismatch
> 
>  super-intel.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 

Applied!

Sorry about the delay, I am still catching up after finally falling
victim to the virus at the beginning of the month.

Thanks,
Jes


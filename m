Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1246C43334
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbiFNObf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344068AbiFNObd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:31:33 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07905393D8
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:31:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655217086; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=A7NgKm15DcQSlK5+7FlSoiq1yKoENOVaAGHdBSHASPqoLVE6cjoBLNMS1Qy21CWBwquoF+kLObrl3zMt74M0plPU0dp7IPH5tRddZnv8TNfZnxkj4t1iEcHhzPPc7UHeZcvn/bXs65TeXARPokJwRyKFyyIkGzgIX2p+qaWogcA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655217086; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BQep0Nu43NnUlTMAvq50WX9UnyXHY2bl9YAaWIpV9A4=; 
        b=N99IWPV8c1rmsNG3qXIT60OvJB7FCqEHEuh7PfIQZO22mmubsRyCqq4KqQkBQQcY5aPctJ213y24Z4uB2QcyMm/UrfyV2rDvEGZV3Q6zVl4lvUOiumtqocTa97WHhE/9vpiK4wYZpFOJYOtX1iGhjHTumOgSM2uuTm4kJzJAEEk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1655217084525911.5298567396502; Tue, 14 Jun 2022 16:31:24 +0200 (CEST)
Message-ID: <764bd8be-24eb-39d8-9f97-cd6b6b9b139d@trained-monkey.org>
Date:   Tue, 14 Jun 2022 10:31:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 resend] Incremental: Fix possible memory and resource
 leaks
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20220613101125.20593-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220613101125.20593-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/13/22 06:11, Mateusz Grzonka wrote:
> map allocated through map_by_uuid() is not freed if mdfd is invalid.
> In addition mdfd is not closed, and mdinfo list is not freed too.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> Change-Id: I25e726f0e2502cf7e8ce80c2bd7944b3b1e2b9dc
> ---
>  Incremental.c | 32 +++++++++++++++++++++++---------
>  1 file changed, 23 insertions(+), 9 deletions(-)
> 

Applied,

Thanks,
Jes




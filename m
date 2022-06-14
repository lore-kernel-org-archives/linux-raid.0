Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59F18C43334
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239799AbiFNOpk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238801AbiFNOpg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:45:36 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D80D2CE14
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:45:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1655217929; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=MkiYnQlO2EBZmwcjO/zmHxO3st6jGx7HfoiTE3imBPFSgfsVuCv2ojsot33lNnlYEiGtQBG5bvBxhPYaYAJ/hi8QvoUv05wAEBO5AIm0V5eSmbQOjGjaiMDv/sdSJdUvMRNLKcKp2n3Nl8j4Ipan6vGetIX2RiAiVU5c5J1Iamw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1655217929; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=h12XkOMoSIQwJiew/TGtCSRQWWz6PO/BxIUUQ4z4jFk=; 
        b=AOeTVzTxDCjLjLSq44pPjqsa+0dHIVmO/wjcsz64pz21dCNbAt0hjgmPhplAXhDAWqLT5LMCXTsUjFlx5PqVehE0dRk+HybL5BAUceueOCseSgXOh2W6AFeHhaIRiTxJynujtLSy9T6IYmMTd1NcNi5PItRtTo2LTVehIQFuafM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1655217926975842.3194071137848; Tue, 14 Jun 2022 16:45:26 +0200 (CEST)
Message-ID: <021517a5-d1d9-6a87-4905-b4a891e44d25@trained-monkey.org>
Date:   Tue, 14 Jun 2022 10:45:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH resend] imsm: Remove possibility for get_imsm_dev to
 return NULL
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20220613100009.19219-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220613100009.19219-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/13/22 06:00, Mateusz Grzonka wrote:
> Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
> Guarantee that it never happens.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  super-intel.c | 153 +++++++++++++++++++++++++-------------------------
>  1 file changed, 78 insertions(+), 75 deletions(-)

Applied!

Thanks,
Jes

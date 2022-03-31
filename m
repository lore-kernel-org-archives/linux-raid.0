Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94494C433F5
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 15:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236313AbiCaPoU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 11:44:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239958AbiCaPna (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 11:43:30 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069831D192D
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 08:38:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1648741134; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=knbDCX7IzGqI+h32qD8D8Q1y+v3Q6yfia5lh6G8T6IxV9PytZ5cgkqCZAcVRQTgFLOIdtzqY/dQIv/1AGUfEUrxxb2Jba2K/XFk7dW+qQfOMXKVG+AAZC+D1hlOfk7JAk2NlSBoq1ibzT7lt/9m6EV64btagmAawWJjdCZuWfZA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1648741134; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3/L3jcqN7iPSBTFNtPM3RTBUPj/3xZ25Gxxc0Fr3wP4=; 
        b=T3Jms3+sVXTF0fZE10ZHfD5O3/lSRB3ngN1Jz75IQ50qfwxt5A5feB54AVx21pHRmH+iUQ/GphNWWCg/TwK3OyibKG7IS9sBI8NuiFtX1NPHEFNuWbbgx0S2/0tpd/TWIxDFl4+FlhA1eSZY5so9qTqwnSNhP6cvkwFQdrfkAXM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1648741133416353.14519121880187; Thu, 31 Mar 2022 17:38:53 +0200 (CEST)
Message-ID: <d2dd311b-9ad0-1241-f360-28a407836953@trained-monkey.org>
Date:   Thu, 31 Mar 2022 11:38:50 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] Grow_reshape: Add r0 grow size error message and update
 man
Content-Language: en-US
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220323140519.1151-1-mateusz.kusiak@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220323140519.1151-1-mateusz.kusiak@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/22 10:05, Mateusz Kusiak wrote:
> Grow size on r0 is not supported for imsm and native metadata.
> Add proper error message.
> Update man for proper use of --size.
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
>  Grow.c     |  6 ++++++
>  mdadm.8.in | 19 ++++++++++++-------
>  2 files changed, 18 insertions(+), 7 deletions(-)
> 

Applied

Thanks,
Jes



Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 937BFC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 15:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbiCaPoY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 11:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239458AbiCaPnA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 11:43:00 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799CB1C34AD
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 08:37:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1648741037; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=CepVjML+b/xr3K9au0eLIm/rK5BEr4SJRFf3jcFElkAn7LtNM9Frinp7qlNl+ojWCtWtjdOwfl7kbBqRmApErPlt8hTVJfhQX8P/KeC2Fa3UpTshNSHEBwT3DJ5iRg6rERjWSlz+xKrarBRul1untPmVJjkD6nStEQJUHaRl/60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1648741037; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=AAA/U89s1ThlKPeGJJCjITUx5vaTtVUSNk6dHXGxW6c=; 
        b=Z8zRTXVZe0Jfb3pfLotbXtTwocE1GPDnRcwsxLjts3XpMDxurTrRN2Qm2n+wObcc5L1iUXbTC1H95rPfovzwlCHL+X8H7ERzMr5RSWYu7kKNZqjnajn/qTl9zDSz8ZW15aOLMuYG5vPhH9uXmRB0S6fEfq4FmDj+gNIivkADxP0=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1648741037093734.4355676151259; Thu, 31 Mar 2022 17:37:17 +0200 (CEST)
Message-ID: <788262f0-1f6b-e21b-bf29-ed80a92d34af@trained-monkey.org>
Date:   Thu, 31 Mar 2022 11:37:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] mdadm: Fix double free
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220325114859.525589-1-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220325114859.525589-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/25/22 07:48, Lukasz Florczak wrote:
> If there was a size mismatch after creation it would get fixed on grow
> in imsm_fix_size_mismatch(), but due to double free "double free or corruption (fasttop)"
> error occurs and grow cannot proceed.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>  super-intel.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Applied,

Thanks,
Jes


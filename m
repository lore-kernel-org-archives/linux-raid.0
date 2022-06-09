Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5771FC43334
	for <linux-raid@archiver.kernel.org>; Thu,  9 Jun 2022 22:26:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbiFIW0I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Jun 2022 18:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237063AbiFIW0H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Jun 2022 18:26:07 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B16602E4373
        for <linux-raid@vger.kernel.org>; Thu,  9 Jun 2022 15:26:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1654812604; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=g5M7LsdCVYMKFzf9DDeYj7xrK4EP+aVdn2/JWINTp5Jj4gTxeeOhnGTCrrgoXkC0TTKcAwFMTzPW49LMA6JvWu+K75UxqK/+jM2P8IFXlioF2lt+SZlL10yrzQZS6ORadiv0gEAHiShBfC804nHBe9RlgQPpqfitOrXmr4ZKYr8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1654812604; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=hHYzfkXzvFn15j78ngmRoH1YOamJX+vl/LzYumYL0EM=; 
        b=gd4DG51mCkP6HO4imcsoDCNrqFkUNBM9Iq4grS15vB+2/xsx2B8+C3lTEw65JYHRLazSYPJRWCNWbvLmZrFib1u4esFuTsA54YilcW3P/xaa/i+giEhEQ7Y0GO5KA2xHedcpHiRHesi+F8wQZOHycEMHquBe7WCl5JaJkW8jbK4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [172.30.27.237] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1654812601404139.32174689914189; Fri, 10 Jun 2022 00:10:01 +0200 (CEST)
Message-ID: <14c7f83a-bfef-b73e-9d71-0708f6e68985@trained-monkey.org>
Date:   Thu, 9 Jun 2022 18:08:51 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] mdmon: Stop parsing duplicate options
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>,
        linux-raid@vger.kernel.org
Cc:     colyli@suse.de, Song Liu <songliubraving@fb.com>
References: <20220513071942.27850-1-lukasz.florczak@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220513071942.27850-1-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/13/22 03:19, Lukasz Florczak wrote:
> Introduce new function is_duplicate_opt() to check if given option
> was already used and prevent setting it again along with an error
> message.
> 
> Move parsing above in_initrd() check to be able to detect --offroot
> option duplicates.
> 
> Now help option is executed after parsing to prevent executing commands
> like: 'mdmon --help --ndlksnlksajndfjksndafasj'.
> 
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>  mdmon.c | 44 +++++++++++++++++++++++++++++++++++---------

Applied!

First guineapig patch for the patchworks Song setup (thanks!)

Thanks,
Jes


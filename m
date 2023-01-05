Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB21C54EBC
	for <linux-raid@archiver.kernel.org>; Thu,  5 Jan 2023 03:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjAEDjj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Jan 2023 22:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjAEDjG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 4 Jan 2023 22:39:06 -0500
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF9604435D
        for <linux-raid@vger.kernel.org>; Wed,  4 Jan 2023 19:39:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1672889935; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=YI3VdA26uv81WdNzusm3tHExPF6erLyh6tytubJewjKX6ShFJeKh8rT3w8sciDtJmPcFZp+2C6Ra6PYzRnQ3JoSHxIJMmXma+ss3WxyeC+mZvUhrDjrka5AsyMYgSjk8fLWxAq7BGG+hlDrySwQQMFI44O5IJKuWVShSZLUI+ik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1672889935; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=wZXsns39eI3FNN3VuoGd+DNO0fvGiI2eEtrNDFoWgCM=; 
        b=Y3jkFz+VyhwsX2SH1XB51SAdUD0sSu0DVnEi92SaxDU1pohHofPpp1j4rfzkI40aV3V1Ou3VUuglHLKlzNWKpIoAyBAEvOVln2eQkRRgoDydgeeWHidz5NH4Y5IlvdLru68q7J9EJwh7GUbC5YsN8ZZD0K91y8eO4/KclPKdWGk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1672889933224569.2849081697298; Thu, 5 Jan 2023 04:38:53 +0100 (CET)
Message-ID: <f4d3ac0f-a565-4314-0f94-757830179ec9@trained-monkey.org>
Date:   Wed, 4 Jan 2023 22:38:50 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 0/3] Incremental mode: remove safety verification
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de, xni@redhat.com
References: <20221227055044.18168-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20221227055044.18168-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/27/22 00:50, Kinga Tanska wrote:
> Changes in incremental mode. Removing verification
> if remove is safe, when this mode is triggered. Also
> moving commit description to obey kernel coding style.
> 
> Kinga Tanska (3):
>   Manage: do not check array state when drive is removed
>   incremental, manage: do not verify if remove is safe
>   manage: move comment with function description
> 
>  Incremental.c |  2 +-
>  Manage.c      | 82 ++++++++++++++++++++++++++++++---------------------
>  2 files changed, 50 insertions(+), 34 deletions(-)
> 

Applied 1+2, 3 fails to apply for me.

Thanks,
Jes


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322B9C56202
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CAA3D207BC
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:21:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbgKYXVN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:21:13 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17392 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729779AbgKYXVN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:21:13 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606346468; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=IBLfsThHMHa5XqxOheCaSKbf4rnWgsdEmtF9Orb66ownXFPqtO0+cJXE3U66ZDGHrARmAqJrY5tzsJpQXEGP13+X82Ek5RPYFyAY+g6mPKQSdqp5ousIGE5qgsF12LVdxMDvz0SUvKwppIn/Xkc5p4lU9Wva9qLa5yeh6wTkyc4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606346468; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=gOi5XnX1Nfb3xcsg9KPUzQgU1UEywH3q53e5aHynCkI=; 
        b=G7b4rSp0254DH3qaTLGwxQZbl1syxHTiTogCwUQdib8jgojhiZ27PZaUPxp6bUv6Cel8dR9aSLW4T00+EcXc9aQVPbhOtvesQ6FXCHhHjI+RyFfj/TtNuHsJiMsFj1aHr6hJZ7gQa1zDCyEqrALo8vdwKNUU1jg6iZ7764gmcrM=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606346467864561.4078768885906; Thu, 26 Nov 2020 00:21:07 +0100 (CET)
Subject: Re: [PATCH,v2] Make target to install binaries only
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     jes.sorensen@gmail.com
References: <20201022122229.31443-1-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <47d81209-6c04-8633-2aca-47b7976cbeb3@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:21:06 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201022122229.31443-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/22/20 8:22 AM, Kinga Tanska wrote:
> Make install causes installation of binaries, udev and man.
> This commit contains new target make install-bin, which
> results in installation of binaries only.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Makefile | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 

Applied!

Thanks,
Jes


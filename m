Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6F5C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 24 Nov 2021 12:09:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242251AbhKXMMe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Nov 2021 07:12:34 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17293 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242284AbhKXMJs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Nov 2021 07:09:48 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1637755596; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=D+XogClqbXnYWVNeSCjFkk7UpsHx6qNIDNeBuTRplH9I6DkbsluSRSxn1LTn/SaZBeAUsqH+FVZYDS4Vm1uawtx5u3ahOnqYHSENJOSU493IgA97FFJQ/l25+i2X/U7xKSyZbFwprmZibEIXn6vf/H2O4k+BmiYiJ2PUCGDXJwM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1637755596; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=cxreUS312dOwz6LSNxB1hzl0TZBNMvI7W5/19y1+JZ0=; 
        b=jY2ICgoTN+OWzVp6M3zZ9OdLCNd5dIFjD4y0SEUzrp+iAqjiTCAhG/5CKi+rXvDc0W1b1p37e+LzSuZpK9o3pxybxTbjtCOHtD4kQ7yPwp9cpHloVbIrpww32w9811jJTgcyDxQyHyPBd9v0TpL7o6EsKmWfHqiU38QfBQZQFts=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1637755593421625.292480405046; Wed, 24 Nov 2021 13:06:33 +0100 (CET)
Subject: Re: [PATCH] Incremental: Close unclosed mdfd in IncrementalScan()
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20211124104530.26592-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <934f4f9e-bc53-2cca-26bd-bb1e8ac1a42b@trained-monkey.org>
Date:   Wed, 24 Nov 2021 07:06:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20211124104530.26592-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/24/21 5:45 AM, Mateusz Grzonka wrote:
> In addition to closing mdfd, propagate helpers to manage file
> descriptors across IncrementalScan().
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
>  Incremental.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)

Applied,

Thanks,
Jes



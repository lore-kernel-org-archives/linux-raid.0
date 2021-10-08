Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA44DC433FE
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D213660F43
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 10:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhJHKdl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 06:33:41 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17220 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240111AbhJHKdk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 8 Oct 2021 06:33:40 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1633689096; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=VtmdhN66aGyLRfmI3B5udG6YS1u/kS0rM6do4vNDlUmjjbMlA2tlfjh5jco0XtMReKva9NLliuzqqWrALOOj615ZEnHLUKK+JNeVnQ+UpjPgwkQPnnaly9755WgUP0src8nQvcMgGQIpktwzCSJO0DHQhMTiRNSGQ2RcWqTipug=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1633689096; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3dh9RGTxjktTswgIvBNVuN1avFQgp0s81WnMRtVJrX4=; 
        b=YxsWm6yjmUs2XvHJVjYaUm8JTU8FoFpbVVJ3gl8JCWcXfJnFZnOeJBoDg0A/eLLthF48IZ6RaK2bdQhTMWxz1LGswyLga4XFBD/uW37zdKDFwMXyOdh5RZxnTJ0rahE4ry9u0B3dhe5etT3Li8bIU52SLseNzdxJd0S9FsCcqVs=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [100.110.16.7] (163.114.131.1 [163.114.131.1]) by mx.zoho.eu
        with SMTPS id 1633689008790330.87511984140883; Fri, 8 Oct 2021 12:30:08 +0200 (CEST)
Subject: Re: [PATCH] Fix error message when creating raid 4, 5 and 10
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>,
        linux-raid@vger.kernel.org
References: <20210830082517.9109-1-mateusz.grzonka@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <27f0d847-5617-c436-4900-f4bfbcb301f6@trained-monkey.org>
Date:   Fri, 8 Oct 2021 06:30:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210830082517.9109-1-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/30/21 4:25 AM, Mateusz Grzonka wrote:
> Change inappropriate error message "at least 2 raid-devices needed for
> level 4 or 5" to only mention relevant raid level.
> 
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Looks good, applied!

Thanks,
Jes


> ---
>  Create.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Create.c b/Create.c
> index f5d57f8c..2c0b17e9 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -153,7 +153,7 @@ int Create(struct supertype *st, char *mddev,
>  		return 1;
>  	}
>  	if (s->raiddisks < 2 && s->level >= 4) {
> -		pr_err("at least 2 raid-devices needed for level 4 or 5\n");
> +		pr_err("at least 2 raid-devices needed for level %d\n", s->level);
>  		return 1;
>  	}
>  	if (s->level <= 0 && s->sparedisks) {
> 


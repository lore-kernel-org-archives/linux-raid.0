Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8F9C00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:01:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238586AbiHXQB4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiHXQBw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:01:52 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06C5276461
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:01:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1661356903; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=AdXhXsK///wzlbiCbBqZF8EVSCe7nmcfxTktLjgelYqPRI695Y0Dxyb++6/OeK5Z3Tbqh9Lc0ZGPsesUlvvBxQBxHNcsgszO35C0T8jRNkqOI+rBpvrXJrOx9TFMKgcjUdPbp56q68gl2qT0DTtX7dliDicJ02gQac1T39SdLVk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1661356903; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BrlbkM6XLsdi/t6/8fzVuCfeKEfIioDeVpotgq/dalY=; 
        b=crqdM3MfqWWX2FMCwSGwghEF4nayhd0TMB3UfwyLrAEeUvA0Sv1aOCLHbaQFBm9JMYuPBQ1OBYR9+cTNgrQSa2VtSHThEYdtkJQFDXESUrD5mA+qKFl7Kg6TgFb0pqyKFZTZumvtElvcMwPR5akcYiy2QuJfOCCONVNR6nFkvbk=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.78] (pool-72-69-213-125.nycmny.fios.verizon.net [72.69.213.125]) by mx.zoho.eu
        with SMTPS id 166135690092230.54148524962568; Wed, 24 Aug 2022 18:01:40 +0200 (CEST)
Message-ID: <1145ae49-7bf9-d1fc-dc5f-012d540433cc@trained-monkey.org>
Date:   Wed, 24 Aug 2022 12:01:39 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/2] Assemble: check if device is container before
 scheduling force-clean update
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org
Cc:     colyli@suse.de
References: <20220819005547.17343-1-kinga.tanska@intel.com>
 <20220819005547.17343-2-kinga.tanska@intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20220819005547.17343-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/18/22 20:55, Kinga Tanska wrote:
> Up to now using assemble with force flag making each array as clean.
> Force-clean should not be done for the container. This commit add
> check if device is different than container before cleaning.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>  Assemble.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/Assemble.c b/Assemble.c
> index 704b8293..f31372db 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1813,10 +1813,9 @@ try_again:
>  		}
>  #endif
>  	}
> -	if (c->force && !clean &&
> +	if (c->force && !clean && content->array.level != LEVEL_CONTAINER &&
>  	    !enough(content->array.level, content->array.raid_disks,
> -		    content->array.layout, clean,
> -		    avail)) {
> +		    content->array.layout, clean, avail)) {
>  		change += st->ss->update_super(st, content, "force-array",
>  					       devices[chosen_drive].devname, c->verbose,
>  					       0, NULL);

Applied,

Thanks,
Jes


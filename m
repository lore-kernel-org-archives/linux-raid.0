Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B55C74A5B
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232429AbjCWQp5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231778AbjCWQpY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:45:24 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0EF5FD9
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:44:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679589865; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=kQu1SJPfUrUHiMaAi+EcdlL5KACF3GkxXhHWSBWHG45haNUWlLnr42ewdIHOCktE2qoUYWoGp/N/wHEGTpUkGLIPSPWy9PEU+zfNHOjBJflszkTvkC00NQIu2nzlBdsP1U0Od7dMUzdeQTp+VplIdP5LpH9JwbYJlBnod1+tKwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679589865; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=0lG2zttwKncyh21FHDaQqGHNK3uy+Ex1VfezoIGuNmY=; 
        b=P7Bg6DEvtQCmpzMs0upc6pk6lY1GjMfOJqUFNv8C7N9lIZHab1AX1IViD5dSVjD5S+X/Hf08CDiDGpFijZyaCh6bcijAZwnQZkhuY1xC6Nx0zPuobiK9jgxrcNf3qj8uM4v+e6chNSQt6cIYCps/B5YlGEsg2vHj/WHyKW1GxOY=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679589863833170.9146010704875; Thu, 23 Mar 2023 17:44:23 +0100 (CET)
Message-ID: <def99610-2b46-a434-6ef0-f1df7fd42f6b@trained-monkey.org>
Date:   Thu, 23 Mar 2023 12:44:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] Revert "Revert "mdadm/systemd: remove KillMode=none from
 service file""
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, colyli@suse.de
References: <20230323161318.25564-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <20230323161318.25564-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/23 12:13, Mariusz Tkaczyk wrote:
> This reverts commit 28a083955c6f58f8e582734c8c82aff909a7d461.
> 
> Resolved by commit 723d1df4946e ("mdmon: Improve switchroot
> interactions.") We are ready to drop it.
> 
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  systemd/mdadm-grow-continue@.service | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-continue@.service
> index 9ccadca3..64b8254a 100644
> --- a/systemd/mdadm-grow-continue@.service
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -15,4 +15,3 @@ ExecStart=BINDIR/mdadm --grow --continue /dev/%I
>  StandardInput=null
>  StandardOutput=null
>  StandardError=null
> -KillMode=none

Applied!

Thanks,
Jes


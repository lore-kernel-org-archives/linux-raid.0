Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B40C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 10:44:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80766610C9
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 10:44:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhJMKqg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:46:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:61286 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229461AbhJMKqf (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 06:46:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10135"; a="227294259"
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="227294259"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Oct 2021 03:44:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,370,1624345200"; 
   d="scan'208";a="592127994"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 13 Oct 2021 03:44:32 -0700
Received: from [10.249.145.103] (mtkaczyk-MOBL1.ger.corp.intel.com [10.249.145.103])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by linux.intel.com (Postfix) with ESMTPS id 3E3665808DC;
        Wed, 13 Oct 2021 03:44:31 -0700 (PDT)
Subject: Re: [PATCH] mdadm.8: Copy --no-degraded clarification from --help
 output
To:     Vladimir Panteleev <git@cy.md>, linux-raid@vger.kernel.org,
        NeilBrown <neilb@suse.de>, Jes Sorensen <jes@trained-monkey.org>
References: <20210929082113.1486453-1-git@cy.md>
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@linux.intel.com>
Message-ID: <ca7c1718-9663-8272-289e-3a0d35643a98@linux.intel.com>
Date:   Wed, 13 Oct 2021 12:44:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929082113.1486453-1-git@cy.md>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 29.09.2021 10:21, Vladimir Panteleev wrote:
> Make it easier to discover this POLA violation.
> ---
>   mdadm.8.in | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 96846035..74cca534 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1159,6 +1159,12 @@ are present.  This is only needed with
>   and can be used if the physical connections to devices are
>   not as reliable as you would like.
>   
> +Note that "all expected drives" means as many as were present the last
> +time the array was running as recorded in the superblock.  If the
> +array was already degraded, and the missing device is not a new
> +problem, it will still be assembled.  It is only newly missing devices
> +that cause the array not to be started.
> +
>   .TP
>   .BR \-a ", " "\-\-auto{=no,yes,md,mdp,part}"
>   See this option under Create and Build options.
> 

I think that it is not necessary anymore. This is default behavior,
at least for IMSM/external.
If we are using assemble with --scan then it is probably done
manually. Do we should care about unstable connections?

Normally, udev calls mdadm -I on each drive.
There is also a timer which calls #mdadm -R on array
after timeout.

I would consider to drop --no-degraded support and adapt
assemble behavior if is different.
Neil, Jes could you look?

Thanks,
Mariusz



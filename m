Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF4AC6FD1F
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 16:30:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCSQak (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjCSQaj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 12:30:39 -0400
Received: from sender11-op-o11.zoho.eu (sender11-op-o11.zoho.eu [31.186.226.225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3351CAF4
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 09:30:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679243420; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=knhdhHjLmuLuj+P6YQGo+7G9rS5quFob82kMRCPM5QpSpPQcvuJhuj0e6kiLoRax3mmZjEhm+IqESdaCf/DydU16rDFgxXlzz4HaTkVxdstKUt5GEBbEavVh2s1i7vsMXzbmG15MRQU+kPCB2CgjgYqJuN7coo+52cRmJGTJjWk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1679243420; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=BtxZsfloHH8owxjgWzRjhg7xEHX2UMNwaRq4R8hNlZA=; 
        b=VJKk1UyolT3wHQxjzOh5S2KcV7b+KJ+P/Xt9PhkVdJySRW3bvjM6bVfb9677qhW6FtihD4HIZzFiSlUMpN0FLBdY/Eacadeg24DQPsvWPRZgb+C+iI7oIvWFuEO8Dw4aKf1NIHWbpOOokSXprdbwIa4Bi+cWHx9vsMsLIJA/mZ4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.50] (pool-98-113-67-206.nycmny.fios.verizon.net [98.113.67.206]) by mx.zoho.eu
        with SMTPS id 1679243418975312.1068690032919; Sun, 19 Mar 2023 17:30:18 +0100 (CET)
Message-ID: <e2256aca-b2a1-344c-8dc4-f00d849530eb@trained-monkey.org>
Date:   Sun, 19 Mar 2023 12:30:17 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/6] Improvements for IMSM_NO_PLATFORM testing.
Content-Language: en-US
To:     NeilBrown <neilb@suse.de>
Cc:     linux-raid@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
 <167867897868.11443.7240557073570592164.stgit@noble.brown>
From:   Jes Sorensen <jes@trained-monkey.org>
In-Reply-To: <167867897868.11443.7240557073570592164.stgit@noble.brown>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/12/23 23:42, NeilBrown wrote:
> Factor out IMSM_NO_PLATFORM testing into a single function that caches
> the result.
> 
> Allow mdmon to explicitly set the result to "1" so that we don't need
> the ENV var in the unit file
> 
> Check if the kernel command line contains "mdadm.imsm.test=1" and in
> that case assert NO_PLATFORM.  This simplifies testing in a virtual
> machine.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  mdadm.h                |    2 ++
>  mdmon.c                |    6 ++++++
>  super-intel.c          |   43 ++++++++++++++++++++++++++++++++++++++++---
>  systemd/mdmon@.service |    3 ---
>  4 files changed, 48 insertions(+), 6 deletions(-)

Hi Neil

> diff --git a/super-intel.c b/super-intel.c
> index e155a8ae99cb..a514dea6f95c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -629,6 +629,43 @@ static const char *_sys_dev_type[] = {
>  	[SYS_DEV_VMD] = "VMD"
>  };
>  
> +static int no_platform = -1;
> +
> +static int check_no_platform(void)
> +{
> +	static const char search[] = "mdadm.imsm.test=1";
> +	int fd;
> +	char buf[1024];

This isn't safe, /proc/cmdline can be longer than 1024 characters.

Cheers,
Jes


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA84AC433DB
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DB8E64F17
	for <linux-raid@archiver.kernel.org>; Fri, 26 Feb 2021 22:07:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhBZWHc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 Feb 2021 17:07:32 -0500
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17270 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbhBZWHb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 Feb 2021 17:07:31 -0500
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Feb 2021 17:07:30 EST
ARC-Seal: i=1; a=rsa-sha256; t=1614377200; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=e3eWGLGB0clGmJTW3ciQtXmJYCohEJ6J6csLlEwTJ2z27GidzmZplMXWJ4kDMywm225lIDEjcXVFxiv74wdnfZZUPMyRExM35UFRwTWO9IPIz6bGfa+WcgNRcmZLW4H30crVQUJsZ1hOTSsDyRbzDTbHhcco6UPDMgg4tNJCYw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1614377200; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=oXayfNXKbvBCcTk4MI6qulfBzDCFNfi7Bx98oHAQF3s=; 
        b=bhGwMh8qwgM2Chld4XlBLUalJdNGb+lZhXRZH6yKPF4SY3pea78eNstVfFpEQujrEW+v/cFbgTc9T6JyHTiWLQY7vrLPD2vEE2248oy1+thM5HouImdl+vzBfDauMOX4JdZsXF5gvNyjg2UMGCZL4GpW2Y6IQm+8HZzxU70eFDg=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1614377197991635.2130189466387; Fri, 26 Feb 2021 23:06:37 +0100 (CET)
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
To:     Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org,
        xni@redhat.com
References: <20210120200542.19139-1-ncroxon@redhat.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <84ed6e32-3b69-f13d-b1b8-33166c92e5ab@trained-monkey.org>
Date:   Fri, 26 Feb 2021 17:06:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210120200542.19139-1-ncroxon@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/20/21 3:05 PM, Nigel Croxon wrote:
> Reshaping a 3-disk RAID5 to 4-disk RAID6 will cause a hang of
> the resync after the grow.
> 
> Adding a spare disk to avoid degrading the array when growing
> is successful, but not successful when supplying a backup file
> on the command line. If the reshape job is not already running,
> set the sync_max value to max.
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Grow.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)

Applied!

Thanks,
Jes


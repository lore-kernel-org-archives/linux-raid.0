Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67526C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 21:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CAB060EB2
	for <linux-raid@archiver.kernel.org>; Tue, 27 Jul 2021 21:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhG0VgY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 27 Jul 2021 17:36:24 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17090 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhG0VgX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 27 Jul 2021 17:36:23 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1627421762; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=Wd1QgoJCPqqFFbl536vxNCj19N9fqDfdr+folU2+phfwFzc9ZbBYoVZTpkRKNaB/DvgvGlagv4/+ibhV6VCOiX+RqoCRsmlS/pwApvpn/j6TX/qmLJmWISJz//AV0l1onFkILpEMvN0WgFOwCegaU1VzK0Afq5c7sGI3Fi3XHec=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1627421762; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=MDFvUx32macIWfbWGRJTmvLsfH9taFNPoQX4+/GVVks=; 
        b=jf7CK589TzqM6KDFShl4dRTn3zhwGgcUHzevjADbU/tXvxNZB6oaMpRK6phcm2fTcXgmKB6ftjwcWbHekfIcajRSrq0hOWpRMGMYOX4mkGmrG8plD/Mx3z8ILieWxFgW1idgjuQ4ftwpRlUBueG4ffRibfxxDc3fBQmgnmcr/lU=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org>
Received: from [192.168.99.29] (pool-72-69-75-15.nycmny.fios.verizon.net [72.69.75.15]) by mx.zoho.eu
        with SMTPS id 1627421761762143.15875250385363; Tue, 27 Jul 2021 23:36:01 +0200 (CEST)
Subject: Re: [PATCH] Assemble: start dirty and degraded array.
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org, devon@sigmalabsinc.com
References: <20210721154754.31872-1-mariusz.tkaczyk@linux.intel.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <a08029cf-6e87-995e-cb6c-37169f1c4bd5@trained-monkey.org>
Date:   Tue, 27 Jul 2021 17:36:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210721154754.31872-1-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/21/21 11:47 AM, Mariusz Tkaczyk wrote:
> The case when array is already degraded has been omitted
> by commit 7b99edab2834 ("Assemble.c: respect force flag.").
> Appropriative support has been added now.
> 
> Handlers for "run" and "force" have been divided into independent
> routines. Especially force has to be as meaningless as possible.
> It respects following rules:
>     - user agrees to start array as degraded (by --run) or is already
>       degraded
>     - raid456 module is in use
>     - some drives are missing (to limit potential abuses)
> 
> It doesn't allow to skip resync on dirty, but not degraded array.
> 
> This patch cleans up message generation for external array and makes it
> consistent. Following code could be reused also for native.
> 
> In current implementation assemble_container_content is called once, in
> both Incremental or Assembly mode. Thus makes that partial assembly is
> not likely to happen. It is possible, but requires user input.
> Partial assembly during reshape fails (sysfs_set_array
> error - not yet investigated). For now I put FIXME to mark current
> logic as known to be buggy because preexist_cnt contains both exp_cnt
> and new_cnt which may produce an incorrect message.
> 
> Check for new disks and runstop is unnecessary, so has been removed.
> This allows to print assemble status in every case, even if nothing new
> happens.
> 
> Reported-by: Devon Beets <devon@sigmalabsinc.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>  Assemble.c    | 176 +++++++++++++++++++++++++++++---------------------
>  mdadm.8.in    |   3 +-
>  super-intel.c |   4 --
>  3 files changed, 103 insertions(+), 80 deletions(-)
> 

Applied!

Thanks,
Jes


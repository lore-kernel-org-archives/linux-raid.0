Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B32FC7EE23
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jun 2023 11:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239632AbjFGLGb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Jun 2023 07:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbjFGLG2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Jun 2023 07:06:28 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DF71723
        for <linux-raid@vger.kernel.org>; Wed,  7 Jun 2023 04:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686135962; x=1717671962;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hO1aXeMk7cws8o4d48krLtS1NBA50qsQREqhoqFDqxY=;
  b=Rf4Q5oDlaYLfa6hnYFdC5nxxqfXyzWdbic8k9Vudfi3nMC2D4kFSWLJo
   6eXWoEeGLHwMgioRekbfyns3Lecg1Jlg7K0GNCSuz0iEPc4JGAyOTYmqE
   KtZsbaySfTZY5Evb5wCjLvHUmx8GJiGH2ZnGAkniUlBcoF7vBowmFQKWp
   omzNBwchCIAV4WNOSvfouLoBs36aMgdGAXcRokxASjUBGR1gya+Z7nq60
   pGoNH7UgA6J2j5EIeZd9UGPsKivNRSRgC071lKKNKMLzif675x9AEgwkU
   TRXCCdko2tZa7RmVdYiQI80yaj4yjUAQZkOF/70HpcTopWiyfghCQaAt+
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="420512384"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="420512384"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:05:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10733"; a="703593260"
X-IronPort-AV: E=Sophos;i="6.00,223,1681196400"; 
   d="scan'208";a="703593260"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.158.35])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 04:05:04 -0700
Date:   Wed, 7 Jun 2023 13:05:00 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     <jes@trained-monkey.org>, <pmenzel@molgen.mpg.de>,
        <linux-raid@vger.kernel.org>, <linfeilong@huawei.com>,
        <lixiaokeng@huawei.com>, <louhongxiang@huawei.com>
Subject: Re: [PATCH] Fix mdmonitor-oneshot.service fail to be executed
Message-ID: <20230607130500.00004df6@linux.intel.com>
In-Reply-To: <20230607065734.2722921-1-miaoguanqin@huawei.com>
References: <20230607065734.2722921-1-miaoguanqin@huawei.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 7 Jun 2023 14:57:34 +0800
Guanqin Miao <miaoguanqin@huawei.com> wrote:

> When we start mdmonitor-oneshot.service, we found an fail 
> for mdmonitor-oneshot.service:
> 
> mdadm: No mail address or alert command - not monitoring
> 
> According to the error information, We modified the Environment 
> field and added the syslog parameter.The service can be 
> executed successfully.
> ---
Hi Guanqin,

I'm against this approach because systemd service should contains
parameters specifies systemd wide mode only, like "--scan".

It globally enables syslog logging for --oneshoot. I know that
it is not configurable right now and nobody is asking but I believe that user
will prefer to have possibility to enable/disable it, not to have it always
enabled.

If you want add the syslog logging then it should be configurable via config
like MAILADDR is e.g.

SYSLOG = yes

Please also consider that we have two services: mdmonitor and mdmonitor-oneshoot
and logging for them should be configured separately, so I think it is better to
give two options: SYSLOG, SYSYLOG_ONESHOT.

But the question is, if you want the syslog logging or just to make the service
working by default.

If service is not working by default it means that your package provider does
not provide default configuration to run that. It depends on them. We are
providing a solution which may need to be additionally configured.
There is not requirement saying "service must work by default" so I do not
consider it as a bug. Please correct me if you think that I'm wrong here.

Thanks,
Mariusz

>  systemd/mdmonitor-oneshot.service | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/systemd/mdmonitor-oneshot.service
> b/systemd/mdmonitor-oneshot.service index ba86b44e..032b8aad 100644
> --- a/systemd/mdmonitor-oneshot.service
> +++ b/systemd/mdmonitor-oneshot.service
> @@ -10,7 +10,7 @@ Description=Reminder for degraded MD arrays
>  Documentation=man:mdadm(8)
>  
>  [Service]
> -Environment=MDADM_MONITOR_ARGS=--scan
> +Environment=MDADM_MONITOR_ARGS="--scan --syslog"
>  EnvironmentFile=-/run/sysconfig/mdadm
>  ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
>  ExecStart=BINDIR/mdadm --monitor --oneshot $MDADM_MONITOR_ARGS


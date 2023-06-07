Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1671FC7EE23
	for <linux-raid@archiver.kernel.org>; Wed,  7 Jun 2023 07:59:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237911AbjFGH7j (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Jun 2023 03:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbjFGH7i (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Jun 2023 03:59:38 -0400
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F465184
        for <linux-raid@vger.kernel.org>; Wed,  7 Jun 2023 00:59:34 -0700 (PDT)
Received: from [141.14.220.45] (g45.guest.molgen.mpg.de [141.14.220.45])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 7313F61DFA90A;
        Wed,  7 Jun 2023 09:58:44 +0200 (CEST)
Message-ID: <71cf934d-a16c-f7fc-d3a0-19d26243b112@molgen.mpg.de>
Date:   Wed, 7 Jun 2023 09:58:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] Fix mdmonitor-oneshot.service fail to be executed
Content-Language: en-US
To:     Guanqin Miao <miaoguanqin@huawei.com>
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        linux-raid@vger.kernel.org, linfeilong@huawei.com,
        lixiaokeng@huawei.com, louhongxiang@huawei.com
References: <20230607065734.2722921-1-miaoguanqin@huawei.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20230607065734.2722921-1-miaoguanqin@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Guanqin,


Thank you very much for your patch.

Am 07.06.23 um 08:57 schrieb Guanqin Miao:

For the commit message summary/title I’d suggest:

mdmonitor-oneshot.service: Pass `--syslog` to fix start failure

> When we start mdmonitor-oneshot.service, we found an fail

a fail

> for mdmonitor-oneshot.service:

Maybe even:

mdmonitor-oneshot.service fails with the error below:

> mdadm: No mail address or alert command - not monitoring
> 
> According to the error information, We modified the Environment

s/We/we/

> field and added the syslog parameter.The service can be

s/added/add/
Please add a space after the dot/period.

> executed successfully.

Maybe:

Pass the switch `--syslog`, so alerts are reported to syslog and not by 
email or an alert program.

> ---
>   systemd/mdmonitor-oneshot.service | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/systemd/mdmonitor-oneshot.service b/systemd/mdmonitor-oneshot.service
> index ba86b44e..032b8aad 100644
> --- a/systemd/mdmonitor-oneshot.service
> +++ b/systemd/mdmonitor-oneshot.service
> @@ -10,7 +10,7 @@ Description=Reminder for degraded MD arrays
>   Documentation=man:mdadm(8)
>   
>   [Service]
> -Environment=MDADM_MONITOR_ARGS=--scan
> +Environment=MDADM_MONITOR_ARGS="--scan --syslog"

Isn’t it more idiomatic for systemd to capture standard out and standard 
error directly? Adding `--syslog` here would add an unwanted redirection?

>   EnvironmentFile=-/run/sysconfig/mdadm
>   ExecStartPre=-/usr/lib/mdadm/mdadm_env.sh
>   ExecStart=BINDIR/mdadm --monitor --oneshot $MDADM_MONITOR_ARGS

Could mdadm be fixed to allow to be started without email or alert program?


Kind regards,

Paul

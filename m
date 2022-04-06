Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE8CC43217
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 17:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239247AbiDFRi0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbiDFRhl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 13:37:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB6D6E57D
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 09:32:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 72CA121122;
        Wed,  6 Apr 2022 16:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649262768; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZJSRkj7tlbSNjzF6FLqxsiK62xi9qvJDv/1/ccW71s=;
        b=ErAlS+D2rFwm/GEVoQ0rW00+GErarhBV9gRXTbBa09LnPhyKl5brYq7PhjAOFqBk3sDf6R
        M7Z0WmLtT4w19+f0cfAiPrX1Zwi20tuhGB4aEFtdXVkcZhnknRwAUmROPYJWjeHhKbrl8T
        gVpsQ6Mrw/X0zgsVkoe2xXGz6XKB2kY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649262768;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gZJSRkj7tlbSNjzF6FLqxsiK62xi9qvJDv/1/ccW71s=;
        b=3RGXgRjKJz9w5FEHKxcCSWMJlKWOuKF/FEJKnYVPm9RAcec7LXmAZZIoKOy84dH9UPGpum
        9sHZY7kfE8ES31Bg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id DED76139F5;
        Wed,  6 Apr 2022 16:32:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JLOtC67ATWLJVgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Apr 2022 16:32:46 +0000
Message-ID: <ae20a79a-a7f3-c124-b67e-a36e767164e2@suse.de>
Date:   Thu, 7 Apr 2022 00:32:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 2/2] Mdmonitor: Improve logging method
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220405114057.27080-1-kinga.tanska@intel.com>
 <20220405114057.27080-3-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220405114057.27080-3-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/5/22 7:40 PM, Kinga Tanska wrote:
> Change logging, and as a result, mdmonitor in verbose
> mode will report its configuration.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>


Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


> ---
>   Monitor.c | 25 ++++++++++++++-----------
>   1 file changed, 14 insertions(+), 11 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 0b24b656..bd417d04 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -137,24 +137,27 @@ int Monitor(struct mddev_dev *devlist,
>   	struct mddev_ident *mdlist;
>   	int delay_for_event = c->delay;
>   
> -	if (!mailaddr) {
> +	if (!mailaddr)
>   		mailaddr = conf_get_mailaddr();
> -		if (mailaddr && ! c->scan)
> -			pr_err("Monitor using email address \"%s\" from config file\n",
> -			       mailaddr);
> -	}
> -	mailfrom = conf_get_mailfrom();
>   
> -	if (!alert_cmd) {
> +	if (!alert_cmd)
>   		alert_cmd = conf_get_program();
> -		if (alert_cmd && !c->scan)
> -			pr_err("Monitor using program \"%s\" from config file\n",
> -			       alert_cmd);
> -	}
> +
> +	mailfrom = conf_get_mailfrom();
> +
>   	if (c->scan && !mailaddr && !alert_cmd && !dosyslog) {
>   		pr_err("No mail address or alert command - not monitoring.\n");
>   		return 1;
>   	}
> +
> +	if (c->verbose) {
> +		pr_err("Monitor is started with delay %ds\n", c->delay);
> +		if (mailaddr)
> +			pr_err("Monitor using email address %s\n", mailaddr);
> +		if (alert_cmd)
> +			pr_err("Monitor using program %s\n", alert_cmd);
> +	}
> +
>   	info.alert_cmd = alert_cmd;
>   	info.mailaddr = mailaddr;
>   	info.mailfrom = mailfrom;



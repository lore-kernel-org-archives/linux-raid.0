Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C510CC433EF
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 15:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357408AbiDBPsp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 11:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238235AbiDBPsm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 11:48:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670DE177D33
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 08:46:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id BDEDE21613;
        Sat,  2 Apr 2022 15:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648914407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IV9W4lBQjlhkcN5TcoV4WS0AUt7gGRqteTYaw8IlbE0=;
        b=L5t3dOYltDaVsorm0HgSkx87z+BYt2Kh5FPjsCVOFxe7iUMu3SczRMICjn3AYrnTrXRNTU
        gK7Y1QUMycnXuspdxOR6OX7tBz5C4Ybo8YiQSHn4yhtBHMkN/Avcc27feoyJstt5NYB4Q0
        eAHwmBOwk3Vku6zJJhktv7cfMGQaVjE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648914407;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IV9W4lBQjlhkcN5TcoV4WS0AUt7gGRqteTYaw8IlbE0=;
        b=wmrQd5bAB55F0ifwtYv4qzADbdKMz3QveaZRlSxX97iXQ0L9q76JN4nHQiEpAOVA1/LXnX
        0g9nnPrItPckmFAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E92213440;
        Sat,  2 Apr 2022 15:46:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id edKQMOVvSGJhOAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 15:46:45 +0000
Message-ID: <250bf65c-87e6-ba6d-18f3-fa1f89887c2d@suse.de>
Date:   Sat, 2 Apr 2022 23:46:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] Mdmonitor: Improve logging method
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     pmenzel@molgen.mpg.de, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
References: <20220323090744.26716-1-kinga.tanska@intel.com>
 <20220323090744.26716-3-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220323090744.26716-3-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/22 5:07 PM, Kinga Tanska wrote:
> Change logging, and as a result, mdmonitor in verbose
> mode will report its configuration.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
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

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li


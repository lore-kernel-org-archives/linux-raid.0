Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF1FC433F5
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 16:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240493AbiCSQnI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 12:43:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230453AbiCSQnH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 12:43:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9492498A0
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 09:41:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1AAFE21106;
        Sat, 19 Mar 2022 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647708105; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=679zUOW8dL4XtgLuTTm1vZzh5HL7Z4o1Uz+wv6AzscA=;
        b=lfwsGmPm8UWIPIyHdHUDjQ8m9hWGuBIAzlquVBP/loAG968dkzZm6KlmX4lp5r2jgPmfBa
        O7H05MTEwY38SlBxqJ9WtabVzZfCJ2Tl5Ig1G4qNNd/e0DOuevfB2dUmeddEBeUmWPvr3H
        bFghBZtRtwvNrGp7ajPCxtcZRzAqPhM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647708105;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=679zUOW8dL4XtgLuTTm1vZzh5HL7Z4o1Uz+wv6AzscA=;
        b=Sr+yVInu9xQ2aHa+iPs8dhPZTiU2anULeDnFN+5cN8UBZ+hR7FET2gr0U9WFFKYqqCH+Kd
        3dv5XyT5qu5KYNCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A2A98132C1;
        Sat, 19 Mar 2022 16:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id s95YKcYHNmL4IQAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 19 Mar 2022 16:41:42 +0000
Message-ID: <170ca288-b665-3bfa-d093-0443783126b7@suse.de>
Date:   Sun, 20 Mar 2022 00:41:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 2/2] Optimize signal setting in alert() function.
Content-Language: en-US
To:     Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220221120521.16846-1-lukasz.florczak@linux.intel.com>
 <20220221120521.16846-3-lukasz.florczak@linux.intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220221120521.16846-3-lukasz.florczak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 2/21/22 8:05 PM, Lukasz Florczak wrote:
> Moving signal setting in Monitor.c out of the alert() function
> makes it more clear as it was set to ignore SIGPIPE every time
> alert() was called, but was never set back to default again.
> Now SIGPIPE is ignored for whole duration of the program just once.
>
> Signed-off-by: Lukasz Florczak <lukasz.florczak@linux.intel.com>
> ---
>   Monitor.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 40388b64..222568cb 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -159,6 +159,9 @@ int Monitor(struct mddev_dev *devlist,
>   	info.mailfrom = mailfrom;
>   	info.dosyslog = dosyslog;
>   
> +	if (info.mailaddr)
> +		signal_s(SIGPIPE, SIG_IGN);
> +
>   	if (share){
>   		if (check_one_sharer(c->scan))
>   			return 1;
> @@ -436,8 +439,7 @@ static void alert(char *event, char *dev, char *disc, struct alert_info *info)
>   			char hname[256];
>   
>   			gethostname(hname, sizeof(hname));
> -			signal_s(SIGPIPE, SIG_IGN);


Hi Lukasz,


I suggest to void extending th SIGPIPE range out of alert(), maybe 
restore the old handler after pclose(mp)? Then we can keep minimized 
logic change.


Thanks.


Coly Li


>   			if (info->mailfrom)
>   				fprintf(mp, "From: %s\n", info->mailfrom);
>   			else



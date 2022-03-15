Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57E9C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 15 Mar 2022 09:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346859AbiCOKAF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Mar 2022 06:00:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiCOKAF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Mar 2022 06:00:05 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0190A4739B
        for <linux-raid@vger.kernel.org>; Tue, 15 Mar 2022 02:58:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B464121900;
        Tue, 15 Mar 2022 09:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647338330; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFOvdhHdYhNgqQ0c7Z8IDjlW/ylPA0B9GQINyXMqq0g=;
        b=JM2eA9VqKI2DiY3omL08GE8ZzLmr+CaiREoPGSssBH0rBjHIr/oA3QZ8JJEthDUfcWcE+E
        Tfs9REDZZx8nZ0pN8sGA6cuaLPYODGEgUiewKEZ0ICnPgiRB/YyiConqdPsoetjtBi0FIp
        8rMNoP3gfpqa7WK/tFPL5TxnxyGxZ80=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647338330;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFOvdhHdYhNgqQ0c7Z8IDjlW/ylPA0B9GQINyXMqq0g=;
        b=Fy7jSVPUFcGDC/dWDbf7DctS5pJwqBvYS8cSc6r5y+zdspAFYWXoyVwU8XvAlsdASVVMwO
        brAVMQ4no+gRYhAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 6139213B59;
        Tue, 15 Mar 2022 09:58:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id z6+cCVhjMGJJDwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 15 Mar 2022 09:58:48 +0000
Message-ID: <4f71792b-fca9-a18a-b2f2-2dbfaf3e8725@suse.de>
Date:   Tue, 15 Mar 2022 17:58:45 +0800
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
Content-Transfer-Encoding: 8bit
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

Hi  Lukasz,


This patch doesn't apply on branch 20220315-testing of the mdadm-CI 
tree, could you please rebase this series on

git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git 
20220315-testing

Then I will continue to test them.


Thanks.


Coly Li



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
> -			
> +
>   			if (info->mailfrom)
>   				fprintf(mp, "From: %s\n", info->mailfrom);
>   			else



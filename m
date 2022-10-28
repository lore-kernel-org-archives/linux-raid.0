Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D21BC38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:47:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJ1PrY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJ1PrX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:47:23 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97A11E09B2
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:47:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 8AD1E21D56;
        Fri, 28 Oct 2022 15:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666972041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IGabiZVcIIBmy0NZmNF5xAl/Te4qcFlWtSJocgpt2J0=;
        b=avtfg6ePPtFO77xgm8RXsaDUl7uj8uEkrN/lUl5f5Bkl5Uul5UP1QoKAfVGZL55lTeaqIo
        IzQMb8jpzQKDtQzcV+lfV2ShcmFlWxKQUXfmna+gzWeWh41AdTL3/pqaeVUpnRVi1BwKuf
        peazZwz4Y7LiuedodPmHEhMU0juUiGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666972041;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IGabiZVcIIBmy0NZmNF5xAl/Te4qcFlWtSJocgpt2J0=;
        b=BPdYmf5eWpri6JqbnV5hHNykpyRvTeYOoL5rtDe9R/XcyIt/ihIhVaxE+oKAYKOS5rdRlo
        7icWN6/3bbFRtmAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A697713A6E;
        Fri, 28 Oct 2022 15:47:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cxyBHIj5W2PTVQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:47:20 +0000
Message-ID: <f6e1a1ee-04c9-9bc0-80d5-3727cc872504@suse.de>
Date:   Fri, 28 Oct 2022 23:47:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 7/9] Mdmonitor: Refactor check_one_sharer() for better
 error handling
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-8-mateusz.grzonka@intel.com>
Content-Language: en-US
In-Reply-To: <20220907125657.12192-8-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Also check if autorebuild.pid is a symlink, which we shouldn't accept.
>
> Signed-off-by: Mateusz Grzonka<mateusz.grzonka@intel.com>

Except for the code comment style, the rested part is fine to me.

Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li


> ---
>   Monitor.c | 89 ++++++++++++++++++++++++++++++++++++++-----------------
>   1 file changed, 62 insertions(+), 27 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 3e09f2a2..aa79cf6c 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -32,6 +32,7 @@
>   #include	<libudev.h>
>   #endif
>   
> +#define TASK_COMM_LEN 16
>   #define EVENT_NAME_MAX 32
>   #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
>   
> @@ -214,7 +215,7 @@ int Monitor(struct mddev_dev *devlist,
>   	info.hostname[sizeof(info.hostname) - 1] = '\0';
>   
>   	if (share){
> -		if (check_one_sharer(c->scan))
> +		if (check_one_sharer(c->scan) == 2)
>   			return 1;
>   	}
>   
> @@ -394,39 +395,73 @@ static int make_daemon(char *pidfile)
>   	return -1;
>   }
>   
> +/**
> + * check_one_sharer() - Checks for other mdmon processes running.
> + *
> + * Return:
> + * 0 - no other processes running,
> + * 1 - warning,
> + * 2 - error, or when scan mode is enabled, and one mdmon process already exists
> + */
>   static int check_one_sharer(int scan)
>   {
>   	int pid;
> -	FILE *comm_fp;
> -	FILE *fp;
> +	FILE *fp, *comm_fp;
>   	char comm_path[PATH_MAX];
> -	char path[PATH_MAX];
> -	char comm[20];
> -
> -	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> -	fp = fopen(path, "r");
> -	if (fp) {
> -		if (fscanf(fp, "%d", &pid) != 1)
> -			pid = -1;
> -		snprintf(comm_path, sizeof(comm_path),
> -			 "/proc/%d/comm", pid);
> -		comm_fp = fopen(comm_path, "r");
> -		if (comm_fp) {
> -			if (fscanf(comm_fp, "%19s", comm) &&
> -			    strncmp(basename(comm), Name, strlen(Name)) == 0) {
> -				if (scan) {
> -					pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
> -					fclose(comm_fp);
> -					fclose(fp);
> -					return 1;
> -				} else {
> -					pr_err("Warning: One autorebuild process already running.\n");
> -				}
> -			}
> +	char comm[TASK_COMM_LEN];
> +
> +	if (!is_directory(MDMON_DIR)) {
> +		pr_err("%s is not a regular directory.\n", MDMON_DIR);
> +		return 2;
> +	}
> +
> +	if (access(AUTOREBUILD_PID_PATH, F_OK) != 0)
> +		return 0;
> +
> +	if (!is_file(AUTOREBUILD_PID_PATH)) {
> +		pr_err("%s is not a regular file.\n", AUTOREBUILD_PID_PATH);
> +		return 2;
> +	}
> +
> +	fp = fopen(AUTOREBUILD_PID_PATH, "r");
> +	if (!fp) {
> +		pr_err("Cannot open %s file.\n", AUTOREBUILD_PID_PATH);
> +		return 2;
> +	}
> +
> +	if (fscanf(fp, "%d", &pid) != 1) {
> +		pr_err("Cannot read pid from %s file.\n", AUTOREBUILD_PID_PATH);
> +		fclose(fp);
> +		return 2;
> +	}
> +
> +	snprintf(comm_path, sizeof(comm_path), "/proc/%d/comm", pid);
> +
> +	comm_fp = fopen(comm_path, "r");
> +	if (!comm_fp) {
> +		dprintf("Warning: Cannot open %s, continuing\n", comm_path);
> +		fclose(fp);
> +		return 1;
> +	}
> +
> +	if (fscanf(comm_fp, "%15s", comm) == 0) {
> +		dprintf("Warning: Cannot read comm from %s, continuing\n", comm_path);
> +		fclose(comm_fp);
> +		fclose(fp);
> +		return 1;
> +	}
> +
> +	if (strncmp(basename(comm), Name, strlen(Name)) == 0) {
> +		if (scan) {
> +			pr_err("Only one autorebuild process allowed in scan mode, aborting\n");
>   			fclose(comm_fp);
> +			fclose(fp);
> +			return 2;
>   		}
> -		fclose(fp);
> +		pr_err("Warning: One autorebuild process already running.\n");
>   	}
> +	fclose(comm_fp);
> +	fclose(fp);
>   	return 0;
>   }
>   



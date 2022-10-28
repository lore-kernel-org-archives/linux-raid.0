Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6467FC38A02
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJ1PrQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiJ1PrO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:47:14 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010B31EA56A
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:47:13 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9C2EF1FA9A;
        Fri, 28 Oct 2022 15:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666972032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4CvRYyl7lPDZTXLPBek6/m4+7ucvZbmHGTAJRYBg54=;
        b=IR9a5QkU3+FFU0/1PDeGrt8tloo9d84ymvGuOuRSgaIOywe3wpiRqb8jTzrdS297/HqG7b
        kBNqPqu0CM/T4CmG8YrYWOB44iorre5DltiNoXLdK690q3SVFK7rrtUtALzOOcEWOTfjPT
        jyR+VbnW7Dsk+7bTCWbLVc61uLu0Dnc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666972032;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4CvRYyl7lPDZTXLPBek6/m4+7ucvZbmHGTAJRYBg54=;
        b=u2tJ6MXQJTyAY1dDyGE0kyoxMmq1FGIzmCr0z6qBcnuYnCuQCha4kE895VU3Ud7vV3M6BL
        EyPtsaGRaTz5JYAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C04F813A6E;
        Fri, 28 Oct 2022 15:47:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id oQ16E3/5W2PBVQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:47:11 +0000
Message-ID: <3477f5e0-bff0-481a-9428-5378a9248b85@suse.de>
Date:   Fri, 28 Oct 2022 23:47:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 6/9] Mdmonitor: Refactor write_autorebuild_pid()
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-7-mateusz.grzonka@intel.com>
Content-Language: en-US
In-Reply-To: <20220907125657.12192-7-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Add better error handling and check for symlinks when opening MDMON_DIR.
>
> Signed-off-by: Mateusz Grzonka<mateusz.grzonka@intel.com>


Except for the code comment style, the rested part is good to me.

Acked-by: Coly Li <colyli@suse.de>


Thanks.


Coly Li




> ---
>   Monitor.c | 55 ++++++++++++++++++++++++++++++++++++-------------------
>   1 file changed, 36 insertions(+), 19 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 80e43ebe..3e09f2a2 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -33,6 +33,7 @@
>   #endif
>   
>   #define EVENT_NAME_MAX 32
> +#define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
>   
>   struct state {
>   	char *devname;
> @@ -123,7 +124,7 @@ static int check_udev_activity(void);
>   static void link_containers_with_subarrays(struct state *list);
>   static int make_daemon(char *pidfile);
>   static void try_spare_migration(struct state *statelist);
> -static void write_autorebuild_pid(void);
> +static int write_autorebuild_pid(void);
>   
>   int Monitor(struct mddev_dev *devlist,
>   	    char *mailaddr, char *alert_cmd,
> @@ -224,7 +225,8 @@ int Monitor(struct mddev_dev *devlist,
>   	}
>   
>   	if (share)
> -		write_autorebuild_pid();
> +		if (write_autorebuild_pid() != 0)
> +			return 1;
>   
>   	if (devlist == NULL) {
>   		mdlist = conf_get_ident(NULL);
> @@ -428,29 +430,44 @@ static int check_one_sharer(int scan)
>   	return 0;
>   }
>   
> -static void write_autorebuild_pid()
> +/**
> + * write_autorebuild_pid() - Writes pid to autorebuild.pid file.
> + *
> + * Return: 0 on success, 1 on error
> + */
> +static int write_autorebuild_pid(void)
>   {
> -	char path[PATH_MAX];
> -	int pid;
> -	FILE *fp = NULL;
> -	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> +	FILE *fp;
> +	int fd;
>   
>   	if (mkdir(MDMON_DIR, 0700) < 0 && errno != EEXIST) {
> -		pr_err("Can't create autorebuild.pid file\n");
> -	} else {
> -		int fd = open(path, O_WRONLY | O_CREAT | O_TRUNC, 0700);
> +		pr_err("%s: %s\n", strerror(errno), MDMON_DIR);
> +		return 1;
> +	}
>   
> -		if (fd >= 0)
> -			fp = fdopen(fd, "w");
> +	if (!is_directory(MDMON_DIR)) {
> +		pr_err("%s is not a regular directory.\n", MDMON_DIR);
> +		return 1;
> +	}
>   
> -		if (!fp)
> -			pr_err("Can't create autorebuild.pid file\n");
> -		else {
> -			pid = getpid();
> -			fprintf(fp, "%d\n", pid);
> -			fclose(fp);
> -		}
> +	fd = open(AUTOREBUILD_PID_PATH, O_WRONLY | O_CREAT | O_TRUNC, 0700);
> +
> +	if (fd < 0) {
> +		pr_err("Error opening %s file.\n", AUTOREBUILD_PID_PATH);
> +		return 1;
>   	}
> +
> +	fp = fdopen(fd, "w");
> +
> +	if (!fp) {
> +		pr_err("Error opening fd for %s file.\n", AUTOREBUILD_PID_PATH);
> +		return 1;
> +	}
> +
> +	fprintf(fp, "%d\n", getpid());
> +
> +	fclose(fp);
> +	return 0;
>   }
>   
>   #define BASE_MESSAGE "%s event detected on md device %s"



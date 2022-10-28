Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104A4ECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiJ1PoQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJ1PoP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:44:15 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9152C1CD68C
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:44:14 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 22C0321D52;
        Fri, 28 Oct 2022 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666971853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVTMN3UsVr5mTODHheyV2q1n5yP+AqtpC+bO6dt6WLI=;
        b=tEejoRS7SwkpTcXrJUCBLVgBkSJ0slkbEkIZYGhY6YjOpwlEoGSUNbBdPYQt9fuGqQNl8e
        /dcqG+t8Z3Z1hpH7Ra/GYdDjpohnSLF4X4rJEwQJ69zvtW5ybQXqGf7jbvNXkPT2YTj7r+
        DP82urT0KnHPhijfYGQ84+lVSkAnuoc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666971853;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVTMN3UsVr5mTODHheyV2q1n5yP+AqtpC+bO6dt6WLI=;
        b=D/dVY0Ls5pgv/LAuB+GazMnDYcSbWcE92NecYCx8EwgbIpaaJqydrwcTNHBHI3Nsixoj5j
        yjW/MwV6kGGRq6CA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 482BE13A6E;
        Fri, 28 Oct 2022 15:44:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Amp6Bcz4W2NUVAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:44:12 +0000
Message-ID: <bba5423c-dc79-62f2-81cf-32f3d93518bc@suse.de>
Date:   Fri, 28 Oct 2022 23:44:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
From:   Coly Li <colyli@suse.de>
Subject: Re: [PATCH 1/9] Mdmonitor: Split alert() into separate functions
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-2-mateusz.grzonka@intel.com>
Content-Language: en-US
In-Reply-To: <20220907125657.12192-2-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Signed-off-by: Mateusz Grzonka<mateusz.grzonka@intel.com>
> ---
>   Monitor.c | 186 ++++++++++++++++++++++++++++--------------------------
>   1 file changed, 95 insertions(+), 91 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index c0ab5412..65e66474 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -66,7 +66,7 @@ struct alert_info {
>   static int make_daemon(char *pidfile);
>   static int check_one_sharer(int scan);
>   static void write_autorebuild_pid(void);
> -static void alert(char *event, char *dev, char *disc, struct alert_info *info);
> +static void alert(const char *event, const char *dev, const char *disc, struct alert_info *info);
>   static int check_array(struct state *st, struct mdstat_ent *mdstat,
>   		       int test, struct alert_info *info,
>   		       int increments, char *prefer);
> @@ -402,111 +402,115 @@ static void write_autorebuild_pid()
>   	}
>   }
>   
> -static void alert(char *event, char *dev, char *disc, struct alert_info *info)
> +static void execute_alert_cmd(const char *event, const char *dev, const char *disc, struct alert_info *info)
> +{


The above line is too long, it would be better to modify the parameter 
list into multiple lines.


> +	int pid = fork();
> +
> +	switch (pid) {
> +	default:
> +		waitpid(pid, NULL, 0);
> +		break;
> +	case -1:
> +		pr_err("Cannot fork to execute alert command");


‘\n’ at the tail missed ?


> +		break;
> +	case 0:
> +		execl(info->alert_cmd, info->alert_cmd, event, dev, disc, NULL);
> +		exit(2);
> +	}
> +}
> +
> +static void send_event_email(const char *event, const char *dev, const char *disc, struct alert_info *info)
> +{
> +	FILE *mp, *mdstat;
> +	char hname[256];
> +	char buf[BUFSIZ];
> +	int n;
> +
> +	mp = popen(Sendmail, "w");
> +	if (!mp) {
> +		pr_err("Cannot open pipe stream for sendmail.\n");
> +		return;
> +	}
> +
> +	gethostname(hname, sizeof(hname));
> +	signal(SIGPIPE, SIG_IGN);
> +	if (info->mailfrom)
> +		fprintf(mp, "From: %s\n", info->mailfrom);
> +	else
> +		fprintf(mp, "From: %s monitoring <root>\n", Name);
> +	fprintf(mp, "To: %s\n", info->mailaddr);
> +	fprintf(mp, "Subject: %s event on %s:%s\n\n", event, dev, hname);
> +	fprintf(mp, "This is an automatically generated mail message. \n");
> +	fprintf(mp, "A %s event had been detected on md device %s.\n\n", event, dev);
> +
> +	if (disc && disc[0] != ' ')
> +		fprintf(mp,
> +			"It could be related to component device %s.\n\n", disc);
> +	if (disc && disc[0] == ' ')
> +		fprintf(mp, "Extra information:%s.\n\n", disc);
> +
> +	mdstat = fopen("/proc/mdstat", "r");
> +	if (!mdstat) {
> +		pr_err("Cannot open /proc/mdstat\n");
> +		pclose(mp);
> +		return;
> +	}
> +
> +	fprintf(mp, "The /proc/mdstat file currently contains the following:\n\n");
> +	while ((n = fread(buf, 1, sizeof(buf), mdstat)) > 0)
> +		n = fwrite(buf, 1, n, mp);
> +	fclose(mdstat);
> +	pclose(mp);
> +}
> +
> +static void log_event_to_syslog(const char *event, const char *dev, const char *disc)
>   {
>   	int priority;
> +	/* Log at a different severity depending on the event.
> +	 *
> +	 * These are the critical events:  */

The original code comment didn’t follow existed mdadm code style, maybe 
we can fix the above mismatched code style here?


The rested part looks good to me.

Thanks.

Coly Li


> +	if (strncmp(event, "Fail", 4) == 0 ||
> +		strncmp(event, "Degrade", 7) == 0 ||
> +		strncmp(event, "DeviceDisappeared", 17) == 0)
> +		priority = LOG_CRIT;
> +	/* Good to know about, but are not failures: */
> +	else if (strncmp(event, "Rebuild", 7) == 0 ||
> +			strncmp(event, "MoveSpare", 9) == 0 ||
> +			strncmp(event, "Spares", 6) != 0)
> +		priority = LOG_WARNING;
> +	/* Everything else: */
> +	else
> +		priority = LOG_INFO;
>   
> +	if (disc && disc[0] != ' ')
> +		syslog(priority,
> +			"%s event detected on md device %s, component device %s", event, dev, disc);
> +	else if (disc)
> +		syslog(priority, "%s event detected on md device %s: %s", event, dev, disc);
> +	else
> +		syslog(priority, "%s event detected on md device %s", event, dev);
> +}
> +
> +static void alert(const char *event, const char *dev, const char *disc, struct alert_info *info)
> +{
>   	if (!info->alert_cmd && !info->mailaddr && !info->dosyslog) {
>   		time_t now = time(0);
>   
>   		printf("%1.15s: %s on %s %s\n", ctime(&now) + 4,
>   		       event, dev, disc?disc:"unknown device");
>   	}
> -	if (info->alert_cmd) {
> -		int pid = fork();
> -		switch(pid) {
> -		default:
> -			waitpid(pid, NULL, 0);
> -			break;
> -		case -1:
> -			break;
> -		case 0:
> -			execl(info->alert_cmd, info->alert_cmd,
> -			      event, dev, disc, NULL);
> -			exit(2);
> -		}
> -	}
> +	if (info->alert_cmd)
> +		execute_alert_cmd(event, dev, disc, info);
> +
>   	if (info->mailaddr && (strncmp(event, "Fail", 4) == 0 ||
>   			       strncmp(event, "Test", 4) == 0 ||
>   			       strncmp(event, "Spares", 6) == 0 ||
>   			       strncmp(event, "Degrade", 7) == 0)) {
> -		FILE *mp = popen(Sendmail, "w");
> -		if (mp) {
> -			FILE *mdstat;
> -			char hname[256];
> -
> -			gethostname(hname, sizeof(hname));
> -			signal_s(SIGPIPE, SIG_IGN);
> -
> -			if (info->mailfrom)
> -				fprintf(mp, "From: %s\n", info->mailfrom);
> -			else
> -				fprintf(mp, "From: %s monitoring <root>\n",
> -					Name);
> -			fprintf(mp, "To: %s\n", info->mailaddr);
> -			fprintf(mp, "Subject: %s event on %s:%s\n\n",
> -				event, dev, hname);
> -
> -			fprintf(mp,
> -				"This is an automatically generated mail message from %s\n", Name);
> -			fprintf(mp, "running on %s\n\n", hname);
> -
> -			fprintf(mp,
> -				"A %s event had been detected on md device %s.\n\n", event, dev);
> -
> -			if (disc && disc[0] != ' ')
> -				fprintf(mp,
> -					"It could be related to component device %s.\n\n", disc);
> -			if (disc && disc[0] == ' ')
> -				fprintf(mp, "Extra information:%s.\n\n", disc);
> -
> -			fprintf(mp, "Faithfully yours, etc.\n");
> -
> -			mdstat = fopen("/proc/mdstat", "r");
> -			if (mdstat) {
> -				char buf[8192];
> -				int n;
> -				fprintf(mp,
> -					"\nP.S. The /proc/mdstat file currently contains the following:\n\n");
> -				while ((n = fread(buf, 1, sizeof(buf),
> -						  mdstat)) > 0)
> -					n = fwrite(buf, 1, n, mp);
> -				fclose(mdstat);
> -			}
> -			pclose(mp);
> -		}
> +		send_event_email(event, dev, disc, info);
>   	}
>   
> -	/* log the event to syslog maybe */
> -	if (info->dosyslog) {
> -		/* Log at a different severity depending on the event.
> -		 *
> -		 * These are the critical events:  */
> -		if (strncmp(event, "Fail", 4) == 0 ||
> -		    strncmp(event, "Degrade", 7) == 0 ||
> -		    strncmp(event, "DeviceDisappeared", 17) == 0)
> -			priority = LOG_CRIT;
> -		/* Good to know about, but are not failures: */
> -		else if (strncmp(event, "Rebuild", 7) == 0 ||
> -			 strncmp(event, "MoveSpare", 9) == 0 ||
> -			 strncmp(event, "Spares", 6) != 0)
> -			priority = LOG_WARNING;
> -		/* Everything else: */
> -		else
> -			priority = LOG_INFO;
> -
> -		if (disc && disc[0] != ' ')
> -			syslog(priority,
> -			       "%s event detected on md device %s, component device %s", event, dev, disc);
> -		else if (disc)
> -			syslog(priority,
> -			       "%s event detected on md device %s: %s",
> -			       event, dev, disc);
> -		else
> -			syslog(priority,
> -			       "%s event detected on md device %s",
> -			       event, dev);
> -	}
> +	if (info->dosyslog)
> +		log_event_to_syslog(event, dev, disc);
>   }
>   
>   static int check_array(struct state *st, struct mdstat_ent *mdstat,



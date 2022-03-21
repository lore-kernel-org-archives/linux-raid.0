Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5544DC433EF
	for <linux-raid@archiver.kernel.org>; Mon, 21 Mar 2022 12:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346258AbiCUMrT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347539AbiCUMrN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Mar 2022 08:47:13 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D3E972B8
        for <linux-raid@vger.kernel.org>; Mon, 21 Mar 2022 05:45:44 -0700 (PDT)
Received: from [192.168.0.7] (ip5f5aef4e.dynamic.kabel-deutschland.de [95.90.239.78])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9C5BC61E6478B;
        Mon, 21 Mar 2022 13:45:41 +0100 (CET)
Message-ID: <e5502af7-be1c-da7f-af3d-ca36d45e6301@molgen.mpg.de>
Date:   Mon, 21 Mar 2022 13:45:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] Mdmonitor: Fix segfault and improve logging
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
References: <20220321123234.28769-1-kinga.tanska@intel.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20220321123234.28769-1-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear Kinga, dear Oleksandr,


Am 21.03.22 um 13:32 schrieb Kinga Tanska:
> From: Oleksandr Shchirskyi <oleksandr.shchirskyi@linux.intel.com>
> 
> Check that devices passed to mdmonitor are md arrays.
> Also, change logging, so mdmonitor in verbose mode will report its
> configuration.

Thank you for the patch. As these are two distinct changes, could you 
please split it into two commits?

If you could add a reproducer the segmentation fault, that’d also be great.


Kind regards,

Paul


> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Monitor.c | 36 ++++++++++++++++++++++++------------
>   mdadm.h   |  1 +
>   mdopen.c  | 17 +++++++++++++++++
>   util.c    |  2 +-
>   4 files changed, 43 insertions(+), 13 deletions(-)
> 
> diff --git a/Monitor.c b/Monitor.c
> index f5412299..bd417d04 100644
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
> @@ -183,6 +186,10 @@ int Monitor(struct mddev_dev *devlist,
>   				continue;
>   			if (strcasecmp(mdlist->devname, "<ignore>") == 0)
>   				continue;
> +
> +			if (!is_mddev(mdlist->devname))
> +				return 1;
> +
>   			st = xcalloc(1, sizeof *st);
>   			if (mdlist->devname[0] == '/')
>   				st->devname = xstrdup(mdlist->devname);
> @@ -204,7 +211,12 @@ int Monitor(struct mddev_dev *devlist,
>   		struct mddev_dev *dv;
>   
>   		for (dv = devlist; dv; dv = dv->next) {
> -			struct state *st = xcalloc(1, sizeof *st);
> +			struct state *st;
> +
> +			if (!is_mddev(dv->devname))
> +				return 1;
> +
> +			st = xcalloc(1, sizeof *st);
>   			mdlist = conf_get_ident(dv->devname);
>   			st->devname = xstrdup(dv->devname);
>   			st->next = statelist;
> diff --git a/mdadm.h b/mdadm.h
> index 8f8841d8..03151c34 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1607,6 +1607,7 @@ extern int create_mddev(char *dev, char *name, int autof, int trustworthy,
>   #define	FOREIGN	2
>   #define	METADATA 3
>   extern int open_mddev(char *dev, int report_errors);
> +extern int is_mddev(char *dev);
>   extern int open_container(int fd);
>   extern int metadata_container_matches(char *metadata, char *devnm);
>   extern int metadata_subdev_matches(char *metadata, char *devnm);
> diff --git a/mdopen.c b/mdopen.c
> index 245be537..d18c9319 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -475,6 +475,23 @@ int open_mddev(char *dev, int report_errors)
>   	return mdfd;
>   }
>   
> +/**
> + * is_mddev() - check that file name passed is an md device.
> + * @dev: file name that has to be checked.
> + * Return: 1 if file passed is an md device, 0 if not.
> + */
> +int is_mddev(char *dev)
> +{
> +	int fd = open_mddev(dev, 1);
> +
> +	if (fd >= 0) {
> +		close(fd);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
>   char *find_free_devnm(int use_partitions)
>   {
>   	static char devnm[32];
> diff --git a/util.c b/util.c
> index cdf1da24..003b2f86 100644
> --- a/util.c
> +++ b/util.c
> @@ -268,7 +268,7 @@ int md_array_active(int fd)
>   		 * GET_ARRAY_INFO doesn't provide access to the proper state
>   		 * information, so fallback to a basic check for raid_disks != 0
>   		 */
> -		ret = ioctl(fd, GET_ARRAY_INFO, &array);
> +		ret = md_get_array_info(fd, &array);
>   	}
>   
>   	return !ret;

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F032C433EF
	for <linux-raid@archiver.kernel.org>; Sat,  2 Apr 2022 15:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238101AbiDBPlI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 2 Apr 2022 11:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237964AbiDBPlH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 2 Apr 2022 11:41:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA4349F28
        for <linux-raid@vger.kernel.org>; Sat,  2 Apr 2022 08:39:15 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7FB5D1FD01;
        Sat,  2 Apr 2022 15:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1648913954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbjAuR6WJyHirrSwvbsjLRhrxdpSH4x9HqcjU6ktH20=;
        b=ehEhqDGRXqDa+HAcwznAoDpXEINk6e4HDTEBS3Cwk8/+0izGary9zAyiUFqTiy8FDJV6WV
        IGfv6aYIJOt78jR2BcJYYlypxK6wUprJ6eoqQvSgnS/9dK8HvQaRAw4y1m2S5j3lCC7xae
        BzI7fzpK4sN4e20UdUfkwATArzKkh1E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1648913954;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UbjAuR6WJyHirrSwvbsjLRhrxdpSH4x9HqcjU6ktH20=;
        b=NMmIZv3CxaUJJF1MfYmr08aHzt5iVNTVpVX69WT2pfNbMzuF52zPMPiX3qLIIaFZQcCy3W
        AYPSqIcP22SMIPAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 650BD13440;
        Sat,  2 Apr 2022 15:39:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id E6oBByBuSGKTNgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 02 Apr 2022 15:39:12 +0000
Message-ID: <cec53c8c-f100-3845-3cff-2a524cc39759@suse.de>
Date:   Sat, 2 Apr 2022 23:39:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] Mdmonitor: Fix segfault
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     pmenzel@molgen.mpg.de, jes@trained-monkey.org,
        linux-raid@vger.kernel.org
References: <20220323090744.26716-1-kinga.tanska@intel.com>
 <20220323090744.26716-2-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220323090744.26716-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/23/22 5:07 PM, Kinga Tanska wrote:
> Check that devices passed to mdmonitor are md arrays.
>
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> ---
>   Monitor.c | 11 ++++++++++-
>   mdadm.h   |  1 +
>   mdopen.c  | 17 +++++++++++++++++
>   util.c    |  2 +-
>   4 files changed, 29 insertions(+), 2 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index f5412299..0b24b656 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -183,6 +183,10 @@ int Monitor(struct mddev_dev *devlist,
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
> @@ -204,7 +208,12 @@ int Monitor(struct mddev_dev *devlist,
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


Hi Kinga,

The last code block is irrelative to the main idea of this patch. Could 
you please remove it from this patch, and maybe post another separated 
one for it?

Thanks.


Coly Li



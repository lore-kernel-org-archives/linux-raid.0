Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E79C5C433FE
	for <linux-raid@archiver.kernel.org>; Wed,  6 Apr 2022 17:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239033AbiDFRmE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 6 Apr 2022 13:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239370AbiDFRlp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 6 Apr 2022 13:41:45 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1070333D0E5
        for <linux-raid@vger.kernel.org>; Wed,  6 Apr 2022 09:29:53 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A0F2B210F4;
        Wed,  6 Apr 2022 16:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649262592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VHj+OFElhvuVTj9YlaUS5QG62vYqxKKzya3hIbIzd5g=;
        b=iBWiEekB+CkL2IuT3lsrCX+xzt13o8eJeLTibM/r2hDLUmHtwODWmpL9eWg3YCYPd4H6jJ
        iGo8EVv7SJ+GOL/ilFjqwWZZFJtXoQrN9sBO2GNiy3MrRs1Va+fwSJiZoLB20WSVGR8nAW
        DiBdp9SgcyWX2nZcpyKb6Cywy7sO0tk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649262592;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VHj+OFElhvuVTj9YlaUS5QG62vYqxKKzya3hIbIzd5g=;
        b=8inJ48QQ3d1NTST8eHsk877fJ0W99nyPmuTfuQqzwL1Vxuium5lNbjgTcTEQJiMO4IzLNI
        WV78rJlyL+I9g2BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CC0F8139F5;
        Wed,  6 Apr 2022 16:29:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 36kgJv6/TWI3VQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 06 Apr 2022 16:29:50 +0000
Message-ID: <dc702aee-785e-e69e-ad02-0e3e9c441a54@suse.de>
Date:   Thu, 7 Apr 2022 00:29:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/2] Mdmonitor: Fix segfault
Content-Language: en-US
To:     Kinga Tanska <kinga.tanska@intel.com>
Cc:     jes@trained-monkey.org, pmenzel@molgen.mpg.de,
        linux-raid@vger.kernel.org
References: <20220405114057.27080-1-kinga.tanska@intel.com>
 <20220405114057.27080-2-kinga.tanska@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220405114057.27080-2-kinga.tanska@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/5/22 7:40 PM, Kinga Tanska wrote:
> Mdadm with "--monitor" parameter requires md device
> as an argument to be monitored. If given argument is
> not a md device, error shall be returned. Previously
> it was not checked and invalid argument caused
> segmentation fault. This commit adds checking
> that devices passed to mdmonitor are md devices.
>
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> Signed-off-by: Oleksandr Shchirskyi <oleksandr.shchirskyi@intel.com>
> ---
>   Monitor.c | 11 ++++++++++-
>   mdadm.h   |  1 +
>   mdopen.c  | 17 +++++++++++++++++
>   3 files changed, 28 insertions(+), 1 deletion(-)
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


HI Kinga,


Suddenly I realize that your test for the above change might not be 
complete.

mdlist->devname is permitted to be a relative path under /dev/md/, with 
your change such devname will be regarded as invalid by is_mddev(). 
Because open_mddev() only takes absolute path. Maybe is_mddev() should 
be called several lines behind current location.

The rested part of the patch is fine to me.


Thanks.


Coly Li

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



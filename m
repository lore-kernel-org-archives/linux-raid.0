Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 984ACECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 28 Oct 2022 15:47:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiJ1Prk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Oct 2022 11:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJ1Prj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Oct 2022 11:47:39 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B1E1EEF07
        for <linux-raid@vger.kernel.org>; Fri, 28 Oct 2022 08:47:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A8F21FA9A;
        Fri, 28 Oct 2022 15:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666972056; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jxl3o7U7szgNuqi83ytTbruO2XgOpdu3y56r8darRnY=;
        b=oPRSqjpcf5iscPoEhFzycQdYyQ6lfj9JPvUEvBmcp38xJYF/Zn0W3GwWL1ExkacGxqO9Rn
        n5cYLdT9qEXea52cOMeVIQjZHWVJjmmQhxl5j0tZG0g35IFSKfBrlBCXaOxuIrYV3f+1yj
        JmrqYtvoi67CjfR0RqTbdF99O4C6R7I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666972056;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jxl3o7U7szgNuqi83ytTbruO2XgOpdu3y56r8darRnY=;
        b=jI8IWY9hGIeF+R/8orDCTY1nXvMnzK+q+OUySbRLmD0+H1T4MT/Dhwy/CKliKs7l2ScATu
        hQoLpDrHMnrJUZCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AAA7513A6E;
        Fri, 28 Oct 2022 15:47:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /Ri3HJf5W2P2VQAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 28 Oct 2022 15:47:35 +0000
Message-ID: <07383573-e798-e99a-93e5-d94dbe3d3567@suse.de>
Date:   Fri, 28 Oct 2022 23:47:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH 9/9] udev: Move udev_block() and udev_unblock() into
 udev.c
Content-Language: en-US
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
References: <20220907125657.12192-1-mateusz.grzonka@intel.com>
 <20220907125657.12192-10-mateusz.grzonka@intel.com>
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220907125657.12192-10-mateusz.grzonka@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/7/22 8:56 PM, Mateusz Grzonka wrote:
> Add kernel style comments and better error handling.
>
> Change-Id: Ib6b8e7725d6739a2d7f7b8801e3403137c9cc402

What does the above line mean?


BTW, for the code, it looks fine to me. I want to ack this patch after 
the Change-Id in the commit log explained.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
>   Create.c |  1 +
>   lib.c    | 29 -----------------------------
>   mdadm.h  |  2 --
>   mdopen.c | 12 ++++++------
>   udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
>   udev.h   |  2 ++
>   6 files changed, 53 insertions(+), 37 deletions(-)
>
> diff --git a/Create.c b/Create.c
> index c84c1ac8..e68894ed 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -23,6 +23,7 @@
>    */
>   
>   #include	"mdadm.h"
> +#include	"udev.h"
>   #include	"md_u.h"
>   #include	"md_p.h"
>   #include	<ctype.h>
> diff --git a/lib.c b/lib.c
> index 10a6ae40..5a1afd49 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -174,35 +174,6 @@ char *fd2devnm(int fd)
>   	return NULL;
>   }
>   
> -/* When we create a new array, we don't want the content to
> - * be immediately examined by udev - it is probably meaningless.
> - * So create /run/mdadm/creating-mdXXX and expect that a udev
> - * rule will noticed this and act accordingly.
> - */
> -static char block_path[] = "/run/mdadm/creating-%s";
> -static char *unblock_path = NULL;
> -void udev_block(char *devnm)
> -{
> -	int fd;
> -	char *path = NULL;
> -
> -	xasprintf(&path, block_path, devnm);
> -	fd = open(path, O_CREAT|O_RDWR, 0600);
> -	if (fd >= 0) {
> -		close(fd);
> -		unblock_path = path;
> -	} else
> -		free(path);
> -}
> -
> -void udev_unblock(void)
> -{
> -	if (unblock_path)
> -		unlink(unblock_path);
> -	free(unblock_path);
> -	unblock_path = NULL;
> -}
> -
>   /*
>    * convert a major/minor pair for a block device into a name in /dev, if possible.
>    * On the first call, walk /dev collecting name.
> diff --git a/mdadm.h b/mdadm.h
> index 3c08f826..3f81cce6 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1662,8 +1662,6 @@ extern char *stat2kname(struct stat *st);
>   extern char *fd2kname(int fd);
>   extern char *stat2devnm(struct stat *st);
>   extern char *fd2devnm(int fd);
> -extern void udev_block(char *devnm);
> -extern void udev_unblock(void);
>   
>   extern int in_initrd(void);
>   
> diff --git a/mdopen.c b/mdopen.c
> index 53da4d96..93193739 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -336,8 +336,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>   	devnm[0] = 0;
>   	if (num < 0 && cname && ci->names) {
>   		sprintf(devnm, "md_%s", cname);
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
> +			return -1;
>   		if (!create_named_array(devnm)) {
>   			devnm[0] = 0;
>   			udev_unblock();
> @@ -345,8 +345,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>   	}
>   	if (num >= 0) {
>   		sprintf(devnm, "md%d", num);
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
> +			return -1;
>   		if (!create_named_array(devnm)) {
>   			devnm[0] = 0;
>   			udev_unblock();
> @@ -369,8 +369,8 @@ int create_mddev(char *dev, char *name, int autof, int trustworthy,
>   				return -1;
>   			}
>   		}
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) != UDEV_STATUS_SUCCESS)
> +			return -1;
>   	}
>   
>   	sprintf(devname, "/dev/%s", devnm);
> diff --git a/udev.c b/udev.c
> index 18055bfc..d6e3d7b5 100644
> --- a/udev.c
> +++ b/udev.c
> @@ -30,6 +30,7 @@
>   
>   static struct udev *udev;
>   static struct udev_monitor *udev_monitor;
> +static char *unblock_path;
>   
>   /**
>    * udev_is_available() - Checks for udev in the system.
> @@ -145,3 +146,46 @@ void udev_release(void)
>   	udev_monitor_unref(udev_monitor);
>   	udev_unref(udev);
>   }
> +
> +/**
> + * udev_block() - Block udev from examining newly created arrays.
> + *
> + * When array is created, we don't want udev to examine it immediately.
> + * Function creates /run/mdadm/creating-mdXXX and expects that udev rule
> + * will notice it and act accordingly.
> + *
> + * Return:
> + * UDEV_STATUS_SUCCESS when successfully blocked udev
> + * UDEV_STATUS_ERROR on error
> + */
> +enum udev_status udev_block(char *devnm)
> +{
> +	int fd;
> +	char *path = xcalloc(1, BUFSIZ);
> +
> +	snprintf(path, BUFSIZ, "/run/mdadm/creating-%s", devnm);
> +
> +	fd = open(path, O_CREAT | O_RDWR, 0600);
> +	if (!is_fd_valid(fd)) {
> +		pr_err("Cannot block udev, error creating blocking file.\n");
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		free(path);
> +		return UDEV_STATUS_ERROR;
> +	}
> +
> +	close(fd);
> +	unblock_path = path;
> +	return UDEV_STATUS_SUCCESS;
> +}
> +
> +/**
> + * udev_unblock() - Unblock udev.
> + */
> +void udev_unblock(void)
> +{
> +	if (unblock_path)
> +		unlink(unblock_path);
> +	free(unblock_path);
> +	unblock_path = NULL;
> +}
> +
> diff --git a/udev.h b/udev.h
> index 515366e7..e4da29cc 100644
> --- a/udev.h
> +++ b/udev.h
> @@ -32,5 +32,7 @@ bool udev_is_available(void);
>   enum udev_status udev_initialize(void);
>   enum udev_status udev_wait_for_events(int seconds);
>   void udev_release(void);
> +enum udev_status udev_block(char *devnm);
> +void udev_unblock(void);
>   
>   #endif



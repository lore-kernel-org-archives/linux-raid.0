Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDFDC61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:41:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbjBWNlt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbjBWNlr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:41:47 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A8C842BCC
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:41:46 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1491C2025C;
        Thu, 23 Feb 2023 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159705; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhPTCqmWMt91dPVOB/b3Kx8BMIsm6dLgFdlN6Q1/yBA=;
        b=JRqCekP7feTXgemkl2Q8tTQFw9pKleoyXcRKJb8ibgWaTDeErZR9b/+fK3RYlR4XVRxmdl
        VoY3nMfebR4DxvdhhSydP5Ec1ATugcarcrrJEmTujNrK5IZSloq1v7Hn0ZidCR6OjlpXlv
        lqcg2AK60LefgDgFSsYsSD4POafvqmI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159705;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PhPTCqmWMt91dPVOB/b3Kx8BMIsm6dLgFdlN6Q1/yBA=;
        b=gr/cveKGeZEkidkgzOOCzrylTgxv1yTp8z32ZU1Dedtoro+zY+TTaylvnKmnmiQdlb2ox5
        zsYkos8sT+1pXdCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 267BD139B5;
        Thu, 23 Feb 2023 13:41:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YAVoNxdt92MEfQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:41:43 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 8/8] udev: Move udev_block() and udev_unblock() into
 udev.c
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-9-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:41:33 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <FA6125D3-E73D-4207-8F5E-4195E9066E3C@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-9-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:06PM +0100, Mateusz Grzonka wrote:
> Add kernel style comments and better error handling.
>=20
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>


> ---
> Create.c |  1 +
> lib.c    | 29 -----------------------------
> mdadm.h  |  2 --
> mdopen.c | 12 ++++++------
> udev.c   | 44 ++++++++++++++++++++++++++++++++++++++++++++
> udev.h   |  2 ++
> 6 files changed, 53 insertions(+), 37 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 953e7372..666a8c92 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -23,6 +23,7 @@
>  */
>=20
> #include	"mdadm.h"
> +#include	"udev.h"
> #include	"md_u.h"
> #include	"md_p.h"
> #include	<ctype.h>
> diff --git a/lib.c b/lib.c
> index 96ba6e8d..24cd10e3 100644
> --- a/lib.c
> +++ b/lib.c
> @@ -186,35 +186,6 @@ char *fd2devnm(int fd)
> 	return NULL;
> }
>=20
> -/* When we create a new array, we don't want the content to
> - * be immediately examined by udev - it is probably meaningless.
> - * So create /run/mdadm/creating-mdXXX and expect that a udev
> - * rule will noticed this and act accordingly.
> - */
> -static char block_path[] =3D "/run/mdadm/creating-%s";
> -static char *unblock_path =3D NULL;
> -void udev_block(char *devnm)
> -{
> -	int fd;
> -	char *path =3D NULL;
> -
> -	xasprintf(&path, block_path, devnm);
> -	fd =3D open(path, O_CREAT|O_RDWR, 0600);
> -	if (fd >=3D 0) {
> -		close(fd);
> -		unblock_path =3D path;
> -	} else
> -		free(path);
> -}
> -
> -void udev_unblock(void)
> -{
> -	if (unblock_path)
> -		unlink(unblock_path);
> -	free(unblock_path);
> -	unblock_path =3D NULL;
> -}
> -
> /*
>  * convert a major/minor pair for a block device into a name in /dev, =
if possible.
>  * On the first call, walk /dev collecting name.
> diff --git a/mdadm.h b/mdadm.h
> index 23c10a52..5607c599 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1729,8 +1729,6 @@ extern char *fd2kname(int fd);
> extern char *stat2devnm(struct stat *st);
> bool stat_is_md_dev(struct stat *st);
> extern char *fd2devnm(int fd);
> -extern void udev_block(char *devnm);
> -extern void udev_unblock(void);
>=20
> extern int in_initrd(void);
>=20
> diff --git a/mdopen.c b/mdopen.c
> index afec34a4..ef34613a 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -336,8 +336,8 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
> 	devnm[0] =3D 0;
> 	if (num < 0 && cname && ci->names) {
> 		sprintf(devnm, "md_%s", cname);
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) !=3D =
UDEV_STATUS_SUCCESS)
> +			return -1;
> 		if (!create_named_array(devnm)) {
> 			devnm[0] =3D 0;
> 			udev_unblock();
> @@ -345,8 +345,8 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
> 	}
> 	if (num >=3D 0) {
> 		sprintf(devnm, "md%d", num);
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) !=3D =
UDEV_STATUS_SUCCESS)
> +			return -1;
> 		if (!create_named_array(devnm)) {
> 			devnm[0] =3D 0;
> 			udev_unblock();
> @@ -369,8 +369,8 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
> 				return -1;
> 			}
> 		}
> -		if (block_udev)
> -			udev_block(devnm);
> +		if (block_udev && udev_block(devnm) !=3D =
UDEV_STATUS_SUCCESS)
> +			return -1;
> 	}
>=20
> 	sprintf(devname, "/dev/%s", devnm);
> diff --git a/udev.c b/udev.c
> index 72a38f47..5389e5df 100644
> --- a/udev.c
> +++ b/udev.c
> @@ -30,6 +30,7 @@
>=20
> static struct udev *udev;
> static struct udev_monitor *udev_monitor;
> +static char *unblock_path;
>=20
> /*
>  * udev_is_available() - Checks for udev in the system.
> @@ -145,3 +146,46 @@ void udev_release(void)
> 	udev_monitor_unref(udev_monitor);
> 	udev_unref(udev);
> }
> +
> +/*
> + * udev_block() - Block udev from examining newly created arrays.
> + *
> + * When array is created, we don't want udev to examine it =
immediately.
> + * Function creates /run/mdadm/creating-mdXXX and expects that udev =
rule
> + * will notice it and act accordingly.
> + *
> + * Return:
> + * UDEV_STATUS_SUCCESS when successfully blocked udev
> + * UDEV_STATUS_ERROR on error
> + */
> +enum udev_status udev_block(char *devnm)
> +{
> +	int fd;
> +	char *path =3D xcalloc(1, BUFSIZ);
> +
> +	snprintf(path, BUFSIZ, "/run/mdadm/creating-%s", devnm);
> +
> +	fd =3D open(path, O_CREAT | O_RDWR, 0600);
> +	if (!is_fd_valid(fd)) {
> +		pr_err("Cannot block udev, error creating blocking =
file.\n");
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		free(path);
> +		return UDEV_STATUS_ERROR;
> +	}
> +
> +	close(fd);
> +	unblock_path =3D path;
> +	return UDEV_STATUS_SUCCESS;
> +}
> +
> +/*
> + * udev_unblock() - Unblock udev.
> + */
> +void udev_unblock(void)
> +{
> +	if (unblock_path)
> +		unlink(unblock_path);
> +	free(unblock_path);
> +	unblock_path =3D NULL;
> +}
> +
> diff --git a/udev.h b/udev.h
> index 515366e7..e4da29cc 100644
> --- a/udev.h
> +++ b/udev.h
> @@ -32,5 +32,7 @@ bool udev_is_available(void);
> enum udev_status udev_initialize(void);
> enum udev_status udev_wait_for_events(int seconds);
> void udev_release(void);
> +enum udev_status udev_block(char *devnm);
> +void udev_unblock(void);
>=20
> #endif
> --=20
> 2.26.2
>=20

--=20
Coly Li

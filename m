Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91CD4C636D6
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbjBWNls (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:41:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234083AbjBWNlp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:41:45 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6E843446
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:41:45 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CEC6A349BD;
        Thu, 23 Feb 2023 13:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159703; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGacbU+RGE04rlCtX0KBd/7Q1ibbJdhSaDjlFJMCCx0=;
        b=oGZXKbJXw68tPurdXutfMAPajkCVdi1/EBOjT8+vBBbvOGrM/5B9inxBZzAVVytpfAyMSr
        0ti+y1zXCm8FDtH2qA3ukQ2HNQIKUGPp/iklLlJHUdkBVPiSdxpGNq7LSEfhPmwJTKVBX0
        31iveqACDerK1lM1/9dOsW+Qaps9DEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159703;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGacbU+RGE04rlCtX0KBd/7Q1ibbJdhSaDjlFJMCCx0=;
        b=CRuWopBMrPvOlODXJbqycF3s0CvO2khF/fjY/DHP2Gym6r5KmIfijxs9rRiKI3KBQkHl24
        +NfCn9pjBbcZv+AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EEEB3139B5;
        Thu, 23 Feb 2023 13:41:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wxUkLRZt92MOfQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:41:42 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 5/8] Mdmonitor: Refactor write_autorebuild_pid()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-6-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:41:30 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2B43CA8F-86CC-4B11-8DAD-FCFD98B9E598@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-6-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:03PM +0100, Mateusz Grzonka wrote:
> Add better error handling and check for symlinks when opening =
MDMON_DIR.
>=20
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Monitor.c | 55 ++++++++++++++++++++++++++++++++++++-------------------
> 1 file changed, 36 insertions(+), 19 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 39598ba0..14a2dfe5 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -33,6 +33,7 @@
> #endif
>=20
> #define EVENT_NAME_MAX 32
> +#define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
>=20
> struct state {
> 	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of =
"/dev/md/" + device name + terminating byte*/
> @@ -126,7 +127,7 @@ static int check_udev_activity(void);
> static void link_containers_with_subarrays(struct state *list);
> static int make_daemon(char *pidfile);
> static void try_spare_migration(struct state *statelist);
> -static void write_autorebuild_pid(void);
> +static int write_autorebuild_pid(void);
>=20
> int Monitor(struct mddev_dev *devlist,
> 	    char *mailaddr, char *alert_cmd,
> @@ -234,7 +235,8 @@ int Monitor(struct mddev_dev *devlist,
> 	}
>=20
> 	if (share)
> -		write_autorebuild_pid();
> +		if (write_autorebuild_pid() !=3D 0)
> +			return 1;
>=20
> 	if (devlist =3D=3D NULL) {
> 		mdlist =3D conf_get_ident(NULL);
> @@ -440,29 +442,44 @@ static int check_one_sharer(int scan)
> 	return 0;
> }
>=20
> -static void write_autorebuild_pid()
> +/*
> + * write_autorebuild_pid() - Writes pid to autorebuild.pid file.
> + *
> + * Return: 0 on success, 1 on error
> + */
> +static int write_autorebuild_pid(void)
> {
> -	char path[PATH_MAX];
> -	int pid;
> -	FILE *fp =3D NULL;
> -	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> +	FILE *fp;
> +	int fd;
>=20
> 	if (mkdir(MDMON_DIR, 0700) < 0 && errno !=3D EEXIST) {
> -		pr_err("Can't create autorebuild.pid file\n");
> -	} else {
> -		int fd =3D open(path, O_WRONLY | O_CREAT | O_TRUNC, =
0700);
> +		pr_err("%s: %s\n", strerror(errno), MDMON_DIR);
> +		return 1;
> +	}
>=20
> -		if (fd >=3D 0)
> -			fp =3D fdopen(fd, "w");
> +	if (!is_directory(MDMON_DIR)) {
> +		pr_err("%s is not a regular directory.\n", MDMON_DIR);
> +		return 1;
> +	}
>=20
> -		if (!fp)
> -			pr_err("Can't create autorebuild.pid file\n");
> -		else {
> -			pid =3D getpid();
> -			fprintf(fp, "%d\n", pid);
> -			fclose(fp);
> -		}
> +	fd =3D open(AUTOREBUILD_PID_PATH, O_WRONLY | O_CREAT | O_TRUNC, =
0700);
> +
> +	if (fd < 0) {
> +		pr_err("Error opening %s file.\n", =
AUTOREBUILD_PID_PATH);
> +		return 1;
> 	}
> +
> +	fp =3D fdopen(fd, "w");
> +
> +	if (!fp) {
> +		pr_err("Error opening fd for %s file.\n", =
AUTOREBUILD_PID_PATH);
> +		return 1;
> +	}
> +
> +	fprintf(fp, "%d\n", getpid());
> +
> +	fclose(fp);
> +	return 0;
> }
>=20
> #define BASE_MESSAGE "%s event detected on md device %s"
> --=20
> 2.26.2
>=20

--=20
Coly Li

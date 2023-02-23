Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E550C61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbjBWNln (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbjBWNln (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:41:43 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042DC42BC1
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:41:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id A656E2041B;
        Thu, 23 Feb 2023 13:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159700; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6R/Y0iy0+/oCxC3PwuTqbjDRtnEWm4SiYG6LXfIa1I=;
        b=kw21VxjmdXUepI7G93yf4b8PBbrTHkLOzmsPUk/RP+pV9vmKDfrIsz6WI4tt9qK+OOmCPy
        Yg9XTJke9GQKbdj7SPsOZIp+R8uAmnAIoC8CFIyh+QtOFxKKCdQp+m6s/xu2JdYVLvXjzW
        Apd12gyYJiVdwi0gbG1y8xcodA1fyYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159700;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=S6R/Y0iy0+/oCxC3PwuTqbjDRtnEWm4SiYG6LXfIa1I=;
        b=FjRtPaERpYEbLN/I5p/k+28iScVZ025plzBuhsVyLHdw+AtRxXrEMMZrRRxTbvuDUMZrCr
        Ts/LbB9g8Ig6aADQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B5712139B5;
        Thu, 23 Feb 2023 13:41:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GHEvHxNt92MEfQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:41:39 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 6/8] Mdmonitor: Refactor check_one_sharer() for better
 error handling
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-7-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:41:26 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC555496-3DCC-44AF-9076-2222E13DB32C@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-7-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:04PM +0100, Mateusz Grzonka wrote:
> Also check if autorebuild.pid is a symlink, which we shouldn't accept.
>=20
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Monitor.c | 89 ++++++++++++++++++++++++++++++++++++++-----------------
> 1 file changed, 62 insertions(+), 27 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 14a2dfe5..44918184 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -32,6 +32,7 @@
> #include	<libudev.h>
> #endif
>=20
> +#define TASK_COMM_LEN 16
> #define EVENT_NAME_MAX 32
> #define AUTOREBUILD_PID_PATH MDMON_DIR "/autorebuild.pid"
>=20
> @@ -224,7 +225,7 @@ int Monitor(struct mddev_dev *devlist,
> 	info.hostname[sizeof(info.hostname) - 1] =3D '\0';
>=20
> 	if (share){
> -		if (check_one_sharer(c->scan))
> +		if (check_one_sharer(c->scan) =3D=3D 2)
> 			return 1;
> 	}
>=20
> @@ -406,39 +407,73 @@ static int make_daemon(char *pidfile)
> 	return -1;
> }
>=20
> +/*
> + * check_one_sharer() - Checks for other mdmon processes running.
> + *
> + * Return:
> + * 0 - no other processes running,
> + * 1 - warning,
> + * 2 - error, or when scan mode is enabled, and one mdmon process =
already exists
> + */
> static int check_one_sharer(int scan)
> {
> 	int pid;
> -	FILE *comm_fp;
> -	FILE *fp;
> +	FILE *fp, *comm_fp;
> 	char comm_path[PATH_MAX];
> -	char path[PATH_MAX];
> -	char comm[20];
> -
> -	sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> -	fp =3D fopen(path, "r");
> -	if (fp) {
> -		if (fscanf(fp, "%d", &pid) !=3D 1)
> -			pid =3D -1;
> -		snprintf(comm_path, sizeof(comm_path),
> -			 "/proc/%d/comm", pid);
> -		comm_fp =3D fopen(comm_path, "r");
> -		if (comm_fp) {
> -			if (fscanf(comm_fp, "%19s", comm) &&
> -			    strncmp(basename(comm), Name, strlen(Name)) =
=3D=3D 0) {
> -				if (scan) {
> -					pr_err("Only one autorebuild =
process allowed in scan mode, aborting\n");
> -					fclose(comm_fp);
> -					fclose(fp);
> -					return 1;
> -				} else {
> -					pr_err("Warning: One autorebuild =
process already running.\n");
> -				}
> -			}
> +	char comm[TASK_COMM_LEN];
> +
> +	if (!is_directory(MDMON_DIR)) {
> +		pr_err("%s is not a regular directory.\n", MDMON_DIR);
> +		return 2;
> +	}
> +
> +	if (access(AUTOREBUILD_PID_PATH, F_OK) !=3D 0)
> +		return 0;
> +
> +	if (!is_file(AUTOREBUILD_PID_PATH)) {
> +		pr_err("%s is not a regular file.\n", =
AUTOREBUILD_PID_PATH);
> +		return 2;
> +	}
> +
> +	fp =3D fopen(AUTOREBUILD_PID_PATH, "r");
> +	if (!fp) {
> +		pr_err("Cannot open %s file.\n", AUTOREBUILD_PID_PATH);
> +		return 2;
> +	}
> +
> +	if (fscanf(fp, "%d", &pid) !=3D 1) {
> +		pr_err("Cannot read pid from %s file.\n", =
AUTOREBUILD_PID_PATH);
> +		fclose(fp);
> +		return 2;
> +	}
> +
> +	snprintf(comm_path, sizeof(comm_path), "/proc/%d/comm", pid);
> +
> +	comm_fp =3D fopen(comm_path, "r");
> +	if (!comm_fp) {
> +		dprintf("Warning: Cannot open %s, continuing\n", =
comm_path);
> +		fclose(fp);
> +		return 1;
> +	}
> +
> +	if (fscanf(comm_fp, "%15s", comm) =3D=3D 0) {
> +		dprintf("Warning: Cannot read comm from %s, =
continuing\n", comm_path);
> +		fclose(comm_fp);
> +		fclose(fp);
> +		return 1;
> +	}
> +
> +	if (strncmp(basename(comm), Name, strlen(Name)) =3D=3D 0) {
> +		if (scan) {
> +			pr_err("Only one autorebuild process allowed in =
scan mode, aborting\n");
> 			fclose(comm_fp);
> +			fclose(fp);
> +			return 2;
> 		}
> -		fclose(fp);
> +		pr_err("Warning: One autorebuild process already =
running.\n");
> 	}
> +	fclose(comm_fp);
> +	fclose(fp);
> 	return 0;
> }
>=20
> --=20
> 2.26.2
>=20

--=20
Coly Li

Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB28C636D6
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 13:49:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbjBWNtx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 08:49:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234761AbjBWNtv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 08:49:51 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC13D193F5
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 05:49:42 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7578034D68;
        Thu, 23 Feb 2023 13:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677159880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wg7+94C6rtfkswgu1c9RyuxlfOXd50zOiO9+NTU00Ak=;
        b=zDtv7JNUgyNYE4LIvjzZN1/7Frb0pICtheoP4txIj7j52Zk/V2ZNz/79xIZqQjlrtlVeaf
        BOftdbJPpFRtNZB3xd0/eaMqJN/dBtDlmAYrEaNN+UTsnJWzMs1fQJivdmPr1Iew5WIljy
        0nHvl+yJgOc/qaVw8reo4ISt03mEbHo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677159880;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wg7+94C6rtfkswgu1c9RyuxlfOXd50zOiO9+NTU00Ak=;
        b=ijnOoYz1DWVSpBgN12ZGnMbvIvsyWz60YXurHRFZS1s3NBjvPKHCiySMxnwVZXdK68Vl04
        zI2LzXLTK3PJZUBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9519613928;
        Thu, 23 Feb 2023 13:44:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id i7tcGMdt92OxfgAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Feb 2023 13:44:39 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH v3 4/8] Add helpers to determine whether directories or
 files are soft links
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230202112706.14228-5-mateusz.grzonka@intel.com>
Date:   Thu, 23 Feb 2023 21:44:26 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <90E090C7-C128-453F-B972-6E2644C93685@suse.de>
References: <20230202112706.14228-1-mateusz.grzonka@intel.com>
 <20230202112706.14228-5-mateusz.grzonka@intel.com>
To:     Mateusz Grzonka <mateusz.grzonka@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Feb 02, 2023 at 12:27:02PM +0100, Mateusz Grzonka wrote:
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> mdadm.h |  2 ++
> util.c  | 45 +++++++++++++++++++++++++++++++++++++++++++++
> 2 files changed, 47 insertions(+)
>=20
> diff --git a/mdadm.h b/mdadm.h
> index 13f8b4cb..1674ce13 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1777,6 +1777,8 @@ extern void set_dlm_hooks(void);
> #define MSEC_TO_NSEC(msec) ((msec) * 1000000)
> #define USEC_TO_NSEC(usec) ((usec) * 1000)
> extern void sleep_for(unsigned int sec, long nsec, bool =
wake_after_interrupt);
> +extern bool is_directory(const char *path);
> +extern bool is_file(const char *path);
>=20
> #define _ROUND_UP(val, base)	(((val) + (base) - 1) & ~(base - 1))
> #define ROUND_UP(val, base)	_ROUND_UP(val, (typeof(val))(base))
> diff --git a/util.c b/util.c
> index 9cd89fa4..5afb7c08 100644
> --- a/util.c
> +++ b/util.c
> @@ -2396,3 +2396,48 @@ void sleep_for(unsigned int sec, long nsec, =
bool wake_after_interrupt)
> 		}
> 	} while (!wake_after_interrupt && errno =3D=3D EINTR);
> }
> +
> +/* is_directory() - Checks if directory provided by path is indeed a =
regular directory.
> + * @path: directory path to be checked
> + *
> + * Doesn't accept symlinks.
> + *
> + * Return: true if is a directory, false if not
> + */
> +bool is_directory(const char *path)
> +{
> +	struct stat st;
> +
> +	if (lstat(path, &st) !=3D 0) {
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		return false;
> +	}
> +
> +	if (!S_ISDIR(st.st_mode))
> +		return false;
> +
> +	return true;
> +}
> +
> +/*
> + * is_file() - Checks if file provided by path is indeed a regular =
file.
> + * @path: file path to be checked
> + *
> + * Doesn't accept symlinks.
> + *
> + * Return: true if is  a file, false if not
> + */
> +bool is_file(const char *path)
> +{
> +	struct stat st;
> +
> +	if (lstat(path, &st) !=3D 0) {
> +		pr_err("%s: %s\n", strerror(errno), path);
> +		return false;
> +	}
> +
> +	if (!S_ISREG(st.st_mode))
> +		return false;
> +
> +	return true;
> +}
> --=20
> 2.26.2
>=20

--=20
Coly Li

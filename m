Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 109AFC19F21
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 12:50:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233422AbiG1Mup (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 08:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237970AbiG1Mun (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 08:50:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7BA140BD
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 05:50:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C4CFD1FA8A;
        Thu, 28 Jul 2022 12:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659012640; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnSel90MU0T5NQudvd7clLooeugw2H6hDjGnnGYtPYY=;
        b=IqeH/cWgO4ojmQZnVwPVJtb88BTY3DQBwwgACXgs/DDzb9OChOSMwbE0NGEJVtihhLWUmp
        udlzI0I5ttF3RCzjbIa1fALKTqBIU5UNmB5A1zNhG5lNuvEgp2j2WmQSE9qYcNyHQ2xmLx
        X26WfAAovVi2KQaTj5nzNhUN+0Vrm5A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659012640;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vnSel90MU0T5NQudvd7clLooeugw2H6hDjGnnGYtPYY=;
        b=Omjr472E2WCYC+W3ndE8UHfqbkWgD0SQZP9dcbfI8FczwBR3soR2muRf2b7H76TG9/Rw0q
        LlwGqft3Q6XKLUCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F8FA13427;
        Thu, 28 Jul 2022 12:50:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id UZ9BOR6G4mICNQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 28 Jul 2022 12:50:38 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/2] Monitor: use devname as char array instead of pointer
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220714070211.9941-2-kinga.tanska@intel.com>
Date:   Thu, 28 Jul 2022 20:50:33 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4CACC0E0-0F9D-4428-85CF-C968D6931EE8@suse.de>
References: <20220714070211.9941-1-kinga.tanska@intel.com>
 <20220714070211.9941-2-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8814=E6=97=A5 15:02=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Device name wasn't filled properly due to incorrect use of strcpy.
> Strcpy was used twice. Firstly to fill devname with "/dev/md/"
> and then to add chosen name. First strcpy result was overwritten by
> second one (as a result <device_name> instead of =
"/dev/md/<device_name>"
> was assigned). This commit changes this implementation to use snprintf
> and devname with fixed size.
>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

This patch looks good to me. I added my Acked-by and submitted to Jes =
today.

Thanks.

Coly Li

> ---
> Monitor.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 6ca1ebe5..a5b11ae2 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -190,9 +190,11 @@ int Monitor(struct mddev_dev *devlist,
> 			if (mdlist->devname[0] =3D=3D '/')
> 				st->devname =3D =
xstrdup(mdlist->devname);
> 			else {
> -				st->devname =3D =
xmalloc(8+strlen(mdlist->devname)+1);
> -				strcpy(strcpy(st->devname, "/dev/md/"),
> -				       mdlist->devname);
> +				/* length of "/dev/md/" + device name + =
terminating byte */
> +				size_t _len =3D sizeof("/dev/md/") + =
strnlen(mdlist->devname, PATH_MAX);
> +
> +				st->devname =3D xcalloc(_len, =
sizeof(char));
> +				snprintf(st->devname, _len, =
"/dev/md/%s", mdlist->devname);
> 			}
> 			if (!is_mddev(mdlist->devname))
> 				return 1;
> --=20
> 2.26.2
>=20


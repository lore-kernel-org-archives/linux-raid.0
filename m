Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F808C77B76
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:06:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbjBXQGK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbjBXQGJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:06:09 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EEF60132
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:06:08 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C125D3EA4B;
        Fri, 24 Feb 2023 16:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254766; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8yqLm8qPPviJMFAOOcx3mVURoqIUbKnkbiyitF7fEPw=;
        b=A8FESnyrZbza0QucsragkbwiWvl27QZs51iKa5I60FIGAYmiqbyxEX53KdJplGmEnjuV8r
        Tx8SD7LsLzP3vIxfMkfWv66V/riwj8rEWBGddkYYgket5pjpmLwa4meK82Tbpag2XJ+XkP
        E+SSx8qjzEWI2m3WgOwwfnPg9XjiD5E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254766;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8yqLm8qPPviJMFAOOcx3mVURoqIUbKnkbiyitF7fEPw=;
        b=x9skp5tHRHV1KfTYcQ3Hwma+vOUwf3N4GyzORbWxekGvYGygJANfOMSInGhHvAsivG3omq
        cFTjl7aRZQe8y6Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 26EC813A3A;
        Fri, 24 Feb 2023 16:06:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SN/lOGvg+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:06:03 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 7/7] manpage: Add --write-zeroes option to
 manpage
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-8-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:53 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <769A010C-6097-43FC-9852-EFC18A2B3386@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-8-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:54PM -0700, Logan Gunthorpe wrote:
> Document the new --write-zeroes option in the manpage.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Except for the typo,

Acked-by: Coly Li <colyli@suse.de>

Thanks.

> ---
> mdadm.8.in | 16 ++++++++++++++++
> 1 file changed, 16 insertions(+)
>=20
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 70c79d1e6e76..3beb475fd955 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -837,6 +837,22 @@ array is resynced at creation.  =46rom Linux =
version 3.0,
> .B \-\-assume\-clean
> can be used with that command to avoid the automatic resync.
>=20
> +.TP
> +.BR \-\-write-zeroes
> +When creating an array, send write zeroes requests to all the block
> +devices.  This should zero the data area on all disks such that the
> +initial sync is not necessary and, if successfull, will behave
> +as if
> +.B \-\-assume\-clean
> +was specified.
> +.IP
> +This is intended for use with devices that have hardware offload for
> +zeroing, but despit this zeroing can still take several minutes for
               ^^^^^ despite ?

> +large disks.  Thus a message is printed before and after zeroing and
> +each disk is zeroed in parallel with the others.
> +.IP
> +This is only meaningful with --create.
> +
> .TP
> .BR \-\-backup\-file=3D
> This is needed when
> --=20
> 2.30.2
>=20

--=20
Coly Li

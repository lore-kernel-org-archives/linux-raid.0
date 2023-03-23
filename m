Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9ED51C6FD1C
	for <linux-raid@archiver.kernel.org>; Thu, 23 Mar 2023 16:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbjCWQo0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232145AbjCWQoE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Mar 2023 12:44:04 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AEF3584
        for <linux-raid@vger.kernel.org>; Thu, 23 Mar 2023 09:42:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id F346E337E2;
        Thu, 23 Mar 2023 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1679589763; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8rMQZu7E5GucYoWPOJch1GlCD3bZXkoScm6XyFnoEM=;
        b=LEhf/aHpRo1cDj9U1sL16qn+Kb6tPM4oblInpSKwx1mW4pd5ORSNK5f4omOcokT7sMfCTy
        RxIEAZ5n8lr0bimOZm1UuccgTAEu3iijiAw1HwkXPHr8K2HM+syzO2vbN0nHHZPiteqHe+
        B2foSNNhT33TgGGTSseSsutT1AHwWxo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1679589764;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N8rMQZu7E5GucYoWPOJch1GlCD3bZXkoScm6XyFnoEM=;
        b=qdSMKeJDmQ9Qt2K5+GTrMfwJ6q9qUa5BK0+FI18QbQLiJnJerZTfiC9ZlX5M9Gsj9jjv5Y
        uQjv4qK4gsmvo3Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2BD7C132C2;
        Thu, 23 Mar 2023 16:42:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EuHeOoKBHGRfUQAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 23 Mar 2023 16:42:42 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.400.51.1.1\))
Subject: Re: [PATCH] Revert "Revert "mdadm/systemd: remove KillMode=none from
 service file""
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230323161318.25564-1-mariusz.tkaczyk@linux.intel.com>
Date:   Fri, 24 Mar 2023 00:42:30 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71199967-8DB0-48F1-BAF9-1FBB6FC8DE5B@suse.de>
References: <20230323161318.25564-1-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3731.400.51.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B43=E6=9C=8824=E6=97=A5 00:13=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This reverts commit 28a083955c6f58f8e582734c8c82aff909a7d461.
>=20
> Resolved by commit 723d1df4946e ("mdmon: Improve switchroot
> interactions.") We are ready to drop it.
>=20
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>


Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> systemd/mdadm-grow-continue@.service | 1 -
> 1 file changed, 1 deletion(-)
>=20
> diff --git a/systemd/mdadm-grow-continue@.service =
b/systemd/mdadm-grow-continue@.service
> index 9ccadca3..64b8254a 100644
> --- a/systemd/mdadm-grow-continue@.service
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -15,4 +15,3 @@ ExecStart=3DBINDIR/mdadm --grow --continue /dev/%I
> StandardInput=3Dnull
> StandardOutput=3Dnull
> StandardError=3Dnull
> -KillMode=3Dnone
> --=20
> 2.26.2
>=20


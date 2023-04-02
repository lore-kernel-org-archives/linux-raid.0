Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C35C8C76196
	for <linux-raid@archiver.kernel.org>; Sun,  2 Apr 2023 23:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230299AbjDBX4T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 2 Apr 2023 19:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230292AbjDBX4S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 2 Apr 2023 19:56:18 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1034A9EF1
        for <linux-raid@vger.kernel.org>; Sun,  2 Apr 2023 16:56:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B6B9A21A5A;
        Sun,  2 Apr 2023 23:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680479776; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUjdCIoiqZEct2U1dR2Ghwdr0hh287FGEIXIJanAMjA=;
        b=qDDbCAdVuYdxHtYOs9+DN1gvQcMULi0g0uKEkO2awJE10WYFQtE65VTS7Qjnemp6dOnxB9
        p+7Ny5jmJS7aMtlr7Cr35oKDezzJMfc9hIIkyK1SJJcP8OLV9zpyCIhJR8ohsX+Q7u61nu
        U9y/F9BOC7RsNtFqlbpd5E6Q5ZVjqmw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680479776;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CUjdCIoiqZEct2U1dR2Ghwdr0hh287FGEIXIJanAMjA=;
        b=64aaQTX9hzLs0sLKAiJuieHS3ENdygqNuH0W5OCmEU78DK4kQ6kzdeBToW2JMHnSbV9W8G
        Rd4bZw7P07LOr+CQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 835AF1342C;
        Sun,  2 Apr 2023 23:56:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6ShfDh8WKmRqcAAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 02 Apr 2023 23:56:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Hristo Venev" <hristo@venev.name>,
        Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org, "Hristo Venev" <hristo@venev.name>
Subject: Re: [PATCH] super1: fix truncation check for journal device
In-reply-to: <20230401200134.6688-1-hristo@venev.name>
References: <20230401200134.6688-1-hristo@venev.name>
Date:   Mon, 03 Apr 2023 09:56:12 +1000
Message-id: <168047977245.14629.9624022647798760855@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 02 Apr 2023, Hristo Venev wrote:
> The journal device can be smaller than the component devices.
>=20
> Fixes: 171e9743881e ("super1: report truncated device")
> Signed-off-by: Hristo Venev <hristo@venev.name>
> ---
>  super1.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/super1.c b/super1.c
> index f7020320..44d6ecad 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2359,8 +2359,9 @@ static int load_super1(struct supertype *st, int fd, =
char *devname)
> =20
>  	if (st->minor_version >=3D 1 &&
>  	    st->ignore_hw_compat =3D=3D 0 &&
> -	    (dsize < (__le64_to_cpu(super->data_offset) +
> -		      __le64_to_cpu(super->size))
> +	    ((role_from_sb(super) !=3D MD_DISK_ROLE_JOURNAL &&
> +		  dsize < (__le64_to_cpu(super->data_offset) +
> +		      __le64_to_cpu(super->size)))

You need to have extra unnecessary ( and ) in here.  But that doesn't
make the patch wrong.
Thanks for the fix.
 Reviewed-by: NeilBrown <neilb@suse.de>

NeilBrown


>  	     ||
>  	     dsize < (__le64_to_cpu(super->data_offset) +
>  		      __le64_to_cpu(super->data_size)))) {
> --=20
> 2.40.0
>=20
>=20


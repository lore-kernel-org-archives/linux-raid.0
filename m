Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01CCC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 21:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82EF260F11
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 21:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbhHQVkr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:40:47 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:37006 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbhHQVkq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Aug 2021 17:40:46 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 35BA91FF76;
        Tue, 17 Aug 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629236412; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7CdK+yImIeaTuX7m1HOABAmZUQtd8WYwVds/Rcss1E=;
        b=ag1HjlgsPQeoc3vMasHkbS3fT8Gs7BGi9djnrrfJ5bnMIy6ZauGmOsmvMFrOl5GKhEbvPd
        wYez3NucKU3pYUzkHCBH/DR/14Ri48C024MTsZMWwKtpp6DGBxnJNpW3PA/BswxdHX+tji
        Gl6E5j9R242zWlJ7pW2lS5n0ODLjDhA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629236412;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y7CdK+yImIeaTuX7m1HOABAmZUQtd8WYwVds/Rcss1E=;
        b=zoEPvpVcZwhzZ0KvdJggrMCZA+0NU5PujtY1+t8+Pb6Wq6N/4tJ0pNPjO0V+1BEkSVfI/0
        9HTAoGR0F2Oe+jBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D5A4013A77;
        Tue, 17 Aug 2021 21:40:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Vxy9JLksHGFfMwAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 17 Aug 2021 21:40:09 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Nigel Croxon" <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        xni@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH] Fix potential overlap dest buffer
In-reply-to: <20210817131448.2496995-1-ncroxon@redhat.com>
References: <20210817131448.2496995-1-ncroxon@redhat.com>
Date:   Wed, 18 Aug 2021 07:40:07 +1000
Message-id: <162923640700.9892.140398062433916759@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Aug 2021, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> error.  Overlapping_buffer: The source buffer potentially overlaps
> with the destination buffer, which results in undefined
> behavior for "memcpy".
>=20
> The change is to use memmove instead of memcpy.
>=20
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>

Reviewed-by: NeilBrown <neilb@suse.de>

Thanks,
NeilBrown


> ---
>  sha1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/sha1.c b/sha1.c
> index 11be7045..89b32f46 100644
> --- a/sha1.c
> +++ b/sha1.c
> @@ -258,7 +258,7 @@ sha1_process_bytes (const void *buffer, size_t len, str=
uct sha1_ctx *ctx)
>  	{
>  	  sha1_process_block (ctx->buffer, 64, ctx);
>  	  left_over -=3D 64;
> -	  memcpy (ctx->buffer, &ctx->buffer[16], left_over);
> +	  memmove (ctx->buffer, &ctx->buffer[16], left_over);
>  	}
>        ctx->buflen =3D left_over;
>      }
> --=20
> 2.29.2
>=20
>=20

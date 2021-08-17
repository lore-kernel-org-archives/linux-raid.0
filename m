Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDE2EC4338F
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 21:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE3F160240
	for <linux-raid@archiver.kernel.org>; Tue, 17 Aug 2021 21:53:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235450AbhHQVyF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Aug 2021 17:54:05 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45400 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbhHQVyF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Aug 2021 17:54:05 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E518D21FF0;
        Tue, 17 Aug 2021 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629237210; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZTkZG/CeUwhI9M+3xHL0cVKuVrV67GEbgxXFEuQQNQ=;
        b=njhsB+63WE/mnR6jfep/S06FatjBzFFrXya7bc6dClTJFXLd68dC9vevgsrCyXGKQoU5Ia
        hAHVkLBxj2OYZZze9x6E+BIwklBk8E48r5VNcrbRxnWWiZrjEn5VsBtMc3m0o6ajeSvrIf
        OtWoGroV5Y1RSE8A0oQ/S3OJuxmfWHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629237210;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZTkZG/CeUwhI9M+3xHL0cVKuVrV67GEbgxXFEuQQNQ=;
        b=ZRlw/y5ROXs6OJgPwr4zXYwkotBc4Oh4YjXtZiIxK0vUy4OWxJiBQO3aGQYxnMdMmY1LtA
        +gcPiNU3NARpWjAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 52E4713ABF;
        Tue, 17 Aug 2021 21:53:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LyGdBNkvHGGINgAAMHmgww
        (envelope-from <neilb@suse.de>); Tue, 17 Aug 2021 21:53:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Nigel Croxon" <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com,
        xni@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH] Fix buffer size warning for strcpy
In-reply-to: <20210817130611.2496090-1-ncroxon@redhat.com>
References: <20210817130611.2496090-1-ncroxon@redhat.com>
Date:   Wed, 18 Aug 2021 07:53:26 +1000
Message-id: <162923720646.9892.12533617772401180490@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 17 Aug 2021, Nigel Croxon wrote:
> To meet requirements of Common Criteria certification vulnerablility
> assessment. Static code analysis has been run and found the following
> error:
> buffer_size_warning: Calling "strncpy" with a maximum size
> argument of 16 bytes on destination array "ve->name" of
> size 16 bytes might leave the destination string unterminated.
>=20
> The change is to make the destination size to fit the allocated size.
>=20
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  super-ddf.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index dc8e512f..486183ed 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -2637,9 +2637,10 @@ static int init_super_ddf_bvd(struct supertype *st,
>  		ve->init_state =3D DDF_init_not;
> =20
>  	memset(ve->pad1, 0xff, 14);
> -	memset(ve->name, ' ', 16);
> +	memset(ve->name, ' ', 15);
> +	ve->name[15] =3D '\0';
>  	if (name)
> -		strncpy(ve->name, name, 16);
> +		strncpy(ve->name, name, 15);

This is not correct.
ve->name is *not* required to be nul-terminated.  It is a string that
can be up to 16 bytes long.  If it is less than 16 bytes, it is
nul-padded.
Probably the way to get coverity to stop complaining is to use memcpy.
   if (name) {
      int l =3D strlen(name;
      if (l > 16)
           l =3D 16;
      memcpy(ve->name, name, l);
   }

Probably the ->name should be initialized to '\0', not spaces.

  https://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.p=
df

describes the format.  Some fields are specified as being padded with
spaces, but not VD_Name (which is ve->name).
The field is specified as being either ASCII or "UNICODE" (which doesn't
make any sense as "UNICODE" is not a byte-encoding.  Presumably it means
"UTF-8") and that:
    If this field is not used, all bytes MUST be set to zero.

So it should probably be zero-padded.  But there is definitely no
requirement for it to be zero-terminated.

Thanks,
NeilBrown


>  	ddf->virt->populated_vdes =3D
>  		cpu_to_be16(be16_to_cpu(ddf->virt->populated_vdes)+1);
> =20
> --=20
> 2.29.2
>=20
>=20

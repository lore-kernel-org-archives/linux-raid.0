Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2AE8C4338F
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 23:23:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A614460E9B
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 23:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237883AbhHLXXw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:23:52 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:35332 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237877AbhHLXXw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 19:23:52 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 810E61FD68;
        Thu, 12 Aug 2021 23:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1628810605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf81c/yAbbuIw9Kfl1FPG3hO87qeoZhxkSsLPmM2Pss=;
        b=jAbbHA/4I7IWc1YcComTvk/hEutdNd9qWZXVChG1zxPvey9n5lDPIe5llKFigu8NsIqYCN
        qPSAycVQO34AWAghK3JA5L5/tixzD2HJtOpSrlQVMZR9Ge1yQ6R/OGsBF61HcIov//3F2D
        VpOxZGQpBMmOFD/Xm4y5AMQcVH3JhpI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1628810605;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yf81c/yAbbuIw9Kfl1FPG3hO87qeoZhxkSsLPmM2Pss=;
        b=eJnIcMRq+G9Vl4gGWMibB9iN6nthCCoAPkoA5CwFb0AHktTt10Vmb4E4eBNkmEhxCtyyl+
        AKFLP2OQOm3sDiBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2DCAF13A00;
        Thu, 12 Aug 2021 23:23:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7Mk/N2utFWHZAgAAMHmgww
        (envelope-from <neilb@suse.de>); Thu, 12 Aug 2021 23:23:23 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "Nigel Croxon" <ncroxon@redhat.com>
Cc:     jes@trained-monkey.org, xni@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH V2] Fix return value from fstat calls
In-reply-to: <346e8651-d861-45c7-9058-68008e691b93@Canary>
References: <20210810151507.1667518-1-ncroxon@redhat.com>,
 <20210811190930.1822317-1-ncroxon@redhat.com>,
 <162872237888.31578.18083659195262526588@noble.neil.brown.name>,
 <346e8651-d861-45c7-9058-68008e691b93@Canary>
Date:   Fri, 13 Aug 2021 09:23:21 +1000
Message-id: <162881060124.15074.6150940509008984778@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 12 Aug 2021, Nigel Croxon wrote:
> On Wednesday, Aug 11, 2021 at 6:53 PM, NeilBrown <neilb@suse.de (mailto:nei=
lb@suse.de)> wrote:
> On Thu, 12 Aug 2021, Nigel Croxon wrote:
> > To meet requirements of Common Criteria certification vulnerablility
> > assessment. Static code analysis has been run and found the following
> > errors:
> > check_return: Calling "fstat(fd, &dstb)" without checking return value.
> > This library function may fail and return an error code.
>=20
> In what circumstances might it fail and return an error code?
>=20
> NeilBrown
>=20
> Hello Neil,
>=20
> The fstat() function will fail if:
> [EBADF] - The fildes argument is not a valid file descriptor.

But we never pass an invalid file descriptor

And you didn't list "EFAULT", but of course we never pass an invalid
memory address either.

> [EIO] - An I/O error occurred while reading from the file system.

fstat() doesn't do IO, it just reports data from the cache.

> [EOVERFLOW] - The file size in bytes or the number of blocks allocated to t=
he file or the file serial number cannot be represented correctly in the stru=
cture pointed to by buf.
>=20
> The fstat() function may fail if:
>=20
> [EOVERFLOW] - One of the values is too large to store into the structure po=
inted to by the buf argument.
>=20

Those don't happen in practice for the fstat() calls that mdadm makes
either.

I think this patch is adding noise to the source code without actually
providing any real value.  I would much prefer that if you really feel
there is value, then just add a wrapper:

int  safe_fstat(....)
{
    int ret =3D fstat(.....);
    char message[]=3D"mdadm: fstat failed, so aborting\n"
    if (ret =3D=3D 0)
         return 0;
    write(2, message, sizeof(message)-1);
    exit(1);
}

Then just change every "fstat" in the code that bothers you to
"safe_fstat()".

This approach of adding pointless checks because some static analysis
tool thinks you should is not an approach that I approve of.

But, of course, it is up to Jes what patches he accepts...

NeilBrown





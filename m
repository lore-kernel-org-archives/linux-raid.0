Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F920C77B7F
	for <linux-raid@archiver.kernel.org>; Sun, 14 May 2023 11:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbjENLOr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 May 2023 07:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjENLOq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 May 2023 07:14:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6318187
        for <linux-raid@vger.kernel.org>; Sun, 14 May 2023 04:14:45 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7768D1F88B;
        Sun, 14 May 2023 11:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1684062884; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fviU152UOSBAAJD9t6Q+amM9HfIYGRyTR5ac22GaW/k=;
        b=uhFgTGnZ9xflBaOXfZMfOEm5XyJ5mUZmFWMcvqabGqz19aHB/7Cj5pjiSW1GQBfVst5JSB
        C3hHVhZfKatZd+MIHD2AR6FRdeSm5tSuEDiLfu23l0XKcFEjS4pA58mz3HJcNK+2WAMuF5
        t8yaSkIrqoDDaTfruplrldlJU0Uf43w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1684062884;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fviU152UOSBAAJD9t6Q+amM9HfIYGRyTR5ac22GaW/k=;
        b=dMac6KT3uH+XSvQEd1Z0vdzKJWxs9S4ZMnitxK/aGNYecNdBZgD41YSgqjtv0k4vPtfhyj
        HB83OuCmlfzTYWAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5E9FB138F5;
        Sun, 14 May 2023 11:14:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id DFswFqTCYGTfdQAAMHmgww
        (envelope-from <colyli@suse.de>); Sun, 14 May 2023 11:14:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH v2 0/2] Fix unsafe string functions
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230511025513.13783-1-kinga.tanska@intel.com>
Date:   Sun, 14 May 2023 13:14:33 +0200
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7E423237-21B0-4350-A3ED-E4AFF192C8BA@suse.de>
References: <20230511025513.13783-1-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3731.500.231)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2023=E5=B9=B45=E6=9C=8811=E6=97=A5 04:55=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> This series of patches contains fixes for unsafe string
> functions usings. Unsafe functions were replaced with
> new ones that limites the input length.

Hi Kinga,

I am on a travel and fighting with jet lag now, hope I can response next =
week after I back to Beijing.

Thanks.

Coly Li


>=20
> Kinga Tanska (2):
>  Fix unsafe string functions
>  platform-intel: limit guid length
>=20
> mdmon.c          | 6 +++---
> mdopen.c         | 4 ++--
> platform-intel.c | 5 +----
> platform-intel.h | 5 ++++-
> super-intel.c    | 6 +++---
> 5 files changed, 13 insertions(+), 13 deletions(-)
>=20
> --=20
> 2.26.2
>=20


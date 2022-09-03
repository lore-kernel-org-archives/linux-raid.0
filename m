Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B550C6FA82
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 07:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbiICHL1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 03:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICHLZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 03:11:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121B84C603
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 00:11:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A2B933368A;
        Sat,  3 Sep 2022 07:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662189083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKQFhrNUu6yRHtl6fGT4jvRElh5pPp1ItYrsxjVj6rc=;
        b=cmRv3cVgXtxwXOxJXDyNFae2Ni2kNqliuHXO2bcwEEPFmMOfpl9lZsc7jDJrgUxS3Uwdxm
        /GjZukvhknBA4SqGELwjtdrPFkDfh/zDSuzGTBmRSEpB+3WoF/bRf4WirGncJmMpWrWgLe
        2IbyDEZET1fMf/1SQYz1lnmtg+5HJvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662189083;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OKQFhrNUu6yRHtl6fGT4jvRElh5pPp1ItYrsxjVj6rc=;
        b=MWdIHh8mZSMt36CJl0ECrafffNldr1LL81bZdDwfPKYbZY874laugvryz2Vqs2xgVWXUOM
        2YDcez8yeVUVu1Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C2DE713517;
        Sat,  3 Sep 2022 07:11:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eaKIJBr+EmNEVwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 07:11:22 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v4] mdadm: replace container level checking with inline
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220902064923.19955-1-kinga.tanska@intel.com>
Date:   Sat, 3 Sep 2022 15:11:20 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CBEBAEB3-59DC-4756-9393-3709C0306F59@suse.de>
References: <20220902064923.19955-1-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=882=E6=97=A5 14:49=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> To unify all containers checks in code, is_container() function is
> added and propagated.
>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Acked-by: Coly Li <colyli@suse.de>


But this patch has a minor conflict with Mateusz=E2=80=99s =E2=80=9CManage=
: Block unsafe member failing=E2=80=9D series, it is simply because your =
patch landed a bit late than Mateusz=E2=80=99s.
I already rebased your patch in the mdadm-CI queue. After I finish to =
review all the pending patches, let=E2=80=99s see whether you should =
post a v6 version or I can post the rebased one for you.

Thanks.

Coly Li


> ---
> Assemble.c    |  7 +++----
> Create.c      |  6 +++---
> Grow.c        |  6 +++---
> Incremental.c |  4 ++--
> mdadm.h       | 14 ++++++++++++++
> super-ddf.c   |  6 +++---
> super-intel.c |  4 ++--
> super0.c      |  2 +-
> super1.c      |  2 +-
> sysfs.c       |  2 +-
> 10 files changed, 33 insertions(+), 20 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 1dd82a8c..8b0af0c9 100644
> --- a/Assemble.c
> +++ b/Assemble.c
>=20
[snipped]

> @@ -1809,7 +1808,7 @@ try_again:
> 		}
> #endif
> 	}
> -	if (c->force && !clean && content->array.level !=3D =
LEVEL_CONTAINER &&
> +	if (c->force && !clean && !is_container(content->array.level) &&
> 	    !enough(content->array.level, content->array.raid_disks,
> 		    content->array.layout, clean, avail)) {
> 		change +=3D st->ss->update_super(st, content, =
"force-array=E2=80=9D,


The conflict is here, and the rebased change looks like this,

@@ -1807,7 +1806,7 @@ try_again:
                }
 #endif
        }
-       if (c->force && !clean && content->array.level !=3D =
LEVEL_CONTAINER &&
+       if (c->force && !clean && !is_container(content->array.level) &&
            !enough(content->array.level, content->array.raid_disks,
                    content->array.layout, clean, avail)) {
                change +=3D st->ss->update_super(st, content, =
UOPT_SPEC_FORCE_ARRAY,=

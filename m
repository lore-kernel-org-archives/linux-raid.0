Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 465A7ECAAD4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 05:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiICF5q (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 01:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229952AbiICF5p (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 01:57:45 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A1022BCB
        for <linux-raid@vger.kernel.org>; Fri,  2 Sep 2022 22:57:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 4EAF720AE0;
        Sat,  3 Sep 2022 05:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662184663; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32Mud2svtUBF8HALhK3/wH2BMQRQ/yNAJOMeV3lbDY8=;
        b=i1nRUbRLCxo0LdRGY81WB4eQGY+So1tAKXbgSZVDBITW1nVa5prylFNEBy4VoEun2anoWI
        yNdulThHsuNMePoqAiiLHWFPjt0Pwk6ucALgfSn5+Ltqp8BKrkfEm0URI3m+QWgL3zynQe
        qa9PMWhM6eZJAqJTT8NT+ki+lXdsSxg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662184663;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32Mud2svtUBF8HALhK3/wH2BMQRQ/yNAJOMeV3lbDY8=;
        b=eDdNF3Y12syhrcliB7/OQOHNagy1khffBiLw/CRe8NCLfw0ZTGaQVEvk9EI9JSqwwcwHUc
        Gyb8Sxngy7+firAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 77D84139F9;
        Sat,  3 Sep 2022 05:57:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id TQeAEdbsEmMpQgAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 05:57:42 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 08/10] Change update to enum in update_super and
 update_subarray
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-9-mateusz.kusiak@intel.com>
Date:   Sat, 3 Sep 2022 13:57:39 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2E7253EA-FF33-4DED-A5F2-360FB619CE5E@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-9-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Use already existing enum, change update_super and update_subarray
> update to enum globally.
> Refactor function references also.
> Remove code specific options from update_options.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> Assemble.c    | 14 +++++++++-----
> Examine.c     |  2 +-
> Grow.c        |  9 +++++----
> Manage.c      | 14 ++++++++------
> maps.c        | 21 ---------------------
> mdadm.h       | 12 +++++++++---
> super-intel.c | 16 ++++++++--------
> super0.c      |  9 ++++-----
> super1.c      | 17 ++++++++---------
> 9 files changed, 52 insertions(+), 62 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 6df6bfbc..8cd3d533 100644
> --- a/Assemble.c
> +++ b/Assemble.c
>=20

> @@ -1813,7 +1817,7 @@ try_again:
> 	    !enough(content->array.level, content->array.raid_disks,
> 		    content->array.layout, clean,
> 		    avail)) {
> -		change +=3D st->ss->update_super(st, content, =
"force-array",
> +		change +=3D st->ss->update_super(st, content, =
UOPT_SPEC_FORCE_ARRAY,
> 					       =
devices[chosen_drive].devname, c->verbose,
> 					       0, NULL);
> 		was_forced =3D 1;

Hi Mateusz,

The above part doesn=E2=80=99t apply on my current mdadm-CI queue. Just =
FYI, after I finish to review all this series, I will ask you to confirm =
the rebased patch or repost another version.

Thanks.

Coly Li=

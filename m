Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62324C43334
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 17:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiFTRVt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 13:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232815AbiFTRVs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 13:21:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D321EADD
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 10:21:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BCC1C1FDE9;
        Mon, 20 Jun 2022 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655745706; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXmtPc51ax6QTonTxcdF2fFF18Om1BAvfpF6mb4Rmxo=;
        b=egxTQ+y0az3XQl8X+ylO+ZUDHErrgEtbVRYALb+yuitmpdB5erU/8siXvw6POYEkokdGMO
        hT6VOUsQneyJv3wTMDHFkjgjnUFvDJLE8fulP37YqkSSXHh+Lg0FE+HuzN8/U/GHvteQeM
        u068H/VCwORFVXV5+H3oRBSUhFhBaNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655745706;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zXmtPc51ax6QTonTxcdF2fFF18Om1BAvfpF6mb4Rmxo=;
        b=yOJZpszGO+aKOPUs/rDTbhD5HN9C0n4STuIIXYIgSUaGV3B7HJu4rA0RvshFr6NOLp35/z
        86ZWSb/PdmrZRWCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1055213638;
        Mon, 20 Jun 2022 17:21:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tJnsNamssGLILwAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Jun 2022 17:21:45 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220609074101.14132-1-mateusz.kusiak@intel.com>
Date:   Tue, 21 Jun 2022 01:21:43 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A520DF12-AC0A-4E2E-9E96-0FEEA001C4DC@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=889=E6=97=A5 15:41=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Grow_reshape should be split into helper functions given its size.
> - Add helper function for preparing reshape on external metadata.
> - Close cfd file descriptor.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Hi Mateusz,

Overall I am fine with this patch. Currently it dose apply on branch =
20220621-testing of the mdadm-CI tree. This branch is based on mdadm =
upstream commit 756a15f32338 (=E2=80=9Cimsm: Remove possibility for =
get_imsm_dev to return NULL=E2=80=9D) and stacked with other asked patch =
from for-jes/20220620.

I will response this patch after other queuing patches are handled by =
Jes. If the change is minor, I will do the patch rebase and inform you.

Thanks.

Coly Li

> ---
>=20
> Changes since v2:
> - removed dot from commit message
> - formatted commit description as a list
> - got rid of returning -1 in prepare_external_reshape()
> - changed "return" section in prepare_external_reshape() description
>=20
> ---
> Grow.c  | 124 ++++++++++++++++++++++++++++++--------------------------
> mdadm.h |   1 +
> util.c  |  14 +++++++
> 3 files changed, 81 insertions(+), 58 deletions(-)
>=20

[snipped]


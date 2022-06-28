Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FAFC43334
	for <linux-raid@archiver.kernel.org>; Tue, 28 Jun 2022 15:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348060AbiF1P4Y (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Jun 2022 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348036AbiF1P4Y (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Jun 2022 11:56:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0D836178
        for <linux-raid@vger.kernel.org>; Tue, 28 Jun 2022 08:56:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D4C8A1FAFF;
        Tue, 28 Jun 2022 15:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656431780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuboyOHs/zXWXO0BpIJHLwdflP8LkTWNzPjmEdboKfM=;
        b=uCbPZQ6+zcVN5BVOC0CpMdiWJzo+feWRZYM+PGo8ilq+d2Z75rBCyWcoHvdyozavRgIEtz
        k4MrkDecw7zG5RmaDCH14LN/YNH2JOuQONHimFNDefpU0CpB6S9ZnJyu3REm7hHrPK7TEJ
        X/CEUrEj9/YRCnAgCXSbVoDHsXPCEew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656431780;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wuboyOHs/zXWXO0BpIJHLwdflP8LkTWNzPjmEdboKfM=;
        b=jVs/nKNHD8N0wCVkGXiVTmMl+w6PrPK+OGRb9lG+y9qvcgGZujDpXXieMAJ0pH/yyffyz9
        NAgcvUzOUngLkPCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C244D13ACA;
        Tue, 28 Jun 2022 15:56:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id aQ2nIaMku2KGAwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 28 Jun 2022 15:56:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <A520DF12-AC0A-4E2E-9E96-0FEEA001C4DC@suse.de>
Date:   Tue, 28 Jun 2022 23:56:16 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <702B9063-D708-451A-A8F2-6DFD77728B9B@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <A520DF12-AC0A-4E2E-9E96-0FEEA001C4DC@suse.de>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 01:21=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>=20
>=20
>=20
>> 2022=E5=B9=B46=E6=9C=889=E6=97=A5 15:41=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>> Grow_reshape should be split into helper functions given its size.
>> - Add helper function for preparing reshape on external metadata.
>> - Close cfd file descriptor.
>>=20
>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>=20
> Hi Mateusz,
>=20
> Overall I am fine with this patch. Currently it dose apply on branch =
20220621-testing of the mdadm-CI tree. This branch is based on mdadm =
upstream commit 756a15f32338 (=E2=80=9Cimsm: Remove possibility for =
get_imsm_dev to return NULL=E2=80=9D) and stacked with other asked patch =
from for-jes/20220620.
>=20
> I will response this patch after other queuing patches are handled by =
Jes. If the change is minor, I will do the patch rebase and inform you.

Hi Mateusz,

I just rebased the patch and pushed to mdadm-CI tree into branch =
20220621-testing. This is the only patch in this testing branch. It =
looks fine to me, but can you help to confirm whether the rebase is =
correctly? The conflict happens in Grow.c:Grow_reshap().

Thanks.

Coly Li


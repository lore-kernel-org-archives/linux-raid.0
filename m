Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1988FC00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:09:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238148AbiHXQJt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237658AbiHXQJr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:09:47 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 041BAD61
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:09:44 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0BA223450C;
        Wed, 24 Aug 2022 16:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661357383; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlqjFWFulKvsk53toexsraMcf813JrXwF22Ra4gxQpg=;
        b=ZLE2Eckyx8bQS+8P1FrH7yNJ8kkSnsO9h24b7ZZO/uGHlkGUVKjj/WooFji3knM89y2ogD
        orxbS424deMVuh6gkw8NnMTiIUx7E070dIBl9AYCVCEKPYLjodEOlfRf4K40dHYbBRuVxo
        ADk7IkKu1cy4mVKYpjSmGJqHw3t9Lf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661357383;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NlqjFWFulKvsk53toexsraMcf813JrXwF22Ra4gxQpg=;
        b=YpHnefNtHddR2tKykN/YcMRt9Z+jwyimqYRoFAb/AQfuITaYQQtV+YKsXhiwSdk4SIO7ku
        qwgvr+3WvZRmv7Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 22A0213780;
        Wed, 24 Aug 2022 16:09:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fc0/MURNBmNHMAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 24 Aug 2022 16:09:40 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <42df7fa8-1a9a-afdc-5298-1850f5bce879@trained-monkey.org>
Date:   Thu, 25 Aug 2022 00:09:35 +0800
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <193A9B1E-ACB9-40C1-A6B0-BE0FC5C29753@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
 <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
 <42df7fa8-1a9a-afdc-5298-1850f5bce879@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8824=E6=97=A5 23:56=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 8/8/22 06:03, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B48=E6=9C=888=E6=97=A5 04:41=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>> On 6/9/22 03:41, Mateusz Kusiak wrote:
>>>> Grow_reshape should be split into helper functions given its size.
>>>> - Add helper function for preparing reshape on external metadata.
>>>> - Close cfd file descriptor.
>>>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>>>> ---
>>>> Changes since v2:
>>>> - removed dot from commit message
>>>> - formatted commit description as a list
>>>> - got rid of returning -1 in prepare_external_reshape()
>>>> - changed "return" section in prepare_external_reshape() =
description
>>>=20
>>> Hi Mateusz,
>>>=20
>>> Changes look good to me, but it no longer applies. Mind sending an =
updated version?
>>=20
>> Hi Jes,
>>=20
>> Please check the version I post to you in series =E2=80=9Cmdadm-CI =
for-jes/20220728: patches for merge=E2=80=9D (Message-Id: =
<20220728122101.28744-1-colyli@suse.de>), the patch in this series is =
rebased and confirmed with Mateusz, it could be applied to upstream =
mdadm.
>=20
> Hi
>=20

> I applied this one, but none of the versions applied cleanly. I had to
> play formail games to pull it out of your stack, as I am not going to
> apply a set of 23 commits in one batch without going through them.
>=20

These days I was in partner=E2=80=99s office and planed to repost the =
rebased version soon. If you don=E2=80=99t do the rebase yet, please =
wait for me to post a v4 version on behavior of Mateusz tomorrow.

> It's really awesome to have your help reviewing patches, much
> appreciated, but I would prefer to keep them in the original batches =
so
> I can pull them from patchwork, rather than trying to deal with the
> giant stack.

How about we improve the process like this,
1) I will continue to review and response the patches from the original =
emails, so patch work may track them as they were.
2) For all the reviewed patches are not handled by your after a period, =
let=E2=80=99s set it as 2 weeks for now, I will post a email with all =
the patches with their message-IDs to you as a remind.

Thanks.

Coly Li=

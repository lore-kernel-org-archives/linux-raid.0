Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1131C00140
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 16:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238635AbiHXQll (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 12:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239016AbiHXQlg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 12:41:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D035913F6F
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 09:41:34 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E5EED20A1E;
        Wed, 24 Aug 2022 16:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661359292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJqfIkyUZMrapSC7DE8OdHSZziE/vGI5pcrqI6Ymin4=;
        b=DX3dShBJqlpIJZk7W46fUtmFAT4zeZlOzk3qRLnbYUWiSO5Mb4goTTMmbrtzwAeLnlU9Cw
        MlgnVcn9gAxJZESbR1ZT97aJSAla+nxiMBUsY5bm+oYpHfj+eyANLkak4u4USbvR0wKMCb
        upWybhRrQwPYj5vwLtPfOLnwzuTStds=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661359292;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJqfIkyUZMrapSC7DE8OdHSZziE/vGI5pcrqI6Ymin4=;
        b=16ju66NSHO9S+mIC4xsKFOzTcG3E7HHS0sgl7Ss4hpU6o75FvyRCdmVLea6FTP9FA6Oz6V
        wcdUdDCvxwksLaDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2F83513780;
        Wed, 24 Aug 2022 16:41:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 68S6ALxUBmPiOwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 24 Aug 2022 16:41:32 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <f732cc9e-65d5-2b8a-cd66-20f99bc2d625@trained-monkey.org>
Date:   Thu, 25 Aug 2022 00:41:26 +0800
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1592EF9-D385-470A-B6A2-C774D3CC3BF7@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <9b885a13-21cf-3c9a-f320-c047301294de@trained-monkey.org>
 <2622AABD-75DC-41D4-9F1E-E958463E9FD0@suse.de>
 <42df7fa8-1a9a-afdc-5298-1850f5bce879@trained-monkey.org>
 <193A9B1E-ACB9-40C1-A6B0-BE0FC5C29753@suse.de>
 <f732cc9e-65d5-2b8a-cd66-20f99bc2d625@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8825=E6=97=A5 00:33=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 8/24/22 12:09, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B48=E6=9C=8824=E6=97=A5 23:56=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>>>> Hi Jes,
>>>>=20
>>>> Please check the version I post to you in series =E2=80=9Cmdadm-CI =
for-jes/20220728: patches for merge=E2=80=9D (Message-Id: =
<20220728122101.28744-1-colyli@suse.de>), the patch in this series is =
rebased and confirmed with Mateusz, it could be applied to upstream =
mdadm.
>>=20
>>> I applied this one, but none of the versions applied cleanly. I had =
to
>>> play formail games to pull it out of your stack, as I am not going =
to
>>> apply a set of 23 commits in one batch without going through them.
>>=20
>> These days I was in partner=E2=80=99s office and planed to repost the =
rebased version soon. If you don=E2=80=99t do the rebase yet, please =
wait for me to post a v4 version on behavior of Mateusz tomorrow.
>=20
> No worries, I already pulled some of it in, but you can check my repo
> and see whats there.
>=20
>>> It's really awesome to have your help reviewing patches, much
>>> appreciated, but I would prefer to keep them in the original batches =
so
>>> I can pull them from patchwork, rather than trying to deal with the
>>> giant stack.
>>=20
>> How about we improve the process like this,
>> 1) I will continue to review and response the patches from the =
original emails, so patch work may track them as they were.
>> 2) For all the reviewed patches are not handled by your after a =
period, let=E2=80=99s set it as 2 weeks for now, I will post a email =
with all the patches with their message-IDs to you as a remind.
>=20
> This sounds good to me! I think it's also fine to have a branch with
> everything applied for testing, it's just less easy for me to pull =
from.

Yes there is already. Every time when I post the reviewed patches to =
you, there is a branch for all the patches. For example currently the =
branches in mdadm-CI tree,
  remotes/origin/20220315-testing
  remotes/origin/20220406-testing
  remotes/origin/20220719-testing
  remotes/origin/for-jes/20220402
  remotes/origin/for-jes/20220620
  remotes/origin/for-jes/20220728
  remotes/origin/master

All the branches in for-jes/ are the patches I posted to you as email =
thread. You may take any one for your convenience. And the latest branch =
will be rebased against the latest mdadm tree before I post the remind =
email to you.

BTW, the mdadm-CI tree can be found from =
git://git.kernel.org/pub/scm/linux/kernel/git/colyli/mdadm.git

Thanks.

Coly Li=

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F164C43334
	for <linux-raid@archiver.kernel.org>; Wed, 29 Jun 2022 13:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiF2NO7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Jun 2022 09:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiF2NO6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Jun 2022 09:14:58 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A91E240AF
        for <linux-raid@vger.kernel.org>; Wed, 29 Jun 2022 06:14:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3C88E2201D;
        Wed, 29 Jun 2022 13:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1656508495; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX4Yd2XNtsd/yKooFrtbtBp1vyIfgkfpBCGSTA0XmKY=;
        b=PJKKHha7baJK2yRv2KHoNEw5z7SAOYmJKDlTBpuILJb/C73Tmw2dkH8w6GOqcXbWkwWlL5
        eNQKBNNI+EP0/UvEIQ+a8WKLViS9MTO2Yn7ofy8urPw3FrFXaAdnjVaAEeeSUn5t9JElBm
        okcTjMmErK8mya/5/1stxAOX7hB1SJk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1656508495;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DX4Yd2XNtsd/yKooFrtbtBp1vyIfgkfpBCGSTA0XmKY=;
        b=atbsrNP1JUwf08w39+mE72a7VKbrWM9RVZLCD47n67+guNGurGZOdcp+pT3Nqp0FlYJyLq
        dU8p1xFbUOHAI9Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C344F132C0;
        Wed, 29 Jun 2022 13:14:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RBluIENQvGJFaQAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 29 Jun 2022 13:14:43 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH v3] Grow: Split Grow_reshape into helper function
From:   Coly Li <colyli@suse.de>
In-Reply-To: <43497f54-7b9f-7ad3-b965-b9f83a3fbed3@linux.intel.com>
Date:   Wed, 29 Jun 2022 21:14:38 +0800
Cc:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6A7A82E7-3474-479A-9AEA-70334DC3AEA9@suse.de>
References: <20220609074101.14132-1-mateusz.kusiak@intel.com>
 <A520DF12-AC0A-4E2E-9E96-0FEEA001C4DC@suse.de>
 <702B9063-D708-451A-A8F2-6DFD77728B9B@suse.de>
 <43497f54-7b9f-7ad3-b965-b9f83a3fbed3@linux.intel.com>
To:     "Kusiak, Mateusz" <mateusz.kusiak@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8829=E6=97=A5 21:12=EF=BC=8CKusiak, Mateusz =
<mateusz.kusiak@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 28/06/2022 17:56, Coly Li wrote:
>>=20
>>=20
>>> 2022=E5=B9=B46=E6=9C=8821=E6=97=A5 01:21=EF=BC=8CColy Li =
<colyli@suse.de> =E5=86=99=E9=81=93=EF=BC=9A
>>>=20
>>>=20
>>>=20
>>>> 2022=E5=B9=B46=E6=9C=889=E6=97=A5 15:41=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> Grow_reshape should be split into helper functions given its size.
>>>> - Add helper function for preparing reshape on external metadata.
>>>> - Close cfd file descriptor.
>>>>=20
>>>> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
>>>=20
>>> Hi Mateusz,
>>>=20
>>> Overall I am fine with this patch. Currently it dose apply on branch =
20220621-testing of the mdadm-CI tree. This branch is based on mdadm =
upstream commit 756a15f32338 (=E2=80=9Cimsm: Remove possibility for =
get_imsm_dev to return NULL=E2=80=9D) and stacked with other asked patch =
from for-jes/20220620.
>>>=20
>>> I will response this patch after other queuing patches are handled =
by Jes. If the change is minor, I will do the patch rebase and inform =
you.
>>=20
>> Hi Mateusz,
>>=20
>> I just rebased the patch and pushed to mdadm-CI tree into branch =
20220621-testing. This is the only patch in this testing branch. It =
looks fine to me, but can you help to confirm whether the rebase is =
correctly? The conflict happens in Grow.c:Grow_reshap().
>>=20
>> Thanks.
>>=20
>> Coly Li
>>=20
>=20
> Hi Coly,
> I checked the conflict myself, and the changes on the branch also look
> fine for me.


Hi Mateusz,

Copied, I will submit this rebased patch with my Acked-by to Jes wihtin =
1 week, with other patches (if there is).

Thanks.

Coly Li=

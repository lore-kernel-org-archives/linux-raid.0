Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00632C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 16:13:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbiFTQNc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 12:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244538AbiFTQN2 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 12:13:28 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06447201A8
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 09:13:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B10A021B85;
        Mon, 20 Jun 2022 16:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655741604; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7M5/oMFe+T6OUABNgJ6wdpv72JNJMmkK5T+bAv4PWo=;
        b=WeRkT0r0uWDAsojkmxfx09krRL3It/SZyv/mngKdF8kOQI/zeQC6n7sn0b+EwoC5nn7656
        HYFgyAwQObGv5AJqNUTdFSJ58Y1PmrQEU7b3eQ1uvlw+t9VYiLC3ndIume8qPZ1haoqvP4
        UbUSMApHiGNirHx8lIxzCZgTFOPeA4U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655741604;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C7M5/oMFe+T6OUABNgJ6wdpv72JNJMmkK5T+bAv4PWo=;
        b=yDaUTah18dSOAb1QOxzeLu44lL+4Vlwb3jH3daZCvoXwPDLNVlv/PbjuwTPnk7gmf5JY3p
        XNfg6mu6ifgoYHDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 21F22134CA;
        Mon, 20 Jun 2022 16:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 57T6MaKcsGJIEgAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Jun 2022 16:13:22 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH] Revert "mdadm: fix coredump of mdadm --monitor -r"
From:   Coly Li <colyli@suse.de>
In-Reply-To: <5f9a4417-d044-a87e-3945-2c6b29278d8c@trained-monkey.org>
Date:   Tue, 21 Jun 2022 00:13:19 +0800
Cc:     Nigel Croxon <ncroxon@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        wuguanghao3@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <94FEEB40-1A39-4590-88CC-A3352366A541@suse.de>
References: <20220418174423.846026-1-ncroxon@redhat.com>
 <54144438-5b6a-60dd-6f62-e90e052772ee@redhat.com>
 <62ec6c6e-76b7-e705-7326-a82b59f337b8@redhat.com>
 <5f9a4417-d044-a87e-3945-2c6b29278d8c@trained-monkey.org>
To:     Jes Sorensen <jes@trained-monkey.org>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B46=E6=9C=8818=E6=97=A5 03:35=EF=BC=8CJes Sorensen =
<jes@trained-monkey.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 6/17/22 13:09, Nigel Croxon wrote:
>> On 6/14/22 10:11 AM, Nigel Croxon wrote:
>>> On 4/18/22 1:44 PM, Nigel Croxon wrote:
>>>> This reverts commit 546047688e1c64638f462147c755b58119cabdc8.
>>>>=20
>>>> The change from commit mdadm: fix coredump of mdadm
>>>> --monitor -r broke the printing of the return message when
>>>> passing -r to mdadm --manage, the removal of a device from
>>>> an array.
>>>>=20
[snipped]

>>>=20
>>> Jes, That is the status of this patch?
>>>=20
>>> Thanks, Nigel
>>=20
>>=20
>> Jes, Is there an issue with reverting this patch?
>=20
> The fact that I am swamped with my regular work and it hadn't made it
> into patchworks. It's applied now.

Hi Jes,

Since I don=E2=80=99t see this patch applied, so I send it again in my =
=E2=80=9Cmdadm-CI for-jes/20220620: patches for merge=E2=80=9D series =
with my Acked-by.

Just for your information. Thank you in advance for taking care of them.

Coly Li=

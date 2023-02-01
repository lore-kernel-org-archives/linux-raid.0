Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4CD9C636D3
	for <linux-raid@archiver.kernel.org>; Wed,  1 Feb 2023 14:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbjBAOd0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Feb 2023 09:33:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBAOdY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Feb 2023 09:33:24 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F9C18A83
        for <linux-raid@vger.kernel.org>; Wed,  1 Feb 2023 06:33:24 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E3C1621FEA;
        Wed,  1 Feb 2023 14:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1675262002; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbnd54z+7rmntZwwoIMEx7Ho9nN6k8/8Wj15vxviPDM=;
        b=MlDvKc4KOmad8/YWPW3pYtoo35zGdkDmsn4YUCqOf4PoIBPrEh57QgE7HewtA8KFN03MNe
        vkhrLTbeeUhEVmZPYoO17PwHgzpJG+4G7ss1VHa9nux/VXyA/jua0W8Y0pc6aKJOj9Y3og
        f5rzc2kbr04RD2QM9hVGoM477BFxVFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1675262002;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbnd54z+7rmntZwwoIMEx7Ho9nN6k8/8Wj15vxviPDM=;
        b=9LVRoCAD/Q+HPNuxD/G4utpRvDq+ghPrY7rW5v4uEzGohmy/jKjrRQJTiH90QuXnPozN7i
        rPkxIN3QiEnOq2AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CF9841348C;
        Wed,  1 Feb 2023 14:33:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xalXJS942mPxdwAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 01 Feb 2023 14:33:19 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 0/7] Write Zeroes option for Creating Arrays
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20230201150032.00003a4f@linux.intel.com>
Date:   Wed, 1 Feb 2023 22:33:06 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        Logan Gunthorpe <logang@deltatee.com>,
        Xiao Ni <xni@redhat.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <7839659F-6E65-4ECC-A5ED-505AE28ED285@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <CALTww2_veP=bkpz5Z03VjmF=0dH-D9WqD2+K5A9cBiK5Pb-USg@mail.gmail.com>
 <85822a83-f4cc-b699-d589-b6c5590b3f98@redhat.com>
 <753b5edc-9a34-dce3-051d-514f8d43f3cd@deltatee.com>
 <20230201150032.00003a4f@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

I will take a look and response after next week. This and next week are =
occupied.

Thanks.

Coly Li


> 2023=E5=B9=B42=E6=9C=881=E6=97=A5 22:00=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi Jes and Coly,
> Could you take this? I believe that it is ready to be merged.
>=20
> Thanks,
> Mariusz
>=20
> On Thu, 19 Jan 2023 10:39:54 -0700
> Logan Gunthorpe <logang@deltatee.com> wrote:
>=20
>> On 2023-01-06 00:53, Xiao Ni wrote:
>>> Hi Jes
>>>=20
>>> Just a reminder about this series of patches. =20
>>=20
>> Any progress on this? Should I resend it? I haven't heard much =
feedback
>> in a while.
>>=20
>> Thanks,
>>=20
>> Logan
>=20


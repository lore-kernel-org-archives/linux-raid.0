Return-Path: <SRS0=mN13=CW=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E476C433E2
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 23:49:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFEE921D79
	for <linux-raid@archiver.kernel.org>; Sun, 13 Sep 2020 23:49:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aim.com header.i=@aim.com header.b="YTIQreSA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgIMXtN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 13 Sep 2020 19:49:13 -0400
Received: from sonic305-22.consmr.mail.ne1.yahoo.com ([66.163.185.148]:44057
        "EHLO sonic305-22.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbgIMXtK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 13 Sep 2020 19:49:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aim.com; s=a2048; t=1600040948; bh=Cqb4aRTh31/i1ttKTE9d+p7VTYzILV+w+T0ZaQ8N2xk=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=YTIQreSAfX/iwu4kD0zBXAHYPLJeAqM9ZTlTmoGmDQME3G+OGtvYQ36ePDUZ7H83HAV1SgqvXJxxup34j6n9VJbUDfsB56vo39zVZtkjTWA/PE717bTCoLoBaP3eypdpju0ZklMqkt7I24hPIvvjs/bxX5FTfUqnDZ1d0rqNWfIn+v+sm1HQ4fg/LWQ7Kqd7erm34VrJYAnAf2g2yD5pSR+l54QUZ68wY/nojMCtJigTsfgPXiLbDOepUVLrSJ5keDBW+TROxY9N3NTnPCRthJfwIECUHbumFoivIYqFWK1wF201qCUC4ePkb0htJLgEx/eMQShHN3Q61SrH3lUNRw==
X-YMail-OSG: hnfxkFYVM1kFchSZyg.1Alanghu3FPHxf_7c29BUxp1IksD1BWriYAui3vTghlm
 e3hsUAcTQ4uXs3ncqY8TLFcLzHw5bRKODL.eQjDvR5Z0y.TNIyhtNqqwWBVBOccoEsjFZF0PJXD_
 mHqMalN1MtQdYLTMSCYdp7z9E6IfMyrL2cyq6dlv5EJfwRZ0xV2gc9hkw1Kv8PpGHE7SVXWMJg8S
 E43EjCSn9XzkW1IqNwOa2xVGcxuWXsfdXDjMKSX8pjRr_W0R50SugGAMQcO12.ngv41h1pMspspt
 nrGyhkihXuoR4rBNm48sOPfVAOIWGjqTTiiSNTu_fBUYQNj9w1f61XE5FJfn12uUl1HZoBnTEzdq
 3USa9xxod5HQ74mob_iu55y.L7j09LP8Qs4O9z1r1Q59s9RQCXIVhW8p82RH4KFglwzaaO6VqJkl
 TqPPqhbg8ldtNrqHO7YKRzxXfGtbdqIQnPUCsKWTJcU6l4dciiL4Ozhf0aJfVGxBzmQejjVqw9LF
 7i5oEKFxHGw0KkykhxUkWI8mt5JDtfI1p51sbFihO7Comz6efifA4rxhBgYs0LSAhADa5cELVITN
 8HjZ7p1KRRDKVajYm90ZBEWzLnRGLOY0SNVG7t7UE8lujfGz7D2MXS2Jh16m_Y7KjD3l3YB.JaxB
 jzDGq4tF3Z_taM_NBmQCf1pBbSg9LGVoEfNxXYZW.sPyGr0Q07Tvj0isKdp_bM7_GKfGe6UJjgWl
 F_gxppEiMam_CyZexb1JGiuGgnMQVUefHoE0p9yNHjPWaO55LhvnVZy3yMVCUUA0thmHdjQ5Uikt
 F5y7.6xDuHzuIz8wvFBDC.iVdYR9ITXMr6Md9cAx78mfoUo3ThsTqT_WmjL5e67_wuCghtUXW_CF
 lM_VPyPTj0JprFhLqjFb3i0zyM4t7szFWzXSIpR0aQWz5vVNT.hbqsfPiBrL8OMknnDCX_OM3yFK
 .YdGpu8qhUCegQNtDRyoQ71I2zq0XKcBVskEgj7uZ7X5tYl7PEh.87tU0Rpy9H7JElXn6dKMcLzs
 DGTzSt3ir4YnBSQ2mkBgqjCrXHgROIaWYWZpAYYGr.Vkr3sDoCgOHLplqAf2qXypC6QQJC_Yeh7t
 _JztGBg7oViKE8jkpkLKMQUw4pUZiFlvU_zfubwoSbGF5D.4DJ2.CEV4b4JAcVKVfPli4juSXAFR
 HnPB8h91TEXVjq_TzPepuV2rQ4bUhrUEGQEMotosAwCXppT7in_gxx9M057MfQAwJ5nyX23YQ_me
 ex2nCXP_k3njavxcP3.b3fkkrXmFbpa.5n2ZZkFPVPn.F3M7Dq5hTm_PZOhHzauW11e6G737l70J
 FI.i3l6liYwV4jacL0Lm6e6G8VJzsESsJIn.fo53msZUtRwtTGhMzTp_HD_JeB4se8Foe1DmEMKq
 7Ntw3YbZcE03x4KK2kcWgseglL5QLQtukOponZ1hWaSbfXEX9PnrR4TK4WANugcmmdwnK6NIP54o
 633n0z46NepFy281DxVyIb.xqJMBCTNUU
Received: from sonic.gate.mail.ne1.yahoo.com by sonic305.consmr.mail.ne1.yahoo.com with HTTP; Sun, 13 Sep 2020 23:49:08 +0000
Received: by smtp401.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID eeac3e4362928dcaf176a4a62878a862;
          Sun, 13 Sep 2020 23:49:05 +0000 (UTC)
Subject: Re: Linux raid-like idea
To:     Wols Lists <antlists@youngman.org.uk>,
        John Stoffel <john@stoffel.org>
Cc:     linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
 <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
 <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
 <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
 <24413.1342.676749.275674@quad.stoffel.home>
 <9ba44595-8986-0b22-7495-d8a15fb96dbd@youngman.org.uk>
 <24414.5523.261076.733659@quad.stoffel.home>
 <5F5E425B.3040501@youngman.org.uk>
From:   Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Autocrypt: addr=brianvanderburg2@aim.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <f9144d16-3c8d-821c-c951-1fb5e6a7d317@aim.com>
Date:   Sun, 13 Sep 2020 19:49:03 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5F5E425B.3040501@youngman.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.16583 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

OT, but I've got one of those 3x5.25 to 5x3.5 hot swap bays in my main
system and I love it.=A0 I'm using it with an LSI 9207-8i as my
motherboard only supports a few SATA connectors with several already
used, so needed something to provide more ports for future expansion for
my main system's storage.

For more drives, you can use one of those external drive shelf boxes.=A0 =
I
currently have the HP M6710 I got off eBay with all caddies for about
$100, which can house 24 2.5 hard drives in a 2U chassis and I've used
an LSI 9201-16e to access it (both HBAs flashed to 20.00.07 or something
like that).=A0 I've already tested it and it works great, though a bit
loud on the fans when powering on.=A0 My understanding is also if you hav=
e
more than one of these shelves you can daisy chain them via their ports
SAS card -> Shelf 1 -> Shelf 2, etc, even cycling back to the SAS card
for multi-path support (which is at the time over my head).=A0 My plan fo=
r
it is to put in my network closet once I get it cleaned out and cabling
ran better to provide whole-house NAS storage.=A0 I think there is also a=
n
M6720 model for 24 3.5 drives in a 4U chassis.=A0 There is also NetApp
shelf I was looking at but from reading looks like it uses a QSFP
connector on it's IOM, and the cables that converted from SFF-8088 were
quite expensive.


On 9/13/20 12:01 PM, Wols Lists wrote:
> On 13/09/20 13:50, John Stoffel wrote:
>> I know, I really need to buy another drive, but my main system is
>> full, so I *also* need to either get a new case, or one of those 5 x
>> 3.5" into 3 x 5.25" bay cages to make some room.  Decisions... decisio=
ns...
> I know I keep on saying it, but I really think I'm close to getting my
> new main system (and hence my development system) sorted, and I think I=

> need to buy one of those cages too.
>
> If you did get those two 8TB drives, you could still have your 8TB 3-wa=
y
> mirror without needing any more bays/sata-ports.
>
> My problem, of course, is if I'm playing with raid layouts I need as
> many disks as I can cram in :-) I'm counting 6 tucked away in my drawer=
,
> which means I'll almost certainly need to add an add-in 4-way sata card=
,
> and as those drives are a mixture of 500GB and 1TB, I'll probably split=

> the 1TBs into 2x500GB and ignore md complaining that I have multiple
> components on the same physical disk ...
>
> Cheers,
> Wol


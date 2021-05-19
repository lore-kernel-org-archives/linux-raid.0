Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E3E9C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 15:00:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D8C6135C
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 15:00:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242618AbhESPBz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 11:01:55 -0400
Received: from sonic316-9.consmr.mail.gq1.yahoo.com ([98.137.69.33]:33819 "EHLO
        sonic316-9.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhESPBz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 11:01:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621436435; bh=YvGtwm27aaU81dCDfujJ4sqAwK1sJE9s+Q010BikLQk=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=aB6bCtsO9CWkNZKqGYd0hl7o1Urz2W/djjutCNINM7vyfjHB63UGfzN4DEpsDGNKSTd5kdKCEcoGVNaZ06q3UoVpAYgMDwwFQMaz2M7ICJZFpNB6V3HTAYZ4abK1h60Hou9uEjMcxGB/Us78FFLnOVuxCvHKLnUOdcXbfHlbbdY=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621436435; bh=4cNZznf8Z5ImBo8jlLAmmfkO2FMqcJRsUcvMGED+2UB=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=A4vdbERX00S9X/E9GE6CsnmRAU2B0n3mDPnj/3fEdOlZL+8U34EZ2UK3BTzDx+igE7cn7r/E8V31f5ETekZgS+rGJq7LS3k4W+qHqOmEzCcip/GMugRekJ8YHne93Mr5mgR2OVKiJaO6AuFUNstmFBebqbxqYpO/P9OFXep4vn/e8vk8+cA4GxaMi96Rnl+J3WqzQwusieVBH2KRL5mXa73YvPNtmf94hfYVR/Jkl3mmZoXYgM2XP6b9bIFhXpwtPYeK/bLE0qBqkMDrX7OJhkmZXRz0q+wmerCntZdmcrrUpKz2Pl8EDxZINJjJA/oi8esZGyWnZP30LPNctV0UKw==
X-YMail-OSG: zCprrEwVM1ntHmxAnZYoE976x17D9EMXox3nByZGKAzElavaveULwIitTukLtgS
 vChpAfb3EMSaHgDRahjBjLs6VknzyVwFLxybiwHoJJEqIhCkbO7v3zOvKoFzzfIlu0gVLtFrV.hI
 pV60r3LKPn9qLr9VhH5pBD1oM7QTlzKAEvpMt.B3vjE5fLpKo_nNiqcVIop.fixva_qoIwWEjqYI
 sx1P1J8HI46V0Lr0JyrS_zn.fhQVFKt1stL4.QxJJb_FswNb25HoKoRa7g4h7bP.PYjCXOM_5ynQ
 x0LWqaaCdztFy22phfwQE.Urwv6_2cFRjZnliFAslVGQPwCMq9GR1BYrxbtpvjlQR7SrOK3uRWKb
 vrK_iRFI2iLs.HF2NsXECqbiP6rt_zUz8mwK33IwYqvbBOjmu2b6xPb3Lm2YaoKC7X25m2ki08PA
 fzhNOKyVk0tqL.kK1IMj6LH7KvgGqbiHqkN4GMibEO_UwnBg453zLuG8d.v.QF7BjSVOlIlJtNsn
 Om3Vq0vSYrXPvWWgQzOh0hQpz4.MCo._weQ57W0vb9PuEYmQqO1H_GHpxF.N_zNxNLxeUbvsiLy.
 ERHddSoAuyhxCw1c1ax7kVC4qLc_NFoc7JCwbAdOn0xTWamD18lPADwI9po_nfV9TJArL8ye2whC
 b.lmuaRCn10pccx5382aHnwgyjnA219Q5reBHEdrEtsUsTaOvPvF1MI3nUrpYem_27WO3WvVhDVK
 D8SE_bbbGkhEQ.K660x1vu41hFcGvHxhH1AfBLYYviQtHW4evOG5U0.z7MnKeidVWd2cPhABeXmA
 QYZ3meOjQEi3R.51I2qntzA9AwF4v.sMocDdfWmNR5k6pS8jDgSsXnoP8fRxDnPrMpHPnHyO0y1q
 XSwYMPsGrx3YeIF.3ddIE1Nr7OvLN7aitqUH3ZWaOLuaCNBDmeDsUepSKnhgv50ZacDjgN79yz1.
 CW3lZyhbcv7zeUHYPMSnI4.T1QIdpHprth4Gj3MzxwY3_M4yyMUjvjeafajdIm.NXbDffcinVNn0
 yUeSL.5.3BrydQWc413kF7LI8_0K9cGbYB42ypFT4NoRibwJ7f6ibmVSaq4OG_7Xxel2DWwRXi1T
 Op03lxPf1Bu7TjvjKw6jrlki52RCzcqDQOKTGXnA3tAWq.Z5uWIz._FD4kCVggafPLUZ56uRhbOV
 nyUdHmVqJrZBiClk6veSoBINm7ICkgCZJRVdpRWO9CQrbqQW0jxSGyDPeK7FSXffU9.7XojjlkhX
 S.QB7j.0F4mbsTx.IsQ3u2DgA4yA9aUn08rsBsU2SlLkEgodUcOgihYsRn4oiZDZofZWdQC_.Uun
 Xw6gfJHuSHm359UsscNcPiGthLGCBjC5u3aSbXU2VwfpTK8dUpe9gX1HhOrDdhJsG7Tn6UeF14EG
 HhphGogjW.5RoZP2HfNveTLmW3cW6SeKTElUgQbXcemSc0DsoiIHZ2TRmQHboAkKuROOfr3CLELr
 RxScaPzVCaYCKtYpZdy..jXR9Q9N.nvf.JdcRQID_fwj2j3Xn0W8A1wM37JnOJRU1pGH1BCa.cTf
 YOFtAX8XcU7xzXZq4N5G4.V7DiLKPWZg4LcEAuC4y_eb3.Ww9sCygWtmqufiGbNC5wW21jHzOL2G
 MZnlE7i7oASiGgloor3KH.Mu1a2tJLaLsPCH0HfF6DLNnMJxX9oh.mcqTN2.2hVD6VMlDxlURGXN
 BN.ZeYGwPI.SaeO7c.CWfXllEFd.QvBM4X_me0vSMfT.ZWfVYVOU992PoDJiiGfgABRfpmVAclqi
 DZ9udoQEib6ykYEtwVqDH6YlXaQkDZGtf7tPqJjlL.CfcnnxyF4DHNP4Jd14NB3ZzKn2BJqIOk6U
 e9AdsOAJjYvywoOAKKleLmDUs4JTF3JbZfeofcdXa.y4du1SzFlBJMLVrM331TqxGWm43z.k46SA
 W0ATOSmqu3vkNK2I2mTyvmuyuQKsDinuhFMm7uKRWp76cin26TPtKIn.5Xek4As1.yJYkuivhsdR
 wZGJDzbT7a28iDNuFuOAfS.xxyuY_CEIxDCPnmhyFVw9Jxp5QL2AySpXxGkNU5BG_1EH.KZld8Fg
 NW7qhyc044WuLPXSERKJRAQCGsW8b7uXTw1M03Tgutrx95_7tgHdi8MVnvORF8zS6labRlyuqXbs
 X2KuT52B3WrRIjltmzyXRF7IiqofT6TP8m6CXVM2zxu936XCB8bsbZrjAiR3Fas9YmijFSVXQrHS
 a0bWbA9TfbNCH2OnqvGbAZTXvRqcuTt.rVEA9kEm26apY4wuRgiEY0WEFb5zcMG3KvfWU4LQkQV.
 wBFnDTQXYBM3eKCyfp7uLvFDutyZ3MqYlcuqeRrACuOQCwuu2UZvaBk5Zp71qcmlO5R0sYZNLPJ3
 aS7BfnJIHpF_Yd2c3rpGGPYl00Cgo_5OOq19brQ--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 15:00:35 +0000
Received: by kubenode512.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6343efcbe355e0a9bd48abfe204b870e;
          Wed, 19 May 2021 15:00:33 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
 <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
 <20210519142027.o6qob6po43aaahcc@bitfolk.com>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <0326f206-662d-d077-64e0-dd3382117a49@att.net>
Date:   Wed, 19 May 2021 09:59:51 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210519142027.o6qob6po43aaahcc@bitfolk.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/19/2021 9:20 AM, Andy Smith wrote:
> Hello,
> 
> On Wed, May 19, 2021 at 08:20:19AM -0500, Leslie Rhorer wrote:
>> 1. Partitioning is not necessary.  Doing something that is not necessary is
>> not usually worthwhile.
> 
> I'm with you in that I prefer not to use partitions when I don't
> need to.
> 
> However, there are many reports of people suffering corrupted disks
> that ended up being due to their motherboard helpfully deciding that
> if it sees a disk with no MBR nor GPT then it should create its own
> at every boot.
> 
>      http://forum.asrock.com/forum_posts.asp?TID=10174&title=asrock-motherboard-destroys-linux-software-raid

	So to paraphrase the other fellow, "That is another reason not to use 
ASRock motherboards."  Indeed, it is IMO a far better reason not to 
support ASRock than it is to spuriously employ partitions.  Of copurse 
it is also just another reason to avoid Microsoft like the plague.

> So, I'm not going to rail against anyone who prefer to always
> partition.

	I am not going to rail against anyone.  They are their systems; they 
can do as they please with them.  Indeed, it is they are who are 
suggesting I should do something, not the other way around.  I suggest 
not doing it.  Honestly, it is not a huge deal, either way.

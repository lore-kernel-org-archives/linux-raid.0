Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8515C433E2
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 15:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675B120770
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 15:27:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=aim.com header.i=@aim.com header.b="lpfXrM5e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgIKP1G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 11:27:06 -0400
Received: from sonic308-9.consmr.mail.ne1.yahoo.com ([66.163.187.32]:39180
        "EHLO sonic308-9.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726184AbgIKP04 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Sep 2020 11:26:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aim.com; s=a2048; t=1599838015; bh=FQTnClQxsAHDJn8ile6DQu4OWWG05NkRJN777BhOBi4=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=lpfXrM5eFB030YFeVGakhVqyTnjcyrcWfdBnhwJPomKA5H7VF2HuhqOhCEpTYsU3gbcxUE23xUOHgKyldnBx2iYVDwwBL4KOYB12S7hRe8oJ7hAD39sdCrFuKU3yFLaKaeDOTwYINvpwIoOWbW73tna4pRjAuHQcezPB+e7sud5Trt45ovMaJgYDdjBxtRCICWc8rFFVuHpf7fmXbGtM1M1b2N6CnZdTZ9Fk4qD3Sw3AWLfjQAStM1GZ3UvQGaFXqIrMNr1FNw5EQg43yfwnSp4RHL13m8/7fg/pPqKIeanST52pkqYdQuyJC9kA6pyDSPcyzutMUKZ03Cuy/KQHqA==
X-YMail-OSG: iJv5bt0VM1kpVq5yWoOUmQon5VZMjEVA_1U3QzVg6zkbUaT_rYtcqvFCEpFgJoo
 U8zJQwNsYV0xB7kM.XC98YTzVh0Nr.u4NygjrCN_PUAHXHR1qF3BGe0vQkjTpLRnEaPAtSruSEqb
 JUBBikZOniT5aoOsQseqPaQMk.9MbJMl_WfVuKqVv4rgSm1ICdhrFNyZjJ_01_4c8OCbZl24BqYy
 rCoAjLEwaaaUkbEtgByrGXuVoV6D_6z0DHHGXD61C1UnA8KHTaHCQqfE3mPKg3maK2tyqh7U3xae
 tXGVXCPWvGBMcU6yjzveetUUy66g0IKx.3q39ckeKOeY8AgVQcFoSTRuxeticQsLu1r3cyNlDXod
 t92qLct_fxoKcJLOvZg0T4.kzTY0cerRLYWqiwX1b_n1lZ.iqhkscPi9n1UIuyJlGdK80aFbSGD_
 sJ2Yi9LAzltpivwCzl.eG3TEEW6OoUsHAPD5XeaSt1fFSrzhaUzqahYduOahmKSQJuGPd4Mx2uAM
 ZPeomlauB33h5Ayxip63W28DQRc1vHf2Y2ZMGtX5OH12rQR_co6Bl4KcgK084iVI4_uDPAdad6YZ
 sjzGW00p5uGFEKt2NmjB3FSo692z.ogJp7D_AFHyKjidUf.7WUU9J38MOu8lrREOP6yapN1ECcVG
 ELHJxUTVnnfZEIdAizbfe.TP3eIFWCJk14zeGh4XSSYi.0YEwfdpTi7xAP803S244CsR6T9WJbq_
 Wdfgn.VGJt.XTSPSjpV16i.slAASMOE5gCTXgJJ71Uc2QJWBlOJ5Xm4i0TkixJcrLo01vdUmRCID
 iYh4IMLOJxilZjes_ebSOx3Ksd3YFbz.yQC0eS9eRBEaYWGIuiho9mO926Y8cQsnRZV8tcWBNdMr
 X6I50gZ6S015O7.pTio0tyk8rh8zBN8e0laOuUZB0BFCX1qwijycTFt39DxJndOa.ZHG8U1EsQCz
 qtGQK9QXICUFLuHCelo4TZdt6z.h1SQ6YwYW1TA0T5vAFNitLKzBSx6pfSBzx3KzKYdn2tF1XFTT
 05OBjhbCnnui3EF7GOqsgJSH10Qb6bsOYYdfbZzIaFo.MYS1Raqcydw.K8QeP0aBQqfFgLx9HXgE
 619wclvuD.5awek9Z1eJQv115IV_ouH9TlFgMO_o0HE9ZIits.hNEuaKuzWupaWgOQ1fUoXDHiJ6
 Zx7I0.v2wQJ_0F5wNRzsDoFWE2ErZ6Hrx7HIXdzzErTQqfs3Coe0vYEYyV2aPEGa_RnoisLd_cEK
 FfvIVYbIOO0KtFqN0XnGN5eMgErQFzF66gyFCg05BNY7i.QZJyxafJFksOW41VLs1O9nMbeLaRtA
 axe6470bedLZcRQWToS7AnH03R_xTyV_rNN_PCsTf9Z00FCnZoKLdHLRRwiBBvNQNflw1rHW6VPN
 6oDEBBEIoDbLdMk1xd2TodPzv67AWL0ElGa2ox3GvBdNFAO7WVdKb6RMDqf5R93oKeMvjMnGoUca
 gQQixJwyruZI4k_LMxsSmbag-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Sep 2020 15:26:55 +0000
Received: by smtp406.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID cfd1189744fecf835cb701f572df204d;
          Fri, 11 Sep 2020 15:14:38 +0000 (UTC)
Subject: Re: Linux raid-like idea
To:     Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
From:   Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Autocrypt: addr=brianvanderburg2@aim.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
Date:   Fri, 11 Sep 2020 11:14:37 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <5F54146F.40808@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Mailer: WebService/1.1.16583 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.aol Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On 9/5/20 6:42 PM, Wols Lists wrote:
> I doubt I understand what you're getting at, but this is sounding a bit=

> like raid-4, if you have data disk(s) and a separate parity disk. Peopl=
e
> don't use raid 4 because it has a nasty performance hit.

Yes it is a bit like raid-4 since the data and parity disks are
separated.=C2=A0 In fact the idea could be better called a parity backed
collection of independently accessed disks. While you would not get the
advantage/performance increase of reads/writes going across multiple
disks, the idea is primarily targeted to read-heavy applications, so in
a typical use, read performance should be no worse than reading directly
from a single un-raided disk, except in case of a disk failure where the
parity is being used to calculated a block read on a missing disk.=C2=A0
Writes would have more overhead since they would also have to
calculate/update parity.

> Personally, I'm looking at something like raid-61 as a project. That
> would let you survive four disk failures ...

Interesting.=C2=A0 I'll check that out more later, but from what it seems=
 so
far there is a lot of overhead (10 1TB disks would only be 3TB of data
(2x 5 disk arrays mirrors, then raid6 on each leaving 3 disks-worth of
data).=C2=A0 My currently solution since I'ts basically just storing bulk=

data, is mergerfs and snapraid, and from the documents of snapraid, 10
1TB disks would provide 6TB if using 4 for parity.=C2=A0 However it's par=
ity
calculations seem to be more complex as well.

> Also, one of the biggest problems when a disk fails and you have to
> replace it is that, at present, with nearly all raid levels even if you=

> have lots of disks, rebuilding a failed disk is pretty much guaranteed
> to hammer just one or two surviving disks, pushing them into failure if=

> they're at all dodgy. I'm also looking at finding some randomisation
> algorithm that will smear the blocks out across all the disks, so that
> rebuilding one disk spreads the load evenly across all disks.

This is actually the main purpose of the idea.=C2=A0 Due to the data on t=
he
disks in a traditional raid5/6 being mapped from multiple disks to a
single logical block device, and so the structures of any file systems
and their files scattered across all the disks, losing one more than the
number of available lost disks would make the entire filesystem(s) and
all files virtually unrecoverable.

By keeping each data disk separate and exposed as it's own block device
with some parity backup, each disk contains an entire filesystem(s) on
it's own to be used however a user decides.=C2=A0 The loss of one of the
disks during a rebuild would not cause full data loss anymore but only
of the filesystem(s) on that disk.=C2=A0 The data on the other disks woul=
d
still be intact and readable, although depending on the user's usage,
may be missing files if they used a union/merge filesystem on top of
them.=C2=A0 A rebuild would still have the same issues, would have to rea=
d
all the remaining disks to rebuild the lost disk.=C2=A0 I'm not really su=
re
of any way around that since parity would essentially be calculated as
the xor of the same block on all the data disks.

>
> At the end of the day, if you think what you're doing is a good idea,
> scratch that itch, bounce stuff off here (and the kernel newbies list i=
f
> you're not a kernel programmer yet), and see how it goes. Personally, I=

> don't think it'll fly, but I'm sure people here would say the same abou=
t
> some of my pet ideas too. Give it a go!
>
> Cheers,
> Wol


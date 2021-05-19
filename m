Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4CA8C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 23:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95FE861006
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 23:46:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhESXr4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 19:47:56 -0400
Received: from sonic312-27.consmr.mail.gq1.yahoo.com ([98.137.69.208]:33787
        "EHLO sonic312-27.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhESXr4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 19:47:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621467995; bh=KzsAPOscSUDI+4A1TXownYQF0RIaLR0+44NHb1axkwc=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=Lyb3SWjJJIdK+5sgWqfhK9e8wFUA3+ARY1ISWD0w5+CaZuxK9V0k9xC8H/0OnTq2YrQzBdOjf9Fm8h0ni9XNgwCpQjYM0RMFocQlPas2TwGjMNqtEy7X+nqisJqV1jevwYUIfH8cuHLuAskeV1D3aWFVAzBFqkkwduJDWz5xM1Y=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621467995; bh=KOqk+avceNhpcOJ2H1MCesz7VQ2+FMGz9GnhwMHhqC+=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=ncKOaZHxYyl4+5AU+NxOtMTSOcWonS5Lua035XyhtGrWuK7RHIbfoTCYzGWOcuffUN1ttntJaePHD/wgK/wZzbh+RPe+VE9/+LcEVlY6qLx4dvyKacgmo2A6QRbDwuV20zvKNUaly11QaP/OAcKhshzDMsbICo9l1s/+OWvMXbvdL2jEmm9nYoqKzLS68nG+Jd/X8gmuWFFFHQgpiDZxLAGwW6goxUkRz3sJd/3n+MhCXWlogUbKe/VGnx6zWfs2PRTMssIV5/G7yT8QfEflFWNLs/0oFRnNOyfO8HI5kZTI5JaPOSJ752G6F87WVYgoBAP+5hHJ9guH7U+Qa9iLJQ==
X-YMail-OSG: rP44ryAVM1lA0l.LT5sIErDAajoYEyVAvjeS.NDtEdW8fmHAJmy4eqZvB84RNsK
 Sd9tq0F1R8RoIuwigQJbTX1_Aia63PSf75I.cgb6C5X2igbNPMe4fH1FrX_wmFxrmQz6jSomn6be
 NJZL_SgZOPzPiu0nr6ZgmU_pJfCLloSuXSAIMURX.0aZ4B667r7WRugZt7PEZVAOeKtbooBYPcbc
 AUb1oiWh4a.kTKAvT2U62DQpgV84hbmGnHZ.42Lg.Yn_IE3Ce5DebRi4FSz5yucwxbEneS44Gyv4
 u.NclHV06hi_dpBMMsCjOrtive2_rkKoM_fg..QRxDCG8g7XdegykdhE8HUca9AyzBnCldsrp35a
 Sungq7bP37lX3_7vrqHZyZJbFjtQDo8ru0pGEUqZwmStow5CKszRvKVpWVyjQJXmgcRq1_tDyeOe
 TJD0qTtpRnb4SFCIe4SRa37YJARw77jzGFpCl6kH9QyEtlulb5QDMZ1VWLXdR41UxTCJIa.LtYgj
 inJR5kZzF8U_AKhirafVHPhyLB9c3TJolAQn.6kdDccqFO5SF_p_iWxmtV7z6YYcS7VY0VR9f_6k
 F829.gy16pNkVN9q5pilYyjZKSq8bFj6LDwe_5M5BeLR9AolxllmlDoi6Pb9KAdITiNvcE7CeY0T
 61TeXUIeCQlnRN_uW9kWXu.oaBJcldtg3RgnaXajVLTRh_Cjpj9kgJOCeK3MYChyYyXzbkDzOwsp
 H4Ri6fMoil2aDRj0kcLXr5B4abDckCoqU4XiDPHCG1htLGEi5n0puzWn7yP41FTujCH8AHOyBeR1
 hHgFhqwoxZrbwvWp2mBkPvquhzcbI0wysmkDLdMwL9bM_3dGtboEZodiga9GFuHo2Kag5x.gebzN
 toP_UxhKBzy7M4afgrD0oUscZteq5tQgp9BXXvc8t8ZYfXywUJ0M__PQUaXjXLjPqJWV0yLfx9JZ
 jk4809LPIRnAGuAgmyWwiEUiDD2RGhWKtKiL9dvBnAB6HsGfbrtCism891V4fbslkT5_.E6DQFQB
 7KGZh2aQMJ1QHlOd5VUl7t4NjmimTAn.ksepQNUyGlvd09v..K2fgcv4CJ9460hjJSqL0ifq6JX1
 xixGljg6JXTC6rdAmCM.n5TtJ51tRah5j8RZq0qnzCsU7mBFpMdkH9Fj1N852AFqr_5VV3xWwIH7
 6tFPo7iKduHkOhbc9NPaNKDQRymljQKV5ZGyzbCr_HNFKIr5ylNXPc5nOLjsrxSApmRFqOQYTERg
 _kA1Q6TYvWTQdplIqid7H5gxnYgUaCwK8sPYRLT9R1QNC3sWBP4mQ4QwZhx9mUOFtlWyog_a7Ay6
 xOKOmzCiszxW1ntRBlYwUOqF2EsDatsof9rfi404iptrh6Za2AIJrr6vJsGB0bs5j2E2gVKGHIE0
 NE5oH0dhWE1IzvGZhGMJ1hgLmKs8isUmGIVHKur54RA4sZEizy08QgEmjUN8D9YWCzJ0gb4Z5EsV
 h6Xf43S6GBRgudJPRSC4hKF4hCSgWGu58qFgSdnnHbhac6on2D2HJLqiUSq9Cxq86MvXF9zy3U2o
 2PcVjD8ad3SNcoOBotomBnvo0d13Qxax06Fb2gi8RSHx3ZGcwWjsjnODKq_G.oE2W7XSLuf_wF4U
 94ENmGrQUfnirU7KrsHra2Mib16TXKqr83QcXMEp7wHzhLshUmQ7qPAjSrUtgkv_qJcBcMmZpmq3
 PVLygBU_p6tV89.Ujdj3uNscHhAvjbMq0eay1uYzAS78AOsQGggR4A5.uqSJoZSn.5hJOZdakyIi
 q6Oh3WaaerBi7NDW3Remq4wc3.KWfq3eJJTCFtNxEgB3gXW7Xje2dbLkvFu8V7xb_4GWMU0WAAxU
 8vQ4v5QCdwxS1pgajiA5NjDwcWgDzOzdrYNyJbiofhYlLl2zNaZv9UrI7EqLuhm_DlZ78_VW62WM
 sZnG1amjRHfjNFD_Nl4LsFKFUyjdGitcFQse5tED_uj_YFJhHzBG.O8D06IMytmxML_k5yYLbyaM
 J8KhuP_sNXuwy91MIEeP8Vl8VFPWBfTZUpeC8RrrRR2g4Z.oecvYxnPZfo9U.XBWdUiWKdLIhIVb
 BOKZ.IFR0bi6K4mU0mae_oRtWs6G757rW6fFeu0rmsPRh9hD8MJBW35E0Dh2gwydqmtxsosd30eK
 o6AtCn8zvLXDiPsK3wrp5y2HvqanyopYNZo6.KcGAt1gZVH8bkcAuyEew8Or00UvyFwnKBFV7KKx
 YzM.15dG8DvbqEvAd85tGdS8.MzRbOr_QBieBI2GL3vNgz2IouOFbRopx71JynxDfHrPeQaiVF5p
 8z5d6iElWKjzmmmKrfzh2GQQ6Adpy62VZji2EMnKa84wX_MUYFtxP8tNOeQjaspIKGHbbn6GbFta
 gsZLI7WZJkIkSM7HeIdFQBygj.iPw8pAWXxIwPU0HR8V2i3tPZdayU4_lNdRuFNwrSBwv5XtbnIv
 I4aTw3nUqs6DE
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 23:46:35 +0000
Received: by kubenode561.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID a835d52dce0b5731055ae7ab8f447e6f;
          Wed, 19 May 2021 23:46:33 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     antlists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
 <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
 <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <60de3096-95e8-ca32-3c83-982bf8409167@att.net>
Date:   Wed, 19 May 2021 18:45:47 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/2021 3:01 PM, antlists wrote:
> On 19/05/2021 20:01, Leslie Rhorer wrote:
>>> The ONLY time you can be reasonably confident that running --create WILL
>>> recover a damaged array is if it is still in its original state - no
>>> drives swapped, no admin changes to the array, AND you're using the same
>>> version of mdadm.
>>
>>      That's a little bit of an overstatement, depending on what you 
>> mean by "reasonably confident".  Swapped drives should not ordinarily 
>> cause an issue, especially with RAID 4 or 5.  The parity is, after 
>> all, numerically unique.  Admin changes to the array should be 
>> similarly fully established provided the rebuild completed properly.  
>> I don't think the parity algorythms have changed over time in mdadm, 
>> either. Had they done so, mdadm would not be able to assemble arrays 
>> from previous versions regardless of whether the superblock was intact.
> 
> 
> You said there's only three possible combinations of three drives. Every 
> change I've mentioned adds another variable - more options ...

	I meant 6, not 3.

> The data offset is not fixed, for one.

	All of the data offsets were 262144 sectors in the listed Examine were 
262144 sectors.

> Swapping a drive could mean 
> drives have different offsets which means NO combination of drives

	I think not.  That is to say, it is certainly not impossible for it to 
change, but it is quite unlikely.  For one thing, if the offset is more, 
then all the data will no longer fit on the device, which would be a bit 
of a disaster.

	My main arrays consist of 8 drives each.  Every drive in both arrays 
has been replaced numerous times, starting with 1T drives more than 10 
years ago.  Now they are all 8T drives.  All 16 have data offsets of 
262144 sectors, just like the report from his drives.  Note I have seen 
arrays with different offsets, and of course any array on a partition 
will have a different offset.

	So while it is possible the offsets on his drives have changed, it is 
not at all likely.  Again. likely or not, it will not hurt for him to try.

> Yes you can explicitly specify everything, and get mdadm to recover the 
> array if the superblocks have been lost, but it's nowhere as simple as 
> "there are only three possible combinations".

	The number of permutations of the order of three drives is precisely 
six.  The permutations are:

1, 2, 3

1, 3, 2

2, 1, 3

2, 3, 1

3, 1, 2

3, 2, 1

	The Examine stated it was 2, 3, 1, but the device order is not at all 
unlikely to have changed.  Once again, I was very explicit in saying the 
simple create may not work and if not he is facing some much more 
serious issues.  That was and is in no way incorrect.  The odds one of 
them will work are not terrible, and if so, he is in good shape.  Are 
you seriously implying there is no way any of them could possibly work? 
  Are you seriously suggesting he should not try the simple approach 
before digging deep into the data to try to figure out all the 
parameters when the system was shut down?

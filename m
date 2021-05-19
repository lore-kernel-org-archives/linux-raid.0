Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF64BC433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 13:21:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88BD7610CC
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 13:21:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346736AbhESNWY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 09:22:24 -0400
Received: from sonic313-22.consmr.mail.gq1.yahoo.com ([98.137.65.85]:37135
        "EHLO sonic313-22.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240404AbhESNWX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 09:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621430464; bh=Ru4KxLFO2uJi+W1Wiysu1fPa6v742lvM6cH2r4VYhG4=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=u2XyzAtJcRe9bRsbi4PUXK7NDYkfFk1gBZAGgx9xceZw9XWIhiasZu5T6CaxiHwzpejMg/eOz2j5Ob8r0+Oa0atpCAmqtzIneH7O5OUO5DluhqB7up/nO166SGxPAkIc284r/eUSSiU3N02FJtWhuMaE/jLQHEYfZZfm0KR3qn4=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621430464; bh=yuMtySS+rpwj7nkePN37bXE3V+yLWZU+UIQSt3sIssC=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=nuNC94Ha0QL7Tt+D5cwz29/DRJPOIZe4GgLcR5Wm/vOi1Ical7Y90rUs5go0Bagq8NATm35vs7kpcldIOSE8hxDjI4wODWmKEYreNzV32o2yGLTHKaaaqDLJ91Y6Xtf11muvYcOHnuzxGi6/3A96mjYhcwsIOn0DU7ns6WWmRB586nvsjjYoC8qFgJLBoNd4SPYTds/BM/NZ39aHeLbjBgdRbUwNj/SfM/0WNumUi6rlu1pcOGB0QJHMaaP3MtET0BfIjHRwW9CgTxQ0crL03nINSG8T/mo/wybfG1zCFSEVoExKXJxC82L/m2mKqZW3tDs0fBAfCjBQQijO8cTbQA==
X-YMail-OSG: S3sEVV4VM1n0WTGueCtUuV9oifK5ESbrwvKqUQfx.n8I5ENWv6_IDXrkAXvH.Ym
 GJh3sgeOvzc_GVjQqgrcl.1cy7QyeNOwCIZzsx7GED5082fa7WMmcCSTfDr6nUgxqxJLalsAWoKp
 eVjMWacmAMjNGv2WUB2AoGLu2evdp4h8gmHBc3RET0RThsiSti2h.LpCXsEkyeEQqRVaJqCS4j_8
 6etBOl2z5YcIGMdosAfTwJG_vh4tLUrGs3rYfFlZdz1TGEw5wjzfXZmKbrC7tzUlntDnl9YTW0Bq
 AWW9YRMWsTvuChRQs63m3bC2OqL7HYjqykLaDinBwYvxwJgdmoYiuGGjkIXJTBl1Wly37o2nw7IH
 FZVQFZmkW7fLRCVxy6nvcLwQI3op.k_qOCDqU3ROAcpzYS9tFFiq_mXi11eGG6_DLXj_Www4A3x1
 .LEgMO3o2p5lJ6czna.8z_Js_rONuSEzgFRf.IPK84gIRaIcZ1sZs5iKC6vde6J0d46eFKCX3g2Q
 7bKVdk_mMAw2VNkcUirGl4VhVGeOoMJXxuIKBhTeAM4c0x_ZXlCTQp59qhxeaZUisFkqraao5g8f
 e.BdI6ZM1Xoj0_2Pwg84QKo3IH450dXQNSzTDmk.Wm182X82kJiDCnkyPOxePaxIKxdL9hb57qSR
 KqQCpCmm_djCmZZ1HJ5gjtb9nWCHvRfEBDCB.qRJQhbN6K639g9KRPOdZxqVtpvBdpqvVu_skOs4
 SeyMsbYBjC1Dd2lOxq_lGw5GXkBdXEn9t_gNLXNYODUJOYEbj8V8jxI8L7jwb_0QQ38wepNFQVU3
 ETUljlt99UOpIeVIhzAR3ez4y7KnUCKDS124rtLTxWHhVJap_41ugIzbzohVSZ7kDahMdGhWxFOO
 TvGzxTKFayAMhgsBBNdET1OfrcRWi8fW5C7q6qkg5hwB3tehG5KdFlkSAk27vvRdCjrlOlhj8_tU
 R6dcfEfO9czRTcWxFX3gPZfhLzgYGW_RztGfCQP_JLdyigvB_zNQpKZGCUl3vYTTXbBRQ28.Pe6r
 i3l_FxBInqX.UsCCyDyKn8zviSBj_9iZR8RSOL08KzUL9MyK6WIzdwPObbuiFxEKoPdS.n2cPy_5
 xLiwkVsPDx67oKknyrm4CXAyxMVyXvHM.MJ7QYh9sIMTyqfO5zeEEFJYacPeoSy4AeE9sumW4L8j
 4tdc1RoOtn7DGzFLWl5.40T5L7uyVFJYoAvcv3sYcPd0r.G.vzYx5KgVAJ3HH4Ap7RC7UJ9V92pn
 rA6oylbNSfIeFd9oV4xaVbpwJsvwha.nN6PISg1qdWiHemu5cX7KMBwUV7S4cQF_IvFRz0d7R361
 17R9nw.m.BRpL9YEv2u6Z4y6UFMvpkTlCx4cR6R.HmKGJlSWe2u7wqS0jrztU4UJC3MKzBiwWS8Q
 2eMTXngJltPC_oLYyslnLkpE1afyL_vpECgJsWv5ae.P1PA2oLEvWfmq8ivbAJtpc6oUht.FUmAs
 SOD65gWr6uIbntgGqNom2kZCFXw9ydT9bokI7vngNKJXRIF.xXFgb0RF.wbsDUplg.8eiMn_h6T4
 vZ_kX39tgG9wsNH_dCDKGzF._vg8Qo38Od7FBCtIWMQqA071cpOvXwUFzDGErtgZ3gYlfLrcRMk3
 KS2h1KEdad0XBR5hmkNN24zZp3qruZ79QZ3cJmy8zqpXnEROM9hm9xiz4scF59dj8kctPJssG.x0
 bL4RUm1fKV_.0YA5eQ8Pjh7MOfoJynKuIzyZGLSHQYaRPDlTsVsZ5Ts.aPMQJfGiLpp6ZFzuV8sw
 VY7gkgNRMewMFIJiMHmFRi1qqEquLddUKnFrRbRYw6XC70toENiCtIKN3zsKfhpkdfsu6AsUlbWj
 prDFvshGudHO0VM9SrEHE6PbX5oJTcdJUj1AsY8xXlIXLHLrug0F.DJPZTV8DyyIStbCdxjkdxw5
 As7yIBQRv0ce8wVe9CmKxvue7o0ffcLrkzGO.aKMS1D5iaINJTxkeHPdffm9SPJR.v21qYdIBL0N
 JvjtFm081S.gu1VD_71D9JzpadiAlE9C0NzxF_R7zUJv4OtHNuunr7dz4odpQdl8aYAv22.JBeqV
 PyFiUG8G9sJup.GPKdZ6TGcVLJEZgBLCF0dJkHG4FSqHIb_Gb9yIolVrR.z0FKyfUmAJMWsiZTDZ
 GoUWl.XQHtr6.3qDSP.5ZGAtQGi_7gSPCT8j7Ajp0IhhcW8iFVfQQnkde6C7gUqBUiDcky3fJP.P
 mn6BHYvOD3pA0BRxtsIWyhfq2VJldQ92cY3pUQRkD9E5QDJt3dXU2hm1J313irtHkIvxt8_YFfAY
 KBPP4LUk4y3C9Y4EoJ7LMjUI29pdp8DAouyKt1uKMm2yfAtBPySbN7aSgtDu6jO0TexcpvAk7Ur7
 aWSN2OxUK4_wn8V.7GH3ZHIhpdGM5FpJeL5LT9D9IQZ0DuVgj96gttJOH36Q1VqzxlhVmPfNsEVh
 sx8zKlirnzV9nA0vJ0VNx3p04UZ_TYGP8nGykGe6fTAZG_bIA1jkRuB._EtFXi6JOVAJIZ.Fme6Y
 CucPl3KUwwdskgxC_IrvftuL4ymekq7QJfYoFIlDghEaahKf41MAIe9kMWtw8I1YrP38znD.8..a
 fef1ta0_jj_C10cfzib6oOh6W0oqxnwY0d5BdsiPJWdBeN70mIWTzdIu7TMaIn89nWdzpxrjoJ1M
 68yKOzrFnXm1f6n1BFEXlN0BEMWM5cw8e8sgbBvLaTtgS
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 13:21:04 +0000
Received: by kubenode544.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6e4bf409c03d63b15b11e63f66904967;
          Wed, 19 May 2021 13:21:00 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Reindl Harald <h.reindl@thelounge.net>,
        Phil Turmel <philip@turmel.org>,
        Roman Mamedov <rm@romanrm.net>,
        Roger Heflin <rogerheflin@gmail.com>
Cc:     Christopher Thomas <youkai@earthlink.net>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <20210517112844.388d2270@natsu>
 <CAAMCDec=H=6ceP9bKjSnsQyvmZ0LqTAYzJTDmDQoBOHSJV+hDw@mail.gmail.com>
 <20210517181905.6f976f1a@natsu>
 <2e37cf64-1696-a5ca-f7db-83a1d098133d@turmel.org>
 <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <09d03968-28e3-8c67-38c1-e3a8c577bd93@att.net>
Date:   Wed, 19 May 2021 08:20:19 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <d21d0214-32e6-1213-b5a5-5b630223e346@thelounge.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/18/2021 1:31 PM, Reindl Harald wrote:
> 
> 
> Am 18.05.21 um 19:47 schrieb Phil Turmel:
>> On 5/17/21 9:19 AM, Roman Mamedov wrote:
>>> On Mon, 17 May 2021 05:36:42 -0500
>>> Roger Heflin <rogerheflin@gmail.com> wrote:
>>>
>>>> When I look at my 1.2 block, the mdraid header appears to start at 
>>>> 4k, and
>>>> the gpt partition table starts at 0x0000 and ends before 4k.
>>>>
>>>> He may be able to simply delete the partition and have it work.
>>>
>>> Christopher wrote that he tried:
>>>
>>> chris@ursula:~$ sudo /sbin/mdadm --verbose --assemble /dev/md0
>>> /dev/sdb /dev/sdc /dev/sdd
>>> mdadm: looking for devices for /dev/md0
>>> mdadm: Cannot assemble mbr metadata on /dev/sdb
>>> mdadm: /dev/sdb has no superblock - assembly aborted
>>>
>>> I would have expected mdadm when passed entire devices (not 
>>> partitions) to not
>>> even look if there are any partitions, and directly proceed to 
>>> checking if
>>> there's a superblock at its supposed location. But maybe indeed, from 
>>> the
>>> messages it looks like it bails before that, on seeing "mbr 
>>> metadata", i.e.
>>> the enclosing MBR partition table of GPT.
>>>
>>
>> The Microsoft system partition starts on top of the location for v1.2 
>> metadata.
>>
>> Just another reason to *never* use bare drives
> 
> the most important is that you have no guarantee that a replacement 
> drive years later is 100% identical in size
> 
> leave some margin and padding around the used space solves that problem 
> entirely and i still need to hear a single valid reason for using 
> unpartitioned drives in a RAID

	I can give you about a dozen.  We will start with this:

1. Partitioning is not necessary.  Doing something that is not necessary 
is not usually worthwhile.

2. Partitioning offers no advantages.  Doing something unnecessary is 
questionable.  Doing something that has no purpose at all is downright 
foolish.

3. Partitioning introduces an additional layer of activity.  This makes 
it both more complex and more wasteful of resources.  And yes, before 
you bring it up, the additional complexity and resource infringement are 
quite small.  They are not zero, however, and they are in essence 
continuous.  Every little bit counts.

4. There is no guarantee the partitioning that works today will work 
tomorrow.  It should, of course, and it probably will, but why take a 
risk when there is absolutely no gain whatsoever?

5. It is additional work that ultimately yields no positive result 
whatsoever.  Admittedly, partitioning one disk is not a lot of work. 
Partitioning 50 disks is another matter.  Partitioning 500 disks...

6. Partitioning has an intent.  That intent is of no relevance 
whatsoever on a device whose content is singular in scope.  Are you 
suggesting we should also partition tapes?  Ralph Waldo Emerson had 
something important to say about repeatedly doing things simply because 
they have been done before and elsewhere.

7. There is no downside to forfeiting the partition table.  Not needing 
to do something is an extremely good reason for not doing it.  This is 
of course a corollary to point #1.

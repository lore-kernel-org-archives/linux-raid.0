Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 092D1C433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 19:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDEF26108D
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 19:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhESTDt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 15:03:49 -0400
Received: from sonic312-27.consmr.mail.gq1.yahoo.com ([98.137.69.208]:45753
        "EHLO sonic312-27.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231368AbhESTDs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 15:03:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621450948; bh=lEt27hEPWztZ4LrlhTmD8XSxVIb/M9p61snulfq35Tc=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=YbSwTO+7lHiAd59WDtlOdoY8Wg3seyjmuBLfJ7L3ddjfqCFS2qo60WraEDLFTQDSZi8z5z7vuR1FyVvQA3NwvbSSJjOhL4WtxGnVTjEfA26J8kVw6XVq5XQ064Puh5+ofLg6si6+unHKkhIcdWRqU8gWj0XMk1XxAz0pFy7D0A0=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621450948; bh=8hQ88kZPB+fs6Lp909mLd99M9WoVuosycAc4f0ApxyC=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=H9g757ZRANNMGWd+Lpr1Qeeopxw0I1/vGOtpRvuEwoQM1bDIss44rbPUoyR3uwfoMw3Ft3rA0OMq6daUXXcSUttdMYCLXCrG9tgjfZDf2UkYO9WPLkvwa3vxvNXjFqoOKfTuDyc3x07W+I3hVwKGzgmXZlRGBcwtIZtwlU19Gweer2aWYhK66RdXjI+BnqbGdePvgJMdLJOcPW2S1VYVes9ceOxuEPxBcm/HtJpkU3cNx5Cu5WQYKQSAnbrE4f5ML7u2WgoZQUoVQ4EleQjE6L+uErGj/MVrXbjJwVoae5rRYMD8ZmEvPRQme/ji2CG5qcQs/6Ukn6pdL+3sKWu1qw==
X-YMail-OSG: uw18yw8VM1nSPW6kE2TnU6OgCsna28PCBBgM0MfmwYqLrHclmP_KgjJB.DH3Kr4
 pCtvI2TD6IUfxdt7v1_YJh_PZctRAsRQYV5jZwMsSuwn653Dg8jUnK3_5SYAeW9zoipb8Bo16.Hg
 sl0i36MyhGGRgC7K36_mKD87JPGYjYhI24Xv.ob4_LSCgipY.So5glIl2LfDOP3qN5IgOwpSlu1W
 SwUnZX3BlqExeiRYWjAR1YSZ36vP9NmumwSkSuhqkutUcSp20YyEeYr1fz_4BJxGN6sf9_W_Q_jv
 rbbMjLEj.KpmZDmInDiEUsHaG64Z6943B9Fu7a5C0VHL7RniuECStOIU7BxxKZamWojq7FPCfP4z
 wKh0.4Muz5BbKihtWDtKQwqOpq1GS4yQl6sNn1Q.lte2W_g7gerShLtM5e9bMgoRx9EnQYyh3r_0
 PhlROttMXVlien9gsJWdt3hIUlVsTkVKzHyPXdMz7PiYtEjqoSJLQ3Ym4JD6oN3wZLHcHCJ8WKP5
 hS3pVblnKAFEDDU3NLLjA5eOirjRKwzhNKDCY1TWi7F7T4zzxlIzpYF69l0vpf3Z_Oc3Zvm.0GkC
 LedpLL.5kahfwB28M5pUV0up.PeCbo4hqqSIoOgbtAqccXzePS.OUNJ1fF9DM7v3UUkanhSaNXpg
 ETW0pRpb4cesCvBO3Ra4WFBZ1d5j_r1FX3rMx3HjvZNoiJgCfuVaWSLBwF3nCHpVoX7rhymNdFW_
 gPiMbsxg6uShLrVj1DWpkwjlyk5zzrd0Re3Ap4pquixbEwaI318CurFshjn2SBFRoqFLWLpmHay8
 JSITfJUE1NFv4ImQOq1vXxK9tvNVRA13_9IAmzsrRevYFZc3K20uEAV6HctGXva.m2O5VkHvDxO7
 E3lTim0q5zjzP.kC3pFyOGUAXmqo9gQsCuKmihe5TRtCwfbb1u0PzrvYsk9IEKU80tb8O7dhhEo.
 048Ddt.6ftgHsX7z.lrdg7J0Vc6YZCnzGqEWMwVk4g3aFvM.SmbEWvhRO2orbfMfcKuejHCm5tE5
 CAnKM8kHdmpECcRjuNGNuijSECShN6EfD5EmoY0I3jW9NERq5O.f63LojcGFSuWIoylheMll6Dpe
 wIe5swhVAqE5_ibUWxu54W8pJrI4RCTIVPBOqdhb5MrKedDOqlQMjEr1.yqHZ4bFk723s8OKi.zm
 qPikJHnRyyzg8g4uoc_wJSH2tuyKYhzoHlYkLJ.U.z3FEWJmIb02YE4GvUOYAgztNGZLR9wjhKgJ
 6G8TeaBhtEF8QtVox6wT.yQYFJjlnI7xe864dcCOWGVgpZX8KWUrhEQBfK99R41X.331qm.FvJzw
 KCv9Y1ap8n36i6tpIQqsE1K9sXM7oVsEhnJpz1q1hZVt_nXy5ey3mTPvk_B5Pzyqa_mC3wXFuy94
 2PdC71NgAWJjo910rv4DwU8SyO..D5Ks9fs0l6JD_ZH.w7lIk2XCOBlWJc7owUmRjTzjZfh63XfP
 wpf1_goTmhpZMi.zoShHyLW7xQCqVFGtEzsrfqgn8bk0zuNinqZ7bTglIFbKi5DtmN6eCwBPccL4
 G5AuLAf8eoba7QqJ21ObFHrmJ63AbJT2abM841XMXM8Z8Nfn.a0byQ8O76e_bqAORfekRhI2TfM5
 GViAgJBdrNHfVhmAbvW_7UOBt6xEKOF37nNSAmYuwXo1Vy98ohbYOhoOwAIyh8BtJh5_63T_c9ai
 xzZnhecN51sC3lwnHkjOGHLLCfUS2_Gf8ppsg78DhRjypMBAtiuiJOxz_N6_LqzRmL_5IZkKQ6bS
 6j22nmOsF.Wle53J7BL7tDL_PtYP6bFUf5QL_TdChztet3CCKQNKzVJ60Wp2Y92QbMqiT80RNxr1
 7PGGoaYhFiuPb1unz6klqW.bHvBW1VK3wwkkMFz1GIki2aQB1ngYb0zw1oky9nl4pmVdzDq_iUEf
 JIISQJf_yn5toz.AMRMbiyHu6HZN7YuCBZM0tNTb7GUaDXp7rJWwgWvM6V7x67GLPLiWMJI55LeG
 PCx1SQjN3Zu9Coj9NbVn3LSaMYTMAeEc1Z.oOhHWBXdp9qktX7J30x5UAhw5qXNFOcxc.AabHgr1
 EhlYTIK9xR28aEm0yvEaAQPhrjcoMECIv9LKgJQmpJXv7MBrOQad4cPc0pdIh4RtJ9wQWpaaWt50
 ..d_HiaCoyCWURDTpgmXuZInGqcp5uaDRdJncCPKRamkyWPAkAgM9mI3TvQBLNUYkkOTqW_CHoZJ
 kERLlfq0JcXKEHFeERxx3A7h7iHm6oGlqyQqEBGfjIn0r.NbM9ie3Bo4fcGjOxez5mqOmpfAoAbT
 oM.QiJVbfP9SDvODcoHzF0CTbvw3z2IHZJ9tPoFroOZwP97HT75mH2KzG1wbip4QOO_psjGZTE.G
 Twhrq9MDDzlvWIR3VNbZTdNlEIVPAnwU0lr6.S56W1nP10zgCL7.VdfxLVBrmaYbPA9wsrcQqtEa
 KaCqnnDUqxLamzKndOg--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 19:02:28 +0000
Received: by kubenode546.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e3eb763f5b1016d641536457c7954d95;
          Wed, 19 May 2021 19:02:25 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
Date:   Wed, 19 May 2021 14:01:42 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <60A55239.9070009@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/2021 1:00 PM, Wols Lists wrote:
> On 19/05/21 18:08, Leslie Rhorer wrote:
>>>> There are only two other possible permutations of three disks.  If
>>>> none of those work, you have some more serious problems.
>>>
>>> And here you are oversimplifying the problem immensely. If those three
>>> drives aren't the originals
>>
>>      Hang on.  Which drives do you mean?
> 
> The drives he originally ran --create on to create the array in the
> first place.

	OK, after a double-take, I wasn't sure.

> The ONLY time you can be reasonably confident that running --create WILL
> recover a damaged array is if it is still in its original state - no
> drives swapped, no admin changes to the array, AND you're using the same
> version of mdadm.

	That's a little bit of an overstatement, depending on what you mean by 
"reasonably confident".  Swapped drives should not ordinarily cause an 
issue, especially with RAID 4 or 5.  The parity is, after all, 
numerically unique.  Admin changes to the array should be similarly 
fully established provided the rebuild completed properly.  I don't 
think the parity algorythms have changed over time in mdadm, either. 
Had they done so, mdadm would not be able to assemble arrays from 
previous versions regardless of whether the superblock was intact.

	The main point with respect to my previous post, however, is one 
needn't be confident at all.  Hopeful, perhaps, but one needn't have any 
certainty at all the attempt will work, since one is no worse off if the 
attempt fails than prior to the attempt.  I certainly would not bet the 
farm on it working.  After all, as I mentioned before, there may well be 
something else really, really wrong going on here.

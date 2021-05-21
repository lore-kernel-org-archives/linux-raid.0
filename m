Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A37CC433B4
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 04:20:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCA4611AD
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 04:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238633AbhEUEV5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 May 2021 00:21:57 -0400
Received: from sonic315-11.consmr.mail.gq1.yahoo.com ([98.137.65.35]:46126
        "EHLO sonic315-11.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233608AbhEUEV4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 May 2021 00:21:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621570834; bh=UsFcIdiZ00YWW3sRM88i5CI2M2OTT9bI6GlPzWf75gA=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=pTbsQFfWDRT0LBeUc8bwpXZJgk0sfjdUrClpFAwsK25NphK7knQA6xlKoLjyexQ3AiEHOIajWHN9t8bY/EhToIiXUj+murZA2UqENJEO9AFowo3Rv+p8C85IFCdhbWK9IyarKyHH/OdcwJj9nlGCQMWWOldMBbgXKA8sk2ro6vs=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621570834; bh=lmX5T9QmLY5hlPnOM3oywGPzyi2UVUAux/YrTfJlJ1L=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=jvkH34o5LGmPP7w7LlRSNxaEIQjB7IywVGMWQgJzv1EqxPXy0HN/ui4p5fX4nYchVczvDxbI8kkMN8BxYDg0QJNjAe+2U2v81A4qlgYTY4bhKur83Qn1s86s0vXHOW47Xptjp0h2SBmTsxsEr0hu3JqOGVUx03R72vuT7z4BpO2LYlpuHicEybflEzB6yvFSL22+yGHoqTXO2ZOO8HLtJe0lnzQrePVKxFrz/JL+1oXznf2bImwHhGG7HQWPp0NBzcvahyO2Vj9sv2BGEt2uYX/vpxyHKNbJKz16uiAaY5sF+h/5g0WwPjTjfJtGEmHHV5UdEYAVCpuesFsRCUlSAg==
X-YMail-OSG: 1kUadk0VM1ky6B9FQw3.TgH1bqb3yehZqbIuiPUF4IUFbKTvug.ZUNWhLggb7M.
 RrAYD6EgZhfsJOGwFR4LhKz8imkni8mIHf1yzcTnQckwzY.iKRAYu9XYdFh3qXLUrJ0oMHtKAwAU
 lZTaafo_.gT5vlKR3sLmnWt6Apjcaib6IOj14yCVEU2Z8BQkssoVvlmETAZCpBN1ZmNYltCNNqNr
 d3Lvg6J7eiZmoIvzflBXEavFO9exHQw0oL4uPTyGqfMvdxjliaan3ZSPndGATZo8S7WkwHTCb_2l
 2oI72Ux5.RpFKwNPMfAKYm6gKOMLpdU5iXNSZSA5HGX5XgBGb68UjUMJG5WPIEetI9ahcau2Abqf
 STINbptWjNLrxcpIgfmhSD4r1CDQ.nFM9d4VswyqijwzMt0OVqXV0aPQ1cSAUbeQ7igbuv8KhwRd
 DMf6cNNDr7WkQq.LzYyLwvKSWWcSb87fxdH2FRBU4JvKDm3sLMNt8a7HEYNGLEGSxl7oZ93EDH9M
 nPq9eoCLPCSV8fmz.tVoF095bMFsxb4vU.sFbQWJVj521uKyfNKoigl_ZqMK1F74WpKUDh0bQ7qM
 _MWut3586BTFHq6L4ilI_DtrrZbQhQ6ZiqEg3ZGduMY2RA9wx4siSaKLCnpnfPdXcleuty5lOw2v
 Z7_uyg0hAg9cjywjCUm0TubKJksTBeFNRShTYtvjOWOwLadmofK1TJKw8LY3WDrxiqkfhgjkGlT.
 3L3ZJkfvXjUfz9C_CCEebZC6VLyXmXGFJAuN3zQxR8KAh4ICi4LB_2uOk01ICFdKPIZ4mGG3piNb
 Re282lJgKO4NUWPgFvciQGUIZ5mpJk99w36lOVmQvqv59xXt4e2RylMJiGitY.0rQnuICggibOHZ
 HoRo7LRu6e8DqINTNWARsBJUvDYJs0KS5xgkjsEN.Q0l6BCMHMSV0qWOY4IxZdhUiCkYP8xyjty4
 VkvdTYhILKtm8UCOLih3Y6iFaeizm4qonwt.vuHvK5Zftx2meotgTBKD0qyZpureyuOGj.Ep3VQ0
 7XE0.AqLCiX74NSxFfLW8W_LIeBfwyE8YcktfH29HLL9uqdbgRvQ.v5gS1wJybtLn_nZaYcEIMLn
 4Q6c_35TFo9mdoQvF2Gt8fdE3ooGOZ_W1H5DL15UmrLdqHcZjovW8S38CqQDtpMUJo_tpw3_XwNW
 Jk_G18OVUXQ6Zq716oUP54H.IO2nMRlx1kdE_8tQv6cgLyQl1w5n4ezte1D2VgCAJAzB_cg4zBeK
 X.HidB_FpfnVJCF2ZrFFJWF2j7liXXV0rRRBqYXfd8c1hkFyiMNxxO.LlM.XGsOYQ4YGBRUa6R4l
 mRx6kHPlySMpavpPuSqRGc3znQPUJoDEPyWRfD7twvZp7CbM2dgCbPAECR10dGM4rCIYsBSiJE2m
 xx2cDz1CrANgbglDyAbocs6BhPK2YFimZELnC_gDlK8DQMxfPOZYngL3ycUP6lE7l3348SeRQR0N
 AACJP_7UMqVGRY.NiHLJPwZKbQiuoUu9LozeWVCAmm56Mf39Sl0vK56YeuWOY6FlJ3OjWykcymsc
 Cguggy6Ll0hYE6vDb4aYyAOMN5xmPPksSf.M37iMIdve2WkjElMtrjXs6oRyGBAMuXL48P.nv9uX
 h1U0oJmOqg74y5k1IAXfcx6SyGNwXGGWsfbJz8QBCEMdZi_Ff0erjlPPpY4coioQdX.Dg7ZCn0JN
 1rzcKvWTENwbrvZLDqVT.UOJciS5OHozZkYVbl5Wwf.SsdJDL0pYJhCxcSDNBCcAb1uqVQW45BPH
 Cfscg_.tS6G4fTpfV.DAM5W8BsnHjl5jimmoTX6HI_UY56MBUg_RNqtm2Nh5aoCIwwFqo6kCkczR
 _YbupQL4VFHe6AkPE3Pz5F0paD5LXzRCnlqqdhlptIXY3CZmxjECre2hnC7mkUNzfDLdqbKh1MC_
 4aN8zm3rbrA358cpnW4O1R3KalmP41pDk2GOZn9CWc4fJMCvVUmNH9oXzuesSW4oLQYJL2Uobr0c
 BQhIlbTPH7_ngG6NsAuVYz_Ygrzbn0N37qx.8wsPV7U0Jjuvnvu_gD9ZNncKecR._PndOXdBkz19
 Nt9jHAilsFRl1eu5069iEFryBR07vz0d8p1AqmUgtfYuvjeFe_WO_MkZaEdCAz.qiIaLpuHSQZbB
 2hNaOsZwkuXw6qQ_R2lRpXhtOBR8chSkKNkl_3PXFXZTq_.R4hkkRGtgAdo5IXKHkoBY613zuza.
 nimOJQsvfIc.Gr6zDGBvnpK0YjdvH7RgqtRKzMDkgrecAWKMTYVXO1uIJccxUx0lAbj_oNgiD4Ht
 y..by6TopsyACSz_zsRkOZc6odTRgbIKJe8N5amLMRCgFoB0x07ORGnM0Q__usBUba_KL2zpMRVn
 vDFzSCNkOhBWWdpz8EUp5e2e8SJFcYYHN6cI-
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Fri, 21 May 2021 04:20:34 +0000
Received: by kubenode550.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 85071c41afa04172a96ded472e9914d3;
          Fri, 21 May 2021 04:08:30 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
 <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net>
 <d3a8bd2d-378e-fe84-ab81-4ac58f314b50@youngman.org.uk>
 <60de3096-95e8-ca32-3c83-982bf8409167@att.net> <87a6opnnah.fsf@esperi.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <32762416-afa5-e3a0-a888-782a25668803@att.net>
Date:   Thu, 20 May 2021 23:07:31 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87a6opnnah.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/20/2021 3:49 PM, Nix wrote:

>> odds one of them will work are not terrible, and if so, he is in good
>> shape. Are you seriously implying there is no way any of them could
>> possibly work?
> 
> Of course not, but it's *likely* none will work.

	Well, it is not unlikely none will work.  I would estimate the OP has a 
pretty fair chance it will work.

> mdadm's default chunk
> size has probably changed since the array was created if it's more than
> a few years old, for starters.

	Which is precisely why I specified the chunk size (-c 512) reported by 
his Examine on the command line.  This eliminates any ambiguity.  Since 
the build in Debian Buster is also using a default chunk size of 512K, 
it is unlikely the default has changed since he created the array. 
Older versions used 64K.  Specifying the chunk size on the command line 
makes the issue moot.

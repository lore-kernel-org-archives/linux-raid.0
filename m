Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 322F2C433ED
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 03:57:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F14C610A8
	for <linux-raid@archiver.kernel.org>; Fri, 21 May 2021 03:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbhEUD6u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 20 May 2021 23:58:50 -0400
Received: from sonic316-10.consmr.mail.gq1.yahoo.com ([98.137.69.34]:36464
        "EHLO sonic316-10.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233879AbhEUD6t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 20 May 2021 23:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621569446; bh=VRX5TJwbRQt7DkStErFM3PL5pC46MZbG+SFEh/Msr8A=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=U1hdk1Fupb6I1nBHpOZYy7MjrzTaqFZ2AppDFD3JI4VyHDByO+O/ab198btXvV2TcVBMsJfrzhTVTA3Yc0qe0KkxxU91LfkqcHUHCHB3Cif4qYyY6JMDZsQYDJdgk7cTx0rk7gxq8JecQaew6DnRwLGpwOecqteNd6jfQYijofA=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621569446; bh=EC0SH/6jfZl5o/ksTCkq2l2c4KX0KmeqkRm5TOo9zEi=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=s4xdzQ4+QPEFhcXD76uQNj2GTq+YwQ6cEVAIz+19/28ciKSONrGjUAe3kTD2iTS+P7Gy8Zhk+WR/l/PnzkbqJszUm35vPdLKuASr6OekX+tqVa1JjxHIEGwjO+7XI59FzWn/ak/O0/xwzjhESrDIOkOYPY5mPPCNIf1vN/KTv91NzVrD6/Mhs+vVQ3+z4VI33rt7lk6tUenKyifb6wcKyH1/mDuPS1wjCdqVJlA1jYO0xtkYB5hTfzsG0F6AGBxGS27Ni0tjPuSon4d9cefR+vwCIyhVYL5zWe3AhnLaU1c4m+GqbnzeW4KxEHGB1YLowkuwbkVChBUNXkzvkz/w/A==
X-YMail-OSG: RnBJhesVM1k9yg1k.paSEfe9FL.erdus6XfqR._9kDldFMjUoS9qbySwkliZ2SH
 3FSPI30NvKNwdrUIbtPcL30fcS6TEa.6NqhDxl6HJUcbllcUj1MrP7OoL52Wq_JYk1FPvhNiEHnp
 nRUpBsPWn.DaezoYby7i6wYR73h.FbxGv7Q3hJppIdpxvmygwaZl6oaX.FMoloItc_ESTXvW3f6d
 lsXbaGMIwUoRgDGdlGI5xAgwaoDbup7gqD.clF8gWLa6uS4N1iH4z5B0Yoe7tpuRR13tyGRYa9km
 N1ajY4vWWUIHHFSHy11DXrlqbJTR7YjljeHuXhE6T2mSRgoRjm3r43FJh_3BEnmXV7e2LrR85hna
 fTI4Bj.4z_H3D_PfD56x4KsOJpCRtvwLYJGzXVL_wXMSYocbPX0oYvwRa5HUO.icUbHf4RyD_4DF
 pXZF6ksTmo9KNvfLZlxeiaGKYW4_RWvM.wab6_NrtQWxKmHsqeW4MSSdkfGfhI9kDztRqRVtWzoQ
 HZK14fbkMUXkXiyIom0J6XmPCpwomqtKQdsUVeAsmXTT6Jdz19gS86qesfhIISnJ9KBvbKvzi0iK
 aTkGYumInJjzWhczOOENJsvn6SsIoTbRwh._p0tCDs5.8dz15kqePvZFRmxj0AifMB1PnoXlKrxj
 GfsKAAH5SRVgV6czg49LQq8ouey7jkz94gFF.0z72SRsaXMg7oYJ4RuoShwuR7w7eSoyOjaYOF_1
 LjuLbIut9tmBCXPODSCnFX1cDJRkRziMJwWJWz3F2sofBL6w7R7N6.FfNR9_YBKfPY7PF9T0OUgy
 mNW95HKBKPwlFQcl3Gx9D5GqKHx9CdduKTlbS6.3OvPhJnml5fJgdPaaIiMZyzl2iU2kHu2r59Gl
 5mOIaUS2CpNzdxlVLwct7h_NNMgJBHGzWlXmy4MZ3dDaBtvJqAcAZQi4e9vNaxf1cMYuJ0sndrvh
 inPwPmjqRKv6ZdKZCQOtJ1KIdeqAIO.BjgSZrhwR4laTgW8xCqJSOpyITxdvMKZ0vxW.EiXmMss_
 OcFTkGrmjBOmEzYZjNO4_93wx35oiQdqo6S5mcLmns3h3sNKzGawsMdrS5.OYVJt5WArRyfMsAQJ
 ld_iSN1nymP1RwfLm3dBXbewMNYpEo9BGbtPsC8qWDsDEXUV7emwFg3fIakAdqAiTEiU_lIxSPnS
 XZsvRyrrwp2IPK7_zC7XfgMVaMGmoXOWoLe79gNW92XVC9wDI9EkQqYB1Im6mMR_kN4ZMM09iomN
 np91veTpc3f2dXwjqtg2ggRGpOlPBB9QF.q2YghKIw8_DoAsslHjxzSqnp95uN1B6XM1sQ_9son9
 s8MnC0Be25WA2QKdezIvVGzYpbVWuWw6jhJMxGy5R1h5F6g8dslgv_CGaInlarHqacUHZfHVkDpO
 Gg7X80KoFE4R37jcTYB55w7gAaQqGwd8EaA0jc_Pf0dnwe3P7LsMLF_Q7nrlho0mqY1afS7UUfsV
 1tT_G1S9Qxc0a5edITQ2Mf160hle0BxaX0hIEJlBqLx1h9allNt6hxTrswAy0bmle1x78Ilj9zfA
 XdRLbartuLVBsU5D3IGg3t3Doux4wzMURyHXRNZzw9PAERs_yPIYMVIZaAP4UDKTy_SCH9wvmvzS
 KQmeK07MSw.VEImH3lg_JEScoYL6KZaj_gxa3H_InhrmkhIj2Nqi1YbelRclXw_KyOAO74j.xLNe
 lDKbUpyEnAb8UD92kYhFIPdhpcPnszgo10w3t.0jpDUCdQaCPcURcEqXXWN_Ky.TnCazUUPh.xJt
 6dowysrE55ZE91Rg1Kopu7Fepa5NUHhC0OqPHWYUnWrGbNr9S7uLIUtouHQ.M2So5E4KU4LtBzrJ
 9mokkmrurA8renbLUMvaSBQbdB5uuLAg5Z0nUZNQYfNnCRC2Z7wTGw7tRmGvt2Xy7yudcg99Ua4r
 sN.4LOzPxh7bLVk.hE7KYr93xT2AeR6UJeFD.4mAxFws2F8su4CwxzdAuSnwkxuft1P9J_Y0cOX5
 S7WjwduIC5O5T58oyyTAxqXPUPw3W7Yx_7oI_S8Xb3gcqrrh5vfVbesDtKR1HeVDLweYVaNvvzFR
 1GGAXNoMbfJzVzxZ0mmiJecT5jtv.ntPZGAwWo80WeVsOuIOK1NLjXJboUNeZzZocks4olOY7zQO
 DzejE8yZ2WCqx.DHhSCdo4_flXO_TIv3mlEqX7ibaTwjLjvcYXGBH3YkotSvqjaZp317O4eX6edz
 ypB42kfTsBnUZAeI.CBFafqaj59rwWz.uspRsaXxxNQgUYnLrZavO9yPFUDo_d4WpSxR.WNNvDp9
 DzKeKFDA8SJrxweY_7ducQ361a8kx3.1d4sNMh09wjMDX8MFUUJx1t1xHDx86XkD7Kt6fYZQHUGt
 yUF1wjSn.MlIT9LDwGZd3zRUUoJAIpA12MeJfIZ3hGd861lPw3E64lH3E5W2zub4_Q0W25ijssSK
 bqNy27CBxhf4-
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Fri, 21 May 2021 03:57:26 +0000
Received: by kubenode547.mail-prod1.omega.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID c7b9f0ace5ada37aab56c4bd7073b21b;
          Fri, 21 May 2021 03:57:22 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
 <3f77fc62-2698-a8cb-f366-75e8a63b9a8b@att.net>
 <60A55239.9070009@youngman.org.uk>
 <8ab0ec19-4d9b-3de6-59cf-9e6a8a18bd37@att.net> <87eee1nncj.fsf@esperi.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <1a766dce-fb5a-1f7b-6bab-330da3ea1251@att.net>
Date:   Thu, 20 May 2021 22:56:23 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87eee1nncj.fsf@esperi.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/20/2021 3:48 PM, Nix wrote:
> On 19 May 2021, Leslie Rhorer spake thusly:
> 
>> 	That's a little bit of an overstatement, depending on what you
>> mean by "reasonably confident". Swapped drives should not ordinarily
>> cause an issue, especially with RAID 4 or 5. The parity is, after all,
>> numerically unique. Admin changes to the array should be similarly
>> fully established provided the rebuild completed properly. I don't
>> think the parity algorythms have changed over time in mdadm, either.
> 
> All sorts of creation-time things have changed over time: default chunk
> sizes, drive ordering (particularly but not only for RAID10), data
> offset, etc etc etc.

	Which is why I explicitly specified those parameters (other than the 
data offset) in the examp0le commands I listed.  There is a build of 
mdadm out there that allows one to specify the offset, as well.

> The list is really rather long and the number of
> possible combinations astronomical. (Sure, it's less astronomical if you

	It's not astronomical, but in terms of just guessing it is indeed 
rather large.

> know what version of mdadm you made the array with in the first place,
> but hardly anyone who hasn't already been bitten tracks that, and if
> they do they probably recorded all the other relevant state too by
> preserving --examine output, so no guesswork is needed.)

	Which he did.  This limits the field substantially.

>> Had they done so, mdadm would not be able to assemble arrays from
>> previous versions regardless of whether the superblock was intact.
> 
> Naah. Most of this stuff is recorded *in* the superblock, so mdadm can
> assemble without difficulty or assistance:

	Point taken.  The OP's downfall will be if the superblocks were fiddled 
substantially after he saved them.  If not, he should be golden.

> it doesn't do it by picking
> defaults from inside mdadm's source code! *Those* defaults only apply at
> array creation time.

	Yes, of course.

> But when recreating an array over the top of a
> vanished one with the same parameters, you have to *remember* those
> parameters...

	Unless, of course, the defaults in the build match up with those used 
in the last organization of the array.  Fingers crossed, as it were.

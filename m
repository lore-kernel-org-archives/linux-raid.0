Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFC1C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 12:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378418AbiDTMTE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:19:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242236AbiDTMTD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 08:19:03 -0400
Received: from sonic307-9.consmr.mail.gq1.yahoo.com (sonic307-9.consmr.mail.gq1.yahoo.com [98.137.64.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DD325EA2
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 05:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1650456973; bh=7VOW/Z2189YIl7CxDunjd0IBtvJLiyHbbCBHXVywxxY=; h=Date:Subject:To:References:From:In-Reply-To:From:Subject:Reply-To; b=5wi1q9CPEBhm7d2AJWezB5FI6acWZ2xYb28PKlOU7i0BmpcxYxsjf/j5sucYPTZbN4P6vSv4rvuI8cO2Seymz40yPlmJu+pnTKBSVFwd/R2hQXb61lIKFCplj1faG1hVMFEIGCUAeAMgKqjobfFU97ihlwpyZr1NEDl4DQ4/ev0=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650456973; bh=mwj8avgrqNtUOFbvybKkRVMSwAFKUMGlt3I/k56tMYi=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=VJ/HZhziyxbCLDOkKfGTAPChhv/B35HyOU4F2p9DGQBWKiBSMeJ1pPYlshAnoJTVrbdpZb5iYfNnZUNeV3BJZ/2aFZh+V+I4EHnPnaP6q07BvirFVUnNjEeA/yOh9q1ALOkVTawdktykLJ0qwbn6U85iDVixUEmB9fza5hpqSipCn1kvG3igAq/cz0XQtHTzrkKQXFuiefsXrFFe8Dx1n0LJLPvIRad5KiMN/U4+n6nUP2diOWfoB7BvDL1EeAlF9GpG8Zw5SyoiyjwDdjicEinqej/VIE5rdWhsRedID7URe1Un8fHt8oAK3XcTZfw7vqMG7BuNwGQ0WFdGUmPLAA==
X-YMail-OSG: _X9qt78VM1kKPphRo5nM.kwui8ZL3NMRk4gXjVJ5thIDtUVmubu.I80ljOfx.jQ
 yWVraoKYiOxJ_DqdpjWoY4n28OqmZUM66UkGTrrGPuiCDFV94AlSGBSpmOjVwoVRlrd8mncj_fmb
 BhlkykvCQnF1i1vZeWpp7_bDefMJUxxwYj2K9xzx3dCvOP6C0aef3YFw1g5Q_7Khm6M4xTEgx2v8
 dKNjDQ_Q9GxhUe6HFzGcOrbxNldRqW2IDTkRbK3AYem4RG48f4C8loXskHg1RS9fKrWxc6O7zLNo
 bai7jDVoVaJ.G.kX7IjUIA8LJcWj0fT9rpve.u2diHUyYSOOAJ9kHEsltT8P8F7DFx4cFwTuqSPO
 PfhJHdS4d4qVBK27ozmICxAJKvatBwTZxd8cz_aABuZGHGB61NkQGcEiJZU_xhppXK7pd0LhwPPs
 KW43_e0NmluqwoWxATVes.EWm77pWtWfK3.YRWMapEG.B.4AN9XJ2mhWrH38GJ0XkoCIF.0SOgCq
 Qs6ZiG53Ur.mgDOmbSztbMzm1nyJJV17biQNxtIvHVxm7NsrDXET0Z5fyfPKpXuM2P1FbH3Jk5tW
 QMeonchbC9y79n5cSVa51Dl.SCAN1jJafhjGGfFJfZiskexyy9ktSxbvPX87.wsSRD4rmWop0nPn
 j8fBE6XwKMgdzlQ6r83DDM88ez0mpHY..E0EuoL.FOgbbP54rtqAc.XZbMCwsFnj4DobTc0wYimm
 IpJfpYHB7dcFuRfMgFqIoQLmQGDp2Ot8E2vXR0OpG3DEwuliuEH4wUY5x3i_SvzSf8tmuOa3Puz5
 X0jGc5_SXJDuXEhGbnfn2n77xxuVy1asJ67QjyfQJR3dwUYfHC3TgL5r_2mDbQFXQYapBNK_uyhW
 p2_NfWKruXLXn0FpYtkuZ8JMuAJVIdZv.MVLPHrw8Koqi6rUrMnmDuxftkUt1aft8scC8kPB6dd5
 N.37FWls3Sl4rEuCYynj1tTghas.JcNtUN9kTDr79SU_LK_uxgFLvi4kO6nv1f4Y4HrpE2gS4uPw
 CJDj0bgmhG7_MgSH3eLQo6WqFHTqYWM.I9b5lvjkuWrsLbiHqqLNxsnot.uVRp7.o1OOUjngqORu
 aSux2nDIutYCmUd.4tnL6W8iO5twLRZcVORXudReJK11flvnp26vF9OYFkabZoX2ZpnPtmbeH6mM
 ffHXxQX5jrqPJweHjKq5ta6uHpMRipBmmOMm.hy9gE5mppVYeW9z1Tl95vPzjL6C.jjb9d5dr1Dq
 ZvKbsZ6Go.2nrOFRFlFcyvbpxz2fOwjO3ayrwZVgbx2S5JFVwfQwKBLHklh5IK1aIb8G6zxEjxhD
 XHYBzF1aKZO8l5CzfX8LPyQCXzAegbcVHezumsFBX7SfFcYU86bBWcYuWfSJBdtm..KyZJfRNgaX
 Dg19GkiqB0BFT.IRRvxaC_5Dm6po6ibtCxK.CSvs7Jl6oxs_DP9.tY._GYqk_TB27URJ1ZU_K1Zw
 e_Ke7sAMnYOPo6.c0DovXzIvW84EwuGp18Fx.QEA7ym6s4KYwHgmY85KiJdj8tB.MIra4QF8bo3n
 cKhNjt6BAKu_T5qqXSTf3R0a1_6dvbr6LBUEszGsa47__wjVdm8xRrWbge.5ptydTBOh6M29O_5R
 0zjtUDSK988k9.5Z2Pcm8xq94Ow3QR75kns59ZjfBUPTOe4c94PS2J8rZCpwIoscKk4SNdVfceMH
 3jjizxJ7YT_D9lZVu1P.ZgTp_i31p5rW6PQFftDfAy7_XvtOBFVi1Bu2PtuoSQOaiGINe.3Ukoyb
 8ycF03Bd_0ns31_JBnV5uKx2ge12fjKb96if7nhqkliiolZzHrgkZEHBuBgJ1tOITt6QL1Lz_ki6
 MCWk5xZ8QJyiR3YYt8KjK48TnQ3k3t90NIybDUERxJLUfn_JWADkzDGMOvDDVpQP_wYl2zEbohHY
 _Q7j_KSmRDmu1LRKiBUYSZTbx2O3kO.iIaRE2GRnt5KfXJ4t6vF3awmIOFAgBYuxJv_pqwr4Z2Jz
 dClpXnraSg2MyNAy_tnKXMqBgg8XCUhaqaEOZCJiGCXR4eUiBiOJPwtJbyF0S5jQy6DzxsRWeHP_
 7edHQ1gjFuAgxhY06rbjqrgZAtpSgWIhQ36i4oKQ0dlmkV2RDGxIdenAbN1Whk56qnYoAAduFjte
 tcdrCG6srHU_8PGaMR0ca8fOpQPyWsrXha_xNGLOisZYquFOd0Wpjn.7bgr7nmhRfogxvHCkeBTp
 pmx0EyndrBTvipPqExLvXXMjTxxf6YM.j88PwZSl5.qyKLV8IVVs-
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Wed, 20 Apr 2022 12:16:13 +0000
Received: by hermes--canary-production-ne1-6855c48695-qqb7f (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 658055e9e9a9d48702b985cc793ed93d;
          Wed, 20 Apr 2022 12:16:08 +0000 (UTC)
Message-ID: <be2d6ae7-ab3d-e339-cddb-1f5cfb709edd@att.net>
Date:   Wed, 20 Apr 2022 07:16:02 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Need to move RAID1 with mounted partition
Content-Language: en-US
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
 <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
From:   Leslie Rhorer <lesrhorer@att.net>
In-Reply-To: <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20048 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/20/2022 6:08 AM, Andy Smith wrote:
> Hello,
> 
> On Wed, Apr 20, 2022 at 03:40:12AM -0500, Leslie Rhorer wrote:
>> The third partition on each drive is assigned as swap, and of
>> course it was easy to resize those partitions, leaving an
>> additional 512MB between the second and third partitions on each
>> drive.  All I need to do is move the second partition on each
>> drive up by 512MB.
> 
> I'd be tempted to just make these two new 512M spaces into new
> partitions for a RAID-1 and move your /boot to that, abandoning the
> RAID-1 you have for the /boot that is using the partitions at the
> start of the disk. What would you lose? A couple of hundred MB?
> Exchanged for a much easier life.
> 
> You could do away with the swap partitions entirely and use swap
> files instead.
> 
> You could recycle the first partitions as swap, too.
> 
> Cheers,
> Andy

	Well, the idea is moot, since I have already moved the partitions.  (It 
took less than 10 minutes.) Of course, I could do as you say, but I 
don't really see the advantages.  How would my life be easier?  I looked 
into swap files rather than partitions some time ago.  I don't recall 
all the reasons, but I decided to keep the swap partitions.

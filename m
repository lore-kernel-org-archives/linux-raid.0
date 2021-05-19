Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31DEBC433ED
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 17:04:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0EFB561363
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 17:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355509AbhESRGB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 19 May 2021 13:06:01 -0400
Received: from sonic315-9.consmr.mail.gq1.yahoo.com ([98.137.65.33]:39945 "EHLO
        sonic315-9.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1355502AbhESRF6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 19 May 2021 13:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1621443878; bh=9ky9joefetayGTLqyiWu0oOLPOsY0Fvx+/hWrgNcR8o=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject:Reply-To; b=6guHwpaHjQh3Fyfk+h6KhHs4Qx5AvPUNmaqEcf2MwpJFPzpI1JvNz38QQuLpWitnKGLZsHqSAATvVz/aCep7S9xjjX8aB83wtt8evMfR9eVK1TYp+WnWPZ+Ndb3ezFuPNHM6m8uOJDIYdpIzFC811Wr7OUQ5seID8RQejCtwOl8=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1621443878; bh=KbpAi9EshelecTwGzozf85efai15bTpnx8f8sFD2YHK=; h=X-Sonic-MF:Subject:To:From:Date:From:Subject; b=JEbDtM/LrsHl37yo3DSe77kF7/CJkLxRDcII6JCIf2wl9Yavuxoo7D+SKFX0ueTYsRN5/fncgTtRcVyXRLs3x7NdlTI8DK5u4On6B/As6wx+BaVIPtxKxb9bPxOLcglbsm9ERYDPYZFhx9bKG6UwDTr8oNeKwVzU/esGhVDJkutFNd9yZcE7UjajfAk7HsreIAMxkFj45Dgl63NkFC3QQpPAWbbq2aj/rXwhR6stFstwwz8sAnPF2DAPkrRq/SbSl5lAa8G6gLtjOofUS7lSoJ4IxZWv4VXUiGGRi2Cuptr3ex+I/0vyPr9BIfMD/dTH9oGVXoxKKnJtGJmzRLGEqw==
X-YMail-OSG: BLfvxQYVM1nG71aqpL6Mm85IzsLR0t8KvZGoZYMSNajXSJ69f0WW9NK1y_8b7yq
 ZHnOV_ZpfeR6y3p6WApm0fec8BMjoEsodfTZqsFm_nMj6x8fDq26x5V9gF5i_h4Dtlff.3yZ2kWw
 QWVQDyy7sxhX0tj5JOxfFOYbvg62g2YKLDUdu0CCY9O_y7ncIYT0oNjQwBVkWXLWwKPAZw4fEp7v
 DJSiyn4HqFzwADpvDJsAb5uuhUJFn8NGUTyz7Z81oPbddCRWKOLNwdrl.Wh9K_ynmqeEj1SxWPF2
 JTBvsf0Ph7OeTxVHW.9oCsUzIU.JWYal9j7rLTEzX4hAkOU.OKCLiW6LERCMx0rHEFQJeShGGaut
 sJdPKhsvQN0BSsxWdAWUr5Bx4qz7maqLVIk19jrjxBe6YCUoGtOKw7yNMP3HDsh4WXRmDdZAg_ea
 3mDR8lq9_rcppjjRBVZRG1iPtqIlznC4aTfSJoyVYvNOnYLpCQ3hLvyd0rL4x00u_6nvrM59f_0F
 O4Or51t9kcNHS6qkxj4SmVhdWbHUrHmECDlzp7Xz3NfPu.8sifcbtukjXl1bs_A7Awhwxln7.cb3
 kbBMWhy_3djeUo58F5u919XFKd0KUIoBMKwONU8cDE01Hdb1b4bZZd6dZAOvXD.myerdGr7Xvau6
 cIt5zXJh79A2bpRKVpHNQSUAPOm_aV65pr5n647icbwSzWfZiJRY6cBPjeHBp4luQjkL52g39ntB
 zkwiWk_YYiWG5YMfVvyM17m_hrF_9zu0szLQDyCE5L.Obilf1laLeqDVD1958lLk76CvVq10rORx
 tuuRlHwAt6LLf155BOgo5cSRvvI77ckd7Kz4yofwHkDqNlpsV64vzf1cMLg3eI6Kn4imrE_3JciW
 ivMcq3Jdcky76JYeqRaMwpV0GtcZwEIoX2r1Tax.KOURsmEAfj5OfkFqsx3nWURT4YB42I6r5WMN
 ad8EJJUT5uyHAF6E4.bDkMCPNnYMyWfWnNcveepYkt950dvDD1xNflKxk9mFcg1cjtn_vsRb8Roi
 A.5dFhLdA8remBsHr9f7vznX8V._mKmWW.K45Q1h4h5zbi7EL_fXoAIhrTCp4LIwT2.MuoseW7Ib
 FW.pNGKfbql99artsZSZab4VB0e4k0CKEAPvwqHt4IS7Ac6WwKAj66vnXZ3n562q3OiucjDh1PBN
 zSe8ijv21zwH3fuC1vAaAsyFr0oGfkzrI1BfnA_wGz6up6fM3Ktg59F2pqp0mD_.7eTwdB3CecTN
 hP5cUO25vc1SIsFAL5JjZsuS.TTkmapRCCXxkfqwSLHOvSmzXBl.MDSzXR823DkSB83hs1iqh7Y2
 qLbd4d6sm9qCUiZ2iv8GuhZLF6vAG5Q5MXKwqSpK2YVDuuoX6UnDLrgog26NzoCnevj0ZMq_TaZX
 f.3AEyDy.GdCqewgrMW1QrxRN4gstzpC4e5jy6JsGQ..junMLCA_e9UxNqnPIU8AL1QOifFhcy3w
 61hdVHqKQjt65F4d3AHSpovM.KrCumca5rGZuyijifPLBhcHyOQ8uxPPZM5e0IGZ3F3H2yCq_ZWO
 .P7Lct6yd9FGuPJrFImACOERtA3DJhjAm7E1.ukYyjaGXCPpbkTuClAd5SZSm6HhQVznpBZgZ_4p
 .BH_orG14M.e5iXrHT84yUxR3fKn4lTXPZ2C2eN7LIHSLNmY5OBkfubCnIsGVIqihvGqg6AK.gFj
 7dZ4A7EyibenHGnm6ZB8GjpsRyY3GuOJGD4ziYPZacdL.1CnXISg.faS42O2ZeHkcJ.gaCTY._Ut
 rS42RAYc_kfzEthjVQiLNXbLW.zcV3aFykP.zdzCNe9Amd0YCR4R6h5kcgG_CGS4Ax_ZuCcEjX.S
 dYR37qpjZaQg728b_Xk98FRybq2pBgbH.NzpCCvxrLYkQyp_IfrMyTtDIS9iX4thxgdJevSNjsfI
 QQ78M.82bazxnseLPnOE0v4.l1fBGztnCTkQ1D1G.QrhW37bExtNvN5WUFMpHMHP_CSsEtC8y2bm
 HyJe92MepqKi26jeTsPa0KScmqN2pcSdFKda1Goj1sr.w8TEgodo84zPqjMfn.8LGV7KnLejs.GA
 FbmtYSFUTwlwoRi7MwHSRBrG_Yihu4ZHt1IM0_HvZjwJYuVplGpuK6bkLvE5PrsTr3zJPzFzdheB
 N7zwBcM_CPgrNN.o1pJGaiqhtt8ymtrjuR5n4TQghvidzrjoBN5gG6DD9vJuanmaqXPIQC0k1T58
 fJDOnGonWRewSthxJr5Xo1kZUZYQz8QK5xPB4GkawWHs9.roBT9qd63dnNUp_DUuyvh1alzRBhPa
 egj0ETaQvgJN2CfNNx4_sLLoVwz4Y_Pkn0yY5Vcvoc1So9ISOIVsk6IRNrf11E6NLjJLMilrr3PN
 cwmNgRevZ6ofCUESEGQK01wXvoNiv92VcbaDN6mSS1fv0yOvBFTRTfavgdFHIsjWv5Zeyq1blF2i
 Rt6KP.V52fg--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.gq1.yahoo.com with HTTP; Wed, 19 May 2021 17:04:38 +0000
Received: by kubenode510.mail-prod1.omega.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 21aa9a99aa658f9d7edcca8e558fc0a2;
          Wed, 19 May 2021 17:04:33 +0000 (UTC)
Subject: Re: My superblocks have gone missing, can't reassemble raid5
To:     antlists <antlists@youngman.org.uk>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CA+o1gzBcQF_JeiC7Nv_zEBmJU2ypwQ_+RkbcZOOt0qOK1MkQww@mail.gmail.com>
 <c99e3bac-469a-0b48-31df-481754c477c7@att.net>
 <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
From:   Leslie Rhorer <lesrhorer@att.net>
Message-ID: <e7317eee-9a6d-7fbd-bdee-8aca788b47fe@att.net>
Date:   Wed, 19 May 2021 12:03:50 -0500
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <cceec847-e2e2-3d7f-008e-e3f1fac9ca20@youngman.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.18291 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo Apache-HttpAsyncClient/4.1.4 (Java/16)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/19/2021 11:41 AM, antlists wrote:
> On 19/05/2021 15:48, Leslie Rhorer wrote:
>>      Then I would try recreating the RAID based upon the earlier 
>> Examine report:
>>
>> mdadm -C -f -n 3 -l 5 -e 1.2 -c 512 -p ls /dev/md99 /dev/loop2 
>> /dev/loop0 /dev/loop1
>>
>>      You may notice some of the command switches are defaults.  
>> Remember what I said about a belt and suspenders?  Personally, in such 
>> a case I would not rely on defaults.
> 
> Because defaults change?

	That is one reason, yes.  It also means no mater what else, I know what 
the system is being told to do.

>>      Now try running a check on the assembled array:
>> fsck /dev/md99
>>
>>      If that fails, shutdown the array with
>>
>> mdadm -S /dev/md99
>>
>>      and then try creating the array with a different drive order. 
>> There are only two other possible permutations of three disks.  If 
>> none of those work, you have some more serious problems.
> 
> And here you are oversimplifying the problem immensely.

	No, I am not.

> If those three 
> drives aren't the originals, then the chances are HIGH that a simple 
> re-assembly/creation is going to fail your simplistic scenario.

	Absolutely.  So what?  If it does, very little time and no data 
whatsoever is lost.  If it doesn't fail, then his problem is solved with 
very little trouble.  I have been troubleshooting technical issues for 
well over 50 years, and one of the very first lessons I learned is one 
should try the simplest solutions first.  Whenever they work, they can 
save a tremendous amount of time and effort.  After that, it's time to 
dig out the heavy tools.



Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA02C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 09:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377137AbiDTJYO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 05:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244208AbiDTJYN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 05:24:13 -0400
Received: from sonic312-26.consmr.mail.gq1.yahoo.com (sonic312-26.consmr.mail.gq1.yahoo.com [98.137.69.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B3033E91
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 02:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1650446487; bh=Qt7U+aTAr75wpxp62XjH7IkAx9t1O4dpVq/2kExQdfY=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=5n33iOu9r8X3Eo08eJQCC+acBG7Ys2/IMJ+1AvcbkK5s31nh+CytP7TSvmVcoP6OBzXGYqHs024C4TxlWsEpNfaP/mgCQ0VMS9tVblB+bCj+vXExsGgdypj1pc3hQFf9V+5fWWD0CxV1oWlGVo65CEiFaXSat+CkNRrhaASvZjo=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650446487; bh=riAPiOprTEFgJ3QZjWNHsubjfIvmUUAAYMisM1+A8++=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=aK8ts7a5bpIeXrkaazrGn6tXXTIKASZMf0LEXySbFMHzWvIywU5baVr3IKkdy82Wnp7ajefVpWAks7GzFwo6roYlxHzTn7pmU7Ue4OgnaVOnE+imbMYG9hNibGKpArYsJiG3JnL0Svwjakvte8urwICuCnL1PZgKVRR158wjeaNCFlY2bXUhVKqlRdSve8u0LgTJwATiIkALNAiVsEl6IJM1wIIBVgMLzbuurMpWbkmEdRXMC6dD/9ppVgMJs1l570BA2cdRbjug8Y1TesAyFzvT64UL7dToOx09chixcljf3ifTrhf45cSlouGFxg/vlzBBIK8uVoD5Yi5pjHtdbg==
X-YMail-OSG: vL3mqgQVM1mfvjUdpCRUlERyEDRaJHzqOkt27SXNuwld7biSD1VhgIJQSE9LON3
 s59obgpjQrue8rD2zU0bKxjwzNyeaqqVbkal1yFTCRg0FcnC.8yS9ZwVR.h7bdmgrA4fitnmZ6na
 pWft0ykt2c_mmSPgIv440_yOmOtUbf2OBkufC4bX_LVJs.tNY0ei2DMcFvMSJ3MkZQ8lEgQspRmQ
 yRC5C40GWrRUDJNnKxfsxCg0MYjTbLbw5JaUytrP91w4GpUqLSFwwer8o16z106UzRjZxU0pIyOq
 _5SkyZsRPfMExuM6tUQinq44TGzH_XgiWIlWKjNXJQXxtAWwLHYCm1167qyvROZrLGUCK.06FpR_
 wdYeD4.Zo5jyVxKSNw1uJaYWazxkmg19Y7f.5_7JsTGG6VNoXQp.TZuTfjoPTGp8qHH8b5wu1hVT
 BFnmyBf5515RGktToG.p5Uknx5JlEl88TehBYAySDYFptF0WTiPyQSJF4_Kay8WOvZhSqLv6Evst
 m66_Nr.HbTpqoxn5CKgSvVaCaUPu.GmT1nEFE4VoCh4OzZQEod4SSL0wk.Axagaz6D7K0bDLyyRS
 v8cwAxpAZKiWfHXNHj_GBZwyN0IA.T4pv2abYFgwu6FSS0k_3UjGAdXTRJUHV_fxdgNm_mPXeNmc
 fKQaNms.smLGef9GZTp9bGF1UC3y_TOpCqhYFp5_oKIAh2G1kg7BvBZYjhLHNaKIPLfkhdBoDZh1
 DsXFzBs.mb4hiIfTJTvCZ7k.0lGT3KbCZiDGhItluhSshR8MyR4tVuxuNBe5r_iYro.ZomsD6IOh
 isGzW9T040hyuqbfSVXO4bjM7gt5_OvhxrKY76SxQKR2NUcRuaCiL085t1Xty4b_WnGa6agBXfVN
 .8WKQnCxF_vF0NdxyB69MoZV0O7aNT8yS51YCCKT6cTDHgPQehHmrmsy7zSaXWhkI3huyqdrT.Nd
 HhyzFtFOqdlynbhNE89svHnR_iNRTp3AqwE735hpTErlWcE4TFYUYAoJUPEn88vAY8O.W6TmYgfO
 LUNpN0eoemxOOunWIKv2yPnsSgRxPFRMfiHLZorapBU.Bi036G0n1rJwamZS21iE12smtO182icO
 dz0OukqdPPkhAyLjAbyMy1qLF9Bp9AQUgUsxWRtVgYhrdi28t8zLNeCZg1j0XyfXcdZTPs7fva1D
 geosGWPB7bTPtLA.NrBUI7bZJ7QOwe4G2kSNy7s6DZXeD2aU2JJIiKXE6_1rVO6EKuXtqv4BCZXH
 FN6V_ci.TVBdPmZPuic5lr8UQAsN4T8qVwuFp5entzCIQ_wItMCy91QgMgmHZehktxxj.FTpy3HX
 OVpOyXMy7qEHccn4wTcAf4ycmy8rTqF5d6mizIq0nejh4.iUIOyuBh5zbXEbEJeet4LrbFfLmPUa
 vZVTdOJvxtu_8GsL.s.qXuz5fvgTXQbT0LB9HHJuRqsOZjOqlodzKyGdcXPPaHx6dl7AqlG9GTlD
 P0vUZRlNbGPvzBrA4TzenLVDT7p5q3CZhs_mj2okqk.y_fRXViEx4ypsPrjzBabPZEUzM1_DVRo6
 CgWGa8bo.ymyP9ZTKL4ryato5MamuzOvAb5qJjhYqjzenYPD4dC9mKnobnIo0hoQi7Qji_zq2AlL
 mu98a49TGAPB8sZ6D9fBsD9Oj9C.dfZGqUQwsUZ7R4.E74OlxV6Gt20_Zmfr0OWCQ_PiS6oYJbdz
 ZXilAHnS6DcJIokpcFgFsg6brisDPI9nVmcxzhGGR.lJyoTsX.TZ5dqTPdYP347ly5iV926YsBc0
 pg1HC5385CxgI4sSaYHwf6XNyxCfXStj8arJuSbhiixR3fYb9shQShMkLFv5658JzfD47kowZ3DU
 uWaD44hpdYOYuGTlNWQrxzPDXW4pmRX0h92vIaAd1DpmaH1DcLZW96rWiBhil3q2m4D879I1KmRp
 c19dInBTrPiGuQ6.cA_DS28aQx2pQ.5_YtCp1UjgP0uPimV1hpS2R6f_BfIJms7y9EvUHkGYdu4b
 M.zB0laD0sf2llpxwVSueYrYkrHVzi2FgUyNm5skkajFZ9NVtRy1DOs0uCUFKtqdjolfdIoN.WUg
 rVyONv27u25gSgaHYnT4wCk_kkWcxtL.SW49bNrDAGcFexX6lVwb2MGuoAdIx6enHq8VMkzsIXJ7
 GQ7iFxHibmA1eADXL38VL1BcVJsllV9NkN86TA_NpD6LdsIhXJz4_DZTfUat_LKYNnWTlFN9U1zt
 D_amXqWdM7WNXTKI0ftHBgf30lBEyqo2Eqis4vpXIJ7_cXJ6Top1DGUbf9nAjrP1_20GX
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.gq1.yahoo.com with HTTP; Wed, 20 Apr 2022 09:21:27 +0000
Received: by hermes--canary-production-ne1-6855c48695-8fndv (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID b779f7ec905b981f318a743255971ddf;
          Wed, 20 Apr 2022 09:21:21 +0000 (UTC)
Message-ID: <03e77131-a306-f261-b9fd-47cff331ee37@att.net>
Date:   Wed, 20 Apr 2022 04:21:15 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Need to move RAID1 with mounted partition
Content-Language: en-US
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net> <20220420135533.39a32200@nvm>
From:   Leslie Rhorer <lesrhorer@att.net>
In-Reply-To: <20220420135533.39a32200@nvm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20048 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/20/2022 3:55 AM, Roman Mamedov wrote:
> On Wed, 20 Apr 2022 03:40:12 -0500
> Leslie Rhorer <lesrhorer@att.net> wrote:
> 
>> 	I have run into a little problem.  I know of a couple of ways to fix it
>> by shutting down the system and physically taking it apart, but for
>> various reasons I don't wish to take that route.  I want to be able to
>> re-arrange the system with it running.
>>
>> 	The latest version (bullseye) of Debian will not complete its upgrade
>> properly because my /boot file system is a little too small.  I have two
>> bootable drives with three partitions on them.  The first partition on
>> each drive is assembled into a RAID1 as /dev/md1 mounted as /boot.  Once
>> the system is booted, these can of course easily be umounted, the RAID1
>> stopped, and there is then no problem increasing the size of the
>> partitions if there were space to be had.  The third partition on each
>> drive is assigned as swap, and of course it was easy to resize those
>> partitions, leaving an additional 512MB between the second and third
>> partitions on each drive.  All I need to do is move the second partition
>> on each drive up by 512MB.
>>
>> 	The problem is the second partition on both drives is also assembled
>> into a RAID1 array on /dev/md2, formatted as ext4 and mounted as /.  Is
>> there a way I can move the RAID1 array up without shutting down the
>> system?  I don't need to resize the array, just move it.
> 
> You could fail one half of the RAID1, remove it, recreate the partition at the
> required offset, add the new partition into the array and let it rebuild. Then
> repeat with the other half.
> 
> However during that process you do not have the redundancy protection, so in
> case the remaining array drive fails or has a bad sector, it could become
> tricky to recover.
> 
> Maybe run a bad block scan, or "smartctl -t long" on the disks first. And of
> course have a backup.

	Hmm.  I hadn't thought of that.  Well, of course I thought of the 
backup.  I'm not insane.  The boot drives are SSDs, and they are not all 
that big.  The /dev/md2 array is only 88G, so there isn't much exposure 
to drive failure.  Rebuilding won't take long.  Thanks.

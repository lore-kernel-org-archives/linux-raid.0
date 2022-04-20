Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16E0C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 08:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376833AbiDTInJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 04:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376822AbiDTInF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 04:43:05 -0400
Received: from sonic316-11.consmr.mail.gq1.yahoo.com (sonic316-11.consmr.mail.gq1.yahoo.com [98.137.69.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABBBD2180F
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 01:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1650444019; bh=KZsktvE7Kyngw5SNEoPtvwrV6ZEElm2tB4+31evl1p8=; h=Date:Subject:To:References:From:In-Reply-To:From:Subject:Reply-To; b=OLYgnyhMBf9LpnaXHmT5GfJ2lwl3yPCSNtoHtgOSvgwcgczXfGT7ueipcgKf3spiwE83lCVRieEMo5rJS5wue8+tc1VVTKcLFhr1AoHxkBIhUbrM+Eya9oy6Bb2nA87nrxXo+4PDvZvL1Q9b/UybMn3sqVdtG7qipj+qB1SJh+w=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650444019; bh=qJnhzrjNR+B6mOHHJK+sDg/EYk8qxX7QJGmA1HorHPo=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=Q+26+4ZM/uuRfmwqkRwHBicJx83cMmoPKTlJuyK3OBVN5C6cR0CtKIA59KdPKXxT0Pp5+XZ1AyXG+BplpjY+fb1eFJOS9v/+nZBi2dbV1ZPMdC7GXDkjiA827sGZHym431hXSZNHsYlp25hNiZmTIR3ykZf2kF6IQfmoD1rHGpI/Ts0mDO1Oydn5Y3piVyA+aWtqeRvHnTvvgynggaxRvaWbw/jtto+0r6Yjwr6hh7Oy3NF4kb8G9c/fdANtjildjgEYCZl3TkR3p2EQJ4NDChlPC8DuQWM1NwfsbFLjCa7RmtuP5HYEHMOkqIQhA48ZrodENxokddt4X/9w/5Re+Q==
X-YMail-OSG: 84DJy68VM1mWU5Fc9pcWICQJSpvj9oFv7LDCLwlL2L8U2U87fc8RShUvqsLMmRp
 kP2J_HLoEPDIQlKNDnciRHy9ixdUancxWjnxt03k3B0P67guqubVxpK6EWX7pACDjDhTnIvWzjLs
 V8aTEQhoPOVQNLmXzcmSPleOaWckYie4Mp8vBlEwjbTlgcO1CVjvanrXoZ8Q9y2J1jyU2lfxs89A
 3rQ6a_9aH_LaVPH9UkbYwguZ8Ibg0BPlMJdXKDRtHhBvIR.lD4CV9GHz_gOEdM02VKjTXO5rbkNb
 2lwpgj0G_Dyx8JExmw3kWYSETNx6zMsgFOfLUr5yPi0IiQmEkOZHjiCzCPQ7szUMb4JLQyyMglu7
 S0cm7T8mLMoqHA6g1IzRC9xcjq2BNhVrWEvUk.17Pc.BVW7kqKcIHDewZCqq_Ooc2FAtVMahdGHs
 W2ZBrJmX8urC36o.Zvt0AuBZL4HJ43v1rgI1A4MkNq9LWYEzhJWWfJf31TUeoJNv9UgtvpO5EunG
 .ZfRoZ0vdL3RHYdsMIvl3JlMpYzebQ6dPXzyTusTSPcL1ZDs4jQ3XgSfbKh9aYvF1uQuqqYaMq9N
 krcqeK.wKpRa1J.jlUPhXbmXS7jB.9yOwb.9WJCDl7wNElFhz37IlgzYSvKdPloGdpTNe1n4_JEd
 TzeHEy6yhUQ6QKLmIvUKY4gRrt4WoVhQF0g5NydH_6.SeIr_loMdsmUH3pQKcPWDfaeF_tIB77Ge
 74p0oqEyIKyTv9BYrwfOaoWbCAebBLmYzoUIVPWPdaV6qAtyYBqIYuxHfxeKLfFg80evNFO5OBkH
 z8xvg96TS2nKzkdKLTTjlIWRry8H4k757uf165q4LI_YVo.rQ70KdbMuVmuDg7V5GuLgkIaZkR8B
 mmArI57_d7QVOFdR0veHahxln62nkDnUay12gQZPvM9qJoE.OyfsQqJesmv6Qi9Z9SWiefxsTeTD
 WxG9dwsNfL0OtUlDpLgmQVNjGW_149fU2nPS6wsMCddIaGp2GljKgDw3hupaQHB7WapKsjyKbcg6
 D502M38XCtkQL0rfMehfbqvu93l9Onn0vK6..mVXHiMwTnDtg5DGiDaIMOZlyHV5CjdSVhBusMGV
 KBpPtSllLbVxHFIKjEns4eB6iLdnKc_NmKGzB9ylf8cunD8dEKFgpV9iy4ADkC6frWhSkrnQPFmX
 Nh4LvV6__ACN2MgMN7fYYkyafAoAfr32uJPmO3HZKnk2hJA788D.EiWocdIJII1iaJWQAlF8to8r
 F.qD0Yy8tUniXgjbWQUustxYywRNrMjxEinpqk0d9dA87IxM6K8BfWS5HVd2f0jFzb1jpH6JDO86
 OG9uXkx9epHc3uMUmqa7rPoDn15bQGKnzAr8l1LQ826DZM8T_MJns1qu_NQPpb9pYwuDkoOC9xVU
 kIb.7wmY8Vue0GkkPAJE2egkhFfh3M0.4VlW5pPtn4miyR00PLnIBIpIQJKnTq516TNfuyhOxJvE
 uEruLjTjNqFaIvNCFJzpUPcaKbuTVGquHGk9SOM86AMDj8ACLZo2S3W_R_Ca7QaV_D_GFNOJA9cK
 zIuZqGfRXxj1AeG1LtWBydt.CNktGWu79p2z9OHQZJEd_Ik26xGhVUC4y9.bzKjIMJXaFOqrawln
 nP0oSIl_A7VO1cT9ikP4oTt28srVvJzXgAWLrSQbXCL4jjElzsMjmDl5zyzZeWBL7bP.sMeUvFel
 Pt21oBXgcpAOmIXFy8usqvSpiM6f8Cn9ihZgAUtcO8el8j1bUSkw3WqVDRoixcwIYR1M6DBY.DSH
 zDeiw0aEkrOh7tkB0NtM.AYF9iXTAmqnZ66j_8736YARmslYBl6MJ57T6oyAqlZq6n_o.PLlopRC
 vtChAcRIlBjZDxzgOk__4YOpvr0Ygck9ok1CVfSqvz54jvsSKDXQtger_0R_wzIsxrdhqCjKGqE7
 2xmNvsTio3iMLDsXKPiX6IUku48S5UU9b6UW6kYHgKBhNSzLcNG0pQ4ptPUXA3k4QG9WU6pvWNVR
 QOvinGwWEbJq7BLZDyDPd98ObzeYHiFnY1ZsRx.kUnSH9hAFchKPOEQIDPRPGDzMPpBRYw5fMKqw
 FIE4EOcROhqPBAuHGCR0uJIXHhqYNJKX2w4GRKlNMHbymYybOZWI2mcPZQGvihAjfEa1d1feGuog
 tbbV6oFAFLH03PFX4juO9Pe7K2HH7XOYqZ31npQNmCrjyRCnPsrxk3zbgOXN7lxQxeWChAD6jKC9
 yPtQ7KIEsV01Pd8preV9.8dE0qhKQxH2SBs4JeLgtG2WG5g--
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.gq1.yahoo.com with HTTP; Wed, 20 Apr 2022 08:40:19 +0000
Received: by hermes--canary-production-ne1-6855c48695-8fndv (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 902f8a8537aabd24b3b7fdbaf6d2845a;
          Wed, 20 Apr 2022 08:40:18 +0000 (UTC)
Message-ID: <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
Date:   Wed, 20 Apr 2022 03:40:12 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Need to move RAID1 with mounted partition
Content-Language: en-US
To:     Linux RAID <linux-raid@vger.kernel.org>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
From:   Leslie Rhorer <lesrhorer@att.net>
In-Reply-To: <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20048 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello all,

	I have run into a little problem.  I know of a couple of ways to fix it 
by shutting down the system and physically taking it apart, but for 
various reasons I don't wish to take that route.  I want to be able to 
re-arrange the system with it running.

	The latest version (bullseye) of Debian will not complete its upgrade 
properly because my /boot file system is a little too small.  I have two 
bootable drives with three partitions on them.  The first partition on 
each drive is assembled into a RAID1 as /dev/md1 mounted as /boot.  Once 
the system is booted, these can of course easily be umounted, the RAID1 
stopped, and there is then no problem increasing the size of the 
partitions if there were space to be had.  The third partition on each 
drive is assigned as swap, and of course it was easy to resize those 
partitions, leaving an additional 512MB between the second and third 
partitions on each drive.  All I need to do is move the second partition 
on each drive up by 512MB.

	The problem is the second partition on both drives is also assembled 
into a RAID1 array on /dev/md2, formatted as ext4 and mounted as /.  Is 
there a way I can move the RAID1 array up without shutting down the 
system?  I don't need to resize the array, just move it.  Is there a way 
to umount the root without halting the system?  Note the system is 
headless, so access is via ssh over the network.

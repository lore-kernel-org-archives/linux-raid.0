Return-Path: <SRS0=RtKw=CA=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24E6AC433E1
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 01:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0729420720
	for <linux-raid@archiver.kernel.org>; Sat, 22 Aug 2020 01:40:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgHVBk5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 21:40:57 -0400
Received: from omta04.suddenlink.net ([208.180.40.74]:32739 "EHLO
        omta04.suddenlink.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbgHVBk5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 21 Aug 2020 21:40:57 -0400
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Aug 2020 21:40:56 EDT
Received: from [192.168.6.104] (really [66.76.46.195])
          by dalofep01.suddenlink.net
          (InterMail vM.8.04.03.22.02 201-2389-100-169-20190213) with ESMTP
          id <20200822013158.DWVR7821.dalofep01.suddenlink.net@[192.168.6.104]>
          for <linux-raid@vger.kernel.org>; Fri, 21 Aug 2020 20:31:58 -0500
Subject: Re: Recommended filesystem for RAID 6
To:     mdraid <linux-raid@vger.kernel.org>
References: <CAF-KpgYcEF5juR9nFPifZunPPGW73kWVG9fjR3=WpufxXJcewg@mail.gmail.com>
 <1381759926.21710099.1597158389614.JavaMail.zimbra@karlsbakk.net>
 <4a7bfca8-af6e-cbd1-0dc4-feaf1a0288be@fritscher.net>
 <5F32F56C.7040603@youngman.org.uk>
From:   "David C. Rankin" <drankinatty@suddenlinkmail.com>
Autocrypt: addr=drankinatty@suddenlinkmail.com; prefer-encrypt=mutual;
 keydata=
 xsBNBFkinL8BCADU5H9ZxEu+IIMb75pSmVXhW7ujTM7p2TzjZiyTT3Lfbxuoso1rWyAaAti6
 Jyfw2pk0SJYw+8afn1+Ag/BtmSGm7wiuGdpHlDL0e/2sbyCYoFExpFLecgd5+mU+M6GCNUaM
 vZ79BaM2wn+c4r1r0LcPmy7uweHhaVXGlocfMChd2fBweonL2jd4bX64XZbB5YErpkzxFN69
 kM+I4CmkzOaSSLfN6//EUgc2zBKGVJhM6fpZjVE4Wm8S+khvrJwFG0ZoaPC1Ol/b47iyqZcf
 jFZs75i2Tjd3AYyQ6Ai3ZNGrwv2PJSAawR+hfZLeNf5aMaIqoG099SsAN3j8wW97DDjbABEB
 AAHNRERhdmlkIEMuIFJhbmtpbiwgSi5ELixQLkUuICh3aXphcmQpIDxkcmFua2luYXR0eUBz
 dWRkZW5saW5rbWFpbC5jb20+wsClBBMBCAA4FiEEUoo6wDEaJyRJMG0RyQVv1wIPCIcFAlki
 nL8CGwMFCwkIBwIGFQgJCgsCBBYCAwECHgECF4AAIQkQyQVv1wIPCIcWIQRSijrAMRonJEkw
 bRHJBW/XAg8Ih3/CB/9v70EHOFGvaL4sNrmofCXGZFu9Bmn3JjMVslXqzgOPK6SKvsIZivMC
 +4VRYEgWITEGykZ0e5Ddv9QDrr+66l/oOXNFFOzrZYyMr0NNltB8XGqfH4RYIMpsGVcyxoi7
 8WO0G1zXe47PNr3rs50TyXa7FQfv4Hj9LxF6mkn4VebanOjiqWrVhg21fRx3sHKZl2fQbaiB
 4eizYDLltg5+JhYVXBvt+dnngMKw59sfQz1FQiEDlkp4KGwI4Bm+2Iwx6Yiv/GKETwOzsg1u
 0RfGbTSjjGBGJZJIl66g595KKUdtWMlHLboT8qEq+RltycYImxBGjwM+rk/87lRCfQdW8bJO
 zsBNBFkinL8BCADBf/hnq9+d9ayvxYCpXpZgorwW0itZcGMR7O3GIIAnJ0zBmQ9BFs4mVkSU
 ulm9YscWnryZsx+ty/bd0wkIf6MTlcEtr+ntdmnXQgfMGF51lsjYwEGyd+uqoJ2t/Qo099L1
 sPr7fu55347w42bgQuHMd+OUaiM110G8wS7sRApjX279fawg2Ji+sA5fqyzbUTivgChWiNCp
 ovt+atEIPa4jvrPs73MLeZDT8mmS4SjRiL3sf4/d3epINvQii88/J+KgwDLsogZIBgIfPF3j
 vO+RhaV9IRZDVp6cAC8aCoqtnf8o/1pXV6QaKZhgimdP8knrsM8PH2AqVAP1/VhlVxC/ABEB
 AAHCwI0EGAEIACAWIQRSijrAMRonJEkwbRHJBW/XAg8IhwUCWSKcvwIbDAAhCRDJBW/XAg8I
 hxYhBFKKOsAxGickSTBtEckFb9cCDwiH348H/2F6IpwFmm7qroGMUjWn7wXFwBhBOWq02Ehk
 l4VFgREdTs9FOQY3lgCirWp/PKR5Ba3R2FvLLuQOg5+4w8VFgFY180bwNCzWyXyjqwcO5Jxi
 UqmEA+4HXgSWTki39DLfYPXr5MYUeHCxRxtJlh9Ox9ciK3izRU7PotAd7SmOOD+W7DXAMzMA
 9htayXoYhU28UZQIgnOr+ta87vNF2gyixCRR1WIQiUV65WtOA6BmXWSn3OrqxYP2lJ/u89aT
 u9Lrpjpyry1YorbCeiLMQLH4WaeCjwW25E44sXEz3yQEBs0IXKGUttoxkz4NTexuMbajE/zN
 +E26HU22iDtB5AOJ9R8=
Organization: Rankin Law Firm, PLLC
Message-ID: <05661c44-8193-6bba-67c9-4e0d220eb348@suddenlinkmail.com>
Date:   Fri, 21 Aug 2020 20:31:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <5F32F56C.7040603@youngman.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authentication-Info: Submitted using SMTP AUTH PLAIN at dalofep01.suddenlink.net from [66.76.46.195] using ID drankinatty@suddenlinkmail.com at Fri, 21 Aug 2020 20:31:58 -0500
X-CM-Analysis: v=2.3 cv=X9Ys11be c=1 sm=1 tr=0 cx=a_idp_d a=/cos1G3ae6AqFCvJLv+j9g==:117 a=/cos1G3ae6AqFCvJLv+j9g==:17 a=IkcTkHD0fZMA:10 a=y4yBn9ojGxQA:10 a=A1jyNYAxBm8A:10 a=tXNp_sQbAAAA:8 a=iP1lC_2evjmJotsKC3cA:9 a=QEXdDO2ut3YA:10 a=Ml6N1FFu0uQA:10 a=EsphXFvyNvgA:10 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=UDnyf2zBuKT2w-IlGP_r:22
X-CM-Envelope: MS4wfBXfwNSuwirFswAgvXGLShNVSDNFsICFUbvP3U1135alvKgZyrOlyC9uMlkUTGD9Kbe8mL+nrASehIIPA5t5GMTtjnGAZW2eiTw2JybOCn9B/HP3PGCF 6lB2p9/N0HOs1Y6xeFWrtZwdJuUhQqVvdmspfcwu4BAlJ5lS/BNv/wA5LG8LwRJ9fSzJIciKHikwFw==
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/11/20 2:45 PM, Wols Lists wrote:
> Note that it IS a shingled drive, so fine for backup, much less so for
> anything else. I'm not sure whether btrfs would be a good choice or not ...
> 

I'll defer to you, but last I check btrfs did NOT play well with raid 5/6. It
may be old info, but:

https://superuser.com/questions/1131701/btrfs-over-mdadm-raid6

-- 
David C. Rankin, J.D.,P.E.

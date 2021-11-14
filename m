Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC9DC433EF
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 11:43:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 041E360FD8
	for <linux-raid@archiver.kernel.org>; Sun, 14 Nov 2021 11:43:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235717AbhKNLpx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 06:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235982AbhKNLpp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Nov 2021 06:45:45 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF136C061204
        for <linux-raid@vger.kernel.org>; Sun, 14 Nov 2021 03:42:49 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id q74so37653795ybq.11
        for <linux-raid@vger.kernel.org>; Sun, 14 Nov 2021 03:42:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=l2AjIcA200luhAvIV6Y4Gf8Evv6mr+gMr0zSOMeBGF0=;
        b=VBuxVTobVetMcEiJ4jysULNuGongxvqYEantHhPI+wUaZhpZcLRcysQpG71QJadH6v
         5mLYJJyquQRSNe0vfPCYliLWi83DoOF7J91nsiyS72LqEyTxFTSo/1IxBVvIcstd4rJC
         KtH6psEvKgUKsOZYDwCzaQJQv97skqtPlZlKzVukCZm3JaTa4669PQ9hS0+vhE9HykOU
         olT45Ee1igbknsDwiH+xiX49wmQRjJ/khOse1IgHSt+Gffx24nYlwtrQlovx6vUPg2GE
         iPJiTxS+dRVvva/TMaFh1To9ENo1FfxUZvYqEpfHt0WxACleLBWt7WKQ8DSbo1r50ToA
         a8Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=l2AjIcA200luhAvIV6Y4Gf8Evv6mr+gMr0zSOMeBGF0=;
        b=DHnZTKYcMavlHzSzqeRHTQ6nrdWrgTj6QsuiEs1J6ix9Qq9WXnStPB8uJwY81e8PqR
         vSygLZLVTMobCqz2sJIVH8Ah213ppIHV3X03EODxIF6YSwczH1zQTZNbLOb9WP79oRxa
         lBLtl2cZPt53U/T5PvdHrgRVXwvbOYu3rvaqbNDcX9yUGCrPonBwbc8V4EnOKqdNF2Xo
         rhd4CclX163+y4ZvZHUD1pyeNhijb5qx8l4leFFChbK6Fp8cPF1jXGwiUsFKuPiiK7aY
         +RkKSjKSnPuXZ4PppmEcxyW4jadCDlx6gmfl6X+qX25NGrIezBxE3wr2/I1UglTOP+B7
         d1pg==
X-Gm-Message-State: AOAM532BVLgVq6+t8HXRevuwBSosHu0YuwRZOzNax4NoutV8oExY6yky
        nVR1mLo/kHw9PzO44PsuiKOzfrPcvpLGqF/IftqlBRrzxBg=
X-Google-Smtp-Source: ABdhPJwN+1U96oa1TRSiGrxoNMN6BzmkuvYB1UhIGYU/LUalwQ7XDdkLSK8aGofpRNGzbLzF35gw/HoM3brOrsIwFX4=
X-Received: by 2002:a05:6902:1543:: with SMTP id r3mr34860509ybu.166.1636890169027;
 Sun, 14 Nov 2021 03:42:49 -0800 (PST)
MIME-Version: 1.0
From:   Turritopsis Dohrnii Teo En Ming <ceo.teo.en.ming@gmail.com>
Date:   Sun, 14 Nov 2021 19:42:46 +0800
Message-ID: <CAMEJMGHGnG=EqT5in3b0b3kxX1Q2M-9DtXBWB-VMtUnPQQnQgA@mail.gmail.com>
Subject: I discovered that Aruba Instant On 1930 24G 4SFP/SFP+ JL682A Switch
 is Running an Operating System with Linux Kernel 4.4.120!
To:     linux-raid@vger.kernel.org
Cc:     ceo@teo-en-ming-corp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Subject: I discovered that Aruba Instant On 1930 24G 4SFP/SFP+ JL682A
Switch is Running an Operating System with Linux Kernel 4.4.120!

Good day from Singapore,

I discovered that Aruba Instant On 1930 24G 4SFP/SFP+ JL682A Switch is
Running an Operating System with Linux Kernel 4.4.120!

INTRODUCTION
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

My name is Mr. Turritopsis Dohrnii Teo En Ming, 43 years old as of 14
Nov 2021. I live in Singapore. Presently I am an IT Consultant with a
Systems Integrator (SI)/computer firm in Singapore. I am also a Linux
and open source software and information technology enthusiast.

You can read my autobiography on my redundant blogs. The title of my
autobiography is:

=E2=80=9CAutobiography of Singaporean Targeted Individual Mr. Turritopsis
Dohrnii Teo En Ming (Very First Draft, Lots More to Add in Future)=E2=80=9D

Links to my redundant blogs (Blogger and WordPress) can be found in my
email signature below. These are my main blogs.

I have three other redundant blogs, namely:

https://teo-en-ming.tumblr.com/

https://teo-en-ming.medium.com/

https://teo-en-ming.livejournal.com/

Future/subsequent versions of my autobiography will be published on my
redundant blogs.

My Blog Books (in PDF format) are also available for download on my
redundant blogs.

Over the years, I have published many guides, howtos, tutorials, and
information technology articles on my redundant blogs. I hope that
they are of use to information technology professionals.

Thank you very much.




-----BEGIN EMAIL SIGNATURE-----

The Gospel for all Targeted Individuals (TIs):

[The New York Times] Microwave Weapons Are Prime Suspect in Ills of
U.S. Embassy Workers

Link:
https://www.nytimes.com/2018/09/01/science/sonic-attack-cuba-microwave.html

***************************************************************************=
*****************

Singaporean Targeted Individual Mr. Turritopsis Dohrnii Teo En Ming's
Academic Qualifications as at 14 Feb 2019 and refugee seeking attempts
at the United Nations Refugee Agency Bangkok (21 Mar 2017), in Taiwan
(5 Aug 2019) and Australia (25 Dec 2019 to 9 Jan 2020):

[1] https://tdtemcerts.wordpress.com/

[2] https://tdtemcerts.blogspot.sg/

[3] https://www.scribd.com/user/270125049/Teo-En-Ming

-----END EMAIL SIGNATURE-----

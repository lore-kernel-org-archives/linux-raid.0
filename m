Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B388C0015E
	for <linux-raid@archiver.kernel.org>; Sat, 15 Jul 2023 09:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjGOJvQ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 15 Jul 2023 05:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjGOJvP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 15 Jul 2023 05:51:15 -0400
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7797C26AF
        for <linux-raid@vger.kernel.org>; Sat, 15 Jul 2023 02:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1689414669;
        bh=ZONAthFr+ye2k1eUfPYC4LS9Wsbe2T52otZmFe3uvms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=i7rNdrNrtGbzt/YlM4fql9al8snmcPNJoRECKGGDRgtUl8LZlZ9xWyOqnPyBEaWUu
         bXVLlUKFLCcAaAZfjWnnc9t49hbGnjLTMa1v2dYCalUNUi2u9zpqP4LrhQTGey7UVj
         z2IDjMpZg4XsZk/DEIEbaxGcOj+GWU/MmNrZxreo=
Received: from localhost.localdomain ([220.243.191.12])
        by newxmesmtplogicsvrszb9-0.qq.com (NewEsmtp) with SMTP
        id B361F435; Sat, 15 Jul 2023 17:44:54 +0800
X-QQ-mid: xmsmtpt1689414294tq60gmgma
Message-ID: <tencent_0EDE0D522DF8161358B80786820BAAA5C406@qq.com>
X-QQ-XMAILINFO: OR+iMM9v9RFuam7z+5bGLLUDhzWJebHyzAW9QR87s+VYiuWo1jPZNEDt9B30Hq
         US5rCS7a5QURVijig1ubrm9WrctNAR7Jzwi1oBuzEqUuXi6KKjZTLjqaoK7Tdt7Tl7ipit711gcd
         6Rm/u78HzOL2RzAwJES4g4xB5B4bYa/QGlO+Qn6sbV6lCRujHkjG3mAbvs85NfddynzxZfwHR8+f
         MuAGLlCwyLrO8BwrYThGcjGvZ3jCbofEhGZTD+fjPc7NF0TkjprKZx16BkeWKvDZGKpgXzlxfEp/
         1DjP4LicyGg2It8IUD2CZijtyDouYc77JKA5n9NXCTRWuJMv8xIHB3cQUm4NWzTI8ApzUkjTvYod
         8/2mccUuehIg7DhbyanxrOTfdkG/p4tYgTJBA7AqZrkrmUCV1Mnugo7VdZdjaDmp+zZTJBOWraGQ
         yoc/OPDg0WCL++f4wi6MTeIbaqTrJCSl0uNxCaBCXJLFZFmr7a7yFnh4NBEwXGG3Fp/xSVQXQgVF
         rAQJph/nHSvpMvl69gxq+yzju9pV1HAwbUQwDSigAnCJzmJBiq3/EvnQ6DkpEEOJRIso9mbURi0J
         6UP/h4xYrR+f+fc6zCi4o+w8slr4iD41bqwsJeHrBWr2q5OhQ+r9nkU0YUeyRpjs4cXcnBB9JaX7
         bhyodnFJ1igKhQWNf0c/8XKZ16TXxICT8OkI2kvaMpgpa4NFNL8Lt+aQg0TbK2XK2SqjGPrxfv5f
         JC/zlcTin7HIXLylaBRJl342GWAM183MCOdrh8jladKdx7eOPHHInaFZIbz/uM3qp6+tgqFGV5dc
         gszsdnbhj+CmsCJWHHkGpTGrX8yCLmQqlS8qKWpgwZRB8uI3ck0BVk+Q9LYWVZvGvcCm9AvI8RfA
         9ibqKjqAXGXVOqx/oZH0/QB3zB/AKVeDaF15ouxUaEphREz55gnjMnqbPLIb1NbNB1mdyjCH4wf7
         RGYj4OMxNj0nI2wO1NHGpPVfNOIQMvyV+x94DdmuezshO14bsd2WMw8COedvNF8I4kmmjvc28=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: fix potential OOB in multipath_remove_disk()
Date:   Sat, 15 Jul 2023 17:44:53 +0800
X-OQ-MSGID: <5697119.DvuYhMxLoT@localhost.localdomain>
In-Reply-To: <ZK7Zy2U86znezl+a@infradead.org>
References: <tencent_E2C71605D88087940237AA9A44CC8D436D06@qq.com>
 <ZK7Zy2U86znezl+a@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

=E5=9C=A8 2023=E5=B9=B47=E6=9C=8813=E6=97=A5=E6=98=9F=E6=9C=9F=E5=9B=9B CST=
 =E4=B8=8A=E5=8D=8812:50:19=EF=BC=8CChristoph Hellwig =E5=86=99=E9=81=93=EF=
=BC=9A
> On Thu, Jul 13, 2023 at 12:46:05AM +0800, Zhang Shurong wrote:
> > If rddev->raid_disk is greater than mddev->raid_disks, there will be
> > an out-of-bounds in multipath_remove_disk. We have already found
> > similar reports as follows:
> >=20
> > 1) commit d17f744e883b ("md-raid10: fix KASAN warning")
> > 2) commit 1ebc2cec0b7d ("dm raid: fix KASAN warning in raid5_remove_dis=
k")
> >=20
> > Fix this bug by checking whether the "number" variable is
> > valid.
>=20
> I think it might just be time to finally dropped the deprecated md
> multipath code instead..
Should I write another patch to delete them?




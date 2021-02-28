Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C96C433E0
	for <linux-raid@archiver.kernel.org>; Sun, 28 Feb 2021 08:36:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E1464E4A
	for <linux-raid@archiver.kernel.org>; Sun, 28 Feb 2021 08:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhB1Ifq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Feb 2021 03:35:46 -0500
Received: from mail.snapdragon.cc ([103.26.41.109]:33416 "EHLO
        mail.snapdragon.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230075AbhB1Ifo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Feb 2021 03:35:44 -0500
Received: by mail.snapdragon.cc (Postfix, from userid 65534)
        id ADC0119E0896; Sun, 28 Feb 2021 08:35:00 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=snapdragon.cc;
        s=default; t=1614501299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FI0twzUp7slCmsCjWggMpgF/6378H/ti6/HquLGijQY=;
        b=K6VndYHWgDoCSQfUKIqjga50Ql8Ieq+SB/ltMsf/tlK8Btx/FGs8ctaHdww0L3bvWMb1V8
        woPq3d3DY9lgUHwho+9W2JnEN90OuiF45rsgEd5VZLYwZaVN8FqEx2swm/VpOuIZ2nnBG0
        qibEF4TbsGfI36MkytVnCwtbRrsgj6c=
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
From:   Manuel Riel <manu@snapdragon.cc>
In-Reply-To: <DBB07C8C-0D83-47DC-9B91-78AD385775E3@snapdragon.cc>
Date:   Sun, 28 Feb 2021 16:34:57 +0800
Cc:     Chris Murphy <lists@colorremedies.com>,
        Michal Moravec <michal.moravec@logicworks.cz>,
        Linux-RAID <linux-raid@vger.kernel.org>, songliubraving@fb.com,
        guoqing.jiang@cloud.ionos.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <D3026A55-A7F2-4432-87A8-3E9B2CACE4C2@snapdragon.cc>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <CAJCQCtSfz+b38fW3zdcHwMMtO1LfXSq+0xgg_DaKShmAumuCWQ@mail.gmail.com>
 <29509e08-e373-b352-d696-fcb9f507a545@xmyslivec.cz>
 <CAJCQCtRx7NJP=-rX5g_n5ZL7ypX-5z_L6d6sk120+4Avs6rJUw@mail.gmail.com>
 <695936b4-67a2-c862-9cb6-5545b4ab3c42@xmyslivec.cz>
 <CAJCQCtQWNSd123OJ_Rp8NO0=upY2Mn+SE7pdMqmyizJP028Yow@mail.gmail.com>
 <2f2f1c21-c81b-55aa-6f77-e2d3f32d32cb@xmyslivec.cz>
 <CAJCQCtTQN60V=DEkNvDedq+usfmFB+SQP2SBezUaSeUjjY46nA@mail.gmail.com>
 <4b0dd0aa-f77b-16c8-107b-0182378f34e6@xmyslivec.cz>
 <CAJCQCtQWh2JBAL_SDRG-gMd9Z1TXad7aKjZVUGdY1Akj7fn5Qg@mail.gmail.com>
 <5e79d1f8-7632-48ef-de56-9e79cba87434@xmyslivec.cz>
 <CAJCQCtTR1JZTLr+xTEZxrwh8xSfb+zpKjc+_S2tJGFofVMUdSQ@mail.gmail.com>
 <0c792470-6ee9-8254-dd57-a7a90ac95bcd@xmyslivec.cz>
 <DBB07C8C-0D83-47DC-9B91-78AD385775E3@snapdragon.cc>
To:     Vojtech Myslivec <vojtech@xmyslivec.cz>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hit another mdadm "hanger" today. No more reading possible and md4_raid6 =
stuck at 100% CPU.

I've now moved the write journal off the RAID1 device. So it's not a =
"nested" RAID any more. Hope this will help.

With only one hardware device used as write cache, I suppose only =
write-through mode[1] is suggested now.


1: https://www.kernel.org/doc/Documentation/md/raid5-cache.txt

> On Feb 11, 2021, at 11:14, Manuel Riel <manu@snapdragon.cc> wrote:
>=20
> I'm also hitting the exact same problem with XFS on RAID6 using a =
RAID1=20
> write journal on two NVMes. CentOS 8, 4.18.0-240.10.1.el8_3.x86_64.
>=20
> Symptoms:
>=20
> - high CPU usage of md4_raid6 process
> - IO wait goes up
> - IO on that file system locks up for tens of minutes and the kernel =
reports:
>=20
> [Wed Feb 10 23:23:05 2021] INFO: task md4_reclaim:1070 blocked for =
more than 20 seconds.
> [Wed Feb 10 23:23:05 2021]       Not tainted =
4.18.0-240.10.1.el8_3.x86_64 #1
> [Wed Feb 10 23:23:05 2021] "echo 0 > =
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [Wed Feb 10 23:23:05 2021] md4_reclaim     D    0  1070      2 =
0x80004000
>=20
> Already confirmed it's not a timeout mismatch. No drive errors =
reported. SCT Error Recovery
> Control is set to 7 seconds


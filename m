Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18539C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 14 Jan 2022 14:10:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiANOKf (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Jan 2022 09:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiANOKf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Jan 2022 09:10:35 -0500
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A38C061574
        for <linux-raid@vger.kernel.org>; Fri, 14 Jan 2022 06:10:34 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc9a.ko.seznam.cz (email-smtpc9a.ko.seznam.cz [10.53.11.15])
        id 210da7e18f9b2881251ec1d6;
        Fri, 14 Jan 2022 15:10:21 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642169421; bh=LP1WFz41+DZ+ZUA0PR0Sm5c/2xxKkbjozcoZlQHrzL4=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=K9M0ssmB26AK9el3anlK27c7nrsWi0IVZ2wmcwHJZVf0RlATEIt+8J0MnvCuqdNbL
         p4qx7jcHwpDG0XVMcz0Fu9lnOq6/4PcSYkPEvIkcMd4fx0mIGr8TL80YRfreeyn9RK
         B5lOq3Hnt9PH0r1sRqfreyWTOrDrHoCFDQBMSaPQ=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Fri, 14 Jan 2022 15:10:17 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Fri, 14 Jan 2022 15:10:17 +0100 (CET)
Message-Id: <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
        <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
        <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
        <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <47d81dc8-83b0-40a3-aab1-39e8bb34ebe8>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger.

>> Also, grow differs in the fact that blocks get moved around hence the w=
rites.
>
> Of course, but even of that the speed was poor :]

Just for info, I just tried to DD data on the second (faster) hardware
from one RAID drive to an empty one with MD offline and the transfer
speed is the following (sorry for the czech locale :) ...

25423+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
25422+0 z=C3=A1znam=C5=AF zaps=C3=A1no
26656899072 bajt=C5=AF (27 GB, 25 GiB) zkop=C3=ADrov=C3=A1no, 105,227 s, 2=
53 MB/s
25903+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
25902+0 z=C3=A1znam=C5=AF zaps=C3=A1no
27160215552 bajt=C5=AF (27 GB, 25 GiB) zkop=C3=ADrov=C3=A1no, 107,235 s, 2=
53 MB/s
26386+0 z=C3=A1znam=C5=AF p=C5=99e=C4=8Dteno
26385+0 z=C3=A1znam=C5=AF zaps=C3=A1no
27666677760 bajt=C5=AF (28 GB, 26 GiB) zkop=C3=ADrov=C3=A1no, 109,245 s, 2=
53 MB/s

as you can see, the write speed really matches the speed from the drive da=
tasheet,
so ... why the sync speed was 100MB/s only when the CPU load was low?
Can you explain that?

Thanks,
Jaromir

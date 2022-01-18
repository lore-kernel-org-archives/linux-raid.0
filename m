Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F62C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jan 2022 12:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238170AbiARMpa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jan 2022 07:45:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236418AbiARMpa (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jan 2022 07:45:30 -0500
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31442C061574
        for <linux-raid@vger.kernel.org>; Tue, 18 Jan 2022 04:45:29 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc2a.ng.seznam.cz (email-smtpc2a.ng.seznam.cz [10.23.10.45])
        id 049629edaa00a68d00854fda;
        Tue, 18 Jan 2022 13:45:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642509916; bh=NMQ7ok2deTuL3nqkYTkftjmIc7SAZ6Qyal6yf7lUhgc=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=fh5jkSBNRdohKedcsVOo5rOlfgTeOSAD0MX6VNnxdayk7bhRTFUzX4uZyi9XxPLu+
         bdGYBIoiGSJzNrEaYsx5qcT+qlpJkRiE9ulceLUttI5yMCHlyCKy2wb34bnHFpxj3d
         1ynhcO2h7Oa4rZIuDAC96qSaMYqe3InNfd5ru3qs=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Tue, 18 Jan 2022 13:45:08 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     Wol <antlists@youngman.org.uk>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Roger Heflin" <rogerheflin@gmail.com>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Tue, 18 Jan 2022 13:45:08 +0100 (CET)
Message-Id: <RaA.44oPz.6p7zVnhaYjw.1XvhPK@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
        <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
        <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
        <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz>
        <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
        <CAAMCDedMLUPawEwKZWw4gRSP-04SyihqiLcHeXTN2XhfDTcsKg@mail.gmail.com>
        <Pio.44oOQ.1niDXrCPXrs.1XvQvl@seznam.cz>
        <ca5651d0-ef02-4a7d-1486-2cdfb1cd4fe1@youngman.org.uk>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <36719b72-31e7-474b-ada4-1149f4fb0d72>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


>> chasis and going that way requires an external USB3 rack and a bit of=

>> magic if the operation cannot be done offline.
> 
> You seen the stuff about running raid over USB? Very unwise?

Nope, URL?

I mirror the drive in my Intel NUC router to USB3 drive and it works
for years with no problems. Of course I'm aware of lower reliability,
but I hope I'll get I/O errors if something fails. Am I wrong?

Thx, J.

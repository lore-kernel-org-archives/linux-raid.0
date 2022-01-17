Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77990C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 17 Jan 2022 17:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242069AbiAQR7k (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 17 Jan 2022 12:59:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242184AbiAQR73 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 17 Jan 2022 12:59:29 -0500
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B7AEC061574
        for <linux-raid@vger.kernel.org>; Mon, 17 Jan 2022 09:59:29 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc4b.ko.seznam.cz (email-smtpc4b.ko.seznam.cz [10.53.13.105])
        id 7dc6bb25d350344579d5dd12;
        Mon, 17 Jan 2022 18:59:16 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642442356; bh=UyU8xxw6a8ExNPw2ms5YYCcaM8985g3scEAzNPPwOao=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=kL+IKkP07wlHea8QiBDxGQNopSI15+QHRXNbBq1r+/HjdUGGFxaVp9vVxhkuWrO+W
         C7sB6ErFbiIMelxAm5TY6FSsB9RPExa1J7YngZKbFktOZbOKLLxKofdWaDV3yu+vBC
         vMIhGZ6JadAzg+B0HvgttoEH7sWg+1z3eu04vMaM=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Mon, 17 Jan 2022 18:59:11 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Mon, 17 Jan 2022 18:59:11 +0100 (CET)
Message-Id: <Pio.44oOQ.1niDXrCPXrs.1XvQvl@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
        <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
        <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
        <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz>
        <NWX.44oOw.7USLwiS0IVD.1XuOH9@seznam.cz>
        <CAAMCDedMLUPawEwKZWw4gRSP-04SyihqiLcHeXTN2XhfDTcsKg@mail.gmail.com>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <2454e2c8-6e18-41a5-b679-4167a34e66a9>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger.

>That is typically 100MB/sec per disk as it is reported, and that is a
>typical speed I have seen for a rebuild and/or grow.
>
>There are almost certainly algorithm sync points that constrain the
>speed less than full streaming speed of all disks.
>
>The algorithm may well be, read the stripe, process the stripe and
>write out the new stripe, and start over (in a linear manner)  I would
>expect that to be the easiest to keep track of, and that would roughly
>get your speed (costs a read to each old disk + a write to the new
>disk + bookkeeping writes + parity calc).     Setting up the code such
>that it overlaps the operations is going to complicate the code, and
>as such was likely not done.

Yeah, I'm pretty sure the current behavior is suboptimal just because
it was easier for the implementation. And ... surprisingly ... this
feature request is my clumsy try to convince someone amazing and clever
to change that, because ... we love Linux and wanna se it rock! Right? :D=



>And regardless of the client's only being able to run raid5, there is
>significant risks to running raid5.   If on the rebuild you find a bad
>block on one of the other disks then you have lost data, and that is
>very likely to happen--that exact failure was the first raid failure I
>saw 28+ years ago).

I'm aware of the risks ... but, losing a file or two is still much better=

than losing the whole array just because of the low sync speed when you
need to operate the array in a degraded mode for 3 days instead of 1 day.=

Making it faster seems to me quite important / reasonable.


>How often are you replacing/rebuilding the disks and why?

Few times a year, different reasons. Usually requests for higher capacity=

where I need to replace all drives one by one and then grow the array.
Sometimes reallocated sectors appear in the SMART output and I never
let such drives in the array considering them unreliable. The --replace
feature is nice, but often there's no room for one more drive in the
chasis and going that way requires an external USB3 rack and a bit of
magic if the operation cannot be done offline.

So, I still hope someone will find enough courage one day to implement
the new optional sync strategy :)

BR, J.

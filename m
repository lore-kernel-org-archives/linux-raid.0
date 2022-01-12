Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2977DC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 12 Jan 2022 18:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356448AbiALSpi (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Jan 2022 13:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356452AbiALSpf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Jan 2022 13:45:35 -0500
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DE9C06175B
        for <linux-raid@vger.kernel.org>; Wed, 12 Jan 2022 10:45:24 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc12a.ko.seznam.cz (email-smtpc12a.ko.seznam.cz [10.53.11.105])
        id 35c181b49b570ed431d2e783;
        Wed, 12 Jan 2022 19:45:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642013112; bh=4V7sE0ItE/Ltya5bP2mNNvyTcLKuT+io9LqmXLEFpvQ=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=CRMLerwu90yAEpnHexfsSyrZsA7rWWsU7kyXbvvsasemeFKOsQMFW5tKnz45ADWim
         +czsFCBgy7ceAJmRfS9s7bpiBuyyuoYHNYJ+ecA/RVbu0dHx+5dQi5cNHZeoikcNL2
         kap3c/B/O5RxW5n+JN+1abNIEz/KZ63arW3xI1MQ=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Wed, 12 Jan 2022 19:45:07 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Wed, 12 Jan 2022 19:45:07 +0100 (CET)
Message-Id: <Ly2.44rd2.7sLtKmD9o5e.1Xto6p@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
        <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
        <CAAMCDef-bxeM0a_qS0FuviZ89a_Qn496KDsj1WQ3r7NT+t5+_Q@mail.gmail.com>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <b7723520-0aa8-47dd-b3d9-1a51203fa8a0>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger.

>I have noticed on simple tests making arrays with tmpfs that Intel
>cpus seem to be able to xor about 2x the speed of AMD.   The speed may
>also vary based on cpu generation.

It was Intel in both cases and the CPU loads were low.


> Also, grow differs in the fact that blocks get moved around hence the wr=
ites.

Of course, but even of that the speed was poor :]


> On the raid you are building, is there other IO going on to the disks?=


Nope, the array was not mounted and no process was touching the MD device=

during the rebuild. 


> And if the disk has not failed you can do a --replace so long as you

In the first case there was no space left for another drive ... however,=

sometimes I can do the rebuild offline and in such cases I'll rather
clone the content of the old drive with DD. It's much faster.

> I also carefully setup the disk partition naming such that the last
> digit of the partitions matches the last digit of the md as that makes=

> the adding/re-adding simpler as I know which device it always is.

I usually do that on servers where I have multiple raid partitions.

Thx,
Jaromir.

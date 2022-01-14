Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05EF2C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 14 Jan 2022 14:44:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241929AbiANOoA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 14 Jan 2022 09:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbiANOn7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 14 Jan 2022 09:43:59 -0500
Received: from mxd2.seznam.cz (mxd2.seznam.cz [IPv6:2a02:598:2::210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9429C061574
        for <linux-raid@vger.kernel.org>; Fri, 14 Jan 2022 06:43:58 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc7b.ng.seznam.cz (email-smtpc7b.ng.seznam.cz [10.23.13.195])
        id 7493dd07da0552677080bb30;
        Fri, 14 Jan 2022 15:43:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1642171426; bh=yyccE5G5U8hjCDdaukeGsZoQ2VkXr45kLSDCd+D6BF4=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=Hpf2PS1iISKl+Uzf1b728HaPuC4Vo8XB14PUdhE9sjOVgZMxjdotDoISG+36nOuA/
         hHgaKoR4s3mlfGjOYr/y+21Vin6ZAzrGkh13Q5zvROv+VZA8aQQzwwL3wYsy2ahy1O
         dvko1rAFdPZyC0V3phEPM0detICS0UJSvtlpvivE=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Fri, 14 Jan 2022 15:43:41 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Fri, 14 Jan 2022 15:43:41 +0100 (CET)
Message-Id: <Oec.44oOZ.2sBPHLKVwjm.1XuOmT@seznam.cz>
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
X-szn-frgn: <5c013a90-eaab-4047-b814-248120d18b20>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger

> I have noticed on simple tests making arrays with tmpfs that Intel
> cpus seem to be able to xor about 2x the speed of AMD.   The speed may=

> also vary based on cpu generation.

I forgot to mention I did some tests here with -O2 optimized C code
and 1 core of the CPU can XOR aproximately 7.11GB of data per second,
so ... not really a bottleneck here.

Regards,
Jaromir

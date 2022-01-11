Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC2CC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 09:59:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348351AbiAKJ7l (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 04:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348380AbiAKJ7h (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 11 Jan 2022 04:59:37 -0500
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4DF3C06173F
        for <linux-raid@vger.kernel.org>; Tue, 11 Jan 2022 01:59:36 -0800 (PST)
Received: from email.seznam.cz
        by email-smtpc27a.ko.seznam.cz (email-smtpc27a.ko.seznam.cz [10.53.18.38])
        id 22aa092a8c3c864a26b96f1d;
        Tue, 11 Jan 2022 10:59:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1641895164; bh=XUQJpKWMQUbcX7I/WiD8vwWRUFnq2HodqARHNLd5HiE=;
        h=Received:From:To:Cc:Subject:Date:Message-Id:References:
         Mime-Version:X-Mailer:Content-Type:Content-Transfer-Encoding:
         X-szn-frgn:X-szn-frgc;
        b=Nk8yXHsX8A1F8zMtLqHDihMuhHBYG5EsN69lTLV/1dbbkeNegp/jm8X0Fd8TAVv6l
         bQxTewdjfQJJcrc0F114u9BHCOYn/VGXXyRYCrBjHrWzudjbRE6SADkM5Jr5ZgTZsy
         CB5DA+Hca/+TyjTc1FxLbAmdoRa+8WcLMY3ipbDI=
Received: from unknown ([::ffff:46.13.60.217])
        by email.seznam.cz (szn-ebox-5.0.95) with HTTP;
        Tue, 11 Jan 2022 10:59:20 +0100 (CET)
From:   =?utf-8?q?Jarom=C3=ADr_C=C3=A1p=C3=ADk?= <jaromir.capik@email.cz>
To:     "Roger Heflin" <rogerheflin@gmail.com>
Cc:     "Linux RAID" <linux-raid@vger.kernel.org>,
        "Wols Lists" <antlists@youngman.org.uk>
Subject: =?utf-8?q?Re=3A_Feature_request=3A_Add_flag_for_assuming_a_new_cl?=
        =?utf-8?q?ean_drive_completely_dirty_when_adding_to_a_degraded_raid5_arra?=
        =?utf-8?q?y_in_order_to_increase_the_speed_of_the_array_rebuild?=
Date:   Tue, 11 Jan 2022 10:59:20 +0100 (CET)
Message-Id: <KN4.44rdw.1WKWgyVtkH0.1XtLJu@seznam.cz>
References: <Ja6.44rcR.6N3YLK}k{ZL.1XskzP@seznam.cz>
        <0394837e-0109-e7b7-59f9-5e90a03bc629@youngman.org.uk>
        <CAAMCDec5kcK62enZCOh=SJZu0fecSV60jW8QjMierC147HE5bA@mail.gmail.com>
Mime-Version: 1.0 (szn-mime-2.1.18)
X-Mailer: szn-ebox-5.0.95
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-szn-frgn: <706f211c-f01d-4d92-a565-fafaa7bb1e07>
X-szn-frgc: <0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Roger.

I just run atop on a different and much better hardware doing mdadm --grow=
 on raid5 with 4 drives and it shows the following

DSK | sdl | | busy 90% | read 950=C2=A0 | | write 502 | | KiB/r 1012 | KiB=
/w 506 | | MBr/s 94.0 | | MBw/s 24.9 | | avq 1.29 | avio 6.22 ms | |
DSK | sdk | | busy 89% | read 968=C2=A0 | | write 499 | | KiB/r 995=C2=A0 =
| KiB/w 509 | | MBr/s 94.1 | | MBw/s 24.8 | | avq 0.92 | avio 6.09 ms | |=

DSK | sdj | | busy 88% | read 1004 | | write 503 | | KiB/r 958=C2=A0 | KiB=
/w 505 | | MBr/s 94.0 | | MBw/s 24.8 | | avq 0.66 | avio 5.91 ms | |
DSK | sdi | | busy 87% | read 1013 | | write 499 | | KiB/r 949=C2=A0 | KiB=
/w 509 | | MBr/s 94.0 | | MBw/s 24.8 | | avq 0.65 | avio 5.81 ms | |

Personalities : [raid1] [raid6] [raid5] [raid4] [linear] [multipath] [raid=
0] [raid10] 
md3 : active raid5 sdi1[5] sdl1[6] sdk1[4] sdj1[2]
      46877237760 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/4] =
[UUUU]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]  resync =
=3D 88.5% (13834588672/15625745920) finish=3D293.1min speed=3D101843K/sec=

      bitmap: 8/59 pages [32KB], 131072KB chunk

Surprisingly all 4 drives show approximately 94MB/s read and 25MB/s write.=

Even when each of the drives can read 270MB/s and write 250MB/s, the sync =
speed is 100MB/s only, so?

Does --grow differ from --add?

Thanks,
Jaromir



---------- P=C5=AFvodn=C3=AD e-mail ----------

Od: Roger Heflin <rogerheflin@gmail.com>

Komu: Wols Lists <antlists@youngman.org.uk>

Datum: 11. 1. 2022 1:15:17

P=C5=99edm=C4=9Bt: Re: Feature request: Add flag for assuming a new clean =
drive
 completely dirty when adding to a degraded raid5 array in order to increa=
se
 the speed of the array rebuild

I just did a "--add" with sdd on a raid6 array missing a volume and here i=
s what sar shows:

06:08:12 PM =C2=A0 =C2=A0 =C2=A0 sdb =C2=A0 =C2=A0 91.03 =C2=A034615.97 =
=C2=A0 =C2=A0 =C2=A00.36 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0380.26 =
=C2=A0 =C2=A0 =C2=A00.41 =C2=A0 =C2=A0 =C2=A04.47 =C2=A0 =C2=A0 30.31
06:08:12 PM =C2=A0 =C2=A0 =C2=A0 sdc =C2=A0 =C2=A0 =C2=A00.02 =C2=A0 =
=C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A00.00
06:08:12 PM =C2=A0 =C2=A0 =C2=A0 sdd =C2=A0 =C2=A0 77.12 =C2=A0 =C2=A0 26.=
28 =C2=A034563.36 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0448.54 =C2=A0 =
=C2=A0 =C2=A00.64 =C2=A0 =C2=A0 =C2=A08.23 =C2=A0 =C2=A0 27.40
06:08:12 PM =C2=A0 =C2=A0 =C2=A0 sde =C2=A0 =C2=A0 36.45 =C2=A034598.82 =
=C2=A0 =C2=A0 =C2=A00.36 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0949.22 =
=C2=A0 =C2=A0 =C2=A01.43 =C2=A0 =C2=A0 38.78 =C2=A0 =C2=A0 70.37
06:08:12 PM =C2=A0 =C2=A0 =C2=A0 sdf =C2=A0 =C2=A0 46.87 =C2=A034598.89 =
=C2=A0 =C2=A0 =C2=A00.36 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0738.25 =
=C2=A0 =C2=A0 =C2=A01.23 =C2=A0 =C2=A0 26.13 =C2=A0 =C2=A0 57.81

06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sda =C2=A0 =C2=A0 =C2=A05.12 =C2=A0 =
=C2=A0 =C2=A00.93 =C2=A0 =C2=A0 75.33 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 14.91 =C2=A0 =C2=A0 =C2=A00.01 =C2=A0 =C2=A0 =C2=A01.48 =C2=A0 =
=C2=A0 =C2=A00.39
06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sdb =C2=A0 =C2=A0122.57 =C2=A046819.67 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0382.00 =
=C2=A0 =C2=A0 =C2=A00.54 =C2=A0 =C2=A0 =C2=A04.38 =C2=A0 =C2=A0 35.85
06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sdc =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A00.00
06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sdd =C2=A0 =C2=A0105.92 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A046775.73 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0441.63 =
=C2=A0 =C2=A0 =C2=A01.12 =C2=A0 =C2=A0 10.53 =C2=A0 =C2=A0 35.80
06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sde =C2=A0 =C2=A0 48.47 =C2=A046817.53 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0965.98 =
=C2=A0 =C2=A0 =C2=A01.95 =C2=A0 =C2=A0 40.00 =C2=A0 =C2=A0 97.89
06:09:12 PM =C2=A0 =C2=A0 =C2=A0 sdf =C2=A0 =C2=A0 56.95 =C2=A046834.53 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0822.39 =
=C2=A0 =C2=A0 =C2=A01.73 =C2=A0 =C2=A0 30.32 =C2=A0 =C2=A0 82.33


06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sda =C2=A0 =C2=A0 =C2=A04.55 =C2=A0 =
=C2=A0 =C2=A01.20 =C2=A0 =C2=A0 48.20 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 10.86 =C2=A0 =C2=A0 =C2=A00.01 =C2=A0 =C2=A0 =C2=A00.97 =C2=A0 =
=C2=A0 =C2=A00.27

06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sdb =C2=A0 =C2=A0123.67 =C2=A046616.93 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0376.96 =
=C2=A0 =C2=A0 =C2=A00.52 =C2=A0 =C2=A0 =C2=A04.15 =C2=A0 =C2=A0 34.66
06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sdc =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A00.00
06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sdd =C2=A0 =C2=A0109.82 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A046623.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0424.56 =
=C2=A0 =C2=A0 =C2=A01.30 =C2=A0 =C2=A0 11.80 =C2=A0 =C2=A0 36.15
06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sde =C2=A0 =C2=A0 49.18 =C2=A046602.00 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0947.52 =
=C2=A0 =C2=A0 =C2=A01.93 =C2=A0 =C2=A0 39.17 =C2=A0 =C2=A0 97.27
06:10:12 PM =C2=A0 =C2=A0 =C2=A0 sdf =C2=A0 =C2=A0 54.88 =C2=A046601.07 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0849.10 =
=C2=A0 =C2=A0 =C2=A01.75 =C2=A0 =C2=A0 31.82 =C2=A0 =C2=A0 85.16


06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sda =C2=A0 =C2=A0 =C2=A04.07 =C2=A0 =
=C2=A0 =C2=A01.00 =C2=A0 =C2=A0 50.80 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 12.74 =C2=A0 =C2=A0 =C2=A00.01 =C2=A0 =C2=A0 =C2=A01.77 =C2=A0 =
=C2=A0 =C2=A00.30

06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sdb =C2=A0 =C2=A0121.93 =C2=A046363.20 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0380.24 =
=C2=A0 =C2=A0 =C2=A00.51 =C2=A0 =C2=A0 =C2=A04.10 =C2=A0 =C2=A0 34.72
06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sdc =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A00.00
06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sdd =C2=A0 =C2=A0109.58 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A046372.47 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0423.17 =
=C2=A0 =C2=A0 =C2=A01.37 =C2=A0 =C2=A0 12.44 =C2=A0 =C2=A0 35.69
06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sde =C2=A0 =C2=A0 49.38 =C2=A046371.00 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0939.01 =
=C2=A0 =C2=A0 =C2=A01.93 =C2=A0 =C2=A0 38.88 =C2=A0 =C2=A0 97.09
06:11:12 PM =C2=A0 =C2=A0 =C2=A0 sdf =C2=A0 =C2=A0 55.12 =C2=A046352.53 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0841.00 =
=C2=A0 =C2=A0 =C2=A01.73 =C2=A0 =C2=A0 31.39 =C2=A0 =C2=A0 85.25


06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sda =C2=A0 =C2=A0 =C2=A05.75 =C2=A0 =
=C2=A0 14.20 =C2=A0 =C2=A0 79.05 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 16=
.22 =C2=A0 =C2=A0 =C2=A00.01 =C2=A0 =C2=A0 =C2=A01.78 =C2=A0 =C2=A0 =C2=A0=
0.40

06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sdb =C2=A0 =C2=A0120.73 =C2=A045994.13 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0380.97 =
=C2=A0 =C2=A0 =C2=A00.51 =C2=A0 =C2=A0 =C2=A04.20 =C2=A0 =C2=A0 34.72
06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sdc =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =
=C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0=
 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0 =C2=A00.00 =
=C2=A0 =C2=A0 =C2=A00.00
06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sdd =C2=A0 =C2=A0110.95 =C2=A0 =C2=A0 =
=C2=A00.00 =C2=A045982.87 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0414.45 =
=C2=A0 =C2=A0 =C2=A01.43 =C2=A0 =C2=A0 12.81 =C2=A0 =C2=A0 35.39
06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sde =C2=A0 =C2=A0 49.63 =C2=A046020.46 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0927.37 =
=C2=A0 =C2=A0 =C2=A01.91 =C2=A0 =C2=A0 38.39 =C2=A0 =C2=A0 96.18
06:12:12 PM =C2=A0 =C2=A0 =C2=A0 sdf =C2=A0 =C2=A0 54.27 =C2=A046022.80 =
=C2=A0 =C2=A0 =C2=A00.40 =C2=A0 =C2=A0 =C2=A00.00 =C2=A0 =C2=A0847.97 =
=C2=A0 =C2=A0 =C2=A01.75 =C2=A0 =C2=A0 32.14 =C2=A0 =C2=A0 86.65



So there are very few reads going on for sdd, but a lot of reads of the ot=
her disks to recalculate what the data on that disk.

This is on raid6, but if raid6 is not doing a pointless check read on a ne=
w disk add, I would not expect raid5 to be.


This is on a 5.14 kernel.



On Mon, Jan 10, 2022 at 5:15 PM Wols Lists <antlists@youngman.org.uk> wrot=
e:

On 09/01/2022 14:21, Jarom=C3=ADr C=C3=A1p=C3=ADk wrote:

> In case of huge arrays (48TB in my case) the array rebuild takes a coupl=
e of

> days with the current approach even when the array is idle and during th=
at

> time any of the drives could fail causing a fatal data loss.

> 

> Does it make at least a bit of sense or my understanding and assumptions=


> are wrong?



It does make sense, but have you read the code to see if it already does i=
t?



And if it doesn't, someone's going to have to write it, in which case it =


doesn't make sense, not to have that as the default.



Bear in mind that rebuilding the array with a new drive is completely 

different logic to doing an integrity check, so will need its own code, =


so I expect it already works that way.



I think you've got two choices. Firstly, raid or not, you should have 

backups! Raid is for high-availability, not for keeping your data safe! =


And secondly, go raid-6 which gives you that bit extra redundancy.



Cheers,

Wol




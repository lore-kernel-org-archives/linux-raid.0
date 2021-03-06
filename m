Return-Path: <SRS0=ebs+=IE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37A7C433E0
	for <linux-raid@archiver.kernel.org>; Sat,  6 Mar 2021 18:46:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67EB865005
	for <linux-raid@archiver.kernel.org>; Sat,  6 Mar 2021 18:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230429AbhCFSpc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 6 Mar 2021 13:45:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbhCFSp1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 6 Mar 2021 13:45:27 -0500
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97924C06174A
        for <linux-raid@vger.kernel.org>; Sat,  6 Mar 2021 10:45:26 -0800 (PST)
Received: by mail-lf1-x136.google.com with SMTP id r3so3840019lfc.13
        for <linux-raid@vger.kernel.org>; Sat, 06 Mar 2021 10:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=a0VJ572eJYYpPbau4Hhy/1onW5TlMa0SQWVFApHsvB8=;
        b=g9+YEhWbbuzn2baQ2uWdbFBLdHidDh7aArPvTXkpiwnTjcpRxS1y4KTHH71YFRBCYM
         ERgPb0osNHKRFnvsLonmuCMH5xfYwK1/PltDAby1rMOW7QGn2dfvbWWd8cOcAi5OFgla
         ama1wPVHNxQMYFaJtFI5j5UfPh89wlddKfRDM9xLeWow5diuOwaOWeuTJySm49seMpPf
         MNyyGnsMJypNz9hH+C8n2x7cLBPpNssxsSNi7Y1Vb4olAYWx4Opo3cGXAX+3BxTyoBgt
         uxKjZ8w6KNM7C4oBOSphJmKDlRpzG3/rmY/ed7Adg5qooEhN+V06ZcBZ3oHV91AMl0uT
         6X5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=a0VJ572eJYYpPbau4Hhy/1onW5TlMa0SQWVFApHsvB8=;
        b=RRjyL+ZeyI+LnqKiZ/RkmDHlQRp5pB2EnXXBKeSno7Aa7tm0dvQFkkMqEw748kS6Gw
         qiml37YaDkoFTFESC/oaDYRnTuDmcMT5ph632RKeaxEku3wa6rK12eMX1R7C3DfKedAv
         ICrQFtp5wlmd1cODhf0DBbLNc+5yrzz/y5QNhGfUO2rwfKoPCq/609vY49Zc7bH82wfm
         dIfijJ4bsSlxPL2J+JSy3e6/3mj82Zw6CYBZoCbNEuNBVog7k952y6UZNB747ZUD8is+
         QfdErl03zh8+FU996baKRC72xv3Dwl02XXGd05YzS5pV6lQijuUewUTdI54xysuQrDxu
         xAqw==
X-Gm-Message-State: AOAM532Y831pXnp9GraXgggKcF297eO/p5J+wWHMj5rb+WnB/bN26OhO
        YXnvtqVRPnKOvwUmpEa3zTBg823UucL0HOyQzLNxovDK
X-Google-Smtp-Source: ABdhPJyDdtJYDi5/WodXFQXWAqBs7qz5Zjq/JlE293CZX6psBxqkRYVT82HN8y+zQt6D/ERQMAyQMhBjZCqD/vmi3DY=
X-Received: by 2002:a19:592:: with SMTP id 140mr9044235lff.411.1615056324501;
 Sat, 06 Mar 2021 10:45:24 -0800 (PST)
MIME-Version: 1.0
References: <CAPJ7j64RtvGb3=OFde+rDmeBA3GzqAKtpofvTnrhjkfm2m7ehw@mail.gmail.com>
 <37c996dd-7962-642d-3276-2fc73f115f9f@youngman.org.uk>
In-Reply-To: <37c996dd-7962-642d-3276-2fc73f115f9f@youngman.org.uk>
From:   apfc123@gmail.com
Date:   Sat, 6 Mar 2021 18:45:12 +0000
Message-ID: <CAPJ7j66x0CJ8hXC8_xZToGYUyUgY0WHW+dnhEVrb7+4CgQOpVg@mail.gmail.com>
Subject: Re: Raid5 to Raid6 reshape stalled
To:     antlists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thanks, info below.

Linux debian 4.19.0-6-amd64 #1 SMP Debian 4.19.67-2+deb10u1
(2019-09-20) x86_64 GNU/Linux
mdadm - v4.1 - 2018-10-01

/dev/sda
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     HITACHI HUS724040ALE640
Serial Number:    PBJBNNET
LU WWN Device Id: 5 000cca 23de17ca4
Firmware Version: MJAONS04
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:45:04 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdb
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     MB4000GCWDC
Serial Number:    Z1Z8YWB0
LU WWN Device Id: 5 000c50 07ba725b1
Firmware Version: HPGH
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:46:12 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdc
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCHP96XB
LU WWN Device Id: 5 000cca 24cd7c5eb
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:46:39 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdd
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WL4000GSA6472E
Serial Number:    WOL240331724
LU WWN Device Id: 5 0014ee 0588c0835
Firmware Version: A.01
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:46:58 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sde
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCGSLX3B
LU WWN Device Id: 5 000cca 24ccabb82
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:47:15 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdf
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     HITACHI HUS724040ALE640
Serial Number:    PAGLKHEW
LU WWN Device Id: 5 000cca 22bc8705d
Firmware Version: MJAONS04
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:47:31 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdg
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     MB4000GCWDC
Serial Number:    Z1Z8YWJN
LU WWN Device Id: 5 000c50 07ba717cf
Firmware Version: HPGH
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:47:46 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdh
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCGK79AB
LU WWN Device Id: 5 000cca 24cc7d5b7
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:48:01 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdi
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Toshiba 3.5" MG03ACAxxx(Y) Enterprise HDD
Device Model:     TOSHIBA MG03ACA400
Serial Number:    5443K65YF
LU WWN Device Id: 5 000039 58b8009aa
Firmware Version: FL1A
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:48:15 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdj
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WL4000GSA6472E
Serial Number:    WOL240332040
LU WWN Device Id: 5 0014ee 25ddc3495
Firmware Version: 01.01A01
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:48:28 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdk
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     MB4000GCWDC
Serial Number:    Z1Z8XQ9J
LU WWN Device Id: 5 000c50 07b9764b6
Firmware Version: HPGH
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2, ATA8-ACS T13/1699-D revision 6
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:48:41 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdl
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PAJWABKT
LU WWN Device Id: 5 000cca 22be89bf7
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:48:54 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdm
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCG1JAVB
LU WWN Device Id: 5 000cca 24cc0b1bf
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:49:06 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdn
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     HITACHI HUS724040ALE640
Serial Number:    PAJK4VMS
LU WWN Device Id: 5 000cca 22be3fb8e
Firmware Version: MJAONS04
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:49:22 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdo
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCG62VNB
LU WWN Device Id: 5 000cca 24cc2c4f6
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:49:34 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdp
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Hitachi/HGST Ultrastar 7K4000
Device Model:     Hitachi HUS724040ALE641
Serial Number:    PCGSNTTB
LU WWN Device Id: 5 000cca 24ccac29d
Firmware Version: MJAOA5F0
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Mar  6 17:49:53 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdq
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     HITACHI HUS724040ALE640
Serial Number:    PAGTSZES
LU WWN Device Id: 5 000cca 22bcb42ee
Firmware Version: MJAONS04
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:50:05 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)

/dev/sdr
=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Device Model:     WL4000GSA6472E
Serial Number:    WOL240331985
LU WWN Device Id: 5 0014ee 003311232
Firmware Version: 01.01A01
User Capacity:    4,000,787,030,016 bytes [4.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Mar  6 17:50:18 2021 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)



/dev/sda:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4d
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 220e5a63:3311984e:f28d4b05:593c684e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad
blocks present.
       Checksum : 6c62a047 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : c9b754df:84118329:c4e1a36b:bd4c7f83

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 5eb7ae75 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 10
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 0b7f323c:5bcbd1c3:89ef2cd2:fa501410

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 49024193 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 17
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 8c0905ef:8e190062:0a5135ab:5ca3cfa0

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 3c6ce1f - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 896fcc0c:f8b4b6ab:d8056a44:558d0093

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : f6aa6e5a - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 14
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : a9bbd48d:24117e4b:f0b0c881:4765bc46

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 89499a5 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdg:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 01be0b84:bc5ab713:b1352502:de23ddfa

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : fb8228f1 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 9
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdh:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 32f81397:6f0115a4:c3fa2d02:c078170e

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : b22b23ce - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 16
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdi:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 0afa52a2:0f7f4f1f:14e924da:d06d9015

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 181486a1 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 7
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdj:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : db1d31c6:cde52a67:9e4c48cc:18bc5dcb

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 2bbec2fc - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdk:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4d
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 3d9fab1f:172871cc:02215dee:f6c525be

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad
blocks present.
       Checksum : ff5c655d - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 11
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdl:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdl1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4d
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 114ed6e6:9ab8d767:1fcfeacb:4c408814

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad
blocks present.
       Checksum : 95de0ba8 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdm:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdm1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : c8daba50:67137919:9bead1ab:88d3d498

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 159762fe - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 15
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdn:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdn1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : b0893bc1:40c9b3ad:fdf4f722:3acef4c6

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : bf98ccc6 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdo:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdo1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : c07db065:7316a61b:aac57004:2641fc5f

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 4c8051b0 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 13
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdp:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdp1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x47
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
Recovery Offset : 4561114112 sectors
          State : active
    Device UUID : 5843bab9:17b0f8ae:f7712bee:41a23f6c

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 39b7d25a - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 12
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdq:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdq1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x45
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : 45b14d19:6d4b9afc:e51c3747:c46230b8

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors
       Checksum : 7c0c3300 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 8
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

/dev/sdr:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdr1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x4d
     Array UUID : 2a0d5568:ea53b429:30df79c9:e7559668
           Name : debian:0  (local to host debian)
  Creation Time : Tue Dec 17 01:51:38 2019
     Raid Level : raid6
   Raid Devices : 18

 Avail Dev Size : 7813770895 (3725.90 GiB 4000.65 GB)
     Array Size : 62510161920 (59614.34 GiB 64010.41 GB)
  Used Dev Size : 7813770240 (3725.90 GiB 4000.65 GB)
    Data Offset : 264192 sectors
     New Offset : 247808 sectors
   Super Offset : 8 sectors
          State : active
    Device UUID : f27bbac9:00333c9b:c68170ea:a3507ccd

Internal Bitmap : 8 sectors from superblock
  Reshape pos'n : 36488912896 (34798.54 GiB 37364.65 GB)
  Delta Devices : 5 (13->18)
     New Layout : left-symmetric

    Update Time : Sat Mar  6 17:30:59 2021
  Bad Block Log : 512 entries available at offset 24 sectors - bad
blocks present.
       Checksum : 83a03807 - correct
         Events : 303248

         Layout : left-symmetric-6
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAAAAAAAAAAAAA ('A' =3D=3D active, '.' =3D=3D missing,
'R' =3D=3D replacing)

lsdrv
**Warning** The following utility(ies) failed to execute:
  sginfo
  lsusb
Some information may be missing.

PCI [mpt3sas] 05:00.0 Serial Attached SCSI controller: LSI Logic /
Symbios Logic SAS2308 PCI-Express Fusion-MPT SAS-2 (rev 05)
=E2=94=94scsi 0:x:x:x [Empty]
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10
Family) 4 port SATA IDE Controller #1
=E2=94=94scsi 1:x:x:x [Empty]
PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10
Family) 2 port SATA IDE Controller #2
=E2=94=94scsi 3:x:x:x [Empty]
PCI [pata_marvell] 09:00.0 IDE interface: Marvell Technology Group
Ltd. 88SE6121 SATA II / PATA Controller (rev b2)
=E2=94=94scsi 5:x:x:x [Empty]
USB [usb-storage]  {13618102022400B0}
=E2=94=94scsi 8:0:0:0 ADATA    USB Flash Drive
 =E2=94=94sds 7.24g [65:32] Partitioned (dos)
  =E2=94=9Csds1 1.24g [65:33] vfat 'D-LIVE_10_2' {3E9E-7588}
  =E2=94=82=E2=94=9CMounted as /dev/sds1 @ /run/live/persistence/sds1
  =E2=94=82=E2=94=94Mounted as /dev/sds1 @ /usr/lib/live/mount/persistence/=
sds1
  =E2=94=94sds2 6.00g [65:34] ext3 'persistence' {bfde904d-48e4-3741-969a-5=
ad1f0033243}
   =E2=94=9CMounted as /dev/sds2 @ /run/live/persistence/sds2
   =E2=94=94Mounted as /dev/sds2 @ /usr/lib/live/mount/persistence/sds2
PCI [mpt3sas] 07:00.0 Serial Attached SCSI controller: LSI Logic /
Symbios Logic SAS2308 PCI-Express Fusion-MPT SAS-2 (rev 05)
=E2=94=9Cphy-7:0:12 scsi 7:0:0:0 ATA      HITACHI HUS72404 {PBJBNNET}
=E2=94=82=E2=94=94sda 3.64t [8:0] Partitioned (gpt)
=E2=94=82 =E2=94=94sda1 3.64t [8:1] MD raid6 (3/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,=
sdq1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82   =E2=94=82                PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=82   =E2=94=94VG super 40.02t 0 free {EqBsuH-weZl-urAI-aO2f-PiO6-rAO=
3-J8m1F9}
=E2=94=82    =E2=94=9Cdm-1 39.73t [253:1] LV nova ext4 {d1359e47-522e-41f5-=
bb38-8d8d40826e9e}
=E2=94=82    =E2=94=94dm-0 300.00g [253:0] LV star ext4 {dde10d6e-5e4d-4196=
-8abe-d36d863c97cd}
=E2=94=9Cphy-7:0:14 scsi 7:0:1:0 ATA      MB4000GCWDC      {Z1Z8YWB0}
=E2=94=82=E2=94=94sdb 3.64t [8:16] Partitioned (gpt)
=E2=94=82 =E2=94=94sdb1 3.64t [8:17] MD raid6 (10/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:15 scsi 7:0:2:0 ATA      Hitachi HUS72404 {PCHP96XB}
=E2=94=82=E2=94=94sdc 3.64t [8:32] Partitioned (gpt)
=E2=94=82 =E2=94=94sdc1 3.64t [8:33] MD raid6 (17/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:18 scsi 7:0:3:0 ATA      WL4000GSA6472E   {WOL240331724}
=E2=94=82=E2=94=94sdd 3.64t [8:48] Partitioned (gpt)
=E2=94=82 =E2=94=94sdd1 3.64t [8:49] MD raid6 (1/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:19 scsi 7:0:4:0 ATA      HITACHI HUS72404 {PAGLKHEW}
=E2=94=82=E2=94=94sdf 3.64t [8:80] Partitioned (gpt)
=E2=94=82 =E2=94=94sdf1 3.64t [8:81] MD raid6 (4/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:20 scsi 7:0:5:0 ATA      MB4000GCWDC      {Z1Z8YWJN}
=E2=94=82=E2=94=94sdg 3.64t [8:96] Partitioned (gpt)
=E2=94=82 =E2=94=94sdg1 3.64t [8:97] MD raid6 (9/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:21 scsi 7:0:6:0 ATA      Hitachi HUS72404 {PCGK79AB}
=E2=94=82=E2=94=94sdh 3.64t [8:112] Partitioned (gpt)
=E2=94=82 =E2=94=94sdh1 3.64t [8:113] MD raid6 (16/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:23 scsi 7:0:7:0 ATA      TOSHIBA MG03ACA4 {5443K65YF}
=E2=94=82=E2=94=94sdi 3.64t [8:128] Partitioned (gpt)
=E2=94=82 =E2=94=94sdi1 3.64t [8:129] MD raid6 (7/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:25 scsi 7:0:8:0 ATA      WL4000GSA6472E   {WOL240332040}
=E2=94=82=E2=94=94sdj 3.64t [8:144] Partitioned (gpt)
=E2=94=82 =E2=94=94sdj1 3.64t [8:145] MD raid6 (0/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:26 scsi 7:0:9:0 ATA      Hitachi HUS72404 {PAJWABKT}
=E2=94=82=E2=94=94sdl 3.64t [8:176] Partitioned (gpt)
=E2=94=82 =E2=94=94sdl1 3.64t [8:177] MD raid6 (5/18 (13)) (w/
sdo1,sdn1,sdm1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:27 scsi 7:0:10:0 ATA      Hitachi HUS72404 {PCG1JAVB}
=E2=94=82=E2=94=94sdm 3.64t [8:192] Partitioned (gpt)
=E2=94=82 =E2=94=94sdm1 3.64t [8:193] MD raid6 (15/18 (13)) (w/
sdo1,sdn1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:28 scsi 7:0:11:0 ATA      Hitachi HUS72404 {PCGSLX3B}
=E2=94=82=E2=94=94sde 3.64t [8:64] Partitioned (gpt)
=E2=94=82 =E2=94=94sde1 3.64t [8:65] MD raid6 (14/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:29 scsi 7:0:12:0 ATA      MB4000GCWDC      {Z1Z8XQ9J}
=E2=94=82=E2=94=94sdk 3.64t [8:160] Partitioned (gpt)
=E2=94=82 =E2=94=94sdk1 3.64t [8:161] MD raid6 (11/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:30 scsi 7:0:13:0 ATA      HITACHI HUS72404 {PAJK4VMS}
=E2=94=82=E2=94=94sdn 3.64t [8:208] Partitioned (gpt)
=E2=94=82 =E2=94=94sdn1 3.64t [8:209] MD raid6 (2/18 (13)) (w/
sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:31 scsi 7:0:14:0 ATA      Hitachi HUS72404 {PCG62VNB}
=E2=94=82=E2=94=94sdo 3.64t [8:224] Partitioned (gpt)
=E2=94=82 =E2=94=94sdo1 3.64t [8:225] MD raid6 (13/18 (13)) (w/
sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:32 scsi 7:0:15:0 ATA      Hitachi HUS72404 {PCGSNTTB}
=E2=94=82=E2=94=94sdp 3.64t [8:240] Partitioned (gpt)
=E2=94=82 =E2=94=94sdp1 3.64t [8:241] MD raid6 (12/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,=
sdq1,sda1)
spare 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=9Cphy-7:0:33 scsi 7:0:16:0 ATA      HITACHI HUS72404 {PAGTSZES}
=E2=94=82=E2=94=94sdq 3.64t [65:0] Partitioned (gpt)
=E2=94=82 =E2=94=94sdq1 3.64t [65:1] MD raid6 (8/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdr1,sdb1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
=E2=94=82  =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGR=
ADED, 512k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
=E2=94=82                    PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
=E2=94=94phy-7:0:34 scsi 7:0:17:0 ATA      WL4000GSA6472E   {WOL240331985}
 =E2=94=94sdr 3.64t [65:16] Partitioned (gpt)
  =E2=94=94sdr1 3.64t [65:17] MD raid6 (6/18 (13)) (w/
sdo1,sdn1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdd1,sdc1,sdb1,sdq1,=
sda1,sdp1)
in_sync 'debian:0' {2a0d5568-ea53-b429-30df-79c9e7559668}
   =E2=94=94md0 40.02t [9:0] MD v1.2 raid6 (18 (13)) read-auto DEGRADED, 51=
2k
Chunk {2a0d5568:ea53b429:30df79c9:e7559668}
                     PV LVM2_member 40.02t used, 0 free
{HUYjPl-6dU0-53un-71iH-1MAx-dEMU-HtvuV0}
Other Block Devices
=E2=94=9Cloop0 610.27m [7:0] squashfs
=E2=94=82=E2=94=9CMounted as /dev/loop0 @ /run/live/rootfs/filesystem.squas=
hfs
=E2=94=82=E2=94=94Mounted as /dev/loop0 @ /usr/lib/live/mount/rootfs/filesy=
stem.squashfs
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=94loop7 0.00k [7:7] Empty/Unknown

mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active (auto-read-only) raid6 sde1[16] sda1[3] sdj1[0] sdr1[6]
sdl1[5] sdi1[7] sdf1[4] sdo1[17] sdh1[14] sdq1[8] sdc1[13] sdn1[2]
sdm1[15] sdd1[1] sdp1[18] sdg1[9] sdk1[12] sdb1[10]
      42975736320 blocks super 1.2 level 6, 512k chunk, algorithm 18
[18/17] [UUUUUUUUUUUU_UUUUU]
          resync=3DPENDING
      bitmap: 17/30 pages [68KB], 65536KB chunk

unused devices: <none>

Half the drives actually had SCT/ECR disabled. I ran the script which
set all the drives to 7s and tried reshaping again but still stalling.

On Sat, Mar 6, 2021 at 1:20 PM antlists <antlists@youngman.org.uk> wrote:
>
> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
>
> You've obviously covered some of this - glitches with Ubuntu and old
> mdadm are common but this clearly isn't that ...
>
> Please give us the information that page asks for - it probably won't
> help much, but some things sometimes jump out ...
>
> Cheers,
> Wol
>
> On 06/03/2021 11:36, apfc123@gmail.com wrote:
> > Hello,
> >
> > Reshape is currently stalled at 58%. If I reboot the system, the array
> > is started in auto-read-only mode with resync pending. I can freeze
> > the sync and mount the filesystem read only to access the data.
> >
> > When it first stalled and rebooted, I ran extended smart tests on all
> > 18 drives and one came back with read error. I ddrescued it to a new
> > one (99.99% rescued) and swapped it out, but the reshape still stalls
> > immediately when setting the array to --readwrite.
> >
> > The raid5 array started out with 12 drives. I added 6 more drives then
> > grew it to 18 drives and raid level 6 at the same time. This migration
> > was started with mdadm 4.1 running on kernel 4.19. I've tried booting
> > with debian testing running kernel 5.10 (didn't check mdadm version),
> > and also archlinux running 5.11 but with the same results.
> >
> > /dev/md0:
> >             Version : 1.2
> >       Creation Time : Tue Dec 17 01:51:38 2019
> >          Raid Level : raid6
> >          Array Size : 42975736320 (40984.86 GiB 44007.15 GB)
> >       Used Dev Size : 3906885120 (3725.90 GiB 4000.65 GB)
> >        Raid Devices : 18
> >       Total Devices : 18
> >         Persistence : Superblock is persistent
> >
> >       Intent Bitmap : Internal
> >
> >         Update Time : Sat Mar  6 09:41:58 2021
> >               State : clean, degraded, resyncing (PENDING)
> >      Active Devices : 17
> >     Working Devices : 18
> >      Failed Devices : 0
> >       Spare Devices : 1
> >
> >              Layout : left-symmetric-6
> >          Chunk Size : 512K
> >
> > Consistency Policy : bitmap
> >
> >       Delta Devices : 5, (13->18)
> >          New Layout : left-symmetric
> >
> >                Name : debian:0  (local to host debian)
> >                UUID : 2a0d5568:ea53b429:30df79c9:e7559668
> >              Events : 303246
> >
> >      Number   Major   Minor   RaidDevice State
> >         0       8      129        0      active sync   /dev/sdi1
> >         1       8       49        1      active sync   /dev/sdd1
> >         2       8      209        2      active sync   /dev/sdn1
> >         3       8        1        3      active sync   /dev/sda1
> >         4       8       65        4      active sync   /dev/sde1
> >         5       8      145        5      active sync   /dev/sdj1
> >         6      65       17        6      active sync   /dev/sdr1
> >         7       8      113        7      active sync   /dev/sdh1
> >         8      65        1        8      active sync   /dev/sdq1
> >         9       8       81        9      active sync   /dev/sdf1
> >        10       8       17       10      active sync   /dev/sdb1
> >        12       8      193       11      active sync   /dev/sdm1
> >        18       8      241       12      spare rebuilding   /dev/sdp1
> >        17       8      225       13      active sync   /dev/sdo1
> >        16       8      177       14      active sync   /dev/sdl1
> >        15       8      161       15      active sync   /dev/sdk1
> >        14       8       97       16      active sync   /dev/sdg1
> >        13       8       33       17      active sync   /dev/sdc1
> >
> > One of the entries from dmesg the first time reshaping stalled:
> >
> > [105003.994653] INFO: task md0_reshape:3296 blocked for more than 120 s=
econds.
> > [105003.994916]       Tainted: G          I       4.19.0-6-amd64 #1
> > Debian 4.19.67-2+deb10u1
> > [105003.995169] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> > disables this message.
> > [105003.995434] md0_reshape     D    0  3296      2 0x80000000
> > [105003.995436] Call Trace:
> > [105003.995441]  ? __schedule+0x2a2/0x870
> > [105003.995442]  schedule+0x28/0x80
> > [105003.995448]  reshape_request+0x862/0x940 [raid456]
> > [105003.995451]  ? finish_wait+0x80/0x80
> > [105003.995454]  raid5_sync_request+0x34a/0x3b0 [raid456]
> > [105003.995460]  md_do_sync.cold.86+0x3f4/0x911 [md_mod]
> > [105003.995461]  ? finish_wait+0x80/0x80
> > [105003.995464]  ? __switch_to_asm+0x35/0x70
> > [105003.995467]  ? md_rdev_init+0xb0/0xb0 [md_mod]
> > [105003.995471]  md_thread+0x94/0x150 [md_mod]
> > [105003.995473]  kthread+0x112/0x130
> > [105003.995475]  ? kthread_bind+0x30/0x30
> > [105003.995476]  ret_from_fork+0x35/0x40
> >
> > I'm not sure where to continue troubleshooting. Been moving drives
> > around in the storage appliance in case there are bad ports on the
> > backplane but doesn't seem to make any difference. I only have one
> > 4-port HBA right now so can't even try another. The storage appliance
> > has 2 controllers and already tried swapping them as well as the SAS
> > cables. Only thing left I can try hardware wise is to install the
> > interposers that go in between the drives and the backplane but not
> > very hopeful.
> >
> > Any help would be greatly appreciated. I don't have the extra space
> > right now to copy everything out and create a new array so really
> > hoping to get past this stalling issue. Thanks.
> >

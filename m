Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92FB8C4338F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 11:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F69E6120A
	for <linux-raid@archiver.kernel.org>; Tue, 24 Aug 2021 11:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235768AbhHXLQZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Aug 2021 07:16:25 -0400
Received: from USAT19PA23.eemsg.mail.mil ([214.24.22.197]:18722 "EHLO
        USAT19PA23.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235618AbhHXLQY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Aug 2021 07:16:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1629803740; x=1661339740;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=q1abTT18V0EVvvXO+EPfzXecHAV15lA63LGbEoLG19A=;
  b=YnuIHQ0wmF8q8947uVNDUB6IqyzwgU65TIE3odx1TiwcAM7SUp+uTJJl
   BUO9TNS3hMwzZG4eErpJ2sedHpAbNa+VCrzVe4p5slr1OJpnsFlJ2ymbR
   zCrjvtJhF+r9mN8efXaXIoM4ej1LmIKdBEK4kdHZSq35ysZVaYNDRoamD
   MnsGC5kNwVFE1n8mAIxdZnYlOKO+ivKYZf9W2/7vm9uxAhpd4JHihCFhr
   4w90zUnWGcfDjLeLLSbVTCgw02vGvg40+9IAXHfqYGrJXi6uyghacSCAm
   UnhOb6eXD67NZFA1y+tbXokH8jgjR6fAvcUJXYJPBKZPNnvoyKQDV9sj7
   g==;
X-EEMSG-check-017: 250267318|USAT19PA23_ESA_OUT04.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,347,1620691200"; 
   d="scan'208";a="250267318"
IronPort-HdrOrdr: A9a23:HHynE69n73WaU0Vz54huk+Fldb1zdoMgy1knxilNoENuH/Bwxv
 rFoB1E73TJYW4qKQodcdDpAtjifZquz+8O3WBxB8buYOCCggeVxe5ZnPLfKlHbehEW19Qtsp
 uIEJIOROEYb2IK9foSiTPQe7lP/DDtytHLuQ6q9QYIcegcUdAE0+4WMGamO3wzYDMDKYsyFZ
 Ka6MYCjSGnY24rYsOyAWRAd/TfpvXQ/aiWLyIuNloC0k2jnDmo4Ln1H1yzxREFSQ5Cxr8k7C
 zsjxH53KO+qPu2oyWsllM7rq4m2OcJ+OEzRvBkufJlbwkEvzzYJ7iJFYfy+Azd69vflWrC2O
 O83yvIef4DpE85BVvFxycFkjOQrgoG+jvsz0SVjmDkptG8TDUmC9BZjYYcaRfB7VE81esMmJ
 6j8ljpwaa/Nymw1RgVJuK4Ii1Chw6xuz4vgOQTh3tQXc8Xb6JQt5UW+AdQHI0bFCz35Yg7GK
 02Zfusrsp+YBefdTTUr2NvyNujUjA6GQqHWFELvoiQ3yJNlH50wkMEzIgUn2sG9pg6V55Yjt
 60eZhAhfVLVIsbfKh9DOAOTY+8AmnARh/FKyaJLU/mGLtCO3XWtpbx6rlw5OzCQu148HLzou
 W3bLp8jx9BR6vDM7z/4HR7yGG4fIzmZ0WT9ih33ekLhoHB
Received: from edge-mech02.mail.mil ([214.21.130.228])
  by USAT19PA23.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 24 Aug 2021 11:15:38 +0000
Received: from UMECHPAOU.easf.csd.disa.mil (214.21.130.164) by
 edge-mech02.mail.mil (214.21.130.228) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 24 Aug 2021 11:14:54 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.164]) by
 umechpaou.easf.csd.disa.mil ([214.21.130.164]) with mapi id 14.03.0513.000;
 Tue, 24 Aug 2021 11:14:52 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: SSDs and mdraid
Thread-Topic: SSDs and mdraid
Thread-Index: AdeY2FCguMmiPs6WQsubw5GWI/+SEw==
Date:   Tue, 24 Aug 2021 11:14:51 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A238585EA77@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

All,
As I'm trying to achieve maximum performance on mdraid with SSDs, I've noti=
ced a situation that I think could be corrected somewhat easily.

I've been having to play the partitioning game to get enough kernel workers=
 to achieve maximum performance on mdraid SSD stripes, but I've run into a =
few troubling problems.   Basically on raid creation and on raid check, man=
y events get DELAYED because they share underlying devices with other mdrai=
d stripes when you look at the status in /proc/mdstat.   I feel like mdraid=
 hasn't made the leap to SSDs, in that we have a signal in /sys/block/<md_d=
evice>/queue/rotational that  could enable  these DELAYED activities for SS=
Ds.  The SSDs have way more IOPS, both read and write, to handle these DELA=
Ys and we need to start taking advantage of the abilities of the SSDs.   It=
 is an SSD world now.

Regards,
Jim


Jim Finlayson
U.S. Department of Defense


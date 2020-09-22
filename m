Return-Path: <SRS0=RxpK=C7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCA8C4727C
	for <linux-raid@archiver.kernel.org>; Tue, 22 Sep 2020 00:34:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACF7C23A7B
	for <linux-raid@archiver.kernel.org>; Tue, 22 Sep 2020 00:34:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="tgbeOecf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgIVAeo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 21 Sep 2020 20:34:44 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:50248 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbgIVAeo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 21 Sep 2020 20:34:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600734883; x=1632270883;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=F1Sw3GymdOxB10A63dDb1N8UNgQYVoDfro5SgaO533c=;
  b=tgbeOecfxsbRnt7OI1Qz86JWX92JhaIXU3ktbvnJp4UmH71MjoDfWeQH
   +tq3Jrzhd57/4tiu7dAngvIP/ZvYaj8/gRBNO2wkbIPgjSZvsr0mnZPpO
   uPJaYkvOosF3W4OqqVEQriOUwuxSD2ZY2JM2DRudDt5kiKh+4Zdc5fRGT
   4=;
X-IronPort-AV: E=Sophos;i="5.77,288,1596499200"; 
   d="scan'208";a="55235721"
Subject: Re: RAID5 issue with UBUNTU 20.04.1 on my desktop
Thread-Topic: RAID5 issue with UBUNTU 20.04.1 on my desktop
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 22 Sep 2020 00:34:42 +0000
Received: from EX13D06EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id 58824A1CE9;
        Tue, 22 Sep 2020 00:34:40 +0000 (UTC)
Received: from EX13D09EUA002.ant.amazon.com (10.43.165.251) by
 EX13D06EUA001.ant.amazon.com (10.43.165.229) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 22 Sep 2020 00:34:39 +0000
Received: from EX13D09EUA002.ant.amazon.com ([10.43.165.251]) by
 EX13D09EUA002.ant.amazon.com ([10.43.165.251]) with mapi id 15.00.1497.006;
 Tue, 22 Sep 2020 00:34:39 +0000
From:   "Sung, KoWei" <winders@amazon.com>
To:     Song Liu <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Duan, HanShen" <hansduan@amazon.com>,
        "Tokoyo, Hiroshi" <htokoyo@amazon.co.jp>,
        "Fortin, Mike" <mfortin@amazon.com>
Thread-Index: AQHWjMDKl/zP+mpALE6dFQ9y/EZenqlz1bx9
Date:   Tue, 22 Sep 2020 00:34:39 +0000
Message-ID: <1600734878242.50073@amazon.com>
References: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>,<CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
In-Reply-To: <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.156.129]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Song Liu:=0A=
=0A=
May I know if you're able to reproduce this issue? Thanks a lot for your he=
lp.=0A=
=0A=
Best Regards,=0A=
Winder=0A=
________________________________________=0A=
From: Song Liu <song@kernel.org>=0A=
Sent: Thursday, September 17, 2020 3:03 PM=0A=
To: Sung, KoWei=0A=
Cc: linux-raid@vger.kernel.org; Bshara, Saeed; Duan, HanShen; Tokoyo, Hiros=
hi; Fortin, Mike=0A=
Subject: RE: [EXTERNAL] RAID5 issue with UBUNTU 20.04.1 on my desktop=0A=
=0A=
CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.=0A=
=0A=
=0A=
=0A=
Hi Winder,=0A=
=0A=
On Wed, Sep 16, 2020 at 2:53 AM Sung, KoWei <winders@amazon.com> wrote:=0A=
>=0A=
> Hi,=0A=
>=0A=
> I found RAID5 stability issue while doing disk expansion.=0A=
> I attached 4 disks (/dev/sda, /dev/sdb, /dev/sdc and /dev/sdd) and create=
 partition by =93create_partition.sh=94 scripts on my PC and run my test sc=
ripts =93raid_reshape_12.sh=94 (as attached).=0A=
> Basically, the test will add partitions to RAID5 (/dev/md3) and write fil=
es to /dev/md3 (ext4) at the same time.=0A=
> Within 1 or 2 hours, kernel will get crashed (Oops) and reshape/resync ca=
nnot be finished forever (log as attached).=0A=
>=0A=
> The issue happens randomly, but it most likely happens at beginning of re=
shape process. When kernel crash happens, the reshape stops at about 3-10% =
complete only.=0A=
> Moreover, it is not related to any partition size, because I=92ve tried d=
ifferent size, but issue still exists.=0A=
> I've also tried different kernel (4.1/4.2/4.9/4.19/5.4/5.8), and all kern=
el version can see this issue.=0A=
=0A=
Thanks for the report. I just started some tests with the script. I=0A=
will update whether it repros the issue.=0A=
=0A=
Song=0A=

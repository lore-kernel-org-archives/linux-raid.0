Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53DA3C6369E
	for <linux-raid@archiver.kernel.org>; Mon, 16 Nov 2020 17:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6CFB20855
	for <linux-raid@archiver.kernel.org>; Mon, 16 Nov 2020 17:24:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mail.mil header.i=@mail.mil header.b="Bb6KNFaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732762AbgKPRXs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:23:48 -0500
Received: from UCOL19PA39.eemsg.mail.mil ([214.24.24.199]:9638 "EHLO
        UCOL19PA39.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730564AbgKPRXr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Nov 2020 12:23:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2018v1a;
  t=1605547382; x=1637083382;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=fqUv8wPt5pO8r4lTcC77pwlISU8RxeG5g7MuxRoczbA=;
  b=Bb6KNFaFvjU8R70DRmZ5DM+Y4AnyA2+alt0mU5H0z5WOMHHjjTCb9cZd
   Wzi0v3hHi25QraI1yJoScnXIO5YajFHcXiTFzsPhthnbVPllhMda/d1fM
   igyc7oUIC4BB2EQXDZMGR8E+vMTe/aKGzRC+AejAHVj9JUE3jqYGd/icX
   O47zdny0XlOz5zjAXckQPBvmasWVLnI8ejbk1zmT832ycCa66486usBwG
   OmXQZmVgY93UBBtiKsIr8deDtdVdvAl+SCYm+WzR6zPT4pLGTpygyijyA
   NNr4qQNI3t7BeXFFQdMBT7IPdNgBhAviCpDdsiE+v38w+UHQHr+IzReAV
   w==;
X-EEMSG-check-017: 177959663|UCOL19PA39_ESA_OUT06.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.77,482,1596499200"; 
   d="scan'208";a="177959663"
Received: from edge-mech02.mail.mil ([214.21.130.229])
  by UCOL19PA39.eemsg.mail.mil with ESMTP/TLS/DHE-RSA-AES256-SHA; 16 Nov 2020 16:52:59 +0000
Received: from UMECHPAOX.easf.csd.disa.mil (214.21.130.167) by
 edge-mech02.mail.mil (214.21.130.229) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 16 Nov 2020 16:52:00 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.5.170]) by
 umechpaox.easf.csd.disa.mil ([214.21.130.167]) with mapi id 14.03.0487.000;
 Mon, 16 Nov 2020 16:51:59 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: Re: Nr_requests mdraid
Thread-Topic: Re: Nr_requests mdraid
Thread-Index: Ada8NylCrI0s32V2SLWnLZAxO57EJA==
Date:   Mon, 16 Nov 2020 16:51:59 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A23856EEA12@UMECHPA7B.easf.csd.disa.mil>
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

On Wed, Oct 28, 2020 at 6:39 PM Vitaly Mayatskih <v.mayatskih@gmail.com> wr=
ote
>
>On Thu, Oct 22, 2020 at 2:56 AM Finlayson, James M CIV (USA) <james.m.finl=
ayson4.civ@mail.mil> wrote:
>>=20
>> All,
>> I'm working on creating raid5 or raid6 arrays of 800K IOP nvme drives.  =
 Each of \
>> the drives performs well with a queue depth of 128 and I set to 1023 if =
allowed.   \
>> In order for me to try to max out the queue depth on each RAID member, s=
o I'd like \
>> to set the sysfs nr_requests on the md device to something greater than =
128, like \
>> #raid members * 128.   Even though /sys/block/md127/queue/nr_requests is=
 mode 644, \
>> when I try to change nr_requests in any way as root, I get write error: =
invalid \
>> argument.  When I'm hitting the md device with random reads, my nvme dri=
ves are \
>> 100% utilized, but only doing 160K IOPS because they have no queue depth=
.=20
>> Am I doing something silly?
>
>It only works for blk-mq block devices. MD is not blk-mq.
>
>You can exchange simplicity for performance: instead of creating one
>RAID-5/6 array you can partition drives in N equal sized partitions,
>create N RAID-5/6 arrays using one partition from every disk, then
>stripe them into top-level RAID-0. So that would be RAID-5+0 (or 6+0).
>
>It is awful, but simulates multiqueue and performs better in parallel
>loads. Especially for writes (on RAID-5/6).
>
>
>--=20
>wbr, Vitaly

Vitaly,
Thank you for the tip.  My raid5 performance (after creating 32 partitions =
per SSD) and running 64  9+1 (2 in reality) stripes is up to 11.4M 4K rando=
m read IOPS, out of 17M that the box is capable, which I'm happy with, beca=
use I can't NUMA the raid stripes as I would the individual SSDs themselves=
.   However, when I perform the RAID0 striping to make the "RAID50 from hel=
l", my performance drops to 7.1M 4K random read IOPS.   Any suggestions?  T=
he last RAID50, again won't let me generate the queue depth.

Thanks in advance,
Jim




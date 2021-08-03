Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F144C4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 15:00:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2406760243
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 15:00:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235773AbhHCPAo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 11:00:44 -0400
Received: from UPDC19PA23.eemsg.mail.mil ([214.24.27.198]:47259 "EHLO
        UPDC19PA23.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235368AbhHCPAm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 3 Aug 2021 11:00:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1628002832; x=1659538832;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=gNvXUpO+FUybRRNkfiPGSijk9jBD0CXnbjyBh3gPVLg=;
  b=cl73tNvrXb+8ghkQXc5N61ylMjSzu7Kv+/Vv1AhXVpoSBdeOQuyPQrC3
   doreaY6rn+J1eEtxTzZ6PoHtX40tizOOZhkYWUdj45wxWcOeYI1rym4Kf
   /tZQ6TG8hxl7qGDd8PMrROYskREWajViKhKPUB6zKPj5Ba4khl8PwMtRN
   6eS5Uag4/aF1k0G+h0ApGb4nUvjXagczjfdMr1fkh0jdLZPTdqhVlmnCa
   qv41bcE2uvnzmmcEnHhlB/GTbKuk/s106tau4CKfPprdomrNCqrKJXWU7
   X0xYg4J0HKJ2J4I/lfOpIfU/89Mjz0H1FO2Z+UqtBaIdWDK2d0Z+t2OSm
   Q==;
X-EEMSG-check-017: 250496304|UPDC19PA23_ESA_OUT05.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,291,1620691200"; 
   d="scan'208";a="250496304"
Received: from edge-mech02.mail.mil ([214.21.130.229])
  by UPDC19PA23.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 03 Aug 2021 15:00:28 +0000
Received: from UMECHPAPA.easf.csd.disa.mil (214.21.130.170) by
 edge-mech02.mail.mil (214.21.130.229) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 3 Aug 2021 14:59:45 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.164]) by
 umechpapa.easf.csd.disa.mil ([214.21.130.170]) with mapi id 14.03.0513.000;
 Tue, 3 Aug 2021 14:59:45 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     'Gal Ofri' <gal.ofri@volumez.com>,
        "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS
 - AMD ROME what am I missing?????
Thread-Topic: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread
 IOPS - AMD ROME what am I missing?????
Thread-Index: AQHXhsdfCwKapbYhRUCHiA82Jmy1gath4UwA
Date:   Tue, 3 Aug 2021 14:59:45 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2385856215@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <20210801142107.407b000a@gofri-dell>
In-Reply-To: <20210801142107.407b000a@gofri-dell>
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

Gal,
My SA just gave me the server with the 5.14 RC4 kernel built.   I have a tw=
o pass preconditioning run  going right now to get us maximum results.   I =
expect to be able to run the tests hopefully by COB Wednesday.   Preconditi=
oning will take 8 hours unfortunately (15.36TB drives), I have to make BIOS=
 changes for apples to apples "hero runs" and then get the mdraid's created=
.    In your opinion, if I bypass the initial formatting with mdadm --assum=
e-clean, will that make a difference in the results?    I usually let the f=
ormat run, but I want to get you results as soon as possible.
Thanks,
Jim




-----Original Message-----
From: Gal Ofri <gal.ofri@volumez.com>=20
Sent: Sunday, August 1, 2021 7:21 AM
To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
Cc: 'linux-raid@vger.kernel.org' <linux-raid@vger.kernel.org>
Subject: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS - =
AMD ROME what am I missing?????

All active links contained in this email were disabled.  Please verify the =
identity of the sender, and confirm the authenticity of all links contained=
 within the message prior to copying and pasting the address to a Web brows=
er. =20




----

Hey Jim,

Read iops (rand/seq) were addressed in a recent commit:
97ae27252f49 md/raid5: avoid device_lock in read_one_chunk() Caution-https:=
//github.com/torvalds/linux/commit/97ae27252f4962d0fcc38ee1d9f913d817a2024e
It was merged into 5.14, so you can either cherry-pick it or just use a lat=
est-master kernel.

Sounds like your environment is stronger than the one I used for the testin=
g, so please do share your benchmark if you manage to surpass the results d=
escribed in the commit message.

Cheers,
Gal Ofri,
Volumez (formerly storing.io)

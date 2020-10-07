Return-Path: <SRS0=wpSx=DO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7050DC41604
	for <linux-raid@archiver.kernel.org>; Wed,  7 Oct 2020 07:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D13520797
	for <linux-raid@archiver.kernel.org>; Wed,  7 Oct 2020 07:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.com header.i=@amazon.com header.b="p1VoNskq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbgJGHCU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:02:20 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:57129 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727518AbgJGHCU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Oct 2020 03:02:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602054139; x=1633590139;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=n0cDxX6F+nqk+0xadEUtQxOcnCks9fW0XuUZuO3eak8=;
  b=p1VoNskq/dF5aPHpzNepUNIInnovzKtMLuUjODzQWI5Q6oa4D630LkY0
   BvaLscyhxzYuFp+tqC6UCv11OkV81/Jxwp/Nwgr3TiLE1zLeEKz8jY0un
   iVROCR+NNrARwHBjsSZlhcWaACpJ8x33PuGPSDm4tWoyapq53IXHv5mm4
   4=;
X-IronPort-AV: E=Sophos;i="5.77,345,1596499200"; 
   d="scan'208";a="58521963"
Subject: Re: RAID5 issue with UBUNTU 20.04.1 on my desktop
Thread-Topic: RAID5 issue with UBUNTU 20.04.1 on my desktop
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 07 Oct 2020 07:02:16 +0000
Received: from EX13D07EUA003.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2b-8cc5d68b.us-west-2.amazon.com (Postfix) with ESMTPS id 4C3AFA1C95;
        Wed,  7 Oct 2020 07:02:16 +0000 (UTC)
Received: from EX13D09EUA002.ant.amazon.com (10.43.165.251) by
 EX13D07EUA003.ant.amazon.com (10.43.165.176) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 7 Oct 2020 07:02:14 +0000
Received: from EX13D09EUA002.ant.amazon.com ([10.43.165.251]) by
 EX13D09EUA002.ant.amazon.com ([10.43.165.251]) with mapi id 15.00.1497.006;
 Wed, 7 Oct 2020 07:02:14 +0000
From:   "Sung, KoWei" <winders@amazon.com>
To:     Song Liu <song@kernel.org>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Duan, HanShen" <hansduan@amazon.com>,
        "Tokoyo, Hiroshi" <htokoyo@amazon.co.jp>,
        "Fortin, Mike" <mfortin@amazon.com>
Thread-Index: AQHWmusL9wfwpfZB/Ueqw53chpUH0amLt7cm
Date:   Wed, 7 Oct 2020 07:02:14 +0000
Message-ID: <1602054133661.46939@amazon.com>
References: <6F1A48DB-CA95-433B-91F3-D0051453A8E1@amazon.com>
 <CAPhsuW6q5bLgOUyuTH8MFTo6GSnGqRxne6sV+dsFHRy_qHtxRA@mail.gmail.com>
 <1600734878242.50073@amazon.com>
 <CAPhsuW4Q-aYzUQ=Utw6XigjJ0tVbCZOjmn+Wq6hvvjXhvAiwZA@mail.gmail.com>,<CAPhsuW7+jnPkvzVsqn_Eh7TqB_HAuZRXTofar9ucj7rsqyfE9w@mail.gmail.com>
In-Reply-To: <CAPhsuW7+jnPkvzVsqn_Eh7TqB_HAuZRXTofar9ucj7rsqyfE9w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.157.194]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi, Song:=0A=
=0A=
Thanks a lot for your fix.=0A=
I've tested the patch by "v4.19.149" tag from Linux kernel stable tree (ker=
nel/git/stable/linux.git).=0A=
The test runs over 1000 rounds in 24 hours without kernel crash, so the pat=
ch should fix this issue.=0A=
=0A=
Best Regards,=0A=
Winder=0A=
________________________________________=0A=
From: Song Liu <song@kernel.org>=0A=
Sent: Monday, October 5, 2020 3:40 PM=0A=
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
Hi KoWei,=0A=
=0A=
On Mon, Sep 28, 2020 at 10:15 AM Song Liu <song@kernel.org> wrote:=0A=
>=0A=
> On Mon, Sep 21, 2020 at 5:34 PM Sung, KoWei <winders@amazon.com> wrote:=
=0A=
> >=0A=
> > Hi, Song Liu:=0A=
> >=0A=
> > May I know if you're able to reproduce this issue? Thanks a lot for you=
r help.=0A=
>=0A=
=0A=
Could you please verify whether the following patch fixes it? If it=0A=
works well, please=0A=
reply with your Test-by tag.=0A=
=0A=
Thanks,=0A=
Song=0A=
=0A=
diff --git i/drivers/md/raid5.c w/drivers/md/raid5.c=0A=
index 66690b40818e7..39343479ac2a9 100644=0A=
--- i/drivers/md/raid5.c=0A=
+++ w/drivers/md/raid5.c=0A=
@@ -2585,8 +2585,6 @@ static int resize_stripes(struct r5conf *conf,=0A=
int newsize)=0A=
        } else=0A=
                err =3D -ENOMEM;=0A=
=0A=
-       mutex_unlock(&conf->cache_size_mutex);=0A=
-=0A=
        conf->slab_cache =3D sc;=0A=
        conf->active_name =3D 1-conf->active_name;=0A=
=0A=
@@ -2628,6 +2626,8 @@ static int resize_stripes(struct r5conf *conf,=0A=
int newsize)=0A=
=0A=
        if (!err)=0A=
                conf->pool_size =3D newsize;=0A=
+       mutex_unlock(&conf->cache_size_mutex);=0A=
+=0A=
        return err;=0A=
 }=0A=

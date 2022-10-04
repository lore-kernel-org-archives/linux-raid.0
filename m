Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EED6C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  4 Oct 2022 20:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJDUn5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Oct 2022 16:43:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiJDUns (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Oct 2022 16:43:48 -0400
Received: from USAT19PA24.eemsg.mail.mil (USAT19PA24.eemsg.mail.mil [214.24.22.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2553158DFA
        for <linux-raid@vger.kernel.org>; Tue,  4 Oct 2022 13:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1664916219; x=1696452219;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PlNJ7B9w/W+0dJFEq4c6RXu0+3rJQljA4FGqU3HriQE=;
  b=d6VF82GC9/AIrZb2FZpv7VrcOJxoq80UEVtsv3brSBNXA+YrxgOUr1zW
   5SC1HcX/qB/Kaiq8sETOgTIWM5CRqm410RZ+EWKSBUP8h3PITDRSqD5e6
   JOxW+n6tm/hWMYJ5trL4xyhOBmyA4yd2gSBoUqd4RwrZ28h4urnMTzAdW
   Cwn0owS6vxGova7mG/Sf4qfequUX6bKs+CQ8bhG7mnyccav22n/0bcYae
   UpHNOmVlTvX9DvqE2h3TzEZiDMoveBhvEd5LCNPhbyeMRYmM6f1aZcotB
   YNkqaVrcL9NItXkslFajRg8e23x92lj5iGDH7Bm1vjI0ACSwKHJyGtUxP
   g==;
X-EEMSG-check-017: 373382040|USAT19PA24_ESA_OUT05.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.95,158,1661817600"; 
   d="scan'208";a="373382040"
IronPort-Data: A9a23:I4eF26K8lk+lv4irFE+RdJclxSXFcZb7ZxGr2PjKsXjdYENS0zdRy
 zBLW2uPPfaCNGH8LdgkYYrgpB4OsJGHm95iTwRorCE8RH908seUXt7xwmUcns+xwm8vaGo9s
 q3yv/GZdJhcokf0/0vrav67xZVF/fngqoDUUIYoAQgsA145IMsdoUg7wbRg2tY02YPR7z6l4
 bseneWOYDdJ5BYpagr424rbwP+4lKmaVJsw5zTSVNgT1LPsvyB94KE3fMldG0DFrrx8RYZWc
 QpjIIaRpQs19z91Yj+sfy2SnkciGtY+NiDW4pZatjTLbhVq/kQPPqgH2PU0b3oUuhSVwY5N6
 O5868DzQDcqIqDmobFIO/VYO3kW0axu5aPGJ3inuMuYiUDPaHWqyO5iSk03JoRe/+dzaY1M3
 aVFcnZXNEHF2rjwmergIgVvrp1LwM3DPooat2omyHfXDPAiSIHYRKOWo9RZwh81j8FKW/PfY
 6L1bBI0M0+bM0cXZg9/5JQWwsvvlyTzYidjjnXMte0o51aU6Spf6e24WDbSUpnQLSlPpW6cp
 2Tb7yHjCxAWHMKQxCDD8X+2gOLL2yThV+ov+KaQ+/JljRiUxWcfUERQUFK6pb+8i0rWt89jF
 nH4MxEG9cAanHFHhPGmN/FkiBZoZiIhZuc=
IronPort-HdrOrdr: A9a23:W5NpqKjyZ8e7V6wqzTLFlGVjZHBQXgwji2hC6mlwRA09TyW9rb
 HMoB1973/JYVcqKRMdcL+7SdO9qE3nhPlICOUqTMiftWrdyQ2VxeNZnPLfKlTbckWUygc679
 YdT0EUMqyKMbEVt7eG3OHBeexQpOVu98iT69s3mB9WIT2DsMlbnn9E4hTyKCxLrBovP/UE/I
 r13KB6TyDJQxkqhr3QPAhhY9T+
Received: from edge-okcd01.mail.mil (HELO utinhpaoc.easf.csd.disa.mil) ([152.229.52.103])
  by USAT19PA24.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 04 Oct 2022 20:43:37 +0000
Received: from UTINHPANM.easf.csd.disa.mil (152.229.52.33) by
 edge-okcd01.mail.mil (152.229.52.103) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 4 Oct 2022 20:43:20 +0000
Received: from UTINHYII.easf.csd.disa.mil (152.229.111.24) by
 UTINHPANM.easf.csd.disa.mil (152.229.52.33) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 4 Oct 2022 20:43:20 +0000
Received: from UTINHYE6.easf.csd.disa.mil (152.229.111.20) by
 UTINHYII.easf.csd.disa.mil (152.229.111.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 4 Oct 2022 20:43:19 +0000
Received: from USG01-CY1-obe.outbound.protection.office365.us (140.17.139.229)
 by UTINHYE6.easf.csd.disa.mil (152.229.111.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.9
 via Frontend Transport; Tue, 4 Oct 2022 20:43:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector5501; d=microsoft.com; cv=none;
 b=AhkeU+R2rkF3lUCTMUSEWLAFdTlImzL6WnM1Qw8F9pNvUBA/uX1Y7aV3Ylgy7OFyD6vHnYeHxUGGFvt57qSFrZ1+zJlkCj6iUxU+OSpKgNmfZeatP3Zm9wnQ46hEDMFTuQf9ZvBp/ugqHvYhVcqqMwGlqLTVzgydUDyQAdNFGQ2BhiHGEoKTrUHyG4Ah1oY4bla9XxNWB2uNuCrrN5WuMZLEOmRMB/PU2n9rnP+O9QwCqPCvSdzRB0dyzZYUot3ZyzDSLbjUBm7sOQagLhHH7nMxLzoLUfu5L3WPQr8vG30xn/pUYJNEq/pW1+pB4s78wRQ3JUc2Jduu6qU+9gopdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector5501;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PlNJ7B9w/W+0dJFEq4c6RXu0+3rJQljA4FGqU3HriQE=;
 b=exXQwFvIdexuy6LQ5HCq5PQdaAtxvhah8c8nIL41JWu7hbuMC2SnvnubOXN04ofpZELFsOTDSz0WG+yetOqhB0TtD7LLk7uhgd42BKVRRtOLww5d1KA63ILSriIARUdxc/7yyytJEtqSdZpIRmVPsOZ6zfb4xCGueX+uukhWYiw/I9UCtNWD654Z8LlLR38BoAiC+OpStEqunNCn8GnBkk7hf9QlWvztoS96HAOW0A0skuu6DbS4KgOMKQn2JZPp47JiEq3So5SqMdFQuOqSV5qHpfs7JW8puxRPhiAcMcWAbFvtmpwa/RqVlTnimktpotQCVOX/cjA1dvNkit7/6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.mil; dmarc=pass action=none header.from=mail.mil;
 dkim=pass header.d=mail.mil; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dod365.onmicrosoft.us;
 s=selector1-dod365-onmicrosoft-us;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PlNJ7B9w/W+0dJFEq4c6RXu0+3rJQljA4FGqU3HriQE=;
 b=TyE10NW7raGT/N9Lkzr4vM7aQFNdPtm7SKoyjgDEDYuVkOLDB55CpOFRzKGx9Sa1gKYxVBRlRuft6tzv8KzkaQT5+PJuPsmYJKqyW/1UOmhhNyKUbq0ql5P57ikWp08j4jCA5Gv5XhXRnAMU5LQKl8gX4dAa410Yg9scmUhP0s9/LBapXBH9IsisMTuO97CL0UMOAPoO76mfgrrGzf+eTlxn/ErqgMooG2oL+HOLJwbd5Rcjr5ewt+af909I7krv8C4hoP+wCKbsYM6M+WaX1Gyx0YvSLWBN8G3hkUwxIYQ3OAmeDbGcpc65jLkCpLsHt75sN7g8qmw2cGeMvLfXcw==
Received: from BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM (2001:489a:200:589::15)
 by BN8P111MB1397.NAMP111.PROD.OUTLOOK.COM (2001:489a:200:58a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Tue, 4 Oct
 2022 20:43:18 +0000
Received: from BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
 ([fe80::3c32:331c:38c7:e9b0]) by BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
 ([fe80::3c32:331c:38c7:e9b0%5]) with mapi id 15.20.5676.020; Tue, 4 Oct 2022
 20:43:18 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: RE: Linux RAID futures question
Thread-Topic: Linux RAID futures question
Thread-Index: AdjYMPuHQO2okXsCTiG3TSyfFouhkAAAHSGg
Date:   Tue, 4 Oct 2022 20:43:17 +0000
Message-ID: <BN8P111MB195628A92DE701D773E63DD8A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
References: <BN8P111MB1956CAEE20D8EDA11B0DFDB3A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
In-Reply-To: <BN8P111MB1956CAEE20D8EDA11B0DFDB3A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.mil;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8P111MB1956:EE_|BN8P111MB1397:EE_
x-ms-office365-filtering-correlation-id: 5757db34-85de-4957-1167-08daa6491146
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3Nrb9UaK2OagMxxxgye15xOTVlxFjR7M+52Ydhkm5SsGO2CiG/imeJ92gkdOySbbaei07JZpAekbFxmvYuMV4xWBV4sjJQDbj7uhbsTa26C++fXJIMtpgnFhPW3SVN3PRJdOlk8S9jJ6nOHJQcIryI1ZLgicL5lnxpUXHkXA2Qqa38tw8RdhmL427isYQly/bk/CmqmR82b6pPBbduzeT05BUwAFZiGwlNhVU2033kRlDHrhAh5M1VczPL04MddzQm8UPoh0909OgEmASB9ZwEyszaEnn0XnNSrX7tBmgpW7D3XAOPh+ZmUudGMtcAJxsFNvgsvlm//EbObEczPV8GbP3jTJ2nflexiw+TtaJOADfd8AeG5eZFSutdAWENPt8NwfXp6FXC3ON0+BXQ8ZIFgIjhjnDGkSkqa+noZbqLGoe7FozUAAHkgAHjYCNrC5aoa5rxa9ONeySKDQFaK9OpN4pnTrC3NUVUENw4o2p09uIcm0i4a8lJ7cw7+PLiDLI/VG6UqBg66Q7msHFje8f9Sm+DKGTvrTgrVDrIa4dNBQK0g8D3pg8h9pTVWV4d+YhDtKuAFi1bTE06rSTzbQe+cjdpI6qjOPXsBHhwQ60AcTDqiYBfRlOdossMepySsql5vxa2p1lX/8tzCdCm9kRH56h7UEDQ8tO9AkZvKiOAXU0f22aRbM3oImkJzx61CG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(451199015)(83380400001)(66899015)(53546011)(6506007)(66556008)(26005)(4326008)(2906002)(64756008)(8676002)(66946007)(66446008)(76116006)(122000001)(7696005)(33656002)(52536014)(66476007)(8936002)(186003)(3480700007)(82960400001)(55016003)(86362001)(9686003)(38070700005)(6916009)(2940100002)(38100700002)(107886003)(498600001)(71200400001)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: QfdjIiPtFke/5WWjUNYa9ah0yYUAKWLbuPY44Di4DL8f8zTQOOsvlRLyKXVw5NYdzw/38XmpmAfHJyanXDd31WyfOup1FAk+VjBbwU3Guf7eJT81aRQa+Rm9RNPAOpFxtQeUPQF5u/UZMhB4rz8vcrWjGtuRQSsnZMC+jefzkQKIPKKxnsRihsfgTg82bTPG3ejs4oUw92jLAsIG/mxJLZ37e9SL58bcK6B2PR5YGHAOi2Ul/zhURrnUoDcAMptI5k0xkQHt5kmbuWp3C0llsKLwt/LBw2U+fP+cv950znYpjp+3/qJ+u16OZAPtWvuSEis5fk8Jhui/Dl8bBGtoyUGqhdDT15kwstgrkiz/XT6DWt1FqN4rQUl8BqqMbN0kEYRa9uPyvcXWrZjJFswzdNH3LbzpLmyT2BHqRK3On3o=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5757db34-85de-4957-1167-08daa6491146
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 20:43:17.8505
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 102d0191-eeae-4761-b1cb-1a83e86ef445
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8P111MB1397
X-OriginatorOrg: mail.mil
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

I messed with sync_force_parallel and got the speed up momentarily, but the=
 drive bandwidth and IOPs are down and then my sync speed started dropping =
to well below 1GB/s after climbing initially to 1.2GB/s....=20
Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme16c16n1   117608.00    0.00 848824.00      0.00 94603.00     0.00  44.5=
8   0.00    0.83    0.00  98.03     7.22     0.00   0.01 100.00
nvme18c18n1   117614.00    0.00 848936.00      0.00 94580.00     0.00  44.5=
7   0.00    0.85    0.00  99.91     7.22     0.00   0.01 100.00
nvme17c17n1   117612.00    0.00 848856.00      0.00 94563.00     0.00  44.5=
7   0.00    0.84    0.00  99.35     7.22     0.00   0.01 100.00
nvme19c19n1   117615.00    0.00 848968.00      0.00 94553.00     0.00  44.5=
7   0.00    0.85    0.00  99.72     7.22     0.00   0.01 100.00
nvme21c21n1   117657.00    0.00 848940.00      0.00 94516.00     0.00  44.5=
5   0.00    0.86    0.00 101.30     7.22     0.00   0.01 100.00
nvme22c22n1   117687.00    0.00 849060.00      0.00 94513.00     0.00  44.5=
4   0.00    0.86    0.00 101.44     7.21     0.00   0.01 100.00
nvme23c23n1   117720.00    0.00 849248.00      0.00 94515.00     0.00  44.5=
3   0.00    0.86    0.00 101.51     7.21     0.00   0.01 100.00
nvme24c24n1   117793.00    0.00 849700.00      0.00 94512.00     0.00  44.5=
2   0.00    0.86    0.00 101.07     7.21     0.00   0.01 100.00
nvme29c29n1   118601.00    0.00 849520.00      0.00 93685.00     0.00  44.1=
3   0.00    0.85    0.00 101.02     7.16     0.00   0.01  99.90
nvme30c30n1   118615.00    0.00 849592.00      0.00 93702.00     0.00  44.1=
3   0.00    0.85    0.00 100.55     7.16     0.00   0.01 100.00
nvme31c31n1   118530.00    0.00 848924.00      0.00 93714.00     0.00  44.1=
5   0.00    0.85    0.00 101.28     7.16     0.00   0.01 100.00
nvme32c32n1   118495.00    0.00 848720.00      0.00 93709.00     0.00  44.1=
6   0.00    0.86    0.00 102.13     7.16     0.00   0.01 100.00


-----Original Message-----
From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>=20
Sent: Tuesday, October 4, 2022 4:37 PM
To: linux-raid@vger.kernel.org
Cc: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>
Subject: Linux RAID futures question

All,
First off, I'm a huge advocate for mdraid and I appreciate all of the effor=
t that goes into it.   As far as mdraid, I think I'm my own definition of "=
dangerous", in that "I don't know what I don't know" :)   In my ideal world=
, I hope all of these are solved and somebody just points me to the Fine ma=
nual or accuses me of ID10T errors, but I can't find solutions to anything =
below.   Any and all advice appreciated.    To be honest, I have a goal of =
putting together one of these servers, implementing mdraid and an NVMe targ=
et driver and showing that a well-tuned server with mdraid could out run so=
me of these all flash hardware arrays from a cocky vendor or two.  =20

Given that this is quickly becoming an SSD world, I've noticed a few things=
 related to mdraid where I'm hoping there might be some relief in the futur=
e.   If there are solutions for any of these, I'd be grateful.  =20

This is on 5.19.12.....
[root@hornet05 md]# uname -r
5.19.12-1.el8.elrepo.x86_64

The raid process doesn't seem to be numa aware, so we often have to move it=
 after the raid is assembled with taskset.    We currently look for the <md=
>_raid6 process and pin it to the proper NUMA node.   Might there be knobs =
if we want to pin the process to specific NUMA nodes?  There is a pretty he=
avy penalty on dual socket AMDs for cross numa operations.
Relative latency matrix (name NUMALatency kind 5) between 2 NUMANodes (dept=
h -3) by logical indexes:
  index     0     1
      0    10    32
      1    32    10

The resync process seems to move across numa nodes - here is a NUMA node 1 =
md raid running a resync that when I caught this snapshot in top, showed it=
 was on  NUMA 0:
    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ NU  =
 P COMMAND                                                                 =
                                                   =20
 731597 root      20   0       0      0      0 R  99.0   0.0  12:53.02  0  =
 0 md1_resync                                                              =
                                                   =20
   3778 root      20   0       0      0      0 R  93.4   0.0  12:17.70  1  =
89 md1_raid6               =20


Even with my biggest, baddest AMD 24x nvme SSD servers, I rarely see a raid=
 build/rebuild rate of greater than 1GB/s per second, even though my SSDs w=
ill each read at > 6GB/s and might even write at 3.8GB/s. =20

[root@hornet05 md]# cat /proc/mdstat  (this system is currently idle other =
than the raid check)....
Personalities : [raid6] [raid5] [raid4]=20
md1 : active raid6 nvme32n1p1[13] nvme31n1p1[8] nvme30n1p1[11] nvme29n1p1[1=
2] nvme24n1p1[7] nvme23n1p1[6] nvme22n1p1[5] nvme21n1p1[4] nvme19n1p1[3] nv=
me18n1p1[2] nvme17n1p1[1] nvme16n1p1[0]
      150007941120 blocks super 1.2 level 6, 128k chunk, algorithm 2 [12/12=
] [UUUUUUUUUUUU]
      [=3D>...................]  check =3D  6.2% (937365120/15000794112) fi=
nish=3D206.3min speed=3D1136048K/sec
      bitmap: 0/112 pages [0KB], 65536KB chunk

I have set the max speeds  with sysctl to be much higher, as well as with u=
dev for each md device.   I set group_thread_cnt to 64 an stripe_cache_size=
 to 8192.   When I look at iostat, I see what looks a queue depth of ~90 on=
 each drive and an average read size of a mix of 8K and 512byte I/Os if I w=
ere to guess.   The reads are a bit beyond 1/10 of what each drive is capab=
le of doing (thank you for the much improved block stack - it isn't difficu=
lt to run all 24 drives at speed now when dealing with them individually.  =
 My goal is to maximize them in 10+2 numa aware RAID configs in the short t=
erm and then 14+2 when we switch from U.2/3 to E.3S and 32 will fit in the =
front of a 2U server.     Am I missing an obvious knob???

Device            r/s     w/s     rkB/s     wkB/s   rrqm/s   wrqm/s  %rrqm =
 %wrqm r_await w_await aqu-sz rareq-sz wareq-sz  svctm  %util
nvme16c16n1   155769.00    2.00 1125148.00      4.50 125544.00     0.00  44=
.63   0.00    0.59    0.50  91.58     7.22     2.25   0.01 100.00
nvme18c18n1   155736.00    2.00 1124996.00      4.50 125536.00     0.00  44=
.63   0.00    0.59    0.50  92.18     7.22     2.25   0.01 100.00
nvme17c17n1   155709.00    2.00 1124864.00      4.50 125534.00     0.00  44=
.64   0.00    0.59    0.50  92.48     7.22     2.25   0.01 100.10
nvme19c19n1   155753.00    2.00 1125220.00      4.50 125528.00     0.00  44=
.63   0.00    0.60    0.50  93.34     7.22     2.25   0.01 100.10
nvme21c21n1   155805.00    2.00 1125108.00      4.50 125453.00     0.00  44=
.60   0.00    0.60    0.50  93.29     7.22     2.25   0.01 100.10
nvme22c22n1   155773.00    2.00 1124860.00      4.50 125455.00     0.00  44=
.61   0.00    0.60    0.50  93.17     7.22     2.25   0.01 100.00
nvme23c23n1   155774.00    2.00 1124876.00      4.50 125451.00     0.00  44=
.61   0.00    0.60    0.00  94.01     7.22     2.25   0.01 100.00
nvme24c24n1   155826.00    2.00 1125104.00      4.50 125445.00     0.00  44=
.60   0.00    0.60    0.50  93.24     7.22     2.25   0.01 100.00
nvme29c29n1   157560.00    2.00 1125392.00      4.50 123758.00     0.00  43=
.99   0.00    0.59    0.50  93.40     7.14     2.25   0.01 100.00
nvme30c30n1   157574.00    2.00 1125528.00      4.50 123775.00     0.00  43=
.99   0.00    0.59    0.50  93.15     7.14     2.25   0.01 100.00
nvme31c31n1   157562.00    2.00 1125492.00      4.50 123772.00     0.00  43=
.99   0.00    0.59    0.50  93.55     7.14     2.25   0.01 100.00
nvme32c32n1   157507.00    2.00 1125052.00      4.50 123763.00     0.00  44=
.00   0.00    0.69    0.50 108.94     7.14     2.25   0.01 100.00

I believe this to mean that the algorithm is publishing that it is capable =
of > 30GB/s
[root@hornet05 md]# dmesg | grep -i raid
[   19.183736] raid6: avx2x4   gen() 22164 MB/s
[   19.200842] raid6: avx2x2   gen() 36282 MB/s
[   19.217736] raid6: avx2x1   gen() 25032 MB/s
[   19.217963] raid6: using algorithm avx2x2 gen() 36282 MB/s
[   19.234845] raid6: .... xor() 31236 MB/s, rmw enabled

One might think that it could do I/O at "chunk_size" I/O sizes during rebui=
lds...
[root@hornet05 md]# pwd
/sys/block/md1/md
 [root@hornet05 md]# cat chunk_size
131072

When I'm down a drive, no matter what I/O size we send to the md device, th=
e I/O seems to map to 4KB while it is "calculating parity" for a failed/mis=
sing drive even though I might be doing 1MB random reads at the time.

SUBSYSTEM=3D=3D"block",ACTION=3D=3D"add|change",KERNEL=3D=3D"md*",\
	ATTR{md/sync_speed_max}=3D"2000000",\
	ATTR{md/group_thread_cnt}=3D"64",\
	ATTR{md/stripe_cache_size}=3D"8192",\
	ATTR{queue/nomerges}=3D"2",\
	ATTR{queue/nr_requests}=3D"1023",\
	ATTR{queue/rotational}=3D"0",\
	ATTR{queue/rq_affinity}=3D"2",\
	ATTR{queue/scheduler}=3D"none",\
	ATTR{queue/add_random}=3D"0",\
	ATTR{queue/max_sectors_kb}=3D"4096"


Thanks for any and all advice,
Jim


Jim Finlayson
US Department of Defense



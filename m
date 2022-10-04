Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 783F3C433FE
	for <linux-raid@archiver.kernel.org>; Tue,  4 Oct 2022 20:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbiJDUif (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 4 Oct 2022 16:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJDUie (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 4 Oct 2022 16:38:34 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 13:38:31 PDT
Received: from USAT19PA21.eemsg.mail.mil (USAT19PA21.eemsg.mail.mil [214.24.22.195])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC346BCE4
        for <linux-raid@vger.kernel.org>; Tue,  4 Oct 2022 13:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1664915911; x=1696451911;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=WKq+BrGHJ7gWQYDdOa9o/X1H4+qDf08e5dfcsKv2BMk=;
  b=eS61SKTG2b8hNZih6lIfxPmDd4Wl9pBQW3/KXGD7T/EC3kVIngsag85C
   ZmVwXa7hU3DrbDzxrWTIi6OBrHkOqWyZk3XMvTSWG1dWjDLBt0fYf/JOl
   uk83uabxoTW7fk4WYlDwwrtVCw17dvNMKoPdy8P6beoV9xX8VVReeaTOJ
   5uDf0JL6DbuFaJePfZG3rDmz2ZN/dng9Yx8K4eL9EzCcigAkM2vbatwE3
   m2Hzg26PDlJDzCwro5kFQE0pEHF/ExB4IuBce5OOBSy8m7uLt6xYnYOic
   7XI91aXWbq4WP/6mr4G6Sp1YdVlch31VM3/7Tvipvv87XgNV2yZAUF2vx
   g==;
X-EEMSG-check-017: 373060004|USAT19PA21_ESA_OUT02.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.95,158,1661817600"; 
   d="scan'208";a="373060004"
IronPort-Data: A9a23:xBt/RaM0LK5Oi3PvrR07lcFynXyQoLVcMsEvi/4bfWQNrUohhTwDz
 zcdX27UOPyJZWChLox/b46wpEIHv57cndRhHgZtpSBmQkwRpJueD7x1DKtR0wB+jCHnZBg6h
 ynLQoCYdKjYdleF+lH1dOKJQUBUjclkfJKkYAL/En03FFIMpBsJ00o5wbdh2tIw2rBVPivV0
 T/Mi5yHULOa82MsWo4kw/rrRMRH4ZweEBtB1rAPTagjUG32zhH5P7pGTU2FFEYUd6EPdgKMq
 0Yv+5nilo/R109F5tpICd8XeGVSKlLZFVDmZna7x8FOjzAazhHe3JrXO9JMdB4QohqQwOkyz
 ZIQkoCLYwUHNIblzbF1vxlwS0mSPIVL9LDKZH24t9DLkwvDenrohfBvCCnaP6VBp7YxWDwIr
 KJHbmlVNHhvhMrvqF6/Yutlg8k4asytMoIZvnhx1jbfUbAtQI7rRqzL4Zld3TNYasVmRqmFP
 5RBMWIzBPjGSzhXAWwsJ8wToPa5iyftfgEfpRXFnINitgA/yyQ0itABKuH9ft2MWNUQhE+Zq
 krY8GnjRBIXLtqSzXyC6H3EuwPUtS73V49XEbq+6qY2xliax2hVDRwSPbemncSEZoeFc4o3A
 yQpFuAG9vFtnKB3ZrERhyGFnUM=
IronPort-HdrOrdr: A9a23:buJqV6v8+SyzyPe2mZWsxF0M7skCgoMji2hC6mlwRA09TyXGra
 GTdaUguyMc1gx/ZJh5o6H8BEGBKUmskqKdkrNhQYtKOzOW8ldATbsSprcKpgeBJ8SQzJ8n6U
 4NSdkaNDSSNyk2sS+Z2njDLz9I+rDum8rE6Za8vhVQpGlRGuRdBmxCe2Cm+zhNNXF77O0CZe
 OhD6R81l6dUEVSSv7+KmgOXuDFqdGOvonhewQ6Cxku7xTLpS+06ZbheiLokis2Yndq+/MP4G
 LFmwv26uGIqPeg0CLR0GfV8tB/hMbh8N1eH8aB4/JlZQkEyzzYKriJaYfy/Azdk9vfq2rCpe
 O84ivIcf4DqU85NVvF3icFkzOQrgrGrUWSjWNwyEGT0PDRVXY0DdFMipledQac4008vMtk2K
 YOxG6BsYFLZCmw6hgVyuK4Iy2CrHDE1kYKgKoWlThSQIEeYLheocgW+15UCo4JGGb/5Jo8GO
 djAcnA7LIOGGnqJ0zxry1q2pihT34zFhCJTgwLvdGUySFfmDR8w1EDzMISk38c/NY2SoVC5e
 7DLqN0/Ys+B/P+rZgNcdvpbfHHeFAlGyi8QF56CW6XZ506Bw==
Received: from edge-mont04.mail.mil ([158.15.167.102])
  by USAT19PA21.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 04 Oct 2022 20:37:02 +0000
Received: from UGUNHPTI.easf.csd.disa.mil (158.15.167.38) by
 edge-mont04.mail.mil (158.15.167.102) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Tue, 4 Oct 2022 20:36:36 +0000
Received: from ugunhybl.easf.csd.disa.mil (158.15.171.26) by
 ugunhpti.easf.csd.disa.mil (158.15.167.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Tue, 4 Oct 2022 20:36:33 +0000
Received: from ugunhybi.easf.csd.disa.mil (158.15.171.25) by
 ugunhybl.easf.csd.disa.mil (158.15.171.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Tue, 4 Oct 2022 20:36:33 +0000
Received: from USG01-DM2-obe.outbound.protection.office365.us (140.17.146.20)
 by ugunhybi.easf.csd.disa.mil (158.15.171.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.9
 via Frontend Transport; Tue, 4 Oct 2022 20:36:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector5501; d=microsoft.com; cv=none;
 b=K/lyTZWZB1QlklTgP4Z+xyP04AIEx36NFJ9t0Ujm6TZuNSBK2awB3BXPr+M3ESEjcrYVp9LiHVNnqWy8PA6tl988J/tdZI3cagUi7XBPoDSaLy6XgIgk8IE+a7gteRYfFXJG6uk9PIASTm3KQNRqtUJdwiDDI8FMRoC19zso9fqoxTfr6PpNNL7OxE1b6z59D51GGyvKbXIs5OT5w2VHq5/MDa5bpGv+p9acmZyVu/yvM8dNf2hvfhusizlOD1kD7oyliozpJ0v2XBLzsnX2534DPTD1fya8UvG16m5ixOT0HjtckPUe16ERaXmRTFcYBvyKqWZI7kHlBsaKDyN6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector5501;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WKq+BrGHJ7gWQYDdOa9o/X1H4+qDf08e5dfcsKv2BMk=;
 b=ADFR2LxRPbMNjGBGjI6j3Z5AC/u7GsDH55oYPIxysBoBuT9u754AcIvfA/LcpAFQ7JINxTIr1w34q6QrFPkW7blITtPm2K9qv9J/I5AX6DpqbcpKRJhenef8uJ7fgVE0Xl6t3To8Ouc22qa86ZhOCG0TmXQ0eO2KEMotr+CiMqZfxUojHiILQZ0DdiA9nel0cIl14WMVoOprKV2YhVurBq1dKmWpAjKQIEMJuDCB2vBlgY/WKgnt3kaf+D3vccktUA2ZaAsBS1eb1JOgACZMykHpNB8NfDqYuq3pTbPe0lPMZRqR8Yazw22V7VBjYjMPp8OrbNZpU3tolJQOkYVaBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mail.mil; dmarc=pass action=none header.from=mail.mil;
 dkim=pass header.d=mail.mil; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dod365.onmicrosoft.us;
 s=selector1-dod365-onmicrosoft-us;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WKq+BrGHJ7gWQYDdOa9o/X1H4+qDf08e5dfcsKv2BMk=;
 b=hT+0NRS0bpQGjE6BbEK3HCCH/xDQ1d/sUnloYQ6Oj/8v+9pulSxlZk1Lvv2j40CGUBNLRRNfb5u0WAPJCmVu9h17M9xk/8WTlgA69pyO7ZnlqqrWurNgGx01M4gj0h83OsnymnepVucmFi1Lmm+tps2EFKcXoNXhkbQsOdhoa3TUZ3Uq7DDeEOXvSlRsge7hnAGX9mZuqyywMCuHq0TaSDeZHjuFzfrFqDaNer1DwHTwqbsFeQ+HnsFXegck5cswX7Cxzj2ivFLm35UO4UYSb1TNiPgvRg7dU3e673XI0YOSwkrvIUTzuU7BetxE3/AT8Ly3pQjcVh22Vl/GCNcifQ==
Received: from BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM (2001:489a:200:589::15)
 by BN8P111MB1740.NAMP111.PROD.OUTLOOK.COM (2001:489a:200:58b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.17; Tue, 4 Oct
 2022 20:36:31 +0000
Received: from BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
 ([fe80::3c32:331c:38c7:e9b0]) by BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
 ([fe80::3c32:331c:38c7:e9b0%5]) with mapi id 15.20.5676.020; Tue, 4 Oct 2022
 20:36:31 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: Linux RAID futures question
Thread-Topic: Linux RAID futures question
Thread-Index: AdjYMPuHQO2okXsCTiG3TSyfFouhkA==
Date:   Tue, 4 Oct 2022 20:36:31 +0000
Message-ID: <BN8P111MB1956CAEE20D8EDA11B0DFDB3A95A9@BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mail.mil;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN8P111MB1956:EE_|BN8P111MB1740:EE_
x-ms-office365-filtering-correlation-id: 7c17474e-0489-4d0e-6c64-08daa6481f0b
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MRAzSmD7D1/gfEicYF/PRD9bhPbxgMXW4VlK1r5qTQ73pV/5F3LE9oXSK+W8Fu3hPMRdBSQ+JvRO++LLjU09Vt8qzrCvnNexnwFzu1YjxKnOaoL2zSuJLoyPuwXBvgBL53ChFCWvCQOwzMMBZLKjDQhs0/Eks24XSoyjASW8ghlECz2KVjKzBNni64BB7BAy150eoq98ErdAsP5PctKlv1X8hXv8/2Uhf3FQRy+Oefqg9JKt7AACSV/EQsevidAKqo8/ed6t0fjEoWFLqG6uEyxEuN2DsifsgxBIM5libCxEOXpWtA4pdF3l0rPd6WeqXAteozVwbrA9Ob7O4AfjaFdRWhSymjxgfROG3ioq/GKiLlTQbDlnap5JeuO4Pg/qhiiyLFJyqhyvAez5TsNsFR2IpMVTOT5JTkWR/klxXOsywy/rORTcig/3gRer8S5RZ9CYO1DUu1GuyIqlb0UcRbp7fegy2hnHelqp8wHHOJ57qTLIjNuvHRtp5WYfkd+d7p8AO727o9zemJHrtBPpPFyCDPrxne/dZQpMXBmXGsRcBp/+AEqkR+P2sF8FROTQsL/uhXIrk5hTMVhdh9xn6FHPrEtxlkdw6HNRuKgUXFqMukmgri/LaMF0VVThFKYVR2nuNOiJ8R0qe2Br6BA5oE7FRAgqoIeO2DyZ5H4jbbu+j7DX5fLD3FvtuKiv60eA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(451199015)(8676002)(86362001)(107886003)(38070700005)(498600001)(2906002)(6916009)(66899015)(4326008)(82960400001)(33656002)(8936002)(7696005)(122000001)(38100700002)(6506007)(55016003)(3480700007)(186003)(26005)(5660300002)(71200400001)(66476007)(64756008)(76116006)(66946007)(66556008)(83380400001)(9686003)(66446008)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: nOhuspu8JmRRSAkVJMN9F051fRIl29nuWgMgNDgFd++eOHJaM+uyhuH97MWY5sSRbm+aW2vAsm7jmvDg4QcrQcsOQL90OiyW9Sc3wDh/RxU2L0j5jGtYHr1SJ3XiwpQrUjoinhEUZNePlbubXyLXG4smta3AUBd8vAztzAu5UsBZ3xV6V7TUqk4SRFih7QmsWVQx8rKyidLg5pdwxj98jt4BD6zgDUXzig98mUmAfC80hrOZDXB49BVfxNhCgimcbZptpm7JEEVMeWC9TUZrDPO+74hC5DSCPj8cyo4yNyWndLbq7jXsRHVmvS8LFkebDBnJZW9S/xFQGJxT1IrILrsTQgDjdiErL3l/LuvqxCodbEwBpLWOLKdI4uZKAp2OdOM9eZoA7GivSTb7eezn/apJoZOC663JRDG5IAgKngw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8P111MB1956.NAMP111.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c17474e-0489-4d0e-6c64-08daa6481f0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 20:36:31.4888
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 102d0191-eeae-4761-b1cb-1a83e86ef445
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8P111MB1740
X-OriginatorOrg: mail.mil
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

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



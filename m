Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89662C4338F
	for <linux-raid@archiver.kernel.org>; Thu,  5 Aug 2021 20:50:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F6DE600EF
	for <linux-raid@archiver.kernel.org>; Thu,  5 Aug 2021 20:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhHEUvM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Aug 2021 16:51:12 -0400
Received: from UPDC19PA23.eemsg.mail.mil ([214.24.27.198]:55051 "EHLO
        UPDC19PA23.eemsg.mail.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbhHEUvI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Aug 2021 16:51:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=mail.mil; i=@mail.mil; q=dns/txt; s=EEMSG2021v1a;
  t=1628196653; x=1659732653;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z477zErh0GY0qzi5ROTRJFy5OQO3sv5oF1R0R5K3L48=;
  b=Xr+eHhuO2kxWnGUIFNZaQ5YabhAt6+f9R/Is1e78y/DvSDzHIAiBkYl1
   qBTaV3c5WFLGs9ctwqUI9D16rwQIJ8Blb8sMBaRBKS2S5Gcpq4Ix3choA
   MNLRlLggyxvaWZpGmPK7oJQUMKWUex+bCQGVoWly/47+/0XoAO2hqgAqe
   UFw2B6ynYDY1hagxFrtHc1jM3D64hFLqIqOH6iwbrvvGhrZf3tzP1Ianb
   jk59HOLUAc7eT6W+ZrCmVlgVOUq++iPLXCQX4jp9dJmXZQmJMnQTPfTcH
   v3zSEWBdi0qDCEk8H3+QteRlgSxQAniH5VYH8kh1j7Zfjhx6Vpe+c1IhB
   g==;
X-EEMSG-check-017: 251640452|UPDC19PA23_ESA_OUT05.csd.disa.mil
X-IronPort-AV: E=Sophos;i="5.84,296,1620691200"; 
   d="scan'208";a="251640452"
Received: from edge-mech02.mail.mil ([214.21.130.229])
  by UPDC19PA23.eemsg.mail.mil with ESMTP/TLS/ECDHE-RSA-AES256-SHA384; 05 Aug 2021 20:50:50 +0000
Received: from UMECHPAOW.easf.csd.disa.mil (214.21.130.166) by
 edge-mech02.mail.mil (214.21.130.229) with Microsoft SMTP Server (TLS) id
 14.3.498.0; Thu, 5 Aug 2021 20:50:16 +0000
Received: from UMECHPA7B.easf.csd.disa.mil ([169.254.8.164]) by
 umechpaow.easf.csd.disa.mil ([214.21.130.166]) with mapi id 14.03.0513.000;
 Thu, 5 Aug 2021 20:50:16 +0000
From:   "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
To:     "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
CC:     'Gal Ofri' <gal.ofri@volumez.com>,
        "Finlayson, James M CIV (USA)" <james.m.finlayson4.civ@mail.mil>
Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS
 - AMD ROME what am I missing?????
Thread-Topic: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread
 IOPS - AMD ROME what am I missing?????
Thread-Index: AQHXg5T/4rk7hCCa50OEioMjNG53XatlVF4ggAAKU8CAAACJAIAACzvA
Date:   Thu, 5 Aug 2021 20:50:16 +0000
Message-ID: <5EAED86C53DED2479E3E145969315A2385856B62@UMECHPA7B.easf.csd.disa.mil>
References: <5EAED86C53DED2479E3E145969315A2385841062@UMECHPA7B.easf.csd.disa.mil>
 <AS8PR04MB799205817C4647DAC740DE9A91EA9@AS8PR04MB7992.eurprd04.prod.outlook.com>
 <5EAED86C53DED2479E3E145969315A2385856AD0@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856AF7@UMECHPA7B.easf.csd.disa.mil>
 <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
In-Reply-To: <5EAED86C53DED2479E3E145969315A2385856B25@UMECHPA7B.easf.csd.disa.mil>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [214.21.44.12]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

As far as the slower hero numbers - false alarm on my part - rebooted with =
4.18 RHEL 8.4 kernel
Socket0 hero - 13.2M IOPS, Socket1 hero 13.7M IOPS.   I have to figure out =
the differences either between my drives or my server.  Chances are, slot f=
or slot I have PCIe cards that are in different slots between the two serve=
rs if I had to guess....

As a major flag though - with mdraid volumes I created under the 5.14rc3 ke=
rnel, I lock the system up solid when I try to access them under 4.18.....I=
'm not an expert on forcing NMI's and getting the stack traces, so I might =
have to leave that to others.....After two lockups, I returned to the 5.14 =
kernel.   If I need to run something - you have seen the config I have - I'=
m willing.  =20

I'm willing to push as hard as I can and to run anything that can help as l=
ong as it isn't urgent - I have a day job and have some constraints as a ci=
vil servant, however, I have the researcher, push push push mindset.   I wa=
nt to really encourage the community to push as hard as possible on protect=
ed IOPS and I'm willing to help however I can....In my interactions with th=
e processor and server OEMs - I'm encouraging them to get the Linux leaders=
 in I/O development, the biggest baddest Server/SSD combinations they have =
early in the development.   I know they won't listen to me but I'm trying t=
o help.

For those of you on Rome server, get with your server provider.   There are=
 some things in the BIOS that can be tweaked for I/O.  =20


-----Original Message-----
From: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>=20
Sent: Thursday, August 5, 2021 3:52 PM
To: 'linux-raid@vger.kernel.org' <linux-raid@vger.kernel.org>
Cc: 'Gal Ofri' <gal.ofri@volumez.com>; Finlayson, James M CIV (USA) <james.=
m.finlayson4.civ@mail.mil>
Subject: RE: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOP=
S - AMD ROME what am I missing?????

Sorry - again..I sent HTML instead of plain text

Resend - mailing list bounce
All,
Sorry for the delay - both work and life got into the way.=A0=A0 Here is so=
me feedback:

BLUF upfront with 5.14rc3 kernel that our SA built - md0 a 10+1+1 RAID5 - 5=
.332 M IOPS 20.3GiB/s, md1 a 10+1+1 RAID5, 5.892M IOPS 22.5GiB/s=A0 - best =
hero numbers I've ever seen on mdraid =A0RAID5 IOPS.=A0=A0 I think the kern=
el patch is good.=A0 Prior was =A0socket0 1.263M IOPS 4934MiB/s, socket1 1.=
071M IOSP, 4183MiB/s....=A0=A0 I'm willing to help push this as hard as we =
can until we hit a bottleneck outside of our control.=A0=A0=20

I need to verify the RAW IOPS - admittedly this is a different server and I=
 didn't do any regression testing before the kernel, but my raw were=A0 soc=
ket0: 13.2M IOPS and socket1 =A013.5M IOPS.=A0=A0 Prior was socket0 16.0M I=
OPS and socket1 13.5M IOPS.=A0 =A0- admittedly there appears to a regressio=
n in the socket0 "hero run" but what I don't know that since this is a diff=
erent server, I don't know if I have a configuration management issue in my=
 zealousness to test this patch or whether we have a regression.=A0=A0 I wa=
s so excited to have the attention of kernel developers that needed my help=
 that I borrowed another system, because I didn't want to tear apart my "Fr=
ankenstein's monster" 32 partition mdraid LVM mess.=A0=A0 If I can switch k=
ernels and reboot before work and life get back in the way, I'll follow=A0 =
up..

I think I might have to give myself the action to run this to ground next w=
eek on the other server.=A0=A0 Without a doubt the mdraid lock improvement =
is worth taking forward.=A0=A0 I either have to find my error or point a fi=
nger as my raw hero numbers got worse. =A0=A0I tend to see one socket outru=
n another - =A0the way HPE allocates the nvme drives to pcie root complexes=
 =A0is not how I'd like to do it so the drives are unbalanced on the PCIe r=
oot complexes (drives are in 4 different root complexes on socket 0 and 3 o=
n socket 1, so one would think socket0 will always be faster for hero runs =
=A0(an NPS4 numa mapping is the best way to show it:
[root@gremlin04 hornet05]# cat *nps4
#filename=3D/dev/nvme0n1 0
#filename=3D/dev/nvme1n1 0
#filename=3D/dev/nvme2n1 1
#filename=3D/dev/nvme3n1 1
#filename=3D/dev/nvme4n1 2
#filename=3D/dev/nvme5n1 2
#filename=3D/dev/nvme6n1 2
#filename=3D/dev/nvme7n1 2
#filename=3D/dev/nvme8n1 3
#filename=3D/dev/nvme9n1 3
#filename=3D/dev/nvme10n1 3
#filename=3D/dev/nvme11n1 3
#filename=3D/dev/nvme12n1 4
#filename=3D/dev/nvme13n1 4
#filename=3D/dev/nvme14n1 4
#filename=3D/dev/nvme15n1 4
#filename=3D/dev/nvme17n1 5
#filename=3D/dev/nvme18n1 5
#filename=3D/dev/nvme19n1 5
#filename=3D/dev/nvme20n1 5
#filename=3D/dev/nvme21n1 6
#filename=3D/dev/nvme22n1 6
#filename=3D/dev/nvme23n1 6
#filename=3D/dev/nvme24n1 6


fio fiojim.hpdl385.nps1
socket0: (g=3D0): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)=
 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
socket1: (g=3D1): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, (T)=
 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
socket0-md: (g=3D2): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
socket1-md: (g=3D3): rw=3Drandread, bs=3D(R) 4096B-4096B, (W) 4096B-4096B, =
(T) 4096B-4096B, ioengine=3Dlibaio, iodepth=3D128 ...
fio-3.26
Starting 256 processes
Jobs: 128 (f=3D128): [_(128),r(128)][1.5%][r=3D42.8GiB/s][r=3D11.2M IOPS][e=
ta 10h:40m:00s]
socket0: (groupid=3D0, jobs=3D64): err=3D 0: pid=3D522428: Thu Aug=A0 5 19:=
33:05 2021
=A0 read: IOPS=3D13.2M, BW=3D50.2GiB/s (53.9GB/s)(14.7TiB/300005msec)
=A0=A0=A0 slat (nsec): min=3D1312, max=3D8308.1k, avg=3D2206.72, stdev=3D15=
05.92
=A0=A0=A0 clat (usec): min=3D14, max=3D42033, avg=3D619.56, stdev=3D671.45
=A0=A0=A0=A0 lat (usec): min=3D19, max=3D42045, avg=3D621.83, stdev=3D671.4=
6
=A0=A0=A0 clat percentiles (usec):
=A0=A0=A0=A0 |=A0 1.00th=3D[=A0 113],=A0 5.00th=3D[=A0 149], 10.00th=3D[=A0=
 180], 20.00th=3D[=A0 229],
=A0=A0=A0=A0 | 30.00th=3D[=A0 273], 40.00th=3D[=A0 310], 50.00th=3D[=A0 351=
], 60.00th=3D[=A0 408],
=A0=A0=A0 =A0| 70.00th=3D[=A0 578], 80.00th=3D[=A0 938], 90.00th=3D[ 1467],=
 95.00th=3D[ 1909],
=A0=A0=A0=A0 | 99.00th=3D[ 3163], 99.50th=3D[ 4178], 99.90th=3D[ 5800], 99.=
95th=3D[ 6390],
=A0=A0=A0=A0 | 99.99th=3D[ 8455]
=A0=A0 bw (=A0 MiB/s): min=3D28741, max=3D61365, per=3D18.56%, avg=3D51489.=
80, stdev=3D82.09, samples=3D38016
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D7357916, max=3D15709528, avg=3D131=
81362.22, stdev=3D21013.83, samples=3D38016
=A0 lat (usec)=A0=A0 : 20=3D0.01%, 50=3D0.02%, 100=3D0.42%, 250=3D24.52%, 5=
00=3D42.21%
=A0 lat (usec)=A0=A0 : 750=3D7.94%, 1000=3D6.34%
=A0 lat (msec)=A0=A0 : 2=3D14.26%, 4=3D3.74%, 10=3D0.54%, 20=3D0.01%, 50=3D=
0.01%
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D14.58%, sys=3D47.48%, ctx=3D2919=
12925, majf=3D0, minf=3D10492
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%,=
 32=3D0.1%, >=3D64=3D100.0%
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.1%
=A0=A0=A0=A0 issued rwts: total=3D3949519687,0,0,0 short=3D0,0,0,0 dropped=
=3D0,0,0,0
=A0=A0=A0=A0 latency=A0=A0 : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
socket1: (groupid=3D1, jobs=3D64): err=3D 0: pid=3D522492: Thu Aug=A0 5 19:=
33:05 2021
=A0 read: IOPS=3D13.6M, BW=3D51.8GiB/s (55.7GB/s)(15.2TiB/300004msec)
=A0=A0=A0 slat (nsec): min=3D1323, max=3D4335.7k, avg=3D2242.27, stdev=3D16=
08.25
=A0=A0=A0 clat (usec): min=3D14, max=3D41341, avg=3D600.15, stdev=3D726.62
=A0=A0=A0=A0 lat (usec): min=3D20, max=3D41358, avg=3D602.46, stdev=3D726.6=
4
=A0=A0=A0 clat percentiles (usec):
=A0=A0=A0=A0 |=A0 1.00th=3D[=A0 115],=A0 5.00th=3D[=A0 151], 10.00th=3D[=A0=
 184], 20.00th=3D[=A0 231],
=A0=A0=A0=A0 | 30.00th=3D[=A0 269], 40.00th=3D[=A0 306], 50.00th=3D[=A0 347=
], 60.00th=3D[=A0 400],
=A0=A0=A0=A0 | 70.00th=3D[=A0 506], 80.00th=3D[=A0 799], 90.00th=3D[ 1303],=
 95.00th=3D[ 1909],
=A0=A0=A0=A0 | 99.00th=3D[ 3589], 99.50th=3D[ 4424], 99.90th=3D[ 7111], 99.=
95th=3D[ 7767],
=A0=A0=A0=A0 | 99.99th=3D[10290]
=A0=A0 bw (=A0 MiB/s): min=3D28663, max=3D71847, per=3D21.11%, avg=3D53145.=
09, stdev=3D111.29, samples=3D38016
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D7337860, max=3D18392866, avg=3D136=
05117.00, stdev=3D28491.19, samples=3D38016
=A0 lat (usec)=A0=A0 : 20=3D0.01%, 50=3D0.02%, 100=3D0.36%, 250=3D24.52%, 5=
00=3D44.77%
=A0 lat (usec)=A0=A0 : 750=3D8.90%, 1000=3D6.37%
=A0 lat (msec)=A0=A0 : 2=3D10.52%, 4=3D3.87%, 10=3D0.66%, 20=3D0.01%, 50=3D=
0.01%
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D14.86%, sys=3D49.40%, ctx=3D2826=
34154, majf=3D0, minf=3D10276
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%,=
 32=3D0.1%, >=3D64=3D100.0%
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0 =A0=A0=A0complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.1%
=A0=A0=A0=A0 issued rwts: total=3D4076360454,0,0,0 short=3D0,0,0,0 dropped=
=3D0,0,0,0
=A0=A0=A0=A0 latency=A0=A0 : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
socket0-md: (groupid=3D2, jobs=3D64): err=3D 0: pid=3D524061: Thu Aug=A0 5 =
19:33:05 2021
=A0 read: IOPS=3D5332k, BW=3D20.3GiB/s (21.8GB/s)(6102GiB/300002msec)
=A0=A0=A0 slat (nsec): min=3D1633, max=3D17043k, avg=3D11123.38, stdev=3D86=
94.61
=A0=A0=A0 clat (usec): min=3D186, max=3D18705, avg=3D1524.87, stdev=3D115.2=
9
=A0=A0=A0=A0 lat (usec): min=3D200, max=3D18743, avg=3D1536.08, stdev=3D115=
.90
=A0=A0=A0 clat percentiles (usec):
=A0=A0=A0=A0 |=A0 1.00th=3D[ 1270],=A0 5.00th=3D[ 1336], 10.00th=3D[ 1369],=
 20.00th=3D[ 1418],
=A0=A0=A0=A0 | 30.00th=3D[ 1467], 40.00th=3D[ 1500], 50.00th=3D[ 1532], 60.=
00th=3D[ 1549],
=A0=A0=A0=A0 | 70.00th=3D[ 1582], 80.00th=3D[ 1631], 90.00th=3D[ 1680], 95.=
00th=3D[ 1713],
=A0=A0=A0=A0 | 99.00th=3D[ 1795], 99.50th=3D[ 1811], 99.90th=3D[ 1893], 99.=
95th=3D[ 1926],
=A0=A0=A0=A0 | 99.99th=3D[ 2089]
=A0=A0 bw (=A0 MiB/s): min=3D19030, max=3D21969, per=3D100.00%, avg=3D20843=
.43, stdev=3D 5.35, samples=3D38272
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D4871687, max=3D5624289, avg=3D5335=
900.01, stdev=3D1370.43, samples=3D38272
=A0 lat (usec)=A0=A0 : 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
=A0 lat (msec)=A0=A0 : 2=3D99.97%, 4=3D0.02%, 10=3D0.01%, 20=3D0.01%
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D5.56%, sys=3D77.91%, ctx=3D8118,=
 majf=3D0, minf=3D9018
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%,=
 32=3D0.1%, >=3D64=3D100.0%
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.1%
=A0=A0=A0=A0issued rwts: total=3D1599503201,0,0,0 short=3D0,0,0,0 dropped=
=3D0,0,0,0
=A0=A0=A0=A0 latency=A0=A0 : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128
socket1-md: (groupid=3D3, jobs=3D64): err=3D 0: pid=3D524125: Thu Aug=A0 5 =
19:33:05 2021
=A0 read: IOPS=3D5892k, BW=3D22.5GiB/s (24.1GB/s)(6743GiB/300002msec)
=A0=A0=A0 slat (nsec): min=3D1663, max=3D1274.1k, avg=3D9896.09, stdev=3D79=
39.50
=A0=A0=A0 clat (usec): min=3D236, max=3D11102, avg=3D1379.86, stdev=3D148.6=
4
=A0=A0=A0=A0 lat (usec): min=3D239, max=3D11110, avg=3D1389.84, stdev=3D149=
.54
=A0=A0=A0 clat percentiles (usec):
=A0=A0=A0=A0 |=A0 1.00th=3D[ 1106],=A0 5.00th=3D[ 1172], 10.00th=3D[ 1205],=
 20.00th=3D[ 1254],
=A0=A0=A0=A0 | 30.00th=3D[ 1287], 40.00th=3D[ 1336], 50.00th=3D[ 1369], 60.=
00th=3D[ 1401],
=A0=A0=A0=A0 | 70.00th=3D[ 1434], 80.00th=3D[ 1500], 90.00th=3D[ 1582], 95.=
00th=3D[ 1663],
=A0=A0=A0=A0 | 99.00th=3D[ 1811], 99.50th=3D[ 1860], 99.90th=3D[ 1942], 99.=
95th=3D[ 1958],
=A0=A0=A0=A0 | 99.99th=3D[ 2040]
=A0=A0 bw (=A0 MiB/s): min=3D20982, max=3D24535, per=3D-82.15%, avg=3D23034=
.61, stdev=3D15.46, samples=3D38272
=A0=A0 iops=A0=A0=A0=A0=A0=A0=A0 : min=3D5371404, max=3D6281119, avg=3D5896=
843.14, stdev=3D3958.21, samples=3D38272
=A0 lat (usec)=A0=A0 : 250=3D0.01%, 500=3D0.01%, 750=3D0.01%, 1000=3D0.01%
=A0 lat (msec)=A0=A0 : 2=3D99.97%, 4=3D0.02%, 10=3D0.01%, 20=3D0.01%
=A0 cpu=A0=A0=A0=A0=A0=A0=A0=A0=A0 : usr=3D6.55%, sys=3D74.98%, ctx=3D9833,=
 majf=3D0, minf=3D8956
=A0 IO depths=A0=A0=A0 : 1=3D0.1%, 2=3D0.1%, 4=3D0.1%, 8=3D0.1%, 16=3D0.1%,=
 32=3D0.1%, >=3D64=3D100.0%
=A0=A0=A0=A0 submit=A0=A0=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 3=
2=3D0.0%, 64=3D0.0%, >=3D64=3D0.0%
=A0=A0=A0=A0 complete=A0 : 0=3D0.0%, 4=3D100.0%, 8=3D0.0%, 16=3D0.0%, 32=3D=
0.0%, 64=3D0.0%, >=3D64=3D0.1%
=A0=A0=A0=A0 issued rwts: total=3D1767618924,0,0,0 short=3D0,0,0,0 dropped=
=3D0,0,0,0
=A0=A0=A0=A0 latency=A0=A0 : target=3D0, window=3D0, percentile=3D100.00%, =
depth=3D128

Run status group 0 (all jobs):
=A0=A0 READ: bw=3D50.2GiB/s (53.9GB/s), 50.2GiB/s-50.2GiB/s (53.9GB/s-53.9G=
B/s), io=3D14.7TiB (16.2TB), run=3D300005-300005msec

Run status group 1 (all jobs):
=A0=A0 READ: bw=3D51.8GiB/s (55.7GB/s), 51.8GiB/s-51.8GiB/s (55.7GB/s-55.7G=
B/s), io=3D15.2TiB (16.7TB), run=3D300004-300004msec

Run status group 2 (all jobs):
=A0=A0 READ: bw=3D20.3GiB/s (21.8GB/s), 20.3GiB/s-20.3GiB/s (21.8GB/s-21.8G=
B/s), io=3D6102GiB (6552GB), run=3D300002-300002msec

Run status group 3 (all jobs):
=A0=A0 READ: bw=3D22.5GiB/s (24.1GB/s), 22.5GiB/s-22.5GiB/s (24.1GB/s-24.1G=
B/s), io=3D6743GiB (7240GB), run=3D300002-300002msec

Disk stats (read/write):
=A0 nvme0n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme1n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme2n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme3n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme4n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme5n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme6n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme7n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme8n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme9n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.00=
%
=A0 nvme10n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme11n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme12n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme13n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme14n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme15n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme17n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme18n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme19n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme20n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme21n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme22n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme23n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 nvme24n1: ios=3D0/0, merge=3D0/0, ticks=3D0/0, in_queue=3D0, util=3D0.0=
0%
=A0 md0: ios=3D1599378656/0, merge=3D0/0, ticks=3D391992721/0, in_queue=3D3=
91992721, util=3D100.00%
=A0 md1: ios=3D1767484212/0, merge=3D0/0, ticks=3D427666887/0, in_queue=3D4=
27666887, util=3D100.00%

From: Gal Ofri <gal.ofri@volumez.com>
Sent: Wednesday, July 28, 2021 5:43 AM
To: Finlayson, James M CIV (USA) <james.m.finlayson4.civ@mail.mil>; 'linux-=
raid@vger.kernel.org' <linux-raid@vger.kernel.org>
Subject: [Non-DoD Source] Re: Can't get RAID5/RAID6 NVMe randomread IOPS - =
AMD ROME what am I missing?????

All active links contained in this email were disabled. Please verify the i=
dentity of the sender, and confirm the authenticity of all links contained =
within the message prior to copying and pasting the address to a Web browse=
r.=20
________________________________________

A recent commit raised the=A0limit on raid5/6 read iops.
It's available in 5.14.
See=A0Caution-https://github.com/torvalds/linux/commit/97ae27252f4962d0fcc3=
8ee1d9f913d817a2024e=A0<=A0Caution-https://github.com/torvalds/linux/commit=
/97ae27252f4962d0fcc38ee1d9f913d817a2024e=A0> commit 97ae27252f4962d0fcc38e=
e1d9f913d817a2024e
Author: Gal Ofri <gal.ofri@storing.io>
Date: =A0 Mon Jun 7 14:07:03 2021 +0300
=A0 =A0 md/raid5: avoid device_lock in read_one_chunk()

Please do share if you reach more iops in your env than described in the co=
mmit.

Cheers,
Gal,
Volumez (formerly storing.io)

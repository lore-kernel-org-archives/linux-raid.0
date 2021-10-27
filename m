Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421ADC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 20:42:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 241FD60230
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 20:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243970AbhJ0Uoy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 16:44:54 -0400
Received: from mail-gv0che01on2132.outbound.protection.outlook.com ([40.107.23.132]:19328
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243953AbhJ0Uoq (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 16:44:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXMfFU1CB6Oq85HCA0xv8TbvtBrYDVhlwxoLMGj1fxk=;
 b=UzSVdiViJ3d8hPHMBNt8IxLbe1TbWZAvR4Rf/ufuR5xeYSVn/kRalc09zbNjWsNcaHnJj39CGsiXTjsqkkSp8/COl6iPHl68rKC+zwXVvcI5mJh5YSEUxfjOrqWGZPQ5JkLbns09oWMTH7iySwErHmqrt81EzkC6i0u5u5+r/UE=
Received: from AS8PR04CA0165.eurprd04.prod.outlook.com (2603:10a6:20b:331::20)
 by ZRAP278MB0875.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:4a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14; Wed, 27 Oct
 2021 20:42:17 +0000
Received: from AM5EUR02FT024.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:20b:331:cafe::3a) by AS8PR04CA0165.outlook.office365.com
 (2603:10a6:20b:331::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend
 Transport; Wed, 27 Oct 2021 20:42:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 104.40.229.156)
 smtp.mailfrom=werft22.com; vger.kernel.org; dkim=fail (body hash did not
 verify) header.d=nanoo.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=werft22.com;
Received-SPF: Pass (protection.outlook.com: domain of werft22.com designates
 104.40.229.156 as permitted sender) receiver=protection.outlook.com;
 client-ip=104.40.229.156; helo=eu1.smtp.exclaimer.net;
Received: from eu1.smtp.exclaimer.net (104.40.229.156) by
 AM5EUR02FT024.mail.protection.outlook.com (10.152.8.126) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4649.14 via Frontend Transport; Wed, 27 Oct 2021 20:42:16 +0000
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (104.47.22.41)
         by eu1.smtp.exclaimer.net (104.40.229.156) with Exclaimer Signature Manager
         ESMTP Proxy eu1.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Wed, 27 Oct 2021 20:42:16 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 3164188
X-ExclaimerImprintLatency: 421044
X-ExclaimerImprintAction: cc22e4e0cd554b8db05ee8789259594d
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bf0/pwB3ca5E5o3H9klay3SRdp/nu0ujCBK3g4bEZFl9Hyh3sWPPYga4OywCR2yoho+BKGc2h3TNK5Kdt2pW/CWxJpmmH31Rkm8b9ubPOYjJwph9Sdsv6jCes+CcQxYdDHIhePlzNhvC1KF2Sxxk0Ea7Ouqpp6HeWzz3WZX63hiRie0592PJNeYBjq1FGRBt3IDOpaa3cYr92MPb8sa6PRm5GnRwbR35Nsu08GhWUL8WHjH5HXs+ly1Lhg0TPfaP50Yn1qVVouH8GDYXkgQBZMLLLDBa87Kh+JCoWTcEnFCnW/nrk4jX+onGozqaIJnnesW4Ty4NaIskGC87zcXs6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3P3uqjCUqKSKQvYkpcvyxENstW5p+NhFJfzvYUE3Ww=;
 b=M81FFsQBcReudKjLQY+1/Nzqk9kqmyo0/wUlOYjkg2zo388Hng2i2di6JFD5TxYn2HIO+SJgrA1l3j0Vo2vjR7y9yOgzkrcrNzOksICR1/RmLjrvidZmNhYapHNyuXJIh8MY/5pl1lbTAvy0LpgHdGafpp/sk4c9V98mKxclmvOtP9CTGm2baeoyojYP8r3EEMcpMvXQ+ujhQRQMw3bI5S4wVB/efjTWzky/6HIO4yyCRKvkLiL6M7K7QOah5FLK6bF03AKZIZsOs7LVCmKIqSUAMSY4u3rzQyn9DZWQYCK7O9uiFDAb231sb2HXlxcZlizOxdV9dEY/aNlcjsATZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=werft22.com; dmarc=pass action=none header.from=werft22.com;
 dkim=pass header.d=werft22.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q3P3uqjCUqKSKQvYkpcvyxENstW5p+NhFJfzvYUE3Ww=;
 b=HnF3nwMwUukQnN0b1pThir+tRj4PnpveX82Cl496gk53ZRNzftl9xRtQOducPiO81iXtVFg11sV7+zipKSrUSERdzmPNIzuZWAG6ZV5/qvnkQYg22LHjJJB+K6+MMlApSHyHJ+TiYN799dmg4cFEe2veDbJacBPkFLxu1zQXiGU=
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=werft22.com;
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::5) by
 ZRAP278MB0351.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2a::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4628.18; Wed, 27 Oct 2021 20:42:15 +0000
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942]) by ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942%6]) with mapi id 15.20.4628.020; Wed, 27 Oct 2021
 20:42:14 +0000
From:   "Andreas U. Trottmann" <andreas.trottmann@werft22.com>
Subject: Re: "md/raid:mdX: cannot start dirty degraded array."
To:     linux-raid@vger.kernel.org
References: <8b0a13e1-0972-be41-d234-2202abe1a54c@werft22.com>
Message-ID: <8466df78-d0b7-2149-355c-64b0f4526cb7@werft22.com>
Date:   Wed, 27 Oct 2021 22:42:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
In-Reply-To: <8b0a13e1-0972-be41-d234-2202abe1a54c@werft22.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-CH
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ZR0P278CA0064.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::15) To ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::5)
MIME-Version: 1.0
Received: from [IPv6:2a02:168:f013:0:ccbe:9f63:d676:f181] (2a02:168:f013:0:ccbe:9f63:d676:f181) by ZR0P278CA0064.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:21::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13 via Frontend Transport; Wed, 27 Oct 2021 20:42:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 502eb478-c282-4ebc-8d2d-08d9998a43a4
X-MS-TrafficTypeDiagnostic: ZRAP278MB0351:|ZRAP278MB0875:
X-Microsoft-Antispam-PRVS: <ZRAP278MB087573F7ED2CB3EBF0BDA00AE2859@ZRAP278MB0875.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: 8/S1FqbwbKxjPhSRFsM7AIdJ2RMDcpdP0VSisKo3cEKphx3STlCa+W3NZY6yhVSwarI49tQhrNvv6WsBOaazfUmJ/lJWexE81YsEAKpb40SRh6q6iIQnq23Xl/MOfGPxNsB6Az4Caf1WzwvPg7eOa95fkah/TKNDsolD4BwePqta4aT84cf4iZpOCVWyvWuGZQoruKiC7BALBFHPQ0alpwcxuxQaGw3FIkRzmUCDl37vEPPNlnqVRi4YgR21/geVZrVO/EYalB+mhBreDIZTCL8GUbhhXIYw87ih8jm1bO8ke6NI0o2+GXfdqtd7lzySZtaaAZmHhPVTDSSqxQtNk7eknGeB4l8jhI/OurNv8rjbOKLRzisZ08GFHHKZcLqqAbdjV0UuCqOJHhBZpj2tKmc43fkueuf36Mi+HG/9pDVMzVWoMkZu+pwNbs09iZ8FWm8Yk5LA6bR840GxDT+Gi0qIIRe1SiRsJDlV2zhlM32oG0+oCiweWAlCND9DEvsR+bhirebvc1ocxl9CQy6TcRr+vrVdeVfGqkOhieGQOnX9zkL+OVvFrZOsp3bPu1AkrRCv9I0YRtapYOO5QpB2Leo0t7TyVNKg4u0nWQvomIDwNXteal79E3WICUPAyBKhbFUKX8vGLnPTEQiYDZAM3PoXNj35bti5gwi5LqtBg+lWb3PAgXh3XK43ITEInciK7G1ylXUA9saCj0KhKQLlae4bFYBE2QPPK/al+8xSaEuk6QbXfukQSvhy2Gkt/vD9
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(366004)(396003)(6916009)(6486002)(38100700002)(2616005)(508600001)(66946007)(5660300002)(66476007)(2906002)(8676002)(36756003)(86362001)(31686004)(186003)(83380400001)(8936002)(316002)(19627235002)(31696002)(66556008)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0351
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR02FT024.eop-EUR02.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 86809a82-d596-4366-5b02-08d9998a4244
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 33cHy9rORcUajLScxp/XXrCO9vzrf55+V+FYF5qGOp/EwOsmowGh9jsoytL0hwyj5aE5IIlSGzCZeaYv+zhfurNIv+YJw5xxCLlb3O/qo5Z992JxOO3038unmIn2PFHxKvPhp7/I5/oxMJsOWEPFzjbdsyoK/iwnJ8p3uCvPXTZglLGmvjuNiOKawfLVnK4i5Bmq+b0kqfCel6MGwsHXoT1/ZUbiEsBuuAt8+deqtQolinhGvRbBTJPdRhjMN8Zhj8wEWmjZDYEaPc3ct3SX1ZnVsVz4PM0jLNQWKhVP0VnP1wKqkMWMzX3xM/XXHw7IKaYkIbe4vXtdMqs+L3NobqDHva+bCJQFd14MEFpsbQD1bnnKm+ktlV9eiM+fifNxKwyAp2oeVV1jKEbTBsqK4O0rqrw7Uhm+2Rc8wnGfEcTyQvaACGWcVkDN1o/gZa8vsbBLLPY6cp5ozH0xV99rz4osp3OKOK3IGjtblRO1ozTxkwdv1OfFCYUAsanVhG5L6Xt+4sYgF3Bi8Z+cgQO8SefdhqLA1r/xXfqTNtlGRTwgSbJPgAMhStdFiRVU3BDIAPhP1TqU3LF4kT5pALVIBgdo06P3jmBOlbR/wjZWqGYBblXoJ5Y7KLBNIKufVqMiql1Q9ChHn3wV/K3EkzCQKTNgc5lKB9OL5xZze8IFIKv6Qm6x9zyVmPX00dZJ/3k1eYvzUoDiicdac2LccGkJOPgjE0VFZNZzoqU4nNNZZTw0EL/VfpTOhUMPYD1DlAFJ
X-Forefront-Antispam-Report: CIP:104.40.229.156;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu1.smtp.exclaimer.net;PTR:eu1.smtp.exclaimer.net;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(396003)(46966006)(36840700001)(31696002)(31686004)(6916009)(336012)(26005)(36756003)(36860700001)(86362001)(8936002)(70206006)(70586007)(316002)(2616005)(186003)(19627235002)(508600001)(8676002)(6486002)(47076005)(83380400001)(7596003)(356005)(5660300002)(2906002)(82310400003)(7636003)(14143004)(43740500002);DIR:OUT;SFP:1102;
X-OriginatorOrg: werft22.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2021 20:42:16.8070
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 502eb478-c282-4ebc-8d2d-08d9998a43a4
X-MS-Exchange-CrossTenant-Id: 28eff738-e52c-4df8-9f47-73928389e1b3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=28eff738-e52c-4df8-9f47-73928389e1b3;Ip=[104.40.229.156];Helo=[eu1.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR02FT024.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZRAP278MB0875
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Am 08.10.21 um 21:57 schrieb Andreas Trottmann:

> I am running a server that runs a number of virtual machines and manages=
=20
> their virtual disks as logical volumes using lvmraid (...)

> After a restart, all of the logical volumes came back, except one.

> When I'm trying to activate it, I get:
>=20
> # lvchange -a y /dev/vg_ssds_0/host-home
>  =C2=A0 Couldn't find device with uuid 8iz0p5-vh1c-kaxK-cTRC-1ryd-eQd1-wX=
1Yq9.
>  =C2=A0 device-mapper: reload ioctl on=C2=A0 (253:245) failed: Input/outp=
ut error


I am replying to my own e-mail here in order to document how I got the=20
data back, in case someone in a similar situation finds this mail when=20
searching for the symptoms.

First: I did *not* succeeed in activating the lvmraid volume. No matter=20
how I tried to modify the _rmeta volumes, I always got "reload ioctl=20
(...) failed: Input/output error" from "lvchange", and "cannot start=20
dirty degraded array" in dmesg.

So, I used "lvchange -a y /dev/vg_ssds_0/host-home_rimage_0" (and=20
_rimage_2 and _rimage_3, as those were the ones that were *not* on the=20
failed PV) to get access to the indivdual RAID SubLVs. I then used "dd=20
if=3D/dev/vg_ssds_0/host-home_rimage_0 of=3D/mnt/space/rimage_0" to copy th=
e=20
data to a file on a filesystem with enough space. I repeated this with 2=20
and 3 as well. I then used losetup to access /mnt/space/rimage_0 as=20
/dev/loop0, rimage_2 as loop2, and rimage_3 as loop3.

Now I wanted to use mdadm to "build" the RAID in the "array that doesn't=20
have per-device metadata (superblocks)" case:

# mdadm --build /dev/md0 -n 4 -c 128 -l 5 --assume-clean --readonly=20
/dev/loop0 missing /dev/loop2 /dev/loop3

However, this failed with "mdadm: Raid level 5 not permitted with --build".

("-c 128" was the chunk size used when creating the lvmraid, "-n 4" and=20
"-l 5" refer to the number of devices and the raid level)

I then read the man page about the "superblocks", and found out that the=20
"1.0" style of RAID metadata (selected with an mdadm "-e 1.0" option)=20
places a superblock at the end of the device. Some experimenting on=20
unused devices showed that the size used for actual data was the size of=20
the block device minus 144 KiB (possibly 144 KiB =3D 128 KiB (chunksize) +=
=20
8 KiB (size of superblock) + 8 KiB (size of bitmap). So I added 147456=20
zero bytes at the end of each file:

# for i in 0 2 3; do head -c 147456 /dev/zero >> /mnt/space/rimage_$i; done

After detaching and re-attaching the loop devices, I ran

# mdadm --create /dev/md0 -n 4 -c 128 -l 5 -e 1.0 --assume-clean=20
/dev/loop0 missing /dev/loop2 /dev/loop3

(substituting "missing" in the place where the missing RAID SubLV would=20
have been)

And, voil=C3=A0: /dev/md0 was perfectly readable, fsck showed no errors, an=
d=20
it could be mounted correctly, with all data intact.



Kind regards

--=20
Andreas Trottmann
Werft22 AG
Tel    +41 (0)56 210 91 32
Fax    +41 (0)56 210 91 34
Mobile +41 (0)79 229 88 55

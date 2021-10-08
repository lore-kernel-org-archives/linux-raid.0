Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EA30C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 19:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FAE960F4B
	for <linux-raid@archiver.kernel.org>; Fri,  8 Oct 2021 19:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbhJHT7O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 8 Oct 2021 15:59:14 -0400
Received: from mail-gv0che01on2095.outbound.protection.outlook.com ([40.107.23.95]:23649
        "EHLO CHE01-GV0-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231589AbhJHT7O (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 8 Oct 2021 15:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wtSem9rLpR9vXgcn2jdVaKDYdgA6r6BUIpHNYq/bVQ=;
 b=bRCQ6+oZxB00/41jxcHbCinINod7o+W7wWioVtPfLFFVlZh5DaHHLkl4A7hTohHvw3JJp7nU0hBMNeL+YYtut7fjTUs2aonB5TpaMXqmZ7bwLIhGtrkq42OWWsaGCJnuQt3pXZ7ZJj30uVZsHn9lkF1RLgjO6HGNTEV/tnMcZ8c=
Received: from AM6P194CA0031.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:90::44)
 by GV0P278MB0766.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:51::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 19:57:15 +0000
Received: from VE1EUR02FT045.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:209:90:cafe::36) by AM6P194CA0031.outlook.office365.com
 (2603:10a6:209:90::44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18 via Frontend
 Transport; Fri, 8 Oct 2021 19:57:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 104.40.229.156)
 smtp.mailfrom=werft22.com; vger.kernel.org; dkim=pass (signature was
 verified) header.d=nanoo.onmicrosoft.com;vger.kernel.org; dmarc=bestguesspass
 action=none header.from=werft22.com;
Received-SPF: Pass (protection.outlook.com: domain of werft22.com designates
 104.40.229.156 as permitted sender) receiver=protection.outlook.com;
 client-ip=104.40.229.156; helo=eu1.smtp.exclaimer.net;
Received: from eu1.smtp.exclaimer.net (104.40.229.156) by
 VE1EUR02FT045.mail.protection.outlook.com (10.152.12.192) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4587.18 via Frontend Transport; Fri, 8 Oct 2021 19:57:14 +0000
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (104.47.22.43)
         by eu1.smtp.exclaimer.net (104.40.229.156) with Exclaimer Signature Manager
         ESMTP Proxy eu1.smtp.exclaimer.net (tlsversion=TLS12,
         tlscipher=TLS_ECDHE_WITH_AES256_SHA384); Fri, 8 Oct 2021 19:57:14 +0000
X-ExclaimerHostedSignatures-MessageProcessed: true
X-ExclaimerProxyLatency: 7014329
X-ExclaimerImprintLatency: 352957
X-ExclaimerImprintAction: c7d51760ba0542aa803c6b908ea3af6a
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mtT2OSnn+dSPjlTjh0NrZ5eS3nKUYInMr94jiCXfvQ92nBFsRbiw+fdj9Q1AUD2XUMKFwHd07dCb0iyLeDWp1gfs3KGShvRTlrlcUfIcQOwJM8wFCAfoqWwGYSX3FGx6jF92H6jVUe+TJY85ot10YxSa77gGEWiKwEE149ti26UYxjU5HNEPm5bJMwYjy7I3yCy/UQiWHOOjbdkn2nxFYnlfMjnPGklcuqHg8jGzUajaBeIb+RktAXdKeGqW+0/aUTSEssgWzvq4K1wOMwNFXsyaMia9Y4IsH8ul5vgSeyOB1VsKRFn5kG5vmUmQX8v/Kmfnf2FybrRsLrFvuK4hog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4wtSem9rLpR9vXgcn2jdVaKDYdgA6r6BUIpHNYq/bVQ=;
 b=evWxosNDBFGTzKJiKWCgV/Cge3uvNBjuJSJ760SmXbU6Z1Si7/l3JzAm0CwLrsPCIt8/rPY3bnECcmfrbY6R3Xo7VlTgkW7rVbXs4K96EkgQPMqe0Qt+Xd8P6q4PngjEr1nOtYcXUkwQVXccPTfAN1jvLXpf+zohaWDuJBCujk73xQHUuomyJv69qEMv5yNW7VvIOEBFL3Yyu9XeTa8EZzl3pFk7nd6DGUldy9R4sfDJYhMtdUJf92r2VSGsHUIu8sSLfOFHok/L2oYy+7eGPrOmycArrkuKBvqI9tDnvSsC/3Opz8r9X1RJb8TJYGCNAF7N8SNb3CEA42/Vpl3xcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=werft22.com; dmarc=pass action=none header.from=werft22.com;
 dkim=pass header.d=werft22.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nanoo.onmicrosoft.com;
 s=selector2-nanoo-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4wtSem9rLpR9vXgcn2jdVaKDYdgA6r6BUIpHNYq/bVQ=;
 b=bRCQ6+oZxB00/41jxcHbCinINod7o+W7wWioVtPfLFFVlZh5DaHHLkl4A7hTohHvw3JJp7nU0hBMNeL+YYtut7fjTUs2aonB5TpaMXqmZ7bwLIhGtrkq42OWWsaGCJnuQt3pXZ7ZJj30uVZsHn9lkF1RLgjO6HGNTEV/tnMcZ8c=
Authentication-Results-Original: vger.kernel.org; dkim=none (message not
 signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=werft22.com;
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:2e::5) by
 ZR0P278MB0539.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:3a::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.18; Fri, 8 Oct 2021 19:57:12 +0000
Received: from ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942]) by ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 ([fe80::8d27:f211:395a:f942%6]) with mapi id 15.20.4587.022; Fri, 8 Oct 2021
 19:57:11 +0000
To:     linux-raid@vger.kernel.org
From:   Andreas Trottmann <andreas.trottmann@werft22.com>
Subject: "md/raid:mdX: cannot start dirty degraded array."
Message-ID: <8b0a13e1-0972-be41-d234-2202abe1a54c@werft22.com>
Date:   Fri, 8 Oct 2021 21:57:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-CH
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::14) To ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:2e::5)
MIME-Version: 1.0
Received: from [195.234.163.98] (195.234.163.98) by ZR0P278CA0027.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Fri, 8 Oct 2021 19:57:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95dcba2a-c7a0-4c5d-08ce-08d98a95d327
X-MS-TrafficTypeDiagnostic: ZR0P278MB0539:|GV0P278MB0766:
X-Microsoft-Antispam-PRVS: <GV0P278MB07666CB6711A4B6D4EA2D0FAE2B29@GV0P278MB0766.CHEP278.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: =?utf-8?B?RDJWVDVQRnVyeVBlSEV3Y05RODVWU3BBRU1CTysreFJVTE13OUxJTTlGc3A1?=
 =?utf-8?B?ZEEvclQ5NVVMck1IZitWY3I5cDRmalU4Y2pjdGNHRmZMQjlqZUQrNUVReW9n?=
 =?utf-8?B?R3NJbld1MFR2S2xWbmh3a29GNGNCR29ib3ozT0pFd2hIQlNPcXk2ajJpVGRU?=
 =?utf-8?B?YlVnbjlCZFlaV3NuQzM5WU00VUFHakk1dTBBeVIrcW1uWnNJTkpaR3pkb0h2?=
 =?utf-8?B?ZkI1T3hlVXF5MlhwckpMRm12QU1mdlRYSlBlakNuTE1nZUZQSUZibE4zM2tX?=
 =?utf-8?B?elFWU2wyMUpmWkt5MHJUVlovTngwRFQ3SG1hcllBUGhTWmU3WGpqRTVHd2VU?=
 =?utf-8?B?cHlrWW9UWm1rYTNGc1dneStDR3ZMZjZoQWV5ZUc1V2N1WEFpWmlOTkpOcndX?=
 =?utf-8?B?V3huU3VlQzFoUVVSRzhxa2txSEt5YUdoNnFOKytZVDNhb252WTFqbWhxWTJ2?=
 =?utf-8?B?Mk9pRGFvNE40M1llTysxd1BPck13clBBekZ6VkJQRHF3NFBRN3kzQ2U0WFd4?=
 =?utf-8?B?K0ZmbHM4S2E1Nnp1dlltTmdFbDhmQnZwWnhSVHhHWXNCMUhvQmNlU3BjVFYr?=
 =?utf-8?B?cDVvVjZHWG9HYitidCsyM1hoTmFwRUduMWtERzl0Z3JVQXkvem9OOHVxZmox?=
 =?utf-8?B?UTVhcTFtdlNKQ3IyZ3NqQy9RM0VCaE9yV1hHSlhVNytrUlFPeVFtWWV4VEhs?=
 =?utf-8?B?RmROclZIYTQvc3FGSnR6WnZad1htUGh2czRlQ3lHS0VSVVE3a2Z2UjJBR2Vv?=
 =?utf-8?B?MWVnQWYyWER6MSs3bEpoaDc4eWJIVVY4M3l4eDVXUWozMFBBVEJremFkamIr?=
 =?utf-8?B?WWdwTE9aMXRYdmFxaEcrZXZtWmxzRHN2STl1cVVVM2dXUFpxLzZmY0Y2Ympj?=
 =?utf-8?B?VWs5U3NXQU1nTE5xTzNiWWdUck9QRVpsYnc1OTlmUEpNN1U5cVFEZXg4QXRy?=
 =?utf-8?B?VVF1Y2FFb0o0OXNiRHBNcFcvbEg0OElZV05tQWxhOUIyME8vVG5qRERYUit5?=
 =?utf-8?B?SnVNN3FNYi91UnRzT0VNcERjOVN0NzFGaE02NXZDaGhXQXEvWHBTWWNadEhJ?=
 =?utf-8?B?eWRTUmVoM2E1MCtqNUV2THhqTVlKbzdVWm4zZ0FMemdGNWI0SXlDK251UW5v?=
 =?utf-8?B?cFlzMC9EaDhnS1NRYnZadDJOcHg1b3ZSZmpqL3ZOblhDQ3pGbENyT0p6WHpx?=
 =?utf-8?B?QXRQeHM2MVVrZGRDK2liU1A0OThuWWc3eVR5UjRpVVJ1Q0dlRlU4VlF0eWMv?=
 =?utf-8?B?OWx1bnkwTHBrZDZUMEdLc01QdVNXVHRBZnNCdkFCTWtCWHh6QT09?=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:ZRAP278MB0397.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(39830400003)(396003)(366004)(31696002)(16799955002)(86362001)(36756003)(38100700002)(38350700002)(31686004)(8676002)(186003)(26005)(5660300002)(52116002)(6486002)(6916009)(6706004)(66946007)(956004)(66476007)(66556008)(19627235002)(8936002)(966005)(44832011)(2906002)(508600001)(16576012)(83380400001)(2616005)(316002)(222603001)(3940600001)(14143004)(45980500001)(43740500002)(505234007);DIR:OUT;SFP:1102;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0539
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR02FT045.eop-EUR02.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 3d45867c-d350-4764-3cf1-08d98a95d164
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BIOtAb25APiJvrlpkeAjVDpscF49N+P1HWiHbvkit848zy01UBPk1TWYjxXsRvdfE+Y8S3hVVw/946vxoG30R00gdOQ2W2CfVNuIsn2fdDg5cKD+1BA5kpCB6pV4n0+9D1AQiY8QWdTUU9prlMSuCxXIP0IzeXFp83SSY9Fiz6nNisVbyXfvgL/E5ytvYnDKWCCXXYbaJo8Gb6VEKMtzLjsCh9ok6X7VLAkxzk2orqYyhI6Qs/m9FzSemnidIaKKa4gywAyT5+TtEuwq7qqTO5/1RpCPtKHcyGPDEN5C/XD3P0MJqyKlmE2SfJBSSqGMe+onqyOzoBgOnj+O1hdi74/4YOO1rNeSgJFTR45qiw1yRvTNAm57ebPr6aiGkUgnwhHJdpDHwQpq6dV5/5wOPYiNBfKq1NZBmA3HzSpiMRhdXy6ag7y0oNIH6DwXTF/UalUZ3R8HznTrW2GTQL2H5z3nd6dkp9QDWRXBGE+SefkLLCbMg3pAvVwgeyHQXNDaI9vN4p1t67mAwCv7Ta1W7C4tkTcET/WvBwUxUkXOz2nVZNWRbPknOAf0wnupgCLtZdxpL9jzCr2w/grBWGT/Kr7OrcN62rRUCRYqHH3AdfuJByN1EVXoNj8VPT0FCw6XLZgOLbtF1GrSv6eGsvXUYZj2sbT0gEJD/X8Lmg8T3dosNfnhS/xrMzydn/4PgUNyqfv/UmBetAY0GJ62grLThDaukLWvWHB7lT44D6fY1SlEZPvP7iT2DaY2PFU25oADj94SYOGUfvEvLCkRF4azqPh1wjLMRSsOH6Uxwf9GZq+RKDDl/JyTEtCw01mh8P9BXsU1H6AcHpN+K9N4GM+Hohx6xfZjDYHLEQNN3Bt5bDW7N6AOsUb+LfTRa6izag5HIEPp+snBsct6TFzYUHspsvvYaxo6UtFdi78JOO37JuI=
X-Forefront-Antispam-Report: CIP:104.40.229.156;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:eu1.smtp.exclaimer.net;PTR:eu1.smtp.exclaimer.net;CAT:NONE;SFS:(39830400003)(376002)(136003)(346002)(396003)(36840700001)(46966006)(2616005)(956004)(44832011)(47076005)(336012)(31696002)(186003)(8936002)(86362001)(7636003)(16799955002)(2906002)(82310400003)(356005)(8676002)(7596003)(26005)(6486002)(19627235002)(31686004)(5660300002)(36860700001)(16576012)(6706004)(6916009)(83380400001)(70586007)(966005)(36756003)(316002)(70206006)(508600001)(222603001)(3940600001)(14143004)(43740500002)(505234007);DIR:OUT;SFP:1102;
X-OriginatorOrg: werft22.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2021 19:57:14.5037
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dcba2a-c7a0-4c5d-08ce-08d98a95d327
X-MS-Exchange-CrossTenant-Id: 28eff738-e52c-4df8-9f47-73928389e1b3
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=28eff738-e52c-4df8-9f47-73928389e1b3;Ip=[104.40.229.156];Helo=[eu1.smtp.exclaimer.net]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR02FT045.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV0P278MB0766
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello linux-raid

I am running a server that runs a number of virtual machines and manages 
their virtual disks as logical volumes using lvmraid (so: indivdual SSDs 
are used as PVs for LVM; the LVs are using RAID to create redundancy and 
are created with commands such as "lvcreate --type raid5 --stripes 4 
--stripesize 128 ...")

The server is running Debian 10 "buster" with latest updates and its 
stock kernel: Linux (hostname) 4.19.0-17-amd64 #1 SMP Debian 4.19.194-3 
(2021-07-18) x86_64 GNU/Linux


Recently, the server had one of its SSDs serving as a PV fail.

After a restart, all of the logical volumes came back, except one.

As far as I remember, there were NO raid operations (resync, reshape or 
the like) going on when the SSD failed.


The volume in question consists of four stripes and uses raid5.


When I'm trying to activate it, I get:

# lvchange -a y /dev/vg_ssds_0/host-home
   Couldn't find device with uuid 8iz0p5-vh1c-kaxK-cTRC-1ryd-eQd1-wX1Yq9.
   device-mapper: reload ioctl on  (253:245) failed: Input/output error


dmesg shows:

device-mapper: raid: Failed to read superblock of device at position 1
md/raid:mdX: not clean -- starting background reconstruction
md/raid:mdX: device dm-50 operational as raid disk 0
md/raid:mdX: device dm-168 operational as raid disk 2
md/raid:mdX: device dm-230 operational as raid disk 3
md/raid:mdX: cannot start dirty degraded array.
md/raid:mdX: failed to run raid set.
md: pers->run() failed ...
device-mapper: table: 253:245: raid: Failed to run raid array
device-mapper: ioctl: error adding target to table


I can successfully activate and access three of the four _rmeta_X and 
_rimage_X LVs: _0, _2 and _3.

_rmeta_1 and _rimage_1 was on the failed SSD.

This makes me think that the data should be recoverable; three out of 
four RAID5 stripes should be enough.

I copied the entire data of all of the _rimage and _rmeta volumes onto a 
safe space.

The _rmeta ones look like this:

# od -t xC /dev/vg_ssds_0/host-home_rmeta_0
0000000 44 6d 52 64 01 00 00 00 04 00 00 00 00 00 00 00
0000020 ce 0b 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0000040 ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
0000060 05 00 00 00 02 00 00 00 00 01 00 00 00 00 00 00
0000100 ff ff ff ff ff ff ff ff 05 00 00 00 02 00 00 00
0000120 00 01 00 00 00 00 00 00 00 00 00 cb 01 00 00 00
0000140 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
0000160 00 00 00 80 00 00 00 00 00 00 00 00 00 00 00 00
0000200 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
0010000 62 69 74 6d 04 00 00 00 00 00 00 00 00 00 00 00
0010020 00 00 00 00 00 00 00 00 ce 0b 00 00 00 00 00 00
0010040 ce 0b 00 00 00 00 00 00 00 00 00 99 00 00 00 00
0010060 00 00 00 00 00 00 20 00 05 00 00 00 00 00 00 00
0010100 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
*
20000000

the only difference of _rmeta_2 and _rmeta_3 to _rmeta_0 is a "2" and a 
"3", respectively, on offset 12; this should be "array_position" and it 
makes sense to me that _rmeta_0 contains 0, _rmeta_2 contains 2 and 
_rmeta_3 contains 3.

I googled for the error message "md/raid:mdX: not clean -- starting 
background", and found 
https://forums.opensuse.org/showthread.php/497294-LVM-RAID5-broken-after-sata-link-error

In the case described there, the "failed_devices" field was not zero, 
and zeroing it out using a hex editor made "vgchange -a y" do the right 
thing again. However, in my _rmetas, it looks like the "failed_devices" 
fields are already all zero:

44 6D 52 64               magic
01 00 00 00               compat_features FEATURE_FLAG_SUPPORTS_V190
04 00 00 00               num_devices
00 00 00 00               array_position
CE 0B 00 00  00 00 00 00  events
00 00 00 00  00 00 00 00  failed_devices (none)
FF FF FF FF  FF FF FF FF  disk_recovery_offset
FF FF FF FF  FF FF FF FF  array_resync_offset
05 00 00 00               level
02 00 00 00               layout
00 01 00 00               stripe_sectors
00 00 00 00               flags
FF FF FF FF  FF FF FF FF  reshape_position
05 00 00 00               new_level
02 00 00 00               new_layout
00 01 00 00               new_strip_sectors
00 00 00 00               delta_disks
00 00 00 CB  01 00 00 00  array_sectors (0x01CB000000)
00 00 00 00  00 00 00 00  data_offset
00 00 00 00  00 00 00 00  new_data_offset
00 00 00 80  00 00 00 00  sectors
00 00 00 00  00 00 00 00  extended_failed_devices (none)
(...)                     (more zero bytes skipped)
00 00 00 00               incompat_features

This looks very fine to me; the "array sectors" value fits with the 
actual size of the array.


I was not able to find the meaning of the block starting at offset 
0x0010000 (62 69 74 6d; "bitm").


I now have two questions:

* is there anything I can do to those _rmeta blocks in order to make 
"vgchange -a y" work again?

* if not: I successfully copied the "_rimage_" into files. Is there 
anything magical that I can do with with losetup and mdadm to create a 
new /dev/md/... device that I can access to copy data from?



Thank you very much in advance and kind regards

-- 
Andreas Trottmann


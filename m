Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56988C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 03:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29D1061A83
	for <linux-raid@archiver.kernel.org>; Mon, 15 Nov 2021 03:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236759AbhKODfW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Nov 2021 22:35:22 -0500
Received: from mail-eopbgr1300090.outbound.protection.outlook.com ([40.107.130.90]:6160
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236772AbhKODe5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 14 Nov 2021 22:34:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhTtdLZ/OuAhDbB4DsIMtONPiLR0mUQ9+AQ3XIKCBSZ07t/vH8YwRPGZgrOpxiANE8vl3AMBb592KVFuIwXTMBakJDnonXIEeuX3whaHeSR6dxXF7yAj4u9ba8ACOONsUDXMTWR1+D1w1oBZtsSJqR9WloyADu8vizP+9yoKamc5Yq8A3DrMWRJEFJebekNC68UdVamCCWNTynzMpf0rfxcW4aRtbCLQACEiWYQpF5hA999+e9sRbDacE7upCJgzcnVJL90tHbsKBZ5lv28VLNTgY882tN9uYJ1+XFfGFypnzcCWBMzai7VwF6eBxvrOKCcBfwSd68pAcOS6t2EZlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MyXfonDXBJGV3nyVRMSpE7VjYSjNK5OVSTjVrNaCrrI=;
 b=hxuguN1iWrwMHw03FJE7+TurjcdMOcsuNYxRh4Cpzj7XH8kHnpshoiBbXEQLeOkPVm/Yx8usOtUq6hNlPDVqbdZjzQAWXP+5GLZAkJqk3xsAqs9uqP6xUBqOqsSo3hEyaw3vJaxznnUhSoGlsOXQmT5rGqPYMtRLfuwHb86RHYoxEm5zBfViLNRxGv9nzUrpdsYdjJLDJRQnYDw3PKkmI9GR1Actg2REO27UTNrDdfgdnwxRgLWir11WMwOKoEZfJ4Nt0Vo8WdJs7NiakClQPxCE8Dg4VgwpcEJ3zvKKtoQ1cnMPBqdYmymmrg7mgv2eMvs2vKtsc5WgqUMIIG8b4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MyXfonDXBJGV3nyVRMSpE7VjYSjNK5OVSTjVrNaCrrI=;
 b=mpzxp0/AK8ZzhdT8O3v/+d7uVqPGi/JTPBA5zzn28ghoucUXxdSwQIAduClkF3Ghgg4xGXBX2hUUrKWkt+zJi0NyYbuBnpAFxmK/0Yf99Gj+aueQub1PYUN9ZE9Dd/PH+5A8+bOUR5GKG95iA8pthvOAwFmA7ARRVR8nyrZh0dc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com (2603:1096:301:37::11)
 by PS2PR06MB2503.apcprd06.prod.outlook.com (2603:1096:300:46::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.20; Mon, 15 Nov
 2021 03:32:00 +0000
Received: from PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385]) by PSAPR06MB4021.apcprd06.prod.outlook.com
 ([fe80::395a:f2d7:d67f:b385%5]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 03:32:00 +0000
From:   Bernard Zhao <bernard@vivo.com>
To:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bernard Zhao <bernard@vivo.com>
Subject: [PATCH] drivers/md: replace bitmap_destroy to md_bitmap_destroy
Date:   Sun, 14 Nov 2021 19:31:48 -0800
Message-Id: <20211115033149.4583-1-bernard@vivo.com>
X-Mailer: git-send-email 2.33.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HK2PR04CA0075.apcprd04.prod.outlook.com
 (2603:1096:202:15::19) To PSAPR06MB4021.apcprd06.prod.outlook.com
 (2603:1096:301:37::11)
MIME-Version: 1.0
Received: from ubuntu.localdomain (218.213.202.190) by HK2PR04CA0075.apcprd04.prod.outlook.com (2603:1096:202:15::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend Transport; Mon, 15 Nov 2021 03:31:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 68a7401c-2cfe-4a19-a889-08d9a7e87bd3
X-MS-TrafficTypeDiagnostic: PS2PR06MB2503:
X-Microsoft-Antispam-PRVS: <PS2PR06MB2503DBBF4A9F270555FF7491DF989@PS2PR06MB2503.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:758;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6PEA/ackjmj8VznLZChBLgmU7hOZwUrP5pvvp2aRBLrDOPeVP8EHd3aq6BhWm90d3ENn2lEcrXQUqDeAzR4zbF7DE2RrFk39MqnGfnU/8CInGYzgeJkiP8b2Yx/FbwQ54W/QXkre4+xloXRy+4J7xrx3IWhRE6nuI6PyznMfDQfmiDUO/FkmjkMcfhBV4G+odT39R6J1jclclLNCfGIOb18Is5KEVbY/iSOgXBxvOL1bgH1AmmiXvUSDtCOPFzSwaoclx8+sMrJaX7ZrT4ic5Cgxvk2lvMDaD5GfSEn27f/1EOnD8ZcJdpbDQg0EukdcuQSKBaL3CuQ9dbxey8Alzru8tGUHy62hl4TqifyKCR6J/NUsFniNE4k9u7WRuztFDH2aD2UqiWOk/D63CXLsFVHO+gcfoz6Sz78UdzoV7uIQiY3WN0aEhGxSO1udRkjFcLjowm1B0mZvEPsyRPFQGLsRZbAe40AQpsItY1pP3mjkEOMgdLyA1AkvpqTdh9WrAhsVV/9Hyr3SEQ/o3bzXJ4WSAO5GTSNPpzZJ1go7e6ZMKbHLJ96QUHZ72ptQpYRQfKylEayFNjB+xJnsSRTN+efcdIFLSTYiAV8JlKql8D1jMqZ/rP58fws65h81hEBYl2qUbWzLUYOenWx/3qSGPuFs8potz5egc+tYJJUGAQbyfuuGWibHKK9jM8+qoirnFMCu/F9SAwpP4pq9W6BpUg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR06MB4021.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(52116002)(4744005)(5660300002)(36756003)(86362001)(1076003)(956004)(83380400001)(8936002)(26005)(2616005)(107886003)(6506007)(66946007)(186003)(316002)(6666004)(8676002)(66476007)(66556008)(2906002)(6486002)(38100700002)(6512007)(4326008)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W81iZnKQONKLlwxE+/55IkVyz63VdW+NIa+ufxKE3zgr0nDpUJ/c9RJb8nTr?=
 =?us-ascii?Q?aouruL+dor+GTa+DhRch1mzvxhCYflwtfsAZqrz0CysSSoO2Y4h5+iGXVVEa?=
 =?us-ascii?Q?SBjNbyTCbvgrU2StmLASgvcNt4QYFMHKAkvpo/UnvMiCkdAhL4LdZSvZQE+7?=
 =?us-ascii?Q?TCXCuds9+1JbLAh1RWim6Fde2Blw2xsGwb0/zM6LhailKVsw6L/LuliW1R/v?=
 =?us-ascii?Q?JvJs21SqNU82do1njPsEWiFY7VgQgd63f1FlQo4b2I2Ow8B67E3mGj/i369r?=
 =?us-ascii?Q?NsUNGg1Sa9H5ngRBHJGgAtUdui6eXFibO/zCMm/lWvwWkAFnFwIEybFyL2QA?=
 =?us-ascii?Q?ApqozHLjLjgdfJp4eZvBVJz+AkbcD+waOq9gtK1GkF9DNObRhnKelBuKs3Km?=
 =?us-ascii?Q?KZE060xGvOUHwNLhsJt469ui9XB6AHnJcl7Q+XVMHwVvdG5Yo92dhWBeyLIy?=
 =?us-ascii?Q?7fwC1EPSDrmEO4t9V+RBCR1fSNCMcYbj3XLOxK7JllKss+MaKrxbGcjImw6f?=
 =?us-ascii?Q?MLeZOS6iqxm5Ftk/SzXgP/Yg7DTLS8ziRcXHrWoPqNNfNSBIa0xT2leSxIYR?=
 =?us-ascii?Q?h+CSzXnhgr0t541QPC+f8KQERuHyo6Qk7oLtoudSZ9sMoRumIgD/sh/QiNAY?=
 =?us-ascii?Q?PQwy8k+T7wLQUYGnRM8ty9Pj59q5sHHIpkercFHD13GsicUMEcAkLHZIlc85?=
 =?us-ascii?Q?fdKShPBYM6FnTs3hEQrtokQp4XW3HwsFssH7fJEo7SNF86ODueClc/pxMazt?=
 =?us-ascii?Q?Hz6+xjfWGqxafJtBMTpN3QdsnhPy3x3u1p01iSGyYdZc2CeOt2c02OWUhDkm?=
 =?us-ascii?Q?0gAThT3iNm8XGQ9XMP6XV0TM35zaIbDAWVbBaNNkEjjXNCAI4o3HHwX2vKgq?=
 =?us-ascii?Q?4SkwlQxdEclTU4aHs5D2usaRzOSS5NWw/WCKk3Bs//XscNUdoKO7szKYXB7H?=
 =?us-ascii?Q?8Ej6HuVePELMOudK4rikNfHJ2hC0vKJbmLaZtFOUYD+n55fMEK/Sw5qfmQGz?=
 =?us-ascii?Q?izf4V4wgVic0Gl+X8gdamWvH8es/8ZvlFjZxNkHZ4WmpHhvsdN3SBn++jMZF?=
 =?us-ascii?Q?4v76FSQf59pJeOWe9HnqN7bQ5GXtDwf2EtCHf0mBxVKXorJDpzx6JYaKZ1T4?=
 =?us-ascii?Q?dnakSYPa0nxES3+HlI//dgiO00N89y4Fr44/7YWDHvOmdA1+WdqFkE3oF0mM?=
 =?us-ascii?Q?5nR/3JBOvCoYKlb4FoR6FxXrSanL2Q7JHCb6zxAgx8IxWbTgrh9XNH1qclH0?=
 =?us-ascii?Q?kT4f9C+T1wZM5/aFOOLFCYahp6DOSwlBLFxeLCf3xBITYpzqyP6Sgktzvxt7?=
 =?us-ascii?Q?VAHvxn/Ihqc50bKTFUUPR1LTHdnla6ADwJGnwK1va80vYRLH+CZP2tzVrlGW?=
 =?us-ascii?Q?XQoOkQqiKdg8jGbrBpusqpcsUIRCBJjbVhKeeoQhjwpYRrwxoGPfX5BZnSRa?=
 =?us-ascii?Q?qPFR64qcuI3J85FSrk4Ojr/+BL+BCDiU37IcLcTOc+GJOyLZ8bZ0M+L+pJbH?=
 =?us-ascii?Q?QZ8l14ovy8pCZVQqrWvcHOmsCi2UgeDAsmIOjb+TJ4dtrzObtgylLhUCGaVR?=
 =?us-ascii?Q?xEJYEYNk5dJeeNlCD0RZi+gYibVZ0c6GcZ1OoWxxANzwaTcQWA3UK0J2TYIx?=
 =?us-ascii?Q?DzLFUIQbfEqym9UnCJ8KuQw=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68a7401c-2cfe-4a19-a889-08d9a7e87bd3
X-MS-Exchange-CrossTenant-AuthSource: PSAPR06MB4021.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 03:32:00.3098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EQyB8keEeVoLOo+LHacCttJV/0YuVXMzfag7RupbOORKrL1uoXtVgZaFD9MHxmKnPeZ51Yva9qsJFIdmUZmtyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB2503
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is no bitmap_destroy function, the right function is
md_bitmap_destroy.

Signed-off-by: Bernard Zhao <bernard@vivo.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..4a6199a28294 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1804,7 +1804,7 @@ void md_bitmap_destroy(struct mddev *mddev)
 
 /*
  * initialize the bitmap structure
- * if this returns an error, bitmap_destroy must be called to do clean up
+ * if this returns an error, md_bitmap_destroy must be called to do clean up
  * once mddev->bitmap is set
  */
 struct bitmap *md_bitmap_create(struct mddev *mddev, int slot)
-- 
2.33.1


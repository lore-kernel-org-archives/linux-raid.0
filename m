Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1932FC63797
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:28:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE0A160720
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhGVRsH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:48:07 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:25808 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhGVRsG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:48:06 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIHZ7a032168;
        Thu, 22 Jul 2021 18:28:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=NeTBhjaPApJuuzYCjjGdWFH4+R9aikL3FtVb4yhaJbM=;
 b=gmqDEQ7J2Qacsh2psLwlOxb5nkj7lrQQq/vB8KIuKUx8GFXcdfCk4ZaCVpULMf/h24UO
 1TWdhkMthfPDexqiL7UxSwZjQz8QngRjTVQ9QaBFX6Iolzshx+kV/zycHV7h79UzZ8lB
 mh8CMNrZzHVlFbeJruGBtoji8eWLDgSuEBXu5qst27Pk1X6b5eDhj56yCqTM5+HuQMa9
 hvUPz788lLaJmBtGqSTZ6wS4XBbOpwjx379LEdSfD5X79Oe71AGq4mZZzhyE6s2PLLTt
 t3CBFv6bCYq61Orr1obtbj1RV8MtW2EfBfoQo75TCbSz5em3cjAXJrL7/8HlhDjSUiXo 2A== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=NeTBhjaPApJuuzYCjjGdWFH4+R9aikL3FtVb4yhaJbM=;
 b=wVoMk+2zuXR/3O5/O+bxbEz/j+QkTvP4tvtxZ9gDIIWKS0yEE7eW4UdpOvOepJI63n2P
 2XniE+82uNuoRCyA77xo78/Ip0kPheclln54Zvor6rm34gkjUmmPDnLbQPuCfDQ9jssV
 2CJoxKrl/ynGtJSgiiWlL4jKJzX5PippSBYcErSJ1RzlZf9ENxfcoAJ8LlIsyDlePvoQ
 qjMxmuefML6lfo+3ind+Ps0jKQzVNBhO1Xnz+/FJQaLh76Sm3ExRl51D6yFdjg4JdhNu
 yMyMDK8HRVPtuS3A3/93cdHxUva7yPa5dPNQAKv87AKYXeMdbxf/6QRGOXDdAVprTe// WA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y04dsv9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:28:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFGaB167847;
        Thu, 22 Jul 2021 18:28:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2046.outbound.protection.outlook.com [104.47.57.46])
        by aserp3020.oracle.com with ESMTP id 39uq1bpwwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:28:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JnbE+syB2UQdXemmWqIjd8mTzLyV7XO0wU601pUGG3CJlgbtBuFKOLCbjNv1f2O1fwGQ5sy5Tca0+mpaLta5bCUf7dYX6YTdFoB6nKRFdaMYCxVDHaKkmX9wHwLAD31nWkH19iI5LCMqMPUa//AMjHOfwPRUVd4RAEpZgn1UsZRgrJcBJ4ochYFpRMxVI8TLdnOadZXrfoGxWZi7sGH1+kEgAxFF7cDgu71wa7meZVErAJZF/ixpTLwfP+1OdcOr4b+J6rxo1i5CK5ZIEMaClXTUvKxm0rKjNumfaW7RQRvTKDQYaaAId2R4wQikTqPiMocfKZOxcjBIKd2Ni2CTtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeTBhjaPApJuuzYCjjGdWFH4+R9aikL3FtVb4yhaJbM=;
 b=cQb635CSUcOTk2EitAfPHeQhhgNbfFwGUUE1/Bw6vpznTweoj5JI0ol1PkKZ380G+JVTVz2uHDNcana+oetJIAvgCw+ShHLoYbj2RsoPT7dRAoJg+oHuZyi/vviW49zzmpHVvHnSa1pp6U7Thql1LFccn9UJzXINnWYGQiC3SQoPdsywKCafw4KMpDl8y1LaVkpAtBQVFf0xBpwrjv56jycnGothkD8ffSESYHBvm8/tN1bKgPRmDYoTNP4QcswESM4YBSS+1rkubgJdjKOGaGR1KF6BRTAp2OaBfS9R1XQj+l3NoAQACagzeQMlGVfvYEbz5h17f8qqlHVGx8VTdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeTBhjaPApJuuzYCjjGdWFH4+R9aikL3FtVb4yhaJbM=;
 b=hoVFm7yLRy0Ysmhc4nc+8/rRIl3PceLDGhVT2QBxOklwAKBqpe2/Ha4/VQMS+ZNzpPuFY6T1W8q8nlNpAnJfFaLW7m9AiJUsScUruyWq7lFQCbhbLNoPnPY+XwiOVFfhOULyruhVof+uykloNhs1p0MeAVwfgIMZ7nN/IzKnXQU=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 18:28:37 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:28:37 +0000
Date:   Thu, 22 Jul 2021 18:28:34 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/5] Assemble: skip devices that don't match uuid instead of
 aborting the assembly.
Message-ID: <20210722182834.GA25244@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN2PR01CA0030.prod.exchangelabs.com (2603:10b6:804:2::40)
 To CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by SN2PR01CA0030.prod.exchangelabs.com (2603:10b6:804:2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 18:28:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 825d1163-4ff2-48aa-fb8c-08d94d3e8567
X-MS-TrafficTypeDiagnostic: CY4PR10MB1381:
X-Microsoft-Antispam-PRVS: <CY4PR10MB13810E3FA4ADCB92947A8177FDE49@CY4PR10MB1381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9X8bfv3Z0FsJPzZ0lHrlt/fsIR+NYnXxfGtTo7mND9nBAB8Je8bgAmWpNqg3zMW9qpdIJH/hxYZROQipCXML/UjNnuWm0pxmZrMCpk3nAQ8Zs/A6lLceSfhVaiP5utrQBK4os4N9/UvecE0ri7qzYUWLBiyfyZtSTlZUATpD3R8bUHDiafIbkQ//89YwmzzuurclxeGlcJcY0I57XJpJQwL/+uaWPWVXxZYrV287odYb/W6oRrWrUc/XOMpmtlgwg58Fw4dLpaBOkqO4AkkjGWt2He1nOXv6pB7WxqFBmZO28YgMj02Oe98cRD1CcKLC2eBhI32hxkDy6p9sa8kAgrob5GXcEwI0dQ7B/l6CuiuYJ2REXLeQ5lPohFD8+bO5KRSKemeRm4UW7rPF/bS2hWu6+EuB1oGNBU2/UqX4swhZsiJ7rg3o2Q//p7POhUPr3mCCaR0iRlL1gqUU+5g+Y8ie8xCnRkLZ9u3nm5LJQ4QEvVrerXHInADrrBxU3+oMAd52SbmmfUzwz1N6Gz73fJN2QjhEhDJh8Fx//Ai2UTGyjqoExNQ7bVeZV/IwWEz7rPXJFA9v6OrjjF6ZMPjUsNZ6aWZ5zwjbDx0qd2alMa44DGYsICp897uAD5xcJj5dn1boAGp6n+QU/HpNsf6dCLaRXMlSzcFaMOtpCjKfJTURRf7+XEJpOc2BgalOlSCdDxcEd/WnDAZ5EEUXAKjkuw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66556008)(33656002)(7696005)(956004)(8676002)(4326008)(55016002)(52116002)(66946007)(66476007)(316002)(86362001)(2616005)(2906002)(5660300002)(1076003)(186003)(44832011)(38100700002)(508600001)(6916009)(26005)(8886007)(38350700002)(36756003)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3U+l+iZMUZTuBfhCQAJR3PFSo1WdI7M4LHsPI1LVdC2TcX3iiz9MNHmxepVT?=
 =?us-ascii?Q?6n8Agl/zvwW2zMwnx1KPpOhENZ9mFfQkYGXJYbVD1+ZDpzBRc8heomo7Llvb?=
 =?us-ascii?Q?6AE8J4hhfczm+UXx2N8cuUoEW/NsEY9I70pHIVW2dkXwS9WBFCo25UqvyRhF?=
 =?us-ascii?Q?2fModUHyyXxfT53i7WjHFACGNuk3tSe1gd3BQTBpsGMaPZMdKBDvFuri2606?=
 =?us-ascii?Q?x0eIsqGrkT/emNIF1TAX/XxnOkrapuAM3jEJ0/B4mureIKSKY/5+RJNf0TdL?=
 =?us-ascii?Q?x1k2e6762eRGiJVpwQYAOPz76XQO94mgwkF1yzOyR6MtJZmi++oK3wJL28Yr?=
 =?us-ascii?Q?Sc2lF5AtqoC+SCCK2bLzqaJ0ERgjFExWQN4tD0qjaHjFMmiEuC6hXyiLmdGU?=
 =?us-ascii?Q?DxZmw1GN6nUpldvZuROMskWdHEsTR7/hdIiGXRQzexi8KcPoL1JTDwwZg0e3?=
 =?us-ascii?Q?qGY0nKbeq1FIWrGn1Z92IG9wp45DxpPd7kLsVZvd1c+LNPXHVFYNa/bU3kZd?=
 =?us-ascii?Q?/pX/0X4w6FuYdCLyWNbbkeee2toph8mHbgkX7NoKDxX2BYMmVbu9/YTBYoMo?=
 =?us-ascii?Q?JsyBrl7BAmKMHuCTd7e7S747KN//koOK3yiIOtYEX2CeIlOH2hDYnmBy6X4H?=
 =?us-ascii?Q?PuwumIpn4RxRRzYHYUTHa/IuO+MaEiuPe+wSQKLMKoWipvsWDAPHb6o5wegU?=
 =?us-ascii?Q?/ilDauD0BMIPEHQ49mVZVw5HuhIz1j6ccfu97LJnY8KAe2TlDLVoKBOmV2tV?=
 =?us-ascii?Q?zsFlwbwqu+22gk/5aLhhIFGb+sWA9M8WPA88ILi35/3AUcU8ooM5VP9dpwRN?=
 =?us-ascii?Q?J0JoJ5Yt4CvZpECsMP8NaLd2UVRdM289fYUgaBYAv3yXqsjx9c+b5Nn3MhT6?=
 =?us-ascii?Q?iBgA0mpzlFrzzSNsCtLXxw1TEXQEd5eER2Wg7z2tWHnKZco1rkROvo2+qHIN?=
 =?us-ascii?Q?jBX+l+L9esWeD6ODtCRZGheUzEPq7kcDLISAW4AKPGLcfbX7EQ5PUpY3oJSN?=
 =?us-ascii?Q?TEsvNMqIvj021PivT1JUjE1TKcDTycNl5FH/jjcoISUwXVKNhYDH2wl6EVoH?=
 =?us-ascii?Q?/oG4IgYMWDdhYRZLgXybIWYZwbz9ZMPiVGIAgfyMs2bNkSvvDE7QU6YmUNc3?=
 =?us-ascii?Q?c5sGqzw6Nca6nNGPmO2zId9KawaiG0/GJaRhEnRyAUwN11JMquBSxlHalqJl?=
 =?us-ascii?Q?/CV1g5A20mWvj/gXTjhYWHGMFJgVuzArmFs1KATigwUHZ71/pvGX2uY9lYel?=
 =?us-ascii?Q?xm67B5hDUjQqA6jZE7BCRWRTwVuMgpd3j5cL9ZzejCDdCpztWdCSeMNyG9E8?=
 =?us-ascii?Q?LE8NM9W63qhZHcYip+Y749ve?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 825d1163-4ff2-48aa-fb8c-08d94d3e8567
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:28:37.2280
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jbWFPVykeUhzdlgpP/f8GfRfOPkhy+/eWvC/HZUlQuD/q6Co8wK9TRAWGQN+LKDRsNV7HvcKc3tQfNtS6sx82OXIx74fsK/ZO3FMzxaJ8xtOg5fJKPZR3N+IWs6p6Sj6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220120
X-Proofpoint-GUID: DVax6MsOxTh8YvkZsE3HqdhO8iQgX2ZS
X-Proofpoint-ORIG-GUID: DVax6MsOxTh8YvkZsE3HqdhO8iQgX2ZS
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This fixes '03r0assem' test as assembly fails when looking for specific
uuid among the device list.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 Assemble.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Assemble.c b/Assemble.c
index 5c6aca9253ac..b46891c0ddaa 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -274,6 +274,11 @@ static int select_devices(struct mddev_dev *devlist,
 				/* Ignore unrecognised device if looking for
 				 * specific array */
 				goto loop;
+			if (ident->uuid_set)
+				/* ignore unrecognized device if looking for
+				 * specific uuid
+				 */
+				goto loop;
 
 			pr_err("%s has no superblock - assembly aborted\n",
 			       devname);
-- 
1.8.3.1


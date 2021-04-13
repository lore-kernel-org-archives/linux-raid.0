Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A899CC433ED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:07:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83FFC60FED
	for <linux-raid@archiver.kernel.org>; Tue, 13 Apr 2021 01:07:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240327AbhDMBHg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Apr 2021 21:07:36 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:56466 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239318AbhDMBHf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Apr 2021 21:07:35 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D15PaC022133;
        Tue, 13 Apr 2021 01:07:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=gZKtbp1dTeRlLf4PfjP10nAzKSH1zImmKItwRsGD+c8=;
 b=pWBEYQtLxGd+5XmUQx8j5sNPQR9QnM1CvthNif/uxfG4aFBXTcNXOOAi/S3GiM9Rfsxe
 3gcZ/GQwk9yMpifIOzZ2dfjjxGT5d1QabYjq1h0bzXC0AccBJ7Z4l3ty58rU9d/bL3aV
 f2jx9aqov1zXU+DyjrPUZ+N1TJJhXyHWX7+k0MlzSJi3mdtLSStEdCieuNstDcYXyssv
 dmF7RmlQQZlcuTIWorl9qGdliDhkwfylNeeSTEwBqtURZVEhEP6dCX8WruBSn2N+sGmT
 HRz8ry1C6kT5Y2+ZxaSwfrWVnvpcZZ4WiFo3bGxSQRC+Guc3RwH9HiJeUyxay7sIp+mx 2g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 37u1hbdkfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 01:07:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D15Rha132929;
        Tue, 13 Apr 2021 01:07:09 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2171.outbound.protection.outlook.com [104.47.56.171])
        by userp3020.oracle.com with ESMTP id 37unsrp0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 01:07:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHZ0+wXfP/9fy3FkFxNG+qpayfd1ELoZMUobQV+VTTvyHxHlJ1D5Q0fWgKF7NdK8DWr3RTUqX9HstA6X5EdN9Vp6ikf//js3Y2/f/VM6TljT+IBnEBRTQN0pV+dxDGnlA/cOm1gR+6M8/CbrrEbuqUSt9VSx0/HApx1jXt6BDUseYGI9TLQDj2R3xGdsGUlIVljsScrwOcg/bmI89YbEVYYhoJXtEVVqRWO05R5wsZG8BHd6D8VOBoQuEzKgNCAHUl58Z/GFs43WIUv0MPgnRJ9TJ9qwIlgM8y138SmJXvLqS0oHRtsR6OM1ctVD/ZkDI2TjaaZUjm7f45eIi3KO+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZKtbp1dTeRlLf4PfjP10nAzKSH1zImmKItwRsGD+c8=;
 b=N9bSDizsCmLTovoqaXVt5AkroAZW6t0JDslL5h+8JGmew1bygw92uE5tCGh+XGaFuO4n3LiAkCwhpDKOFXzGXsfa01E5jWfmb3Y83Oc3ote4+tRkeOusnYrvqykHc5UABgKYFpDXqk3EGWwff2IEbvZWL+5TKCynM+hgnGoJgm6SCKjUajei0nBDfGMbmwt/FfXU6Yp1YTk+Z26q+Dk/bZkSHy3U04GgbFMqnTq23anN31kzVfVf4RLJDgZ5bJgCDN/DrDenCughpPr+9XV5y7k79y70FhLxkWUSolLb8hjpjTn191zjZPan4pd9opnWpwmCxlsow4EWW3sjxxWF2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZKtbp1dTeRlLf4PfjP10nAzKSH1zImmKItwRsGD+c8=;
 b=CN8XAvOR0YIXjGJ0UCgphdwfDn7kJ4c5+E1jAZG0u7XHg/Jl6oCOtuD6ik+v3pu0nQp8s2h/xpIJDidp0KaEiGhbRH21RWlWC2u/l8pqQpR6kUjM1leY51iFmB5znnaDiWUpejFOsD489Nh3SUxHdedJyjfhMu6AkmzytwS6HFg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR1001MB2278.namprd10.prod.outlook.com (2603:10b6:910:43::35) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.22; Tue, 13 Apr
 2021 01:07:07 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::187f:a874:db5f:2974%2]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 01:07:07 +0000
Date:   Tue, 13 Apr 2021 01:07:03 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     linux-raid@vger.kernel.org, song@kernel.org, heming.zhao@suse.com
Cc:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        martin.petersen@oracle.com
Subject: [PATCH] md/bitmap: wait for external bitmap writes to complete
 during tear down
Message-ID: <20210413010703.GA13817@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [209.17.40.37]
X-ClientProxiedBy: SN2PR01CA0004.prod.exchangelabs.com (2603:10b6:804:2::14)
 To CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.37) by SN2PR01CA0004.prod.exchangelabs.com (2603:10b6:804:2::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Tue, 13 Apr 2021 01:07:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3501276-f972-49e9-b72b-08d8fe18750d
X-MS-TrafficTypeDiagnostic: CY4PR1001MB2278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR1001MB2278FD13E8330740333D53B2FD4F9@CY4PR1001MB2278.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nLAIawjfDMrJe0FydBXq0tETaQu/p6R3efYVQQc20vtY/HPqkktarh8qess72Rg5tyn15ywS759nKdeAe4Sxm4G2ZaRnC8hvRjp8Vx/XSxBBDwJiZcBAMHBEPk39w3mTWXHdY4k2vpxI3XazviFKFSvh180LUBhbiaiJGteBP6OhrNl++tEvxfMBKrFF1tsNjpJLOdxzM+Vm6Se1uqdD/YQgWoYlrt2Obv9o2GgKWuiEL5H4uxc4WiKQBpqMfYdSIwnx9AvsEkqkyVHTkuNy9AAB2maInt6HdiBb3seqj73nqfx8ZfVeZb7BUQk2n3BIMVNRjyRECQMcRi1bOHRsEPW1Bx89GGhPAdTpkNSbCiLMu+oXTxSe2ZZFnvIOqyQRO+mW1TVbi3X+ncDVA9LJvyqkzKYbJD8UXZrpjpoRRH4VnAkrTLYy/9dZdxxps2pTOfFGayMzx1jEAvff7PwUvg2nFZT7iAljQCOyIoqrpJC8W02TqJX74JK+KkIShsMo0MqJpYxvy0lEatC2u3HSeL2WhsASIRpkQqlP9SmDmA9xI7GKCfkVWxzlNE0TCTMZec/seUhw2Nrx3AriupU3oZW5kzudc2SJSo/pSfk44ypfbxLEw5jiSvKGIIs8fTytKuiiBwX2iulC+EirHPSypzJn2bi8bEW8Hbitle0+QOI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(39860400002)(366004)(316002)(8886007)(7696005)(8936002)(478600001)(83380400001)(52116002)(186003)(36756003)(55016002)(33656002)(26005)(86362001)(38350700002)(16526019)(4326008)(66556008)(44832011)(107886003)(6666004)(66476007)(2616005)(2906002)(1076003)(8676002)(66946007)(38100700002)(956004)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E8AZOzJGarye3WkQNYNww029c/cRrNG+rKsq+oQzFFrulY2+zviqEPIWkgTa?=
 =?us-ascii?Q?a6/0F0abgzHqtuVXhToiXfEIVNtGtjW4tq/LLJF0ONNrAG9JkjezmIjHqakR?=
 =?us-ascii?Q?HRyUVn9DRXHOqbp8vBG/HEB1pk+4HRCwy1NvdPRchlIOcAut6L46hPqNWNlw?=
 =?us-ascii?Q?1sJ67XjERh121JOaloMsBjvp2WZQpu/q0T/Hc3RGYLNJ/5Kui4WinOzFwCQd?=
 =?us-ascii?Q?FA8qVrBKcdjNi6kzrVajT7Zd+m0QrEIlQoh+sQFpc64U4ExEX8Jle/Q/6l5l?=
 =?us-ascii?Q?t8ux1B+Wc1NC/+CpagcO2UTqa6eRwIJ4vC5Z5nkyc4TGyexVorqP7sr+QS8K?=
 =?us-ascii?Q?AEeJHabIo0maKgdqBHGqaGPxeUhwKoxA+loPl0shUNbk8haOm+1avtsh1cDc?=
 =?us-ascii?Q?FNL8BoHLanrY4wjHFLvX6dfe24sy6m29QDsqO6d2hCUVHEoQ7rk1Salq896T?=
 =?us-ascii?Q?zIg9W5DHt1V0n824Ml0Gaj5dPpQjAe6K0h3RZg/rNtbZll3jLa5kCBbHR2KA?=
 =?us-ascii?Q?sBpZrynIIqQcN9lUSsi/hDoZzYS9F3db+tul0DT2WaoC5xZ5NLZ/WWdxkcwr?=
 =?us-ascii?Q?X3jgNoVjpHYfmFoW+YhcF3VcIApAha/CklXoMFjeslf35VnHKXry92KAj0dP?=
 =?us-ascii?Q?sIl/3ZS8D932wOA0gCO7AWFydSL4rRVTxycKTT2M4/KZoul30ZDHCrku34Od?=
 =?us-ascii?Q?pugaCoYbyVQOFUyNJj2hO/nZeutRFjhfNJAVL0V192XfpJOdoSEWnDbA7RH8?=
 =?us-ascii?Q?+zgyXDGrqY1BIGoSlMh3eShLLQGL9uF4cj+d4wxl0KfTd9D6vgbFlm8ytEtg?=
 =?us-ascii?Q?MtjjgvUxNtFV1MhZx32+ujUM0kFMRwBcDimbyRK1me8kTcpdPDqGG3xfEkX4?=
 =?us-ascii?Q?f2WM0hwPW7cO3qFe/LBJHjYBwVrqvLtgZujywxfL1rHX/KS0Z9zGdY3/z43H?=
 =?us-ascii?Q?96WyJ6o0yYcQ2MRaErukx642DkLKiBAVYV+TZn7EQfcEBw6oLVmw5lQbQd05?=
 =?us-ascii?Q?E8HzbXAEXCDIZmsfzswtwDHtM+Mv22gzgh/RX5qDRuF8wMJZm7CBpkXrw8yJ?=
 =?us-ascii?Q?oX1y+n3jwuV2dxeCVknufCldnQ6YsiF5CJLzfH0tkMoPdxPtdhMPCf1ICRmy?=
 =?us-ascii?Q?X13n2RfWGs4mFwGmo6SbicWIds44JrP8K2d6EjGdgJ15sN2y8exPcded5Vsl?=
 =?us-ascii?Q?XqawVqBmphjNhaotKpZKjb1vWa37e5MOzMY6QEm7aVfJGh25G1foxUPisUG0?=
 =?us-ascii?Q?ws+CZOjOhoF/uZa/YZaHLSwk02Vs1zORC85GY+KQdTLB5heOFbWEBTp0agE1?=
 =?us-ascii?Q?+TnY5buMegx0QAyLQP+pnAUX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3501276-f972-49e9-b72b-08d8fe18750d
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 01:07:07.0967
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8iZW5rB3qsrA51VlRvvLs562vqsSUTptjsvkvSxCMM7oSATpPPS2j7lzKoti5+nLpiPDR1B5Ro+46SLRFrFWRBUFAzT05z8206YtTMUSgTBGV09eX0wjjLSqt3v4Lz8W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2278
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130004
X-Proofpoint-GUID: K3GsAYewmZQ2EEKOb89qMDQZqowj7n9T
X-Proofpoint-ORIG-GUID: K3GsAYewmZQ2EEKOb89qMDQZqowj7n9T
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130004
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

NULL pointer dereference was observed in super_written() when it tries
to access the mddev structure.

[The below stack trace is from an older kernel, but the problem described
in this patch applies to the mainline kernel.]

[ 1194.474861] task: ffff8fdd20858000 task.stack: ffffb99d40790000
[ 1194.488000] RIP: 0010:super_written+0x29/0xe1
[ 1194.499688] RSP: 0018:ffff8ffb7fcc3c78 EFLAGS: 00010046
[ 1194.512477] RAX: 0000000000000000 RBX: ffff8ffb7bf4a000 RCX: ffff8ffb78991048
[ 1194.527325] RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8ffb56b8a200
[ 1194.542576] RBP: ffff8ffb7fcc3c90 R08: 000000000000000b R09: 0000000000000000
[ 1194.558001] R10: ffff8ffb56b8a298 R11: 0000000000000000 R12: ffff8ffb56b8a200
[ 1194.573070] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1194.588117] FS:  0000000000000000(0000) GS:ffff8ffb7fcc0000(0000) knlGS:0000000000000000
[ 1194.604264] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1194.617375] CR2: 00000000000002b8 CR3: 00000021e040a002 CR4: 00000000007606e0
[ 1194.632327] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1194.647865] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1194.663316] PKRU: 55555554
[ 1194.674090] Call Trace:
[ 1194.683735]  <IRQ>
[ 1194.692948]  bio_endio+0xae/0x135
[ 1194.703580]  blk_update_request+0xad/0x2fa
[ 1194.714990]  blk_update_bidi_request+0x20/0x72
[ 1194.726578]  __blk_end_bidi_request+0x2c/0x4d
[ 1194.738373]  __blk_end_request_all+0x31/0x49
[ 1194.749344]  blk_flush_complete_seq+0x377/0x383
[ 1194.761550]  flush_end_io+0x1dd/0x2a7
[ 1194.772910]  blk_finish_request+0x9f/0x13c
[ 1194.784544]  scsi_end_request+0x180/0x25c
[ 1194.796149]  scsi_io_completion+0xc8/0x610
[ 1194.807503]  scsi_finish_command+0xdc/0x125
[ 1194.818897]  scsi_softirq_done+0x81/0xde
[ 1194.830062]  blk_done_softirq+0xa4/0xcc
[ 1194.841008]  __do_softirq+0xd9/0x29f
[ 1194.851257]  irq_exit+0xe6/0xeb
[ 1194.861290]  do_IRQ+0x59/0xe3
[ 1194.871060]  common_interrupt+0x1c6/0x382
[ 1194.881988]  </IRQ>
[ 1194.890646] RIP: 0010:cpuidle_enter_state+0xdd/0x2a5
[ 1194.902532] RSP: 0018:ffffb99d40793e68 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff43
[ 1194.917317] RAX: ffff8ffb7fce27c0 RBX: ffff8ffb7fced800 RCX: 000000000000001f
[ 1194.932056] RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000000
[ 1194.946428] RBP: ffffb99d40793ea0 R08: 0000000000000004 R09: 0000000000002ed2
[ 1194.960508] R10: 0000000000002664 R11: 0000000000000018 R12: 0000000000000003
[ 1194.974454] R13: 000000000000000b R14: ffffffff925715a0 R15: 0000011610120d5a
[ 1194.988607]  ? cpuidle_enter_state+0xcc/0x2a5
[ 1194.999077]  cpuidle_enter+0x17/0x19
[ 1195.008395]  call_cpuidle+0x23/0x3a
[ 1195.017718]  do_idle+0x172/0x1d5
[ 1195.026358]  cpu_startup_entry+0x73/0x75
[ 1195.035769]  start_secondary+0x1b9/0x20b
[ 1195.044894]  secondary_startup_64+0xa5/0xa5
[ 1195.084921] RIP: super_written+0x29/0xe1 RSP: ffff8ffb7fcc3c78
[ 1195.096354] CR2: 00000000000002b8

bio in the above stack is a bitmap write whose completion is invoked after
the tear down sequence sets the mddev structure to NULL in rdev.

During tear down, there is an attempt to flush the bitmap writes, but for
external bitmaps, there is no explicit wait for all the bitmap writes to
complete. For instance, md_bitmap_flush() is called to flush the bitmap
writes, but the last call to md_bitmap_daemon_work() in md_bitmap_flush()
could generate new bitmap writes for which there is no explicit wait to
complete those writes. The call to md_bitmap_update_sb() will return
simply for external bitmaps and the follow-up call to md_update_sb() is
conditional and may not get called for external bitmaps. This results in a
kernel panic when the completion routine, super_written() is called which
tries to reference mddev in the rdev that has been set to
NULL(in unbind_rdev_from_array() by tear down sequence).

The solution is to call md_super_wait() for external bitmaps after the
last call to md_bitmap_daemon_work() in md_bitmap_flush() to ensure there
are no pending bitmap writes before proceeding with the tear down.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..ea3130e11680 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1722,6 +1722,8 @@ void md_bitmap_flush(struct mddev *mddev)
 	md_bitmap_daemon_work(mddev);
 	bitmap->daemon_lastrun -= sleep;
 	md_bitmap_daemon_work(mddev);
+	if (mddev->bitmap_info.external)
+		md_super_wait(mddev);
 	md_bitmap_update_sb(bitmap);
 }
 
-- 
1.8.3.1


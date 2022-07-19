Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29357C433EF
	for <linux-raid@archiver.kernel.org>; Tue, 19 Jul 2022 09:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236489AbiGSJse (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 19 Jul 2022 05:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237078AbiGSJsZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 19 Jul 2022 05:48:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A841A816;
        Tue, 19 Jul 2022 02:48:23 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26J7wWNm024475;
        Tue, 19 Jul 2022 09:48:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2022-7-12;
 bh=ZCSrIbk+HDX2frM4M/uvQHMBjaP765R/7RbHroXInO4=;
 b=d8qbdcAFsosXvrRVrgO6OUD5yVdR0J715SoL0MiqyxwRvlEidqmRGT2yX9mVUjRVrE/4
 nyRc4Ee6LOhLo9na5Yy1uCCvWT62L4p5Z1+Ux0dDsul1wB3qYb7tx9rL9dVgpXVGQcQk
 2o4xNE4CztIXc4kkIJ9Xa5kDarxnOeryOqLZvDuSI5HHfG1r1rHKuI2jg4kjOMZvBG8O
 CJViqKX3aCyyiWrLM2XLqo2rK+MKraqKopfYHYctq99o7LWyjhoCIo02SOQCphJjZKdR
 6cxV+Mo6RN2u8JvcXqDqnCGcPxp15E7hSao26zKKcVgzVe5U3QiEoEjtGh/QiBV5E7XV 8w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hbm42drxn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 09:48:13 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 26J8a8NZ022289;
        Tue, 19 Jul 2022 09:48:12 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hc1hrreqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jul 2022 09:48:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jNmoUPK6uWeCIDapz4Ce/mRh2KDLXgph2ESLkDKhK+3eI9+q+YJ+c0/7mJiAw9OMZFWLeUei4iKGKJFnYLAHJkNS7sMckdR9leE8wqQGVHmTiGJIpn7TaMiRaueBvsFTke40iIei+O9THd1gyVlSaWwj33LwriK4lmmV0/GyXWBNY+vV5qZZ0rIoTYQM8GeFdGbC0yNLCrtjz1U1KrOX7oOGewvrVIh7q6c+nQ4YLXHkwQ2x8B0wm/kA23jSU56nScP0xApShFH4CRMZLMmJvZlssS9R0BE50r5PCTZ67wEyoLKbsO0CIBosY6L6GIZHUBZLGO/oYOr2v0+AT1WN4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCSrIbk+HDX2frM4M/uvQHMBjaP765R/7RbHroXInO4=;
 b=fcLouMjK0Shbh6s5r7taZYkiYZwlcSmib6w6tVji8rv4UeFKp3ljnKZJh6bpd80qWTlyytF5rpaJkfErhdxz4/10/S6EzLRT80FwOiUpaViGkXGSNcU16rLI7i7NjrC0b5vdd5aQJexXfIZV4NGcmh4fxDLryjWnpNCWRMbY13u4RJt0LD/nyx7rrxBofAYMfCD1Lw3lws1XvHKbs7CNZ9k0Vm9Ls7152yPnyfq2cAe3Y8ms06aiqsoTS2SEKJI9XO5BsEFZVtffEtAZbo6aUB7sIgEn9lNz5m6KIi61t+nwfoGF9gGnSgZzRGTPEMS6b1QWkTnQc1CM1CwtR9lx6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCSrIbk+HDX2frM4M/uvQHMBjaP765R/7RbHroXInO4=;
 b=fW2x4yLAahPYWwCxicYAVqfJmI7lhTH3KjZ2Uex0FeeLTXCHfdnZkIvFDF4s1H4zm1+BuaZINDSeXKTiDUWpAIS3BrRRU497kkvlewEFAjQW+/1N/fmsopaNn8N91jjqA6uiuLH2bC97Nrg0pLMRfwSR0BoUeJoLJGRhNuVOxO0=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by IA1PR10MB5924.namprd10.prod.outlook.com
 (2603:10b6:208:3d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Tue, 19 Jul
 2022 09:48:10 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::5020:9b82:5917:40b%6]) with mapi id 15.20.5438.023; Tue, 19 Jul 2022
 09:48:10 +0000
Date:   Tue, 19 Jul 2022 12:48:01 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Song Liu <song@kernel.org>, Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] md/raid5: missing error code in setup_conf()
Message-ID: <YtZ90ZYlrVvucwr9@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZRAP278CA0002.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:10::12) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ffd7b359-cf43-432c-b603-08da696bca67
X-MS-TrafficTypeDiagnostic: IA1PR10MB5924:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: csUz5eNYPSFatBJurdudOJ5jFkpJc4G0BlyMKOvMp6lAJb3foo99M6A0nyffPCa0QWOQ9a9Bvs9Inbum+IZ0gPjN11+TtSK5S+NYeHz85WM2oRQ8NpshcIiNcdaRMMdqStS9Q0WxjLouoPivuel2EC9tFzXT9NuCaYXLzHHcainvDl7tlLfmtnT4eePJadr3ae/d9WEti0CWda1O47R3wJ2n+GMEquPVktW6CsAugh6tH7b+tTzqQyZCrFVsUFdzaSrBcz0FQvk5yUNS+JEwfBeU5cb8gdJfP8BV698tStE9EGX9T1OWbLolmyqe7naz8/ZcI4P3BGbqGoh2oa3PEKOrRUycbMrBEmPgfmWZMkiqODge6TnMVp2TfAm6Ytn1G56z52uZop7HY0ZSir8TRuH0xpauB8RquWC/qTkL/or//w1t8AoppOYrMi6FzK5WovplH2lF5oDUaH2+bbT3nAEXZz5YJA51H137QPvLnA9V4HOIRzDSdaDCrcTtAY8Iqb65aK/TtPpxp2jATAy97PiQEJYPg2/DoqZPNnM7HqR+VyB7N9dhWHvGTIjm49geLUE1Age4ugYleqaU5bZtXPJ6uN1qIIN6GxOXBVgmxX0txzKJse8zIsgMTCnH423g/MlPa4Jzzcwwkp/SHpRsR4jIsVUWLIRuELH65muZdrQjapOik62ZmvPxz8CIC6QtxE9n8VJ8aa9r26/hu1Ate7ubwAVqEs7yjQQ1UBiZ/isF/sJO/qqRo3LJRD4/7LQRT6XTKbZ7FTxP9qhhB85piDN6L3U0KU+U0fP4WL9nLPF5IyyJVMkbBwdiUorIbVsU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(376002)(136003)(346002)(39860400002)(396003)(366004)(86362001)(478600001)(6666004)(41300700001)(6486002)(26005)(9686003)(186003)(52116002)(6506007)(83380400001)(110136005)(316002)(6512007)(66556008)(66476007)(4326008)(5660300002)(4744005)(8676002)(44832011)(8936002)(66946007)(33716001)(2906002)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W7wUO2WnZbXfZnKv7KN74svze0pFhHmGMnZ5MSVZqr0NrvKdlH0M6uM99BJl?=
 =?us-ascii?Q?n9kfmgCCFi5PWFBlW6B1DSOvMfiLTiDMAfJi2296BMND91bjzLSTLNLUoUPW?=
 =?us-ascii?Q?eOFrSf5dKHWPlm9MqMoSNryAhGzwGjIBCQQmG/sFdLqqSUPVpRp8KT7FRGFU?=
 =?us-ascii?Q?ODaFEe2V25uD14p5piT32OZW9iJMyn9DlCnkKo0tI+9SVm2Hu32PBu3AHBVn?=
 =?us-ascii?Q?qIiFcdN4Xm4bHEZL9m0nKDBx4kd9XtkXpaBdTVN+Wjd9O6LYeKyTKYB7BwZ1?=
 =?us-ascii?Q?bMm1ptb2qbn8jb0Jvh+Uze9qaMlBn0W/G6biw59FxNXVXGcGijne+Lni6MsO?=
 =?us-ascii?Q?90yNzKsYe24QrTZ9mcdg3q6PbMBCffvZ4Tje1TJfKhtu7TmN3CzpX1KgTQTr?=
 =?us-ascii?Q?j4hyWO16vNuwMdvjp1YxKKowjskAlHWYXaEx6JVFtOkmtb3yysqtMXNbvyui?=
 =?us-ascii?Q?MF0+A1tccfrpRUrLOZ7x+aJ6eh7FzHBbrgKeSy2/7uHR31v2mTtNsibt6vcd?=
 =?us-ascii?Q?cOa9S8ilQJ16tfyh4VgEffTsXddS58HVBvc2koWGeJ6IBmVCbBWLUdgquk1q?=
 =?us-ascii?Q?nlaJgRRnHQf8+tth9e2l0ZFW/htZNEsXeRi/kigXO3yYEOX4mnb0YT3aSs5y?=
 =?us-ascii?Q?BooKXo0BqDxxMsLdJxgKI/kZ7vQFFd39oq/js90wQ1z3S6l/jME5dcgrsMPU?=
 =?us-ascii?Q?JbuMEaGjZlFWdlc6XxFGVCxZgjQnCRp3yXooGt0/yfBIsPqFm60v+Xv3DO1Z?=
 =?us-ascii?Q?VgoOlA6+4C296MSp8Hk7gUWHO5t89w4ItUeH8Dm9SIxF5zoqrCLJ/6x0Mi9d?=
 =?us-ascii?Q?5Ak1mpThIv23HI5TwOG1iAnrnioBF+XOtln5U2LtriKBBepkwik5zp09xvZa?=
 =?us-ascii?Q?uClzR4Jk9hgV8/d2SmUOa3YT2vAOC8dbL2oI0cCCNvizLwiPlQFSIyVhqGEF?=
 =?us-ascii?Q?Dce7yPlALlTbhQaUcEsPaqj8YKTlJl/xHqG5N9n01AmI7MHvGtpH8vJiB7+x?=
 =?us-ascii?Q?YvZkV3OXcxp+iVqFMc9O4Hq7CwLl4rhxik+MzzxGwnXhTpLJFp0tfsIIfy+A?=
 =?us-ascii?Q?CyXsOpQBu6g1mT2qtYNODCSJekCL3UHqT7GnEp9dk5i2xxO1tyS81OKvjdp2?=
 =?us-ascii?Q?jrAA+CGzUyQomebTCa8mLlTZ05uX+zA4DHzP5XcDNyEOMNyk3GuPIogZqel5?=
 =?us-ascii?Q?KcjYWIkTB1Kl2V/fqkLCYD9I48baCZ321+VmQ49tdRD81rRnyMoNLhGidCPm?=
 =?us-ascii?Q?/ptwqwZWm619HGCGszJCA5KWtnMmgbcrlVrxmYc5v4YI06kAhCcDPSyrXG9J?=
 =?us-ascii?Q?y8hfX9TXZ5I+l6jktUEVAGtxkW6u3V0067NofH8O4Nr9bqcmesGUgHdADlvn?=
 =?us-ascii?Q?eIBKEwDMOTR7hoQavjBNgJXUwhkyNYqgcPMYAMP20dVSe8NMIKfJA7FBE3Dr?=
 =?us-ascii?Q?aezGdntiuusxUFKH1s+1QiI7fNVuQfS6neKa+fvjLkQ5JNMueR++hQkTzh56?=
 =?us-ascii?Q?A85DxyqYfIWdQWukVpzgEor1MFRVBLqbyWJmV9SPrsJZxjTuTzCKlEBzcIaa?=
 =?us-ascii?Q?G57JRfiVnOEOKSmlRFpQf2b+x8PV/ncOwNxFE+wCHNU2Ri0BbzrV20hsPyLb?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffd7b359-cf43-432c-b603-08da696bca67
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jul 2022 09:48:10.5964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yFb4X9HPOn9UckKllRHXCiU/qgv9/z0a7+lguvxLGzq3ZaNzjqhIG6mIdT9cAqXzYwBRRM74/8U11X2UsL3IsPF49QrRvyCYucP2N/Aoa9U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5924
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-18_22,2022-07-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207190041
X-Proofpoint-ORIG-GUID: 8QmPKmTyibn5lH9IBSLshouB6ERmZ-Dd
X-Proofpoint-GUID: 8QmPKmTyibn5lH9IBSLshouB6ERmZ-Dd
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Return -ENOMEM if the allocation fails.  Don't return success.

Fixes: 8fbcba6b999b ("md/raid5: Cleanup setup_conf() error returns")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/md/raid5.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a7db73d36cc4..f31012357572 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7492,7 +7492,9 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 		goto abort;
 	conf->mddev = mddev;
 
-	if ((conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL)) == NULL)
+	ret = -ENOMEM;
+	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!conf->stripe_hashtbl)
 		goto abort;
 
 	/* We init hash_locks[0] separately to that it can be used
-- 
2.35.1


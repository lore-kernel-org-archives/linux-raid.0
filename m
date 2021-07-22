Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402F3C6377D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:29:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 223B760C51
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbhGVRsg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:48:36 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61522 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhGVRsf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:48:35 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIH2W5002740;
        Thu, 22 Jul 2021 18:29:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=2Yf5XD25GmuWdKSLt8UMkXuwTIqNAEmtSU9t1x0bcQU=;
 b=W97ZnGB/qjml+VULSBbjPtWvTKXI8WTSppeRnYj7S/q0PQNidxYWZjID4lJtlhGiz05Z
 NyfMmpdfMhYDIagQALvVcqYrLKH9XkKsgDJeYvYOJOwxsVgd9dagtpAzBbs9OG266E7/
 RNPAT38VeZWd5sNomgFZMeFJ5qUaZ6Jibgv7GRxVMi0Ph4fcsFScmDb/ef7gul04d3KN
 iaABaV7K5+xRnc2k28dfoe6ge7rI+gzmQ1yp3b0BZ6uxlAll2OISsGC6k/eaJQQ+LwKa
 nNIpVTcuC5bxzoLGqhFR1ySUZv3n3zwWzu52WBA+Up3+GDLNMSBp7JYIsLUuH0JnxL4N Jg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=2Yf5XD25GmuWdKSLt8UMkXuwTIqNAEmtSU9t1x0bcQU=;
 b=w9PdJbbhbhNWT0h9ywqOwE++c3HGxoOy9OEzrWK2ak+PGLg1ftfK4P0vvRwiWZdpoF22
 QNalj+mUYa3Szriefe4R2Uk9ulfZF3wrY4cJNlJtL40xmvpa216XbPaTf0tjxmN2Apo/
 4DIzx/FLjuGEU5LIRzTK0aiJ2Lx8XnW4ClRPbSdvwIvPhWuG/Icv/QMbrlea5xJkH/ga
 MN2fftAd0OKcqDemUBtUjTkhfLJt5skMIPD8F75+e548Rmxe5XR/Q6UXgDDUIhM10elB
 aAG2xZEzBYKMAJ6pXoatZ6IevoYOqoUV3/Ewe9I/eWgwOuOBgtZNWbvPAdjoVUTMUukB PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y37t9n50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:29:08 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFR0A158393;
        Thu, 22 Jul 2021 18:29:07 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by aserp3030.oracle.com with ESMTP id 39wunpe6ur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:29:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HlmJ6Bsqp2IqM8vs462ZVCQp7ft36vog7lh2Um0XgcphQzYVKxASOuXnafqA8nPb7r9kHblRC0PCi72XLC2EB8ujvz4tNC4b+bdssr/8u9am0YUDHA6E5LxclK1K5E7zKv7Ffyy2bAcyStO4sysnfxdT+OMdJ34oiK6uvmkM0NZ27cHV/1FUcUHe9kJZJNZHwR6KdU+wsk98v94MoJPbruXb7pPqw457dStwCfsAyQlyCsD/AitHbjqXPHUFy7NwWHTaQXn6Phe4Jat/p2QGPtc5qHw0HM3V1bJ8NXTytaKJ/AThQHpSJEZqfVMUW84GfGVkxoYKYNePpy4sWYEGCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Yf5XD25GmuWdKSLt8UMkXuwTIqNAEmtSU9t1x0bcQU=;
 b=gjkCu/8OeBN/b/DyPdyX4rZGQXxlsK/+VaT0Pza0EAKNdCPFWGiwMUVyI8scRaYrCVrNdDtJS3puXJ4/v98/iH5jfa3RMJn95Kb84QehFhU5OvL+i5KBwEuFSOcTQONKeboYglRrcTox9tzo8GJjRjqKOBjZxNx5ySTFT3YprxlDs4TfDNA72u+u/agCqW4WpCIox4XAGEpZk9cGMQcT8y0OPUtEbiEU4+73Gs0x/uVxwMs3N6w5rVsOPjMarj7RHlZcSv/Y/bvMMLpmik94xBrQ2qpi/7GPzfEQ6798CtXoVE6rWZs3AdpP0Mbztdt70qwcjlDh2NUmLjiNOvH41A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Yf5XD25GmuWdKSLt8UMkXuwTIqNAEmtSU9t1x0bcQU=;
 b=affECIMtyoL1lNynSvFSBoagVG/d8TjnZ4n5WclF/PXqj9d0d/dRsqipwUmSj5uGflPofmBcJbBqRehxdWN7T4Q4nvl1YBF8hgGJcq8c9ZBz0r+zFp8frzbR3Q1JS6M1gsHCLMC3lyj1Manx5BVUJVGijqAiEYFZ0AiL/rg1244=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 18:29:06 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:29:05 +0000
Date:   Thu, 22 Jul 2021 18:29:03 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 4/5] tests: fix swap_super path
Message-ID: <20210722182903.GA25359@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN4PR0401CA0018.namprd04.prod.outlook.com
 (2603:10b6:803:21::28) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by SN4PR0401CA0018.namprd04.prod.outlook.com (2603:10b6:803:21::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.24 via Frontend Transport; Thu, 22 Jul 2021 18:29:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e8d3eff-badc-4747-f5ee-08d94d3e9674
X-MS-TrafficTypeDiagnostic: CY4PR10MB1381:
X-Microsoft-Antispam-PRVS: <CY4PR10MB13811E29EE7B27DD378F1B8AFDE49@CY4PR10MB1381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:207;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LxRZae0E76/GelS8YzLbLBvswY2LgisMbryuEXUXk9mJnT5C2z1tc5ySeV29Q9sHDMWtis9jBrotYVX7vtyly/6PzFup/4T7Th9RjB4pyBYn2T7OiL6tG6ggO7L3GfGDBDHxuxgziGe2ZWogZ5f1ugE58kKYjd116fAJWKG/YD/r4YbKs/A7MoM+dApul+JnLeeOe5GCmrwZRWnE7ET60skVpRmJWL82i2xXzw2EVH2/K1OxdCvt5eCEiUnbJk80Hsu+J08am+n+RupjkIw6p3yuGiGQRTMc45O46yecKqVAoaTM0t48JYMB+5g2ZfwBqE4etF+R/vFYYzOtsv2VQaRRSk/7KsyzQ3+tiuLVBICFTClKmxYT+zPm8QvHVbwg+lk8ia96lx8+dNsolZi6Mr+jI7A1IjMKHarHX8sTggd9AzqsN77P1i1PginmG/KqSPTO6x/3DBpwjOD5wMT4HlmyBn8QHFwntDwsYAviAB18bY/Ys6B1EMn97PcLHCdobMSzLffT8b3bwHAVO4rJDzDasdBwZQ7gJ6ecZHIrzT2biolcVeMt/hfM/U1OQiSDb0BI7dFH6ytye+UjC+fLQTmao9GeZA0JQGxHhWHAmGHl4qKjV03Iotp4cDoQv9gO7taGWB6ImGTTVUKymfvzzPyDT5dz6qcI3+JbXQVczEV4/wcxrZh+cYh5VInm1QeDGEtZ029W1YOxoC22GD3G5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66556008)(33656002)(7696005)(956004)(8676002)(4326008)(55016002)(52116002)(66946007)(66476007)(316002)(86362001)(2616005)(2906002)(5660300002)(1076003)(186003)(44832011)(38100700002)(508600001)(6916009)(26005)(8886007)(38350700002)(36756003)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?R4ga4WwgTgLKQdFpJG4p2G+hV+3S8QAAfEZEZU86s+2rfYSExCaF+wALjTNb?=
 =?us-ascii?Q?bk/mWeGQ+c2Bh0bNWM8QcFn5AmaL/PdPsqaRUJRfGZ6rsmdGVBg6gCj2f1a2?=
 =?us-ascii?Q?457WH1xEF4g8Gsd+ZMGdES1ehep8XizB6DaZynwpEYDkVn2DyG8Qfvnz8f0O?=
 =?us-ascii?Q?mxfzdY0Khp6EdpyP7nQSCn7P6ttOCnMWEx8tocsJM9a4FCLoGf0rWgoOCCE9?=
 =?us-ascii?Q?FR3XSQ0wjYAibI85YBpeF5FhWS2L/DNzXfrn4t5kG7I5nDLGPM7FNvfCm90E?=
 =?us-ascii?Q?zy2wmFBnZ2rWwqFb9hg8PHGId2xXFirG7idxxmBFMPRB5ioZPtsZPm7mX70L?=
 =?us-ascii?Q?zCvsEUsKgVVXyEq3+chp+lsLqRM5TDyHPhknTaraDCfVCGRzmy3YaypNsTUA?=
 =?us-ascii?Q?aHG21nEsnJVp0ghPXf6Abqy9cXwOX8pri58BFOFeWevdQNDT0W5RmsguDCBk?=
 =?us-ascii?Q?oH1t/3g797oYg7x82HMcepzE6ZIJlO+Bm5A87l/OuiCg6cEpgpUQ2ZlWQ5vq?=
 =?us-ascii?Q?dHMP8aB2nmFLPMeoTnLev1Alc6WMnFGxspdZcoOXdIuoEEJpkN775vHxGXGK?=
 =?us-ascii?Q?z+zjCwnW+jYzZzockVgEMPPeYFfvGYkAxumysw4tveGB+jz5+jAhHGmGZw9E?=
 =?us-ascii?Q?cHlVbpSt4fEcyPi/jesXVfqUzzSGCqshGdxONfsYVGr+rMEZhZxT/r+3dhYk?=
 =?us-ascii?Q?ER3YSKwH5bZ2eG3H/T1Lc1Coq1PB8xTFRCnVEM3bCeHM+J2QhAy5ShokKspv?=
 =?us-ascii?Q?JmrWnVPe97nn3BP5KJUyn9gFcb/6ENu89Y2tYVDKimp3gsFsd1z12n+4iIjt?=
 =?us-ascii?Q?H1eB43OdlW4X8BKic/sPssZVOipvEvD9D4/FKEZ7aRbxCnQXiFqQiQ8HdLRq?=
 =?us-ascii?Q?DM31CD1E2GYiDjY4tEQj/sHRiSHbk/2nPRl5lXxgKJwystQWv5MbtM2wdDsF?=
 =?us-ascii?Q?Y3Y4xyylpXYHN0zlDqEGM2QOb3XYJ0iZ0lWQZYufwXecJSp/F8k0tOGT4eBc?=
 =?us-ascii?Q?e4t7dMLL99Xw8pDu7+bo1bPqL3iOnGSHJQFWaU+NbXTqLxALl7fuRHdUJH+7?=
 =?us-ascii?Q?5uUJJJgm+uc5mB5AdxbYPYp7oByAeCikIsbKPyqT13PgUXV3wQbtYbtQtueA?=
 =?us-ascii?Q?3iLCAXq1a/ZKqebrpNl0n1oHGQRTNVOmZowr21HOCk3+akLVDIxFnpp9AUmO?=
 =?us-ascii?Q?+TseYdB8eM5eEdGugPPm2m7fHeWgK/lbzCak8r7XhL+nZ7nBPmdcAON0FhL4?=
 =?us-ascii?Q?qW7SWuqHO+cCrG/4DvmlCjojKgAzfoQRavIGsRnPIOU71ZhDYpjIWt3k7HyC?=
 =?us-ascii?Q?AKv/xYPQUx4/h+h8wIQB4RlR?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8d3eff-badc-4747-f5ee-08d94d3e9674
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:29:05.8184
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U+NW24JPRNzRwSrIzpBmdrriwGEWcH9/MShCqbXMoDh6vCJTfc03oj7Ohx1TWj50wn4Mh4xayDaQR4tC3i/3atCsluyUk2kAamiofrViUZ1k7xgWq6LKhYMocioliHhZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220120
X-Proofpoint-ORIG-GUID: vyNyTDnctoJMn_LYjVmVkBLGN5KYce9J
X-Proofpoint-GUID: vyNyTDnctoJMn_LYjVmVkBLGN5KYce9J
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This fixes '04r5swap' test.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/04r5swap | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/04r5swap b/tests/04r5swap
index 5373a60725fb..8c6a97ba7339 100644
--- a/tests/04r5swap
+++ b/tests/04r5swap
@@ -7,7 +7,7 @@ mdadm -S $md0
 
 mdadm -E --metadata=0 $dev1  > $targetdir/d1
 for d in $dev0 $dev1 $dev2 $dev3
-do $dir/swap_super $d
+do $PWD/swap_super $d
 done
 mdadm -E --metadata=0.swap  $dev1  > $targetdir/d1s
 diff -u $targetdir/d1 $targetdir/d1s
-- 
1.8.3.1


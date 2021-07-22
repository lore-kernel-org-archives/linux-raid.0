Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B80C6377D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:27:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D890560720
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:27:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhGVRqd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:46:33 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11080 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229763AbhGVRqc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:46:32 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIH2VF002740;
        Thu, 22 Jul 2021 18:27:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=7kfnaaYR8plc7y3G5THIeDbBJGH9Z1UD3dk4u40bQqA=;
 b=qDKlvt5d614Vp6Jce/cmThNTltPgqLThPhwAjGSTPSMPcg1GQb8VenKoFHfcJNqxtTg9
 nnNZes3lx/tt9dvrce1ie1dn5hsiXEab4qSU00/1l/6iswCjDh8J9atETTeJOwenBTeG
 8uWDMgwTgO6JDlAE3yqb0RtY5r/iN6pbTwk9hHoFqDg2cFOkoML2jdfcU3JhTiFjwgdK
 el10Md8+93sTM/SyM6ipB5EX7Qe9F77BhGD0Uja99cG6Rb09d3X5BahKhA4cCD0PeB5Q
 u+yRwtEigBy411KOi4iAH6tCczmneFmMkNhq1pwmwHz6C1R1IYKd/TdCoxo7sWYOtISR qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=7kfnaaYR8plc7y3G5THIeDbBJGH9Z1UD3dk4u40bQqA=;
 b=DRqljSLU9GSDjUktZVlgApaWVfG3txC88nbSibAVF92CFLBTsfGfITmzk7x14g3XXXSJ
 dkC6k3ltGvoYPgS08cFL9esBZfXOyyE/E8luNp/PHQYl6D/NcVx9ALBLMT3BY4WyQ9hD
 idhnaJc9pZ2mMgnKL/IkY5zWABfcOh4L65nPGtcqQdZBw5lozcnY1kuzjAGFyQkO0lq2
 xbcAKWHZ1CU2xTmHwa4uJMXuDYBuclsLq+KUr8rBNp2an34ZEwH8lvn4QJ5yzFfvVkqt
 nPGET+37iQfvP31PASUE0UJwviSH/ETIinRwWOn4JoaINQif8UPRH9O6GLPIfgIuIqDM Zw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y37t9myx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:27:05 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFEBD167702;
        Thu, 22 Jul 2021 18:27:04 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2043.outbound.protection.outlook.com [104.47.56.43])
        by aserp3020.oracle.com with ESMTP id 39uq1bpugm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:27:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EtHFGS90hzxlkDWtO8BGjmr7JYK7HpY56BDvSHaDxrpyB7MteM4Sr+QArxNqQzOyTobNUEBLXL5N1BgETbM4W3DGy/PlaKkK/NtoEJ0yYwifcB+lO6Ve/JJ9s8PXI9uyrchGMHi3kRXtqI7QdxokcBHwNZHxOGPocpA4rGMobtQr1mdAikknrV++LxtODgy/YktGrdAXXNkOLHbMipx/uVXvS+5rai97W85PVAmPnIzjIEuK0b0ydkUXwIHH3LhKiTAZRT2aCnDN63GaBluUZfdgoQT5AX7nlDUVv+weLcLtK5RGO0/PevJwZE6GInkg63IBGcfziPsZi0a5r0jNDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kfnaaYR8plc7y3G5THIeDbBJGH9Z1UD3dk4u40bQqA=;
 b=Vo6v9ocPecgOfWxRvtFSW+V/ewW/F9v2VijXKt3bWcs0uZpTYxyHTnkgFCG75/dX01GVJMQLes6Reu9V8YGegbDEvmwJvLdAohFqvWigC/Lic3Ii8M1mTlUWl2Xddte7gYR9LjSZ9NAZ+6cIgpasOCq6d2tWCV/zuiDQJ7zl3r8JZQPFAKZZgDT/6J6PGU7jL1f/AiIXbfjhiGp7/u7hj7uF923ltL3NKcG8beNNXjZvnU6j4gntTyb5aDo/tybqCdVkV4QLR0jjVlgg8g10aayBdECleXpMqOtTqrN1WStlXw0N7tafAvWdW0BtJgNQ8ydUilYLLPGGak+s4IXVqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kfnaaYR8plc7y3G5THIeDbBJGH9Z1UD3dk4u40bQqA=;
 b=NI5Tmd1IkQXXZAeD/LgRaRHeJ3hqYikX4bWPbCGQeWQSgf6NEZaqqUclzfoBVi4iE2tQvNAiaHcr0XrvT7E+Wn0XAb1YBbMACTrekpUbYlPmyLjDY5Joem5x9prWT3lHMHVpI+gAyPSkLhSO+TSbHKXpj25+vD41dGKwtz+9mik=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1494.namprd10.prod.outlook.com (2603:10b6:903:26::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 18:27:01 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:27:01 +0000
Date:   Thu, 22 Jul 2021 18:26:58 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 0/5] Resurrect mdadm test cases - Series 1
Message-ID: <20210722182658.GA24774@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BY5PR20CA0008.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::21) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by BY5PR20CA0008.namprd20.prod.outlook.com (2603:10b6:a03:1f4::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Thu, 22 Jul 2021 18:27:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 00e1e5ff-ff0a-4e37-4376-08d94d3e4c74
X-MS-TrafficTypeDiagnostic: CY4PR10MB1494:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1494AEE8B2671DE4896E7739FDE49@CY4PR10MB1494.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCthp8gWM9VO38IKft0vxW2MelIvW0ZI64pTpdG6YPzhbg/NJH2m1Lxk1/gSKjXqgeQCGWhQevCv1hW+S4c8u6XyHx/jJE2ag3tBcAdlJMQ4HLoGG7OBmwYPC6pwpt8I/jRNoXsXOH4v/xW/IKfnR4Pwrddb63m+2BB0XuwHz5o75Lgbf6VUdgiWrozeYhb1wMIitiVJTePP2nkgExjQunM1paK+M6a5xmSgI0NuGlM2ySElTMjH5J1dJcTK5NQIDYVuWl8StCWxNvb5CpTDKgrJdBRIKTgrGtDCW8nbmj2foonxD4e1y5V1/SK4Civ8xxN0Gv8DIM8YnqlMMOvdeQrbbeDRTQdeAQXA9CUkaE5rXyBIxuMrCw1Odit1CRR+zwEqECTYeQMxVxfKViYNj0ME83OMs8hiRmaLQTO0OcNVg7av0MtpFBPzgrp/JeaCXuALCoYNT9GTjL4fDf69fItb9YInrkqd+Cwltc147+R/5SL+zo6ln91UKyGT9rWh91AJGLKrlcViGHsnWHrIaawcCgPkjkGd17/tcHW5OEl/rwh4YnewnAc2+Ct8grgU7deIphBB6I9JMcYPjgM98xpB5m9hlFbeKSaKChSBFxn9uw4dKvidXebXANnvcCKASF+Eqx38YZhlwRPzJZ1Ey/UhB6g7wc11kZV6Sx6KsO0lYyAg3n/5shwxYSzCoODJEKjFdjDOy9uUowH0bb2HOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(4326008)(7696005)(83380400001)(6916009)(52116002)(8676002)(66476007)(8886007)(66946007)(66556008)(26005)(5660300002)(478600001)(36756003)(33656002)(1076003)(55016002)(8936002)(2616005)(38350700002)(6666004)(44832011)(316002)(186003)(2906002)(956004)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KImLQzYPgCI2YzxNoJwaw+SnX9UlxGTBh6bQ+bJWEiJJvtNd7HhlbFARDVA4?=
 =?us-ascii?Q?695OLL6gJVonuGp7AS/B8uVcySqzEz+GBxDPJnvqvS97NVkv93MNgxi4Q9Bp?=
 =?us-ascii?Q?mXiAnIbmNRt+pMl8JlM/ehyuGkkTdkFPH//muilu14g3lzANsc35LPV3Wm/K?=
 =?us-ascii?Q?sPK0+iOvGJ6ocOJAI+xDi+s6o0gbCgq4GbfRtkpXkgaohVDbciia5BLTPc/R?=
 =?us-ascii?Q?sytL0ghSyTX7pvKva69WdaEm9muJezJhEa0l9fk+i/CPTY/gc0fh9I7Yd6yj?=
 =?us-ascii?Q?4jAT75GPBKE1tfjkpwk/GdZPmZpjyFk7hI9uiOorvw+QOLwjCoD/EJIP9xOp?=
 =?us-ascii?Q?y7mxovYSdxXXr3XOD77VSeWF9KfNsyq0E4l6xqMBnt6w9dL2dz2yXJm5JoVh?=
 =?us-ascii?Q?MWn4NaKB4guLLYL79TY7aU84uPgVYNbjeu0B3+Qb0IuuDn0InTih/9H3Ne6x?=
 =?us-ascii?Q?XsnrQ7QXVRMSyhadpTbGxYnGVyyTpP2ZnP99i5LxPtfPPfB33uz5Ymp7DVpv?=
 =?us-ascii?Q?G9+A2bn487a7VoJ3Bpacsuui4kfWoPVwWfU3AtSB0RdOZrH2MF6QsgpwGE4z?=
 =?us-ascii?Q?0cu2uvMrr10jc7XuKWc7TpMUYbqjGvzgpa+hxTQxWICu7hjjB8k0+ITBb27F?=
 =?us-ascii?Q?hXuHid9rkh1r7+SuddgTlm18MHaSvh3qv3/StCYSNqRYXEM6ac4AUiKQueFF?=
 =?us-ascii?Q?0PCIN190HsrXavOzCWgRCWwLJ/5S97jKkV0qgXA+cI8Q9ReYLxs3zmwTN+b8?=
 =?us-ascii?Q?+cYeKv0PnzmcqPGT9VqoCXMiJyi1gCaqtLYHqWRVYFVNII67alx3cvY5I9ge?=
 =?us-ascii?Q?+YVhhWZnULViOMlwxq41JYDnVVSgLlzowBGCUUCi836TEBne4+nUeCZCjjeO?=
 =?us-ascii?Q?ckugp+eR6murvNzVgVQfyz4KH9JfeWrhm0VJRIB+C95RiO7dmTe57Okx17LI?=
 =?us-ascii?Q?mXnn5HHwvRLL1ND0LW1DYb6WIc/Mc5BODHyed26sI+AgoA2qWdqgFxUmTy7Y?=
 =?us-ascii?Q?cACWL8sOecW7qd64UK6S8lShEiFTbkqQvZ5oYuEfy+9rFh0lV9RmUlxjx7kW?=
 =?us-ascii?Q?+bIjHD6V33sPCkuaRmScB0k9+U5i6WcblyipBonwTwDlbLXc4ZUWyRTQhWMp?=
 =?us-ascii?Q?mdRTWkdzx/AvUDXig/lQfCfxsxiAK53mBfTSQi2z+LMvsDllYE6tHfoUAgeZ?=
 =?us-ascii?Q?dngptVmkbZLuYN48VSj6/G7FYobhsfzT6MdwjAA4jxZnS1CV2pcrB/Pj7QiY?=
 =?us-ascii?Q?yoAfL+dMebsDq7t0sPXqdMuoIcBj7v0DQhk1ESmJ3j7zwyDLz4PgzvtRcMGZ?=
 =?us-ascii?Q?9EHua7KjHf47W+2pQEBhJnxK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00e1e5ff-ff0a-4e37-4376-08d94d3e4c74
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:27:01.6934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R6qc+Ky9opi0si2FhzPwwHmJtI0mUGWeOjVExJIj83kSQXfhnuTJdgq/Dn1EgjhSNsm0phzv3uqRJcj/sjBUomfIK/PCw1kBPYcgxioCyx/Wi3XyHtfNYkDEF1zA6Vu2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1494
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=953 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220120
X-Proofpoint-ORIG-GUID: tJSxp8lZusfiCKSemjScjIKMzUlCqhVR
X-Proofpoint-GUID: tJSxp8lZusfiCKSemjScjIKMzUlCqhVR
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello,

I noticed that mdadm has a vast amount of test cases in place that covers
various features offered by it. But, many of the test cases fail to run
either because the test case is not valid anymore or they need some tweaking
to make it to work. I have attempted to fix some of the test cases in this
patch set while there are many other test cases that are still failing. I will
submit some more patch sets in the future to eventually make all the test
cases to run successfully and possibly add more test cases that are missing
currently.

Thanks
Sudhakar

Sudhakar Panneerselvam (5):
  tests: remove raid0 tests for 0.90 metadata version
  tests: clear the superblock before adding a device to the array.
  Assemble: skip devices that don't match uuid instead of aborting the
    assembly.
  tests: fix swap_super path
  tests: avoid passing chunk size to raid1.

 Assemble.c              |  5 ++++
 test                    |  9 +++++--
 tests/00raid0           | 11 --------
 tests/00readonly        |  4 +++
 tests/03r0assem         | 72 -------------------------------------------------
 tests/04r0update        | 20 --------------
 tests/04r5swap          |  2 +-
 tests/04update-metadata |  9 +++++--
 8 files changed, 24 insertions(+), 108 deletions(-)
 delete mode 100644 tests/04r0update

-- 
1.8.3.1


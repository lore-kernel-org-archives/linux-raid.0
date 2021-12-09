Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17576C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhLISmI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:42:08 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23640 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229621AbhLISmB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:42:01 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HfrXl030827;
        Thu, 9 Dec 2021 18:38:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=fT7yWnqHxvhnjHQG/aUD6nSEWoPvFrneXwhuqu1szLI=;
 b=0Crcafie6OAOpFN+20LkYPOKo6GzR10Qyxi7FJY2iA6jGBysJzyqA9lMsyBm1KG2q92O
 +1CfmzjfzIMQgxtT6xZZxJonStx+pW1ty5SrkfHFoU/e84pIfKT3Y5xFEJD0FYZC5wFw
 s23GXoFYBHKR1yzM8C7DZ0+Bz53Ey2du58zjvacm5282AjJOcSaE7gf4XsidyqYIhnGi
 T5kiSOIPLuJNAJsgAeokhnjKZrAnY2NlLRY1PkJbThu5c14PQaQ06T66rU1KGnCK2iMr
 wvx5gI1gwIqyto78OrmyMqHxJWtGoUIvrLpPpXimVpK2QafSf+6+53Zmvf/dUEhykaxy gg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctse1m5xk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:38:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Ib3Tc084442;
        Thu, 9 Dec 2021 18:38:24 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 3cr1ssx4ef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:38:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M9thZbICXyVOw6nr7c+mqitjd9hRiCa5AIgBQDbebOnbJcwiR+5m49TaY9Q3psAIy3AXyimF9fdzW8W59xKHvfDDPDa2XjnPsErD8aABizsJ4OBcOO1QgTh9SFZhX3yR9u9Ksp2cU6bSjf4bzQOteZ62SyIyrjmqprS0/hZ+Xo2P9lvFJzePZN2Kz/4YUwtK/rpl8SzZYbvzIfAHrGEtZahgAS8Wgd5rkQxFriw8UfCrBeTMVY3/7Uv/gTs4/G4Xnvu3aLHzoYELpiNZFO59Mr/NVtQv4r25H5/ouLpBRvuipo4giIIWwXCNXgig7QJKgYzQcQXelrcV2fZr6bnRBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fT7yWnqHxvhnjHQG/aUD6nSEWoPvFrneXwhuqu1szLI=;
 b=HQRJAiIpT8weAexuYfiqYpsEkNp8rZ33HdXlRC2U9u/N2T0257Byk6y0sREBaDnEdGerelJTlQ9vfu5Dbd/FZzNnzgYkSihzcS/zwLJmmBZG2iEZ/HOeFwcYvijbpQodFf7GSzvjuaeaawpdjobtFkfoNuCsmHG28ONg8llj040am4avlTfLUR71BdFjIPCMcyARdX+ql0hBIc3dVFyQWKMJ2djm37xRdpfVJrctWq6Jl1eLHMmCZOb7Ymza3dLh5LY9U8W9QpIZ2Gcy8NRPbsG/dqvBsgzIFPaVp3N26MekP7neN6FR3g7MgIbT1+ghmBuyb/bmIrLIKb5yiZ7v9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fT7yWnqHxvhnjHQG/aUD6nSEWoPvFrneXwhuqu1szLI=;
 b=AHu2Sq51RFckWisySDttPYinqDGDgL4Jqe3twHjjJs6f9PnDxsu2gz434CmJfjh6Qm6leic/iVw0V2bzgH0eNJYShCbq0NcHIi4aoAA6vXJW7E61JEW4qHyw+TBxZd30lpp382TsT25bhQL0jiS9QlnO+kc4g0s/OxB6T0DFa3w=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:38:20 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:38:20 +0000
Date:   Thu, 9 Dec 2021 18:38:17 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 5/6] tests: Add a test for write-intent bitmap support for
 imsm
Message-ID: <20211209183817.GA22663@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BYAPR06CA0059.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::36) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by BYAPR06CA0059.namprd06.prod.outlook.com (2603:10b6:a03:14b::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 18:38:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88dd2cb9-f3fd-44f0-77bc-08d9bb4312b9
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1655D07F5B7B7EB60D249F23FD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVXBwa+d9INXBhxHWbwS9iUzC2ZtiGar26+xn3cL/GpEUP2mgwFvdoE9r5sOXnU4sdkPj8YKkOoUytjeThZswAmxhIpmamx3gFcB8Jz3XPM125DRsDEqFfbJU0YGXSAd5viZUuS5nvcSPXMyGrNH36QTj9Ec98K822Zx2rH3YYm1Wxs6GS4Xssotub1r8MA77Uyq5mXILiP5l+f3GMMy9n8aHSHNyQPPVlHaZzyEvBBJz8sE9Zb6C5bIdA/Nwe9ApDxODFrbw/KkzQu8M8HY5mfoDSmh6LMiVG5tewZRouu+rgwONTyiYfiHp+U7NmbWTAgeGmVIE0nB5jwii9gQYJxLSXdaiiA9FQmom+KzK4skI5sw+Dkz2WRFFb1PWLkys2Wq7dnG9bttx2lhMzWdKCt7OkJMG2z5PkE59zbfO1unhj3n/sL/QwZB5ZiqvjqPsLj5NGRKnYSmxfHrZUhBswor+jHbnXmN4OhwqHht4cnYq9lYjAHGgCE+RROAbmCFw24qekCVgS7dQpCj70nePqe0giq6LJpVXTXsqnFggtVh3hX14r483jQl0dbVUbe/R8AyNs4/VP4ZDFKOtt0movgwH4WzLATfcY7E//fYi+P40/2Oonsrk8qQHz1iRfblYutMN9zQHb4yhODOReUsBo5KoPuswMjlJ5z9EZHiqdmUrVUShQ+hIf92cNM2x4Ll35DPG2ZQVbf0L81yx1HPfA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(86362001)(83380400001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(4744005)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UiHx85U0zAZv0cEXVghguyiKfJdrZEQDEy7+pLeMDUVqcnYquGFYrO7VRE0m?=
 =?us-ascii?Q?3V64bvi0lSJDVfXh7uvJ+zvu6FfLNGRiXmlQeKb0EaNLQ6CQ2L8FkVqq1QBg?=
 =?us-ascii?Q?UUPh8G5tKlVnudCxT+WJ/vp/Z763L7vgU5s+K4H/v6W9UTw1B04objUg+EH2?=
 =?us-ascii?Q?JOPB8Edj0k6IHz2qwS822+5jzJaykWZ9RZ+DUqDHSdz8rcl1KWOU3tFUKu4I?=
 =?us-ascii?Q?jIls30FEF30kbMReEIAZAaw5DTetUlFlS1R2vZZzgCHsnD8JrAW6UJbtHLp8?=
 =?us-ascii?Q?VTnhxT5PGpRFRNAoU2kUH6N5pcxfPgIUKEBvswXvD2SToVuyEs1LR1PKEcKX?=
 =?us-ascii?Q?/otHds9kXn6HQiCrinPKo9FJ3XITu0KXBtWaP/VhP48vldrtFrfL0ybQ5TFj?=
 =?us-ascii?Q?00uhEioTRoxq8QggTO9CUmMEYMAXf2dF+VorxANxXLgJh6av78VxiRfyWgKe?=
 =?us-ascii?Q?PAcPnu7ejgXOJButZbc5fc7k4rQoU/Kr3tv1sEsZD3swI2kORtBMWN+3EkJh?=
 =?us-ascii?Q?J68FKCCwXhQ9lbLa3ooVQPj6APlakuJygOHlkJN2Caz8Cv+shgkVG6807Vru?=
 =?us-ascii?Q?7Yg+nLVZ+oemVi0a6109fD7DcaraTlmJXc8SCT8R5pgCtz33Eu9wth2IcH0M?=
 =?us-ascii?Q?6yN3qhMBzXMWyBEt/NIwN9c+dg7NKa3oUfrs3sh4YWjU32rLaGL632Uy8RIa?=
 =?us-ascii?Q?pYjgmlrPn9kX6nco55svT5Tr/xoSrfV7OywXiaVgTNgUtJpeI7tyn7vBIRp8?=
 =?us-ascii?Q?W308uTmWmMdrjQUeIO3s/w1bP/RfOiXhBi7Kd8wmQO5uyRmih9TqPvC+Pu54?=
 =?us-ascii?Q?9O13Dj3ZGZmaw8IgBlcJSl0A4TUsxisQ5YZ4FmB1Utqx5vNl4rgK4dsQ0uvr?=
 =?us-ascii?Q?e6mIK26U4QPhpT0mzG6W8TmamDexUbYpocj3jwOVN/s+Ar6WODVNIPVoO7ZJ?=
 =?us-ascii?Q?bB5A6caJDiYxFBsNRjCHzqOqbkY2+j5mg4EoXWck+ApSXG0PN1fa/wFOwYDi?=
 =?us-ascii?Q?UyhUZ6PT4S6klV1PHyFLIkbRkwQaDj1P7QVm6v1opVUjKju4an8bSTFPGJ7I?=
 =?us-ascii?Q?alztIErbLHgZWmlmQM+OLHwRYDTH66ZiN4f3Sc1f+BOgkKU5O5c0um0iBw8U?=
 =?us-ascii?Q?TxF6xjDp1pOPwx5WNxjtOngslzp0MdhwJ3m052SK+cT88MIiZo/DUnB0gNTD?=
 =?us-ascii?Q?0JKgkpzfxyDMaPjTNeycU4bPOFwclnjyMWlQ8BP1WEs/MMnf0XGami63i4dY?=
 =?us-ascii?Q?hnkuSj4IrlduXNw5lIXfDBMA2yPgo6KVyQhI2jz5Wed4Vw1tMMFFzEdCJYPu?=
 =?us-ascii?Q?/Vwcij2Po7GFU7b58HLu2Wue2rwxSjqXJMk/MAzJk0/pnxXDOXJOCdCGlQQl?=
 =?us-ascii?Q?F7Z3Amensss3OmCyr06mInQCGTfwoq4XYt/GzqhuMrPN+iIWsGu9Q7ojMVCb?=
 =?us-ascii?Q?RExN0HoNi1O1I2aNf35D3I9Bi5m1Oo9XXEWWfBR4ny3D0PpMhb8aNr+xfhLo?=
 =?us-ascii?Q?ob8Gg9Vm/Ih/gOfqNP18ZreW/mkzrf4tV6u/oYIMakd3TXXNqmuTA4SXk2X+?=
 =?us-ascii?Q?c1qn7jYldTGl2rWkCceAuV0Gv6mh6yfAXy/igttHKzzQpWGggQyA+CIPkc5v?=
 =?us-ascii?Q?6Vsuag07hXk9g5TdIhi4dyLp2gneEKTAkJa1L2Z0DZHku347tWPmvy0esuFL?=
 =?us-ascii?Q?mxmWsBTbgZJP9Q7xQIJ95+brhsm7xVvBFWIS33ScUpM8ELb+xkldeFQ/1Auj?=
 =?us-ascii?Q?As6cMeQMdw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88dd2cb9-f3fd-44f0-77bc-08d9bb4312b9
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:38:20.2077
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cxyQpZjwUX02unYA0y8W3nw5ORReB846rhV78uE7ytzXHQ/feH37i+/DEUpjbAr82TBNcb3D57Ll3TrqaXoWMm9Cd+c4PiZhyMFf1PC8PKjz2jN17UnqN9+tYqI/lTcL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090097
X-Proofpoint-GUID: 9SIiYS_bE15gl_mkRBJgW-25o_osQ_tO
X-Proofpoint-ORIG-GUID: 9SIiYS_bE15gl_mkRBJgW-25o_osQ_tO
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

imsm now supports write-intent bitmaps introduced by commit,
fbc425562c57. This new test case performs some basic test using
bitmaps with imsm.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/09imsm-bitmap | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 tests/09imsm-bitmap

diff --git a/tests/09imsm-bitmap b/tests/09imsm-bitmap
new file mode 100644
index 000000000000..447662f2594b
--- /dev/null
+++ b/tests/09imsm-bitmap
@@ -0,0 +1,18 @@
+. tests/env-imsm-template
+
+num_disks=2
+size=$((10*1024))
+mdadm -CR $container -e imsm -n $num_disks $dev0 $dev1
+imsm_check container $num_disks
+
+mdadm -CR $member0 -n $num_disks -l 1 --bitmap=internal $dev0 $dev1 -z $size
+check bitmap
+testdev $member0 1 $size 64
+mdadm -Ss
+
+# Re-assemble the array and verify the bitmap is still present
+mdadm -A $container $dev0 $dev1
+mdadm -IR $container
+check bitmap
+testdev ${member0}_0 1 $size 64
+mdadm -Ss
-- 
1.8.3.1


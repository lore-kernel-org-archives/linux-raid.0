Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5884DC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:37:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbhLISlD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:41:03 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9814 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229446AbhLISkw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:40:52 -0500
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HfjAE028298;
        Thu, 9 Dec 2021 18:37:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=AYygjpn4C5CwAqAY5nG5I2lS2mlevIxsEoeDThV8DrY=;
 b=hNwDx7zUIKuGwSgvuSJjEzg9oEduXOWU1qM7fykmILB7OlNuJrR6OtPKH0cfa0d5psJ7
 FwINChi07umZ13dlge+rrVGA3emt6rYtqFXHDtbOXmpXhHKNIhwXk4K0IPHM8ewKsfuo
 QbWFGLB2Nf6Xf2CKSx6osJBf6vxwVNj7yJWjV2pni14oHas9AEDzwSa821TIVG+jUD7G
 yTk3MeOtr/kWu3XTqU+bvV0YgGs2CF91MNd19TGG7wUtoBV5gKrmayDyQGKFeveRXqw4
 Mdn3Z+cv9HOXwaKvZF7gsxKpq9SQmrL2cAx0qSTE9JFoupfZrPQOXOQaRV41skaVTorm ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctse1m5uy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:37:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9Ib4At084455;
        Thu, 9 Dec 2021 18:37:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3cr1ssx3c0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OHaMR7jFt4hGi8p9sdffgayYJAOP9Mn8bg60M+xbSXMSua49QIdl9XP96FcXz/hFfye5miCGk8mMCJofldqhYmzE7AnyYj0N6hW23zWeMDOM2L/eISOMPgXIz2UvhNxawMEH2NdcNeqpTWNpepIaiOoM/AcAORXPDC1qhNKUtQ/UCGpGuiLwWIrTC1JgO1FTOjLVI+LnhiUh2yzwLKsVqesOmM7RAbRwfythv0cnPCT7SOQAG7GQOLuJCUlGon+XkOTFzoZ6e8twPZbjYfmZOt6fYYHqR2u8KeRn84Yg/Iu9XAX21q3Lov2eVdt2HiL9CeGiTiaWEQ4glliu1pZPwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AYygjpn4C5CwAqAY5nG5I2lS2mlevIxsEoeDThV8DrY=;
 b=OTL4ccYmr/HOi3EG87fYgFrXMd6zqL8b7/xntywNshpqpNvxX/OR97kjvKJCHp8ePtueQbVKWl7LJ4ZziXPiQnoRmQpTTo7VZ2rSYhHS/mVhZu7b7uUeZcdwROMzb0p0YEQyO8xp//ei2JultaavQY8xO7AsEjajwBXQVFoNpztS24WOt2Z93FTOrrjPcVmYgr6np8GcIqsSGAMeEqcGAu5aMcqnlSD0orBmoiiaNj1TZ85PbBCzXMQxN5aAFIXo8ZnOpTqQZ8PmS1NvZq7/quIvBb8Jmyi/yW2QStNe6RYQVcwFLHyvW0k2wJC0YnQ69bPnECDYmnNDc93OI4xzWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AYygjpn4C5CwAqAY5nG5I2lS2mlevIxsEoeDThV8DrY=;
 b=XNMv68dlA2iv5QYoEOtZiXSqC5RdYy5TaN3ycD4sLk/eabQ9LJYusQSOC41+hB8kuLiGb21pMEKZI5/VESb6W117iqgoIFkCystY8ipL13CWmRTzTHs4626SQFCc8N/XgH/okJTwx+9cNKcDihChmP35nMkLypDu1gXGPgAUK4k=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:37:11 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:37:11 +0000
Date:   Thu, 9 Dec 2021 18:37:07 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 3/6] Revert "mdadm: fix coredump of mdadm --monitor -r"
Message-ID: <20211209183707.GA22371@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SJ0PR03CA0116.namprd03.prod.outlook.com
 (2603:10b6:a03:333::31) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by SJ0PR03CA0116.namprd03.prod.outlook.com (2603:10b6:a03:333::31) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 18:37:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3bb7e80-87a7-41be-c28e-08d9bb42e96e
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB16558BC51EFF7EA9FAC2A1C7FD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zaG7hbJbxCx8vvQZYghZ636UWHZOBCJFdeAzWXua+LhyN5fC9JmB4EAoR3jgiJv16CvYsHGpVU2nO0E31m1/9aaRwXEDW1qBeKfy8aKCxFsFvBCHFyDkSYZG91SqbxwQiQFfW/cm+iMKCcDJt9tRdBin3BxZDpc6jm6WkXpTBJSjWiqV/nMgXrNxD/6GA3SdYICStkcnwpdOpJ54OjNPL0QQmCD/tmSVNQ+u+MSKmep3GEJbHPl6+PZjeNwq+qcXdiEKf8+0UHoANx7SmwrAJQvJR8QgdxwSvamoZZc5lptERdFTSlvfDZw3uKYvB2G4JjrW1Rc9wxoLXo0ZhEw0vBFNwYsSnHlY9adrUUIArti9IAYS7JbWb5oyGjZS9/fKzuCGI8PKoNM18650vJ+SRJdMUvY1qiN50+vf83BlwszvcI090aUoMDpR81HgSemLc+v5r/DuhMSomqFjdoE/z556JaN8fk8afKaQn+rXBqyZ10m7h0JXC1r1y0eCvROFcy3ekTynWsXKuYgtO7+Ih20Vad8s1CA6DHvIyEwAqXuueNPtLkj8ZuDfrBF6CGv5nbl1KA+F0DZ1rkcFKbgF63JQjd7nuviUBSlcgxrg6BVe4qJsRYdxao2ubPhjeaIAoQmb+xwPvvhwqCW4BiPP+rNlLFfKjio+tAfaO0e83xl0UGvndrGcEP1PQ4qO/JOqhKeMVFKS58fIFtnXJYPXiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(6666004)(86362001)(83380400001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?b2IPExgEZadlbPKcPwuw/G79G0BoCneNhwe3AnlQ9jkfqEGzpAQlGVSgPfCy?=
 =?us-ascii?Q?57jgr5QBZpWGJAYq8pUP33kT1P8A9KozVyq6avYhMUQ0UT6DOCmUz4aMQXco?=
 =?us-ascii?Q?0TGLJbB90dCsphD3aU+t5RnQiHUJ9H/Rbt45mg+onUd9FLYN5YFEcmkLd0Zm?=
 =?us-ascii?Q?15MOQZc8pUFLqb8jVagICSinzSOJmmDirWrWV0BZx6R4oZHy9h5E/o+UF320?=
 =?us-ascii?Q?4B/M6qje73jR6MsJb8Ik5g4OyTIv0rUQ+7YEOh/0KmlZk6waLH/ZDbUnnvJ8?=
 =?us-ascii?Q?9B5HH0NDurvTPG6CPUNd1SpAGKSaNLqQHG+xa4d9A2ooeSvgt80g+nv2Hz6Z?=
 =?us-ascii?Q?5/gVjaJxz2PAGxG1RHIF3G8MC0CiiAHfhMu07I1j/wbisyOU3fW3+prf+I+Y?=
 =?us-ascii?Q?/UGTAt/heIco1h2ObuOubsn9nDjhlhQNmEmEbKOkOuOG6EA7IcIYT36knqPn?=
 =?us-ascii?Q?nfmWdpzMEhswG3l4v4edPOYoYKSC8Xb2r9udOeS0ZaApCvEpt7cdi5FFx+oG?=
 =?us-ascii?Q?ol7H8vadZMUdcdnboSPXKhAxZdU1ub3dHzM0ALjiF1UGJtcQ1ApJVb3s3Ppf?=
 =?us-ascii?Q?B0qz+AuR/7cZhAozDiVZ9pWKJU6jF5D28dL6ISiZtn4QEhsAZaaeiIS2ALFI?=
 =?us-ascii?Q?HfeEZ3CQWZmbBmHgYiHcJF/BA3yXl+ZNtXuEOpuXkqxacbenUWbr6Nd2dYSM?=
 =?us-ascii?Q?cf/ZRcgEYwdqmNYGfF/czt3agprcLL0ETWRizC/3ig8pELWblPNUN3P7aOej?=
 =?us-ascii?Q?IDE2YMunhtjl5BgVcBhlA95nzSDTXCTinX4nDChgiV64XDiDXunR+q6z/kvJ?=
 =?us-ascii?Q?Et61le3rEgx+z60SDq9r2Jch2OV6UadpLJ5RdLKY1uW2B1WSsSK7quvZITTk?=
 =?us-ascii?Q?5w5EeiEDrTBdclSSIENY4I+Os6x+UrWCTdLF+HgjRGwB2gOe2ZH2Dhz3HJBj?=
 =?us-ascii?Q?5UInJu1ge7ZH7qyLZDWfQwRngd93RTIfSgnou4g2HgwUJrmBYs9DBpsYTXQr?=
 =?us-ascii?Q?LM0NBnd426meQI22Xq7raDWQ+CZ0EHOkZ+0FE71eH2EvbnLB6aBEi6TqTlKy?=
 =?us-ascii?Q?NWlB7BMffUZiBwxLllmOHW94Na2SGAqfAGJLVle1XsnynuO5koiy7/Mlm7Tz?=
 =?us-ascii?Q?mtP4ioRdDqgXKI1aSnSr2EVFZE3WD2pV5ryj4goSxY0A9oZi8Xy88J87ZsWI?=
 =?us-ascii?Q?pbQpxqLJYFoOVXRikV8kKNjaFfv2voj27Ui3twUMhmi7Ym6D6mDKGY3Sl9D7?=
 =?us-ascii?Q?IAGC58AI9OvsT1OR9zr9BXbhq8eq7ntYEvgauUSslwQXPE1ZDJOwXjkWC9NF?=
 =?us-ascii?Q?M//Jh0OTORX/L7vqEDLJWLNC5NlqsknT7jhS0tXHQ3JdpXTaSeYByV6vWama?=
 =?us-ascii?Q?zIUlTp2Lt2Tq4bLRfrGfI8hT1n2onQw+9EpGWBnLiXtDO56sEcjOd+6Kx9QB?=
 =?us-ascii?Q?pYBsiv9o84i/hQjCC3MX7kpF8o2pyV9hSentRJMjBRw+cxzbNHX9vYGEwKwo?=
 =?us-ascii?Q?fUXfGo4mMdLRF2A89uviZ/rw0lGcV4vJ+qMd23BbSdK0EVoOb9OpOvWNj4Hm?=
 =?us-ascii?Q?2VxCfjJP4tAASqxcnFN4lLs5mzz21D0eCLYHHJHBZ41/PPGEpJbJAaT1+dd8?=
 =?us-ascii?Q?v+b6hEF9Ay54wBaw4rgaVYpA3kUOPS96oTutOI7U4Hh3vKdVRG4gyCvgbmqK?=
 =?us-ascii?Q?McpSBMcc6Z3q7eVq+wuZsBs6JFOikYGE19e3G7taWIo7pH4RYLhyJ/t9TqJb?=
 =?us-ascii?Q?U3d+oFxweA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3bb7e80-87a7-41be-c28e-08d9bb42e96e
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:37:10.9627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YEqh2W0edpuRi+oRNoWUKt6mgNH/hdRFxSWULId/rBfjgItsO4RKblp5bIdddCYT765lIwwX/5unrHa+A+vWcmllSrxIk3AzWQSCbmUklPVrU7HmKdxXHJxgDmv0o32e
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090097
X-Proofpoint-GUID: 7rt_isTi3OUsAnxZhxptW-YYJrOCmSsX
X-Proofpoint-ORIG-GUID: 7rt_isTi3OUsAnxZhxptW-YYJrOCmSsX
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 546047688e1c64638f462147c755b58119cabdc8.

546047688e1c made -r require parameter in monitor mode but this
inadvertently broke -r option in "manage" mode which is used for
removing devices that are either spare or in faulty mode resulting in
some of the test cases to fail.

Reverting 546047688e1c is safe as the core dump issue that was fixed by
this commit is addressed by 60815698c0ac where parsing failures are
handled better.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 ReadMe.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ReadMe.c b/ReadMe.c
index f581e1e838fc..a88f4e5d2e3d 100644
--- a/ReadMe.c
+++ b/ReadMe.c
@@ -81,11 +81,11 @@ char Version[] = "mdadm - v" VERSION " - " VERS_DATE EXTRAVERSION "\n";
  *     found, it is started.
  */
 
-char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:r:n:x:u:c:d:z:U:N:safRSow1tye:k";
+char short_options[]="-ABCDEFGIQhVXYWZ:vqbc:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sarfRSow1tye:k:";
 char short_bitmap_auto_options[]=
-		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:r:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
+		"-ABCDEFGIQhVXYWZ:vqb:c:i:l:p:m:n:x:u:c:d:z:U:N:sa:rfRSow1tye:k:";
 
 struct option long_options[] = {
     {"manage",    0, 0, ManageOpt},
-- 
1.8.3.1


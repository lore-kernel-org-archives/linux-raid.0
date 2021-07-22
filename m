Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F6D8C63797
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:27:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51C1A608FB
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:27:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbhGVRrG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:47:06 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:60320 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhGVRrF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:47:05 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIH99F016701;
        Thu, 22 Jul 2021 18:27:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=o7JKckCleKeoFz6EOL+C8M4/quPVmTP68e6ormTNVB4=;
 b=t7q8S4K05s91fHXOd1GQYp5D2g4fWyFvMuP5NXHCEkZSuhZwKJop8wryNvZR9Xv9VOAM
 k9VmjTbcYwRNwVFNVCCfeEPNNrEZWgPnGRUtfI5e5MYGWBfDcpTda1CUEjZv5eyQdsZm
 hdUZWH9/VuvgXG5HkaeAKCCPDwLCdjaXmdezJky2tvyEBzxn5wCdKm384cJI4+x/blTG
 bsoG3Ti/3r2ehr4HyGWCjmq1WIg5yjJhdFSdn9GC7onZvi6Z5bfAWWS05+GneXrjR9K5
 YpG33q6sDBMtgGO7QnAk/P0ufm2jG216NF4WR5FqR38YxiDQjg4I9jgc8x/Rfv11Q3ft kw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=o7JKckCleKeoFz6EOL+C8M4/quPVmTP68e6ormTNVB4=;
 b=hSarb0CSLroC1fofS9/lwzh/sG9LJqT9guRXpW4C8BM1Alvro7N+MuuBfUbpYo0X0Jmj
 3Lj+tx0t3edIEvahoKbZ+tl6pXzP8hkAuqWjRYt0QI+/dDRnHXWQ/iP40kOIDC1GiOyO
 U9jSvjbu8UNp/ay31q21JLodrk02unCtpX3fzszj6midO1s19Cpx/kIutTO6hwbCQD8k
 45iB2LyWXu4PLbcGRWZFDJVlPNRQO87UiuWynm07IXwbHQGxa44+HRPmEewq9ngMXZsQ
 L26SM+o9RMXvE5mg6SatASCbKFAJ6/eOPxfNb9NQGOWUyXqJmtS8zO0igOJr5rvZjKFp Fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39ya578q6b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:27:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFFUx167796;
        Thu, 22 Jul 2021 18:27:37 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3020.oracle.com with ESMTP id 39uq1bpv4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:27:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dgc2LfqlC0ba6vOdaDj7T0/lEvQ97aPTd/u8gncYgy0eLUBjyhYN5xq3BYIAAtj6qqbKJAb91Z/vtaaehXmYdXRarNSxpVx75XmyEW63eijg3nRiL7MYqmsnBJwYSgpSzRVy32jwkJGniZy2P8AjrmhCiMjSd46I9NF8T8zlcXvJiq29fZs8kOqHqGMLCQmYC2QJ9QXJ+dOjI/4UvaOMDNg82ilqa9bkkBv8t61Il+GxGDPZx8UpPW3VA+qHsZjK7KzREoMQLX33yV/3cM4QQhBmGprYCezvW/W1KEVX1W/WDCnlPuUwtS+NWjBWpJ2C4arsryFPjGGzutO/XSmu4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7JKckCleKeoFz6EOL+C8M4/quPVmTP68e6ormTNVB4=;
 b=FO3Lh7XYIMJF4jMClgsMJ2UMMRXS+YgrazN9TCo2ATjYMRPSIiD4eTiwbUquJmCc0442CnXPPVCnqZhXLvJHGSCkaVo5c0AGsYyjb1KSCLUHADA5FX1qEj+s6XpuvhAn2UATvwwY1b/SzQIFj5r2RmvhV6S3NUL+GT41Hdio6ShRMy5PICQkVKUXVIx4owuSI2ISOp6E2AH5PMF2k6R5WyLkwJDvIIh+2/zP7DBu2Ab6Eu1ppHb37pESMOvPS5Y/xPJ3Ohl+on5VgWtGldG16OeJs6wTZo9CZOOi32kilDIw8NkcZCi6I7CWb3bL8PP9LfToLQ7CJp3R1gzpPjsWoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o7JKckCleKeoFz6EOL+C8M4/quPVmTP68e6ormTNVB4=;
 b=X1dCO5Kv4ysdTn7VkMYiUkM9zuhZoK8fLftcIoygkhYmJ8VmV6rqU9OCSQl7u37QyUzRte4zweHFSKhlYvQp9ZxBvWo6FVlyxj6KI1yDB+gOH2q4A+ZsmmlGsCHb3mLJORN2FvFPKIC+oMDCjTMi539pV5CnWcauSr3ZFK5D2mg=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1494.namprd10.prod.outlook.com (2603:10b6:903:26::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 18:27:36 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:27:36 +0000
Date:   Thu, 22 Jul 2021 18:27:33 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/5] tests: remove raid0 tests for 0.90 metadata version
Message-ID: <20210722182733.GA24996@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN4PR0501CA0155.namprd05.prod.outlook.com
 (2603:10b6:803:2c::33) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by SN4PR0501CA0155.namprd05.prod.outlook.com (2603:10b6:803:2c::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.7 via Frontend Transport; Thu, 22 Jul 2021 18:27:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ae87e77-b1df-4975-557c-08d94d3e60f4
X-MS-TrafficTypeDiagnostic: CY4PR10MB1494:
X-Microsoft-Antispam-PRVS: <CY4PR10MB149442AAEC1DC7E4743D2C88FDE49@CY4PR10MB1494.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R2MtJzcryQtW49M8ezh+O0C1VRG+P0aMh78zUYw68BCfR5X7G7AaaVOaAGkZbSumRhEWTGR1gtK5ciEjNsrx44CuitolnbYXdrIO3/Qgdz51sHme9Qo57mF+nMo5i/fHmIibOsPvUWgj6nq4fP7viSG+k/rOYRpeh/MBldbvxeedMFYP9A6xkjJVwiLjPAB3f9USFj8mF2y3pK/M6LV/M2x7GyDnaiwonRUU1BR8S4JjjQphThJtQt47zZjtWkCNACwgpILMYAfIyDaYBxcUKLeZQzJ2oy3M7RjJ696puTlqzG5J+nKoORZUBjPSbWl2kEybnir+efg7DxYqJl8BcaIdLe/oij72A711609B/zynBFYZcTIh4sNlhDgy4jZ/h+7KhQReVLm0PbU2ngdnmXhyFsPo3NAtugkx2hHGtiIEMRlxXpvGXTG4sRD/2Ey+xCx3pJ5wZVP50ZzoWaNRQZWFp4vHYJwZqJ1xDUWHvd/FGz/rEOjMMFBtDLis8nIJTrm3JOtWUyCVeTOy8KW3qQA2id85E5S0E7oAtWNBhmR4vB6WqfAvyKzg4gpH/pa40o33ybZponO17Xw0DPvysWlUAN011QeEwm37bZtypRj+D40bAOzYzO2fIDEFdyaB/Er17epv07wygKOkb3Knat/sX8pFNuBrl1SZ2V/wY8Y/uJkAuVWUew3bLgASzDH6d3MOF+C2Mr6V8IP9mnOKQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(366004)(136003)(346002)(4326008)(7696005)(83380400001)(6916009)(52116002)(8676002)(66476007)(8886007)(66946007)(66556008)(26005)(5660300002)(478600001)(36756003)(33656002)(1076003)(55016002)(8936002)(2616005)(38350700002)(44832011)(316002)(186003)(2906002)(956004)(86362001)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fVKlwQUHbH1uFRtAsPBbLVBOnePUrq9OZpiqK8ps3r4GYcLbzsaW05bKzF4e?=
 =?us-ascii?Q?apLmLkSUkiJde7HFI87uDQbKkC3n6PxZV2xr00d6uXdsNM1Bh3PlBKAx3Jvn?=
 =?us-ascii?Q?hlrtvLgpip9V5vUyQiqN5eTBf4aAr0k3GhCv/DsA1ccHp7Yp0KX6dg6mWoVe?=
 =?us-ascii?Q?i/asZojWhSgqyoxNRv4/gMASIPRIqfNZtt/m5WgKkpvZ6IIBeZUlNfb43ZI5?=
 =?us-ascii?Q?Tx5hJeA1BADv0VrNjJQ2kbtqRe3xR/ALXAkVt480sWjKMqXwywJW6+EP3D1w?=
 =?us-ascii?Q?qrnIE3bGb4ZeB5+63Z7D9uxb1I0OuDR7Zk88nnt0JSHnVUSI9QXQBQZyA2IX?=
 =?us-ascii?Q?x+gL/vym4cQMq/5cJpee7INbyGC4SzAjXDake1XnTsTljf/rfvSPTSLEAI3N?=
 =?us-ascii?Q?zukFe1tJhCqTqVwtdc7K7AU6MiU/e4QUZjOM3uEi+b/HHzPa679z4xdtQBHL?=
 =?us-ascii?Q?k1YoVnN/NFRI/s4o9IA1TDJpaBKAYvGgh0lo/svnedhtdYjFqjO+f5k9m+un?=
 =?us-ascii?Q?4Aul0scFY+3wKIrCqpE9S5pvW8ckRS9S0bAiVYWzyNggQYgw+YlZo+m6S5GA?=
 =?us-ascii?Q?uPoNXa6DVxgB6WaBgiOoTrD9a01qi00GIvasPkl5qc72mjU/AHQXnx8yhHbr?=
 =?us-ascii?Q?I0G8vtGjjxa8jxR6BgG8zqQmFNNMVA8KZvjQZVdtyEATgd5rY6aGJzpIhpmU?=
 =?us-ascii?Q?+eQIY5pyQv/s6hdXtjTwySPYVQIkyTHWOWoFxbXchcmQPxglw0KHPV0IRBhS?=
 =?us-ascii?Q?HFXms9yeRAlWYMBnMfALJ6Wyl9OIFQuu5ZoqutHyBy7P4aj0b0bXb/LeNx1j?=
 =?us-ascii?Q?+aX/EakdkzPSsDbJx9E82fn7qzND0P70+D87jtSd8ZVPelR8PVnIyYUPvc6W?=
 =?us-ascii?Q?MPySJKZXpB+cAyx7NtyuKW8xHHJOYsOxJSRKWlz2jEbmcGMAUz1wHx5Vw4FY?=
 =?us-ascii?Q?xCCxYtPaipeAbYe1L68l7mousljPKHeU6AKdoQivoDf+QTnmh5ive52MUKaJ?=
 =?us-ascii?Q?C+QBnyU7G6OubdRyoTXfo50QKjn2hBgPGtiGX6stJVcgbl0668/snwh3YfxK?=
 =?us-ascii?Q?pAOCSQbAOG5KtL08wtlAHJs6JXZkmWmFvz9jcl6L7I7gvS5OC4FXluhHPbVZ?=
 =?us-ascii?Q?qJGtvRHgP9NSiQYHRPonIAXYi4ARi9FLMhM/CfhNdNPL3uUt8SLOtecaaE10?=
 =?us-ascii?Q?a+E/DihNVCMQbTBOKTPAIWxreFD+skmH8MiSdbb+3RZN8gWbGdnZT+kWVkqY?=
 =?us-ascii?Q?ZW2H1O8EHv08cf98QoKGWqQOy6XFE73NBa1pLehBO9nDTZG0M//zcutOkrNA?=
 =?us-ascii?Q?VK8icQxFoEBEtENc4zybOx8r?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ae87e77-b1df-4975-557c-08d94d3e60f4
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:27:36.1181
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSoE5FPNebihzKKLkFWKFo983YJpohcEnDlN74cLywP2wBeeFwvj7D/L4rpMpRJlubFNgHoIHa4i2ptdxXMGY3DepM9XxdpePhZ9J+28wg1zqYi0LZvafNLZANOX/HM1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1494
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220120
X-Proofpoint-GUID: SFvZJmCNzQ5rKWO7a8uFjCwZwvUxhQNB
X-Proofpoint-ORIG-GUID: SFvZJmCNzQ5rKWO7a8uFjCwZwvUxhQNB
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some of the test cases fail because raid0 creation fails with the error,
"0.90 metadata does not support layouts for RAID0" added by commit,
329dfc28debb. Removing the 0.90 test to make these test cases to work.

removed 04r0update test completely as it is specific to raid0 for 0.9
version.

'04update-metadata' and '03r0assem' still fails at a different place after
this change which will be fixed in an upcoming commit.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/00raid0           | 11 --------
 tests/00readonly        |  4 +++
 tests/03r0assem         | 72 -------------------------------------------------
 tests/04r0update        | 20 --------------
 tests/04update-metadata |  2 +-
 5 files changed, 5 insertions(+), 104 deletions(-)
 delete mode 100644 tests/04r0update

diff --git a/tests/00raid0 b/tests/00raid0
index 8bc18985f91a..e0b6e325b4c9 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -6,12 +6,6 @@ check raid0
 testdev $md0 3 $mdsize2_l 512
 mdadm -S $md0
 
-# now with version-0.90 superblock
-mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
-check raid0
-testdev $md0 4 $mdsize0 512
-mdadm -S $md0
-
 # now with no superblock
 mdadm -B $md0 -l0 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
 check raid0
@@ -22,11 +16,6 @@ mdadm -S $md0
 # now same again with different chunk size
 for chunk in 4 32 256
 do
-  mdadm -CR $md0 -e0.90 -l raid0 --chunk $chunk -n3 $dev0 $dev1 $dev2
-  check raid0
-  testdev $md0 3 $mdsize0 $chunk
-  mdadm -S $md0
-
   # now with version-1 superblock
   mdadm -CR $md0 -e1.0 -l0 -c $chunk -n4 $dev0 $dev1 $dev2 $dev3
   check raid0
diff --git a/tests/00readonly b/tests/00readonly
index 28b0fa13f815..39202487f614 100644
--- a/tests/00readonly
+++ b/tests/00readonly
@@ -4,6 +4,10 @@ for metadata in 0.9 1.0 1.1 1.2
 do
 	for level in linear raid0 raid1 raid4 raid5 raid6 raid10
 	do
+		if [[ $metadata == "0.9" && $level == "raid0" ]];
+		then
+			continue
+		fi
 		mdadm -CR $md0 -l $level -n 4 --metadata=$metadata \
 			$dev1 $dev2 $dev3 $dev4 --assume-clean
 		check nosync
diff --git a/tests/03r0assem b/tests/03r0assem
index 6744e3221062..9df7ba6a7613 100644
--- a/tests/03r0assem
+++ b/tests/03r0assem
@@ -63,75 +63,3 @@ echo "  metadata=0.90 devices=$dev0,$dev1,$dev2" >> $conf
 mdadm --assemble --scan --config=$conf $md2
 $tst
 mdadm -S $md2
-
-
-### Now for version 0...
-
-mdadm --zero-superblock $dev0 $dev1 $dev2
-mdadm -CR $md2 -l0 --metadata=0.90 -n3 $dev0 $dev1 $dev2
-check raid0
-tst="testdev $md2 3 $mdsize0 512"
-$tst
-
-uuid=`mdadm -Db $md2 | sed 's/.*UUID=//'`
-mdadm -S $md2
-
-mdadm -A $md2 $dev0 $dev1 $dev2
-$tst
-mdadm -S $md2
-
-mdadm -A $md2 -u $uuid $devlist
-$tst
-mdadm -S $md2
-
-mdadm --assemble $md2 --super-minor=2 $devlist #
-$tst
-mdadm -S $md2
-
-conf=$targetdir/mdadm.conf
-{
-  echo DEVICE $devlist
-  echo array $md2 UUID=$uuid
-} > $conf
-
-mdadm -As -c $conf $md2
-$tst
-mdadm -S $md2
-
-{
-  echo DEVICE $devlist
-  echo array $md2 super-minor=2
-} > $conf
-
-mdadm -As -c $conf $md2
-$tst
-mdadm -S $md2
-
-
-{
-  echo DEVICE $devlist
-  echo array $md2 devices=$dev0,$dev1,$dev2
-} > $conf
-
-mdadm -As -c $conf $md2
-$tst
-
-echo "DEVICE $devlist" > $conf
-mdadm -Db $md2 >> $conf
-mdadm -S $md2
-
-mdadm --assemble --scan --config=$conf $md2
-$tst
-mdadm -S $md2
-
-echo "  metadata=1 devices=$dev0,$dev1,$dev2" >> $conf
-mdadm --assemble --scan --config=$conf $md2
-$tst
-mdadm -S $md2
-
-# Now use incremental assembly.
-mdadm -I --config=$conf $dev0
-mdadm -I --config=$conf $dev1
-mdadm -I --config=$conf $dev2
-$tst
-mdadm -S $md2
diff --git a/tests/04r0update b/tests/04r0update
deleted file mode 100644
index 73ee3b9fed91..000000000000
--- a/tests/04r0update
+++ /dev/null
@@ -1,20 +0,0 @@
-
-# create a raid0, re-assemble with a different super-minor
-mdadm -CR -e 0.90 $md0 -l0 -n3 $dev0 $dev1 $dev2
-testdev $md0 3 $mdsize0 512
-minor1=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
-mdadm -S /dev/md0
-
-mdadm -A $md1 $dev0 $dev1 $dev2
-minor2=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
-mdadm -S /dev/md1
-
-mdadm -A $md1 --update=super-minor $dev0 $dev1 $dev2
-minor3=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
-mdadm -S /dev/md1
-
-case "$minor1 $minor2 $minor3" in
-  "0 0 1" ) ;;
-  * ) echo >&2 "ERROR minors should be '0 0 1' but are '$minor1 $minor2 $minor3'"
-      exit 1
-esac
diff --git a/tests/04update-metadata b/tests/04update-metadata
index 232fc1ffff4b..08c14af7ed29 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -8,7 +8,7 @@ set -xe
 
 dlist="$dev0 $dev1 $dev2 $dev3"
 
-for ls in raid0/4 linear/4 raid1/1 raid5/3 raid6/2
+for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
   mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
-- 
1.8.3.1


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 512E5C433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:36:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbhLISka (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:40:30 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:19562 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhLISkT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:40:19 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HnCLl007294;
        Thu, 9 Dec 2021 18:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=ihjALBbMi2nb6y59QrLOTqkSvfgiHeBGeGH1Pcczejs=;
 b=sRfshucxyLIN+QRs8Si71tP9pyQk7p7Lttu7fsYAeCj879ivlZQCTFKxb1Rm+MOhzmgC
 yoZFwu7bRzzb4vk+ow6j2b8rXiBUqRYlbbKuTbl+oZpJIAzwYLt4lG4IcfgzlRD5Qvol
 9/5K4qaKWNz1xcvtFHf3UrNXrv5p+4gw0mjYpaVgxFUdFho/t6F5g9r1dmNU4Q5BdNq0
 lGalaA7nskOZdRgKHJ03LDswzRhucie41m5vNR7G3AyebY0M0NGdhTUneraLqxOfHBki
 sMHR7ZAuyvJC5lt/J8rGSX/6uMOENsID8p6z0wvNYAeWvMJkhqZmPzsIaz8ZEmkt+Ubd XQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctt9mv1py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:36:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IZXXg036653;
        Thu, 9 Dec 2021 18:36:42 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2171.outbound.protection.outlook.com [104.47.58.171])
        by userp3030.oracle.com with ESMTP id 3cqwf2khc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:36:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr5gFNYoS7sckFvZSrVdRZUrl97UMaK8Af0cNt/oW6M9nB0qT8NjKhBS1lKkXqw5jr7HrEIoEJG2biJIM7FuNMsTvuzikP8Oe1aq6tRkjhaJl6sRfcaWhcPx4mTXLYvIcT55CqBFmIUyTkVchGOgQh4ejQmbW+/auVnGs+TkxRhGB08Id2Qacyqhvsh/SF7jmyvAMAeVECg5oJskbY7r7yBrB3+b+Jk6CEE4Gxvt8p9C0EQKInqa16blhkS7edht8L3S5JWMF1WapD1UHvhk1VqwrVwsVG5CYp/ZHkJs+92nkIHT4TcMuwrnDF9QS9I74IFspz04VaTsF1VEQdWEDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihjALBbMi2nb6y59QrLOTqkSvfgiHeBGeGH1Pcczejs=;
 b=ibAdE/NmPiHrrGYV1vPgxPVBmlFqu5Hmtz+ufcGpQD1UgW96WEArP9DL9y06F96AEoWQexCtG6aOG/7wcJFx4fshnmFpQK8muOuSifOhtFmGALTDh143Q3HIz7d6fATEVCQVeQxjXv3B5qd5PLjQk2rfre5Jc7/spf2SLc6ZEbuQ5WuQmFxSCxOBIv9vT0yk0mkOpes+tF3Zw17+NMjAbgSil+ANtHH/YEf2p2uZcQxnKJJTGwe15TCaVzyC9MCunha67s+Z/qQNbyPzY0792pdFT35Y+Texg2BVD2n0S0eARHeNYI3z2GgcuWcs7bhioIyr4oQMCTosqmwsHDiAew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihjALBbMi2nb6y59QrLOTqkSvfgiHeBGeGH1Pcczejs=;
 b=rS8rLDFSKt5lKjiyXcqrZAR/iFtTcWyCwRwhDqimy5mAHXb02ZSb78ax2Fnn1+1eD3I5EJy84DjupoSg7lnHaVYLF+7NY/qMfeFOH27+k+9uTn55HswyoMq0Wsi7GW29BCgwxWH37n3mUOMOWOxRoj4iSmaRmC+Do25v6WGPAmc=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:36:40 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:36:39 +0000
Date:   Thu, 9 Dec 2021 18:36:36 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/6] tests: fix raid0 tests for 0.90 metadata
Message-ID: <20211209183636.GA22213@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: BY5PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::15) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by BY5PR04CA0005.namprd04.prod.outlook.com (2603:10b6:a03:1d0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Thu, 9 Dec 2021 18:36:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd3b5db4-2de4-44ff-ba11-08d9bb42d6ed
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB16550B3C30EB4EFAAE8FCA7FFD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:660;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0IiO/GZZVhNu92MKTGBz4quF4aoDaahZctTg4+B6Q9AyOyUEsjkd9s6MNFptk2efoihselesvPBkraMEY+1Psuh6zdragx4ZlzQ5qMJJoW9zSEi7+TdLpipoHm7WQdkrve0Aho+X1uomMY9GeGSpvG3ZhXEwNnvRJgz4ivq7Th0maNaihcukI09gvmlEehxjtjD9jXBbvT7+kj4x6LTC9tee0lZgBKC9uF9IE4cFWsYTs0qxASGMFIJfVzQt4+DyHhGaiXjByTS0OjmiGIbl01Mdw9oawtrTBPFgklwg9b+BE6eSsQUe07Kqer/Iz7qqA74USk6jX636AUBwcURvQeg3doehuZg5RhpqlLjakDWmOHp7kXax/O7tviCZwBsn3xZUyE1TUd4B1f5RXy0nCBIIupxQcZx9rG8uz7gto6Ug0W7EYZJx3QzhCE9GSpWshe3kE4cbVI36Ll8selNvZKdYLqcSGC8qYlZUOPB9ExCvBKiAgJ021SI0MKnubiLJPSQbyq96f/9CKoHk+v4kZ3lqADcyxJ7Ct/IoUBD2LErCB3AE/JThCWGIv+tpRn+DOn5Azy8AX9R/rHLU0WbuGvrumMu5xtbOWVqli+0ipZRMzUPTDCGB9LxdNMA3kAViu7oxXIHoePdxauuyGPjN2K6VE509iILaVeW7U+hqOPvNUpk6fQh4z//aULtLVg5AoVNvrEdro7j+R5VfmJnkLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(6666004)(86362001)(83380400001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c9bqhTUHqi/TdDyjOC8JyEdNLMvvUSBXwE7vSX4uV2xW0l594FIJz+V0pAw2?=
 =?us-ascii?Q?BdrE7Il54JlJdAEZNEjUU/7/r/cS5vGpgjulsyIJ2cDMy+N1uZWLTs54DEyz?=
 =?us-ascii?Q?s8I5DH34MZdAn0QTqU6vpm/A1dy6vuj4XYrIUxzkjCj/U6cZ1ZiTDyIHPNFa?=
 =?us-ascii?Q?6ZVczOmMxDMtn1Q0a862Y03HqV8PEaxCc0sxY9j0b8FSOwrIlQcAOJBfoIsi?=
 =?us-ascii?Q?2xYuWlMt9vt1wryEBIEH/EndO2Okxb+AUvu8MDK5JXpk6XNloYaODBqjyd08?=
 =?us-ascii?Q?KI8FbmvORNf8xK5E7YN/lVzEiFtDi6tlL/tHbwR2OptFDzRi+W6sbu8b7Gl+?=
 =?us-ascii?Q?HZtMqbW7Si60MqXweDo5/Pz54IMqrymjR/wtkAf+6xW239XSV6f+OMQyl1FK?=
 =?us-ascii?Q?AVNHA6fXGCHbCpJ17fikyut6ocBniP8RKBM2X3Qb9JnVc0asbGVx8BdX3Nbt?=
 =?us-ascii?Q?8LPcTDxaKUSjS4kQVbGyMAVXIYjKRlUVXAvSkvMnqoI1APgyYu8kUfMSmEHO?=
 =?us-ascii?Q?dB1XBGC7Fy9pfZkUzBATN6FNwqwHDr5/iMLzFIzFmqC1ntnIN0E4KZVtrSPi?=
 =?us-ascii?Q?M3FN8bDkAN0iOa+57quT8v3rR0YyuxdLP8XI84qbMVSxh5Rg6cxvs4RbFDkP?=
 =?us-ascii?Q?HgXrkafase6FROLR92kztJQNeHmAbWLmatXgV31/GjbuRj6FRQhmEHSJlAXS?=
 =?us-ascii?Q?9DxXV34qk7vb5wYNmJ5CkdqMkbHHClADnrAJTZjCC8RRqM5Pgb6bBMsFWqyT?=
 =?us-ascii?Q?MZrh0iiIerCsfORV8R7PMAcE7/3nVEZvBAH/Uu/otkTcl2alusObz+zMwRdz?=
 =?us-ascii?Q?vYsXG+fUdZitgJvu+3YNn7/aVOcTZ6i1eXJebLWKxhcEda57mYPAm3hT2Akb?=
 =?us-ascii?Q?EyOn0r0fqcorFh3p9X5J4Nz5Rqthmt9ndG4Pni1wDIMFYpLmpIsJjw32OOqC?=
 =?us-ascii?Q?yKd56G1U3mFrZkXPL5ujrZbN+H3eqYcPS4zBK0QKs0pI2P4COnkcB4l2aRdv?=
 =?us-ascii?Q?TsWBGKLSMrLA0pKlek2UFKsv3/AJSeatkaQGn+2p6jKP8yhUFadDVTWeDEnM?=
 =?us-ascii?Q?gRAAyIos5YjSwobY35hbfADjDNv3vjJCJPxW8c2H9UctqVRVewhfqG6LkyIP?=
 =?us-ascii?Q?jLt775K2b0reTadhGAfX2xiV5rR8CUhDIRmRIHz5rCnGn9GkLnBuEyVx1EOf?=
 =?us-ascii?Q?B1rb12awL9/l01oHdavuFZb1L63byD7jx1PbiXEdyFttK8NCmBXn2t5lpIVy?=
 =?us-ascii?Q?NY8Vj0qZ1IuzSw1oR/MTPK69brFsK9tEHAF139eRkG/uEskUkzykHkCkQ9jn?=
 =?us-ascii?Q?M5U4pEQtV+33C7ozOLgCBSV2Dig+dT5X4xkyGWAPS+eqH6k9EjlHFVkrvsdx?=
 =?us-ascii?Q?+unOrjnbwKWLBihbGMWu6SlYi2VYB+64T0oCykf9yLiGFTkuk3dYajvkoDWn?=
 =?us-ascii?Q?xBnV4Ezec0c8InJzVAOa0xJ8Z5Y45WraCwvC4XDYtrLneB+R+Zvciq+DPXnT?=
 =?us-ascii?Q?yGd4nWJvFjMyWBZ7zpgGuzryno5AXSgRLg+y9PqPJkta6dI4tM+usMSJ8r/j?=
 =?us-ascii?Q?PqNDHxO0N7hqANXn7ZQi5KVFrI+H8k7P/h3aj6MtdTDosJOOq6TpJTTBDtYh?=
 =?us-ascii?Q?tJMOHNUfx1VFD4FcDGOXqDRkRGhziDgDVYEV5zXdgyUOdR7g3p/lBmnC9pJB?=
 =?us-ascii?Q?uWxLbCa9HutvaiCaen9hjzHlnIMNyv6iwqdsbOGhioW67vVa2QfK/h1bhGrR?=
 =?us-ascii?Q?gnCvahNWcg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd3b5db4-2de4-44ff-ba11-08d9bb42d6ed
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:36:39.8869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hYVYQ6RyJ58FWhRecXTCZjvox+NxTFsSUNqTd+50ExCc/GwS/Qq3dvFtUR00wRM4A1sHjeWF2TTPfhXp7BQ4LGDDTLJb3VUMDyUg5CjM/QlGUfmCdGLzeHbJqw2jRCCX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090097
X-Proofpoint-GUID: -u2um63l3CH4MUthpO_XeV_zimx-DRH0
X-Proofpoint-ORIG-GUID: -u2um63l3CH4MUthpO_XeV_zimx-DRH0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some of the test cases fail because raid0 creation fails with the error,
"0.90 metadata does not support layouts for RAID0" added by commit,
329dfc28debb. Fix some of the test cases by switching from raid0 to
linear level for 0.9 metadata where possible.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/00raid0           | 4 ++--
 tests/00readonly        | 4 ++++
 tests/03r0assem         | 6 +++---
 tests/04r0update        | 4 ++--
 tests/04update-metadata | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index e6b21cc419eb..9b8896cbdc52 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -20,8 +20,8 @@ mdadm -S $md0
 # now same again with different chunk size
 for chunk in 4 32 256
 do
-  mdadm -CR $md0 -e0.90 -l raid0 --chunk $chunk -n3 $dev0 $dev1 $dev2
-  check raid0
+  mdadm -CR $md0 -e0.90 -l linear --chunk $chunk -n3 $dev0 $dev1 $dev2
+  check linear
   testdev $md0 3 $mdsize0 $chunk
   mdadm -S $md0
 
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
index 6744e3221062..44df06456233 100644
--- a/tests/03r0assem
+++ b/tests/03r0assem
@@ -68,9 +68,9 @@ mdadm -S $md2
 ### Now for version 0...
 
 mdadm --zero-superblock $dev0 $dev1 $dev2
-mdadm -CR $md2 -l0 --metadata=0.90 -n3 $dev0 $dev1 $dev2
-check raid0
-tst="testdev $md2 3 $mdsize0 512"
+mdadm -CR $md2 -llinear --metadata=0.90 -n3 $dev0 $dev1 $dev2
+check linear
+tst="testdev $md2 3 $mdsize0 1"
 $tst
 
 uuid=`mdadm -Db $md2 | sed 's/.*UUID=//'`
diff --git a/tests/04r0update b/tests/04r0update
index 73ee3b9fed91..b95efb06c761 100644
--- a/tests/04r0update
+++ b/tests/04r0update
@@ -1,7 +1,7 @@
 
 # create a raid0, re-assemble with a different super-minor
-mdadm -CR -e 0.90 $md0 -l0 -n3 $dev0 $dev1 $dev2
-testdev $md0 3 $mdsize0 512
+mdadm -CR -e 0.90 $md0 -llinear -n3 $dev0 $dev1 $dev2
+testdev $md0 3 $mdsize0 1
 minor1=`mdadm -E $dev0 | sed -n -e 's/.*Preferred Minor : //p'`
 mdadm -S /dev/md0
 
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


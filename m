Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE8DC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237935AbhLISj4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:39:56 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:60152 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhLISjg (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:39:36 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HnEib012017;
        Thu, 9 Dec 2021 18:36:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=KC/Lr5IYjW0CFReUmNCZBWtMzeSDPEQM/e3gq6MxZcU=;
 b=QMzkIh1N9v5ysZwC5gKJyBfjtAbaKwZN6ukagITNas6rULmq70lNiIzbsIzrkuPwTJUm
 SkkrIIjg+zN/+kEMmeDR9yiY/H7mBRGHX6N717S6316NAyNxQGfjiXz4GvM+5Vpn/dHk
 +OxT+0tgTIVUChfSyWuuVDfS36LJXayE2X9Had8hwrDfSXS9uwbdHaWAofWZOtOdL134
 9t40z3kFwlfPetIZg1/J0EsM1oyLyZIE3nU0FeAZRpwn+dw+kE4KN3KCc2YG6cnmuzvX
 WsG6nVpAZugr8+gOglj/2bJ5dpmGxn3PGBnnVzZk/DLePdenWXd4BYc3B7SD/LrUFxqw oA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctrj2vctr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:36:00 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IZk2f147619;
        Thu, 9 Dec 2021 18:36:00 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 3csc4wk77q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:35:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzufHWeIf715RHcnqQLUck8KmHArteaUDd/XrS11dyKXZykYDdis3p8ti1+K4FDBFQ5gM74r0qIPB2/eyQfpNR44qkJ18ktC31LNBgkDWtQ37RpuwTo7wwTRC3xyVObeX5BfOrR+yNnpifnVDcJqKRq6i21NvhSEQWZ4iowq0Hj9+ycSnETGxkOk9HEtN9TM3U/jBakk2sDYmmGcNWmTcUZJ5pLR8OsjPc/heY1Sf69qs5llne3xnxJCYXzSxgM62tUuW/8I5QtOgRb245LRM42/7I5lYG7wyW5YhRVVENnwXk2QjCJyU/4XUb/wCzwxw3g/Zb7kn89lRSftoCi8MQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KC/Lr5IYjW0CFReUmNCZBWtMzeSDPEQM/e3gq6MxZcU=;
 b=HXj8jWE/rGQesi+MYrAfuGer6e3npN+s7/oLLTW9XmNVHCWjiZ5N3YUN6jvguNV6r2s4v5sI0vNYugmZ4ob8RrP8FLvdmg+STq/4TMN26CeHsChMjgnKUVhadGUBIsUYSM790wXaSvij0f6Ejn9iEWxwZVoGIezA1JTw1tWdbgNaPE8zBq/3z7LdUOr4Jq3dKQVGQn8d8WjYqRLXiD5/kS6K7IqN9oElIvUhGqW0WsOQgqYtmgqkY6hkIopAUr9OyGC3pmnf3hB5gPSMPS942KzYKkJV0QzpBmU7wjMuImQxNRoWhb5gCpPB5AKP77qBpXvv4eg+mFn3bx2ghQ8VHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KC/Lr5IYjW0CFReUmNCZBWtMzeSDPEQM/e3gq6MxZcU=;
 b=YkEpsTIUll5xXlCOYXMq/xs6Eb/amLMwc50McEeBkHo6JM/zqTwmAz0cz4ctJSZ8fC1D7nNejMwR3KPb4l2cvSeGWhKQEsFQ+YvDFESYHs0lekK892t/DP51bU3zW2qgXM47+5YqxqehKDF1nniGq7x8qGF0Ra4hM1ZTFNUMYLQ=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:35:58 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:35:58 +0000
Date:   Thu, 9 Dec 2021 18:35:55 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 1/6] tests: add a test that validates raid0 with layout fails
 for 0.9 version
Message-ID: <20211209183555.GA21968@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN6PR16CA0058.namprd16.prod.outlook.com
 (2603:10b6:805:ca::35) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by SN6PR16CA0058.namprd16.prod.outlook.com (2603:10b6:805:ca::35) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 18:35:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b74f3828-93b7-4f37-f275-08d9bb42be19
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB165562B0FEF17E029BB801A5FD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wC67NNaxEGfAP+NFMPEtlUk2Zuto/ufNOpSs4o1yvqKLl+unHmmqCrP/U/kWnqtf6HQu0uBQsDvHpZpZEuSDWQDJ7GTZIZ+H3LqJqL8CkNQWMxcAzGVuB9fwxfNu7qhRN4RTV2V92YJvMD3VgFq1bVyztiWY8ugA8THLTqg5QpX7HLwUa6LXXPMZhwRhkPSAXkoOv1XglCvmE70/aXwd8de2n3uT1SuExZNemLJTZF76pmqtDb/iqsn7PZMuQay69TlLx8Hr2cA3N+n38elNsr4+zNixjA0zTNtRqKkpXqJJ94w9jfdLm1d0ZQZHBehTb1c9YjOQ+5zFENkJfIYfkRa9jLDzEk0nxDDoPcQHWjsyCwVlhhO13XHrP95qMFqxtWrOH1RD/gvnQN8V1S4DUslJTvZEuWE9dVVw9/KW8Ra+O3LJj92Ve1zaLeE9TRY9MiPuOh1IAt1M+k8HMDyiuIHAoNHBG+Z1Ep3fW29YmaPfh0FvyI/jKFXNdwLgD6MnaZsHix8NJSN66lnoGnW3knYevnwgxHUPmR+zbrFTKgfplMrZIPyRQS9uQf7T6KMoGo8F8JvIL7n0htMmuTWswmC4C1T7g4On/6N6wNrHJweZCGFvW/KugjWl4nQHTGXCoNc6wLhSDH6bF8C3DhXa3jPRffZhYx3n0m6HJ3eu23n5WbhExKr/pKBIN+caw4D/nOLYIbjXeyAjNwnNaxrGLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(86362001)(83380400001)(15650500001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(4744005)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6BxetWzBf4UChe5BY/fTBCsUMazJuIVR86up3kzidKYfNggXqv9hyRIzUeUr?=
 =?us-ascii?Q?V9iZS7m7c6qvUxIGms/H/72GA/7/rBB8cV22+XEb8zlu6fmWCIgngLAVCgYr?=
 =?us-ascii?Q?9t21r96ckDG1VJkRN49HltH1MBpVzDcdCoMn6sTAYMZeub5CQ+GjnYgy684R?=
 =?us-ascii?Q?ri9g85O5cSG/FnhO0QpBgzodrxT91UOnrUS6qTHJ4BZsLoG9GetBTvJSSvV2?=
 =?us-ascii?Q?SQf6jhAp13aSk2jhv4KVBiJ5ChFT9/aCcNxCk36ayTAPD5VPxSfe+AUZcikt?=
 =?us-ascii?Q?d60o+cIcQ71PmJJyEsZKxCfkniUrUeso8KCSEhEJSWCJRJp1VNU8s+Ie1IUf?=
 =?us-ascii?Q?RC9fApeILSLfGZrZX136JFTZnkUUd15644VMhR0CG4NtY/gk828gpMaxdL8C?=
 =?us-ascii?Q?sEDOHMZYbuApLI1BF0iU0kgMb0WJC/nZGEVIUSKFPGFB4FWhka3J9LGmkE1+?=
 =?us-ascii?Q?FqKCf+N657OvyrC0cB23HZ8Pcv5MtJiEvpPu5oRULL4gfz81WVkIXlN2W8Ry?=
 =?us-ascii?Q?kXWUXpvGsl8Jn7PgrSMGu/JnD9SeVu2WPnJomO4gdMQm+5lcC6jvQuhamNRy?=
 =?us-ascii?Q?ycPgSBTPAyZ9xZraronQESjuy225ShTbad/nsOvtwykJmSvme3rgpIGJfiY4?=
 =?us-ascii?Q?kdlqJqbRG1KrKdqY26Gpm3rdbkwwliCgY79J7et4U3jEzNlcaO9AUCnQq4Jb?=
 =?us-ascii?Q?A27DJb8d2GB6XhodAaRoa3bQtjxfQSfvA6aXYBTWubzAVG9iBFs2c6/LVMdq?=
 =?us-ascii?Q?v0XehY7i0Hq1GFYMPs5tdG912AAU2Sd3hnnnKRuiiIJ1D88B/ZGSRXTHnnR0?=
 =?us-ascii?Q?OiNXQLGMnWN7wvdOBOm9idRrv92xpEc9E+3UzgBRGFHVUS+O2V3RtDgpK3ep?=
 =?us-ascii?Q?8DXYWSUy2iCuVcTbOkQMcBHC18CTtD1+R8UwdzCCtR63tNhMQFQ7MaXgigIw?=
 =?us-ascii?Q?VdYQyBTC4G2WU7ccafXvemt3RF3bh7FgxvhHQSX8dW5FSG9GnnqAipmAjnXF?=
 =?us-ascii?Q?arA6ap6bA2GeJtIzyDDobM1A1/y3qiVRiGaqNyiL9VQsMZlMiw7P4k5hEYQK?=
 =?us-ascii?Q?X389shx7pRjUDjXs9JPGpUU8pp3CfZOIUVDIwE4/NNbpFWLMVLsdi4uxTZS+?=
 =?us-ascii?Q?RpG+NgUqDg0Nc4z8e1/btyHcrIqK8H/pxy7pq32VIDHRkXJPyi6l4KMBZYWX?=
 =?us-ascii?Q?kTjrk+LR6HwKStZplYSwjxED++5rGxTKHHRZgTLVgtB/VJcloI4B9+nHGiJG?=
 =?us-ascii?Q?toP3W00ItKqj/s/w6Iu2welLt3rl5Du/0JcHypJtvQ+bg8uXjg/ux7C+I+rW?=
 =?us-ascii?Q?yVDdX2giwUoej4V8G4/Jnf0CuT7s364FL0uCGZ/YiVh7Cfd2On+N+V7tIcyE?=
 =?us-ascii?Q?JwjCbCuKJiBocFuw0NMOnL+KKAJrEx7b8LszXQzuEyGs7CMYWge5Wky+R1iB?=
 =?us-ascii?Q?d0ljUvF0G2glt5Zd2dVqVK0zWE9dwkAoA70RFcHUk+/FPFGfyu3dlFhJDQKY?=
 =?us-ascii?Q?2qupqUfVNTk8EnzpdgKYqio0QHMbfVXt8M6AKipoo5csfdiC0S0wTGd8I8po?=
 =?us-ascii?Q?Z0GayyXC+EL/ZbV2QS1d4XqUNuCpVG5mjanpa2uRoCJrIBZcTBgFgHTE1S3e?=
 =?us-ascii?Q?iVO6o9uV8B0aqhffNx+eDSNZv+hJQZiUXsgs2GqJtFyeAaIRaKo/Jy9DNvPM?=
 =?us-ascii?Q?BhK0DWSVywUinokiZTyB23N+CcXKnpiQqYgMCSynaqoFPGhplz+6VSvtRVDm?=
 =?us-ascii?Q?Z+JFIx5mew=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b74f3828-93b7-4f37-f275-08d9bb42be19
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:35:58.2180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eVxhMzh8VDBtbgg+HYIi5XkC3DpseIGOn0jNph0d5FRlzaWc92B0OUL7QKbiHQcpBYCxnmpEABCLjYFv/SVzFPAbS5HWF+r4Y3Xw95cvibE6OrXgamulg15TdML6utmL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090097
X-Proofpoint-ORIG-GUID: kPj_9Yn1ly3bbN6Wbnj9KSoMI-u6m1U9
X-Proofpoint-GUID: kPj_9Yn1ly3bbN6Wbnj9KSoMI-u6m1U9
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

329dfc28debb disallows the creation of raid0 with layouts for 0.9
metadata. This test confirms the new behavior.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/00raid0 | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tests/00raid0 b/tests/00raid0
index 8bc18985f91a..e6b21cc419eb 100644
--- a/tests/00raid0
+++ b/tests/00raid0
@@ -6,11 +6,9 @@ check raid0
 testdev $md0 3 $mdsize2_l 512
 mdadm -S $md0
 
-# now with version-0.90 superblock
+# verify raid0 with layouts fail for 0.90
 mdadm -CR $md0 -e0.90 -l0 -n4 $dev0 $dev1 $dev2 $dev3
-check raid0
-testdev $md0 4 $mdsize0 512
-mdadm -S $md0
+check opposite_result
 
 # now with no superblock
 mdadm -B $md0 -l0 -n5 $dev0 $dev1 $dev2 $dev3 $dev4
-- 
1.8.3.1


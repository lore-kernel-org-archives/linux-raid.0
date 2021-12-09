Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD55EC433F5
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhLISiy (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:38:54 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:31822 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237974AbhLISiy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:38:54 -0500
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HnBHg007286;
        Thu, 9 Dec 2021 18:35:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=XGa/kQj2Q8FDMinbCal7O5iNMU9PSUILU/MwpD2KTR8=;
 b=DbgR5oOGzW778BYa1ETP8OtLG7OEeh+DkdFH3kizMxg0ka1yzg5ew1PnnWkGYSIlg4Js
 c2MsBjW7tyyKJKYS2ovb5viquyqyttYfQ8CdqZ9Vksg73vm2bh+91+ry1MQ1mBKMx+Q0
 F+kaYeeKubP3i8XZMIcRcsZ+nBcJT75oRxWKf6XCAl5TaqTbFQ+VtahJfFnVRncZxHEx
 z6aB7hzRFaDUDIqrsx4lezSXKk7nK1Yv1QIzgHt5B/L5ZMK2znMbkb49LM8PyjqQZC3f
 ajNUB0NCEQDvRzrkFz/CcSmnblF9OUtOOD4bVBUtx6uyZVeUFgdtTqRTMlo/B7ajuUvE lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctt9mv1jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:35:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IKn9Y029722;
        Thu, 9 Dec 2021 18:35:17 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2045.outbound.protection.outlook.com [104.47.74.45])
        by userp3020.oracle.com with ESMTP id 3cr1ssx13d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:35:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqMZ5hxCM/DGls5rjipUPZeopO4vMbu8qHD6gPHR1ZRyramwrvmS8Ajv7hh9LUsTAFP15psCJfLa/SWN9WFxDUa/5IkA2hEbUi/4mGH/U7okgV/Z7oyprnIPy/j/P9FffiZF+bl6N8behMadbfTQ2UnYpCATOLOyuTsBZJ+pEXGa646sugmMVCWtfKzkNUU92B94jbrkQ3angfNUew5E4HpWT+2ZfsGkDBKNMyM7AQS/L0DRnarBkGR+7QiuKOrUtkJ3L7Xqiqjwa7KjF6guIHeg5ye2TJIIqUNk1/bMRCaM5q2oWFfSkL0z/aG50IEQc9BgMLSRqJVwokxzg/sL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XGa/kQj2Q8FDMinbCal7O5iNMU9PSUILU/MwpD2KTR8=;
 b=nGY7Ja//97esbbk/VGTgAo+V8xhBeTeDY2irvnIQ2uLm+qYgyPvOXJVXF7AxmL7dSdINmj+lHAx9RMmYFkG3HfjoPRnUEK1tARRBTBRdgApw4DhAPObzpbEc6SCOgQMKkexHBV9pIOLKkzD1EGRTWX59erU5YNIccZ5Uh1f21qQUurZSbrubdbmKrhPM/bQvWSqwFqMhrnWb8XgvR4fSRovovIl82i2LiNF2T/yOjNpXVffGPcvyTUxbTtdpninUyyF0QbmWMi8mrjQvI5lWytj67RGklLt7EbTp3a1gOX1szhH8rSNVih2WkfiTc4PhDaEHwWUWBFrTfPh+TgBDfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XGa/kQj2Q8FDMinbCal7O5iNMU9PSUILU/MwpD2KTR8=;
 b=YK5shWi1+q+83beUSYthLspOKaIK2NmOShaT/BIDIum5DdEuStZql/oNtcf3h5E3EvsTer6I/mhTPS2vLTtCe4lg22zNJLmCy03qkVQ4lczjYDrtYlQlTLqEom5w8w6oR4O6yOWG6IhaWOejCQ7KPnV3JnEeGWQ3PNIgEfwrqAE=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1415.namprd10.prod.outlook.com (2603:10b6:903:2f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:35:15 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:35:15 +0000
Date:   Thu, 9 Dec 2021 18:35:12 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH V2 0/6] Resurrect mdadm test cases
Message-ID: <20211209183512.GA21525@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SA0PR11CA0116.namprd11.prod.outlook.com
 (2603:10b6:806:d1::31) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by SA0PR11CA0116.namprd11.prod.outlook.com (2603:10b6:806:d1::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Thu, 9 Dec 2021 18:35:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddea0cf5-f9e5-4aeb-60e0-08d9bb42a455
X-MS-TrafficTypeDiagnostic: CY4PR10MB1415:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB14155792F2EF54B91A8E2746FD709@CY4PR10MB1415.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zRuU8yfS8JynKw8/qejgz3TvAuNgRyHVyWHKNbOV9h++scZ3Gcqz8Xh8u5cXT3niY8n/uY5/Kokj+MP6ajeHftLk/Emm2aU10t3lnt6f7HZu0nzaIbLMoJrikp3zQNIABkY681C6wjwwmaAFgms0MDZ5L+81QUaxmYh5VHVDdgKNuo9WfAsXQybCX42Su8mjLqVks8C0Lgqxbj3/d1saqcE3X6AL4fCElXwUPAAJXdyyiYcB9QkKxpcXWDyfzOYHe+NUxOO60gtZUbc45+C3R7ZSGxI97wpLUbmU1rJvRCvq+ClpGMg/qGLVtVmVHwioPowfI/MNlFU650BbItiBrRUQ1ZusVLLT8E7hw66Mip0oh/cOOV85XUxuRo5I6mBRUubO2zP2ImKGlqDylkTgsw9gNmVvpYxXMCKi4dIK/tmqHM+Qvoh9QUEZI/ltD23c/DBkmKAOWR9SIP4mwN4LijpVovREpV9qTLnGWJorgflDlzsPiZAXfMreiod9QU6kFpCIN6G8f8RQ5j/aVEApZkhb/8QM1IZxJynhLsoIDNUtCVG1J06VfHOEA4Z8CPgCtctgrQSroEnZB0Qwabo5+WvDPGxJECKWFPIXTuLvS050LjlfdOqtWOR+VI3yOuVW6rT5cIvlILeb31/j1qKhxXDnkXCSAQxs2u5BnnaTOyfjx1Enl9JFdonkZcQvTQTv/E7dDxJbKSSibW6YQyZwnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(38350700002)(86362001)(38100700002)(55016003)(6916009)(36756003)(2906002)(44832011)(66946007)(66476007)(8676002)(8936002)(66556008)(316002)(186003)(4744005)(2616005)(33656002)(956004)(52116002)(1076003)(7696005)(8886007)(5660300002)(508600001)(83380400001)(4326008)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1gC4Un91feI0tEOQCaqJ9K3ixKVcddhLKJ66iV+6eLWW/6xzAIRgn25Q9hTD?=
 =?us-ascii?Q?ohKGmL+79UjQxPlJbWiRN+BnCvI72UToFZajXqp0UwuBV4hB+0El+GyYspwW?=
 =?us-ascii?Q?xyXap26KAiOX0AmMkt4vKzsm5d7u2hOtr6mh6+/qmZBmHXUatHsItdAEHr3z?=
 =?us-ascii?Q?1Pz8LSPBYRutOp2Stib+giiAFhfEooQWAvG/oMFCNSoD5yR1NuC3A09GT8D2?=
 =?us-ascii?Q?H7ymesJ7UoNyVUlpexV8KdtH7y0CdXhTWKsM8yHhmn8Ve01GjvwSLBp698o+?=
 =?us-ascii?Q?4/KH44L5cF95UO7056Gt1L5cjO0sjCai1djsu27ulw4ro+GILijpQldUkdlA?=
 =?us-ascii?Q?SdKtkdo+5vD+3xU4FUTPbiO4+TfVq0oHW6oHEfPl6nql3Rl+3TtvQwHqH+h7?=
 =?us-ascii?Q?P9pY7mrdhxRla8sjzptn//PYyZ+WVV+3lLAmQZafmNQDxmhXbd/yzcaCBFO2?=
 =?us-ascii?Q?inUO4xqSegk+1TkDJOxTlKsnrrm+/EKNl2D7ZdzYNEmwfl6D9N+U+ZyM/BOI?=
 =?us-ascii?Q?6GfXM6UGNpsC8IbSOD+wWvnj5xL7fTcXG40/uwyPnq/bPyfpz2uJFQ92UJiq?=
 =?us-ascii?Q?NXJuQsa9me4dOReRKM9rpNTIGOd98u4f0sJ5XH0NGDfJyUYLbcvbPicjl4tQ?=
 =?us-ascii?Q?L8mLc3R4NU5ecF/8CbFux8Yeg8FgL+39JYF5tnWcr6EruyP96yvKgfaL0T7L?=
 =?us-ascii?Q?rqRrj7ZZIdGZxnA/x1JcC0Q22ZZZDskvE/iw1oT2r+W5O1Ix87GjjE+9tqWC?=
 =?us-ascii?Q?R+saGBCsolr/VR2Exhr0crnyHtr/LB0ZMGUBY1sboZl8ktMLDgF+2iPfUKr5?=
 =?us-ascii?Q?e2vXrSCV8wklPrOR4pFn15A4gwgVZIvQ3SwjCIm6Oo4mkBiqxXXE58/rQLEv?=
 =?us-ascii?Q?yWv9hsh9TJjW96CD7S19BgAvkw+ej36VfFpeyssHOYgoHQJVicGCGvYh04DU?=
 =?us-ascii?Q?EhoCIiZbh+wMKeDTh4tv5qexNz8rUkCPKNPg+f5gVlUYL4Ax8TsT+wk6T0bR?=
 =?us-ascii?Q?Wy/mSVkx23z9nDaYYJGfXUPGmenpBr8wZvR+H+KzkWLUXdMSc0qTghxCyJEz?=
 =?us-ascii?Q?sZ9wfvXDUQkWZnDPlD6X3sgnfZDKPzYtW+tEqE80uzsFads2MbdZM8mRy+zY?=
 =?us-ascii?Q?o93dbxhGMCLujGwX5jHEVcEITiEpchvhRsHnpJ7OgW5ZSHjNUXWS+yTWD83P?=
 =?us-ascii?Q?Oe3B0u/IhHzOZ2yoEubTOJG+4+Mqh2GdiuecGFMktcMYiNj7Kal5eGMro38n?=
 =?us-ascii?Q?pZR9WXTaAw5SjG6RJ2ALHMc6CaXJq3bIMoXa+AgBGQ6ysxBwpddDDi9aGc8S?=
 =?us-ascii?Q?KsV03VuPBg/fhrvXMxYDUUAOGY3Vo2qfRsPKcF8sYTevZz/SKT/Z4ilk5STu?=
 =?us-ascii?Q?Mf49p3kPsIzz8oSNgpRsSGK9ZG2PB68/b5OLa96P462fpCbpMgGkqylVw9gF?=
 =?us-ascii?Q?755OPsyGxbAnRq32Ef4QFgb2k3+S5YmcUnM4d4JfGI7lLYxaIxj3QTHSAumY?=
 =?us-ascii?Q?erw+xMspJ0Z6z4nH5JSyVJWVpq8c+7A/gejOLVi7zYUScSX+x1engpNjJ/M4?=
 =?us-ascii?Q?Gd1l6qn2wA5QdsSh4M5QIty1Pcu1I/zscrUay3r0nkGBe72Ch7BRK5i5izPT?=
 =?us-ascii?Q?bsDFSDmNYKKLCw/5/8Da7cAsep6lbrKSA0v0U00k/F+dSheIynPp6waCv6wH?=
 =?us-ascii?Q?6caTjlnSWmn/WT37Sd52qPYFVMCAuTrl89tYSNVz/vXHG8+vGj6HlYVOMptg?=
 =?us-ascii?Q?4aIMAnhDnQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddea0cf5-f9e5-4aeb-60e0-08d9bb42a455
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:35:14.9711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtfqcZAnb1CMvNahrFAHXkTt/M/5J9dFUPPiGM7inrjcankeRHyPeiOpW4h33Iv/N3fRSHsT5XRYWEhlFQ/8FzEWKVoc7+XCfrZUKPr/gjmPfktujqrmBIF9Jz/bvLez
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1415
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112090096
X-Proofpoint-GUID: IuvmqNu9_j3ymPxWoQFJJxrGb4Po_MuU
X-Proofpoint-ORIG-GUID: IuvmqNu9_j3ymPxWoQFJJxrGb4Po_MuU
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

Incorporated the review comments from my earlier patchset. Please review
and share your feedback.

Thanks
Sudhakar

Sudhakar Panneerselvam (6):
  tests: add a test that validates raid0 with layout fails for 0.9
    version
  tests: fix raid0 tests for 0.90 metadata
  Revert "mdadm: fix coredump of mdadm --monitor -r"
  test: clear the superblock at every iteration in 02lineargrow
  tests: Add a test for write-intent bitmap support for imsm
  tests: fix $dir path

 ReadMe.c                |  6 +++---
 test                    |  1 +
 tests/00raid0           | 10 ++++------
 tests/00readonly        |  4 ++++
 tests/02lineargrow      |  2 ++
 tests/03r0assem         |  6 +++---
 tests/04r0update        |  4 ++--
 tests/04update-metadata |  2 +-
 tests/09imsm-bitmap     | 18 ++++++++++++++++++
 9 files changed, 38 insertions(+), 15 deletions(-)
 create mode 100644 tests/09imsm-bitmap

-- 
1.8.3.1


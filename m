Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3263C6FA82
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 17:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbiILRlI (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 13:41:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiILRlG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 13:41:06 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC7D1EAFC
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 10:41:02 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHXmd3009884;
        Mon, 12 Sep 2022 17:40:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=mCzYOwBBJJvSznuJk886tpu8b9Mw/kVeuZUFEtYy4yk=;
 b=DRUACJJ/LxPTPS4CieTX2sYQ20aptXjljH21YRIjfJ8lkN8f4YAi+owLPexCGUnGU85o
 EnlR9LE22chW0HwY3LPvRryoJI/ELiC0Vsctt1thiduo+Kmd6JlSa+5aFE2QzgYsN7+e
 BDX0F4/b4N8nT4BiQPlJBjsB4Ahey8PxdLFz3JhLpZnTwgpyxMwYcyGtTVXeCUPKAK8c
 PzlSIJTLvRfLQy24Z2TizVpFkeUYfIImbrrRw9ybG7/VeTJqIbas52tGQW2zlW2pwWvD
 AkXxDT1uXQUVIPHEVvtNzJ89bt1YIpty8k3Kym03Bukrk2MvCRU2Omy74mzjtZ6CJCPA jQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgj6sm904-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:40:41 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CGt4cX020634;
        Mon, 12 Sep 2022 17:40:41 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b9t9b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OkPFZSaSP0lQ6D+OID3Qfk3UzJpa03ObuwESxllVDO4FuRFn/Yhba7z1eIA0i1xZCuNJ4/snZ1Gz00vVb8SgVdU1FoFGj9DY8k2HzDMiCC6OaFVsf7Tl2mAit0Vv/P+Mjg8IfDPNCgS/67dF7jMMnVFWGsjlXEBorEpIz/Pn99k4/83/esHzBqRq0QzApVH9R0Er/EjIDeql+sazv49CaatkQmJXnvm3gtekVqfLM4oxkZcX4wJXxAlKA4JezKpZoCcH3pU+U1fy8tC6tSsC6YKPnfgetDpWH7w7CNERugq8fqYOW41PWcOeyZ14/Zs8O0mG6ZeDPLo4Kl56VNBVZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mCzYOwBBJJvSznuJk886tpu8b9Mw/kVeuZUFEtYy4yk=;
 b=dFcrqIL1kLA0KI2xegkwldU1Z3HOn22S5DP29wYnj7QZ27CHv6TqM/2N/2Mb7pyzoh1nc3Iam+S5LssouhFDaWHYOMkptUBNh35N5TPu3AIRnbkt9Ma+I8gp+cXvC0CG9KA+ZU8Q7JfTOebzFeCm97nM0h+UrhIkXuj7o3bzFzZbvZvulK3nOL3dGefSrGMdi0Clk7ZrbJa3ff7ydjYbaU7J2i7qION/fvuLi9EeEhbMSOGuYCbUbJUONkkt8y+M6mxgcZLlSd4aixA+KcrXQ8jxxKd43oCIMwDrpuT9n+T8iWKSgxaBnXPeE7L4oR9PPzXqKtgOgJPw2qj4PSllZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mCzYOwBBJJvSznuJk886tpu8b9Mw/kVeuZUFEtYy4yk=;
 b=amqnrlkyf2vqYz1FhIi3QjhUHSDxcCcf/XCUOzeA+oRZA/jsXMmr44ilHrcBDR+WqnPPAQ/6iCxZOa774Z8GycuT1OHRUhpICGH0fY0YcWgt8FjNOJjLWl8ZxEwqnoyAaABgUQB4tHxLQ9YV9DiSIqrFmsIZzV4/fh9+S2yK5v4=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BN0PR10MB5302.namprd10.prod.outlook.com (2603:10b6:408:117::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Mon, 12 Sep
 2022 17:40:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:40:38 +0000
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 0/2] Discard Option for Creating Arrays
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com>
References: <20220908230847.5749-1-logang@deltatee.com>
Date:   Mon, 12 Sep 2022 13:40:36 -0400
In-Reply-To: <20220908230847.5749-1-logang@deltatee.com> (Logan Gunthorpe's
        message of "Thu, 8 Sep 2022 17:08:45 -0600")
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BN0PR10MB5302:EE_
X-MS-Office365-Filtering-Correlation-Id: 47a556b4-b6d3-466c-8ba4-08da94e5e7d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: APQ1aCBZHOQwW21lRxwzc8O+PfCDjHPikUhuhtNmcz9hIuJiIx/AtYpNTopUZQL6kJzri+qpf6BNyFY0dtb9ne0FDi+/1eLjyyXFhm9kwdj+qcWSvh8uiLOZ6FmJ9rPl55vqr4kRbyDZmMPKMTmnoomVLGC+6Jg0BPyP23F4RcE23QEkVEsUAUDPal73joOdq2cIocV6ubI0Ac4VFEP+RGbbsS3jCoVpiznxTvFRF2kHsKkiwOvjbIAUSzmKDUoeg7eix9Brr0TGsRSsaDt/XBpC9wMlN9sC1d/0IzuHJyQYDDTl4iunBD46jI2Bs3xE4M3ZZiDnjCqXvLKxx10Q6Y2yAQCVqwi9ghB5IC+/W2ocGA4r3QDRPRo52P4VdWCS/Am8SvaJnmNKGL4kLKsIvIGRvOf2jiuzTs3p/qNXo5QlXsxwaGMRTUjMfFgTmC6b2iyBtOYAtDLZrjWq3fbn/qrtLQIqlPblVkRox/O7ZfP48+SgJR/BIR5fG1gD+ZY7204IdKmgqEVxSa4DF3PvSbZ5jmRmyymKD+6ummOE/pyroW1qE3UvT4HEwnfikL07DPNzXKi3KMAqj4gVEoXAxhb3oM0p0ItYXc0cVQ3rKJkyLZIBDVbT7UsKjKkMu9uJiA1dZ31UieGF+N4sFufRDaslMuxM/7ncCcjbQ/dNt7xkiMTfec6yqqMydOOyqKkeQZW0C47NEFxi5ojac+5AnA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(346002)(39860400002)(136003)(451199015)(36916002)(83380400001)(186003)(6486002)(8676002)(6916009)(54906003)(66476007)(5660300002)(4326008)(86362001)(6506007)(66556008)(7416002)(6512007)(478600001)(38100700002)(8936002)(41300700001)(66946007)(26005)(316002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?c0c+bugcACNbofrpoNTjo/n2qTrdcy7OoS9VabSvoR3aIZM5WAhN9rRDY6bt?=
 =?us-ascii?Q?fP+FggqRg0hVWWpA8OZ846kreXb6D2EEj/q5at4GZEMAJJFjOSHgDIlC9LV6?=
 =?us-ascii?Q?8K+jZDl3kE+tDEPbIYqrrRQUVKILpVPc6+JlHspSG8DgkeXaoUE0SzNtqZTd?=
 =?us-ascii?Q?R49KMDbRv6kIxNGwEvbaz5Bs2QcBn5byu4R3MgS9oDgrwLMemeYF76mOBa1y?=
 =?us-ascii?Q?RbehtgAA2KQ6vaNYIGdVV0qB8/OOF4TkcX2RNEST0V4ZAhPGegZU6PYvoYYJ?=
 =?us-ascii?Q?EwHKxM8H6fAmabf8jABF5SGhGhfzekOVmiW/B4rfXKsOW9eOBZ3x05UIUCfD?=
 =?us-ascii?Q?lovw6CICV9mfBQfSYJGdWwtemSbJrl9xbTyw97gEqTt1DeeXq0AAhRU20UBA?=
 =?us-ascii?Q?is3dw2iMtBP8Y/o7Il5aS0fo0tRTYiGHZleNDTyZrQCzeVM6VuMIps+qfLwY?=
 =?us-ascii?Q?Fw7oXWG9KQX4G2leorjGxNtbZ/EeTB8OHkqEof94mss3Vp/MpI2IXiQknEJj?=
 =?us-ascii?Q?mOMfTImr+gP792H/+lGszTq2llK4YNsHIhDl1lMaMS/SIdN2aOd6tu9FAxQn?=
 =?us-ascii?Q?WcsVGZaYo2GjZqrLW2sZsequJ0zgYcQsAXvJls0sQzXGoksowqA4sNgC2jAw?=
 =?us-ascii?Q?R/7QxhQLn4EEKMjf3G4ylYffSUipIPTTuTVHD9j5M58hfqu6HtF7YpxTSexd?=
 =?us-ascii?Q?loC9emh26yU3zY8udjaBvuS8uRhohD4DHqa6IUPYvtZNK9uD7RCv8X2brAgz?=
 =?us-ascii?Q?0/PjJ1lBuC+RI3NTpsDedRI2VjF84K2IUQN9SHfXtcA/FwxAUdUzXfDu3oiT?=
 =?us-ascii?Q?m0rwRoMz9YEW4UEVQs9QslNgbEs9zkJM+zVbs4kOudRywOofkh+aSy/V7YOy?=
 =?us-ascii?Q?OqJ7YvV2d8pEnDd1bLxsp8a6zTAenJxCZ+FKIioXIiohOlgzORPQY/Vv/FUy?=
 =?us-ascii?Q?APBdg83cUBaO8cDnbV/nUo3+tUhl3dbtOlEK5kTKuOLfwOmNdu139LwZK1UM?=
 =?us-ascii?Q?3JskGStQ20wuHAlAmH44iv+pJ3Tp6Ahe3tL4tcAMYUiMZLs3aMUqZB7H9trM?=
 =?us-ascii?Q?Bt85dqO/Oj3ZgMScfOvi8I4vq5wpkHFViB/yVjhUF/NScAU/vGrENLR9NqaK?=
 =?us-ascii?Q?oGBvaXiAEaDrHIQ6V9aCoc0J7zWq/6pRzAqFDyX124DgSCP1KxfdnSwP9x+E?=
 =?us-ascii?Q?88VVRaWXz3+Wu4YEFUmOiOkRtx95DcFFzPTzRt1Wh+V/Gzc4KF/5Cso2U30/?=
 =?us-ascii?Q?gnGW+EdHpXhQ88KvDd0XDYO+5NnVCFUQxPCZ1z4GvzcitE3l9q88bmIYdMhA?=
 =?us-ascii?Q?3NOuvT0DqNp95HcMawy3zSTGiGjhWo6IpT743cTKEjcsUrfkz1++1ID9pnT6?=
 =?us-ascii?Q?cXAj7fa5JyB68htSywA7F8rwCBW0JOeMjBbglYjNN5LRhyDRZvgg6EKOpE6s?=
 =?us-ascii?Q?DGLDwAtQUizT9mWeuCjkFPqZZiXcDQDUHDhOohOddBhawHZZKwW/cVNU+7M3?=
 =?us-ascii?Q?hcBhzuT+amSn4MXexfjBP3IJd7Ge1LrrYTBz2eaXHyJnzpfxG4xwQ7jov2y5?=
 =?us-ascii?Q?6pWoFzttBdizJ8eB5u+1q4aM38UcVpK5YGYVQ87ldfGHVr/Kvx2AIhyH2jny?=
 =?us-ascii?Q?vQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47a556b4-b6d3-466c-8ba4-08da94e5e7d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:40:38.6592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UV9jpBC1TcEIKPDLZkeDpz4I2iY+e7598+nWHcQDdn8xOfPxp9ob/HK576v7WY+yRTdzZWuubbqSICTdfueDKUjo7bkR64m7ucgGVKaMAXU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5302
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120060
X-Proofpoint-GUID: tcswZs2UnkiWga5Q3YukPf9vJ1hz26a2
X-Proofpoint-ORIG-GUID: tcswZs2UnkiWga5Q3YukPf9vJ1hz26a2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Hi Logan!

> When specified, mdadm will send block discard (aka. trim or
> deallocate) requests to all of the specified block devices. It will
> then read back parts of the device to double check that the disks are
> now all zeros. If they are all zero, the array is in a known state and
> does not need to generate the parity seeing everything is zero and
> correct.

Unfortunately that's a dangerous assertion. The drive is free to ignore
any or all parts of a discard request. And typically the results vary
depending on what else the drive has going on at the moment the request
was executed.  I.e. you could experience completely different results on
the same drive depending on whether it was busy garbage collecting or
doing other I/O when the various portions of a discard request were
processed.

> Another option for this work is to use a write zero request. This can
> be done in linux currently with fallocate and the FALLOC_FL_PUNCH_HOLE
> | FALLOC_FL_KEEP_SIZE flags. This will send optimized write-zero requests
> to the devices, without falling back to regular writes to zero the disk.
> The benefit of this is that the disk will explicitly read back as zeros,
> so a zero check is not necessary. The down side is that not all devices
> implement this in as optimal a way as the discard request does and on
> some of these devices zeroing can take multiple seconds per GB.

REQ_OP_WRITE_ZEROES was explicitly designed for this use case. It will
use discards if it is safe to do so. That is if the device supports
deterministic zeroing; either explicitly through the storage protocol or
through ATA quirks (thanks to the drive being vendor-qualified for RAID
usage).

> Because write-zero requests may be slow and most (but not all) discard
> requests read back as zeros, this work uses only discard requests.

REQ_OP_WRITE_ZEROES will pick the most optimal way to guarantee that all
blocks in the requested range will return zeroes for subsequent reads.

-- 
Martin K. Petersen	Oracle Linux Engineering

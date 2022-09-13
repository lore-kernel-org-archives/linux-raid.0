Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB9DC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 03:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbiIMDs6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 23:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbiIMDsp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 23:48:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3DA54CB2
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 20:48:26 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28D3P4Hn031195;
        Tue, 13 Sep 2022 03:47:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=oJVwSCyPyZ5PhsOTGNVR/w+bMvyYS+vjkBN6B6mle3g=;
 b=QO+XMSai7VkwCqN29prPGF81yXnFnn++sH/Q1lCFs1043nAorR9OFA1D2j67YSvdAsPn
 AAQvnxd0SnBDpkEIQ8pxhRU3PizqA32f9xB4MLh/DHq4aaJ83X/lzZgT+x9Py3VRPoXS
 dBhRj1HvpCDfITsOF6ouIwsfgSJSzz7wdtArd88vBxTrniJ6K/SUEoubW9dSI/IMc5a5
 IB6sDQ/vaF7ENyXETVx8OcTlYro9EV0zQA779mvwjWFHM8AeL6r4p/0zTiGfPjeX+rmH
 GttBQrvLzE6qYPuIcj/D9CDT7R4eBMIuhffUHnvvTPMFcPZqwNRdikJuLatcLAMsA9ii fQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jgk4tdahj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 03:47:54 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28D3Mh9W010260;
        Tue, 13 Sep 2022 03:47:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2170.outbound.protection.outlook.com [104.47.57.170])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgh19hne1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Sep 2022 03:47:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOnfkUTgivNWfwsmtnW4ygW2IbHGR6Gad6d6k9ZCn/Y00quC+A8kXH7NR7rYqWCmgIP3rv4spgcGUS3pH73NUyVxLh47XhG/uF8WrBeTPXG39wMdinLRNAVZSPrmha92jr8cd5pWx46w6DQbvd/hsO98l7NYBPWLJmlpGIg9eoeYtemRWlkisxRBkTiYCfPC12ydDbe6U8xzIpsf8WoOYf/KgxnhZEZJmzPiv2910BPunjucLvZ8YLG5/VO8pTPdBWrKhCRMh6nY3aybvBA5C1/T0pmvpw+9+4BrcURO0sYPFkdLrJ5Ke/3JKVFRRZ+LWindkwfwYaOHn8ehmkYDAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oJVwSCyPyZ5PhsOTGNVR/w+bMvyYS+vjkBN6B6mle3g=;
 b=Ky/MfvxOmoCuasrGNqqJcjcLbTPN3nE1rkYZuVFKTD45GbkWt1ff5Y0GDb3AEwBrVapu+UOs4rh7kn1QddvOH36fb5CiGHHK9MtdVf3nGLF5LlWxbfDWloNzdy1domzQCBoacLBjndEuxyvTW3H9ODWch/t4vY1/s7DB3BdKooKJxHGb5+wf0/iF9YP5lcz4EVpPBVEf42xk78cv+e5BYoAkK8zhC/k+DsoBmHKX1uuTKe2ZFvViSx7hePdrqmWHG3GO5BebX27hZuxEqcs38nrPNeof070V45vLtewYq/5urQjHuiNZVN7YWBV9uMouYklBqZWM+oI2xHN5GKSzlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oJVwSCyPyZ5PhsOTGNVR/w+bMvyYS+vjkBN6B6mle3g=;
 b=wEq/d6bXEcG4mIdL2nneT4nz93Jd3dSzoaniA51lvvbaPchsANBbIwUtcgqYwclNRAma8FFeYx+PiD8gY1mhXIsVdiEhYpvjPws3mpxmuFCC+AM83oVSi6KOz2W3x5GABbbB3izpYfMeZsknzQPojc/tLXZL4OH7043mS79Z9Is=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5361.namprd10.prod.outlook.com (2603:10b6:208:325::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Tue, 13 Sep
 2022 03:47:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 03:47:49 +0000
To:     Jonmichael Hands <jm@chia.net>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 0/2] Discard Option for Creating Arrays
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1sfkw7yqi.fsf@ca-mkp.ca.oracle.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <yq1fsgwbijv.fsf@ca-mkp.ca.oracle.com>
        <CABdXBAP0LeQMmhSLUMZ_TmnSp5xmZ4xJBkNa7HUm7094m_x9xA@mail.gmail.com>
Date:   Mon, 12 Sep 2022 23:47:47 -0400
In-Reply-To: <CABdXBAP0LeQMmhSLUMZ_TmnSp5xmZ4xJBkNa7HUm7094m_x9xA@mail.gmail.com>
        (Jonmichael Hands's message of "Mon, 12 Sep 2022 11:01:48 -0700")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0065.namprd05.prod.outlook.com
 (2603:10b6:a03:332::10) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5361:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b349fc-34a9-454f-fcbb-08da953aba76
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BHIYG9AnZariiPhU/4P2oLFLvXkRajLspNCnIvwebF/zvDGJNxT+yMkajsJ4ZDaMce2AUerWuIfC4xJsU19XR0N+E7UeCnTlEiZNDypkkyTBO24ndz/9/Jj+Q19Qb7V2bOPoZP9pY3WBumqCOyuQZPS3qqiCfW02eC5I2CLDc2iaDQOOsGGf6FvxUSBTskAhvpDNDDPAU4impnCC4L91GbbDz5k3OTCqsntqSBqMfzBf/UhBhNiOGysU9rj4WWdrwE3oaW3s5iRNB1ffDsUft0K47L06F3CzstHbCFzWOTn0GriM5slIlJXMr4JIQdUqPxyETXezZuk8X7LBp8a8mPI0OuCrsoIuvKpzmsfJxf82YRl43Vl8HKiUd1dV2cI3lHt/cve9FZWlEWpXCGLgdpMDoTOddmy5o8pporrBl8p0EpvG3Za0UvAWsDQBiF+jfpbaFi0DglJE1WO0DYygvIWkcPYJjREzZoooXYzPUSC1tQjtTrDinMUFGMyDEZezmoyfcGLZZNOEwEGXSsYEvfQEfQKaPWKssSgtd6SNvrmkc+fYJNw5TCpK6iWeJUayJAgZg0pIfjsipTSNQADVPcqFkPJWta37/sDgv+WTBcgIwDV3BuHrX+R6qjtEUz8RSYrGw20FinTb2g9CPZXzXFV6RRda5EKttIRQTClpt+dijWD0hF0nY/SXSiU980OUyvbrzBYKOP2/+PFIp1OE1g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(39860400002)(346002)(396003)(451199015)(8676002)(2906002)(4326008)(6512007)(316002)(36916002)(66946007)(26005)(7416002)(38100700002)(6506007)(41300700001)(186003)(6916009)(54906003)(6486002)(8936002)(83380400001)(478600001)(66556008)(66476007)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7e65K6cLaNpLvS4C4shf+QE3N1zpdWIbYiWNZb+xxZi4npEwdYKdpkKyuks+?=
 =?us-ascii?Q?FJiZA4WAWrz/WrTX5PJiB6q8bQW71PbGZtlgsvscKrxGwhUijL8VbHrgTmBh?=
 =?us-ascii?Q?DeTmSkFJVOO492ccT2zHgtACY4O3DbuwzR0MJ5vKk7cuz4qNcfNBicmnrDZL?=
 =?us-ascii?Q?7AsLAg3l0y0IY+JZe6jwq0n/dbpoUr0nXpuXmZXIXSnw1ImBErfGmT0jSFc6?=
 =?us-ascii?Q?eyR51Cxku1SRWWWsOhjMWSm2vbW7qnyzRpj0FDRyK7JFuMWM9g3paSjE0qlb?=
 =?us-ascii?Q?tO9aK3CMbcQxBzuwXgGwXWawXSIuzUm780W0Lgh9Pxe44i6Wb5JoJHvLEM6/?=
 =?us-ascii?Q?mFBqKCBLmI8EYPAeoN5NoCVTTICkIuJdWcxTWw7myBY11DddnozeYsErGiri?=
 =?us-ascii?Q?v1nI3pxCo+9KDtergX7z41NMHz2F435XnTVOeTwDRD6r3nSDIiliIguvBRkP?=
 =?us-ascii?Q?N0tlbCq21MwLiQ6tQFzclwEUt/ROsoI4LNTOj/u1pCOmsQZM4kDhsLTyBd2c?=
 =?us-ascii?Q?/rHS9+HMYorvIEineNqYoq7zRiOvOs9MVrNC0jfdjiABUcQ+DAGZ+mGWjYRb?=
 =?us-ascii?Q?SBXUgddPUTsvXMRjCn9lwu7xv4WXnXFBh2B+hP+6aAKPvSspTSyKZe0845ZU?=
 =?us-ascii?Q?JXc/KYkYe6ijWd6DNaJVzvtRqFwZb7w7Y2DthVtbNaiSmFwyhLsxmR7J+r3D?=
 =?us-ascii?Q?Cm8hWWvClzM2f1zy7xQWWKmjYVSkqIjbtSSCOXAdxU8FVS18L0vrklBNYvXA?=
 =?us-ascii?Q?OrafuNtP8EyuaNqCWA7dOKni5rp6wE7vcZBkhQFQKUWUjNGBC7HsqZKkzwRV?=
 =?us-ascii?Q?N49LNFxU8FTaBxGeO0K9eXUODPFzYNbGEGJJhKwcp4YT0u42kec+/KPr3RD6?=
 =?us-ascii?Q?TeZaAhhyXIIfZoq7f63b89ZaGnnMVruIPDhNkfTQd5oc2T7TR6uyMYUYWyNr?=
 =?us-ascii?Q?T3JZKMlIqW5SkfObZHF8iU1u9M4X2BAhBZ2Q/9D8g1WmFbLQMrt7z4VwM60M?=
 =?us-ascii?Q?ahLTKLmGes3y3YEgp54MXn0xWZOumFn4HNNHSPuQk4N2n6AaOmKhS/vujB8D?=
 =?us-ascii?Q?K8LyYmneDnxLDfFgRvmUeIzVMXJkLMxrGjeT6O5hNd9e1wnoV5Ua5WOnqG7J?=
 =?us-ascii?Q?KH2tGHVIlZJNph3sgqsXmdyxH3i8rjCQ45dIo49SO2IBrKwQY5XFy3xs1T7o?=
 =?us-ascii?Q?QLcPNbwnxE1LQnmOWVqynTIo7pQMx+SdT6uKjfY6Kl3s7CkfYlcqe8uxbdZT?=
 =?us-ascii?Q?UBMryy7H//p1nhHkMwRQ8nAdQD4d3lS3ZH+FzhnZEqM1uEWl28UHs/4RgIjJ?=
 =?us-ascii?Q?KptYaLKa6EeUj7daOuDgDBvBbg/7sHUpScnqtYj2QLV0GSkd2TJKHOeqsDHK?=
 =?us-ascii?Q?Sn+bnCaHoWbS0rjhHEm270vY7kyRaWhL8/zgUcZgy2+NMC1Ex+UM55Od78IQ?=
 =?us-ascii?Q?+2XCjyEXGA13ZC0XO4jQwILtETNvCeU83j0pZn1uU+V+Z1OSvizQFl7AIcME?=
 =?us-ascii?Q?b7T0AFp1NvV5zGViPxjwl2Y45EpDmJ3+zJ1DhuVQsCCbMAv2LN412+yo+mYj?=
 =?us-ascii?Q?L2Wr1G2teZ6SgXI6euAwQPO6WqyYU3L4XpYoxh3xvQNpBqR04IhhTBtN4Ff5?=
 =?us-ascii?Q?bA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b349fc-34a9-454f-fcbb-08da953aba76
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 03:47:49.7223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VC5e8kXHn9AEiIFX1Re8ADquVQBz3nki6qQIvEn5P6e4ktyBjIUwRcqgeHLZIXz4KdVxK0S8zIIGy+k3VwaI/LH2/lMbHYGF8S8znGcwx2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5361
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_16,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209130016
X-Proofpoint-ORIG-GUID: RkOkgzd0vlXgDoGemGWIQz2g56lT-eUK
X-Proofpoint-GUID: RkOkgzd0vlXgDoGemGWIQz2g56lT-eUK
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Jonmichael,

> are there capabilities of REQ_OP_WRITE_ZEROES for detection of NVMe
> DLFEAT in the identify namespace information? The purpose of this
> capability is for operating systems to detect it, precisely for use
> cases like we have identified where deterministic read zero is
> required to save a tremendous amount of time and NAND endurance.

I don't believe DEAC/DLFEAT are currently wired up in the NVMe driver
but it would be trivial to match what SCSI does in that department.

The intent of the REQ_OP_WRITE_ZEROES interface is to provide the choice
between deallocate semantics (think discard) and allocate semantics
(think write same) for zeroing. See the BLKDEV_ZERO_NOUNMAP flag for
more info.

The important distinction between REQ_OP_DISCARD and REQ_OP_WRITE_ZEROES
is that the latter is a data integrity operation that produces
deterministic results. I.e. guarantees that all blocks will return
zeroes on subsequent reads. Whereas REQ_OP_DISCARD is a hint that can
and often will skip portions of the request sent.

It was a mistake to conflate deallocation and zeroing in our initial
implementation of discards in Linux. We have painstakingly removed that
and now provide two distinct interfaces: REQ_OP_DISCARD tells a device
that a block range is no longer in use, we don't care about block
contents for future reads. Whereas REQ_OP_WRITE_ZEROES aims to provide
an optimal interface for clearing block ranges given the reported
characteristics of a given device.

Note that I am careful about using REQ_OP_DISCARD and
REQ_OP_WRITE_ZEROES terminology to describe the block layer primitives
for deallocating and zeroing block ranges here. At the bottom of the
stack, a REQ_OP_WRITE_ZEROES operation could very well end up issuing
what people would think of as a "discard" operation (DSM TRIM, WRITE
SAME w/UNMAP) assuming the device has been identified as doing the right
thing.

Anything operating at the block device level should be using the
REQ_OP_DISCARD/REQ_OP_WRITE_ZEROES primitives (or their corresponding
ioctls or fallocate flags). And if there is a need to address how those
primitives are translated into commands for a given device, then we
should handle that in the relevant device driver.

-- 
Martin K. Petersen	Oracle Linux Engineering

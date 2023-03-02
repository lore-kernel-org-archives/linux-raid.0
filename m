Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA10AC678D4
	for <linux-raid@archiver.kernel.org>; Thu,  2 Mar 2023 16:57:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjCBQ51 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 2 Mar 2023 11:57:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCBQ50 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 2 Mar 2023 11:57:26 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BBE837731
        for <linux-raid@vger.kernel.org>; Thu,  2 Mar 2023 08:57:25 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 322FDpob018708;
        Thu, 2 Mar 2023 16:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=7AnHxvX2uYlRtrtoK9XlVUgkTsxA6iOXsxZUvNMoqm8=;
 b=hxQpTnHnkPbRRB7dhBRcvh6DhKr5Q0nZ/3fXmwPGBWzyRQ1tBaVakl/KotO4mj2DyZXb
 +y1isKlm8rut3VnywihA7URd9otBwnmkbZh6iL6hlJLvpjpfJ4AZDRSQnz/YCQ60Rm1C
 5LkqV3JkhX6hiYCJXiumeZnepLfFkV7EJKFSnY/koayx/6bN42+DeKD9q1ap2+vcZsF0
 Z+erNDIyEsafMSE+AyIYMweSQj2VR6yT4769NlxeYvk7KAFqaYBihB5Xk2ftaAcrjSgE
 V9HcnUP9zh245VkaPtF2x6rznyCToDlSaRmJ3X6mxNWxOmdbY9UKg7kqWZcbfb8XpXze Sg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb6emcge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 16:57:05 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 322FXVSx034880;
        Thu, 2 Mar 2023 16:57:04 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sgda2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 16:57:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8bmp7Od8BFDSHhwpi3u0GH6Fgid6+/25Pep8jU992dbrhM0cAbYxFqRmzu96jjQqHh3D3jhbmArqpbSbACfcPsQhImaHypf/20zNc9sXqMMyS+4aD1AeCkosm1bovmw7zz7SxGUMs3VG+I0ZUGJfpVAosONAGUrhcgHyHQNlAz766duI0JUQ34AJPGzMt21sy4Lwx/CZxDo9izFtj2BuKnVo4wthurtHek/60bK7QM0aNDkbDYD15+qpeyQ2oyWa6Ux4OZGL0mNzEveA9ZIeG8A7bMUQmeNUZU9utMupB0L1boHdkEEllTiE2sp0aEbFTb7zVmvxjHZ6c0w0GIWNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7AnHxvX2uYlRtrtoK9XlVUgkTsxA6iOXsxZUvNMoqm8=;
 b=OsyhS+Rkzi0mOcJEeHQBVzNBtUiM2JZYnwRzLfh7InRSvLmbHPyfTPU6I1axTPEYzFGr6fAHUV5dhHzjJOf32W1Bg0mD+O7Mn/1RgP8mkrjQpWgeWy1B8T6byHZPXj2vuUFEj/3t2+gRN2RcS6MEPn67i2Jug5zZ6O1zOe4AY2nXs6QArepg9zicXVX/3IDZDEfNjMd9jIE3T0ChcTtUnifx6XNaw5DGXbh72Wu0iKdI5fYn6K4zgOgTaEZEsguaqgHueC99Gdn5AMM/txMpGtm7Suq0UOWT5RYmlybSkvbwU58xGtkBDTLcQKekIWkEWoGd1cG+4I18T9/jhf8tNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7AnHxvX2uYlRtrtoK9XlVUgkTsxA6iOXsxZUvNMoqm8=;
 b=UoXi8uyJcEp/Eqqaql0sJBMB5ohyaDrgdrxsVvc30uCjuxSzUM+zeMMFvgCHRaZ29vh3YL44ho3xiApqS9gOMjJxBq3fJr+3ybmpdRhzQQHEMfQk9W63j4SnVuqBSNJzs1jExeEiMPBuYndIqfwKyZhrn8ki6aHReQWoa28qR/c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by MN6PR10MB7519.namprd10.prod.outlook.com (2603:10b6:208:471::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 16:57:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::8ef9:5939:13aa:d6a2%8]) with mapi id 15.20.6156.019; Thu, 2 Mar 2023
 16:57:02 +0000
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
Subject: Re: [PATCH mdadm v7 0/7] Write Zeroes option for Creating Arrays
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1ttz3gkhs.fsf@ca-mkp.ca.oracle.com>
References: <20230301204135.39230-1-logang@deltatee.com>
Date:   Thu, 02 Mar 2023 11:56:59 -0500
In-Reply-To: <20230301204135.39230-1-logang@deltatee.com> (Logan Gunthorpe's
        message of "Wed, 1 Mar 2023 13:41:28 -0700")
Content-Type: text/plain
X-ClientProxiedBy: MN2PR06CA0022.namprd06.prod.outlook.com
 (2603:10b6:208:23d::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|MN6PR10MB7519:EE_
X-MS-Office365-Filtering-Correlation-Id: 0975d11e-881d-4b06-e75a-08db1b3f2513
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3/5Lm9rC5ZoW0KiR+GvdhbdF1NpTKQuszfg3M2QB7HbRlxg5x+NDuAuzkcLCyzw9j+RcgB1NxWHBxBcUVWTzJQKeo8jMrxH6wbEhBiYy0f8xf7xPb1G9juEVm2ZRfUka8J26L3B1dEY/GyYCSRypEfS5i5WPT9jm6lUCjoLq6+DAfDlvUvThQwsUq1Iog3mz1ck2RmSvgjSN/gwjRKoaiiJhPm5IW3q/SieCbRRr+FBhmhEhVKQ/4jxnWB2kzFO/CNPhgbO+h6o7RI2KwLY3tZENZQrkSqJH/DqdQJHtM9WIzkOgTVap0/Wlz/arHdFAlNag1x/o7zcg5DGG4djVrhZs1xpc8iU0NYQ6p7W7+HNqLf99Pu1ZMLujfEoHxJ5OunE3C6en85nBwyYotoBfKlAuz99OLYmtIOepIX2h9T6udUXPZVsCXYFb1n0WLOMhdIMqCUjUNF0qCpsJgWjTddI8kgGCULepVmPSONBYMMn3u9jyviKF6Pv71ZjL9/Ir6tks0SSiHweqka4aoxknnEznjbcPOuJoBg9p+DfCuG+B01W1W1sUxYaArv3kmzAKFtYTS0imqpzGEtI1ICAsIYJuGKej0hgCirEhNJDHp8yxGgyLNWxCHmoYQ9uZU32NTaI81CtCASyBUhgPuPv0Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(6666004)(6512007)(6486002)(26005)(186003)(6916009)(316002)(54906003)(41300700001)(8676002)(4744005)(66476007)(6506007)(66946007)(4326008)(36916002)(2906002)(478600001)(5660300002)(7416002)(8936002)(38100700002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HE9zTm44FGECmbG9BqkQ9RDnOrbvsTf5yhKXEAJ31iooR93UFZ+YdhS0WBLw?=
 =?us-ascii?Q?3ZVW3+HRr7/wfCut//IBLGj2kV3sw8Tw/7KoMjMRFX9+n2Uxa0M20wvgNVp/?=
 =?us-ascii?Q?kQbxr2lJBeq/wssPI04op+nUtOqDF8nR8R9aIAlVYXCdg7gQeTDWs64rK0Cm?=
 =?us-ascii?Q?zS6l7FkCB0wbqUCFPRJyOlcsYGEeRRia7Hqw8ZMHIB6N88CUYShspyEIyxFZ?=
 =?us-ascii?Q?cysTq+t0k0jH9J6rEjQzRvQRtkZpTyO1oSlWwGVd3QQI0bVVkoaazOY8GMKS?=
 =?us-ascii?Q?DfWvvH5lIdIzS4Rvemg0BNg+B7i6tA7Qn+W71+wpW7wrV9b8mrzmnMurEZ5O?=
 =?us-ascii?Q?DM2dJ8ntKnuYCIAosL9d/hfJT9AMRFOhgQ5nfsYNFewgMlEX116IgZTXoaGR?=
 =?us-ascii?Q?z7nGqzLAMJTW1x07AlM+cBjQ+OMl2yMvlTwtL8wCvCo2NkzXMjPHezz5IagW?=
 =?us-ascii?Q?TFDkYxJLSPG2e3J6qAU1Pp1IiuhAgM/Cu7mLvoGHlqHE1TVj8ydcfYqNT7Mf?=
 =?us-ascii?Q?AmkOj5ZSGRD3+R75Hvy81i7deEH9XedzerStq2SdDzjVekfnFZr+jDsyt3q2?=
 =?us-ascii?Q?Ru4+C7KRymojGwyPqPvVAJX0sbz5qag0N4LdOffeMq7aDqO5LqdwDbjfcu0G?=
 =?us-ascii?Q?4kd/X4IJHk47X7gxCnKGuLc1satggyCWZgtBmk4BCvX3O4c5l2C79fKQAqzg?=
 =?us-ascii?Q?NL3Wyn40EDH2aHLu8j3eD0fFEGsjTOuIBcn3oSwz+qnYk5Bfmq/56rsvaITr?=
 =?us-ascii?Q?0u5UJ7G6zmXpSkXS2One9Y2lEmL/T3C8/18xpvEdVJLloWEUHM7KwMyVZnIE?=
 =?us-ascii?Q?0Dzz6BCkx3UXn2FuhfSuaD0caPjMIm4eCquNpQocn6zYVjQb0ZcB3ka9hfOg?=
 =?us-ascii?Q?bwq8aVg1r4p9JvO6Evue7SXzRtwwkpQjWlNJXZXora3A9TP1z3k4JoeJVHRW?=
 =?us-ascii?Q?fVCJCIQ5UpDCQ/Cckpz2972+o6O/Zt5IRYqWX4MtyO9875ihPsaXrSTmeV76?=
 =?us-ascii?Q?0UHfaCvBO3pLokS4f/bf4lblwegtAzkF2gkdF7BQVQ7qW7jSaAROryuBz2Gq?=
 =?us-ascii?Q?KKy7aVJm/J1YmpjhrxTO9O+8lGstjpPlTuNAZJ3/NkIVku3WgTvlDGa8apWO?=
 =?us-ascii?Q?Bovxzya4f2oL72F0CKEVr8AYNaDu90e6w27imD9t+bas382fjduG7qPz6893?=
 =?us-ascii?Q?lT7C+DxPtA7ZcSybcEvRjCcxbKdXtNvumg9k42v5xa12nKlZIv/G1jMQe3G0?=
 =?us-ascii?Q?YlajB+CSOe4EUVXReCz8MexmVq/LQYGf/YLEDHIOryAjvq9Ju3XySa8KB5zU?=
 =?us-ascii?Q?f6/1cZni6v2OTW9KYd743D71jSrio1kLQWDrQg5v6hbiiokvjeHOuotUKgLG?=
 =?us-ascii?Q?T1Z+wchFcb9RHzh6z+C9Gd+sUEwAWYcwnFs3skO4fdfBTlYyncwxStZuMjdn?=
 =?us-ascii?Q?ZWkbJcvxKJh0ACUTg76fKH8vnXno3Qu0dwW3x7Kv1meTWPU4DTVgw90xPGDc?=
 =?us-ascii?Q?tAFAdAi+BbVj8F3j/ZYjN5Yhhly5bC5mzXxhV4PCEW+HLaEKHx/L/wWIXxSy?=
 =?us-ascii?Q?diY3OqAA4XIvZNEo1HxQMKaeJK9AaJ1gbv7rviB6L3kqZrLcOWzJGIyC+5Ie?=
 =?us-ascii?Q?1Q=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?i3PC6HJUPfq5bHwrt44XSGxZN/d8TEebTy3m8r4YeXt2vQ5DJpP6HZuNx0Wz?=
 =?us-ascii?Q?Lube/bbsSl6kxupjXpcR9rGO0F6P2jMFWjWTwQvrl9eQ+z2Si/+7iFYL93sL?=
 =?us-ascii?Q?+ys/bX8MYBfzmtImIMLpraxDtr/NUdcKeJLAnPwU4/cWCVfNajamLZOSWclP?=
 =?us-ascii?Q?t8wF7Qr0OuMJ5V7qgg08JxSAMNWrWTBXIohCmWwRFMyyRGybMb2SuZT9OyAt?=
 =?us-ascii?Q?IQFsvWIeCfsoQPTgwrkH7mgdY+xQrmnbxFbVhEBFCg0lfGtkbHHfTG3iguU4?=
 =?us-ascii?Q?FDhnCbXIMg7vGsguVhGcJmxXYxaOTtH3pDTl6af108NoFy9u16g+2Xt3qG1d?=
 =?us-ascii?Q?fSSvW0r72TWeBeBxp4vKNYni+XVZXvUoQDuXg1dIWg7zXvd3qnu2igmF1YCx?=
 =?us-ascii?Q?iSXno3lqdsLymA4QC9oAEXfvMi8FONS5zOxH/5NWFIqmmjImgEt+W7fdeWBM?=
 =?us-ascii?Q?HFtA5M6BziERjgorZbN4OvEyMqE6CJAVlf6sFEWm//xOMak4zvIZH+RL6CLp?=
 =?us-ascii?Q?9QSkxhIJR6yzlQBj5aiRY4xD5OqTAykvSubtZjedQbPzc0x3goQoZ3XdQAM1?=
 =?us-ascii?Q?Oa6AXm4Tvga0x+5n7LtXirNMJ6HPoXZXufdAcV6UikX3Sgc507ZA1A90QUdE?=
 =?us-ascii?Q?hTGt3xAZL/CPk4qJbP9kdDSxI3Tw8EYrlMDWzkqAcfeqzrXq9fyagjuPlpiT?=
 =?us-ascii?Q?gpmuVWBOUQDAF+NMy+lqoqg/EmDtFlKc9sApGEk+xFkS6Zk3SDHDpRGA+TVz?=
 =?us-ascii?Q?t2vGJqZVcSTSPS+Ef3jE0vld/VthVG4sGb/BYXXKlwl+Ix8ch2lWZWOMB7sC?=
 =?us-ascii?Q?kEoa+aELji0tKWbBdBEYukYnNG+MK/u/+FrbNykaPHzWAOMK/QRKnzNzAtyT?=
 =?us-ascii?Q?uqbN+EBDXUs/U0QR7/22LgtfD2xZ2uBx7/3q5eChKmtLHnknXXAprcw1DCAr?=
 =?us-ascii?Q?hRRBmboctudkmXTJUGbfbGb18aB7MeBH8FJ6ZOPgSPGspYnck3SuYvbVsK4B?=
 =?us-ascii?Q?E4fxDnBo4BUxy3a3GP9TOBTZX2Dy2L2pQjHo7E6BQPvAc0XfUnYahYJZYmIy?=
 =?us-ascii?Q?qVQhk/qkNIYzRxBIvL369WaWy4BNSg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0975d11e-881d-4b06-e75a-08db1b3f2513
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 16:57:02.5267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Af3vMW3QFlvg2fTG7kVVzPFNRTBRbuKyJaDDwNdpHklMGYF9TRwq8tn9pbBbt1BD+OJBmvmJ31zTEoXLUpewQSLCkPCn2Av5M/rv/QqaNyw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7519
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-02_10,2023-03-02_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020146
X-Proofpoint-ORIG-GUID: 8pEULjDh_29fa4JVjX5CvfpbmVMoKUAH
X-Proofpoint-GUID: 8pEULjDh_29fa4JVjX5CvfpbmVMoKUAH
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Logan,

> This is the next iteration of the patchset to add a zeroing option
> which bypasses the inital sync for arrays. This version of the patch
> has some minor cleanup and collected a number of review and ack tags.

This looks good to me!

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

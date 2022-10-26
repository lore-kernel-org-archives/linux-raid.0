Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F22F1C38A02
	for <linux-raid@archiver.kernel.org>; Wed, 26 Oct 2022 02:42:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232575AbiJZCmb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 25 Oct 2022 22:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiJZCm3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 25 Oct 2022 22:42:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA4669182
        for <linux-raid@vger.kernel.org>; Tue, 25 Oct 2022 19:42:28 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29Q1nZ06017447;
        Wed, 26 Oct 2022 02:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=fvk8CwCnGvACqIiG5u1SMcLUdkQ+KkShL94oU0ThpIU=;
 b=kgRGHugQnmwnDVdqvt+XcsYbr7kPPU08QYWOWSClXsqvzWwsyHhsGHGbL3m/SEo8Q0mE
 MDePu/oUVfgqfISlZU/m6WfcGNhd63tl2cqTkcS3XeHQkAAWx02rXtVypUjujMIFv5pS
 zf2wsflHCfKn/IOUHH0wm5fktgfUIVhRWeiWshUlyYPuuvExU3+zC/5NlOibs957da2Y
 qsw1lznIvp0+EZ6MMJhccatXNbafWeUHEH9zcXpnk2z8gvjpgcYWb9kdy74vwesFtvWJ
 tZYLJNW5F2iaPWIYQsUDBoy7YOct/O8HKuw1orU/gRhGvulN5L+Udtvtt1rho/L63dN4 ew== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939dvqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 02:41:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PLre1m038374;
        Wed, 26 Oct 2022 02:41:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2107.outbound.protection.outlook.com [104.47.58.107])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y506cq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Oct 2022 02:41:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AYtXFqYU7J+tdcZ+T/BpYf9rQcTs+EkouvB2MavHsejpc22e/OuiAgLZuGVJlSls7eqEmDCWoYbd+2/iwZIuFRasL/9S1sTajL2VYPChFvixLdxj9Rmip2qE7yyqzXs/oEIgu9m5rFy/CyCpBpwnZTttacN8UMHAydqn8Hlg4ZVcvi10dQR2eRdgBPNe+f+K7loncnL7CPj+zDaaSjwN7C67ku4AjkKLNARSWja3B3NN4iTWzv+wRGV0TFXOYGnFYsQOrDZJd1PIssdTwVLcEBuVrdmKDzUG6xdwc15ngvN1/zDhECUFHqI6mt0OK96Lz3/mu/c/b+ynx75radBKIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvk8CwCnGvACqIiG5u1SMcLUdkQ+KkShL94oU0ThpIU=;
 b=kAZgsBRG0YltKz7cNFQKvwNgVvHum68McTYauDJ6HxwQWphywnC2hNPX1BgJfRyiL5+mEvxo/zAvVLIVlX1iBu4MY7ueUN4bc+xZ1D5031siPEBEJI3ZKteB36jx7rW6c7HFn81vhBiVy7M2raBhSivwRcJvzOfdFjsP1L3lX5mzJsobtLRXQL24ZkNEEirLxaAiBRLORCpNfNz4NsZS1yv3ZdaU2qceJdUu+NpXNyVjFBlFQTKYYW6eHv4Z9FbsmwKqjrEOwa0qwd1BelFEwkia/ia4io0qSuAY+vZrMRXDf0TAHzF3KG7XsfgRVKO7cR+4UQFCmlWu8n1f1pAD1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvk8CwCnGvACqIiG5u1SMcLUdkQ+KkShL94oU0ThpIU=;
 b=QW9YRhXckmLaxsa5pz8fVKdM6jvynQvSj4GQTKUeTrRjoWwBL9MJfL0Xpw0nYobuR5TJJG5NoQbrw8oOT1GupRDa4iI036bVWKFPILpk60Y/b3/OrQPHjRuBtMEGcDg9UjgjnSYLLJDUoUvrCsBOCBvYbZrECtXRzjzMoAZKG1M=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4536.namprd10.prod.outlook.com (2603:10b6:510:40::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Wed, 26 Oct
 2022 02:41:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c%7]) with mapi id 15.20.5746.028; Wed, 26 Oct 2022
 02:41:53 +0000
To:     Xiao Ni <xni@redhat.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1tu3rtio1.fsf@ca-mkp.ca.oracle.com>
References: <20221007201037.20263-1-logang@deltatee.com>
        <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
        <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com>
        <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
        <CALTww28XKzYmKrVQn=yYyq3xpjcEDzz1Bao+eLx3LR5mbm333Q@mail.gmail.com>
Date:   Tue, 25 Oct 2022 22:41:50 -0400
In-Reply-To: <CALTww28XKzYmKrVQn=yYyq3xpjcEDzz1Bao+eLx3LR5mbm333Q@mail.gmail.com>
        (Xiao Ni's message of "Thu, 13 Oct 2022 15:51:12 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0093.namprd13.prod.outlook.com
 (2603:10b6:a03:2c5::8) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|PH0PR10MB4536:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fb836ae-903c-4fa6-160d-08dab6fba418
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lP4pzfsRyagFrLufOPd9VUzIQN9tiafO/U9q4fhttpIZMLMhULHZ/V1c40vAAn5+LL3JIZ2oAIUxuy+115cfqTZkCyQT7sFZCqlxC2hLMV8bGNnpGiRVCgTYpq826ygLVBTh3z8JutGkXXWuYNfTYZHRvg6ATAyUf1AVRffmlIVvCgoYD1gYy8FbT9uamTs7FFw1m0EZmBBHe+ksLv9fjOL85cd0DDTFckpKhw6Gh6HlRVfT71R76ZCOP3qAlOLz34r46tzBKETSsTWuV6K57KVygKmNRBqLrT7P8RxFqebw0Ltng/wW4PQ54KTJ8gQUdTU1jKC+04I41Gf5UW6S63HtyMCsMrPvWD5nNdx0Hq++S5JoYWU/k6/zo6rvGrdeL5+kg/iOq1K/TzkIhcbeFeq2iPkPWA8zejzlj0tm5xnitZn0n/TSGPz0nFYYsaYbInXcsmtzQ7e9k77guz/B+hJUdpkcCpaCHbfkrCxYngmbjwk9dwJiZxQzCeT7Pc15uQRUxfkONjKWr2gOEt0rkigcmga7W+srLILI8DQwzhfja9+X8FyLmnxDGoBxDWeG0mQECyLIbqFhhEN7WAzklHwDmiqsnSEcrc+fOCOUhyK0S702NP7wV9+yYW5uesqAt8l474YxJgNa0E63XCgivlk5myJXAPOhEpHMZIFU9Rd8L3BAOgH02/EVPhODsBnv9V03ixBOQr5mMdNGCgr6Bw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(366004)(376002)(136003)(39860400002)(451199015)(66899015)(6506007)(316002)(26005)(6512007)(54906003)(6916009)(86362001)(7416002)(4744005)(66946007)(66476007)(66556008)(4326008)(5660300002)(41300700001)(8676002)(2906002)(8936002)(478600001)(6486002)(83380400001)(36916002)(38100700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FLTEu6mM9IjzZZr48LyST5YOtZCwwojUbY2Qlw0UiolG5kvDVI3PqYl3rSDd?=
 =?us-ascii?Q?SwoQceWw57MPuDI3MJAsfaPwDeROR+kVqEVAXsEZs8iRf3dj7KZ0RW+blqYB?=
 =?us-ascii?Q?pF8MX/oPg0OtgmV+wbfwzeF23eYylgB6CqrL+pX7ZQ/bxIek7PC5M6ERwyqj?=
 =?us-ascii?Q?XIoX9/iBK0tY2foRT6HWyG8Gnjs6HjuzZnIvrMuGHWmA6X8CbfEBKBY5LI8J?=
 =?us-ascii?Q?M8tESgHsgQz9WlgmTd0d18D8Y64yCsOP+OuEaD3WJMHrFrDr/Byc2hs+nfUU?=
 =?us-ascii?Q?UoS1IvzG2hGYZDl+K9oiIXgjHqFvBi+Ci2VE5lzf72fC9NKd61HzjdtssC/M?=
 =?us-ascii?Q?DaCdXq4clwmebxkfpn2ArmtcJiQkaNRt85ZZr4y+I42bwzdKj8iKUGfRApj/?=
 =?us-ascii?Q?mvaNADUI3n5oFnhsH/i6FrlFhs+xDisy66fgG6Pwo0ecTRE+uCS1cyhK8xUu?=
 =?us-ascii?Q?Dk7Ua4nRgEce+qAH89hFymNO2M2+U5O+6D00vJIVhEN1HrqH2CpIAbkcHPaH?=
 =?us-ascii?Q?0wTp1sE6HRwDq6SBSde0qInw0TXGJCxnt774WJpfnEOhUbioFnHvjVjkzl8O?=
 =?us-ascii?Q?ExG5546YxnzMpWF9Ao4vKWPY/ya6zaW42wkdk8jMAuZVI9GKvj38J/OZ4BXl?=
 =?us-ascii?Q?8R7tYECaC3r+vkQp1ij8HZmLT0cKtWU8yPj+24jqwHyMIJKq/iA4+XE5Jktv?=
 =?us-ascii?Q?ddlYLxVGkWFQQfbjFjm4vuACXjK++bQbQHnUIlmGm3eoHOrW3qQERd883TcS?=
 =?us-ascii?Q?V31QZmkfUpcM7YYFzcP+WXYPOG4nDBo6GNkvOqbHpUnyYL7JjdHPyAxq5Djq?=
 =?us-ascii?Q?P62uZwNadGkNMTZONHLMbvd/d++/OIJHxezLf+fdLljTda8UpEFFsvosexWn?=
 =?us-ascii?Q?Jg05dqzXGGHFrm2t6pi3Zg3Fzq7CREWkCb/qYx0TYp/mN8HPBpYL82FFuqH9?=
 =?us-ascii?Q?kHhcZcnJbZmS1wB4gOkx+vHUA+AqFuHSoICmBvz0d7jcqSguaIfWMDyoAQ2J?=
 =?us-ascii?Q?kl236ERcyv+Xq8BgENYWtHfY3jCuZ08PM6e++UsJGKzNHs43pqHEt9FNE4ha?=
 =?us-ascii?Q?8NB1pWn1QI8gDHieaInOYyFHub3v46EgrcNR3YQXxrw0ZWvSwAWJ3fOT17qi?=
 =?us-ascii?Q?nSetqlCcK2hHqyRs6xnYfJM437rGiJCOKa9xKT8J/pyDfEMw8L3eImJLe1sd?=
 =?us-ascii?Q?n8aAXB+QoCrt4F6Rwcm7aZr0hTdbQeZ+WD0XN07KhY3K6Jdc4SDlBoQDMcHN?=
 =?us-ascii?Q?FDvWz/SzeuYSRR6lz+J0vV/aUvLf2hwb50TadU1DLIWPKtYcT0hmobCdVfx/?=
 =?us-ascii?Q?4oEIlkR7+BOQ8RMBpP4QHOoIJeZrKjtQ0sPygpbGJRIHfE0Lc/VMcECSQdmN?=
 =?us-ascii?Q?b4YWkeFT+4tOcjMQ0LO3m/SQXVtb3K9VnxgFj9JT+r0FJ8X6krY56dPVkM9Y?=
 =?us-ascii?Q?nENKj7Ar16lMlSRg421LQI4p1rOBiPL168hnNXzyWSEMNU9Xtuqrbwkf7sDt?=
 =?us-ascii?Q?sbmTxmMj/1+XSGAxdbvD4+KqsbLXx35DLdERPkJHJPoubi2JkQe+JXXUjH0j?=
 =?us-ascii?Q?bM268yOuJlvZDDLld70wh84UKUgq6GpkM/6kTOqAtpwKy/nX3ykxmK2pQ4Li?=
 =?us-ascii?Q?8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb836ae-903c-4fa6-160d-08dab6fba418
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 02:41:53.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N0YO8H6n7FD9HO1vFJ9hlPqK6iUOwGqQmngdjAde4MoCAa+EqbjB0S741YZH/vkAf0niK/ij86SjV3leBqKmvryITLfuidvsD+wWbZc1rPE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4536
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_15,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=727 bulkscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210260011
X-Proofpoint-GUID: EGG6ZitvaL5sYs2M-CkVAgR1m9ykijWV
X-Proofpoint-ORIG-GUID: EGG6ZitvaL5sYs2M-CkVAgR1m9ykijWV
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Xiao,

> If the upper layer submit 1GB request, SCSI will split them and handle
> 32MB requests in default. If the upper layer wants SCSI to handle 1GB
> one time, it needs to pass some information to SCSI, right?

It is the device that defines its capabilities, not Linux. If the device
states it wants 32MB per request, then that's what we'll issue.

>> In NVMe there's a limit of 64K blocks per range and 256 ranges per
>> request. So 8GB or 64GB per request for discard depending on the block
>> size. So presumably it will take several operations to deallocate an
>> entire drive.
>
> Could you tell the command how to check the block size.
> blockdev --getsz tells the sector size of the device. It should not be the
> block size you mentioned here.

blockdev --getss will tell you the device's logical block size.

-- 
Martin K. Petersen	Oracle Linux Engineering

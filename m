Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC91C433FE
	for <linux-raid@archiver.kernel.org>; Thu, 13 Oct 2022 01:34:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiJMBeU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 12 Oct 2022 21:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJMBeS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 12 Oct 2022 21:34:18 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A95103DBC
        for <linux-raid@vger.kernel.org>; Wed, 12 Oct 2022 18:34:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29CMxIec019012;
        Thu, 13 Oct 2022 01:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Ji1ECKUxJOBaGxWKGfYaAHRlHe8zG8IDD0GRea+MVUk=;
 b=gCX3RVYJCt/OBQGZjQg+PBjTyGtPIzm72x4D6UystUUcxbPzDBl0HGeoqp4j7sbEZtgM
 m/zGDKc3iGn+T42kb4WkjCj7bW3+eUBL4OKRElfCOjLFx5KeZPlhZa5hvpEh2HOwK9/x
 oM4B4vOl59Xs71IJ9YQdHI9BLpv7JD7lRa0AqAtJgZBFpIrAWS0uqCoV2kPVzi6w+z+2
 pmmUvV2I6cEpcMs1YQGgTPzCMZqmNdzUImsqYlQhsbMV7A/noOoIQDzeEHFcbuyL7ple
 ZWarVoNg5zhZj+mHV086B5Aa3dJjwD2qwWsnj7ZpQzr0FcYh92z0MOoS02BEI0GUyLDe kg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k62bsgr0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 01:33:57 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29CNoQpI016222;
        Thu, 13 Oct 2022 01:33:56 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2049.outbound.protection.outlook.com [104.47.74.49])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3k2ynbrk7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Oct 2022 01:33:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j5Vu7eXHfZbZ3aaPD5ImTHYk2jfVyZsgPAGQGDIaTyCRuGSBqtYWLfvDS3mGvXggrZtcQVgrR+LltcB6GOFxb80B2H5khI8ycoL8cC0mNMM/ksez9kjcYRGa77gNqwPJQYODLeT+AI1EH30MYAh2+ub27vJMtug5em8t8kraymykX09CqTKZuf3M9StQAvQJUsDOeBWNirWNKhZRMpjyWmYmXGdx7fHfs/HK+RdkkXzQA7BmkWQJPGjHZl7Ol3ZwL9xp8kcPNtUd3ydSQSGC65OX9WISjHZEEj3JZg5bf/ebIyW92s5elwDkIEUGcBnblr4yIVVT+TOTRXhOrLP8Ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ji1ECKUxJOBaGxWKGfYaAHRlHe8zG8IDD0GRea+MVUk=;
 b=KHuLzzejMnlGyrq+4KS6g5uHU9tUQ+HiLfUuLaQSw44ndXo0Lo5utfVJ1gHrv2BjUJofeGQnEoExKnwfr32Fx10EPlEPhi3hMIVepxkB5mfCrecmc+nydSPJr5EQesCR+HR/kafsIrO064nxbPyeMsp6XvDZoyLFmNv8vG4P+x42rpfjOicYmLHbgNChoDLagfxVkAKDv3WsAj2Pg0h9VontKOzUbZsRvTX6VfmdIiKDB/Ba/j94Eh2PntkX4T5V9cSn9tdbGCsSPeYYo9Ja2YGRrkmyVR1Br705QIVBXsVedNF4xnwd/I3q4IBNEPJuy5rbWYfK+vR2SDelUtPJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ji1ECKUxJOBaGxWKGfYaAHRlHe8zG8IDD0GRea+MVUk=;
 b=IoUzAaf56hT+P9nYMxsRSrMdhyrhwyNm1FmWE8/XKa8X1rrZDfcZkERl4h9dZG7ApwlAKbbJ8BunJ/HRAAyt42/gqtLi80d6YcJLvTn814sG80lZWBd6RuVD15sXMlAcNobJpq1ocowUL0fZ357dgwDK6m/Af2yvJeyb9ZkKAnE=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by PH0PR10MB4486.namprd10.prod.outlook.com (2603:10b6:510:42::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Thu, 13 Oct
 2022 01:33:55 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::13ed:5c00:56c0:93c4]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::13ed:5c00:56c0:93c4%7]) with mapi id 15.20.5709.015; Thu, 13 Oct 2022
 01:33:55 +0000
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH mdadm v4 0/7] Write Zeroes option for Creating Arrays
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15ygo4jkv.fsf@ca-mkp.ca.oracle.com>
References: <20221007201037.20263-1-logang@deltatee.com>
        <CALTww28HQUPbB647oP9WKvkLX=9PqZv+9am-884zZVM923H-KA@mail.gmail.com>
        <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com>
Date:   Wed, 12 Oct 2022 21:33:51 -0400
In-Reply-To: <8ee5368c-1808-d2bc-9ad2-2f8332d2704e@deltatee.com> (Logan
        Gunthorpe's message of "Wed, 12 Oct 2022 10:59:45 -0600")
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0017.prod.exchangelabs.com (2603:10b6:805:b6::30)
 To CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|PH0PR10MB4486:EE_
X-MS-Office365-Filtering-Correlation-Id: 1856085c-a16f-4366-db89-08daacbafda1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yns1ya7TKZYYkXxzwlRFelopTaMFsd07jOuri6XwCL1oGeL4F8fOPNrwc82MJfv7SJbKk5GXrVW23rukfDXcgROulBCJANQ/SBrCJBS49berOtGMZcXcEd/VWPULyMZ5V9ZhUIk7H9JHQ1T6Dy9TqoHxsDBFT9qOs55r2HeGfgd7O21DTNvjZsYkkLnbiQlNQYDUEgidh3kX0ckmQGLrgfgRaikNNRWhw0WDAv+0jdPX0nFcpFkGeKegzoJhBERLJ1xJ2Wj6EMFGDCoYWMeToZuRe2TrXU42t9i4nPF8tBtqAH9ydM/lGZze9FGXzorLK7Uebyu9mqx9mM/y7Fl9+YYrQDLaiQ9uTUbTJU8a/1QcDKx/ujVn9tJzgLw+zJ2ZyZSLNEcURCpBz8igXeLuHqbX9TnfhhLYrF9H8j1I7xFQ/6E1wy+HR4x9OjxJBr9bW/QisjEPtL3Khe03fm9qxsNHaTB7ma0w1qaKBjPZH1DUDNaB6JjdTHh9aEBHDpDnbNnOg2XQYaxmnhUp7r0bAJCWtmIgP2MmPJ3U6I97ivnGh4reWTMmqolY2cDjDlPsqgSz6A9a1UQD+c2fh4jW39MVhDaVmU/6BF2iTQDEc3o+/6iiE2GoV9TxZpHN0FYwezkdHMYN9uGMFlQQlknrUPoe6mYiy5eCoZmMgBhEkrWk2a4izKiOVYJEwIU9e7Mr+/kRUXUjsspbeCnFYAOI/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39860400002)(346002)(376002)(451199015)(107886003)(316002)(6666004)(6512007)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(36916002)(6506007)(38100700002)(66899015)(8936002)(6916009)(54906003)(7416002)(41300700001)(6486002)(26005)(478600001)(186003)(5660300002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5cjssCUkIMgPRqhhnS66kshhLLl4aG22RM4nlnzU0CdUAWU2mtiBul1ki9St?=
 =?us-ascii?Q?71bb0hck+R+Nqs2etIeQd7DbL8kbzbFP7ox9pXx//klZ5egi4maxVBRh2vAk?=
 =?us-ascii?Q?iH6/WrpMzVdVfG1O0rDSgGhEUfpEz2cU8VrpNWdYuJ3VEmbZ/vITbo22wbVV?=
 =?us-ascii?Q?RDnTguc7vx35X7lOagNHociopYFaQcsZLcU7itmdWL8ahRYqFUgPZg9zqEu1?=
 =?us-ascii?Q?pEMQPznfRnYKfvrZY+LtP9wvR+sHgjsM51aR1ts2d7t6D94Jt334BSJL29an?=
 =?us-ascii?Q?3YmQQJAFysa0RkvMbs+22lBiBxHziQ+fm8ddvxbfgqT8Mdkkv8TyB8opScwJ?=
 =?us-ascii?Q?UMaVIW+xXu4d6d/dl2suVecSyihQrO45rA80BgLNYa23LuRLntQWT5WZEYIT?=
 =?us-ascii?Q?Thq5qe8+PKKh9aOhEKDeIAuH0qtzHNvxYqP4KU2NhH4jDFwiHH9ALog7D7me?=
 =?us-ascii?Q?P3pD4uRTXN0TYCO91iDOd1tw8OTtZy+PAKt3CBK2pi8Zf7YqUPHQie+sK1UB?=
 =?us-ascii?Q?ouQ0bLFD6ZHyFjHtRZAgcmCjtQuAigb0fR0NVywPckl4yJ/5znRusvF1xVbv?=
 =?us-ascii?Q?gXQq6O7GjFnrIrauJjcvKuQqNpru+uLoSKJDmB0+RECig4LetMQajVpNBwKa?=
 =?us-ascii?Q?oStka9f8gBL1IYD4Qml6AomrXjgDsD/WuajMy7ebeXgAY7lIqDrPe5A8zkdj?=
 =?us-ascii?Q?PWOpxkyKM/QjFEujvhaRP29jXCEl28zqOHFi1hEqGL2XCJomAZGLjDAUC03H?=
 =?us-ascii?Q?opSbM3i9hyIGzhvP6zn0dC31pLjcULeNRz399cmEIHNxEYDYrkEv1HQo05fQ?=
 =?us-ascii?Q?3vqmK1/YI9zYm1D3+kmm0en/NAz0cPLp4KP/pE/MavIphoVGBewAxCNqyjvz?=
 =?us-ascii?Q?U8p0wOveNsa9m6O8I7gr/YMYCxBEEUjs2UlnOGYl2snVpAic5lAB8k6ZnIYc?=
 =?us-ascii?Q?Z/KE4DytV60DHCts4kbY5PZcKWDvFW38sTPP7JLeZa/DGM65qbw7s+jAi4YJ?=
 =?us-ascii?Q?KVOeE3L/nSgiSEd1srrK3hjdQiFvf2YBLt0af+QzmNC2KgIFrs6So3tjF8R8?=
 =?us-ascii?Q?dmBELepN36ae0Ke+hSzd5XMHBhNne1JUrOdKlILtbHyA5yrPVQttYaRewqHR?=
 =?us-ascii?Q?W7e6enLNYpMKWjiec2C6RXz0ehidZeuXzhfRxzYdSQrOJpU52nBJOYx48dF7?=
 =?us-ascii?Q?uOX4r8i5f469jyoW9aAQLzfylhcJ3Gn4/0LbJ4vCSXHk9o6UXquebljb9YAY?=
 =?us-ascii?Q?Yr6MNPiRilZcO58biWwuVEjwRwGq/i7PerplkWL7LJEQJoxAr19W/JQHSZQI?=
 =?us-ascii?Q?uKUInHHeAturr7IGUAM38RViBaKLjPwfo2SbYw0gVf6r7NPIMKEp2njEgYRd?=
 =?us-ascii?Q?YoLVXF2CK5ooO+VAXnShu6kQAiX4xBW0PIQHwHdKsfzqQFGX9XIKr5iB9fw1?=
 =?us-ascii?Q?luYCPn25oaAM+VXwSVZ+B/d2uRWzMv/y8G39juT4SQFcHLg3kYmkfoZrpDrl?=
 =?us-ascii?Q?+1wmBOLpdFc3rzC90FewHoeS1Jq+MLCFYCy727q739ZclSw5WQU46hifipU7?=
 =?us-ascii?Q?BWCttOrJEDqp8B3siJiIhvwniOdw1Icjl4cT6d9tgxjNtQwNgJb3vrdvilMF?=
 =?us-ascii?Q?AQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1856085c-a16f-4366-db89-08daacbafda1
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2022 01:33:55.0639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AA+kjbbJsB3L0he37cwcQLzxrZ1mY4cxbVzoCVXSYrj3t4GoHaKH1Rsa1umrIjwQN0Wl2peSj2dot/8gWX6k2P9LssW2AUf/12L2hMZbGvo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4486
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-12_12,2022-10-12_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 adultscore=0 mlxscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210130007
X-Proofpoint-GUID: IxpUpW-dnvnq-77KfNInM1GEcN_dghmi
X-Proofpoint-ORIG-GUID: IxpUpW-dnvnq-77KfNInM1GEcN_dghmi
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Logan,

> 2) We could split up the fallocate call into multiple calls to zero
> the entire disk. This would allow a quicker ctrl-c to occur, however
> it's not clear what the best size would be to split it into. Even
> zeroing 1GB can take a few seconds,

FWIW, we default to 32MB per request in SCSI unless the device
explicitly advertises wanting something larger.

> (with NVMe, discard only requires a single command to handle the
> entire disk

In NVMe there's a limit of 64K blocks per range and 256 ranges per
request. So 8GB or 64GB per request for discard depending on the block
size. So presumably it will take several operations to deallocate an
entire drive.

> where as write-zeroes requires a minimum of one command per 2MB of
> data to zero).

32MB for 512-byte blocks and 256MB for 4096-byte blocks. Which matches
how it currently works for SCSI devices.

> I was hoping write-zeroes could be made faster in the future, at least
> for NVMe.

Deallocate had a bit of a head start and vendors are still catching up
in the zeroing department. Some drives do support using Deallocate for
zeroing and we quirk those in the driver so they should perform OK with
your change.

-- 
Martin K. Petersen	Oracle Linux Engineering

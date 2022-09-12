Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD3BC6FA89
	for <linux-raid@archiver.kernel.org>; Mon, 12 Sep 2022 17:44:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiILRoJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 13:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbiILRoH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 13:44:07 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0671F619
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 10:44:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CHXpiQ009153;
        Mon, 12 Sep 2022 17:43:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=dJJV3pY3ZMqjJv63gy+cn2OPmU/5jygmZECRUflbSZY=;
 b=kGH0UXA9ixstI99rtdwb/m9HFqvd1HSrD+MDO9xThWydSFnCTC5dpdsDBr04QHmW8HCy
 wBY6XpT0nKJrBjaMewM8N1i66nzFB8I34YGdg6dKYICXVxxWr+aW9paA4OVYsf8vf5JM
 OLqTkndmIopqoKnq12xPYpobuHIzTao44bROaZmi01Dae+pq+vGV1pIKOD2Eurx+huU3
 zUG4FzGOw0ec2e6dxzwYtAgni8bpT7HfM4X35UHluiiYwAZe85HWAPy849+XhRRYlK4P
 GhTEx9b7G7BbfTodimiKeJIG0K5RqCZJ+VkQkiisWn4GJ3X/9LqmmRmnJdRerMUV/PEW mA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jghc2mare-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:43:45 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28CGwv6J020465;
        Mon, 12 Sep 2022 17:43:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jgj5b9va5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 12 Sep 2022 17:43:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0LHNxRGhJG4Fh5NyU4lXFYroen+A2Z9FXwvhqo0Y4coAIPmdbcIjoWy2SyjnxOpbu1D+Sv0dsaY+hSxnM5iXIfJcVY8R2C1AuTu2GGIAZ9sKCYfRXC9QLplSwpX19o0QQuXwJpzM1ylF9SHKo/6Nz4fey67IcifhgjRXVxwG8vUSQyu+97Dm06KEBXIwEciCiRnYhWyPV/kX4x6nEj7j3xfiBl0sEWU09jCqGPq9KXqYyhfYOc+pWAOpbeLqVYsrn80hF5ABeL8WkYY9XPI5pE2VOlIqjWvQI3QRXAgRPP/C3tZlznjgrxSjZwFyhhfA0qCNfDkmRDz9zg4rcGWPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJJV3pY3ZMqjJv63gy+cn2OPmU/5jygmZECRUflbSZY=;
 b=eX8UX7746o4KMUGQ2eZRIwibu2svt2D9NrYOJ2/+2ZUz7zETjYe2wNAmNLyP51WaS/8459zUQeO/5oYd3SgJnDqiJaPwDiepUsC/4Mu7b67VZflZZBvYxJeA3dMztFAxk2R0WQmDIQJl51iGIOadukqtxKOAkzAhnGH9hq39VZUi8wJgDXj8eHjQoSifiKkb61RcNEL2v0Gch+CXoMaP1qhtI83vlL6OGlClEztUEn7Lqfs+HhcKf+uYektZ67a7z882tz6c1TpuTizerwWD4IaECGoDAcZ/vqgMwLe9vSErxM3qopzcm9cJtHjFhiVPNP5Kj1NJRCpos7/v6Hgx4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dJJV3pY3ZMqjJv63gy+cn2OPmU/5jygmZECRUflbSZY=;
 b=Wz7QM5BLyb+Ja878HTb/rUUsyVxubD3f9ixUiZnq46barcg/R7j0Vd1XW/hDfrl5ERbrNlFL27iub5t2oPVLx3aChyEfV8jy3gxKrHRk9/xATmSp3Bo3oaNy2g7WTVSvXoWToF0lSmujs2ywP59eMClpBEqIZiFtlvVFbrhAnGA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by BLAPR10MB5265.namprd10.prod.outlook.com (2603:10b6:208:325::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Mon, 12 Sep
 2022 17:43:37 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::297f:836:f424:cd75%3]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 17:43:37 +0000
To:     Roman Mamedov <rm@romanrm.net>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>, Coly Li <colyli@suse.de>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
Subject: Re: [PATCH mdadm v2 1/2] mdadm: Add --discard option for Create
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1a674bie5.fsf@ca-mkp.ca.oracle.com>
References: <20220908230847.5749-1-logang@deltatee.com>
        <20220908230847.5749-2-logang@deltatee.com>
        <20220909115749.00007431@linux.intel.com>
        <20220909165417.4161b5a8@nvm>
Date:   Mon, 12 Sep 2022 13:43:33 -0400
In-Reply-To: <20220909165417.4161b5a8@nvm> (Roman Mamedov's message of "Fri, 9
        Sep 2022 16:54:17 +0500")
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0062.prod.exchangelabs.com (2603:10b6:a03:94::39)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|BLAPR10MB5265:EE_
X-MS-Office365-Filtering-Correlation-Id: 764069dc-af66-419d-1f09-08da94e651ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NrhQ04bemcUEK6xmpo2LVHU3BnUbe8avd8OnXxC25wCPR2TkrJF2nySFi14ZUyEQBmUGHX538LkqLHJ+HkHt1GfJispT+qvA9++xFMdX0k+mGAnNP1StL0ljcNQcZXNRMBqsKR/3XUbTLa0HZOpD5RJm31CufJsb1HmeV0JdCw/GSNrCOzf2fHBWGmLGeZFGmQ8c8p+J5AMQK3azhYDLnGM8NreaDosjgC1uCH4Q5npvvW9rdkc9m06srmWpuo7BL21aW8A0/esHJTNn3ReXNAdRq+XBVYBhh7w7o+hDHhMtZE0d2OKSdkYvm3gInzaSyGmRiSD+i3QOj08IsKMLVPx3ZYbv/VYI5SFir3rLTtt3rQQKnKwI9LpZF5nps7/A9SJsdmEJm2N5FM87Lbdi4LUYZcJ3b8hFJ6E+/M/tBZ1W7YLJrlvpnFYSMv3OVuHdsTSa3IR4luMoYgWqqxgDI4aIQt53DKL4Fzfnvi3Ub5NIsNQRR/nCc6QNwtsgV0QvXhpif+deZZYg/4pQsGByAmscxFbtkaQHcM5ZXrlk8gfSDeYNNrsj1Q9Qv34b5mH1cKwUAhiZBYYyjgRhmxYO6Jiju8o52qA/Se3eoAYN+HWmFQf1dxcRcGI5OhcNviLDd2ehce3Qu4LzHX8NbnIrQN9y2Fs3U6cybuesRUUxP0E3KPCj+Fw/Z2+fdTMCD5MGU3LJkKSZJZ310ddB0U0/Kw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(136003)(366004)(396003)(346002)(376002)(451199015)(6512007)(83380400001)(186003)(6486002)(26005)(5660300002)(36916002)(8936002)(6506007)(86362001)(41300700001)(478600001)(6666004)(2906002)(8676002)(38100700002)(4744005)(54906003)(66946007)(66556008)(7416002)(316002)(4326008)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0AfZor85b5ovvUTxZ4HS6FfYqLTnOwgr8Ofeh3Lgi+ODBmMMMAf3TgM96F8y?=
 =?us-ascii?Q?FHI9Xpp+9NhIUUatF3lhF9/7r2zeV8Bgb0uQHHLnIDeA+IRMydsPfM5s4JrU?=
 =?us-ascii?Q?gFdkemquvf6+B8ovPdln6D0marLasgqn+st4ysZ7jgjjWwMpneFJGvZRM+R3?=
 =?us-ascii?Q?l47lwKquRYCW1ECxFVi6vGQP5pa+rQQPURI0JzeRS/DcMxHxXNmgOAzd3rRu?=
 =?us-ascii?Q?enav+5qkJ8XPVyQK6gzIYiQaL92xc6jtAW1KC6TPbUvVFo2luXtZdefq4dCe?=
 =?us-ascii?Q?d93SxQ3LhWdLDDu1C3+rHoGddKB5Zy8cMyXcYPpFso2kPJMRJ2/hkLOqOoCm?=
 =?us-ascii?Q?AqMp96m1bsU9fZkG0coixYXzs1WH5aINv41UiaAvlCPYLub8BUCl0OA3IOto?=
 =?us-ascii?Q?svevDusNSvXrDNSfe77T/ktjDKVexQI/lSYZgFVnq0GXgAIDQ5WzT1bXtdVs?=
 =?us-ascii?Q?zq5JGxwSYPSHwrzPUUrZBjHlDVaYJi60W/4DFUZwc2hC8SFoLzft+esGB/Ly?=
 =?us-ascii?Q?3wGUz1byFdB90yDuOydJFpdq8YjHwHHNKh8yUF4B2vGlMRND9nazyivjOlw/?=
 =?us-ascii?Q?Ndf0CM6x7UcWNBTFdZgJPaeoFvVPGTPEWll+7FQdwmAPKMwGq93w+p3zZ2lc?=
 =?us-ascii?Q?k7PLdes/TsuBuZyuz6krtVYmCdUPWW7kYHj1eSFlymwrN/JUPkhxGTxE4S3l?=
 =?us-ascii?Q?Et5BFnGTDIH8itp90qKMY63KXx+JPQcSqpQCepiroox7NCimUjQxlXVbajJi?=
 =?us-ascii?Q?MCvXTug42v6UZvvFGL1TEX2zBEnjwnZxKVeKjo+D85QPl8IkK01H+AbD3VVf?=
 =?us-ascii?Q?opAmn6BJn8Qcsr8MwUzNrkbl86SvH95MC/KTSQOoZobkgRAsDsPNvijMs4Af?=
 =?us-ascii?Q?xWV17FNyibSe2Zf6vYuuagbtGOxNpw5Ds8RQasuem9LAPAmQ3l4PJ84kARJO?=
 =?us-ascii?Q?wEEBlg2OgsiK8Nem28cqipbh6KqH076NDUeNhzQ/H5mX/Yyj5WDy8LccoIoK?=
 =?us-ascii?Q?cpCTx85//2/WpSwbeptiyc+LhjNJ4yo8V/mVD9uzL9aRV1TElMDKBnAT2RbI?=
 =?us-ascii?Q?x6fiVqoYtyK4L1XEUf77yX+qsUWFsN4MHrd6lDsp2W9fK4Z9xXoA9OOQa2ob?=
 =?us-ascii?Q?ibEV/itkzEvt4ZR4QdyfXcXFxDJ7p30t2NlUcIcW62sK3Cdf43u8sl0kc4GG?=
 =?us-ascii?Q?dylJ8cdqMC9gyqUqmCGIrsbtRhzFcCv3/YecUNgZfLPes8VGbZXQkU41jc7T?=
 =?us-ascii?Q?B1ui0yFNoupDMzrNExxQ7ftMfdHssGu6m4qgPyY7ZtYmR80HsF7yH5rOaFJN?=
 =?us-ascii?Q?jTaM/Zw0sLTcMSV5WTn5SY++eOwwS0s3pDN35ULw6Eo9AcOMWYZ/Po8Ff72t?=
 =?us-ascii?Q?xqaTbiYczMKuOEVVb0aWCsDy5nLgMyYtKkuu3nWiDi+wExWW/OwqvFBCD4TT?=
 =?us-ascii?Q?zzltzwPvR8BsM78tMMh2pA+wHXqCGAXdv1MZnLF/dfZ1ycaQz6CxVoRTsEoa?=
 =?us-ascii?Q?BYR4POLsc1Cu7++1+NXAZavkFlOA6ilCv7mFS4tooJt8tqCfz39P2/xSa9Lr?=
 =?us-ascii?Q?yqxit5loSEDMucKsg7DH3mIOsu3+UZbPE9BIwOEmCo5sVwnXHjj+u7pSdKZi?=
 =?us-ascii?Q?Tw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 764069dc-af66-419d-1f09-08da94e651ab
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 17:43:37.3173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2x+KBM/Z//cS2E/vPzMuBHMg7eOEqOM0+4tPsidetvzPpRwXmeKB6l5NlZfgBsZA1Pm0dDvN05mO8ljGVXvyRpNL1s78JjkuVP/tUb35DeI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5265
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_12,2022-09-12_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=793 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209120060
X-Proofpoint-ORIG-GUID: uQIfxOD8aYDjpYU91nXe-C_tLqHP5cBP
X-Proofpoint-GUID: uQIfxOD8aYDjpYU91nXe-C_tLqHP5cBP
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Roman,

> In the ATA layer there is the sysfs file "discard_zeroes_data", which
> tells whether or not to expect zeroes after a discard. That flag does
> not appear to be always correct, e.g. I have some SSDs which do
> observably read back zeroes after a discard, but the flag still says
> "0".

It is hardwired to "0" for backwards compatibility. We don't support
discards for clearing block ranges anymore. There is an explicit zeroing
operation for that use case.

-- 
Martin K. Petersen	Oracle Linux Engineering

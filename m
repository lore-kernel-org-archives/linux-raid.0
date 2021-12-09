Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0B48C433EF
	for <linux-raid@archiver.kernel.org>; Thu,  9 Dec 2021 18:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhLISm1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:42:27 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:26286 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229487AbhLISm0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 9 Dec 2021 13:42:26 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B9HnIk5012046;
        Thu, 9 Dec 2021 18:38:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=dBPjreZLtJmOzaSDRkM9zKRvE/DBxeGFM0ayGDqUxLQ=;
 b=ijvx9DnLvwiYg8UI8pqM122eh8h2AkwX7eMJGtttie3JoNpnYozWohup3d3lZWSrkTl1
 lkx31TCmWByncH5y6B2MtPTyxlDp1MlTvo+p9WU3nPOPanBtxg2izt81PChD5sSFbiLT
 P9ZFo2K5ppiZ6JbmI+HqzQ066+UccAH+/BQMezQhptAIeS4fmTjGFznxP2S7ugd36stE
 mV5NidoavLXTqqMvLcRcT1akQCzsLTRD7n6XbAuYEO8ev3BP1M7cyxCOrBuzC51qQp3W
 YcGkVlv3jKlhf9S7B1uOtISfBBjK1frkZRS2M3jaZV7SffWN1t3ESPqSzYJUfIe2yOjz Ig== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ctrj2vd21-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:38:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1B9IZkwC147590;
        Thu, 9 Dec 2021 18:38:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by aserp3030.oracle.com with ESMTP id 3csc4wkay9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Dec 2021 18:38:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W1r6cAHE+WsjzmdBGvsZSxt1icfsQsXLbBG32FZI+rxX2A4K5KxckYkAZfkFcu2J7MbOMKGjI5HYppvcSJZG6fpgLSlsrYGYc2UUTNXfXX4itN1LFWTGcvnz6sSUTRdHyCdCk6d19k8q192m+IkZBwT1XhTAmK+drmIMTo+9vAwzf4ta41r+CrcwTSeh+R4v+1mv/TCi1JJZv1m2AVsD1MtaBkCDW3qx1UOumfftnuN9dXQDYF0+6BlJDHLTPrynrvbJlt4wmaXfvQQJUExVaTZRFj+oDPEXViNSc1V9nXNJ5KBOnKJ5ZU+0D4TrCcXPvQ9byk/c9ivwzJlT93FYfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dBPjreZLtJmOzaSDRkM9zKRvE/DBxeGFM0ayGDqUxLQ=;
 b=XsMN26A/5w100M4x7PC//f+tvBS3UnaaMRLXM58zLXN4sTyeqPqlZr6bP76ow/Yxtq7jXmreWs3HGWiq9RXxq9R9IiAyx6slGmVcOCkIL+SRZDzeYCcH/r7bZyl8IkUm9LQStorL4XIq8rgK66ieydvRp2E6892thRNKP96s10M4J65MOi3zik3sqkzV7d1MV0MhHCFTukStcKmMwxWS1VvHLNE0xa6ETvZ5rO09UnRoWq18L0dkwzxeQKaOLfxbPhr65gMprIdYymhu0Hjn2TxF+SiomUnHa43BB5l8/32ekSQIM0Iat4qmdejULN1SUQgo4f+CMfoDmcdHDwU7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dBPjreZLtJmOzaSDRkM9zKRvE/DBxeGFM0ayGDqUxLQ=;
 b=I8vv7xd5hn1W7LOAZ7TywzU6pKxGK4LhO+qCEFClVXXtq59HSNFVgVMOOWgH/0LEIuISKMq1E1ZKxp4uPgVvMbcdMM43cvJVa9rmCfPvMbobyXv1xWWcFTHx1KdqZnXEzI4rHPeJ79MpZPJb9Pa5s7p3EpQTr9NbHMBiclFuxYI=
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1655.namprd10.prod.outlook.com (2603:10b6:910:7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Thu, 9 Dec
 2021 18:38:48 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::64c0:e80b:9fd:66be%3]) with mapi id 15.20.4755.025; Thu, 9 Dec 2021
 18:38:47 +0000
Date:   Thu, 9 Dec 2021 18:38:45 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 6/6] tests: fix $dir path
Message-ID: <20211209183845.GA22819@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN6PR2101CA0001.namprd21.prod.outlook.com
 (2603:10b6:805:106::11) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
Received: from oracle.com (209.17.40.39) by SN6PR2101CA0001.namprd21.prod.outlook.com (2603:10b6:805:106::11) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 18:38:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8aefaf35-887f-4b13-ef4c-08d9bb432339
X-MS-TrafficTypeDiagnostic: CY4PR10MB1655:EE_
X-Microsoft-Antispam-PRVS: <CY4PR10MB1655069492A9B5E3CB1614C5FD709@CY4PR10MB1655.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I+m9vM1TAKCAzg+W+XSuidA/P5K/FXgZ2RsYxnnw0eY9ZFYVgcr56816ROyXJzA/+wIFzJWVStow/k/89t90+PWYeb+tIwHE/YbBp6C0tT8OaFvnyFmH2EKkNFIxSPS7vDRmRoMJaWbM+bifD+tVcv82fW5jmHtiQ/NW3jWYEiILCiuJ/1nQbXshbvoF/aAn/eEQCUEcnEuAkp86Y9q8QFqzPuFj8lK5LQiShVGFd+Bl04hjuXXH0IEfONSAuHYYKFlxHEbVcapfJonnm3+WKWE9qfSNCX/1mpJ+N0kzMHxlPs8/qm9XrS6fCO6ltDzuUAliIP7UT9MOz/VZuqy2sTQfAZaJ06J6MxUEApY77w8WcwD1494scVUZ4qftjHDshG6t9RCfi2sc3A7VEZt9Cz/pb1+2vaxKxkBUa7bb4+CRCMg5AOXExJYouQrfZ+zeFMD1GuaYZzdo92AAH12Ca0NTdKLwyYmoWpXWfS/LJfZ23sn2MXzgdt5KWAGI8d/PTi+pJNdUVoTW/StGzpf4n1QWuZ0k2aNQYd3bWPORbu4NLtUr+gOJX35fvZQiu96Gsl0vf1KCHItjXCbWfNZ8uk0WTHJZAiV0a/fh3odyFAuzvHzbVo64rMJEitn3ws42MR6yE24Jaf2h5UoqPdzs4mb66pzVC8pf288R0jg5MXfpUAnwrmz1SBC1cMfdqwHd4YbcRFTHiAF6aKSJIR4Idg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(66556008)(66946007)(316002)(33656002)(86362001)(38350700002)(36756003)(8886007)(8936002)(8676002)(7696005)(5660300002)(52116002)(38100700002)(26005)(508600001)(2616005)(956004)(6916009)(4326008)(4744005)(2906002)(1076003)(44832011)(55016003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P660Ctg5DHMIFgRMilx4uu1cl+zARoxC6kvUJP30k2XFPBTtCLlYcMh3KODG?=
 =?us-ascii?Q?4k1Fno8T19pPm2IlITLBMqQQsno8qpAdIklHa58bqNszrqUiyhw/Mom5RcEo?=
 =?us-ascii?Q?dhkt7Djcdubu/7GmURKvB9hJFHFm+wgZ4cx9uJzQpyIYgpYv/rbUsi8dE1/D?=
 =?us-ascii?Q?d9XjbkTVl92WtzsK2wj4FXfS1qf2vHP4lduPIQPUCiVLh8OCF/qVoQGjz9yp?=
 =?us-ascii?Q?JwrZ8035Ti3q6ogWqc7/dnLXgLN3tDA3AkadmIxvn+LJY4bm2GHbLl7nOMza?=
 =?us-ascii?Q?IiByjNlgoBLq4pMI2OwdI0E5f39vaCJ22xmQ8Wk4T38R/PPr6Oi0EFP1N4cq?=
 =?us-ascii?Q?MgD+ykUHMirRv+alfa0S4AYfzSeDtV332DelEkOTcdp4ORwYDNQPKdZINsq4?=
 =?us-ascii?Q?HIIpbSLgJv7dki7MTKsfJGdE6rcFrSoT8TbKiZin4uSgLjGsiw4rlXtWhArU?=
 =?us-ascii?Q?BW9nAa3NRhJBiHMdjUD+EPTh7Ui4HyNq0a9tgB+QXLoWhgCx8FzkOU8DbHkN?=
 =?us-ascii?Q?4IYfP0Jl+qtKoYOK3o2ypWEv7DYecjzTtCuYOs5lv/m+QpKaoXx8NP2dynat?=
 =?us-ascii?Q?LFTwFqbWw4X2RBxAGd+OAf0+zE9n2S0lQ8ZOxr2B5+yQfEitA/IARfT/sTgV?=
 =?us-ascii?Q?hBwcxZR9Aw834B+0ifpemrY3zAaNne10g4QDwuGEJYkTRUF+YL1PUXWb2uJP?=
 =?us-ascii?Q?R3oHN2lTZJJwSNEizL9QlRpIromE97EdVuv+/XwAXlCYKWl2IAM3q6RTEFIq?=
 =?us-ascii?Q?SPEKfeH7ao895o7GFYF8WvjLPIoexyQvIx/+DPiq2B903gsHYRXLy2ZaWmEj?=
 =?us-ascii?Q?aC0mKNV/bQIZM6QbykkiZB2O7uNNQo71fTQv5IDEoTZWj6k+Disp8MxX1akV?=
 =?us-ascii?Q?m0qSh7WbL5j00/65rt9S3qWyccb3NPEqe07O7vU1OXx/XRRJKu7TzwaRsnnL?=
 =?us-ascii?Q?fFrFr1xXMYLiqnybYpu0VyRF6Bv78s3//ckragOMVAw2mpXRkumZhrTpxcDc?=
 =?us-ascii?Q?iMxL/TIDJssaYqywI5BG1gYxeMc5mJTK8rr3D6KJQAa8+pCcl4pJbERLavX0?=
 =?us-ascii?Q?VaL/EwKPxOnFmY7CuNZuSwBULWr22NaVXf/bF3KxPRcJwiyTbMQzDK7DCjmW?=
 =?us-ascii?Q?C/M8CbTvvDmhgkTokSiCZyzogisf+ZlgT8Ba+6uX2O/HthGfD7HmPLiqhJDs?=
 =?us-ascii?Q?e68mkD9UxO/ud9KOqgkH0uMfHCjKv9iCPi4J6WlOL2bG6qNxydnMS+9ZqepW?=
 =?us-ascii?Q?ziz3SkNvDCKUB9DTN2RJohD2/8Cm9cl6H91ZE5/+xlMkW8GIoUzHe12dEEF5?=
 =?us-ascii?Q?WMVtdqRubPLxqQZpOQ7t2LPQzEq388iHSqe/cjXWEp0Q08X4HfZ+kSn7fPZ0?=
 =?us-ascii?Q?desJgbSt3jhseqVMslLqmfW625tqewpbAxDyNJbdvJXlOSUEUR6WeRPvOs2/?=
 =?us-ascii?Q?+HrhVnrNNFAdNic8VRIzgIRx82HrixLzusvk4lK61Hlvj9cvACAXdn8UBSY3?=
 =?us-ascii?Q?2WKAiaIQx7QvyEAqPuNVCztfGTY/Tm7xmsa6vIKZrStR2dP0H5LzeaUlNOJR?=
 =?us-ascii?Q?a48b+1yRvUyTrwfJLMTTSH/DWnw5MXUYpJK42cnHZ25AWLohgZJ53GPkomeb?=
 =?us-ascii?Q?LBhtJmdAsITA35XMC6PxACep3LLvtCG91+3fNWzbDkc/amELHeRLnvVio5G3?=
 =?us-ascii?Q?GntGPTezO6o6kkxT7ynRqFlRGglGzxyiTN55CHR2gol2/zCtqJW24wiy3NJ8?=
 =?us-ascii?Q?qwKhw/Ic4A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aefaf35-887f-4b13-ef4c-08d9bb432339
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 18:38:47.8931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NRliQnY/t/CXOBMs2b0f/bHmznjLT8RelMHUEvCUbs3anaZu0NtaFRSYxKP9bfycX7IlGQW8pSLv88tXNyPzkkEif09zNtfzVy1ZdXxW1uWC9/t4nE100Eb7KHPyjqSm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1655
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10193 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112090097
X-Proofpoint-ORIG-GUID: Ea_j_G092APy_vP4xYkNMwH_RBa3csXe
X-Proofpoint-GUID: Ea_j_G092APy_vP4xYkNMwH_RBa3csXe
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Some of the test cases use $dir to refer to the location of mdadm and
other test binaries. But $dir was never initialized anywhere in the test
sequence.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 test | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test b/test
index 711a3c7a2076..91b0a98d593c 100755
--- a/test
+++ b/test
@@ -6,6 +6,7 @@ targetdir="/var/tmp"
 logdir="$targetdir"
 config=/tmp/mdadm.conf
 testdir=$PWD/tests
+dir=$PWD
 devlist=
 
 savelogs=0
-- 
1.8.3.1


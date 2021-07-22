Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000E2C6377D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08E46056B
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhGVRtL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:49:11 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:47452 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhGVRtK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:49:10 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIH1B6002458;
        Thu, 22 Jul 2021 18:29:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=sfzGYIiFeNO1r4s8yZI3FNL5fd270IfDYUkZHjLSCZo=;
 b=ejqAuxyuFmAdeEoAMjipBE6A95nHxSoXwjmttFdhqxuBPuQVSAAOi0ENSJxxLteWeLI1
 4VYPDdJv2h0mVYC/fJSxGgvGQKMHPz6YML7FEEqHFZuvhaP6kE1CaaE1b0WeVhlvV/dh
 zclDWPuADFzbs60Uoh7hCgePmcvOchZhhSEdrztn3JO043dN19BmI51FdjiR/p6ydfED
 iEuMwmw572dJDhIzuqMTs5vgLY3R7wNq/eNduMVkg7a8pnWgtHeJTgSlY+o+T2mwTlx9
 Ldk709QWIgK35OXcwf1Sz+qjbpF91rAC9QiJogI9GmLD19pQWxXwg5zFTXzK83Ja8rpx Lw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=sfzGYIiFeNO1r4s8yZI3FNL5fd270IfDYUkZHjLSCZo=;
 b=jJ/s2Sd460zpUWTY5qM+2gVBsbzeaQugTJ68kU07mjyfx0jAZrd3DzkA8E3xK/qPgF2o
 8KZ7/oU6QcS/7HZ0M+l6MFFvbfuPtVFgkgz2bNmYrfPMgmIMtHn0FI8TszLNNhC/7XG9
 YrpmRgV/qOQCFqGlgMKdLteVAMnIayhCP+hvYasFQb+EjmOOv7+zXmCSdhcZk6TeH+U5
 FBaiV8dr5qxkn8IIIITExXOkmoGLkw+tAShhdw2uJwp/j6vLT5tt+nHkFZTF56RRvxvs
 6YZl0BrxNK1vukZd52j7iYHB+gup7Y0V9q9TV4xl76C/+rlBCLgnVou40EumggNkI71e ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39y37t9n6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:29:42 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFRjE158403;
        Thu, 22 Jul 2021 18:29:41 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by aserp3030.oracle.com with ESMTP id 39wunpe8ap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:29:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8pxLicDLOjyUyoJ6sYEKhCooI+UYexSpc2KYkBXKvwzQW4VK82LWcVBOdI12ySV8qmc7aqup4Z/7qwmM9c6uWq024ePOlwvA0vEgMM5tkxJ4DBlMA05pYwFunriejN4VdyI8W8Uh58PgpVktOnDafnah5HpBhlGWkwjIpoLCqQae5tUrcX/iTx7i6Sbve4s7n934eXDGkX7cRXYD834kyYX8ZhotQCK14exKX1WsKfFFDeChkCnU9blvFMxPthHhPIAQVuPxIB4IG7HmxyITH+pWhUJRs5PEZlazaVhVIpRsVu32NIhkAX2K0fry7A1W0drNQaatJ6D2TBVjacjBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfzGYIiFeNO1r4s8yZI3FNL5fd270IfDYUkZHjLSCZo=;
 b=ib6ETuHAZKuqVK1B4qlzGadDs9S/fFjI1uUR0/qBxUnmX//ZAl6DtXTMlj+3ZD9rRlGI86YA4d/luUQH+UrrpcG/HS7BNrAiEQKsFVOybkbTVn+VMD/8Q924znnsy3/8YUbah/zUewKHA8YASjPoH0cX0wQtK40NiqYbXkZaY0k+BbWspbca3Js0Rw/vfpvF8P/ulUnplHCoIZ748xJAaouUGdF6kaFFgZF0VzDZpayIX2zYYyvp7TrEQ9HTPMwBVwjPW+/l8fYJZ43LAAYSqnn1pn9LXW73Hr06C/3KK+chunlJJUs0FUfqDSciVn9TTM1voyuOS+ghjdDlWLuAXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sfzGYIiFeNO1r4s8yZI3FNL5fd270IfDYUkZHjLSCZo=;
 b=dyRoST8dHTvNcUvOxi/IhcYw/E5bCMSRneH9TYns2/lkhvuw7ssJ/SahUwujIRkCjb49inupuP0q2sALFjtp8PFshbWZEqzr6jb57o1Owaw6abiHRuxY7zcUWl0lKR2TDQjINysRGD2AAUKaNtAcW/vStG3zspan8fTSGVXjUgc=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Thu, 22 Jul
 2021 18:29:40 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:29:39 +0000
Date:   Thu, 22 Jul 2021 18:29:36 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 5/5] tests: avoid passing chunk size to raid1.
Message-ID: <20210722182936.GA25474@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SN6PR2101CA0015.namprd21.prod.outlook.com
 (2603:10b6:805:106::25) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by SN6PR2101CA0015.namprd21.prod.outlook.com (2603:10b6:805:106::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.0 via Frontend Transport; Thu, 22 Jul 2021 18:29:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efcc899e-ee1e-4f28-d773-08d94d3eaa97
X-MS-TrafficTypeDiagnostic: CY4PR10MB1381:
X-Microsoft-Antispam-PRVS: <CY4PR10MB13810F17DA2FE5F82A5A24EDFDE49@CY4PR10MB1381.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:88;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9BSypdUpHtDxzEjz3RcUxXS6Ra9Zv6J0AeT7Kf3DbkZOUqIbTIP9+X66M0/zYp3p3Sqm1SQO/YXejk0tfCKRGryO01RhEEqfF9jT8rFSeFjngtVsqUnN0J7sj4bfRRFz9a6AzoworNRgpD6xbbgWAsk8ta2SN4Vj0Sg0X7zK3GJDJ9ZBodv7yhtAFR3nGiiWBCMSZag08haMqDDRTgYgNYZP7ll3hKU8OZeUrzJ1MVCIOT6rSyB8vRJpBTHEKKNTJyznkdf/sqpbucY5GtP2J7DEiJVUyAUhmh4HAVOeldxuptig9pwh8cHbGIiB4/yijwCOaKC+T8HDQVPmrNRNYGAsHYZNQg5ILPBJwrWqtIh1PKvAnpRd8hwv7B/nnITaBj9tv2XTQuh1I/8WOnI8x9mgKixbfl20g6GTewTgtTXKDbJlci0NUW0Yx4LT9POxvzybpQ6PgPZgSxhUE2TvrW3LV1xrMhGub2uVBWERaogIvXK2Z5Fjce9wSYZVPVAvEwcbz6rJWQ7bMSGGZIoR3E7tAh8koXeZ6pI9zDrlWlveQk0utDsm8MEtTJn4Pv8Jhci/dIhMjXP3JOvLIt8BxGBpq6CkumEYZBAyOVpcMRwDPD3Vn7tdg0A0Sv7E8w5Fx4II/1/RJV81u5VJ6SAif9WmjF+Dq8F5PDCW2sTUw08gHHDalV6Ypr7VhrMn7r+Tx42/D7+tYvzVCsObse1tlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(66556008)(33656002)(7696005)(956004)(8676002)(4326008)(55016002)(6666004)(52116002)(66946007)(66476007)(316002)(86362001)(2616005)(2906002)(5660300002)(1076003)(186003)(44832011)(38100700002)(508600001)(6916009)(26005)(8886007)(38350700002)(36756003)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vXMQ3/MIc2FM+htalCczc52fHOnwjJgkzat5Y73pDavuVcJB8hlMu7rxsger?=
 =?us-ascii?Q?Hm8PuAGTdjiQnnjTqL2dvg4wLgIz2v1wEv/t6o38TZS1kjMt9/Y7pLK2uSCd?=
 =?us-ascii?Q?KO9U6XdKyFO+wvGHQ9646xkZ/qpnA9OqsBHoX+HZFp/RvK3AOyvMPWl4OOVd?=
 =?us-ascii?Q?8v/IYUX2Me8nQKefAGj3cCqXc1y0Wpwl6BmIdHgBMBLsxQw5X6naOq4SvO39?=
 =?us-ascii?Q?UvgOOw9Z3lbHAh8DYU1Zc5hkX1HDkzCtJ5ILHO0meYw04a7Ja9sE4uKFv/T1?=
 =?us-ascii?Q?t3E6+NMntm7L46D69bEuXLYowDy9xmyOWOVImM3LoMyys4S2zAyTRVK9RHyk?=
 =?us-ascii?Q?G8WPc1nuUM/HtXQieXUB/by2pTN0Q481Pg8Ik7kQouqMMtK1y5+P0YLEorNS?=
 =?us-ascii?Q?Flefvk7mZZBpSKIWfADDQUWHedqucyCpnXCTsiU3LkNFvWWHQdJfnrImK6Kv?=
 =?us-ascii?Q?MSN6p2bKfPKPsw+m54dYrtCCpsi5wDdcw3C8QUANIyk/fx//LeIAd1sj2ZFG?=
 =?us-ascii?Q?9WYcP5jGE4+ge6S5mwcyp7xrYSwQr0Mp/F5bmYPMTgRPwZNqhdwwlVcMsYsI?=
 =?us-ascii?Q?vodrz3OIz2Oh+qg3ooYi8CbtCTJAZqAH8tsUj/za2pQ9ZcQ2aUC1gennHp+n?=
 =?us-ascii?Q?3bFdt8CNYSxtbrF+y0eRO8603ZknlT9VLQcC9To+ra3pi0NCjH85otjQWcmN?=
 =?us-ascii?Q?XqNAcR8r0vP7NBlbU+Cun3fJJQEHp2I8By7gAh5/lMwToL0fRp9ikOMlMEem?=
 =?us-ascii?Q?0iEOaK/STvP7+Fyg21GJVaH9RGnyKwphmSKRuyRTpYd/RW1DK8ExFQMTcOY5?=
 =?us-ascii?Q?uZEvMTHpSqHdw/MiSLFIhTGSJLW3bDti5gYY0bHrsp8CJgyRXk0Bru0yon0E?=
 =?us-ascii?Q?7RMZjQ4w3yjmE9448fHymIkAg7edoSHHJi+IuEe2afe9MmzcStK9Pn8LfmVS?=
 =?us-ascii?Q?4Mr6QshxLOYHY0cayPkrzUIHs4PIggM0fqf2qz/1rzGmQlRvy9hDUm2wMXKb?=
 =?us-ascii?Q?xzpU7hNHAICWOw99ICFKP9/k1iLoEyyyjRPa2IkOBVdGAeIloAWeCOPmH4NN?=
 =?us-ascii?Q?zv1cT6h9hHnbSKD93vPUVFXizPypE8hfW9PyLBMnllw9QLYrWyk4ePGnyrjm?=
 =?us-ascii?Q?y+s9c4bdFxAbZh22QZ7ZrjHrI2hAHlkBw5adu0Hs7vBHCDhl1xkhNco3a1aN?=
 =?us-ascii?Q?ZFcF4/H6QKguYaHH5RO5Ut+XE7YOkb0pvHxxhUMfauFYkPiC+Ak2F2Q0q+U4?=
 =?us-ascii?Q?NyWwls7fF52VqCyLaqC23fLbafTsMHdXvT3cPh2z052kkAUdfyv+Mlwnt22d?=
 =?us-ascii?Q?Z2BFaigr14GkE73YMDrBELVC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efcc899e-ee1e-4f28-d773-08d94d3eaa97
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:29:39.6174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +54TGH+8+suytEf5WukN1Yftpkqd+ZkvzVCPj9hlASCseM1UMu4o/1Puk3sNilIVPMywTxkje/0V504/cHvgwH5DNbi2bWQpeOLxKo8FEUbgkRSiofXTkJy5JgiuyBlK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107220120
X-Proofpoint-ORIG-GUID: fwX76LtAUuyIjv0FwZ5i2wzvbv4XrI6Z
X-Proofpoint-GUID: fwX76LtAUuyIjv0FwZ5i2wzvbv4XrI6Z
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

'04update-metadata' test fails with error, "specifying chunk size is
forbidden for this level" added by commit, 5b30a34aa4b5e. Hence,
correcting the test to ignore passing chunk size to raid1.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 tests/04update-metadata | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tests/04update-metadata b/tests/04update-metadata
index 08c14af7ed29..591009d2797e 100644
--- a/tests/04update-metadata
+++ b/tests/04update-metadata
@@ -11,7 +11,12 @@ dlist="$dev0 $dev1 $dev2 $dev3"
 for ls in linear/4 raid1/1 raid5/3 raid6/2
 do
   s=${ls#*/} l=${ls%/*}
-  mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  if [[ $l == 'raid1' ]]
+  then
+    mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 $dlist
+  else
+    mdadm -CR --assume-clean -e 0.90 $md0 --level $l -n 4 -c 64 $dlist
+  fi
   testdev $md0 $s 19904 64
   mdadm -S $md0
   mdadm -A $md0 --update=metadata $dlist
-- 
1.8.3.1


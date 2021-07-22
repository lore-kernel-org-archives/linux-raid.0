Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E182C6377D
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:28:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 099BF60720
	for <linux-raid@archiver.kernel.org>; Thu, 22 Jul 2021 18:28:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbhGVRrh (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 22 Jul 2021 13:47:37 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:40524 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229530AbhGVRrh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Thu, 22 Jul 2021 13:47:37 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16MIGUmZ024405;
        Thu, 22 Jul 2021 18:28:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=rF53khICDDAIgLhkBTwPIk/3/ayu6aUegayFMHRfF3E=;
 b=ggdP1ffpJOnwLfKUnhy+SNLn1Z/RCwV65/YFL+cINALY49MAQa9VKfUyYWIN+tV9ZG2V
 LXkdJJwHA30wSWusbDZ3LOd8G5BF0KMqb3gTjvJZdhxmMfZ2YRQmmfIWJUqShu0595VV
 PiZC0UabfrgVwzNclNUWVFrs+DgZDnQcrIgqokmVXuC1G0O9obxIiean9+eiE5hJCXRl
 rUq1gGg7A2ilgqsm/R3BPqu57ggR7vJk4YYXJ7C6zaD6TxA4M9Mwwr1JADqzd7srZm4w
 nU4B+stW4JlR76Nn1f7aZp8nwy8bSyAGbW6OLpuVG/j9/p9S18/VapZNis/JHXgEDuvd tQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2020-01-29;
 bh=rF53khICDDAIgLhkBTwPIk/3/ayu6aUegayFMHRfF3E=;
 b=iS0SAKk3tR7BmCiJ/A5wIFnDOk4GiWYj20lwH10RVuv0KdbvwV5BxgM1Mc1KSvvXeYtQ
 EP46+piZD/Si9ylhOCu471YReZkFC+dsjwHkQlZ1+TAfbuHg/BDVNgIbvdXrNiC2vz6k
 UzL7PPpJE2QH8FG0pvJcRms//mCGgt06ZRLKxLKDb7ZtVy4+8O9Q57rkQ24ERagaReeA
 9GDM6CMcScIy/m+5+976vQFr4OwloJ0bqiCgfLZSdODum9pwquPxBCo1Y8sMkbpYGI9s
 j+WH64TVUW0qdN4gM4Cgk+K2qCSEVhbbLsTUT7Jt5QTXmM1pLE4NGFYiFErTj5GzUXKc EQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39xu2ftdqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:28:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16MIFEr8167699;
        Thu, 22 Jul 2021 18:28:08 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2041.outbound.protection.outlook.com [104.47.56.41])
        by aserp3020.oracle.com with ESMTP id 39uq1bpvs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jul 2021 18:28:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6T9N/BbqtxmlU2hwv6FXemHonLIlspYzBs6C5r7Ip6iTg/mBQivZ8mO4ufsbYg+RCLcTQYF8DcnQ6wVqYdsnkKbFo42ZErgI7Sg2vHDpvB5Q0otcSD8i6DDUxf0Mu5zIQYUG/gYGlLWNroxc/nTokVD2t+Ebb3GQfotk8OyOkgZNfe8C6jpkC/oaxQAD62Mz6HeseFFj8M+7DLMXagXkSacBV01SN0a7czQ7OZxqX5QZpUT/WFODVq1wuJU+N6pAhMbJbqrvTW13ZPGlZ1P2jJBK/ZlhfiSrHx5O91zJdx/ZInahdQxV0Ufd3f9VRSqUCPskCslZxuIlf9X1rxNew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF53khICDDAIgLhkBTwPIk/3/ayu6aUegayFMHRfF3E=;
 b=H25Hll3JRWkzhmBdw/HWsFlPHXXgauZxxp6RHVsO+sEQUjG87eV79OlL7bbBkTgrliLiymb16K9A4isjiqtOo+5Y43gptgl/Wb+eIm0bjkQxMYmr5YwT1refA8GU+pSCy/P6uw8SZKEOCkyOd1M/KUskGtGdik/H4GUNOJSHOyF52MyomxqUYQEeX9T0fSuuZbSdwnaoAOCHQe50G8XcIp9HX+d1/96YlpkXB9xzkp7HtnWYVcgrDT+FMPkU8yCX25A+qGvAFmK70AJtBXB7WIXgOgYmlJk6Ea5SqlDHFf3bxTqBu+egDNf1Tu9oL06I4XRpJE8Ie6jZHgUihrKP8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rF53khICDDAIgLhkBTwPIk/3/ayu6aUegayFMHRfF3E=;
 b=OcvhDIfPRtfbWYBfU2XKAUF6zJGfoost95f6sGumyXol2Ow6y/5MWO9hdYVyaNIiw+hvupFs6wzx9LZZOmlivmQIfHEcHrJUtdSmqjOumwJXyv8Za61cYWyBUhkw/Ekg9XahQxHXd5kIBDlefzYRq24OT/BYp8e7WQ6jz5Q2tvM=
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=oracle.com;
Received: from CY4PR10MB2007.namprd10.prod.outlook.com (2603:10b6:903:123::20)
 by CY4PR10MB1912.namprd10.prod.outlook.com (2603:10b6:903:125::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 18:28:07 +0000
Received: from CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2]) by CY4PR10MB2007.namprd10.prod.outlook.com
 ([fe80::9d86:c5af:e982:11f2%7]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 18:28:07 +0000
Date:   Thu, 22 Jul 2021 18:28:03 +0000
From:   Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
To:     jes@trained-monkey.org
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH 2/5] tests: clear the superblock before adding a device to
 the array.
Message-ID: <20210722182803.GA25122@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: SA0PR11CA0143.namprd11.prod.outlook.com
 (2603:10b6:806:131::28) To CY4PR10MB2007.namprd10.prod.outlook.com
 (2603:10b6:903:123::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from oracle.com (209.17.40.41) by SA0PR11CA0143.namprd11.prod.outlook.com (2603:10b6:806:131::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Thu, 22 Jul 2021 18:28:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b49cd94b-b017-47db-0d91-08d94d3e7381
X-MS-TrafficTypeDiagnostic: CY4PR10MB1912:
X-Microsoft-Antispam-PRVS: <CY4PR10MB1912C14F4848DF7D3B7F5B1EFDE49@CY4PR10MB1912.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bee2265pfVgX7yJfRtrVKcziiB1A0yTyeqj3OaKRpVO3a6+CABMFJ1sRyGhrhzjU05whRzn6+oVT/U/4j9WeqJK6594+55NSDPNvwoj2gdXiA+bUx+hWECMS4QzzaynYdewCvVm1fCsT6qWKW4efzt7vgCAlAZ3mEWrekltVsPxClU1YAotvuV+qbdPATotJn3fmQutqfq+1bg3Fo2HJCxuyeLhhzBP9WwBwU8fryWjwMVBB3+MX/YDEqjEDcD9VLfI30/lK4jhu+4DeIexESCGGMCqAy46+nb7ksqKHyhYjiYY3+ekHD2nXDBffnUuKboAcfwjBmRU89LRkU+S2RRGoWF/RPYyR/cIFIWX0tB0l4Ecg45TsRetD6AZSotv+tZelYPMVdkOlfhBK3+dyoaWuJAIbdVi1qeES+sBf+cQoSBgaS0ACJX5msZzWdFOMo6wtx/u0JnHEd3UqIWnGh9qyXM0dRN9VwMkLwuFZdMY12InURnrwWMEJuH9QSUQ5Mj/T7n1pWMKrF/LYnNDEFTkG6VjcgOMwUJaA8yWDEl4uUvip6M+BSf3c4D6nKzjR2JbNj8s50U3SdX3bHJVCGRha0oh3FQYFOLREVlgraVv3//xFMr6OXZ/TNVYz5I2TkcZwDufGlSC4ndIz2NSIdZWC/kNIlcWCYkO1Cl1R0IhM+ShNKNYsjqq36mi/srYvurL6GhN+RLQkrhPwuSEXIA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB2007.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(136003)(366004)(346002)(39860400002)(36756003)(1076003)(38350700002)(4326008)(83380400001)(66556008)(66946007)(66476007)(7696005)(6916009)(2906002)(38100700002)(186003)(6666004)(5660300002)(52116002)(4744005)(86362001)(26005)(316002)(8936002)(478600001)(2616005)(956004)(44832011)(8676002)(33656002)(55016002)(8886007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hzizA3eOMeLd2vzgAApJkn3ZtZcPAf+h8xWrkQGDU8dHP6KEyOjaiPRoUr3C?=
 =?us-ascii?Q?yvZpylrU1JFsx96anI3GVgH7UKXtOfcTLznirHCpPzMRbJ9DZMhn7dPXwY0F?=
 =?us-ascii?Q?Q5iOZh6VsUn71PzBifFe7c9naLfUGr/IobgIMUr7sHCB4tr24vnLvlq5Qkog?=
 =?us-ascii?Q?M13na4YNtzEu9uWPy60YHYHvAsfJs0nxk86BCJcUGsWCFo/1J3KRiVB4UQ79?=
 =?us-ascii?Q?+lHw5cT+I6z4q/APEiqLcT3kuCfyEjA22v8yCUD4JeH59zayyOyZTJjo/pfZ?=
 =?us-ascii?Q?ksyusp057lOLCbLtwVEwhuoSWiLE5UdROpJ9HecyH/ddliqHGO1BB/Mtn7+m?=
 =?us-ascii?Q?L3aa9WULjbhcetVjpx+zbg5CjK54CbJdI2ZAbXcunM4gHJDLX2JkvkAwqx5c?=
 =?us-ascii?Q?zR2cc/GoMHP/r7atO+luQUsa7n9X4bqWNg/EN0f19K9iljUjBk8GQUMHThC1?=
 =?us-ascii?Q?KzyxD0GADDSB3kyLMy6464NcXS2f6fMNY9x7omRhigZXAmUr8z/3i3mE0Kfk?=
 =?us-ascii?Q?eHU2oJwMNoBiAJcNc0jPSV3DoTwgLk64BUFOzzEjDTtlunjuDkgfQ7ON7XY9?=
 =?us-ascii?Q?TYFqAviZCdEyFgZi2kmsY+pDAP/rrqFKDSwVmbMIoXdAuZOUVcYO/LaOgz2W?=
 =?us-ascii?Q?ivvUt/iYnTnY+aUfTRedvPZFJWxelKG1BVzTmIydctpmNvOu05OPBEhUZInB?=
 =?us-ascii?Q?CKM+DfJeaA4VCJ73M6N5O9lB/a2J/4hElgJhtdtZvzHh3CoECBphhjOk6aKK?=
 =?us-ascii?Q?ihUPOBxBNk1j0sSeslmN7O36gVvFer3Qv7NhVn6pRekPwI1/TnstO7mZxh8/?=
 =?us-ascii?Q?O6nDdsMPzXgRBi39JdaQZRg8vyhbAqUqL5kkRkKdRD4WetP2dBTL0mueg0+a?=
 =?us-ascii?Q?vslXsqk7hJ4XdMlTFqKKdbIWy7kbMLcQsOuBgGHhwlVvSmFg06Z1jBKytMzy?=
 =?us-ascii?Q?6OANkexHx2sPxjYqQalURLSIbT2GS9dMJ0CAayf+bA8zcisNq+ZHsYizLaRA?=
 =?us-ascii?Q?fbEEeoFkGJV/OpiSH5Qaydt1r+9YQHIpnRffC/J+mZK/O2xvhuNzGk/ZtEKi?=
 =?us-ascii?Q?eLkRXT9jDNUEdlUaguP0kg5Gw8MJhhf1brUUSoRIakqUnHag9x5C2VbRNTZR?=
 =?us-ascii?Q?4WcyhDfm5GA/qLqL+8Yfd4rbi83T5L8YtsexdZDR3X6EZgLWSqEB+TTZpj+S?=
 =?us-ascii?Q?NEGFfMeEe83xE4bAn2tcl8nJhwGNVpKdM+yKABM3lD3vOGY5chgqSt++k2Xd?=
 =?us-ascii?Q?ujKRBlC/2qknq4gH0mmf19P+eNberta/1yndlhBaTiMbucpgPnM6yfq9uOgX?=
 =?us-ascii?Q?ejF+hUqk34PasPjnWJaTNKTV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b49cd94b-b017-47db-0d91-08d94d3e7381
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB2007.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jul 2021 18:28:07.2233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RhIanq3OOkJIscZXFnMmw/yY/qzaEsbYQL9mQV627In3zgiAHr0rCDvpoFkxbeFsYeeQxzgPDP9xhn9ZYh+SCMlqM/4EQndZUNh0J3Xm9Q1OLX5bIh+nsSu4fdbZAWeI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1912
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10053 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107220120
X-Proofpoint-ORIG-GUID: L_M95E8AhW73fmnnAEm_odVUFCiW0Kjx
X-Proofpoint-GUID: L_M95E8AhW73fmnnAEm_odVUFCiW0Kjx
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This fixes '02lineargrow' test as prior metadata causes --add operation
to fail.

Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 test | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/test b/test
index 711a3c7a2076..39a85d77fa25 100755
--- a/test
+++ b/test
@@ -48,7 +48,7 @@ mdadm() {
 		;;
 	esac
 	case $* in
-	*-C* | *--create* | *-B* | *--build* )
+	*-C* | *--create* | *-B* | *--build* | *--add* )
 		# clear superblock every time once creating or
 		# building arrays, because it's always creating
 		# and building array many times in a test case.
@@ -59,7 +59,12 @@ mdadm() {
 					$mdadm --zero $args > /dev/null
 			}
 		done
-		$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
+		if [[ $* == *--add* ]]
+		then
+			$mdadm 2> $targetdir/stderr --quiet "$@"
+		else
+			$mdadm 2> $targetdir/stderr --quiet "$@" --auto=yes
+		fi
 		;;
 	* )
 		$mdadm 2> $targetdir/stderr --quiet "$@"
-- 
1.8.3.1


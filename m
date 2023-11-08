Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A293EC4332F
	for <linux-raid@archiver.kernel.org>; Wed,  8 Nov 2023 18:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbjKHSW5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Nov 2023 13:22:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbjKHSWz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Nov 2023 13:22:55 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27FC172E
        for <linux-raid@vger.kernel.org>; Wed,  8 Nov 2023 10:22:53 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GEkL4020423;
        Wed, 8 Nov 2023 18:22:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=/kr66BTrhgELCtt/de9mFnicElBKCgsQMlkBQ7YoLKg=;
 b=jtfhtRTUKusO8LBi+JrxNmXGyl+gWDFiPmaWdqQi8HGu/xCHetyX7eCV8dptX4SIAh4b
 SiUGupU+TDDu9cyDTjH0J5zdUGHAudHTpXx+C92f9PTOR2EpYzpb06I1cUsnL5vfovDt
 dwDezwsVi7S3o/pt4aUb4S8E4Z0o4OBcIHt34BmgyTXNmGXBK3J6fG7uW3AKsCyClYIz
 /yOdcolYXBp0JHbKX5wOEa6CHcsK2SE9foCy+kc5bTJHoda08qM6K2UrPU7V+z8b1/PR
 GVoXTeYm/Wc8Zqi764f3BXcOl0/aCvCXuPzQlt2qEV6vTxnViwFyYYMT0N8yQH1uJrKI cA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23j7vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 18:22:31 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8Hpvlm023990;
        Wed, 8 Nov 2023 18:22:30 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w25e1bf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Nov 2023 18:22:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dJg8tv7eVWZ2E4SDshLX4M12iOJOnXQ8jKpv7Z2I58oRpHL5tApoQj/ZQUj4dEXIvH32XXcw1FvcUuuF1ns8jhygLcH8oQQoouPco71UniHTWZ/fHTua064Z4p5iVjytHBuGcbs5/aTUVt8i5MqNTg1WpmwWhOq5bX0yX4K3vH2ftNXh+yIif6q2WOTEhWag64MiOIOMHyYl2ur/Q4kGgmrEYtPzfTorh7cCI31/1blw5J+v7ACgoDxINmgXSmzb7rWYcaGuIMKNERz6TYSCCep37VoK0q/Hxv3oQrZx9NQMQOqEkFTWwLGbJ+H5/XA4CUISiCWykLB8O3/8xu/chQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/kr66BTrhgELCtt/de9mFnicElBKCgsQMlkBQ7YoLKg=;
 b=NtbXrqyll3yP5/L3I8tuCuvsk0xqSUNKQJUuOKHvh3vU6ld+WgTZuVQsN6sq1Coku88NpHvlc/gGpxYXE4IMQPhYSUqbfqZyVDttYj5Hza0Xuh+dboZZdzm8qlDtHt1wCDH1A9eGaidA/1D495JML/bIjNeMQvcUbxzv3bNPkI/EWaOyKB7e82cU6+xE68YFaidvF5kOkV0TIt3MERJ3/CMSSPNpj+xMSCmYlU/aHpVT1twI2O9h3HitrdPDwC9rtlhr626klFiyS9gs/bp3ZWoealI4zBJOgj4EwzmcIpPQkOKDf/VTL0VO1N+Wv9UlpoMEptT5zKH1fhepOEHIRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/kr66BTrhgELCtt/de9mFnicElBKCgsQMlkBQ7YoLKg=;
 b=y28jXNcCKYx+F6AesMcv3+QpG2V2zNygiDPp5cucOAqR4goID6la52wkHaHKjfOtFbGAuai0vJ7bq+H9OsRm6vCwxirTkSg9JaI3MynPrJLhBHAAlbq4W9m2bmEBgwFJ03PYbupE697GiqFBj0F/M6q5RAvW0QMZtVu0JRb49xg=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SJ0PR10MB4685.namprd10.prod.outlook.com (2603:10b6:a03:2df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Wed, 8 Nov
 2023 18:22:28 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Wed, 8 Nov 2023
 18:22:28 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
Date:   Wed,  8 Nov 2023 10:22:16 -0800
Message-Id: <20231108182216.73611-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20231108182216.73611-1-junxiao.bi@oracle.com>
References: <20231108182216.73611-1-junxiao.bi@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0347.namprd13.prod.outlook.com
 (2603:10b6:208:2c6::22) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SJ0PR10MB4685:EE_
X-MS-Office365-Filtering-Correlation-Id: 929289e8-2cb2-4e15-19d8-08dbe087aa54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n4YCqa3WuJwW7rXTt5o/jLz/eaDFk9takJ9Lu+R1ZUcXrOf6H4fsffnA+ci/NOjxmWUpdF4T1aNISqWrSVj1Wh8h8jiJB9zXLjQGv6yZP23wPe5nxXHSBHIDvl7lsK2TXQPaKetsM4VIRv60eSZLtSuuaVustJC3yjNRimubLBmF9x2gD5NiVG60T6Jn+aORkpzriu38aASnc2cKq4lM8QLzNHCpjlXqNzCGCmCAH+loulZ+DRRCjA5iQRgsGMST/6WGllRmhhjwg7w6go9Oufknht4vFIQtC9VB0+1JA/6z9T6/PjRckvU/yzPw7bkYZYqRzvcDELS6aZAGGILflhowvUCP4VprTkq9u12yp2XkzX8vZlYUtdOE2bXeICldmIUU/z5LnRs4XkTTWdV08GhH3IQayuXDR8QN4cvPSw0yvO075Mwa7FMngyknLKfh/j1/BDG/kbzIjSjHgai8oeX+kZzYNszcZToxY3Xh4nalk9KIorTRlZ04LA0HksmL6lVtkx5xoLx9g3JMJEMiq03fFmwimWPNDT2dKJG9yTyAW1AoA1ZwIqcvwbE7qsMm/FmLtc/jPZMCHgJKFDJ0NeL5bmBzxATiFxbYEGGWFYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(39860400002)(346002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(478600001)(44832011)(41300700001)(107886003)(6512007)(6506007)(2616005)(6486002)(6666004)(8936002)(8676002)(83380400001)(4326008)(316002)(66476007)(5660300002)(1076003)(66556008)(26005)(66946007)(6916009)(38100700002)(2906002)(86362001)(36756003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KF0y0slMMwnajpEQ2r54Y1EkuGBOWIsXMjlGkaCFpNv20iZ3CXUR1YCy3wg8?=
 =?us-ascii?Q?tyRutGOVcz35TBiQkwaT/z2WTBZhjpmwpO057PDuCFKw+5HEw6Lzh9jprv6r?=
 =?us-ascii?Q?vPb0xXe7CqQobx0syAnXJDWIYA47UCsX0JPmB+r5XNOSKgjLacWBwPqcAR9y?=
 =?us-ascii?Q?gvEUp5y+85PuBDY8SyAwE+XoVmeev9PhOyT5bhGLspbnBmvJ01LGLbGGBxdG?=
 =?us-ascii?Q?vAl2kXLdhDAcXifwA3hh2LTKlZDidMbGX75Lqri+GX4O+32jdKxKYPpc56w7?=
 =?us-ascii?Q?X1ttGxsDikWbSMuseWf5nxMHIZYgC4eBlK/OnINqYt7f4rZy+kOFk7hzYI4s?=
 =?us-ascii?Q?OIMsBvfJOqIL3pODduBgBUJdG8IY3btPrdew/2rdN3wgNc27AdyuyqA5oARF?=
 =?us-ascii?Q?+1pmKB6UkcJTAygADW9PkciQ9Cb7Z0TBh0uPZ+SvGdb3VgiC781bJ8ONw9Q1?=
 =?us-ascii?Q?uE/3yaFdEAmnsnAfuMl+Cqht9jwBFSqp7nWJoCfEnD++6YQSX3mQrRJuwQbp?=
 =?us-ascii?Q?T3gSbJjd37cVWJsGmROZnxlOarNrQeoI9FFOfhowHUkku+8rif+KuPURkOO4?=
 =?us-ascii?Q?ivitdQMj+B4+mhX+661Vu0i2WnqbitedSbXUY2cmzh4OGajrlCG7pnris5rk?=
 =?us-ascii?Q?8LOeb+dmrTG/caELcZp7Y4OsxorTW6c3rKf9saCHFYnaJwmVH9g475cBGeUg?=
 =?us-ascii?Q?78A/FlJt6eodSyubora6VGIwSgQDVlZqer6GMP2prSy6MiRrgQ4paHf32ngJ?=
 =?us-ascii?Q?SxCOs7SH4dWgQgn4/mHVP/nc8R2PvkLIK9EPp6vX/hP/oDvepHK2dVai08Vj?=
 =?us-ascii?Q?/pfRFjo529GOzlc8dw6ksk6v4dUKdLJV/QE7AbyT59PYj/azal8fV81d9YX9?=
 =?us-ascii?Q?UZcCCflDNp7qxQIiAOB4vkFUfbEuCfDW7mA9hJJfiqQINOUks6jPXzoINDtt?=
 =?us-ascii?Q?KsV5tR9rUE4lv3SOpRpuV+LHGEnUBhlVwkz3NHuXGPT0gRH1fEDN3/gprudJ?=
 =?us-ascii?Q?SBEjbGPrstnl6Zts4sIthHJyvFNilfRGZUlasyWXQLKubVSAqyLSpqJbGjiV?=
 =?us-ascii?Q?4Miek4hAEMsqeF8g3fANYOJFSg+YfaKUPn6wfTvN1gzvjsgzz2EaFsFnFVBg?=
 =?us-ascii?Q?NqVUSveyeIhvxYs8W5nbTqqlFD316Hx8ORbZxMW82Z5KyZQToU8CIsFtePnv?=
 =?us-ascii?Q?qxZEBU9CAdNogYnuS2cNPgVoyLvW29YRVvt9obq6o/vwUBNRlHwn/RUc3L/c?=
 =?us-ascii?Q?D5kV8LrCYHIXVSEq9um/IEKe0VV8C4MWd7cwK6jUgH65YZ9qW5pLi+qwrr/L?=
 =?us-ascii?Q?70waMi+HsZoXM2W0L84bWsWEXdkCxRhpVKCVt9Tf3jeZVLwI+qyibd0KMH6g?=
 =?us-ascii?Q?nr0+HETVyU8PpzO+oPg6lhbMp+VQCqk5YMBA4JKK0JJ4+nOyrv8XvnxqHHxx?=
 =?us-ascii?Q?0hpyLYZ15HbplMLitbw3u4biwHz8JdWcrH2Bu3bTXwUPSSuvJN6wi0Ony/Zf?=
 =?us-ascii?Q?NHOYDLtj0zNiE0pDGCk/IY0bnrafqTdPKb/9+O15pN9zcVNbpdsm/msyZ9OX?=
 =?us-ascii?Q?KgcTEYPzwF7SriQtj23Vf77N9ySAhY1lVHMBWDGb?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Eo+RT5RHVa1jL04o+1kl+KPxwYcKW+tS02NP17WY9vszHO9JYRUcQ3k9QUqhqHTQUdGuoJ0H59+DpI2qIAgk03PliedvWJOqtqLV89+kAAZuPRA1ngH0oBwqb9gCoSOFxYuOlrnj2PGuGeOijasHjwXDAIxu08JQ9y53o2JvWnmid9mISRryPvO9iVSsc45xLI6kkkM52uSUKeK1d6KOOI/X1V6vjC3iP56rkkUfbRyaNHvGLdoP1yi7thr1aG5QwcXgQe+T0xHT/n3dG0/D1j56f538/esgVuzI+A9waN8Mzfm0RMO2wtYaU4XIivxuwJZZyF2RfAgTcQtD94N72xGhBeLzJFqdrSuOJGjIkIPMeeHr9LPGMrWo3MD8HuShAvoI3POAT2sdIU+ijdT4+ebQRrBoDXpK+c6BMTxGzkCUH/Bv1TcxIBomFX5t0PWC45JmGuWOaIwEeEQWp3BN2GjR1ubzoJ2wmyiSxHIeN/tZFxRF5zs/sykPsCiK6CgdYI/l9GZFhjmIpBYvVpfg02XT7XIYHq/KAK0JNNNlZ+N3vqPXkEZdIRjRcXr9SNDo7A50OSx8qVyXpY7ggZR48pAJLLEz50T6y4s55t0FN8tFnjpUVtNfa7DgWgtegTSVzTPnF95k4wyWYiuYdo/ULVp3F0P5Pb7POx5C0C3yYfBbnwzn2LC9KDmnlsIMTMU4MfFFux7r3PlK/zlFnCZsupBiftJzQKQM5MKSQ1+MU6dp8z4R6lL0M7WHGviS5YPZqPjCUx90yYEj8YekhsUShek2h3Udus89ZKXBofMh80xYqgarKnRsAk01onaArLgNB58pKLSKIwDtOeAXr+uLnplH59BwX5cytOJb9nXiQnhDmvhHrddb/hHR7MzLpkte
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 929289e8-2cb2-4e15-19d8-08dbe087aa54
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 18:22:28.8761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +XkEOZnG6p9zMf/prkWyFQhToQKuo4S0yaXAObAFY8VVE2NkzlS9Ie7C9ijKtVzAnN2rydEmb7xECmhCzAP/IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4685
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_07,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080151
X-Proofpoint-ORIG-GUID: jDGczQJEsu6r4j4QWD9_oHUE1w5DUynm
X-Proofpoint-GUID: jDGczQJEsu6r4j4QWD9_oHUE1w5DUynm
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.

That commit introduced the following race and can cause system hung.

 md_write_start:             raid5d:
 // mddev->in_sync == 1
 set "MD_SB_CHANGE_PENDING"
                            // running before md_write_start wakeup it
                             waiting "MD_SB_CHANGE_PENDING" cleared
                             >>>>>>>>> hung
 wakeup mddev->thread
 ...
 waiting "MD_SB_CHANGE_PENDING" cleared
 >>>> hung, raid5d should clear this flag
 but get hung by same flag.

The issue reverted commit fixing is fixed by last patch in a new way.

Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d")
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/md/raid5.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index dc031d42f53b..fcc8a44dd4fd 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -36,7 +36,6 @@
  */
 
 #include <linux/blkdev.h>
-#include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/raid/pq.h>
 #include <linux/async_tx.h>
@@ -6820,18 +6819,7 @@ static void raid5d(struct md_thread *thread)
 			spin_unlock_irq(&conf->device_lock);
 			md_check_recovery(mddev);
 			spin_lock_irq(&conf->device_lock);
-
-			/*
-			 * Waiting on MD_SB_CHANGE_PENDING below may deadlock
-			 * seeing md_check_recovery() is needed to clear
-			 * the flag when using mdmon.
-			 */
-			continue;
 		}
-
-		wait_event_lock_irq(mddev->sb_wait,
-			!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
-			conf->device_lock);
 	}
 	pr_debug("%d stripes handled\n", handled);
 
-- 
2.39.3 (Apple Git-145)


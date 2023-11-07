Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D596C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 21:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbjKGVYl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 16:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234348AbjKGVYj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 16:24:39 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCDFD79
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 13:24:37 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LJxD6022783;
        Tue, 7 Nov 2023 21:24:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2023-03-30; bh=1kvZZe3+PECc/UyF/1LkSORsjNredWh8+SfnQRhmzFI=;
 b=2sfmgCMWU9KsjZLRoRVS2Q7GBKhlAOLX16sHucYFgfOfBzkjad6yqKT8cqEcl1Ccq6Fe
 3VALGf3YesJBmOPekfIY/ooN/S7CLZv043v6Dj3Ccsr/p107FdTrhfYodVJq7sQ7uiGs
 5K+YnSpNJ2uevXPpQC5EuCJh10+bzjhqNjnx75JoZAnAiQGcEx6z6C2rGZhmt8J7HqSw
 X9UXgTqApY4lsd23bd+/PzV/zPWMHizXGuPV0T1yEZOCPVbQ4zTeCwK/iNW8IlOD/bCJ
 aeg2gwlK7T4wzmMJoOgTDr4Zu0uHw+782/qzjv9MN71DrTK17EzcxWApDCT+o6QxHqmv lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w20007c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:24:24 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7LIo9T000483;
        Tue, 7 Nov 2023 21:24:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1v86tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 21:24:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ax03AMhQz6s5DOXbBs8WTcF5p3CiouGxUwXlZA2TihAQoCmWatueSLQOH1Ky/R2iSXEKhz4zl2El9s64CDNS/Ny3pbRFLMKmkw0M/QKfnmkvzrobm3fdqRBjn1AyQFx3s4JULcK+xVyAEmh5xDisvOC3p14GKqHGBGTcDCRRJ01mKHRH/GYU1TRdorIkdWRhHxzaO7hn+HQBgFvzSjPWBss72q6SpOKHhjbkTpe50ERvCay/fWxH8JfwR8sIlo6F8zcoxD5mIl3wrV7qbwCr+Z6aM/kWZXIhhnCs9lTecUR1Q5solMnbtZHFnaEJvcMimxEKO1Qw7QmsT9BwQLPQXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kvZZe3+PECc/UyF/1LkSORsjNredWh8+SfnQRhmzFI=;
 b=e2D7TBpjvPKbNfEyjHGCtRaTPXowqWjz5zmmRIOKLC03m9MiKK/ph1VAmrUZlSR7fPKrPCrjjKs+VN0TJTVyBNe2as3Ew6HlGxFqXdj1RcitAkKthUv1gTxtZVa+rUqDCHz8plCd9gTsRHjuiTL/V0UNlGKPam6Daumpcqg2HQIgNjYglVWy0XjeLShm0HyQ8RJFFv+zgDazIaMz/b6QQgn/om1YYP7yc0/RKDIsT5LC1kTHCVJLXPFaEN6sL0P56WV0WwCyCniv0gf7p20c+BEI9C3pW94U27g+QWs5Inn+bU9QDje1GaNpAIlehNzncY2FvIFg2dEIu0g7+NETxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1kvZZe3+PECc/UyF/1LkSORsjNredWh8+SfnQRhmzFI=;
 b=QnKmHGlr0Q1ZHwXDE/qmgLAkVB3fHUbep5gLu4a9FD0PDOw1n7odIbm+Vqixq9nqud0Wce4Te9aWXnqmM/9JFU5ZRH0nAufdpSYyoX6/P5Rixt6hsbr7ZpD6bsvrcCDvYKd37tB4QlQKcQ6ZQ2ZsSwM9kz5VeKae9wWZ62ob+XM=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SA1PR10MB6366.namprd10.prod.outlook.com (2603:10b6:806:256::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 21:24:21 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 21:24:21 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH V2 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
Date:   Tue,  7 Nov 2023 13:24:12 -0800
Message-Id: <20231107212412.51470-2-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
In-Reply-To: <20231107212412.51470-1-junxiao.bi@oracle.com>
References: <20231107212412.51470-1-junxiao.bi@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0P220CA0021.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::8) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SA1PR10MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a86237d-fb2d-44ea-aea3-08dbdfd7e868
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xNaTgrqua2eULvL1a9yk7iEd+5+we5Bf11ZdLf6LpTaDMGyyI4wcOLqR/bJ4JvBuzgFMCBCmcsReySbdjPZiw8dKxIViDE1LKvzuCoXJhWSLIidfOryFInwbdRtoo3yHgBIhyt1Z0bTk6Jri0DMC3UzHslZeluWft5c2YeuzinU/wPyBf4oLcG6sBfyEZC2YD6mfHe6whYJzf/9J1PTvPSZOPjdGXvs8G96YioPGfmO9f3U7bc5vEI49JOsp/W/GfUX4qwvk4JBS9rTcvqTXH5VIrO/Nyf1X2ZK8kq5hiklv210wR4jd+fdn/Cl3fryOAg4I4B7mHEe+hIXo4y5HbZmf2XqTc9j/1OFh866dW53Cxa4yROpGgd5SPHS4zmzBjk1fEcgB5wdolymLmBrUNysMoMjiV25FySX7LUV71o68++RXbyLSdTmPwdvwrreed/3C2J0KHc99PhEpTXS/FlNb0wTcR+yANnjVpUoIJn56wUNQks/lhWD49k5c1xKEO016Q+aI96jJ6fKVA+SwwNRIwzhzGf49jh68+hdS3Sc3PTDVlTdn01/izyyWMme7ZLeVzRB7Bu8CHGFe3nJZYtDf4i1crrBvrVTxQ21iwBM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(2906002)(5660300002)(86362001)(8936002)(316002)(6916009)(66946007)(66556008)(66476007)(4326008)(44832011)(8676002)(36756003)(41300700001)(1076003)(26005)(107886003)(2616005)(83380400001)(6666004)(6512007)(6506007)(38100700002)(478600001)(6486002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6rxgpN9/+R/yJCiawKXS9HjhzxeyWbR4fiMRFm2sQUgkR1hTYl56VTpiFQI7?=
 =?us-ascii?Q?jSYlrZOCjZGeSML7f3OrtPyKRwoOUWeytuJfFsfFOcGyTzFaqQYdtaUF+jWg?=
 =?us-ascii?Q?SZvbriaF2awSS2QgpyBS/j5qME0kQrfzC0YX5h+wd7ZKkZhDCLAqyPo6FlFO?=
 =?us-ascii?Q?76cqY1thOAPL2LGo/ML91SYtWO9VBjxGRRkw883m4F86m1Pw1hRkPYc/sSf4?=
 =?us-ascii?Q?4s9yBYLYFFYyi9k5l/ggwH6Eq8Ay2Gp5+hAhf55cKHm9znYucoFWev0iKYSh?=
 =?us-ascii?Q?Rt21jFF2NbDCyPkP+bu/QTA88dYscQ8nGvdbWc9V+SpeDGGdBJHIVVlCFgnQ?=
 =?us-ascii?Q?25nEJ2RUMnSDjCZAL/OAbiThF9PtQZjBlcPLAVQNI8SfDzQsH+o+kNLktRwM?=
 =?us-ascii?Q?ihlEKivREUc6B+UC4409axJs/auvtCZNSJC5BFusMdHqdAdFO0aBH+a3KvLd?=
 =?us-ascii?Q?S41ahhJvXgYu32VU776YB7ol/YlpAuTpuWs9QE/WRNhje1UjPk/okd1W6lw8?=
 =?us-ascii?Q?B4/C5PHZcs6J0ODfsbTpk6PTa1Wxq4sAvUrvYoLh5WFLhXGO4ICiOLyBfbvs?=
 =?us-ascii?Q?HITIjXOXin6dXlccOYM7YXz9eHTrfqHCC9ZWExXAHhXj65wlIsXPfmBQhiOx?=
 =?us-ascii?Q?C7r+UxgK4K3RtPNqDCkCTcVyrFLWUNUoG98IcttPoFrJ7h7Rm57oik5cmZQS?=
 =?us-ascii?Q?jTnZ9O66zO1ZzPqSocgZFOEmQYgqm5vfnHdNh0RG9n+i+hB7DHCPC2BjPAyS?=
 =?us-ascii?Q?E7DMW4FthSzl+J1G252O8AbspI29DVbWjwyxXWBVIYtO5cejnKQaX95A0m6Q?=
 =?us-ascii?Q?3u/3gJj9pJDnJgxI6jrvDMbsSdZZnicaHWG8xgXnyesKyQTwToOFWoAPgElW?=
 =?us-ascii?Q?ONDHmdHSZVZdl+LP3t0urPT2zDenq5TJwtV9cAjza5H47VnbNneZT20mB2tV?=
 =?us-ascii?Q?1yNGgWFIUmEbOqgyvuAupRx5TL7M0BmaqPcjlvb03RWc2bFdqVn0osk+bLkq?=
 =?us-ascii?Q?lSfyZaoJRmqEkKyB53ZWph4m2qsqS32uHXmJ9OpX32xuGz+8JfrWiYZSNMQz?=
 =?us-ascii?Q?gRlgnG7syV78Z3Iij/1WSH1qZhZfhXqUBujHCbQLJbwg2A7op5guvvqiKLhK?=
 =?us-ascii?Q?xvLnGtz9FoadTkWefSHTW35j5RPGK1lTI9OO3ta4SRca7D4s8NzkgRnY2Q+6?=
 =?us-ascii?Q?QShOpeeV+W1oquZa2vF2u1uT1QDqaEUGhpQkpU2TXCUw9Ms/pvVuR9k3b/IP?=
 =?us-ascii?Q?mXTqJQMyPUApTGtnZNV3i/Z8a4AzNK0LoSmE/GlBvGxwpfqw+kQXCiu6CKkA?=
 =?us-ascii?Q?ndaIAKCm7b5R1I2NOQF0s4H0w5VLhtmOpo7N2NAjnNIFqQ6ijdBi+IxxmmD3?=
 =?us-ascii?Q?F5Rth80jISaMWeW1DHHgG6QXK4CyFDJ0Jws8ENMrMaP/jYhaMflh9ZAmIhgZ?=
 =?us-ascii?Q?4CrjSq5KFzy4a7TU0bFQlnzawkl0jtKEfFykO+2JeYeZ0wREtBx2Z10oorxv?=
 =?us-ascii?Q?d5ROZYAKbKwzloDkpG81wxXdoj3LtBeOqfvnfvPA6zcauPrGlx6bkocNRi8X?=
 =?us-ascii?Q?niSbVWw861nJ8yuZV7PPpcx16l86OtcXQ2Bu5LN3?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8cO7OEPaFPpIk7jTB109rgcHrQ/evsgFABiiGRZFX/0q7FiScUEY5piP5hYji3B4dikyafFZ7EhMDeprBW3crJkHg8F5HfcxCeFNOoG2ws09PNUreZbFqp1032mBcbkka47ILIdiyTlzKzT9HoRJJhxcCThi9xm02kKtNv3Dis4sGJK5x4waV9tc2TD32nBhDnhM9Kl9+PUFs7YARW9WLtuyr6O6wb12gGgHcnr9bYLTL0S2oFnrd+b6e9A1anFXDh/fPbGKXHn/hzqnzYOTFNEb7wZW8tykdva9x0T/QufTTOVLbAVtDWu6JnfA9qLL4w/6VPbJc5/qjij+oCjeu+RyOhYT07aWVqGYSTbPpbECX0BaJrJtA1pHajKsQrLth4Pok1yKIUts7f41vseD/utIyH4+EPSi7RI7oDqcHsEAFwTZAVubrwTux1wbVvvGmdOwxV6V5Cpn/GAPFYXL2aLciLBW+AWiis+wSfiiS16cqIV/Qlv+uY47Q+RYviZGzfRP4hMIIsMYlYkX57iyPkyrZbwDx5sv0EKacgEoumimRUszK4wnirTjGI7MvEqInTjKE4A74mpHR7EPGayGz341vw+H/a1+MfxP55BI3PHhpvJgKVxTqWBGWttvCe7aO+krdU2n0A5Xy6BSOe5Lhu5jU/I8419I4Gwsh7S5TL4ueMy55oQKvr286k4RvvI/jc+5c9j6AwV+dLeuQ/zgvdiRNlKkEU4NL/JNcWj2YbvrHvK/cEbRIa3XIYZcML2X+MkGXa2oBTaAlWJJIeRaH3o6Qffj+Ct14+OeS8AedUysDE25oBK9piVBTpRfQzfswYOAIpux1msWLQHjRT++Xu2NkbxDOWb3h2s+MXewTapSgpjsenP/qKTo4i6OF5+Q
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a86237d-fb2d-44ea-aea3-08dbdfd7e868
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 21:24:21.4983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O6xDKvmHphtUL7vLsn5GA9jgGd1lY4Z0DoZU/qpIqA2UH+OB+jpN7TYPGfi2WaxLYrL2rTsXo+i8sH8aal/X7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6366
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_13,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311070177
X-Proofpoint-ORIG-GUID: MzSjj2qMhrb6vjYrgEuQcdtZ58XPtkpN
X-Proofpoint-GUID: MzSjj2qMhrb6vjYrgEuQcdtZ58XPtkpN
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.

That commit introduced the following race and can cause system hung.

 md_write_start:                                                                        raid5d:
 if (mddev->safemode == 1)
     mddev->safemode = 0;
 /* sync_checkers is always 0 when writes_pending is in per-cpu mode */
 if (mddev->in_sync || mddev->sync_checkers) {
     spin_lock(&mddev->lock);
     if (mddev->in_sync) {
         mddev->in_sync = 0;
         set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
         set_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
                                                                                        >>> running before md_write_start wake up it
                                                                                        if (mddev->sb_flags & ~(1 << MD_SB_CHANGE_PENDING)) {
                                                                                              spin_unlock_irq(&conf->device_lock);
                                                                                              md_check_recovery(mddev);
                                                                                              spin_lock_irq(&conf->device_lock);

                                                                                              /*
                                                                                               * Waiting on MD_SB_CHANGE_PENDING below may deadlock
                                                                                               * seeing md_check_recovery() is needed to clear
                                                                                               * the flag when using mdmon.
                                                                                               */
                                                                                              continue;
                                                                                         }

                                                                                         wait_event_lock_irq(mddev->sb_wait,     >>>>>>>>>>> hung
                                                                                             !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags),
                                                                                             conf->device_lock);
         md_wakeup_thread(mddev->thread);
         did_change = 1;
     }
     spin_unlock(&mddev->lock);
 }

 ...

 wait_event(mddev->sb_wait,    >>>>>>>>>> hung
    !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) ||
    mddev->suspended);

The issue that reverted commit is fixing is fixed by last patch in a new way.

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


Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EE62C4332F
	for <linux-raid@archiver.kernel.org>; Tue,  7 Nov 2023 17:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjKGR6I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Nov 2023 12:58:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbjKGR6D (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Nov 2023 12:58:03 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F60094
        for <linux-raid@vger.kernel.org>; Tue,  7 Nov 2023 09:58:01 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7GeTLc023619;
        Tue, 7 Nov 2023 17:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=1KLnModKLcSj6pjKtFx5peZ1U44A1F5dnVKXZ0Ib0v8=;
 b=uz7VCWGqZLuOVuIbsDfaFxcm21gfP4EkeiuCVvhmTo8cCCes7duZ9u9Wbmoq7X65vJ52
 JiuFkheqD1GVQeV+5tM9F1Avu+YKH9kQMP+VmQXpV2cw73HhnW7aidrniFOT9VF79CTq
 Yx1rE5LnEmVRPjV9ohFP0fDH4o9txFCGUFN9fhdw0br5vhzWouts0qkVoHh+UBAWR4PS
 9ZgiH5fY02IMaBfuTN6xjQMMP61GrckqHwge4cFmLSX3bqh52tdj3gaqnzfXNiZvvhRj
 OdqqE4g4A8v34HLBtKDZV0B/S/VaVnT60WPYBjMNY8O/FGkRN61teYUUp1WyUvzrZDMO Fw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u679tngkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 17:57:41 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7GpBS0026788;
        Tue, 7 Nov 2023 17:57:40 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u5cd77a9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Nov 2023 17:57:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f7h/18GWBHImPZ32LFBRYizf/ec1o+TwWQXltYxz4iN+/5UWzLr959Qi7k6fjp125LyQCJWefxjvsnJisP5DCOCF6XEXg8oufNIWE/S9YbYWnfx60DqWG1vEbOGCuCQOo5xYzR1ziD2x2MWrIe7SJQJ/LVV0WHQuvZspfVzXMNlQfxhwbJrYQ5XtQngr/5KvJOUKnIIO7FBTzv2jNUK6hRN+YbNl2f0dx/brIB4or12w/vqf5pwlGyTE2Ol3jS5otfHhMXahfMeFkHnmP4rGQWRthJnyDpDpCkzxaM8lj7nzIwVsQypYgtlJooPsVN+ZYM9qBeQA4Jy6CSHvv+e00w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KLnModKLcSj6pjKtFx5peZ1U44A1F5dnVKXZ0Ib0v8=;
 b=B9lCHY8gECsrN1wUf6VnGg06KcFdKk2Z+yfGZ+8OQc9blEhO3SUVE43jgCBrhCQH865CH2g8ULLsqu0DBYJgBynMIl9/PTZPUffhVBIahJxj3GCGB6HaDBR7UTmioWZcjcauW0xIXv4h0UWYCgsYsNDx0ZF+/oktrQGZ+miepbpuTQ2RZcjCNqa3kqVTz+VX3x+OLjCdfUDNjo0bmkxWopVGGB72TkDletY8v8ebgJx4+JuzmEFFXfzFC9luQXTzAqo5y+EDnCsVr0rUdCEu+SNgDxlYgCCRb5FvQLVi+dacFilxwCARu7W/QOSHhOr94QK8YkdSX04C6hFWVDgiGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KLnModKLcSj6pjKtFx5peZ1U44A1F5dnVKXZ0Ib0v8=;
 b=hXMLBLLEloq0/y38IbEQWUGHHLU1Kc8Ltb6CCE7vFqJ+0zs9SyMOZXThccZYkvT3sT9Pfkoe6KbGZmcwaPw6Ak3m4ravme/XpxO0d4oEi/5zbgiagjDglJAJgcWk/VnnV3RryZp5oizyUOo7zO88PxUFs3GboqITnmNQ3RZWlbc=
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com (2603:10b6:a03:2d7::19)
 by SN4PR10MB5542.namprd10.prod.outlook.com (2603:10b6:806:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.28; Tue, 7 Nov
 2023 17:57:38 +0000
Received: from SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f]) by SJ0PR10MB4752.namprd10.prod.outlook.com
 ([fe80::915a:381e:a853:cf7f%3]) with mapi id 15.20.6954.028; Tue, 7 Nov 2023
 17:57:37 +0000
From:   Junxiao Bi <junxiao.bi@oracle.com>
To:     linux-raid@vger.kernel.org
Cc:     song@kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com,
        junxiao.bi@oracle.com
Subject: [PATCH 1/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
Date:   Tue,  7 Nov 2023 09:57:35 -0800
Message-Id: <20231107175736.47522-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::9) To SJ0PR10MB4752.namprd10.prod.outlook.com
 (2603:10b6:a03:2d7::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4752:EE_|SN4PR10MB5542:EE_
X-MS-Office365-Filtering-Correlation-Id: 23689207-148b-4d71-0c64-08dbdfbb073f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdQziok/uH0mdZYEC5FeajDv7AmY4TDa0QfC5ZAq0JpOQH0gDgTEB37Cs49KcQZhgh7KcEC4ggPatTpK3lfoUHOoK8ukIC9FLG6/waeQ7X5avGneqzzdySjcxSXYFAngKAaPHE5tiUggPwN86TW2+dsmK3ESg7nmEqIL43/GfadWRwGvD06oES7UucUbuefUpT1ojEYnnq96qK5TkEnsnW5tFEvjUOCpV6M3vyb5fK4KKUBARm6EnOBUw2Cn6OtG/x/383DL7v3rYijDhLOf/cmVDblxzl3izG9xOXE0DZ1Cgx4GyAHmrH5fLwJhvvcGndWe6kvdYSz3T4woFft0sL6p/HKHu2fc2jRNSlPqf/POKLe/aBDHAoHYboJqC8Dl0S2OsqdKkBlf7ddRsj8ivzEJTCwXIN/FvkciP8Y6vS3lB2brDeg9uAt/k92cZ/QU0b5VJ7fJxHKcCalk0GyjXb9+miKingCq2KawkPOoog/TfJ3OxcjlR9ijgC2cQLi7l8L+6TgXE8OrplBVZRqvo44VofDWNttIJUlvybjz0xV18kLWCIcdJc9oR3AL8U897Meg58TFjG6XkcHkRTHT6PhQST1Xz7FBLGHuYhdgOYo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4752.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(39860400002)(136003)(346002)(396003)(230922051799003)(451199024)(186009)(64100799003)(1800799009)(316002)(66476007)(66556008)(66946007)(6916009)(6506007)(2616005)(6512007)(1076003)(107886003)(26005)(38100700002)(83380400001)(36756003)(86362001)(6486002)(478600001)(5660300002)(41300700001)(8936002)(8676002)(4326008)(44832011)(2906002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WReNm0mKpAvMV1d7xh2fGPcO6wA7RSXPMsOKGgGCOjDodwHVC1eKNirSxej3?=
 =?us-ascii?Q?fxSeuhqC60AIy8OlBVZlFhJIy9cbAyUdZjnAukGZnVWCcQqWdi8ymZ1VFWqT?=
 =?us-ascii?Q?kU4A/jQzN7nzz96nEJ3Ir0CSCb1i+WvZzoQIsUOYYOUYxerxC3MR1Lu214FP?=
 =?us-ascii?Q?2QSHZfvn8voqUsT7wcIf8advydGtKhrEPiV990CbQcZxsaNePosi+DwQ3N1H?=
 =?us-ascii?Q?rPFJ4xXDIEe8wDVgw4E23LTWjdovVVxi7xRLvXsLrfGv7SkxhESrO//ZoFso?=
 =?us-ascii?Q?BheAyKuujEkyV4VLLz5L97/X33PVWpLulLM7A+My5SV9TCaElT5W3l3Jxgmn?=
 =?us-ascii?Q?k81wF2zJVpQLTT4Tq534udZZHX8xOwIoat1taD51RZO37DLi2zwCOdBtBUxq?=
 =?us-ascii?Q?Y40L0gVJoh2F8aOoiyHJBElUeWkVwnFsdJEoigf0iZAzpiB/n4a1uiU1E8Jv?=
 =?us-ascii?Q?afanaQXSMuZyPCPH/zvYGopv+/rNg1+reZfx43xy+mVHpgxtp4uICdIOewNG?=
 =?us-ascii?Q?md/cHoa2tF9T+Yt1szmV9oiCyRsVjPMq6+yYQgLFVtiEemysBWSrByBU7Kfs?=
 =?us-ascii?Q?LYgVhpCKIQk5AopFn52htz/ZHQXZuVVAGFe9VzBHwuRe1JNOU0EgjNCh8246?=
 =?us-ascii?Q?oZO3gQm85NzOXfu2TEof+Q3TNJq4Gmlq/J2t+I7n/ookJk0s0oTfcSvkyl6q?=
 =?us-ascii?Q?sdQzxMfwGNgzQ1HvbP6+IjkxVrckqaffaKVAx7bo9iuC4Yty/wJUdC7wO0WF?=
 =?us-ascii?Q?91LrPfjwnMxxKV5+iVXdFCx5qP1c3qwzAPZsPmLrDhwX2CIBoDsamzlulvHX?=
 =?us-ascii?Q?uYnhie6shwwtBghsAaqnDlNTSVYfhEoeidAyMP/21BWHrRUoKyNUG9fqfn/I?=
 =?us-ascii?Q?941TxnS9REEzfXtZhcpPgqRp880WYx34ZDSQYPgat1fMAflXhODoNdS6phqc?=
 =?us-ascii?Q?i13xackdYJVLifqOSPlNdCjcqtmND5oaadv6jueoJlyNVq3XaItcHWTU8HcE?=
 =?us-ascii?Q?Pw+nfa4JQABPB7l9vvPm/JjyC0L8q+w4QPe76AlHXPM9a/o46DKcA8MRQnxi?=
 =?us-ascii?Q?96kOZJ+zYiVEqDms7Q2EkaakLbBiFcWIvjzQ7q7sd6+OJ1kzLYMPy6tvQtOQ?=
 =?us-ascii?Q?IAtBcZKXytI1h2xwJHzc5jcL2sn6sUNEqahtxkOiJuiNeNWsQYnx+ZU4/hbB?=
 =?us-ascii?Q?C3/eAejzaNw/m79UrKQOcxynnYM3iwAuDj/plgbYjY4Z9Z3Eo2O7OK8mrX25?=
 =?us-ascii?Q?eSYe/EowT0r7Pf6Zr39N+apyPuKhr6EbEdzipNzq8oH2sOlH/JnxnaRX1e6Y?=
 =?us-ascii?Q?eq/a1DfYj2A2egJc5zEkxlsKQrVArFWGRQdNcMp8kaU9ZUZFhuIkUH7zvluN?=
 =?us-ascii?Q?UmA6KydPePUkGy5DOmGPF14+DRRGu0ZjAP5UbRiTsOJmzdZDeYFiClxKvwUa?=
 =?us-ascii?Q?fpgFYnxmHwjwU4jCex40f2c7Ufx7NtltdEXpAYaP3FSIrfhXhoanAj4gg1zZ?=
 =?us-ascii?Q?PtRabwt+agi7L7dlYNyagm9JHRIc0qrInRW6hj8T/bpNZ0e63yiECZTf/EjO?=
 =?us-ascii?Q?oTc8piEZRX8K3AOhbe+YGlCIo4vhJjUQgNvzhy/p?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 6AT4JNf1R0vgQn9rUNn807GTOZ628yTWzE6TL1qmovw1GEY/d5tgo7g8jT7ywfF9IXT0mQfmU6rVf8ZgObSsUIrsh+kAn+ngb5rPv8N7aSpu8itXfgNdBpnr5pGoI3Vqp/ldYg9/PHhpFD+pZjPOYbWoRQAC82eJDfidAcIb2HRF+5mMFhXxQt4OgeG4O+4KQACtjN3YmWwglBy0CANfmmf+OUZDXbvlZdBeW65lAhgaWEQlmaHY6TKQlXWLWdY/6R+psKoiVXuvT9x/5hnjbkOGOG0VWRbqarlD3Vfjk02OBWN0fmm+IiXHOekDa1VhEw/cQTmM9fuLkGBePxUnARyR9mk5rEVbPaW8bJoFwGFm2+m0HSI3U1Zp2sZ1tBY5zkL3CpEPbmp1MsKBQOuDk9tOFoIqYMNFrJW3hklh7rZxHfk4dWaZikAxQdd/p/j0Xh1tm+W3BxMMMF6KxJUNwCo+XMfybnpJDY7LNBSriGjsWBs9yAsghXrW9EJS86TsEcbnFw5Vdma0J1SNJIfQ7MdUWd/Zpyjn9owtqzn2TjtgS8VlQS1DMKgmz1lI4TGWUIhqQE18dA6Tk35b8barCq/RIblqGe/RpWKYQD+MbFE9pF0gtsUgQzAaS4OGPZlRzVucpbbtkzhAbnaDtFC1z3fGnNPXZX/TYnRYF/K/rlqfHylUkPrmW649OCQq+YgnvOOou70iWpyrXR+dk00OMeTu7lGauaqLkpbdj9KlWDSph/UAGsNvHYEUtZ00jfw73RSQc8De9gh+ggxRSyIhuHa/fzKzE5UJQuqhCwBmFnRhA1u59TRBCHWEeIgRp2DYewsd4OwzZWOiJbmILg7UsX+2JhZrNEUYxkaFosmQKclbrMt71nnj3CfBGZZYP4yk
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23689207-148b-4d71-0c64-08dbdfbb073f
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4752.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2023 17:57:37.8996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vBAEqfaGzXtRkfkQXjc4IFyZbDT0GdhPyqp9VrfL7BMKn0mgAOSLrpSxdkl5mT+mHCR9GKpj2260lE247VmDPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5542
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_09,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310240000
 definitions=main-2311070148
X-Proofpoint-ORIG-GUID: t_Tcy0h9odaWkL_cNxHLU-5kPgdWClQL
X-Proofpoint-GUID: t_Tcy0h9odaWkL_cNxHLU-5kPgdWClQL
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

Next patch will fix the issue that reverted commit is fixing in a new way.

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


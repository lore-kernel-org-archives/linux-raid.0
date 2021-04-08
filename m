Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0748C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:44:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CE126113D
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhDHHox (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:44:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:25564 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDHHow (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 03:44:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617867881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=TnOfJJgbIlw90yT+pNj4uZo4JMZK4TdEMFg7/jvYG4s=;
        b=WMvKxOQNQyxVJ8KZGnpxE/bTEHqmjdllkGMfbkuZ1rO+XYyxzIBgi8iJi1j1Gx4Dl2CquL
        t7qtgK8XYJD4DjocrrST7ofOkrgWRJgVe8YykQGll37Yn3DVIKa2L0piw1KSQKzpOrYJQ3
        uJcatU4Ozq07HR+86gLNXuToF3g2y78=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2176.outbound.protection.outlook.com [104.47.17.176])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-59qPSpfgNRK8N18hF7gkew-1; Thu, 08 Apr 2021 09:44:30 +0200
X-MC-Unique: 59qPSpfgNRK8N18hF7gkew-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl2oKMwZRGcNKAVBBjru7o2dLyO6BQQqxu0sK9l3sjTjYJpVAA/JBWnMiQP1umO4JljWWb1TswWZdkbrjV2pztfULtMM41iM78VOFpzqc5sn5jvLpEQriSXzcpUdVT0Y+nOzwEMuP8ahCC0iJEZFnuQWToZZcIdb1BpR1W2YAp+XkrjCRAHvTa6OJlVUoo2lwFmWGXOT0UgIphJXRDRsk8tSbPvN9HCV2zROp3mGs1CtvwbzLz6dFcV1/qY+SxWH7v9rytLJqTxdCDswrPetUwZ49eA3or5y7JRnM4Q8VT7/nTH/f/IIrm3T+0N6zKdTOwZzDENZm6vhYksC/Ul4JA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TnOfJJgbIlw90yT+pNj4uZo4JMZK4TdEMFg7/jvYG4s=;
 b=KcU7ODAI75gS2tXBKGGwx2LPqCJwxWbFkOmn/MK/Lk1nqBWsguEydSRJIibvR0uuXCudR6+lI6GnXHqRFj+TuDmENaznWj7nvQkFBsfbaOpAu/3mIX7y2noaDnO0c2c6GJe0d9NgHZGAXVEtmjwnGtD179Galvv/iGnr6CwOJ2SWqA0y5ZTcvPuldzw9uVfAvS3IJxVAfVpcR6S3qUokuU/T/4/gBPKWQ5sCeKT19r6ds4oSlSFjN4pmKIgUPaIZvGT2k65Qt5LKltHODjl0lARGWInoK+iJ8MhI+MYhGQXyf+j99AHN/1XaeG3rUmQtmby3+h+W7bumNx2RL5y7Xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7415.eurprd04.prod.outlook.com (2603:10a6:10:1aa::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 8 Apr 2021 07:44:27 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 07:44:27 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Heming Zhao <heming.zhao@suse.com>, ghe@suse.com,
        lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com
Subject: [PATCH v2] md-cluster: fix use-after-free issue when removing rdev
Date:   Thu,  8 Apr 2021 15:44:15 +0800
Message-Id: <1617867855-17481-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK2PR0401CA0010.apcprd04.prod.outlook.com
 (2603:1096:202:2::20) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK2PR0401CA0010.apcprd04.prod.outlook.com (2603:1096:202:2::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 07:44:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c1d3f50-c03b-4a20-3c90-08d8fa6222bd
X-MS-TrafficTypeDiagnostic: DBAPR04MB7415:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7415C22CB57ED15B2A2DD96A97749@DBAPR04MB7415.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:639;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PaYUMU3IdgW7gly7LM/VKYLp9M0ATr3e1aEyy+rcFn9lxvGJYY3poHORlxMbBE4zT9w4Q5ohG7EsHxn5QjNLPc2voNH3jT0zV4z2VcxrJ6G9HD0JkVJVu06cg1n/0Ty5H14aUeOL3fC+uy2QAKwczscvnDxu77Smf1DsrZ5lU7zPVxTIuz+Va+3bB+L36N+iDHYq+X6Hviko9OTg9c5kailKS6VipbfpC9T+XVMAzj84qypWAfnLtM+o8YKa/PsgilRPJjDlSS9C/UMsO5Zc8HDtRK8t05OVi++geLjMPWGZ2C128ZvxVs2m1tu1pD6awrXJpiaPFakIDg71NsZGjw2EW3yYQBt2ILElmVg69fP9Ft5WraH/D4KvVfD1bJtsXEhQsnUbVetrxUULnjCm+ek1RQ3bzSuD8xrf04c9wQl6OTRyq6Jmhg3twjEqGicilqCHlVavo4EHiz6Kr78nUfd+XmsYYAz40e5/Sw2x53cXzuzCXvJfnPO349JTQ9+n31/LMFkjXeivc64l81r2l0q52a1EjL11+wvMJbOmnWrzgM+qUV4Tava87lKvTYj3HH7YgJTRzyL47MBW7G92hbD4ehos9IjAFkqEuAemMLO2vKnWvxpOB9Bqh2/Vsfe+eSQFJHCpU1EPKKDmnqV4SmC5UyhoqYwDG1qRIJJwIDCUfYPvobwybm4wStaRn5/avfacc+xMj0uEdhh8mb98vA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(6512007)(6486002)(956004)(38100700001)(38350700001)(478600001)(86362001)(52116002)(44832011)(2906002)(8936002)(107886003)(5660300002)(26005)(8886007)(6506007)(2616005)(4326008)(186003)(83380400001)(66946007)(8676002)(66556008)(6666004)(316002)(16526019)(66476007)(36756003)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IhomnIAT+DNEpkXAAFRmWuF7qSBkL6a26D9fDw7xIjPkNwtQfylWd8cKG58R?=
 =?us-ascii?Q?glsTQSbiHqpPEn4fLLx30MZ+HNTRtB8hXGnTVN/8YC8W9uKtcqRe3QBxOJcG?=
 =?us-ascii?Q?RrIPZoqMHu2IiRxb72QzhzhPHrNyz/YAFoA6h1CJwnloLW7E51pefgDhQb9L?=
 =?us-ascii?Q?QBJXebb/XfBzvOE5NZ0EYPpIHNTcl4/8yakuGClN0ZoQJ6R2j7LLndduMWlm?=
 =?us-ascii?Q?t6dmhuFsaTRZ0Qp2GXMz2gnTfcg4YvMEOA064jJkESnAog7Scs3RnxscPwPr?=
 =?us-ascii?Q?5E6COw2vnIwSqQTU0wB/H/E6VUt7Jdnj5ABlk3SpqNHnRdI3QK1wZnHnUPs3?=
 =?us-ascii?Q?Seth166HSw39lTxVCzdcZmpmwajrRR8OJloOJEFCnyM66Oh4BlUs3hZjvuh2?=
 =?us-ascii?Q?B3kS8UbLW0yGUDn66qY5Cq2pFfG3bCCZ3TGqwIWZ0Nzxmcgs2qWkGUlJDQ0I?=
 =?us-ascii?Q?NtZpEF7ukg+5WfWaJMK9rtKx1CzIsg7TkgewobGPVjU1rKI4d/necDoPVW2R?=
 =?us-ascii?Q?vq2WhKCldjtvKxkwf5PBtIOqMP8xXIuNXx6FtD9fkrYxenedR0lQLLtIYjpA?=
 =?us-ascii?Q?0L9nXj/xLfdEjkv6oxoV6BEbpLq2Nt77orcJf2rL2hcqcWNVQw7UtfTgAbU+?=
 =?us-ascii?Q?QvC4mwQcgrOhzs8vufKMbZZ/di35sGrVggyMJG4NI2Ay+wDsiaDBk5u8OU2V?=
 =?us-ascii?Q?wxTUw7a3TAqE0nHuFg79lsjw/Us+NVMKjo5nmkqANGtpPLQTo5YOutfaF9/U?=
 =?us-ascii?Q?pEh1UHKUoyaDDwvvZoVAP8IWd/JXH7vRoLKHgCFmU24LBr2b449828Diw6+X?=
 =?us-ascii?Q?358UIvVyGHsClXqAnR/PQF8YDqZ6xu1du3IN46tbk8KXMBMScfQp7Jjudopc?=
 =?us-ascii?Q?YlsxioTz0oYKGhvwPS4oPygAq0Vad7EYvbqcvDUfSoa0KMfY/dWUBrjBnKf3?=
 =?us-ascii?Q?/fTPMg7q/UQ/RVa7Fz/TKjYR+FH/irYn4csbMgbQ6soYNqktMfEjN38qUKmB?=
 =?us-ascii?Q?y9Y04wiiW+akqeUxIMDsCQPGqo8KSrS2pWvFjFjgdghxYNuFZ5EozCeX7uMy?=
 =?us-ascii?Q?k5/wk9AATx2axLR2ZxNFVFzDZ59LV5b7AJj6HizhTa6MIj3V/WOFOOJYAntU?=
 =?us-ascii?Q?5KP/wzMwawi7Hr5TJTCsxkuSOPOosMfrA0ktyoo3YnftqowOnhsM7wt1W6bg?=
 =?us-ascii?Q?d9Yey1baGKp9bBUDkJwIBU0kRsT+i3fApNYDLLgRvjN/IEYzv1FyIbl+y5Pm?=
 =?us-ascii?Q?itDlQxv6456w4ISLzvnlp5utNbyY6I7uYPk7dZnnOBVYP1MkjNObn20KVVEr?=
 =?us-ascii?Q?h59cbLHWnLJETegLbQCJBobl?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1d3f50-c03b-4a20-3c90-08d8fa6222bd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 07:44:27.2809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vKX+Q0bOvbeLVwaA+oCkUznEDbO6kcLpAFBOJ5ANR7OC83h/AkAB6h3XuT+NNZ5oOjh0qdrErBZc3n0Qdl6h5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7415
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_kick_rdev_from_array will remove rdev, so we should
use rdev_for_each_safe to search list.

How to trigger:

env: Two nodes on kvm-qemu x86_64 VMs (2C2G with 2 iscsi luns).

```
node2=192.168.0.3

for i in {1..20}; do
    echo ==== $i `date` ====;

    mdadm -Ss && ssh ${node2} "mdadm -Ss"
    wipefs -a /dev/sda /dev/sdb

    mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l 1 /dev/sda \
       /dev/sdb --assume-clean
    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
    mdadm --wait /dev/md0
    ssh ${node2} "mdadm --wait /dev/md0"

    mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
    sleep 1
done
```

Crash stack:

```
stack segment: 0000 [#1] SMP
... ...
RIP: 0010:md_check_recovery+0x1e8/0x570 [md_mod]
... ...
RSP: 0018:ffffb149807a7d68 EFLAGS: 00010207
RAX: 0000000000000000 RBX: ffff9d494c180800 RCX: ffff9d490fc01e50
RDX: fffff047c0ed8308 RSI: 0000000000000246 RDI: 0000000000000246
RBP: 6b6b6b6b6b6b6b6b R08: ffff9d490fc01e40 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
R13: ffff9d494c180818 R14: ffff9d493399ef38 R15: ffff9d4933a1d800
FS:  0000000000000000(0000) GS:ffff9d494f700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe68cab9010 CR3: 000000004c6be001 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 raid1d+0x5c/0xd40 [raid1]
 ? finish_task_switch+0x75/0x2a0
 ? lock_timer_base+0x67/0x80
 ? try_to_del_timer_sync+0x4d/0x80
 ? del_timer_sync+0x41/0x50
 ? schedule_timeout+0x254/0x2d0
 ? md_start_sync+0xe0/0xe0 [md_mod]
 ? md_thread+0x127/0x160 [md_mod]
 md_thread+0x127/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 kthread+0x10d/0x130
 ? kthread_park+0xa0/0xa0
 ret_from_fork+0x1f/0x40
```

v2:
- modify commit comments
  - add env info for test script 
  - add 'Fixes' filed
v1:
- create patch
---
Fixes: dbb64f8635f5d ("md-cluster: Fix adding of new disk with new
reload code")
Fixes: 659b254fa7392 ("md-cluster: remove a disk asynchronously from
cluster environment")
Reviewed-by: Gang He <ghe@suse.com>
Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..9892c13cdfc8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9251,11 +9251,11 @@ void md_check_recovery(struct mddev *mddev)
 		}
 
 		if (mddev_is_clustered(mddev)) {
-			struct md_rdev *rdev;
+			struct md_rdev *rdev, *tmp;
 			/* kick the device if another node issued a
 			 * remove disk.
 			 */
-			rdev_for_each(rdev, mddev) {
+			rdev_for_each_safe(rdev, tmp, mddev) {
 				if (test_and_clear_bit(ClusterRemove, &rdev->flags) &&
 						rdev->raid_disk < 0)
 					md_kick_rdev_from_array(rdev);
@@ -9569,7 +9569,7 @@ static int __init md_init(void)
 static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 {
 	struct mdp_superblock_1 *sb = page_address(rdev->sb_page);
-	struct md_rdev *rdev2;
+	struct md_rdev *rdev2, *tmp;
 	int role, ret;
 	char b[BDEVNAME_SIZE];
 
@@ -9586,7 +9586,7 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 	}
 
 	/* Check for change of roles in the active devices */
-	rdev_for_each(rdev2, mddev) {
+	rdev_for_each_safe(rdev2, tmp, mddev) {
 		if (test_bit(Faulty, &rdev2->flags))
 			continue;
 
-- 
2.30.0


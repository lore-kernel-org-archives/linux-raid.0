Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9518CC433B4
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 03:01:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7477461168
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 03:01:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhDHDB5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Apr 2021 23:01:57 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:58137 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229514AbhDHDB4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Apr 2021 23:01:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617850904;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=2VVrixXYwovv/0d3maNKXySprmct8Ln3IZ52vHO5Qy0=;
        b=ApcrVknTZcpUNaRbSZnXTi90p/naopp3RBywEXw8QC7etijaai4vDC6rjvQ8DEa7RHOoLj
        EpQ63xBerDYjSYpzGqJxhTWcLTlxliATts3L1+WdbISWR3OrrMH6CZFrlnvzsO+/ozA2vG
        iZ63wfNppernSyiEC41o8zybBM1NXRY=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2055.outbound.protection.outlook.com [104.47.1.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-lb5WqCCrOKmo6RZU7a6-Ug-2; Thu, 08 Apr 2021 05:01:38 +0200
X-MC-Unique: lb5WqCCrOKmo6RZU7a6-Ug-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmkDMPgpfg5I2vPphC3LE0gBB0hCthCyUSbcjAJS9aoICYmh8z31zhnrezraPlIaHsfywJZ8OoQ9rm/hpczdrwYMlAXpTo37MfdUZGl6TWC3tmHOQVeX/tJvjYuTEzhbt1xrc+sIlUKPVi3EAEjlIB0rgYXovBXMNSPNWaOO9PgaISAAdngVy1zUbhXLeHaJrMS+omm5dFASCSKrEzx0zuElZ1FGvUeuLhovdqWtwZzcEdNjA932gEqo1EP4kdlw4gDRQs/cQvfZBQS5UnHEqfINX2AmLZBgc74LhdTF4DQbfhDAeOJ8a21TiAqypfu0cKl8NXKqi86+fL89PxJnJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VVrixXYwovv/0d3maNKXySprmct8Ln3IZ52vHO5Qy0=;
 b=CwYCvQd6sJACGg8zHWWKrbSDfe3Gqzyt3DYhMfZGI8gX75euh51CCd/LBlIvYjvXhxGDZmrpd/vIlI4d5MndNlYwqp/qxEhEX9IdVn/w767NDGQq5ruYgfdQzGFTzMgGNtpDN3MFUYeKXV+qsHV8KNlSOyx5UySEM/rILfysTi9jotatAwtrZh9RSJ9uRPSxmGLso3DNwtTNxVCEpTrs/KrEgZDizcQtGLLoJ4jQVZylFbs44CywUk98mMzb+nxSagUyB2IINoOFgbm4Z7Zw7o3FywUwsJKx/AsHiR/R0x6WlFeWR//8N5W4XC8vIShRJdUx6k+Em3v6peIyM/ZPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5449.eurprd04.prod.outlook.com (2603:10a6:10:8d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.32; Thu, 8 Apr 2021 03:01:31 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 03:01:26 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     Heming Zhao <heming.zhao@suse.com>, guoqing.jiang@cloud.ionos.com,
        lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        ghe@suse.com
Subject: [PATCH] md-cluster: fix use-after-free issue when removing rdev
Date:   Thu,  8 Apr 2021 11:01:02 +0800
Message-Id: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK2PR02CA0205.apcprd02.prod.outlook.com
 (2603:1096:201:20::17) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK2PR02CA0205.apcprd02.prod.outlook.com (2603:1096:201:20::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Thu, 8 Apr 2021 03:01:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b048bb7a-2439-4279-3e59-08d8fa3a966d
X-MS-TrafficTypeDiagnostic: DB7PR04MB5449:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5449D1500F2CB0C1EE863F9097749@DB7PR04MB5449.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HH2cCbvPulK4E3ERh+p3ODQJ8980lZ8KVoz3267NpJ9LUoHPb9Jb5niC+85474Sxcc/HrMBQyVGDXqxtEls/QUW2AfxdS2b1lnXu0ViRPXj7q0zQYY33B4+qQaeBdbcU3teatIn1nkmMg0anx0987vADVUV3zvRPXR8QgXCturi7TJ7hEjz/cewJq0YU7gwObGa6IG0Iv6kkruzJnNqOsECnzJvQYoBCiy9Fum6sWffUFN+hZgpwHMF/0KGKngFp3X9/M/I/CasaOCuUphn/T9YvvxXa//vcyfiF3bQzMsui8YyxvL7tt1fgwmN6kNVQ304tK+si+XtW0Qd2D3bip8A/VKKyB7sPpNidH5LqD5OB36QStaPoW3hDvQv3NOChMpr2FvEPj4BcL1qoro1CeEO/Zw2QYlIqyArFzH4uNV1TnWU34AyD91VKHGZfmz8/kk3G5Rz8QMiN7uYbYRRcLu6HMKJ1eoJS1WB3JIJabzQ9MlUe3JwJwBK4ij9mtIeMjuKUHGLc/nnXKb+xhqtvPSQiV6dLa7VeXCPc10RIQ9+Q2WTrd8yS3m/3enXVU5n273rH11rNGYj7rFq0bz7l4wEUDztLuXhkGQGtoLMxmjUgtajRp695EMR+LU5U/4sxUXnMnIYMifOzjyG4OdimjEzoIoGtmEkeB5ftzkYVw+Ns3VDkwCb5y2/icjh1QF9Z0skO/ao5qOo7Mvvx/ekeaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(376002)(39860400002)(346002)(107886003)(26005)(38100700001)(316002)(86362001)(5660300002)(6512007)(6666004)(478600001)(83380400001)(186003)(8936002)(8676002)(4326008)(38350700001)(66476007)(6506007)(66556008)(36756003)(956004)(2616005)(6486002)(52116002)(8886007)(2906002)(16526019)(66946007)(44832011)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?f9IK3L5vI3kPNUppJNZlLHK4m+htghDed3hxD3hb3sfM4pJ/wzE2OmeKo2e/?=
 =?us-ascii?Q?7by7wonza7m5cmRpeR4zfpb7ZB4FRAD4SvxLb035COzKQ3+yVtCVxX86XNZA?=
 =?us-ascii?Q?H3bgqtkYvopRayittz6Z01h7+BDVOmf8ALsw0RNjw72D6ooV8wxxNNa5uUpZ?=
 =?us-ascii?Q?pYgBuqHF3vTpcOsgarfncFb7irr478DezlJ+ndM1tLZQN65279DdKOw9fA+U?=
 =?us-ascii?Q?7/X8L6+dPTdR/FaPzvN1uEl361tRQqdFEJE43tcRMK/rePtToNWniEUcoHFD?=
 =?us-ascii?Q?vfuTZlbG4TgGlEqWQKcTiA4uiXXaPYY4GP6GnWMoubbgf2OoxZeKefGWbN4H?=
 =?us-ascii?Q?rOfaKP1cMKNVF8CJarxI646M87zpsR06wjRePADM1qJuuLE0l1R1pKX9p7Aq?=
 =?us-ascii?Q?H2jNRfzacOJ0bWJF7d2GT6CXgUz8xryQY+eEYoetgxyapB0pCcBgrs7Bq7M1?=
 =?us-ascii?Q?CJ3uWI0ujLEycgFaa2/DLb+PuiSfs1Mnth7FjcHLcmy0k+AYG2Qwl7id3f9w?=
 =?us-ascii?Q?BoG0KcWwxCQTuY17Mq6DtKy4bG+u/LPlhrbBdWNv8djF/cIDaYwdZiHurtt0?=
 =?us-ascii?Q?Bgk7JESj+jtBOGUJ7xUr/b8UN7jq+UCjSiEzUMhq40D6vQddTxRD51HviuaR?=
 =?us-ascii?Q?NCRDWKVHsmP9LaRMUTL3hHbeQXz917W5lVlEp+nuZ9mdAPUij3AOyEMynmA+?=
 =?us-ascii?Q?MvP6JNEZo4F4apK8OZh6aC1V89lbP0hfujB3ah6qAWUf95pUq11S/V2nPW/J?=
 =?us-ascii?Q?2fa6axitAC6r01PK5DDRbGM7enoFxy7WU0MvHwKFiibcDtEotNA97Vr/B0gD?=
 =?us-ascii?Q?iLzK/cUbqFjdHPWpU8D0crXm6l2dlMCnOrC3UncaoQS4XgsfjNr1GAbJ+KSu?=
 =?us-ascii?Q?ghfKYruF/AlH+/bn9CSj7pXy/lXUUJlvzxfYe25DWZGfp5YSzqWDKMnJ/n/Y?=
 =?us-ascii?Q?CKYmpY+h9aaycU/0mik/mfzvLtXHZjsQkVAwtZnIWrdaETIJN0aRW/4jWXnA?=
 =?us-ascii?Q?J/aA5/uaGhGnyfhNKownqXBeYrmK4ei7FMMjtlNpKuHe8UMY0PU9V+ZRLbmN?=
 =?us-ascii?Q?dWQr2mvkKqO56J1gN5tCJJ1Fa3aMvk8rRxp/nZ8xx4vYpqG506t0X2N3vKWW?=
 =?us-ascii?Q?8rK+3NGkaIdSMEZfMEmtr1XiSbm4o0HMJiuFAcEEToJpIYKpIPnPhd7hFAhQ?=
 =?us-ascii?Q?on1BPUn1tv6QEWhy6/AqWdJtn26o9pWYG7KQ3MRH+psuxw+uK/aZJ6QYSkUr?=
 =?us-ascii?Q?8aSOZJv47VfP1Fv9XFVYrpqXt8C04gfH22VtfDfubUxemTYWaO9wIoyB70dM?=
 =?us-ascii?Q?nqCy+3c7r4yv8nx3pBH+3M6H?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b048bb7a-2439-4279-3e59-08d8fa3a966d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 03:01:24.0357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CmeoQNZGtswMvKS2GHEZi2OrUP8xhYhXImUQpj7dNsQH+fU52+1XoKMYHav6OguHl1MfhVKKExXQIivdRGwWOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5449
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

md_kick_rdev_from_array will remove rdev, so we should
use rdev_for_each_safe to search list.

How to trigger:

```
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

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Gang He <ghe@suse.com>
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


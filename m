Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95AEAC61DD8
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3731222409
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZVlV3M+T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKOEa5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Nov 2020 23:30:57 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:46546 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726177AbgKOEay (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 14 Nov 2020 23:30:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605414650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHwvhF49EwwNLyLBYrDg3AOcECPfzagrki9kaTT6wr4=;
        b=ZVlV3M+THMvZoH6REk0LE17w+qv1xEYaDRC/0dmJMs/9Q+vzYHWIw+hNhh93UkP3ItKG65
        v4knNbgExnP8VdqiS2d3p9zF9TeZUZSiGe37gfeUKvUCxoC72DFVYcXYHbZkuVYjD95e2U
        we9oVhAW5Scg1+kqL/ija8hQosLsgls=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-rNqRQno5OCmRMCDrTnE9OA-1; Sun, 15 Nov 2020 05:30:49 +0100
X-MC-Unique: rNqRQno5OCmRMCDrTnE9OA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SQxV0WTUPT3g9jiwTsbbvD2JVGj1tTA4xh/1kxq+izDDyuj5Ne3sUn0JSqTWh5zgQG6XzYR26GFy4s8NII6tiBmSccb8YB0qBulykNNV8rCVmcTShLRQ6cB8pbCJaNbQ5S62bYlO5+mYQ8bgoYJOx68kJ+fEKn7rmGnRWJN62B8/96Q1a/zqNbnBfCKWUQTu4snUEjw1zaW4FBa4ufgv2iDTgXASxUjnazWi/sIMuZPqPEGdzmNebJEHvVqdfZ0yfB6YxRBJ6cIM/ajRI0qOyYQDXF+UpVszz8DyBvRS0G/FmdeJLouGmHn3pRrSEnJRcukx4IeUU3lpS0JDMaJ1+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHwvhF49EwwNLyLBYrDg3AOcECPfzagrki9kaTT6wr4=;
 b=CxYzuXhf4YZu5KtfOZh4jSJ7+0qbjoNxArb4qU75xjW2UUV2SFUns1xZaiEc5xy99ASSV/PTaWQQ3L763yD8fqMOif+miNYICt0j49Bz/OWt6kDm2qSmItxxt6bgrKgvUY1Emdfpd9CSr/hYy/EOsyKiyy6Ydlr8rzECGvjr6z7iGDYzjoEP20TlIpfWxf4I3gopcYCdRXlpS9PwQzbrkrDWPVnnn/V4L5oRYrRCMtJ6kk5fIwhrc/Xzw0F11JPH/QZg46vgwR05A7aYdyva0Y6utGFW6439/qJuNQQVy3hm4rEE31+/qTa/GQDdGwCClc62wB4Wxsl9fQj7hSXMVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2438.eurprd04.prod.outlook.com (2603:10a6:4:33::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Sun, 15 Nov 2020 04:30:48 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.025; Sun, 15 Nov 2020
 04:30:48 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de
Subject: [PATCH v3 1/2] md/cluster: reshape should returns error when remote doing resyncing job
Date:   Sun, 15 Nov 2020 12:30:21 +0800
Message-Id: <1605414622-26025-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1605414622-26025-1-git-send-email-heming.zhao@suse.com>
References: <1605414622-26025-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Sun, 15 Nov 2020 04:30:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 92266f65-b67a-421d-9f01-08d8891f39c8
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2438FD3774126DAC600EB75797E40@DB6PR0401MB2438.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V1EVV3ive9jvwAqipFA/IGZ9SK6JW9i1MkLJPJ3h5fQUH3utp7l1h+2a2XUM7uCX/obtaQRBDv9xGqtQpn1nJ/KsEUniR/YDuzqfkZUeh5vJ3ncMze5U6yasGs/DdmnJJI3+Y13a1mKLPDtQshnJ8NA16z5imy7eHeyojhb73zPYIZHYPTyhTMC5AWQFvGWuGLyj0BsiQOTNX2/1Hjve3AT/4RS+4SsBfAt5D+fpslZuwBU+g+JcUa0PIo1s9L3iKd0R5ssd7DtDEm2fZdqzwRg9h1SThLuJYetgw7cNBst7SMz6749FHvOIEjWqiTBV//kll6eibBLL+XCGqZNc5+O++GZLnktfrsJsmFl8lBLUHb3+70vxFl7pfdyb7lDp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(8936002)(83380400001)(8676002)(8886007)(86362001)(2906002)(6666004)(6486002)(6512007)(6506007)(52116002)(66476007)(66946007)(36756003)(316002)(66556008)(956004)(5660300002)(478600001)(186003)(16526019)(4326008)(2616005)(26005)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: hREaM+gXq8nRRYVSBZ1Immkhynu56LLbQ/xGy9xvWhIh2arX+uZNo2DlT6soFDP6W6LBYCmOgE3nMGZPesi1jhtTL8IVPCeA+dzxRFtukwsGfbPPRO+erkfbCIZGpFnpO5WfyotpzBKijIcbB6QrRLawU6vMdtiLDjTiMyCs2luC4pYtjQLdkKBnK+8s8uHCDBufFVA6Hf9IY8OTii9t3qwuTxML2r0iJDFK6ylvQ31fWjAjyrivl0hQ6HAaDTAPKyj2K6o08Zgi69WqXK1X49NoMylQH8eLy5fKCAym65a6z/WSbSvB4hQ2HUc1dPHFxicTPiNK19AHtiFs2BDl12ZFoZui83VSITT3k+LxUjFPXQyHkuBWbET/BMifncXE85M5LZfeTESQLfwW1zpsKu8MNFHMs+aKv/wkH6F4TGVr6PjW4WPBjafkBH57i04KCaqiZMUC1Hk3Nvic/Uj0JJn6QE5Zo/Tz2LDzL20anxZi7EnN68f2mEiX9tmy1Lkstve9+TFGtHq27hJx1q2oht4wpjXhiW9cNJzXNTs2ypPFyKLLS+8gUCIjci/uMR5QlYIqgEwg7um75kWuIHcuLpHj4raKtwKbqj7pcpIyypaFRotzq8Bt9EZHejnDJZp8a1EenfIbwbfXTMt27NfvWw==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92266f65-b67a-421d-9f01-08d8891f39c8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2020 04:30:48.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZembP+aKdbJWhoBPpYKDK8EcgKyjr9lflEYCt/v23FKIgHwCIEnr++71jct3yfAwiIWxc47UUOWp+t5qve2OpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2438
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Test script (reproducible steps):
```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
mdadm --zero-superblock /dev/sd{g,h,i}
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

echo "mdadm create array"
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
echo "set up array on node2"
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
 #mdadm --wait /dev/md0
mdadm --grow --raid-devices=2 /dev/md0
```

node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB, and
the disk size is more large the issue is more likely to trigger. (more
resync time, more easily trigger issues)

There is a workaround:
when adding the --wait before second --grow, the issue 1 will disappear.

Rootcause:

In cluster env, every node can start resync job even if the resync cmd
doesn't execute on it.
e.g.
There are two node A & B. User executes "mdadm --grow" on A, sometime B
will start resync job not A.

Current update_raid_disks() only check local recovery status, it's
incomplete.

How to fix:

The simple & clear solution is block the reshape action in initiator
side. When node is executing "--grow" and detecting there is ongoing
resyncing, it should immediately return & report error to user space.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 98bac4f304ae..74280e353b8f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7278,6 +7278,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
 		return -EINVAL;
 	if (mddev->sync_thread ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+		test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
 	    mddev->reshape_position != MaxSector)
 		return -EBUSY;
 
@@ -9662,8 +9663,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 		}
 	}
 
-	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
-		update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
+		ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
+		if (ret)
+			pr_warn("md: updating array disks failed. %d\n", ret);
+	}
 
 	/*
 	 * Since mddev->delta_disks has already updated in update_raid_disks,
-- 
2.27.0


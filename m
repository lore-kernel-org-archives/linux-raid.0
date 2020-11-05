Return-Path: <SRS0=7RKO=EL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDA8C00A89
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 13:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D8D4206B5
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 13:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="CJSyFX0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgKENL5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Nov 2020 08:11:57 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:47110 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726777AbgKENL5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Nov 2020 08:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604581912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=3mUePIAjyQbcNf+v+ZX3q0f2rdmY+BkFlr+nrPkUTiU=;
        b=CJSyFX0AtF4gcui6YKPhY9RgKzVvs+OchZ6flBVzm4u4DTBCquNoZkd5E0NYrZjuKmNmg4
        fiSUoigCGcZd2jVapet5cJL5M311PzgU6qY6pOoK/u2sinCJ4d92aLCSR2vtj4toq5i1a3
        xhVRCDYrCXLCUkB1IXLnk/bl3N1lUn0=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-Kg0AAnd3PPOnAikEU01gVg-1; Thu, 05 Nov 2020 14:11:51 +0100
X-MC-Unique: Kg0AAnd3PPOnAikEU01gVg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d2y/2TCmx4fElQ1kQdT6Mc6xTgEO9CxH/3Yq6gGPTNiPil2t3PDpLPWjwz/g+XfTrEgERnPJ+kk4bvhHuNeGmo0aKmB+2xjI2qeDP6n4LyHBiSJvXxrSwdgENlZ/jzwkB/O2s4aJT1Li09ieKDtlw2C9PdM5J8L/ZC5T0a+yGyS5goNdObgjrUySGvu1NjrL9Vewfk4ejCd3RqiEhzEB1UiNvLmu+ckgFY/hN4DZJwBcdgxKFCJF+/9JFRc0D1V+jfW4zZu8yttXdSsU/eTBusA8TNy805OsMhHDY3NHGRsI9sgGC7Jnude5a/eBn8aQGuofkmhP1gpWRckAFe/nSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mUePIAjyQbcNf+v+ZX3q0f2rdmY+BkFlr+nrPkUTiU=;
 b=c6SMvNo+Mvk+kK4Lm7tJ19YLaArRqwGOvmbaL2gxMNk31ez+aLfLC+nW5dHBxyVc7XkUKDYesvuweRjG7ToGIuOmUEbVWphLVQ5s8raPApzmyNySQbgG4wYA+hVhvbQk/KBwmUPSobVCAGKplBNIiEm4R4suqJacR+b6ZfqFXolZdl+r2fAJBwNhhOy7RLyDLWjruCDHWh6fN6U1dPwC+826Tiz6HrZjfZyThqCMzc9SKacTqWIGpuKsHkYXZLZD5UHa39XIr5RSWIiZsODg3Hih4x6X7NlbeYdclyKIeYlZuozavEdfqxLiL28BTrZNsnBRzzxaNR/kGPl28xFXxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4891.eurprd04.prod.outlook.com (2603:10a6:10:21::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Thu, 5 Nov 2020 13:11:50 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 13:11:50 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH 1/2] md/cluster: reshape should returns error when remote doing resyncing job
Date:   Thu,  5 Nov 2020 21:11:27 +0800
Message-Id: <1604581888-27659-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.130.173]
X-ClientProxiedBy: HK2PR02CA0202.apcprd02.prod.outlook.com
 (2603:1096:201:20::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.173) by HK2PR02CA0202.apcprd02.prod.outlook.com (2603:1096:201:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 13:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58f263e2-970c-4a12-426e-08d8818c5b21
X-MS-TrafficTypeDiagnostic: DB7PR04MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4891FEBBF2F7B71DCCBF833D97EE0@DB7PR04MB4891.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLGVQwd+JfUPyOMuPuQTNGRzOum9Lh4myTM+z+afYQ1mPyNXPNKK0JBKKRMJpRi8z4Hdk0VNmnDjLgYzxhUKH2QDXN02ZPGgeFf/IoRl7dRg/1a6Y7OXWF//NnCHbVqODi8AXrz2jUrQdQukILpJJQZQ5ShdvECyIvFODMyHdSFwaLquCI95iNiySxscL4GJ4RtpKekIf4FUdN7KHz55IVA29aRBLK5td8vw3EyQGt9Q6uGwHPKlqxDeSFe5mLxpC06SWLQ4iq1MO7+tqqkjY3IuRywPGE3Z7SOIYFff1GofPvGCiTH5qQzhvWomYx5y1Xvb61qrjk+rqQ0yHtM6cFj81Gmp2IPkSoMvCBsB3ELRlJfcs1968FlP76RtfvPg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(376002)(396003)(66556008)(83380400001)(316002)(4326008)(86362001)(956004)(2616005)(66946007)(8936002)(8676002)(66476007)(8886007)(36756003)(6666004)(6512007)(52116002)(5660300002)(26005)(16526019)(478600001)(6506007)(6486002)(186003)(2906002)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OWOy7waSAak4cuegHLd1V7DZdpnQFE2Eqv8NQoFEY0YS0YXn3xE0dsbo5IqF0PDei164IpBq8HKNG4SOD6KcTKpYXTFTMb5Qx/qolrndaoImEfwXmAxBiB/62jqOTQlETW8omrIFAGRxGN9axAQOVJ01d+SZH2wSffKRgDWO+B4uIvbvHSb4mWhx06xv6qNFR7iSgSWuL9pcclyva+iWtcIKv4KKvUTC/lbkKM/DN8d3bqcBw6w1oj/FEQGRT8LtVILUVgRV19KTRqH1A14e27B4knvIwvK3ek5D7h/wZJ1KoH2HgE0SZAp6LFgtXpP8gRgICF7TI/rj15MX3Qmfzj7jO7i/dHneGOULCzfxAiDDqrkQ5yGrcaWIpnFXOGE7WKM9sIKjlqx4Ptx3437qJEiT5D8uF4sOz9Cps6V0FJmVQ2qUqzqv2vF+K2NQgPCuNZLGdZLwqid5FNZtmbuaWCie/X9jzmVhW4X6MyV3Gjl2DQBOTAcS+te5rJ5Plq+BDRP/9QTZbVW1MMcEyqwzai7k5hdh/zLhyz4Z4gpuDY4QGRMevpLQ7XiKCVqQfOcIfyFhCWFZjzmfn02V7nkbAs/RAgQ02HNMMP84fFM0ugThzAr6Kun+2Tjn8XHDKpurRt5MxlRONCSBQOe2Huh7EA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58f263e2-970c-4a12-426e-08d8818c5b21
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 13:11:50.1233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBqoEvLW+GTvvvj9UXin4LmI6V8hp/ZE6rWhsJRU+mmiMw+nZ6vlSNyspRn2zq645pwKwhvPDnMhNuhhIBVjQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4891
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

sdg/sdh/sdi are 1GB iscsi luns. The shared disks size is more large the
issue is more likely to trigger.

There is a workaround: when adding the --wait before second --grow,
this bug will disappear.

There are some different test results after running script:
(output by: mdadm -D /dev/md0)
<case 1> : normal test result.
```
    Number   Major   Minor   RaidDevice State
       1       8      112        0      active sync   /dev/sdh
       2       8      128        1      active sync   /dev/sdi
```

<case 2> : "--faulty" data still exist on disk metadata area.
```
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8      112        1      active sync   /dev/sdh
       2       8      128        2      active sync   /dev/sdi

       0       8       96        -      faulty   /dev/sdg
```

<case 3> : "--remove" data still exist on disk metadata area.
```
    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1       8      112        1      active sync   /dev/sdh
       2       8      128        2      active sync   /dev/sdi
```

Rootcause:
In md-cluster env, it doesn't promise the reshape action (by --grow)
must take place on current node. Any node in cluster has ability
to start resync action, which may be triggered by other node --grow cmd.
md-cluster just uses resync_lockres to make sure only one node can do
resync job.

The key related code (with my patch) is:
```
     if (mddev->sync_thread ||
         test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
+        test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
         mddev->reshape_position != MaxSector)
         return -EBUSY;
```
Without test_bit MD_RESYNCING_REMOTE, the 'if' area only handle local
recovery/resync event.
In this bug, the resyncing was doing on another node (let us call it
node2). The initiator side (let us call it node1) start "--grow" cmd, it
calls raid1_reshape and return successfully, (please note node1 doesn't
do resync job). But in node2 (which does resync job), for handling
METADATA_UPDATED (sent by node1), the related code flow:
```
process_metadata_update
 md_reload_sb
  check_sb_changes
   update_raid_disks
```
update_raid_disks returns -EBUSY, but check_sb_changes doesn't handle
return value. So the reshape job doesn't be done by node2. At last node2
will use legacy data (e.g. rdev->raid_disks) to update disk metadata.

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


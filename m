Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B02C5517A
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 15:50:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F246620674
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 15:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Pk809j0z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730850AbgKJPuo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 10:50:44 -0500
Received: from de-smtp-delivery-52.mimecast.com ([62.140.7.52]:33344 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730511AbgKJPuo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 10 Nov 2020 10:50:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605023440;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=cXGIZ+FAVOZ/Q4AalDqh5HPUVkqUeC/bBaU+MYbIvw8=;
        b=Pk809j0z+AQw2ehX1tMYeTUEf5CM+E9nPk3VXJ15fmW9AfG/8dpQ/Uy3HBbGncxzGAbNOl
        OzKIUQSuvwpLWZr+7ETeiFq27hr10/zbDzX9iSMTSoqPVB6/NrYFHrCCSPniUTEka8eWVJ
        JmAog+4hehpm3Tdc6yL57w8LTwmMUkw=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2057.outbound.protection.outlook.com [104.47.0.57]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-24-PJoG9EhfOnS_2z5SWQY-Lg-1; Tue, 10 Nov 2020 16:50:39 +0100
X-MC-Unique: PJoG9EhfOnS_2z5SWQY-Lg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nC/ocBO3S/84mAtM7la4Po8k4U+km2tfyZwP1CA4aN7gvhM3Odzbx0ezTkCIrylM+5DBMPAUpJBlNptuN0YtKlIn2VQCKD4erSxlYjv5XJq40JUIYPXvFG2EcrK1wNnBLPOGN4jlMW43NP9//zvfqhEY21al7/74D1Fvn8TXtNt8BLQX/DfWIyZNSIaorfJkklD5E4RsbIfF0Qkz67iK6pBG1Vwj6hEyiOD8QIP2tILFwHAr0gX/nD5asfGS5CFZzWzCRciW89g/PCWSQQbRhdteE7c/QGz4/Zed84Eo2bPA5JZFWIl19P4OiBEVqLKjzDLTIVMpSW1K9wk+Pa9oLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cXGIZ+FAVOZ/Q4AalDqh5HPUVkqUeC/bBaU+MYbIvw8=;
 b=bmFSDWj2fDKHRERrfjoaEBH8pSt9q1lj7aIg8pmiXSrjPmoVZJDqlUgeaRH2vRI6JVsoq2J5hVtvIYCpZwZt4IDHaYADO0slE0dQm4wL8PonSkGwfJzcLo9AgvUToC1ISoTPb76w6KgSZWMdHnCQopwTwsM0Ho0GKpZpfORRHNZa4/I2SpbbVuUbDCeKtm5b4y2IhOS2kwmJxXfR9aQeZ+RJ6dhaygxx6+cqbDDuvLgrcYLcPO2Go5X2cYO1Q3GF9DJC/2a4OqKf97KsEDC0cVDxo2BKXxYYimgewWQ9MtMfkhD8qR0EHo5/bKjDPe/UDyzgyIpxI2RbNVGsiogkeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6649.eurprd04.prod.outlook.com (2603:10a6:10:104::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.22; Tue, 10 Nov 2020 15:50:36 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Tue, 10 Nov 2020
 15:50:36 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH v2] md/cluster: block reshape requests with resync job initiated from remote node
Date:   Tue, 10 Nov 2020 23:50:09 +0800
Message-Id: <1605023409-1994-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR02CA0221.apcprd02.prod.outlook.com
 (2603:1096:201:20::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR02CA0221.apcprd02.prod.outlook.com (2603:1096:201:20::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Tue, 10 Nov 2020 15:50:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2603a37d-5f61-48a1-7d99-08d885905d1f
X-MS-TrafficTypeDiagnostic: DB8PR04MB6649:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB66495FCC41BF4F40AE7AAFC597E90@DB8PR04MB6649.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B/BE3pxVL49pScaFjke1NjGE9DfoKdDQxVP3QVX7n255MsuB0bP93Sy6zSb2kCxUHShH1GPBMy5MyCFWxvoxbwvqhZ51XY6f7S65CNursvXF7ZD+nLFjtP7VyvddJETyjWJyi0d7q58PnZv9HvT37rbrTrQhIG861BZWWolnQ6TBLyr89kUsomT3SciaT8etefPpBwXY5mwoJxVdwdaUAkQoSUgikdDIM8TsDX6DmGb4dnrP6HUTwYXcApO0Mu8XOzR6iLFzw93XDAJqftw+0JfhDvElcekzkbQ4QU/MfhKtYtz94nI3Yx4vJ06aD+2KAzlMdAru7soLdnV0sUFUoVHblC7JFFCqfWBfuZdT9Pu4kaDFp17ECHPjjzzZACeN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(39840400004)(396003)(136003)(5660300002)(36756003)(52116002)(86362001)(83380400001)(66556008)(66946007)(6512007)(2616005)(66476007)(478600001)(16526019)(6666004)(956004)(316002)(4326008)(186003)(2906002)(26005)(8886007)(8936002)(8676002)(6506007)(6486002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: BrwgKZRxQo5zFewWrpWB5HS3rm8e7IwFduABss6Aep+nM75NjhY8YakSVsfxKGisUqTtEnP9eArJUUsnvQawl4Xgd6EAFETBst+gXY3+r47vRcKXhfV6e4pm0YjPpLpogPP6KRprK459qNHlLHc7gOaqGi4/YgUbhuQEHPOPo8fbXUW59iMQdlMJLEuEJHwKkXTTQnlMSUo3NAiX9V6ZtstiBB2qt/m1SsXaY/18ayaoO6YJsbdgJ19K27zhUJork7N/yOmoEjupGs+iZQOhrf0bh4VEnU/NOFCBNkgcM9UvOqTXj9dBeXAo9MA2pgtz4DyTd0DxrmGWpuJSSpEjaMzokC4JouoZEqGP1qXzTN6CUsm4+U3jaZVfM8baBvysf8RDtd2AM7IBp/lbBubDs0hugVEXG4tXTPLDudG+nJXjf4yd33XzubgfX7vZOYowP8+R6ngusET5QyYYPbKevJ90SfeozjWpovsU6dg0hItApHowl5pceMjO3dj6gFoRsd+TS8tjZn4dffJjkl07fPLBftt1yUXohdZCnf2EKia6QmYh6jliFG/Y0t6lac1O+EF/mq4VETnjU5awi7UG5WgshDpwft+pREmjVMfiigQK3F56PdDFRwhEDtD5fWbC7TvWgwk4Wwctb1jJIvDpUA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2603a37d-5f61-48a1-7d99-08d885905d1f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2020 15:50:36.0013
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vxKKfiWVEWsLHfDYdAwdIhhF3382Ws8EY9goHg98Or6gKU8E9PlmBPcsiTp/Hqfcmt/HOuNI9ESx66OQyytV8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6649
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

In cluster env, a node can start resync job when the resync cmd was
executed on a different node. Reshape requests should be blocked for
resync job initiated by any node. Current code only checks local resync
condition to block reshape requests. This results in a chaos result when
resync was doing on different node. 

Fix this by adding the extra check MD_RESYNCING_REMOTE.


*** Repro steps ***

Test env

node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB. The
disk size is more large the issue is more likely to trigger. 
(more resync time, more easily trigger issue)

Test script

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

There is a workaround:
when adding the --wait before second --grow, the issue will disappear.

Test results

Every cmd line in test script can be finish, but array status is wrong.
There are 3 results.  (part of output by: mdadm -D /dev/md0)

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

*** Analysis ***

code flow of the problem scenario

```
  node A                           node B
------------------------------   ---------------
mdadm --grow -n 3 md0
 + raid1_reshape
    mddev->raid_disks: 2=>3
                                 start resync job, it will block A resync job
                                 mddev->raid_disks: 2=>3

mdadm md0 --fail sdg
 + update disk: array sb & bitmap sb
 + send METADATA_UPDATE
 (resync job blocking)
                                 (B continue doing "--grow -n 3" resync job)
                                 recv METADATA_UPDATE
                                  + read disk metadata
                                  + raid1_error
                                  + set MD_RECOVERY_INTR to break resync
                                 ... ...
                                 md_check_recovery
                                  + remove_and_add_spares return 1
                                  + set MD_RECOVERY_RECOVER, later restart resync

mdadm md0 --remove sdg
 + md_cluster_ops->remove_disk
 |  + send REMOVE
 + md_kick_rdev_from_array
 + update disk: array sb & bitmap sb
 (resync job blocking)
                                 (B continue doing "--grow -n 3" resync job)
                                 recv REMOVE
                                  + process_remove_disk doesn't set mddev->sb_flags, 
                                     so it doesn't update disk sb & bitmap sb.
                                 ......
                                 md_check_recovery
                                  + md_kick_rdev_from_array 

mdadm --grow -n 2 md0
 + raid1_reshape
 |  mddev->raid_disks: 3=>2
 + send METADATA_UPDATED

                                 (B continue doing "--grow -n 3" resync job)
                                 recv METADATA_UPDATE
                                  + check_sb_changes
                                     update_raid_disks return -EBUSY
                                     update failed for mddev->raid_disks: 3=>2


                                (B never successfully update mddev->raid_disks: 3=>2)
                                when B finish "--grow -n 3" resync job
                                 + use mddev->raid_disks:3 to update array sb & bitmap sb
                                 + send METADATA_UPDATED

recv METADATA_UPDATED
 + read wrong raid_disks to update
   kernel data.
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v2:
- for clearly, split patch-v1 into two single patch to review.
- revise patch subject & comments. 
- add test result in comments.

v1:
- add cover-letter
- add more descriptions in commit log

v0:
- create 2 patches, patch 1/2 is this patch.

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


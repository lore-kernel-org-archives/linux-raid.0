Return-Path: <SRS0=e7iu=EO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB8BBC4741F
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 14:53:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73263206F9
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 14:53:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DeD6Irnx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728016AbgKHOxl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Nov 2020 09:53:41 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:50181 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727570AbgKHOxk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Nov 2020 09:53:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604847217;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gHwvhF49EwwNLyLBYrDg3AOcECPfzagrki9kaTT6wr4=;
        b=DeD6IrnxnoWwtB8+SdeetbEfiIYHeKL7VmiDM9ThmWv4cFGaL3+gmqCj/GVP/Ss3Q6OGi+
        dYg4Ga0ogdh2PN3mikmpNl5FPh8Hiv9D6I2KbqhucFwQ1S95iRJDXpLmdPxmJHOImcmNM5
        OA22HmjrFtQ9sDL2MgB8KGx1ZDmbEyo=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-B-1blYS6Oqq5CvUm0118qg-1; Sun, 08 Nov 2020 15:53:35 +0100
X-MC-Unique: B-1blYS6Oqq5CvUm0118qg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E0o6apSL4LTBRg4AUq+u6u4UbbojICrZuDj6gUKLUX5V/Qzulj2V56eNHhBamOx6eXlRt30PAJQCn8QTSpmGccqniZuoJWGkSjDAr888gIuzaAK5czAnyynEMUS9T9YPRKcXGakC6UtNMqMlOoiY3QRLDDdfo7FhrtiRbGKjUvA+mt7zz1dQz3YK8fo1rnXXWDqXv1ZGOqUxoa9jJ9qXPiC1tesF9d+21w/Okk+cmsT4IdBbcKBy0/3EMOtXOkhCSAj84jOKwhI8/TVXemJTfizJDHR5N8Y2k08oPkDxAjL+L7qSjcYfwy3/9ZChYF8wmC9kYKgEOGg0cIQm11h2KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gHwvhF49EwwNLyLBYrDg3AOcECPfzagrki9kaTT6wr4=;
 b=TKy/aQ+mvFRVsCyYYqFlegS6bZnm/oKtHdotSNaZeUsCrZrX5YJ7X371iAJfeMQFhIiuPnUjerYuQ79iAl9X63tskuLlFnWOwTipeSGA0mB2qOMj45t3eJK+MdJ+jccdcIUNlxIyWIOaH41Xz/15lfrYV76Uku/3bwukWiinytzqCgOPePeZUhXTJL4+mtAK03e+4P1BZ/63cTIzs1xmtuzLgjNEdGqWSwe0DdqbcXAVPIPUfgjDBVvMLnqv5/ydGvrZ7IAFNw2PNL5CELoFe7gb1cyMgGWIAuipJADTijEJWeM/D68vSeUVw221Eh0bBpMQY33ZHhdu19UngNg7yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5115.eurprd04.prod.outlook.com (2603:10a6:10:15::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Sun, 8 Nov 2020 14:53:34 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.021; Sun, 8 Nov 2020
 14:53:34 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH 1/2] md/cluster: reshape should returns error when remote doing resyncing job
Date:   Sun,  8 Nov 2020 22:53:00 +0800
Message-Id: <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HKAPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:203:c9::6) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Sun, 8 Nov 2020 14:53:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bde116a5-9b1f-489f-1ac9-08d883f610f7
X-MS-TrafficTypeDiagnostic: DB7PR04MB5115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5115E02E2552CD58574883E997EB0@DB7PR04MB5115.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+aerwupustZ9EZxWCSK6KEkKEjCiafV05stmcmy0BKA4zr2hINscS0P7bjLDVM4wAoWQsv2vKo6SmaUCKdFW8/Epp6u1TkT+EI9o3XfU650LLjazYVY2wYNl7d9zCIPkN1at62CDcq7WturUUlOO0P53l9lgQ9ZcogO6vgRed9MbdBvzFMBt/a2d7OIOZX9iVI/+NHYcv6VEOx4nCmenOn8vPHN0xMf8DvjhjDD47DIdz0eUqMI8ZZlxfdnwZuAA4hBOypZ/n3xMfXBbtV8gssr5cccuicJg/DYmTBFxXDyggeiV1aiSnf1mgT6J20lq8JUqx52KANio8G3Tfjy5AeVIPXYnnbOhAbOaQ3Bm+ywO9NowxxA/syg1S4YNKOv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(8936002)(52116002)(316002)(6666004)(956004)(8886007)(2616005)(478600001)(86362001)(66556008)(66476007)(66946007)(4326008)(6506007)(6486002)(8676002)(6512007)(16526019)(186003)(36756003)(5660300002)(26005)(2906002)(83380400001)(9126005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NxJ762Xg9n6+sKxuNXmjr+RQr7Mx9CK3BiR0LePlRNXDCJ/OofXgJetJVjMUn8plGscPqJnqT1IQNWDE2oBrIhNFLmie3ytjVb6G57uDhFASF2fwVPTRo7JJHltVj+VL886Zw1P/heH/tj5pVkRVGGdS2bTUI6UWv/7NpimDsw2+ZCtnaAL0H5U5t64oS4AqN8qgyu6pa+CfuqYFjTJ//9vI1OWSvTohZAD0Hq1HFT41Gr0FJzKf8hsjFydRSwX+ue2YwgzRAHnH7ViPlGtM63jI0cwAR42/F4K/Vldr1yNQgzCDIq3TBDQmpuD2wAeMMdCZmZ8aE9lzhb3OujDibGd3jgfqGdi5NiKu2CGXVTSVUhA+Omco0Mrsn+rAs35NJ7xigdeAxQj4Xv3sD3laQFIc0wLtTQG3jW77iUxxnIz+6FaKje4moOm8JWcofbiWKXQCT74O36yQosak3QAavhhs+YqO+BI15Y3qQmrwzGHfCLAVdCHEEX4X14qBlPjAev7ChfJpIV4I+j8kqlV/V84hfcNtdowgAAGM/CI2wRlgRGpxKzdypRzEgGI1dxgc7xRt5Zp/Fps9E4e0Rv9R267rZj497+OEizWyhvD7q2s6kABKrSVT26fRHMORIRkwwL7WY97XLcr0oUhiL7BFTg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde116a5-9b1f-489f-1ac9-08d883f610f7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2020 14:53:34.5786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V5ixSEqVWchxKjdCtR3H3NlluCYZWMjaE8hTg7HEmALA70ubFwKnXZmo6k9Z5BCd5WLAnmR04yBmYRREo43qyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5115
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


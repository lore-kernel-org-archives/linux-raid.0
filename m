Return-Path: <SRS0=e7iu=EO=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6C6C388F9
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 14:53:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91903206F4
	for <linux-raid@archiver.kernel.org>; Sun,  8 Nov 2020 14:53:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="meOoh2at"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgKHOxp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 8 Nov 2020 09:53:45 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:55903 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbgKHOxo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 8 Nov 2020 09:53:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604847220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=udwXjUGr6oNqMVaGdrZ57OH4AEzDrfPRwfbWo0lfAiw=;
        b=meOoh2atzaGJQyC0rEE1nS4ut/K08OHFN9pr/f5QSXlAwjo6ykHjvtS7Q8GhDwYUu7VagN
        Rij4W1iNNLlNkj22lLvYi87/dt148o4Wj3KODIp5USSknpuf6inv64R15TBpFQf84ylpKE
        m6dEb7xEmbj6MGb3LoP56Isuy/cPRig=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-27-irw0NQe9P1igdO0cpSpimQ-1; Sun, 08 Nov 2020 15:53:39 +0100
X-MC-Unique: irw0NQe9P1igdO0cpSpimQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RCPVW65doxgh/1SbuiAQlwUIY9j/ndtWUiiIi5OfI9RI+BVYk5hpwj24qK3IEs6/HRQxaHaD2CRr8UcixepRuMJeYa9DDByTtX2U4N5Du5w3oYPIFxZqlSHPxUfpM6VzAavzYUK16wkVmmrU9Vx2WihiMD9ku5hS2k7N2aiXAuzUK8IHl8lr+u5KKx/61exdSvIbVqMbV/Vq1oN1Q9l3CbF6CERrjsIgtwlOXKB+JwJlkV38ZgtJByayATqD8yt01afou0JGGCOUXzeEE7IKUghjAxaV65jHJarBkARxauZqNM4xZnXpOaI50hzG/v29xp2ubn0Ty/ioxx7MfQNwEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=udwXjUGr6oNqMVaGdrZ57OH4AEzDrfPRwfbWo0lfAiw=;
 b=YPQFhhCUe5DTmpLjP6wyUxu1s8CTGtAzyksl874VBhIQramjPDgfoOC2npfN9JrUHwEG6BUiwSSyrjSfEZhX4R4kjMasZYEpL70k9XCAmCSYRmMBVOV3TwJzti4d51hkDaf6I0MupI6mVojTAO296n7SWZuRwsK3x4rsSjX0m/M8UmSCzWIs8V0Fj6CLij+ycP6QEid7rg4l/HE+l1h7q7jJCsPtUR7W/cK1yIccjig7sTCOxF/i+JiLYcbRCDn1R4HAaR6o+uu34TEXYm+Z6d06wrOgPeQQC0tSDSUeiM1w1K1YD/H5uljk0dTS3EUqqyHpMqWl2qhFjVn7plZO9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5115.eurprd04.prod.outlook.com (2603:10a6:10:15::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Sun, 8 Nov 2020 14:53:37 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.021; Sun, 8 Nov 2020
 14:53:37 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
Date:   Sun,  8 Nov 2020 22:53:01 +0800
Message-Id: <1604847181-22086-3-git-send-email-heming.zhao@suse.com>
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
Received: from c73.home (123.123.132.155) by HKAPR03CA0019.apcprd03.prod.outlook.com (2603:1096:203:c9::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.13 via Frontend Transport; Sun, 8 Nov 2020 14:53:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cabc8a33-c50a-4416-3a83-08d883f6130e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB5115D7512B727508538F101997EB0@DB7PR04MB5115.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VZZswlNVa4JgeIhGk/PTfx91BChBVjFrGRb64i+/DWiX5c5M9M2pQlS8bqS17+92T+tI/a99wi7tUt1Fh6xKnBs7Cs05lxi4Bgs+rssycafSmrSj7m5SM1CnV1e82bw/+PLHszpmRtEUZoq24LFsIjQGPHzA9K6hwHLaCasTcvE+g6r3pSA2hADRxd67Tm30rUXZ8P71+FY+yMworl3jZIIwVChv9Sf0nmhjWopixuSj0ehYdshUYSGpl+ioG7zQPHy7BAo7ssGE6UZDI3MiyUl/4yUtPH7rdugKW93ggNbAOL8TRaJ+UHUJrN4eMCgRz7fZCeog3FyRMDOA5b+rWENPofa+gcG+JWpEvOTWZG2+JD6OjFO1j/y0P1u3LygV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(8936002)(52116002)(316002)(6666004)(956004)(8886007)(2616005)(478600001)(86362001)(66556008)(66476007)(66946007)(4326008)(6506007)(6486002)(8676002)(6512007)(16526019)(186003)(36756003)(5660300002)(26005)(2906002)(83380400001)(9126005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: yz95jFV43YJZc0Q/bGaU7Ve08yfB8hYHea9McK6jMOK1rOG9BbiXxeQjYGSR5Yixmvz95kkVTIsSlB6XTY2z30ipsqjStNnHe7OL9ZV9YqYkyS/xvMJ9+Uj6T3a+gmSFa9sU0GVMF6oMSz+/+2C71wymirjB/AyaeTqUa3CyN3a2qrOCh6RBya1cdPk5z9BWdFbj3qXfs5Ftr+HpGXXtK013ewLRl4GALIRMf2QpUUxEDRB95lUtMBryVjy8rfpQnEdsqLTtGraW4V+oW4BaWBftwMosVuQukKfahdfgyfATrl+7qjv5dhJ0Xcm5ca+fxK6edrlQ/bAiBKWq14R4q1qBkGAQ4EBVobnQhOO4El7ONSWswBxDb1kCR12FGq8cCCNJd6TCbJC4cOSM8O9eAXCE/5/rn/SLIWi+ILO0jqI2CQoLjFIFNbL3KMUfIVIcEFunFFybp+E3uL/2WSlKCrjMSiPOgNAXbeZdcpZZgjTOkiA4/rkf7vwlQjzdqQbNmjbxairvV5KBxGS8vkhsSK+dKHVZ85DdJErfUEVlfpX6Hbuofllif0GuP9U5IPtG6eAkET9NSjVFBPfZv5iwqz0mQgRy5A2wSj965pI8uLLiGc7iCc79a0FIsQwAS4WiwfGbpYS0/R02K7LVptPmiQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cabc8a33-c50a-4416-3a83-08d883f6130e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2020 14:53:37.8767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zdlrDzSn6Pvl30hNl+duwC0/7Aal52B2KF2anyS9Z9nntC46TP+8rsWtGAd+qdPoGKcgN1adU/rTL/AK8MAN1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5115
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is a similar deadlock in commit 0ba959774e93
("md-cluster: use sync way to handle METADATA_UPDATED msg")

This issue is very like 0ba959774e93, except <c>.
0ba959774e93 step c is "update sb", this issue is "mdadm --remove"

```
nodeA                       nodeB
--------------------     --------------------
a.
send METADATA_UPDATED
held token_lockres:EX
                         b.
                         md_do_sync
                          resync_info_update
                            send RESYNCING
                             + set MD_CLUSTER_SEND_LOCK
                             + wait for holding token_lockres:EX

                         c.
                         mdadm /dev/md0 --remove /dev/sdg
                          + held reconfig_mutex
                          + send REMOVE
                             + wait_event(MD_CLUSTER_SEND_LOCK)

                         d.
                         recv_daemon //METADATA_UPDATED from A
                          process_metadata_update
                           + (mddev_trylock(mddev) ||
                              MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD)
                             //this time, both return false forever.
```

Explaination:

a>
A send METADATA_UPDATED
this will block all other nodes to send msg in cluster.

b>
B does sync jobs, so it will send RESYNCING at intervals.
this will be block for holding token_lockres:EX lock.
```
md_do_sync
 raid1_sync_request
  resync_info_update
   sendmsg //with mddev_locked: false
    lock_comm
     + wait_event(cinfo->wait,
     |    !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
     + lock_token //for step<a>, block holding EX lock
        + dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX); // blocking
```
c>
B do "--remove" action and will send REMOVE.
this will be blocked by step <b>: MD_CLUSTER_SEND_LOCK is 1.
```
md_ioctl
+ mddev_lock(mddev) //holding reconfig_mutex, it influnces <d>
+ hot_remove_disk
   remove_disk
    sendmsg
     lock_comm
       wait_event(cinfo->wait,
         !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));//blocking
```
d>
B recv METADATA_UPDATED msg which send from A in step <a>.
this will be blocked by step <c>: holding mddev lock, it makes
wait_event can't hold mddev lock. (btw,
MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD keep ZERO in this scenario.)
```
process_metadata_update
  wait_event(mddev->thread->wqueue,
        (got_lock = mddev_trylock(mddev)) ||
        test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
```

How to fix:

There are two sides to fix (or break the dead loop):
1. on sending msg side, modify lock_comm, change it to return
   success/failed.
   This will make mdadm cmd return error when lock_comm is timeout.
2. on receiving msg side, process_metadata_update need to add error
   handling.
   currently, other msg types won't trigger error or error doesn't need
   to return sender. So only process_metadata_update need to modify.

Ether of 1 & 2 can fix the hunging issue, but I prefer fix on both side.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-cluster.c | 42 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f6..d59a033e7589 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -523,19 +523,24 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 }
 
 
-static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
+static int process_metadata_update(struct mddev *mddev, struct cluster_msg *msg)
 {
-	int got_lock = 0;
+	int got_lock = 0, rv;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
-	wait_event(mddev->thread->wqueue,
-		   (got_lock = mddev_trylock(mddev)) ||
-		    test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));
-	md_reload_sb(mddev, mddev->good_device_nr);
-	if (got_lock)
-		mddev_unlock(mddev);
+	rv = wait_event_timeout(mddev->thread->wqueue,
+			   (got_lock = mddev_trylock(mddev)) ||
+			   test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state),
+			   msecs_to_jiffies(5000));
+	if (rv) {
+		md_reload_sb(mddev, mddev->good_device_nr);
+		if (got_lock)
+			mddev_unlock(mddev);
+		return 0;
+	}
+	return -1;
 }
 
 static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
@@ -578,7 +583,7 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		return -1;
 	switch (le32_to_cpu(msg->type)) {
 	case METADATA_UPDATED:
-		process_metadata_update(mddev, msg);
+		ret = process_metadata_update(mddev, msg);
 		break;
 	case CHANGE_CAPACITY:
 		set_capacity(mddev->gendisk, mddev->array_sectors);
@@ -701,10 +706,15 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
  */
 static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
 {
-	wait_event(cinfo->wait,
-		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
+	int rv;
 
-	return lock_token(cinfo, mddev_locked);
+	rv = wait_event_timeout(cinfo->wait,
+			   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state),
+			   msecs_to_jiffies(5000));
+	if (rv)
+		return lock_token(cinfo, mddev_locked);
+	else
+		return -1;
 }
 
 static void unlock_comm(struct md_cluster_info *cinfo)
@@ -784,9 +794,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
 {
 	int ret;
 
-	lock_comm(cinfo, mddev_locked);
-	ret = __sendmsg(cinfo, cmsg);
-	unlock_comm(cinfo);
+	ret = lock_comm(cinfo, mddev_locked);
+	if (!ret) {
+		ret = __sendmsg(cinfo, cmsg);
+		unlock_comm(cinfo);
+	}
 	return ret;
 }
 
-- 
2.27.0


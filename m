Return-Path: <SRS0=7RKO=EL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D722C00A89
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 13:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8E220756
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 13:12:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="k9oiQ64e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730445AbgKENMK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Nov 2020 08:12:10 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:58063 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbgKENMK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 5 Nov 2020 08:12:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604581925;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fKwCaZ2ebWd7rPYxZ8L1Es8WIk7wSMgbbm0LMv1c20k=;
        b=k9oiQ64eK/pKqSxEHw3hl7ZXhwJ8MKFBghSbYPc0wYFn25TCbLQ9v7rgUkA3o1eebExtOR
        eaCYXXzUlef1YkEXQyLMvUUYnhAeW5e0jn5HlCVf4c+tumIecgMmUtP+P/jzJ+s/CxFgZS
        Q0v8EYZ8p6tTvfF+wO+HdXvk1Q/H+Bo=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2108.outbound.protection.outlook.com [104.47.18.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-9-vq4W9AaCMZSHwHAkrZGunQ-1; Thu, 05 Nov 2020 14:12:01 +0100
X-MC-Unique: vq4W9AaCMZSHwHAkrZGunQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Aw4yqs84Fdzoe+KuV4j6Pms6EKbNMhTL8jDeYRumKf2Wvm7f1uV7ziPdJP44dXRms/g5VGaiSl8Dnf0mt2jaYHYFZ8VKeyPNMojP42DdUyltmoSeGDswfG44rXFhFgQrIBbVmyGZ/nHwz4gkW2aiYekrOjOOgZayoXL0yfK/MBhUlLQEJluruDX7BynPBYIxn4/8e4IATn2lededH+iSbCPl7hBnDhm2RSDjLBLX6kqAnodfhfXa15wz0u9f72ZVioEUOt1FFxs1kVrVOSo71RCuLad5NHXZxaqAwUEKHp3aYtp7ZPZrrRwwSuMj5Q41CgldjOKW50jFkA3pbMNvNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fKwCaZ2ebWd7rPYxZ8L1Es8WIk7wSMgbbm0LMv1c20k=;
 b=JqhaLPYiK97AXncpGeuxy5/t6ZZRvkdJmfJTdzD9U02W8Xs0Uuex0wcatsjYIMbBXEXNxsrcEYJCkpBsChue0Hxmb1iSiVUIciIMLpokZ/GdzIM0ihMhGJm2euAQuB9n+L7QCj6oiHjrqxRMt7/JmYhG79vwqqCE1P6VIWIqafi34Sgb0UT2ox/P2IZe3GdR5fbxFSCVfhk8cUWTCiayCXvvEV9rnGC/Z2MrLW6MYBBlm8vFktWAAJ5wyk4wasZ2MEcTCvVHrL7WOiljW5YvuzCN3mo+d2hU2kz1bfxTfwlvG9IHBxLjkvEEAoxl7GO8pVkjPWofv5Jmp+6fVxnRIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4891.eurprd04.prod.outlook.com (2603:10a6:10:21::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3499.18; Thu, 5 Nov 2020 13:12:00 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 13:12:00 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH 2/2] md/cluster: fix deadlock when doing reshape job
Date:   Thu,  5 Nov 2020 21:11:28 +0800
Message-Id: <1604581888-27659-2-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1604581888-27659-1-git-send-email-heming.zhao@suse.com>
References: <1604581888-27659-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain
X-Originating-IP: [123.123.130.173]
X-ClientProxiedBy: HK2PR02CA0202.apcprd02.prod.outlook.com
 (2603:1096:201:20::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.130.173) by HK2PR02CA0202.apcprd02.prod.outlook.com (2603:1096:201:20::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Thu, 5 Nov 2020 13:11:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 977daa75-58b1-4214-6546-08d8818c61af
X-MS-TrafficTypeDiagnostic: DB7PR04MB4891:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB48912FD5BB8992200AC031FE97EE0@DB7PR04MB4891.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FguUeCpuZ/W+POlZXcLF85ke0E2d++H7aqzkFG29hYd1j/SzWHncZ10GDbbQgtiUKsWmyGdXMHvzl+lK9yyMQSTHkFGLhWWTewAYBECEM5iwVB35yw/6MNQYL3Wpbduo85MT/8wWPBDrThRlxXdzoaix+vGWxCKN1yImwLXv7yJw1XP6xue0a6HJgLu4gQfbFxOkPTtXJ6Fqg5/gR+70ftwYDM8uNjND5f3v4FKtyeOR/6nFv/Fnrc8nGprWWEmC7Esp5GLJtDEO7sFSEua+yh8AGlc4jKfZGYujv6geYR3FCntjJ1p3odFFZSyy8zK5oSKXGZ1wR50CGrAa2LY4BTM/hMp37kcOiiPYoyLrGE52tTtNyZdpcp1gTKHQGToR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(136003)(366004)(376002)(396003)(66556008)(83380400001)(316002)(4326008)(86362001)(956004)(2616005)(66946007)(8936002)(8676002)(66476007)(8886007)(36756003)(6666004)(6512007)(52116002)(5660300002)(26005)(16526019)(478600001)(6506007)(6486002)(186003)(2906002)(9126004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x7ZKuTZEbXKzCWP02igNPg5wBXsPyEunjdEqApnQi5xWbSxczCrjEv0L0N6pdEW0chClkvGQGF7iJ15nKqvIUK1rnaCfnjpRSSw6Xhrx6ATdcoufmHVNk2OePUKEMoBKeXM6zqroanC4Ha6f18ryTigQD3a5ODKPStywOKUDsiteIdPRBRhJ2j4jLmUVdpHRMIMuNvQGAcOxkXsJZoixEXcsp+T/A58MdowmSB0NvwYQLLtzwVkJ9J84PeXA2we5wHWXokd+AylV6XnU68xQx11qQgFlqUYDYyI8J3FJ9lXKjjf/QqbbRuiv+JhQt7MLUIbhEi/aKEX5YJNnvKThwoB1Gd02O390SGdG/IqdU6obLu3XbC6Q/d6lBVZsMAI+KJglBc07yyBOqNmhKxsuJv+kCs3w9kPwGlwFhSd0WFB3QziwXwsjnccWOYPpkfbUVEUSrgSFGgvwGVoyT1zwaNMoRhjt+LFfmp6VyjIeDdcxZSEmz9RcfGW0+pCpciy7hI7xLuhFDIbWguucws8prLXdc+j5We8+lyLG/ozj2Vg1IBlVUFVc8hF0SI9go5iz2hjXrJOiK1Sy9cIvAnuHHRmDFQgTeRk1qTIIJ+JPpJMliTotqnxUy21txiyxR4qoAb9r7i0tiJCSAwMDKradTQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 977daa75-58b1-4214-6546-08d8818c61af
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2020 13:12:00.8223
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9oRUyvHCtQ8jiBz4I4o49rdvoUhxAzyJ9iq3huFfXM3UK6YUK+MXcisTzrLBQQ5cowuJ8OSfwEKT11kTWb6TXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4891
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The hunging is very easy to trigger by following script.

Test script (reproducible steps):
```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
mdadm --zero-superblock /dev/sd{g,h,i}
for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
count=20; done

echo "mdadm create array"
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh \
--bitmap-chunk=1M
echo "set up array on node2"
ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"

sleep 5

mkfs.xfs /dev/md0
mdadm --manage --add /dev/md0 /dev/sdi
mdadm --wait /dev/md0
mdadm --grow --raid-devices=3 /dev/md0

mdadm /dev/md0 --fail /dev/sdg
mdadm /dev/md0 --remove /dev/sdg
mdadm --grow --raid-devices=2 /dev/md0
```

sdg/sdh/sdi are 1GB iscsi luns. The disks size is more large the
issue is more likely to trigger.

Hunging info:
```
node1 # ps axj | grep mdadm
1  5423  5227  2231 ?    -1 D   0   0:00 mdadm /dev/md0 --remove /dev/sdg

node1 # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdi[2] sdh[1] sdg[0](F)
      1046528 blocks super 1.2 [2/1] [_U]
      [>....................]  recovery =  0.0% (1/1046528)
finish=354.0min speed=47K/sec
      bitmap: 1/1 pages [4KB], 1024KB chunk

unused devices: <none>

node2 # cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 sdi[2] sdg[0](F) sdh[1]
      1046528 blocks super 1.2 [2/1] [_U]
      bitmap: 1/1 pages [4KB], 1024KB chunk

unused devices: <none>
```

Analysis (timing order):

     node A                          node  B
-----------------------------------------------
                                    <1>
                                    sendmsg: METADATA_UPDATED
                                    - token_lockres:EX
 <2>
 sendmsg: RESYNCING
 - set MD_CLUSTER_SEND_LOCK:1
 - wait for holding token_lockres:EX

 <3.1>
 mdadm /dev/md0 --remove /dev/sdg
 mddev_lock(mddev)
 sendmsg: REMOVE
 - wait for MD_CLUSTER_SEND_LOCK:0

 <3.2>
 recive METADATA_UPDATED from B
 wait for mddev_trylock(mddev) to return 1

Explaination:
1>
node B send METADATA_UPDATED msg.
this will block all other nodes to send msg in cluster env.

2>
node A does sync jobs, so it will send RESYNCING msg at intervals.
this will be block for holding token_lockres:EX lock.

md_do_sync
 raid1_sync_request
  resync_info_update
   sendmsg //with mddev_locked: false
    lock_comm
     + wait_event(cinfo->wait,
     |    !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
     + lock_token //for step<1>, block holding EX lock
        + dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX); // blocking

3.1>
node A do "--remove" action and will send REMOVE msg.
this will be blocked by step <2>: MD_CLUSTER_SEND_LOCK is 1.

md_ioctl
+ mddev_lock(mddev) //holding mddev lock, it influnces <3.2>
+ hot_remove_disk
   remove_disk
    sendmsg
     lock_comm
       wait_event(cinfo->wait,
         !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));//blocking

3.2>
node A recv METADATA_UPDATED msg which send from node B in step <1>.
this will be blocked by step <3.1>: holding mddev lock, it makes
wait_event can't hold mddev lock. (btw,
MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD keep ZERO in this scenario.)

process_metadata_update
  wait_event(mddev->thread->wqueue,
        (got_lock = mddev_trylock(mddev)) ||
        test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state));

steps: 1, 2, 3.1 & 3.2 lead to a deadlock.

How to fix
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


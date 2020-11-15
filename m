Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF1D1C55ABD
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F9E72242E
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SA3T7udP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgKOEbL (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Nov 2020 23:31:11 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:37138 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgKOEa7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 14 Nov 2020 23:30:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605414655;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dox7s/iDbzVdDdnFXaHNIDbDurmBBzPq9GznB63iwYY=;
        b=SA3T7udPNNZs87f2KJ0BtDp3xSw227T3ixpovBv67yzDNMMdV5Ud2NWCmrej73NAPrLDgd
        g9AekN1hG2ySu3DcAA82kIzAhXx/kWxHok3SvXTJLzwj4zdtf9lJW9eHYLM79rtkY+ofqs
        dyxojUw9ILNCBoPKedlAbgIVoAo4mWQ=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2052.outbound.protection.outlook.com [104.47.13.52]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-resK4ZRnPmyWg4OeFCaI2w-1; Sun, 15 Nov 2020 05:30:53 +0100
X-MC-Unique: resK4ZRnPmyWg4OeFCaI2w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay3G6pQGZN9kIUYaL+xtUsFb4Ld3Thf93szkgg4mBhntnodzb/CHa51jekLvsYKHmN/uG8JZGVgO6mJ/YkCPikr/QHckdhGsON7Z5sykGhifOELFRUHhO8I7O69pqfk7BGervrIhCs1/oNKC2MPGnZAfketlgsVdzpxURLGjn9Q3byHltus5F5BW7rfdALuAgvVwtoBIdyfFoJtHYVScfFj8P9PJ1cWvv977wXdU+lih+kdNYJ21CtSbdf70eRZTGLb6y++Q7L6qn99Nb1PSQy4rp7hmcISo1GDAIFvUstWXrlu97CC41uy9DyLQ6sojtr53tUhvr+Dl2uevpM68SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dox7s/iDbzVdDdnFXaHNIDbDurmBBzPq9GznB63iwYY=;
 b=BxrR7tVfSm8yppd3vpzXT8ozivOGxXlATvW3csOFZhN4FDQCPcRBnA9SCkZvyucNvT4DAcWeFL5nxrzNnRzA83eDENV2Az6JEt9hLw02GcjJG40jsfNUGyqsEeSNp5wheg3eQ6OGc7NAxON8mW3vuRGV5cHd180xPR0fvSHPf16bEXEmefGCk4A/lIW8KZZZ3JpzKIu6eYNTzYmBN636H4cmC70ywU20hqV4FckekEBteDLhP4E534lDBVqKAW421s5YuuEZHnhlRmIJgNzo9BAV7wTWCnR/v4Gghrg4jP+dNdrd5g+BwGtHdAcFcFd5DAGs5oxWaZkRXmME2EmwvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2438.eurprd04.prod.outlook.com (2603:10a6:4:33::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Sun, 15 Nov 2020 04:30:51 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.025; Sun, 15 Nov 2020
 04:30:51 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de
Subject: [PATCH v3 2/2] md/cluster: fix deadlock when doing reshape job
Date:   Sun, 15 Nov 2020 12:30:22 +0800
Message-Id: <1605414622-26025-3-git-send-email-heming.zhao@suse.com>
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
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Sun, 15 Nov 2020 04:30:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd7b2348-d59b-4615-33a1-08d8891f3bd7
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2438687EBEAF8A6555D62F1297E40@DB6PR0401MB2438.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4GM1l+S9DuFo7jA9x0FaifHgeEJEIeQYIcCoOi68elEVTOXBmku5DVtMcjcfZeeGXPYk1/rwmsjkJSxMgIc2nNN2pu3DVOM2rtHm+hxTgXLoDCg6Pu5/xe6ssV+tC2KTi0hynsN15XGDOciQ3xa7rsIpL51EPOdHB8a8GPoc5cJdkBRB7fXhHofq0qafcsF6+K58KZ1Q98Ndi8vodES3JG6m6xgpQZWSEUIXA2RWaw45oLxSFlWk2/kDVzImDlu/x5LXovYg+BJ19BFQhsA0A/k86Q676jHvAYk/B9aU4QElETEJJQ67KmX2onLavtx6PLuwbc9Cg6VBh4s7gzqqOAF/mjHCDAjUVmRD/uKq8VlDg+WLw6PrzItMqIiQ40ei
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(8936002)(83380400001)(8676002)(8886007)(86362001)(2906002)(6666004)(6486002)(6512007)(6506007)(52116002)(66476007)(66946007)(36756003)(316002)(66556008)(956004)(5660300002)(478600001)(186003)(16526019)(4326008)(2616005)(26005)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5rc2ssUSmxJamqq4wYG6abYra9Yu3Zj/cp4CtuzGXR8FJorQ3JAQdZ8G7UByGPIIzJexk3f8pj4fWe0l43b9L4DFrd2/8kgmQ6Dmrjn5GxSkFMYfUrxtTjOieueoM8ZkDfwLqWfJmVO7TfZxkaMKHwag6TO+ryZOGUcpdgfIl/RQfdKXvk5GSwd+p8Z+xcrxZKWXVTkMZvORrgStTVQxOGwBZX13Xi/pip4q9KLA/b/YBE/oZ3GGcQZclVgTue770BeItgKRq1dAgsxfT7JHIgDXiHfIEl5XEIDMdEGowkNRKO+LMZmXnE6y9apVY/7d3y7xuj2wt8EDGI16D/aXaqcCf5gZm8BOmUZbWGcyx4hG7UkZSu3D/MVFrtFZQz9NxoFhxAVuB5+zHomYBvXvTcWqv1Zd6l1FmD99M0Oa/oI8m6vgirZFtrd3Rl5WAZnrAoqyhcKp/rTs17t2gh2Fx9pbBhnQ9YG32ZmS9c6OZtb7mtjbVA2bvo5FIeYVBexGL/BKeKdqjCBJehjErc6paTfFEUwlFGARabzA2R0R+wh36Sxl8XJEtn6ne+q8r2m2g2e1NT6HauMs7Ks09Q/QilSrctFbTKjWAcpXaN//o2s97PGx2NdUgIgXOL6E/QTTZmU/fNpXJP6GRkLOU9k0EQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd7b2348-d59b-4615-33a1-08d8891f3bd7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2020 04:30:51.7743
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WP6vrkH4NeObviUa4xi+RPxZm7trjxa+pHrzjZDE7Ch5hYe0a3EKQlN3sMzPAtApsmUHfigMfbgpgtb23q/MJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2438
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

There is a similar deadlock in commit 0ba959774e93
("md-cluster: use sync way to handle METADATA_UPDATED msg")
My patch fixed issue is very like commit 0ba959774e93, except <c>.
0ba959774e93 step <c> is "update sb", my fix is "mdadm --remove"

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
     sendmsg //with mddev_locked: true
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

Repro steps:

Test env

node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB.

Test script

```
ssh root@node2 "mdadm -S --scan"
mdadm -S --scan
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

Test result

test script will hung when executing "mdadm --remove".

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

node1 # echo t > /proc/sysrq-trigger
md0_cluster_rec D    0  5329      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? _cond_resched+0x2d/0x40
 ? schedule+0x4a/0xb0
 ? process_metadata_update.isra.0+0xdb/0x140 [md_cluster]
 ? wait_woken+0x80/0x80
 ? process_recvd_msg+0x113/0x1d0 [md_cluster]
 ? recv_daemon+0x9e/0x120 [md_cluster]
 ? md_thread+0x94/0x160 [md_mod]
 ? wait_woken+0x80/0x80
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40

mdadm           D    0  5423      1 0x00004004
Call Trace:
 __schedule+0x1f6/0x560
 ? __schedule+0x1fe/0x560
 ? schedule+0x4a/0xb0
 ? lock_comm.isra.0+0x7b/0xb0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? remove_disk+0x4f/0x90 [md_cluster]
 ? hot_remove_disk+0xb1/0x1b0 [md_mod]
 ? md_ioctl+0x50c/0xba0 [md_mod]
 ? wait_woken+0x80/0x80
 ? blkdev_ioctl+0xa2/0x2a0
 ? block_ioctl+0x39/0x40
 ? ksys_ioctl+0x82/0xc0
 ? __x64_sys_ioctl+0x16/0x20
 ? do_syscall_64+0x5f/0x150
 ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

md0_resync      D    0  5425      2 0x80004000
Call Trace:
 __schedule+0x1f6/0x560
 ? schedule+0x4a/0xb0
 ? dlm_lock_sync+0xa1/0xd0 [md_cluster]
 ? wait_woken+0x80/0x80
 ? lock_token+0x2d/0x90 [md_cluster]
 ? resync_info_update+0x95/0x100 [md_cluster]
 ? raid1_sync_request+0x7d3/0xa40 [raid1]
 ? md_do_sync.cold+0x737/0xc8f [md_mod]
 ? md_thread+0x94/0x160 [md_mod]
 ? md_congested+0x30/0x30 [md_mod]
 ? kthread+0x115/0x140
 ? __kthread_bind_mask+0x60/0x60
 ? ret_from_fork+0x1f/0x40
```

How to fix:

Use the same way of metadata_update_start. lock_comm &
metadata_update_start are two equal users that want to get token lock.
lock_comm could do the same steps like metadata_update_start.
The patch moves setting MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD from
lock_token to lock_comm. It enlarge a little bit window of
MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, but it is safe & can break deadlock
perfectly.

At last, thanks for Xiao's solution.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
 drivers/md/md.c         |  6 ++--
 2 files changed, 43 insertions(+), 32 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f6..405bcc5d513e 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -664,9 +664,27 @@ static void recv_daemon(struct md_thread *thread)
  * Takes the lock on the TOKEN lock resource so no other
  * node can communicate while the operation is underway.
  */
-static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
+static int lock_token(struct md_cluster_info *cinfo)
 {
-	int error, set_bit = 0;
+	int error;
+
+	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
+	if (error) {
+		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
+				__func__, __LINE__, error);
+	} else {
+		/* Lock the receive sequence */
+		mutex_lock(&cinfo->recv_mutex);
+	}
+	return error;
+}
+
+/* lock_comm()
+ * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
+ */
+static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
+{
+	int rv, set_bit = 0;
 	struct mddev *mddev = cinfo->mddev;
 
 	/*
@@ -677,34 +695,19 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
 	 */
 	if (mddev_locked && !test_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 				      &cinfo->state)) {
-		error = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
+		rv = test_and_set_bit_lock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD,
 					      &cinfo->state);
-		WARN_ON_ONCE(error);
+		WARN_ON_ONCE(rv);
 		md_wakeup_thread(mddev->thread);
 		set_bit = 1;
 	}
-	error = dlm_lock_sync(cinfo->token_lockres, DLM_LOCK_EX);
-	if (set_bit)
-		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 
-	if (error)
-		pr_err("md-cluster(%s:%d): failed to get EX on TOKEN (%d)\n",
-				__func__, __LINE__, error);
-
-	/* Lock the receive sequence */
-	mutex_lock(&cinfo->recv_mutex);
-	return error;
-}
-
-/* lock_comm()
- * Sets the MD_CLUSTER_SEND_LOCK bit to lock the send channel.
- */
-static int lock_comm(struct md_cluster_info *cinfo, bool mddev_locked)
-{
 	wait_event(cinfo->wait,
-		   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
-
-	return lock_token(cinfo, mddev_locked);
+			   !test_and_set_bit(MD_CLUSTER_SEND_LOCK, &cinfo->state));
+	rv = lock_token(cinfo);
+	if (set_bit)
+		clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
+	return rv;
 }
 
 static void unlock_comm(struct md_cluster_info *cinfo)
@@ -784,9 +787,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
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
 
@@ -1061,7 +1066,7 @@ static int metadata_update_start(struct mddev *mddev)
 		return 0;
 	}
 
-	ret = lock_token(cinfo, 1);
+	ret = lock_token(cinfo);
 	clear_bit_unlock(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
 	return ret;
 }
@@ -1255,7 +1260,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 	int raid_slot = -1;
 
 	md_update_sb(mddev, 1);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1)) {
+		pr_err("%s: lock_comm failed\n", __func__);
+		return;
+	}
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(METADATA_UPDATED);
@@ -1407,7 +1415,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 	cmsg.type = cpu_to_le32(NEWDISK);
 	memcpy(cmsg.uuid, uuid, 16);
 	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1))
+		return -EAGAIN;
 	ret = __sendmsg(cinfo, &cmsg);
 	if (ret) {
 		unlock_comm(cinfo);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 74280e353b8f..46da165afde2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6948,8 +6948,10 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		goto busy;
 
 kick_rdev:
-	if (mddev_is_clustered(mddev))
-		md_cluster_ops->remove_disk(mddev, rdev);
+	if (mddev_is_clustered(mddev)) {
+		if (md_cluster_ops->remove_disk(mddev, rdev))
+			goto busy;
+	}
 
 	md_kick_rdev_from_array(rdev);
 	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
-- 
2.27.0


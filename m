Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BFC9C5517A
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 15:52:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A579720709
	for <linux-raid@archiver.kernel.org>; Wed, 11 Nov 2020 15:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="F09AqoiS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgKKPwE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 11 Nov 2020 10:52:04 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:58945 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727205AbgKKPwD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 11 Nov 2020 10:52:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605109918;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7+xgU4gtj+GOnPFG7TYFyx4t/S+T+ht/Z05tBUjz0Z8=;
        b=F09AqoiSj/dKqMBDHqpyFjQHpt2b11UwueGD035uGu87uLUNIvQw65iYU4SiTxIjtMQzFJ
        Ig4/4+SJaRPNMwuQUyrBCogEEQs2/M1l39JInaf3MqXbPjxuHjCMU1yy12RWvXDbypLMLZ
        MrenNJe974rP/zwSpl++BrZReWoqBd0=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-7-jrADSIHYOBCTtgdVgF6G8Q-1;
 Wed, 11 Nov 2020 16:51:56 +0100
X-MC-Unique: jrADSIHYOBCTtgdVgF6G8Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OF47E0V4IZtaeO/R9JkVRX5pfJzQXZrzgH9DUfK/dlqdxLx8I1cqNzukovfwyck2PJcxf73ubfUndyxJU+fgZ7Cy0VFvVxNxthu6iSfzcO0aRoiqhRPO0ajyQjWf8M415haeG0dU/k5UVZabLJaoH88u0uxMbtpJlUjM/UOc170cQtEs6uC7W4Ivfi1qSClNEJ8wkMEVQnOISejqY3Ym0xTStjOLfg2oy2e+YcrfJbSpGO+Cn7sGPjnJcyBB5vUysrPdlp9IVQOp7l/v05U4vrcSpX6tki+ttmHny1kNCA/Go4stZ0xkO+r+vxhmxt/S7r1Ucgj01t+M/CFBRJgXPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7+xgU4gtj+GOnPFG7TYFyx4t/S+T+ht/Z05tBUjz0Z8=;
 b=GDeHWCRnfSbJ9OWIQN4RNHR9cd3SC+Ulnhvs0okUJWH6acN1uBrqm2WvXUOUAW2ZzFjmbvP4H3FPYEgieZnVF+U4DYnKMjEC9PxHsewVm8UZZio7IZiEAawK1rcNZkHDKtoGR68xNVEn8CRJR61bn1wXtQQc3fy6PZHbJvB96IkK+PYHJwY5o4oz7RCVzXDcSH5nE7M+wgkwa1Hi6ZR+pnhd75j+GDHjqtNSeED1pk5VjX8fEthEcVJlZEvAQ96NpPI703pez741pZ2zVzxljesVlHyWQiLrXy5e2RPzjUTvCiq0RVHJPd70Rr+3h89+iFheib/rG/gNmi1LygEwgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4060.eurprd04.prod.outlook.com (2603:10a6:5:23::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.25; Wed, 11 Nov 2020 15:51:55 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.025; Wed, 11 Nov 2020
 15:51:55 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.de
Subject: [PATCH v2] md/cluster: fix deadlock when doing reshape job
Date:   Wed, 11 Nov 2020 23:51:38 +0800
Message-Id: <1605109898-14258-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR04CA0062.apcprd04.prod.outlook.com
 (2603:1096:202:14::30) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR04CA0062.apcprd04.prod.outlook.com (2603:1096:202:14::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Wed, 11 Nov 2020 15:51:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eae9f65c-13f1-4b40-9daa-08d88659b6bc
X-MS-TrafficTypeDiagnostic: DB7PR04MB4060:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB406093301826B19E773D44A597E80@DB7PR04MB4060.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xDDAwcfJNwct+y7QfjYGQTm7Pf+sVEq3gwF6027p0iOvk6atSeF3x80aP+LfGpHUQ74/HaCcyBBQA0Dcomh3tVVT8jo/V1VeiCDednjDgGecmIZ/XHLyvC5MphXo2+3v10sxnpCLrR/MCWMecEc8d8r4pToHfZAeekzaEnzj3U6dWYzFke/n1ObeRXIxa4rJ8h7Tc1jCtITlaFjbIsK6+XQo2qJZ12yDiry4amOrDln9LyxVlmqcq9AdG9sTT/fUxPmY1fSTlq/i86A1DIaM1w3/TWm86D02KjqTkiVdasVeW5DeHeHTcoPKcwhvwKV97nAbHY167R0r4J2ejx3gIPqBmyxq6Q8OvVLdVl+uT0nFUgrpIUHQO9OnofQg7p1l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(39860400002)(346002)(136003)(186003)(16526019)(36756003)(6512007)(478600001)(8676002)(26005)(86362001)(316002)(6666004)(956004)(2616005)(8886007)(8936002)(66946007)(4326008)(6486002)(6506007)(2906002)(66476007)(66556008)(83380400001)(52116002)(5660300002)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: J66cYA0CvEZiwKoVeX9W0YPx4pitaP1N6x5HAhGdxoQtHZkIgiN6JfKesQK6y5yww1b84m5wn1qwEDlnUbS7ytBJk8BL0n60/g8Z8ITD83OLQHQDEQD9yVY+7sm36OVmzG9MezB1VT94y5BmXgQeFA3JVndDqPWnIKlv5gl0+H2EIgZCPk5XnI3zs6ZcMOW6a8stmsE/L2TgP9weLTUpmdvTZ8/tc+BRuUCBdr7ubm/51b0V9b20MYMvQ+yq5iCMFVuIzNxKsFHGKINXeeYkISXypTeNAFyvMySQ7mTAQpcv3UBgjGs91vqkIZslaeA0qOXQg5Jy1DpiyCY933yhcvUiuTZKnikCCMfQJ3alTus1tGzC+R6op6X9188R5X9iqrmIPmxDmityB3DxJr9+23JOghgHwdS/roGLmkgYFr3CfCxzrAQkFU5AJKa5uV8ll/rn1Nu2QbQdPFpcxqlr1HIiA2GDzGUzb7qcqv76D9sPa58O8MP4k9egF37mUMmW6E8lxye+Y85TypWQ0U5dxGMIPEPK1jBPwFBQoA8htEkubxEXEUU2xW23cqo0o/xhXqJWo6H3SA7iM9pfgnompwigLogPjaPkZVzRjnMkZh6+Gj5bp3RAWdOGb3ws/uyM7ZLcBdpevMSVDGaooaPa1w==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eae9f65c-13f1-4b40-9daa-08d88659b6bc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2020 15:51:55.0819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQF4jZxsRsTbTqPfgnnpXpZgC1wIt/Nanu/0vn/N4PzA0JSqSLLxz1NJFwEU6QDl13kAGBgY9uzRy3FoDwioZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4060
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

node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB. The disk
size is more large the issues are more likely to trigger. 
(more resync time, more easily trigger issues)

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

Break sending side bock by wait_event_timeout:5s.

Why only break send side, why not break on receive side or both side?

*** send side***

Currently code, sendmsg only fail when __sendmsg return error. (it's
caused by dlm layer fails.)

After applying patch, there will have new fail cases:
 5s timeout & return -1.

All related functions:
resync_bitmap, update_bitmap_size, resync_info_update, remove_disk,
gather_bitmaps

There is only one function which doesn't care return value: resync_bitmap
This function is used in leave path. If the msg doesn't send out (5s
timeout), the result is other nodes won't know the failure event by
BITMAP_NEEDS_SYNC. But even if missing BITMAP_NEEDS_SYNC, there is another
api recover_slot(), which is triggered by dlm and do the same job.

So all the sending side related functions are safe to break deadloop.

*** receive side ***

Related function: process_metadata_update

Receive side should do as more as possible to handle incoming msg. 
If there is a 5s timeout code in process_metadata_update, there will
tigger inconsistent issue.
e.g.
A does --faulty, send METADATA_UPDATE to B,
B receives the msg, but meets 5s timeout. It won't trigger to update
kernel md info, and will have a gap between kernel memory and disk
metadata.

So receive side should keep current code.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v2:
- for clearly, split patch-v1 into two single patch to review.
- add error handling of remove_disk in hot_remove_disk
- add error handling of lock_comm in all caller
- drop 5s timeout patch code in process_metadata_update
- revise commit log

v1:
- add cover-letter
- add more descriptions in commit log

v0:
- create 2 patches, patch 2/2 is this patch.

---
 drivers/md/md-cluster.c | 27 +++++++++++++++++++--------
 drivers/md/md.c         |  6 ++++--
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 4aaf4820b6f6..06b4c787dd1f 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -701,10 +701,15 @@ static int lock_token(struct md_cluster_info *cinfo, bool mddev_locked)
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
@@ -784,9 +789,11 @@ static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg *cmsg,
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
 
@@ -1255,7 +1262,10 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 	int raid_slot = -1;
 
 	md_update_sb(mddev, 1);
-	lock_comm(cinfo, 1);
+	if (lock_comm(cinfo, 1)) {
+		pr_err("%s: lock_comm failed\n", __func__);
+		return;
+	}
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(METADATA_UPDATED);
@@ -1407,7 +1417,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
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


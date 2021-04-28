Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0705C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 28 Apr 2021 08:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8111061004
	for <linux-raid@archiver.kernel.org>; Wed, 28 Apr 2021 08:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbhD1IbK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 28 Apr 2021 04:31:10 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:46725 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231635AbhD1IbI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 28 Apr 2021 04:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1619598622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=QFh3qIG5hLNOvgWPswijG18QuLApby9tf67Edy9UV8U=;
        b=W5QPinYg98ZjZ4iomZQVWHqIrAcl7ccITbVo5U2Cjk+73jew2LSUtR5nA/OculPODzpOo0
        2/fO1qoK0RzV5UL3Bc79aBp6YYzMvUu0TRrzZr3BhLIwoZQgonBEs0Rr2MMG6v39UXHjWJ
        QMQaMlsko3X5DjnVmhqfVzcv8vsDm9A=
Received: from EUR04-DB3-obe.outbound.protection.outlook.com
 (mail-db3eur04lp2055.outbound.protection.outlook.com [104.47.12.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-5-9FAtyM68PNeT9c_omVEgUw-1;
 Wed, 28 Apr 2021 10:30:21 +0200
X-MC-Unique: 9FAtyM68PNeT9c_omVEgUw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UU6k8oVwNd7nNrEpW7XcRoudjYdUnDJBPZblt2DPS+L+WGjGFCqeTpXcsi+Rg/5ZGJj9wkqbbX4Ot1rGgMsb+L2bDeZGssGDfE3uIcksq4yExkLitJ0txQro/4W8aFC2E3mKFcbbZgpd7O7Ekfa+RxPtoK3I+2UFok1vi7mN7uI25Q0Zce1LF1l9yTy5cwpqLJYrrnznEhq5pxpbdubirjKRnkjgqyKv09lpFPBl+g3t0NaoZYpjqm2IcYltDwv3GXdQRjnm2i4azc81IVVRqtxUQNM0q/lYrkc5JlepLKkzS8IJZuIN9O16OWlJNucQJ8OZgEY2m8G2dSJ7imYObw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6nf4whpJu1rJkibu5qJ9xoG+yciKDeNxIhRxyCg057c=;
 b=cdkwMYzL5g84M9CKTPnKCGrp2tZRXhRCg1iyvXUC7k65cOg7+k7zhFUNfWp93Eb7SzC135RfLOZ+AJ7TSafoRXFZHUyCngs8Hh1FKQx3xHfLBw4Cx8cwoRL7QWIpEyJoFq/ZmA8Nso54uKIpYae7SuyBgFqUy0nq39AjooAY8Y6RS13WIDY2bHuqhr/U7dla3POYUaQMYmGfsitEA0Cd0+Kb2zXHQj9iklZIdGWeucssmrf9SRpou1P0D5nUbA1VzDMi3yxncR1yb/28QQO3xOlLqityF2g8sjxX2ZG0mJlwxBTG0snQXl3t/T9lNvp9m/Pi9YC6JRbqiA89mT3/aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM9PR04MB7555.eurprd04.prod.outlook.com (2603:10a6:20b:2d6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22; Wed, 28 Apr
 2021 08:30:20 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::7c02:9e68:f15a:1dfa]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::7c02:9e68:f15a:1dfa%6]) with mapi id 15.20.4065.027; Wed, 28 Apr 2021
 08:30:20 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     linux-raid@vger.kernel.org
Subject: [PATCH] md: adding a new flag MD_DELETING
Date:   Wed, 28 Apr 2021 16:29:03 +0800
Message-ID: <20210428082903.14783-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [39.78.177.121]
X-ClientProxiedBy: PR3P192CA0020.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:102:56::25) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (39.78.177.121) by PR3P192CA0020.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Wed, 28 Apr 2021 08:30:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d216a6dc-d963-46a7-6c4a-08d90a1fdbcb
X-MS-TrafficTypeDiagnostic: AM9PR04MB7555:
X-Microsoft-Antispam-PRVS: <AM9PR04MB755563165A835C350A999FDEF8409@AM9PR04MB7555.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5qJPXbj+mvwF32fxD+3W6XBB2P+FXu79FmDFWutrnxsRw+BJ/rYaWoFosX3G9peiwjz8iKnAAJp1NhOGiKbqo49t+ov/o5LXXsS+xlbPOhQ694NkM0zKmA6STggJSHpMqdQW9I0nFX/qmR3iCisk67cfDAFP7s1OhRFvmvrpD4XQycA3T5CYRYf8LP8JVxYh7K034SHsgfOgTI4jre8Wy7NTwImCpJyyBjDNIITyfhjp8lNLnGs8XNL4Sml4d5Pf+t4lMJwu+ADaczdEKL0DXArascFWDIeIAralJDpOhaQw8PxDnge2a7fhGAprRYD7oI73OMUU/c0NM91fVLILUtgCgiLuigfX7/GhB2z6h12MO8axz+CPttHsokn9Ts2BxJhbF+/Emumg6udGTdC7k8KCPSVtZFcjBl2A8QiHTE3To5fWIcm7J5Q4Q4IcNigVLNRO6CHFxXAoqChObCa0N8WGuyNDtlMOzV4qQBZVUuyUtxkRQGzo2g5ADfc41AJTWPjWMugRN1Lxrog8fYm+539U10uKY2gkXVU/iuzUSVJ+IKVVYK/85lTSCaCxgUaaTgMsC9P2pcFfi9OOc4/vODvI8TnI/4KxKmYRBTMTATSLlPDHT2NVzVNP19vmP6W5X5fknG6DBoxiS1xAmcWugg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(39860400002)(366004)(346002)(376002)(26005)(186003)(38100700002)(478600001)(66476007)(44832011)(38350700002)(8936002)(6512007)(8676002)(86362001)(6916009)(6506007)(1076003)(956004)(83380400001)(5660300002)(16526019)(6486002)(36756003)(2616005)(8886007)(316002)(52116002)(2906002)(66946007)(6666004)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VlJg2ouHvCz0hvSMN+qqfpq6f8X+yzEt4Z6HcqPz3NTHeoQ/ydA4LrktRxKQ?=
 =?us-ascii?Q?ZxvXd54QkRXSn9/sseZ/LbXCd9YpdOAcdhW/0z1pAj2Rezjq0gdehix/8El+?=
 =?us-ascii?Q?aejS66DNm2BcrkGzAeC66AJs91N03it+2np9hQUh82M7L7CrE2O1UwMkguPQ?=
 =?us-ascii?Q?fnLuoCCDBsn1NqR0Xg/drOdWqh5tWTeR/XopbmNaiD0Hv8BoMo6jaiAgKc10?=
 =?us-ascii?Q?ylvlX5i+05ycHQq2WhHIbVbvZ4S54Fbj4Csqj3JRb8E2qACoKUMcnbiwz2Yt?=
 =?us-ascii?Q?UlvIgmUotgNfZ2hKUpj8rhSTmwD5qUP4pksDX0pGwbCdP1d5XV3sY09iXvyY?=
 =?us-ascii?Q?k2nNXfdPc3+9ZT4rgCO43VuFbvzmfZi+60ydJAJoNbWFtGWJk1Dpt2MNDdIl?=
 =?us-ascii?Q?OSjsDjJx1ZNgZgXG65+9PamZmGDU5zYJHmULfzWTBERwRtFMAEo9iMQRFfL8?=
 =?us-ascii?Q?sduLfz96cR1HRUIm28rzKsOKGtT6osRgbiSTC3GuxAQVWOaeBpcQXdFxV9eP?=
 =?us-ascii?Q?g9IDUKqqmV4dBFllYDP9xyuZCCRhYIFZ5zGuBlmCrfhursxmKlh4lvOTE+PA?=
 =?us-ascii?Q?c8J6R3spOQKiBFM0Q/SllYKGvuHNQdwtdArELPamgkT8rn72ksMyafFTqrYn?=
 =?us-ascii?Q?2ZPU8bnvvUuKSPe5vawMDvrflRRFVIPjC/oGHvt/rvJgIqt57kjbsz1DqYvD?=
 =?us-ascii?Q?U34Y+wWH4K6Cp7Ve8BJ57ddQHvTF+5rVOO6aFpt+Q5whH3LNVNPaxr+32PZ/?=
 =?us-ascii?Q?+bHnMDKn7nm39Q5qiirruOBBuc1K/nDDaYuqJMd/TjT1tAlMizaVb+MmzdIr?=
 =?us-ascii?Q?lxFoqEUP4eGL9EgvB3JsW/vYOxYeEfD3dWhQhrcKWzQmubMJEhdz7/HghFNI?=
 =?us-ascii?Q?1vMT0lsdJLFWUWFmbaq+Bkba7rl4mscq2V4PHkol0+tAcp9bWcV1+kFnCXFm?=
 =?us-ascii?Q?w6+h89GM+t/EoICtH11n71NZUaNaiFKULyVrD5EcOKsMsD2j239sc3A3NjAf?=
 =?us-ascii?Q?ejMwkp3vLmNu73PBOGcOsS4P3wEpRPQQLQ3ex7ud2LgZnTcnkVppaxVOdUbd?=
 =?us-ascii?Q?d1hYSIFp1schJdOw0X/62DMQj3H+z474nZ2Zo1THc+oO7N65noWW13R84L89?=
 =?us-ascii?Q?CTIOMhYV0rgpkJUsMZLtiQQlslxD933iEstRcXKLUmQ3SceGZYFmZE52Srxi?=
 =?us-ascii?Q?DiTPInQyMgeWI50eF+aThFoJAoHjkVIVmqT2b4YuvxwOHdy8MmJz93q7DURu?=
 =?us-ascii?Q?1voTCZdI5kcT5UWVUnXGmprcPHRJXZgOmDDnw3kXPn5oQPEnxPkO4v24TZ8o?=
 =?us-ascii?Q?42/dNcvwqkS72zPIzLL+n9KV?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d216a6dc-d963-46a7-6c4a-08d90a1fdbcb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2021 08:30:20.1279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fbGo91pgRftD+Iw5Dgf5IDwDgNdTG5AzRYMyXEs8I9bcWc610hhryurHLJnSJT8Itdv/HMbjYJpmR6XU36K+Cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7555
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The mddev data structure is freed in mddev_delayed_delete(), which is
schedualed after the array is deconfigured completely when stopping. So
there is a race window between md_open() and do_md_stop(), which leads
to /dev/mdX can still be opened by userspace even it's not accessible
any more. As a result, a DeviceDisappeared event will not be able to be
monitored by mdadm in monitor mode. This patch tries to fix it by adding
this new flag MD_DELETING.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 drivers/md/md.c | 4 +++-
 drivers/md/md.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 21da0c48f6c2..566df2491318 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6439,6 +6439,7 @@ static int do_md_stop(struct mddev *mddev, int mode,
 		md_clean(mddev);
 		if (mddev->hold_active =3D=3D UNTIL_STOP)
 			mddev->hold_active =3D 0;
+		set_bit(MD_DELETING, &mddev->flags);
 	}
 	md_new_event(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -7829,7 +7830,8 @@ static int md_open(struct block_device *bdev, fmode_t=
 mode)
 	if ((err =3D mutex_lock_interruptible(&mddev->open_mutex)))
 		goto out;
=20
-	if (test_bit(MD_CLOSING, &mddev->flags)) {
+	if (test_bit(MD_CLOSING, &mddev->flags) ||
+            (test_bit(MD_DELETING, &mddev->flags) && mddev->pers =3D=3D NU=
LL)) {
 		mutex_unlock(&mddev->open_mutex);
 		err =3D -ENODEV;
 		goto out;
diff --git a/drivers/md/md.h b/drivers/md/md.h
index bcbba1b5ec4a..83c7aa61699f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -262,6 +262,8 @@ enum mddev_flags {
 	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
 				 * I/O in case an array member is gone/failed.
 				 */
+	MD_DELETING,		/* If set, we are deleting the array, do not open
+				 * it then */
 };
=20
 enum mddev_sb_flags {
--=20
2.26.2


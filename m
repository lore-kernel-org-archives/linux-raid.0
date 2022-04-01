Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B856C433EF
	for <linux-raid@archiver.kernel.org>; Fri,  1 Apr 2022 02:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243999AbiDACQA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 22:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243993AbiDACP5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 22:15:57 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49E773E5C0
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 19:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648779246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/7zsWr3mUQvwZNkc1xacd8bZtwMpq9n5VwkJn+4oziM=;
        b=A0NWMNhjQ8CvIYQIIMjic1VGL6S6J+3G5rP3l3BkzOOh8v3jJFducqa76JcD6/Ww9jUQ//
        yb3GtTa8vBVk7giq6NH8sSnS6GvHTY20jLpCjY9Qod5SA7nU34sldZr8YBNZSaE7UXWGHG
        mecTrvoAzKE1ra830ZI3ya9kAElBFIQ=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2110.outbound.protection.outlook.com [104.47.17.110]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-25-8d0ptJ6SNh2FxQw7siQE3w-1; Fri, 01 Apr 2022 04:14:05 +0200
X-MC-Unique: 8d0ptJ6SNh2FxQw7siQE3w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WeeY7zjlUQxsxfJ1DY81PqyY06WnquOjYP4x9teAfMisMBjX4GfuhObQ2YqolaeUbQ34DmkQoo+1cr3f/nFKCnGXFhMziR6QcynEB5uX8PAJBPiOM/neVHCzwWZKfTglufqZMXHjX17WaEI8ud3b8UYWfNvnLvP1XZNAS6WnuCAFm5tM0MLo7lUfXbD5JIAZd7so4Tzj2Jy5NqFZbDwHt/N6nmeoQGLmNpWUalf5467k5Sjt73O3+Rm0AB2o9VROjFiJkhXmMwKJPF1O4TstiDSTomlM70fvp59Lkt2s33iUzWeQJeLdTTLy9Fk5EfIkeJt8703kjdze/MI2p7ESvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJri+Xzow4stm5CRzZi+BHt2MYlrdhO40D37vCKJEqo=;
 b=fqUxgK7iza0mMloZxZTAFJeWK+eYhDSNpvYJeB1vpCErmzHbhYIiXL75ZqLu4njDYq5Hjtn2YKszZ3hVjAJYA6YUfMeCCjP4WbIXhXn0iAobu3uVg+g/RRKgrTsWucQP/kKwS9EcDqFTbKqu++yCoZGgyznZrcTJGKHWYc2R4dOl6pmK4Z4CQ/x9jS/2BzETcbSzpMA1bBaEpHfX6F63wKRB0xaAX69czvwUBT4wlmEIpxCzmmHISObc70nBzygyZOoRIxjPau9g8Xcjd3f1fsfSnl8s/6JRC5eKMwuX6ivyJ68B1wG8axKeTqPCj3w/Gx6RqnM2XQiC2x1ANGQ4Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6857.eurprd04.prod.outlook.com (2603:10a6:10:114::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.25; Fri, 1 Apr 2022 02:14:04 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.025; Fri, 1 Apr 2022
 02:14:04 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@linux.dev
CC:     Heming Zhao <heming.zhao@suse.com>, xni@redhat.com
Subject: [PATCH v4 2/2] md: replace deprecated strlcpy & remove duplicated line
Date:   Fri,  1 Apr 2022 10:13:17 +0800
Message-ID: <20220401021317.4046-3-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220401021317.4046-1-heming.zhao@suse.com>
References: <20220401021317.4046-1-heming.zhao@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: TYAPR03CA0017.apcprd03.prod.outlook.com
 (2603:1096:404:14::29) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d50486c2-5869-45e4-a02a-08da13854b3f
X-MS-TrafficTypeDiagnostic: DB8PR04MB6857:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB6857EB1887DF2C14E67658AC97E09@DB8PR04MB6857.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1np9qKf+8M4kePWJHsj1peLr55a6zSVnk/sOQ37e9kxdRzT7/t2Gj4SsfBPTDuaL/tsw7TN8x+YiB6nfRSxWZsu1ednsLp+EgL/CKTm5kbOvZisOBxy65lKIN8gFsMSjkEPrzuiksWopudRCoOQA1CElYgOcy5r1sC6GqUFrHZUI/8/NEC8XidM/LxUlI44kTcxA943y1zQ+IlxNaW/ubD47aYKD/4bihyRR8mNmsUUJ4pwarc43gYUK8cFhBOIjLaPa19XZEy00G6bD71wf+PI1M0XLQKz9HuEOyyMb9ypBtTj+86WbSNvDEUZ+UH1u4xaNz/ZfsIh+KJz1J//lmYlfgmddTY0/CtFcQChsiMiXzoBeBKVA/GDl6Z6jri+mWGq5UmuV/SZ2M9gYZxJ3P+KEqfcM2ncHtEwM9WsWX4clnVtdP8EF5zW9LOe6CcGDyNF1EhSHW9PAJLT02w6h32uWraWU2FznfyXeiC4pKTBaRJOwDWHWVUkxIomLGZA/T6GsVB3Ou7nI9GGQztoHtZn7RYvgWK9eWls7smO/b0gSk9LiegbxG7+DZ5hDUT7U7uBaYhkWDTugfJPo56ghtXK5mBOy/bJHUw/msR0jXkEBuWp+/Ei+/Ue3IeVh1KJtWnl0R5fvAkkR1CejjVcTxw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(2906002)(36756003)(6666004)(6486002)(44832011)(6506007)(5660300002)(8936002)(4326008)(66946007)(83380400001)(6512007)(66556008)(508600001)(8676002)(66476007)(1076003)(316002)(186003)(26005)(2616005)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+6DZ04Vl+fMYAb4G6bUdgyXuPks3EiqXhvNuZfkPptwjANtDINmJwaZKo5o2?=
 =?us-ascii?Q?XYxTPtBVBNUr/s2aMC4ApjFX/pyvuNzwLarnOxzbaBuEbwo9ypr2nVemZd4/?=
 =?us-ascii?Q?B0xrWnGBtKPsumPvmy0q08D4/OiOwk5Y4PPlpU8lEPMMNo9/TiiGqB/2N7lA?=
 =?us-ascii?Q?EkvGTMgLuy20aP7ugvkOduTb4Za6XnuVerop5wvcpnEXRMF45M62FYX02//E?=
 =?us-ascii?Q?bGlS/wV6miJH3WqQkfO3V7irP9KANVUTCXpsi2YMspkg87FJaRlOf3vqlLCC?=
 =?us-ascii?Q?PVEhRuRM5JP9Pym94rkXxFug+k7M4IFAi/+0mTZDId4qvNNEjqm5RsMCZ46K?=
 =?us-ascii?Q?4dlIeXFDRXJyoOqKDEjuYXq89pmm/gOFzYnAFc9Zldp1ETzoxeEz0iaVuvLD?=
 =?us-ascii?Q?AhTORDd2BwhD08ah+KPxFG2sEeB5YT4XSsfbTbphEf+2PIMWp426tQYou7+H?=
 =?us-ascii?Q?pBXwAESEMj+OHJl/cEQiILnaORJgkuTYHSfFS8XSy2gWnhGFJ7/isv3t4eBQ?=
 =?us-ascii?Q?Qtdu6z9PZQoOhacBMWDCj60spu94eiSp9/SOGJUj5MO0T5rwwRG6FNfWGTXS?=
 =?us-ascii?Q?ii+i9TUS+f/PBM6FjPQGIKNW+nKGx7vxhCnNxKxxEDoGVHAzx9YlZdQMnRam?=
 =?us-ascii?Q?nHccR+eOrKjayDLuHCegDEfT5y06Ya3QZ3tJhwk+NOjuCVRkSbs/Kboqzkl/?=
 =?us-ascii?Q?yDjNiD+B7KUiA2+YrAaEc/fNrmEGDN499Yo6+2CNFVotPiNk89Z68sp2lV+/?=
 =?us-ascii?Q?IZ62X9aDqva6klDk+kXOw0srLQGi+326lgOaH9UUsgTp4SstxdMvjVRwyzzV?=
 =?us-ascii?Q?d/qOuJkhZunoIzPKE3AvfV8nvT9LT4LpnaVDh0kLjyjIjkwLimfFOiZGPF10?=
 =?us-ascii?Q?E87JqVUGnyrTjK8N2bRAXrw+mAawcVUQRZvEePYj27C/jujEw2BTcO2CoyOh?=
 =?us-ascii?Q?UDza9QKnwru+Hxb9/qrZX7xOy9jWp1vqmrYFkYeIc8nQV3TjMLDr2pCkYmzX?=
 =?us-ascii?Q?kDGxwJSgVK6ifW+MC5QklRQe7yy1+F/xsEb89NFisCIoVN57bAjg6tJ1BtsZ?=
 =?us-ascii?Q?m2p8ig6oVdf9JPSLQiMJikLfDqfC/p/uvrenUUty08D9gonTvteSf1FDLwZB?=
 =?us-ascii?Q?ii2kNFwIEIaOYgJdUfPNmg+p93YMhFONwueFf/aGlQwQc6jllQgAQxOtOKb/?=
 =?us-ascii?Q?t7GdQ7DGma36czegLXWRI5bmrnyqPhVzLI9zMUHNhhk7g2ZwAu7T8JgYMU9O?=
 =?us-ascii?Q?bQKyQyGN+8oLqwhAGgCKNptVeFqh6PHNsPqdkWardwRlLVwC93HznjlYFdeG?=
 =?us-ascii?Q?rU+ccg3JcEo6rxwq5TOv3qhXGg9pzkMkenv9qQHW4lOGZ1/90yuonffsZwof?=
 =?us-ascii?Q?ctHgxtLS5tAou/wRY1/GSn7HUz0bql8L2eeYrZepPYYm2tcSc1SHb7HvtBpu?=
 =?us-ascii?Q?V5SJnHYpHOAJu0Oi0JPDnrSnSsNEZ91yDusGE4L4Sbrb4YnPWNaXwEs38+qU?=
 =?us-ascii?Q?zyD6YyCSe0e80z9I4Nr4Zz1CCigiA7uM2HuPOf4Lv4MKqz5zTi5BRw4JElwc?=
 =?us-ascii?Q?CMZ71ml8g+dyJVaVki8SntItgYv+bSRtL1so534aqrsFhHr8ciqzN6ozZj36?=
 =?us-ascii?Q?6NuUe3wqvYAcucAEucrsLqmkxXkv7PbAlumbmll9nSYI+fAW+2ljCo+yEotl?=
 =?us-ascii?Q?lFy0Ha2F/BCw9I0JfPYs4dwoAzEmiq7iVI/AooG9vzIHVEwljia9XmTUTcVM?=
 =?us-ascii?Q?kxSRLsbLag=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d50486c2-5869-45e4-a02a-08da13854b3f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2022 02:14:04.2260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kh9d/yMDcOi1evwoMgpphTUrHFStuv2o+Mq1UAl5W7it0mTvImNf0oUtT+q6zb98Ch5sru9qFCynq0CZyQgxKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6857
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

This commit includes two topics:

1> replace deprecated strlcpy

change strlcpy to strscpy for strlcpy is marked as deprecated in
Documentation/process/deprecated.rst

2> remove duplicated strlcpy line

in md_bitmap_read_sb@md-bitmap.c there are two duplicated strlcpy(), the
history:

- commit cf921cc19cf7 ("Add node recovery callbacks") introduced the first
  usage of strlcpy().

- commit b97e92574c0b ("Use separate bitmaps for each nodes in the cluster"=
)
  introduced the second strlcpy(). this time, the two strlcpy() are same,
   we can remove anyone safely.

- commit d3b178adb3a3 ("md: Skip cluster setup for dm-raid") added dm-raid
  special handling. And the "nodes" value is the key of this patch. but
  from this patch, strlcpy() which was introduced by b97e92574c0bf
  become necessary.

- commit 3c462c880b52 ("md: Increment version for clustered bitmaps") used
  clustered major version to only handle in clustered env. this patch
  could look a polishment for clustered code logic.

So cf921cc19cf7 became useless after d3b178adb3a3a, we could remove it
safely.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c  | 3 +--
 drivers/md/md-cluster.c | 2 +-
 drivers/md/md.c         | 6 +++---
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 612460d2bdaf..d87f674ab762 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -666,7 +666,7 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	 */
 	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
 		nodes =3D le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
+		strscpy(bitmap->mddev->bitmap_info.cluster_name,
 				sb->cluster_name, 64);
 	}
=20
@@ -697,7 +697,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	if (le32_to_cpu(sb->version) =3D=3D BITMAP_MAJOR_HOSTENDIAN)
 		set_bit(BITMAP_HOSTENDIAN, &bitmap->flags);
 	bitmap->events_cleared =3D le64_to_cpu(sb->events_cleared);
-	strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb->cluster_name, 64);
 	err =3D 0;
=20
 out:
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 1c8a06b77c85..37cbcce3cc66 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -201,7 +201,7 @@ static struct dlm_lock_resource *lockres_init(struct md=
dev *mddev,
 		pr_err("md-cluster: Unable to allocate resource name for resource %s\n",=
 name);
 		goto out_err;
 	}
-	strlcpy(res->name, name, namelen + 1);
+	strscpy(res->name, name, namelen + 1);
 	if (with_lvb) {
 		res->lksb.sb_lvbptr =3D kzalloc(LVB_SIZE, GFP_KERNEL);
 		if (!res->lksb.sb_lvbptr) {
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4d38bd7dadd6..d09bd750e6bd 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4030,7 +4030,7 @@ level_store(struct mddev *mddev, const char *buf, siz=
e_t len)
 	oldpriv =3D mddev->private;
 	mddev->pers =3D pers;
 	mddev->private =3D priv;
-	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
 	mddev->level =3D mddev->new_level;
 	mddev->layout =3D mddev->new_layout;
 	mddev->chunk_sectors =3D mddev->new_chunk_sectors;
@@ -5765,7 +5765,7 @@ static int add_named_array(const char *val, const str=
uct kernel_param *kp)
 		len--;
 	if (len >=3D DISK_NAME_LEN)
 		return -E2BIG;
-	strlcpy(buf, val, len+1);
+	strscpy(buf, val, len+1);
 	if (strncmp(buf, "md_", 3) =3D=3D 0)
 		return md_alloc(0, buf);
 	if (strncmp(buf, "md", 2) =3D=3D 0 &&
@@ -5898,7 +5898,7 @@ int md_run(struct mddev *mddev)
 		mddev->level =3D pers->level;
 		mddev->new_level =3D pers->level;
 	}
-	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
+	strscpy(mddev->clevel, pers->name, sizeof(mddev->clevel));
=20
 	if (mddev->reshape_position !=3D MaxSector &&
 	    pers->start_reshape =3D=3D NULL) {
--=20
2.34.1


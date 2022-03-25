Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA65C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 25 Mar 2022 02:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352550AbiCYCyK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 24 Mar 2022 22:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231890AbiCYCyK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 24 Mar 2022 22:54:10 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB067C5587
        for <linux-raid@vger.kernel.org>; Thu, 24 Mar 2022 19:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648176754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=uf5IlRkfFpjv03qxSwGYVLu9+T2urQqphOuUwk3glVQ=;
        b=VFI+lYvrdKbyE67RfV4Ssu1767/hUJOOHrdzrez75JLUsQ6I+TVNrb9QrAVGj2JKlVthVn
        dLaZ79zq8Ll9DYk0wxal3Nb5DwqrMVA/eDCcyB54P1HgH9Ot1s7rOjv8fJgq4JhV3xyayk
        rHTKqmoYmIqB4CkeZmni93TYBdpt3Rw=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2059.outbound.protection.outlook.com [104.47.6.59]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-6ugTQxjfMoG2nFHS-1lfFg-1; Fri, 25 Mar 2022 03:52:33 +0100
X-MC-Unique: 6ugTQxjfMoG2nFHS-1lfFg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGxNdx2ztERqLBSRerXtw+QmXUgN6r5JR/Y5s358G9BEOHeYRrXBUf0x2AQ2+U7+RkJyulRfr/ZI55JAQqQBqVgiM+zXvIdyL6z5QfrQV5pzX80SCjyBS4b6GwYEdHhZ/jIiqGkaxtfW6YfdMvynK1zDk4katiN8NYIGfGJCanyFqmKNq0hhSHzfmU7MlOk4oC9jkVxbTRHpTgw5qZV9AIJ4h6vtCmAGGscfLUSbXO5ePTlZfYM9ALgJ27rYGwstFQR3kuARW1EKb9I2m761QyRzYGvxvT57+QPgTDATg5z8Zfp6XMhSF2axpG+ome0jpEM9BkswCHdGGTDTGZ9EqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/J834NtU4QX7IzR2xI8V44LzVUCpGWRZxTm11AwR0fE=;
 b=fUh87G85KoQhR8tx5zE8Xn0L2ZfrfokB1pg6YkI7cI5RrRMT6uW4hh/hb/uImcXrQX6kUme6V0xFVFpG+aKZCAuowAC9r79kOe7bFYB5V2fjQKY9StDvBCzI1a9sHq3xMmXTs/j1HTAfqp2dTm5YDz5/7/kFoOyTcZMmn1PySPVg0xj8tlhDZwht6zUQfczm8pn1I+YDHx5YqKMOfXNl5TmWls0robbpKvgBqt+2+sCvJWXC5faG5XlsjTe29e9YoBAbhv+FwumW13pQ8+jFaYrfwdY+aN9Xt77zFFmH6F0l03XkBjomaiXbfihVS+qk2I1MqUrk3LT6LlRfQiL7pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 AM6PR0402MB3622.eurprd04.prod.outlook.com (2603:10a6:209:7::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Fri, 25 Mar
 2022 02:52:31 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5102.019; Fri, 25 Mar 2022
 02:52:31 +0000
From:   Heming Zhao <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org
CC:     Heming Zhao <heming.zhao@suse.com>, guoqing.jiang@linux.dev,
        xni@redhat.com
Subject: [PATCH] md/bitmap: don't set sb values if can't pass sanity check
Date:   Fri, 25 Mar 2022 10:52:23 +0800
Message-ID: <20220325025223.1866-1-heming.zhao@suse.com>
X-Mailer: git-send-email 2.33.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0063.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::27) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0aa3325-e3ee-4a2f-4481-08da0e0a8144
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3622:EE_
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3622579A54D367430D8B7A48971A9@AM6PR0402MB3622.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: djR4v0uru7MQcL94VVXYsmFHVr9d/id4zvns7t1VR+EfO/lKRflG8oM7LUcPzJIO2ZxUAv7xvEsCXMN8ZGnycNUkG+zlPXJP4Uqe8jGt+z3+so35Bdkk4yONzZpjxEuCc3EB/gnWA9xzVUvwJykofid0qxmvY9oikRQ76jUxKJGdRScxy6s+E4fw21XKMkEPPBXkE4FnLDZxX5mhvhTeE/yoNSeGCy2UKT2WVVM823CvcAtx3iSCscuwLxTffxMH80F/EIINR6zO8EKrQ7efen+oxAm7BZZabptcxMaDmfAVgX51tBztePlyiQ4olJtG526ILw6j2McCTt8rqRM/BsJrqs4x7dXFTYuOUNRkeDvMl7zbK+9w/X9os2gFsykBqSKcKFmBI0pzzXfewyle/8KX9+NvpzPO0LulfjSLP2gk+w/5mJjlPiI6yBE4VUB4p06btLCyQMQ1AX4Zo9WbcGqO5HGnjvGuQb+kj4ZV/ud3lSv4fS4RgsjWVlo0bsvgYHbglP7H3517Mz6TOU+oVHNH1kUc7hhROsRGhs4HsxeoX5h7h/bSGDI1ywKQS5a2YaM5JhsVLq/wgO9dPMQkmd6nZlUTN7myTKxxZvPjfkXMLgujLUe7H8C8dpDuI0r+Ydu0ZL5FiU4CBjCrIeZ9uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(8676002)(26005)(1076003)(186003)(2616005)(5660300002)(316002)(6486002)(6512007)(6666004)(6506007)(508600001)(83380400001)(38100700002)(44832011)(66556008)(66476007)(2906002)(4326008)(36756003)(66946007)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ihF3iThMDyf6SnQdWosBzf+oIZ3kguyzRWxxONXgTAWIVS7uZQizP1RO9Nfo?=
 =?us-ascii?Q?wwgtHyM688H9A10gDTqJhHXEc2nhc0gwpvhN9cwQ2kdFaJ5It9e5JcLlHBl7?=
 =?us-ascii?Q?1LV1lLx2NXkJXKND6LuUmmWRbIvqQDkWlGa/oXgRVXFLEUlbJIyWfkXrUpfF?=
 =?us-ascii?Q?w42bx9v80gOwz6wysXp5AJEhPxOBLU+JDu8sFimgIMR1kIsqJiOy7lSymUSO?=
 =?us-ascii?Q?XOLLmmidA2OCKgaz1w1bO9565BeP0TRxv0tnrpzx0D8qTLhdN1TcORtjjByb?=
 =?us-ascii?Q?enczRK9V80wc2UMHNSzUJGtZGW9CSOgWX1sSF9pb6BRAkBoE9iIguYFFdNOU?=
 =?us-ascii?Q?oI5ttRFSntXlVKzx6OqKxHWnUba3UPo45qZ3wU2lk1rkKSOgzdXUTdXDvXBW?=
 =?us-ascii?Q?3QWYOaLFOcLAhx19wn7Z5BFH3zu0Rkf9NIsFx/iWa1UpaG4v+vgP01XyGToV?=
 =?us-ascii?Q?AOW6rbp0HgKEQN6iCbC5+OONP4IdXMxvvAYoVZgJeSmyYCX94ibYJsWE0DKa?=
 =?us-ascii?Q?HfaVCkcb2hKu9XvTt41OOa+uNU7VRtfuWvAr8KHvKs1qlvwgBooxgrRjG4mQ?=
 =?us-ascii?Q?Dj3OQwn9PXELpmHNb4H1YPp392rJGsUgwom0R61JQwcL3dw1Za18xZY0YBAL?=
 =?us-ascii?Q?OLndkGcX7HCy///erBtFA8QJDrHuBZKdVq42U3zn681hsmwosPH56JbGm1dw?=
 =?us-ascii?Q?rTVzFjCQRQqi34sa8m5euacpUraK4D5b/UG4j5zk3x3cU3tK/Gm6Egt8XpAz?=
 =?us-ascii?Q?LrLG++eCUONk/5D6Ky53lDis2rrfRsutKgMvClUMfONSzCB6RcI1uGvV6hGM?=
 =?us-ascii?Q?TcqDMterhNlnRInzBAZHYMlKDERwne3IYgmdfStHYbjDBXlEIeXDtlnhzaih?=
 =?us-ascii?Q?TUgt1B6Zf+QnB9ia62p6qTIx6Uy7C91ftIO/ei+xyPCQHz8zb6VPVzQsvswR?=
 =?us-ascii?Q?KV3RbpAr781o7VuKqIGekS4j18eZRUoLO1YFd9eIrBkpipVV8JVqLLaFdKJ+?=
 =?us-ascii?Q?fzk5mlmNBuW0sj3PGjhYT/FnEjJ+n0RUOKGdqaDW8y/MPXfpHb2AcCuaEbk4?=
 =?us-ascii?Q?cZh8N+nteAT0D5E6NRmd+1qJd2vyHEpSJCSBGgtwUMJg/BXwYDZRulsDLxrB?=
 =?us-ascii?Q?xrsYcs1wV6FRV0gqSUed5VcV9xF5LioZSgLuuoM4T4tO76gUL130GmfnoOaC?=
 =?us-ascii?Q?ReHUX17H+Tz9Sx0Y3w3ueWzEc9qqVS0kp8p5pLGLpACxrMmEnGfY1rXNgknG?=
 =?us-ascii?Q?oeMOu4VXkzN0IPyzirGu/KWKr+72+TIOIKGkyLBLzyW7+e8ZsDW70XajmPhk?=
 =?us-ascii?Q?ztUWH11OwALDcOb9YdyomlJ3KnaN5ArRA/lTRuIil80XmYQB6EcfARHlUrWs?=
 =?us-ascii?Q?ZwEkiDDwUeB8H3jBZjuyNN5ixwH7m5YWrFHiWzFcdUD6RW8qxv12Gqjlmqxu?=
 =?us-ascii?Q?cAwqSby3TKGeLxNZ9ohIJsi0mXALWzkWUHGz5OI+qweBskP6UkGByXqTDKu1?=
 =?us-ascii?Q?w0MQQ+eJGQZ70HVTGfuCnJhMCYV9Mccz3buCZDrzgq3sXEkNvpfhMKNFW7y7?=
 =?us-ascii?Q?RkTqyqw7KQEAm4YX7Kii1XJd4XSehj+pK6dUW4l/x8s/6pq/irTHW+J2uI/W?=
 =?us-ascii?Q?OMGJ8a6+8fqk1Ns/2bmd3Tzh8oYNJaxAWIWP2eK4bGcUpnsDTuKu0fIKol7F?=
 =?us-ascii?Q?d3gkL29Z5GC64X82RT1a8XHGz+xb+XO92oEyCnAQKF44AGLsSi2miV3ZW03x?=
 =?us-ascii?Q?MQLvDbweEg=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0aa3325-e3ee-4a2f-4481-08da0e0a8144
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2022 02:52:30.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WBm5I7oAsR0sKsDKG9RaNsH87qai+ZetnazvumKN/TCWYnxb7qLErishDUHT3YQbbqveweWyO9Bx+zeiZEW6cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3622
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

If bitmap area contains invalid data, kernel may crash or mdadm
triggers FPE (Floating exception)
This is cluster-md speical bug. In non-clustered env, mdadm will
handle broken metadata case. In clustered array, only kernel space
handles bitmap slot info. But even this bug only happened in clustered
env, current sanity check is wrong, the code should be changed.

How to trigger: (faulty injection)

dd if=3D/dev/zero bs=3D1M count=3D3 oflag=3Ddirect of=3D/dev/sda
dd if=3D/dev/zero bs=3D1M count=3D3 oflag=3Ddirect of=3D/dev/sdb
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm -Ss
echo aaa > magic.txt
 =3D=3D below modifying slot 2 bitmap data =3D=3D
dd if=3Dmagic.txt of=3D/dev/sda seek=3D16384 bs=3D1 count=3D3 <=3D=3D desto=
ry magic
dd if=3D/dev/zero of=3D/dev/sda seek=3D16436 bs=3D1 count=3D4 <=3D=3D ZERO =
chunksize
mdadm -A /dev/md0 /dev/sda /dev/sdb
 =3D=3D kernel crash. mdadm reports FPE =3D=3D

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 40 +++++++++++++++++++++-------------------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bfd6026d7809..f6dcdb3683bf 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -635,19 +635,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 	err =3D -EINVAL;
 	sb =3D kmap_atomic(sb_page);
=20
-	chunksize =3D le32_to_cpu(sb->chunksize);
-	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
-	write_behind =3D le32_to_cpu(sb->write_behind);
-	sectors_reserved =3D le32_to_cpu(sb->sectors_reserved);
-	/* Setup nodes/clustername only if bitmap version is
-	 * cluster-compatible
-	 */
-	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
-		nodes =3D le32_to_cpu(sb->nodes);
-		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
-				sb->cluster_name, 64);
-	}
-
 	/* verify that the bitmap-specific fields are valid */
 	if (sb->magic !=3D cpu_to_le32(BITMAP_MAGIC))
 		reason =3D "bad magic";
@@ -668,6 +655,19 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 		goto out;
 	}
=20
+	chunksize =3D le32_to_cpu(sb->chunksize);
+	daemon_sleep =3D le32_to_cpu(sb->daemon_sleep) * HZ;
+	write_behind =3D le32_to_cpu(sb->write_behind);
+	sectors_reserved =3D le32_to_cpu(sb->sectors_reserved);
+	/* Setup nodes/clustername only if bitmap version is
+	 * cluster-compatible
+	 */
+	if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUSTERED)) {
+		nodes =3D le32_to_cpu(sb->nodes);
+		strlcpy(bitmap->mddev->bitmap_info.cluster_name,
+				sb->cluster_name, 64);
+	}
+
 	/* keep the array size field of the bitmap superblock up to date */
 	sb->sync_size =3D cpu_to_le64(bitmap->mddev->resync_max_sectors);
=20
@@ -700,9 +700,9 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
=20
 out:
 	kunmap_atomic(sb);
-	/* Assigning chunksize is required for "re_read" */
-	bitmap->mddev->bitmap_info.chunksize =3D chunksize;
 	if (err =3D=3D 0 && nodes && (bitmap->cluster_slot < 0)) {
+		/* Assigning chunksize is required for "re_read" */
+		bitmap->mddev->bitmap_info.chunksize =3D chunksize;
 		err =3D md_setup_cluster(bitmap->mddev, nodes);
 		if (err) {
 			pr_warn("%s: Could not setup cluster service (%d)\n",
@@ -717,10 +717,12 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
 out_no_sb:
 	if (test_bit(BITMAP_STALE, &bitmap->flags))
 		bitmap->events_cleared =3D bitmap->mddev->events;
-	bitmap->mddev->bitmap_info.chunksize =3D chunksize;
-	bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
-	bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
-	bitmap->mddev->bitmap_info.nodes =3D nodes;
+	if (err =3D=3D 0) {
+		bitmap->mddev->bitmap_info.chunksize =3D chunksize;
+		bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_sleep;
+		bitmap->mddev->bitmap_info.max_write_behind =3D write_behind;
+		bitmap->mddev->bitmap_info.nodes =3D nodes;
+	}
 	if (bitmap->mddev->bitmap_info.space =3D=3D 0 ||
 	    bitmap->mddev->bitmap_info.space > sectors_reserved)
 		bitmap->mddev->bitmap_info.space =3D sectors_reserved;
--=20
2.34.1


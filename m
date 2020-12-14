Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1BAC4361B
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 14:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3220820643
	for <linux-raid@archiver.kernel.org>; Mon, 14 Dec 2020 14:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395170AbgLNOx0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Dec 2020 09:53:26 -0500
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:37590 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725976AbgLNOxQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 14 Dec 2020 09:53:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1607957520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pSCyZCts9EGRSYJbIfOhl0iZJVovrDiwTd9kqg3h0aI=;
        b=S8RLy3TsQeaJINq0pDrfTRHhLxm/C+vMvZch75N1Cs4z9W6rA6kTjrqzPTtUxbf11nBPR4
        QDVHUaA5ve+QXFzCSMVI3u91Rj113CNKvVBgY3EOGfavnn8dp/o4mm6/jkneX6B6jueSzY
        4hLq93bObk6lwx4x4pl+0CwJf9GALvA=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-37-43sKnpiQMc6X2Rvt6Po02Q-1; Mon, 14 Dec 2020 15:51:59 +0100
X-MC-Unique: 43sKnpiQMc6X2Rvt6Po02Q-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEjAv0d5ONHA0eXzus5zwfK7Qhphet3ivSG8CmsrmdY1ZU3uHurPh2UkmlczooDk+UdRrnvSRM3RLNeEz9KM6SH29IvpX8bxrwIWrwnzsm/uMuVqjGHVrbrCUaB3MhGoL34Kb9tNUXyuQOvuDUm0XIKTMQP1neZBbEQIjds1QRc5wvJA3GT/Rk2+LRii+ocqOK/xuPha4GLM3spPpg9WJfiX2vMC6Rtwx5tqIzdC7/rU1wCJd4Q/vnkVTpvvrPN/2OD0n2rww3mZSOoK60h7LSMHIFwa3AviMB1oM0lgtwUKMI09SDrGw9C9BdX11gCB2PcsrcOyd1N9mgoEHdn0HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=deb5vV8M0ZVOyV6wX8iAYedyxr553b+Y1mZCgiMj7F0=;
 b=FSuqQKnyojj8nd/Xn9R9KLM9oyxW374yreRAlSikoUCz/aV9/hGZszfm+aF5K3r6GiQcD43qoADKaS9OuM+iY/O7jEXHRtQGRb37v3OsVFu3yA4Er3dYv7mrka17DIbf20CW424loTIPqCebfVnD/vgwowXAY9+1gicKU1vPfLGtjXxT/w2a2pwkyvircjs5Ism4tGUpXkD0kWZo5wOswN3l7FSbas6EnJ3gkbvB/SN2r7YIw07Lr7qBEo0xBS+avcl+EBF5hltW3F+R3zD86X4KmYSh2bhSPCmP38etfL2IKrfYybDtO1svbifYQtgcwU4p/ViGb2XrhyRU4O+kzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB6708.eurprd04.prod.outlook.com (2603:10a6:208:178::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Mon, 14 Dec
 2020 14:51:57 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1553:f9c8:be4b:19fa]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1553:f9c8:be4b:19fa%6]) with mapi id 15.20.3654.025; Mon, 14 Dec 2020
 14:51:57 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     jes@trained-monkey.org
CC:     linux-raid@vger.kernel.org
Subject: [PATCH] Dump: get stat from a wrong metadata file when restoring metadata
Date:   Mon, 14 Dec 2020 22:51:33 +0800
Message-ID: <20201214145133.25896-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [39.91.2.107]
X-ClientProxiedBy: AM0PR04CA0025.eurprd04.prod.outlook.com
 (2603:10a6:208:122::38) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (39.91.2.107) by AM0PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:208:122::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 14:51:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e795334a-ec9b-46e0-771f-08d8a03fce54
X-MS-TrafficTypeDiagnostic: AM0PR04MB6708:
X-Microsoft-Antispam-PRVS: <AM0PR04MB6708103D145AF1DEB4869F52F8C70@AM0PR04MB6708.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KhZ5bapUwRD1pJAX43yKBWTjkhbXa962CfSBUqmxrEORCRsWEoWIIyBwL1jOekRuqNiUJMVZN0OcWlSAjXORkUgDCYkRf2N7KNPflnsevUDV5Q1lVF0jKRR3RUYc8h2kJeGzfYSrKR5B6LTLGqm00ssefqlTY0ufltK8r5mDr08Q7Ul7MYnGrHyIT7RIzb9iMUb4cFI+NPHIihw3EMYozFfiqdwO4VfL+w1hExvChJ0WYNAAimag23od2x3CWv1C2pgN1o124zrzStrhwjJbxJQVa1c81VdJv7D2zfY1KDM2YKIfyd/RQLHekwQZoUqS44BNbiACwXKTupYJzqhyGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(136003)(376002)(396003)(956004)(6512007)(36756003)(8676002)(8936002)(4326008)(26005)(52116002)(6506007)(6486002)(186003)(16526019)(5660300002)(86362001)(6666004)(83380400001)(1076003)(8886007)(44832011)(66946007)(66556008)(478600001)(316002)(2616005)(2906002)(66476007)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?5uQLmvTphLhAtsnui4ddWdgNPpiIBEPrvY+cu/nszQfD3KAxBV1XfMdwP0/r?=
 =?us-ascii?Q?IB29B6mGz0nI87SPPtMZF+QGHYcsluePzDR/JG4cxYybAyMEa3NRcJ+KQhce?=
 =?us-ascii?Q?7JQYKhCFtJMFahao7AarwKczmh02FOTAOVVK/bFcEdyvso29aWd1LG7JvQdB?=
 =?us-ascii?Q?20B9kxzc6H+lc+TUNiRzulfi7PBGzCeiR4yDYdqeGC05WC7b0gDuULCDm9Oa?=
 =?us-ascii?Q?qlCcWI+FF0FE851XdGTOeHFC9nO4N3YAuLKceLhEyr8HMzJR7S5rHemTN+Me?=
 =?us-ascii?Q?D5KB5KMS8mxljpsP2IWuRpEut0bEQSaoESabIzKsW/hmBQdr5dBLF8NQgNYV?=
 =?us-ascii?Q?6rb+f2ag7fDPUDB6n7vH1T1LaTd0eMCs4a09Y80N6dyYmgFdl7BJDIrzDXWB?=
 =?us-ascii?Q?4toG0dyrRR+eQ1KeW5OpFxRbYFdyrzq5eRESqO/n4LQdpXL0zhcGrmM1inHE?=
 =?us-ascii?Q?QTbDJzYA1XZ3YB3tlWzP00p0zl1H/cfdLYQoNEZEs9aO7It0iGVbXRD+8j37?=
 =?us-ascii?Q?17PG4g5wYyWEaz9c19GCxWfthUvBZt4dKZaoGvORbhcsSdB6Eg/hMXQq6A/n?=
 =?us-ascii?Q?ZSrCLCiq8Qjgapcmmihlvx8XVcDrZ3Gde4018gzQdx+2Ry6tkdsyeETu6HVj?=
 =?us-ascii?Q?D08Yyx0zW8NPZp88WAvkCo3LuPu5De+hChlDw9x+JSw4ERZVY4eR83LA7Ijy?=
 =?us-ascii?Q?AF5oWc5/r3hJ6VOjAAlJXRW4bIXTjRrfCcvAmiWeusFcFjP8fCK2BHWF0De0?=
 =?us-ascii?Q?LGg7wL7h3xnYCQk9YuLmtl2xBxcjMTYN6Hdpuv+D2quMo57mvpcv0aGhSUGh?=
 =?us-ascii?Q?uhQ+F1Jc0spjv2SrnUen0krt+yamDgdByMZDsvQPGa3h+J0F6/3C8M6SnTvn?=
 =?us-ascii?Q?GjYXJHTxi7TZWqNMf7trKoUI9sBRz5xYFRSR+E+hlVr7TNGMlIPYC8mmpFbu?=
 =?us-ascii?Q?OCDjNhFB+PAiZdKGMKCGIZr5RGD7iiqArML9MqHBx9g=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 14:51:57.6761
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-Network-Message-Id: e795334a-ec9b-46e0-771f-08d8a03fce54
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vpcqRg79fBzbaMYbZuZ7VC8q1hzCllY6c2ZzSQCj3wVvB5BZ00fKoCBAjEA5dnAZsIzq5R3H/0FznM9vxVWQdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6708
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The dumped metadata files are shown as below
localhost:~ # ll -ih test/
total 16K
34565564 -rw-r--r-- 2 root root 1.0G Dec 14 21:15
scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-3
34565563 -rw-r--r-- 2 root root 1.0G Dec 14 21:15
scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4
34565563 -rw-r--r-- 2 root root 1.0G Dec 14 21:15 sda
34565564 -rw-r--r-- 2 root root 1.0G Dec 14 21:15 sdb

It reports such error when trying to restore metadata for /dev/sda
localhost:~ # mdadm --restore=3Dtest /dev/sda
mdadm: test/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0-0-0-4 is not the same
size as /dev/sda - cannot restore.
It's because the stb value has been changed to other metadata file in
the while statement.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 Dump.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Dump.c b/Dump.c
index 38e8f23..736bcb6 100644
--- a/Dump.c
+++ b/Dump.c
@@ -272,6 +272,11 @@ int Restore_metadata(char *dev, char *dir, struct cont=
ext *c,
 		       fname);
 		goto err;
 	}
+	if (stat(fname, &stb) !=3D 0) {
+		pr_err("Could not stat %s for --restore.\n",
+		       fname);
+		goto err;
+	}
 	if (((unsigned long long)stb.st_size) !=3D size) {
 		pr_err("%s is not the same size as %s - cannot restore.\n",
 		       fname, dev);
--=20
2.26.2


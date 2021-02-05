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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B25AC433E0
	for <linux-raid@archiver.kernel.org>; Fri,  5 Feb 2021 07:13:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48FCA64FBC
	for <linux-raid@archiver.kernel.org>; Fri,  5 Feb 2021 07:13:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhBEHNS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 5 Feb 2021 02:13:18 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26966 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231324AbhBEHNL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 5 Feb 2021 02:13:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1612509116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=WLyRY/fnotqT5jgWrFCREYQIORbKznpFCRBdNHQZuDc=;
        b=GiHYqOlqnHL0POkz3O/5hONFSl5YIHZGItcoyLZ+bIzH/iOH0KeIiB5VNxOV9iWE4M+vYT
        MPxv9YtpRWslsiiHW/6gnwJ0QCeMyeUwrG3U+Xq0OeMpTBaRj5k5qt/YaWs/aKu+Oy6jqh
        dZ/V7DHGgMzTHSs57azyFuD07E0NSDw=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2104.outbound.protection.outlook.com [104.47.17.104])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-33-of-COsK9P6ielwWEWi15Kg-1; Fri, 05 Feb 2021 08:11:55 +0100
X-MC-Unique: of-COsK9P6ielwWEWi15Kg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dbPwWo+4ZpQpn/CPjxpUTbsHLd5WUsMl0CQdwdl4lhl7eX1LUnI8rVEMqLmTCzDVfBsCXZuTgUaIi9zwCmxSKrCC08MCNhDWAMTRd9fdRFdMy5PhM9rjh5e4fNHP2hY8FJqnD3PyG4R6DAhPa4bewh983g6oQet3o8+tUl+zl/mZif9RKBFdLDb/d89OpZ813UqErtDyzVoJs7vIKdLoqYzValeMF51Q69ympDGFrcdNpaXMqOTwkxRWiQX7pGj6vMmzUSkVQ/c3wgljKhpvuJW7TQaw9SakrTO3/8nvGXNRrszwxBJj+5fNWEZVwQ+HTm3K8dWpzharH1N72FvD0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=erRtnj5Kg38LjPpcLUA9UC+oSfIR9heXO34Nbc9+fck=;
 b=bKdiO32j3714Ik+acewLi3IShpLTN7fRpgY5BuBGB0uy+RxmkMwneQzUn6+R1Z6xq5kIvNc59hMiq+3xI6ddsBCmS9BuJNAWVdqboS4prww1c3PgyRr+W32mDxtuc/WD6sSzP+Cvw/VmNZuKsp0mKDRJ1Ni7kole49JrdYJj/0ESCuX1W3oIvdWX1ZGU/phg6HCkItp6OyDuPw+uViNiKOBB3sWD4LLs5bF41KPMqO6LXFwuCYnC/RqaVFC0UHVFUIHbG0BiN0iDFZ5dvr2WbVRJbM/TD+wD7IE3RTl6SDiV+eS8Oe01W4Oi4hewvHBJW9dTxfAOsSTV/DzEW3VCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB4740.eurprd04.prod.outlook.com (2603:10a6:208:c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 5 Feb
 2021 07:11:54 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1d6e:70d1:7189:f2e4]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::1d6e:70d1:7189:f2e4%7]) with mapi id 15.20.3805.033; Fri, 5 Feb 2021
 07:11:54 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     jes@trained-monkey.org
CC:     linux-raid@vger.kernel.org, david.chang@hpe.com
Subject: [RFC PATCH] super-intel: correctly recognize NVMe device during assemble
Date:   Fri,  5 Feb 2021 15:11:33 +0800
Message-ID: <20210205071133.11139-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [112.232.229.111]
X-ClientProxiedBy: AM0PR03CA0093.eurprd03.prod.outlook.com
 (2603:10a6:208:69::34) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (112.232.229.111) by AM0PR03CA0093.eurprd03.prod.outlook.com (2603:10a6:208:69::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 07:11:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b21c6329-5c18-42de-169e-08d8c9a55128
X-MS-TrafficTypeDiagnostic: AM0PR04MB4740:
X-Microsoft-Antispam-PRVS: <AM0PR04MB4740F63B11C7052B363FB6F1F8B29@AM0PR04MB4740.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNNEOstijG64Otc7E7WLfgPOT8iFraB5kHnd741uEUIk9BrBXb+YEXkj6RJKt0cA6O2ml0IMz4Lz2lKnsDBvFwlSuS1E57BOoElSPVpp5hPINstBYG6jvZ2lVyg+UaIyfzvk5Aid36WgEd1BeN9z9S4CttbN5xUeY9sOErVx70c51aQn0SRtx5Z+KNRSbyVxUsd4Z6UqMuh9pZ7UJvj2izqC6HjFxS8Zfkm6KyDJz/QHZzKfhrtPCckgtpeYCb7SPP8uhbeYpF8gVoWvzXCe9c+hG7n0UZVu4qJB9W51l08c6mWz06MfyAJxCAK1N9ppk9XWTx52yVsJn3byoWBlWcZvG7+Jakt+JPG7kBGIM5jqwkAIXLtNalUyijz7hsvPqZP0Ay71TXU8eAZzewgSnU4FftE3ePWjKDdL/1Y3rc7mivedSYP1heafUt9H1sBXkJB3a9W/RKTDkfuljbCnnWNgxXnUSwcU7GTO89rUUnFPLJISL4drx/luVv0yZ6PVHgONC39H5nemHdEdcIFUiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(136003)(366004)(396003)(6506007)(66946007)(8936002)(6512007)(6916009)(44832011)(6666004)(52116002)(16526019)(4326008)(8676002)(5660300002)(66556008)(1076003)(956004)(2906002)(478600001)(316002)(2616005)(86362001)(83380400001)(26005)(8886007)(66476007)(186003)(6486002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cSObyLZGpZwmB1e438jzBf7NOgIm2/2N+eD6b4GR2D9gBJdKq1ZOZ17vkkAU?=
 =?us-ascii?Q?F4/+KVyzL7P/qlPebZ1+cUx6avDExomS4J39GjTgV8gY7933XAkooH+IVl6g?=
 =?us-ascii?Q?Uk4nlqo6eXFylsdiSAKCLYQbLY/4eNp0GxHWiULDRGG/YhZdpPgIuzDNEIoL?=
 =?us-ascii?Q?qqEP3/QiM9/bp2TV6t0Za5WiOXNp6sqQDgqfGGdSl6cBvf5rDpNuoMJ7AR1G?=
 =?us-ascii?Q?bNksmG8KyFCXOetWu178yoLLNzNnO7jm1vmUcwIvrV/LlTUv/e3XYfzqoaeK?=
 =?us-ascii?Q?/qoNqrcp6qL5pVYdj0eriFfkMPNX0NdOUiuf2gFIgjbC1EsdYoXtg5byF+wn?=
 =?us-ascii?Q?jtKHkwqqscCLyiDi8RhV2b+3San3CiPci1P+y7yIjiQL+hLq50bVK4pjNCfM?=
 =?us-ascii?Q?KQSHB4tWuCY2nBed7EigSJ5yGKSG1tXqrTcOVlLDN9KeFDZxshvon6z+zYmO?=
 =?us-ascii?Q?Ae7Y7U4t9NhVnhNa3BA+nBpPLfrUsyorkK+rXhR6JUvNKi9PGeZswaLee+YT?=
 =?us-ascii?Q?XSRAkSe8/c8VURtBk4ggzMQ3NklF3cK9CXzWIW0Z1ff6/ecrgrp7OJMct53y?=
 =?us-ascii?Q?vxCI/i1tsyBn0dx2ynlYPcJRpEqC5hSUuOdK70V1V49GrBX+syGdoVmbi3SC?=
 =?us-ascii?Q?JQUVdQEhSUBtLCPMS6+LpabEnJiyjjLW5l/Tjs0Tnw1d/RU9bUBNp0gcCV/l?=
 =?us-ascii?Q?3qTU3wdgRO9V0AoHEXo0HBcg1UN0hWe3BrEk9M8k9KkdFQWK8cSqT16US28c?=
 =?us-ascii?Q?GP0PUXzNzmfCyV56wnkc54bFTH3L17v+mvBnL3ZYgc2MFf57NwroOj+TH0do?=
 =?us-ascii?Q?fB3XDSmwb6xV4kJnboo0A5mtyCbdAZk6ulryHD6aA4C6kDUZbO5OazOroi79?=
 =?us-ascii?Q?gx96XzKVskYGyKvYV7LDsaWfvk9GKbbQbJtfPgPlHM4UqWZ2r2b4Y/Q6xoJM?=
 =?us-ascii?Q?Z0Kua/RdDrJmtt7tsfNiW0WE3pHY7IIX9pvDU2qvmqGpaOzt4w8XcvDSjmUb?=
 =?us-ascii?Q?k29iz8zdHs/AwoUEv29bm+MOwtiP+9NCwszk3jXV5eweMUztPwTF+Svm6I84?=
 =?us-ascii?Q?l9nqHDh/SiEGpYTbyKFf7onJ40RcTW/nhz1mD7ocn52D/xlD3ZlAN3j6FYKv?=
 =?us-ascii?Q?C1koEUKAHri5BBE/mqA75GEuUsWZPpz6QsiajbuuVTJCeaY9dc4CSWWW4I4z?=
 =?us-ascii?Q?k2MY+nxP4g7+WHUQZwMBpWlW960fwW1ql7SPuAD3lNhv5SVzTjZM3GSyXFUA?=
 =?us-ascii?Q?RqlzCYwjP2yvcGgFd8wojSDOqjwHLw9c0nmJMCE26GRxYAh+6hBSfiIAW2a9?=
 =?us-ascii?Q?G64JklR84O+MhyHZWimqJKFj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21c6329-5c18-42de-169e-08d8c9a55128
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 07:11:54.5971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EWrXqpNEVgYV2HU0mzHfrZL1vmDOPAfQg5zwV1Q6gS3TSuCAgbea94cK3N1ajXY8az17w3q81OuxKgraS8MKxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4740
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

We had a customer report the following error while assembling the raid
device, which is created from Intel VMD configuration of RBSU(bios).
> sudo /sbin/mdadm -v --incremental --export /dev/nvme0n1 --offroot
/dev/disk/by-id/nvme-eui.355634304e2000530025384500000001
/dev/disk/by-id/nvme-MZXL5800HBHQ-000H3_S5V4NE0N200053
[sudo] password for root:
mdadm: /dev/nvme0n1 is not attached to Intel(R) RAID controller.
mdadm: No OROM/EFI properties for /dev/nvme0n1
mdadm: no RAID superblock on /dev/nvme0n1

It's because in function path_attached_to_hba(), the string of disk
doesn't match hba and thus it fails to be recognized as a valid device.
The following is the debug output with this patch applied.
mdadm: hba: /sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00 - disk:
/sys/devices/virtual/nvme-subsystem/nvme-subsys0
mdadm: NVME:tmp_path:
/sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0
mdadm: NVME:tmp_path:
/sys/devices/virtual/nvme-subsystem/nvme-subsys0/nvme0 - real_disk_path:
/sys/devices/pci0000:c0/0000:c0:00.5/pci10002:00/10002:00:04.0/10002:03:00.=
0/nvme/nvme0

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
Reported-by: David Chang <david.chang@hpe.com>
---
 platform-intel.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/platform-intel.c b/platform-intel.c
index f1f6d4c..e3c12a3 100644
--- a/platform-intel.c
+++ b/platform-intel.c
@@ -707,6 +707,17 @@ int path_attached_to_hba(const char *disk_path, const =
char *hba_path)
 		rc =3D 1;
 	else
 		rc =3D 0;
+	if (0 =3D=3D rc && strstr(disk_path, "nvme-subsys")) {
+		char tmp_path[PATH_MAX], *real_disk_path;
+		int len =3D strlen(disk_path);
+		snprintf(tmp_path,"%s/nvme%c",disk_path, disk_path[len-1]);
+		real_disk_path =3D realpath(tmp_path, NULL);
+		if (real_disk_path) {
+			if (strncmp(real_disk_path, hba_path, strlen(hba_path)) =3D=3D 0)
+				rc =3D 1;
+			free(real_disk_path);
+		}
+    }
=20
 	return rc;
 }
--=20
2.26.2


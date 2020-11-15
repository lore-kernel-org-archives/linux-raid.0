Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EEB4C2D0E4
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 063C4222D5
	for <linux-raid@archiver.kernel.org>; Sun, 15 Nov 2020 04:31:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="T6FYPEKo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKOEax (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Nov 2020 23:30:53 -0500
Received: from de-smtp-delivery-52.mimecast.com ([51.163.158.52]:26060 "EHLO
        de-smtp-delivery-52.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726136AbgKOEau (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sat, 14 Nov 2020 23:30:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1605414647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=q3UoibF8nLc1RENQcGlAVHm2tIlRXLpRw5uwEgRFuck=;
        b=T6FYPEKoucahO0LDM8lOmN7pIKiX6jY6DmegjoXFlWMk+mlg+36Sea0gZYHSOBoioMA6pE
        81055AVK0jPEppaRsmEV0LvQVv7YVOv0wu2Cz8o3+XrANZknOXfmaL/Fw3lN5HgT6Gu+AP
        +k5OEu693WroTpEOupaI6wZN+xZP8tw=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2051.outbound.protection.outlook.com [104.47.13.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-45vPEpLMMPOWzi-2kTqWhw-1; Sun, 15 Nov 2020 05:30:45 +0100
X-MC-Unique: 45vPEpLMMPOWzi-2kTqWhw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6Pq1JqAsr14CVmFWly9kB+BzdFGUur1tOJgYLu8oGevKNQujd4/DCZClGW88DSO2HhNchCqjzoR1ASI90h3lmsYthBuy1pvCiAo9SgiHCdiuUF158QTgyywVvRYvJ4gNfSnd2a0RRcF4kxMOmpFl2p9fAkD2LccgJxGKg4klYpGCduOxNOGDTemN2QCHnxKbOEB/Mh5hCORtpTDUYaiTk7inXAsupqgIsdJ0/dstgZtvBPXt09G3sh/BZK2COBxe1VuLzq9CAFRcqzKnSMXAQWBbyjvactO5mGv6XjbiyGfHuwNMTNzMcVuhGD6+bQH91l5podT8K4B28afW0qOyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3UoibF8nLc1RENQcGlAVHm2tIlRXLpRw5uwEgRFuck=;
 b=JJabx+Xt806tL6h8j4jljrao3u5w5oQVKOQGHYLYm4IOSscFADGb0JO8/vyXM0RVh0Qw+CmYYBAuM/+izZQ3EkyJ3O88OS3ufkE2hhxGd3LRh0A0WBX++QlvitHX0Qc/Dlw43DwHG0+QGHj1Bsh+6agVFYatb+lgUZAnf2fhNDYvLtaO4DhuwBFWjPrbI5xaIV5U3/gUQvmIlFq7pQ6lA+dgvvKRaId9vqNBNywARoFxTquoKl/BgFBl7+AF+GUDzIm8WT1nWtJNMj0ONShz7HILJPfO3QvwnowfWQZuAUXbtwnfC821EB8mhVQMuxzVLeEGOKauyf2ojTkBDbNBVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB6PR0401MB2438.eurprd04.prod.outlook.com (2603:10a6:4:33::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3564.25; Sun, 15 Nov 2020 04:30:43 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::1c22:83d3:bc1e:6383%4]) with mapi id 15.20.3564.025; Sun, 15 Nov 2020
 04:30:43 +0000
From:   Zhao Heming <heming.zhao@suse.com>
To:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, xni@redhat.com
Cc:     Zhao Heming <heming.zhao@suse.com>, lidong.zhong@suse.com,
        neilb@suse.de, colyli@suse.de
Subject: [PATCH v3 0/2] md/cluster bugs fix
Date:   Sun, 15 Nov 2020 12:30:20 +0800
Message-Id: <1605414622-26025-1-git-send-email-heming.zhao@suse.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-Originating-IP: [123.123.135.93]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.135.93) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Sun, 15 Nov 2020 04:30:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75f88900-ceb5-4edb-707a-08d8891f366d
X-MS-TrafficTypeDiagnostic: DB6PR0401MB2438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0401MB2438F1F0EEB095B078F44E8797E40@DB6PR0401MB2438.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WgHmpKHWndZo1YhHMF1gA30gyxwU/cEnKUrP6I1uZgAVoH0/EeMVJRgB53KNZfHb0CLm0xQxMO9e3e15bCfe7fDR6HdIDDxKJ73yZ6lnuRE76qaPlWvLoPXa/kTlxrDtkxtPIETv1FDzE9TP0NehIdORIWqHoDVMS7kqH5veJh9HrvlXdWuh7LBAhn1FyPW8CHdg4qB4M2he12Z9HSq/YEsj6O6jvwnoF3wjtyF1HYVXd2td/TZyqsXOKd30KE0jr5P0PFFXpcOJpwW0NXnUQOz+gcsZetr3DZAzGG7i1r/kANClTg0Ex03ZizT/BJHoNv7KqY2uPHQl+fev/Hp3U5DYkW37NP6ngCvTfoskydU/nSlARYL/vnenwkO4VJOz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(376002)(346002)(136003)(396003)(8936002)(83380400001)(8676002)(8886007)(86362001)(2906002)(6666004)(6486002)(6512007)(6506007)(52116002)(66476007)(66946007)(36756003)(316002)(66556008)(956004)(5660300002)(478600001)(186003)(16526019)(4326008)(2616005)(26005)(9126006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: iCI/f6oyE7TlZeWOfm5NOvBTwDqJCmSXMb67xpL1+G2479Hn0FedSL08HW9CZiv+MIO5CbXhBK6zivP5vANHaCxmF7e9B04U75Rrq7csOLsFG0YKaT9S2BW8Xx+DOuSvpIgpeWqGmOdiSiJofFxYse01T8LXaQ6uKKbEyB7sujq1X20zTNj6oiBwlHclX1rOAGt9aRmQmH1EexvmNahdt1VbnaPXr5c/nopdltcVXCXfryu2b7UrK+GYk3AGGtzDuMBIsdFYXOzSsuMBMJZEb15hnWIW15o+Wgah5ZnZIFbGNO/V91+05fIOkhXyKDVIKYmX8LB/d7nZXaZWuJgOmn/bwS+ykr4OgCa2UKQUwvYbkrcCy0Oksfut7VZUWCDBPuDfyCH/hst3RuyDSSfYkhVe04F8zc/er7k4EahUbDkAMvaMAqkdAKBMjdMRjFcOg6MpWaYA0TmHgEa92pRYD/HpOYu9c9a7Wc3iVDxWea/idNgz4am0VJz9qwjAytH8Aoq+EShFN/C3v1BBEoIP5NsKY77VYUQdWVfflt/pmdIkgfAcuUvHbCgwqNcZEtugJYMUnl9SJEn029oSF2wRiIOl66CnJ1tez7AGUSclN5sJ4s7YQQKQ1auoMejvwpUhSIZdbl/Zc4W+Fi+D3aUYXg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75f88900-ceb5-4edb-707a-08d8891f366d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2020 04:30:43.1233
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XthyICL7i66L+/Z2BWAIhSuKRs6NzxAvulw5OO3ilj7S72qJ1FHCnRZU4c7+sm+LPbdoRRPmS+FUHo+7c5OJVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0401MB2438
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello List,

There are two patches to fix md-cluster bugs.

The 2 different bugs can use same test script to trigger:

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
 #mdadm --wait /dev/md0
mdadm --grow --raid-devices=2 /dev/md0
```

For detail, please check each patch commit log.

-------
v3:
- patch 1/2
  - no change
- patch 2/2
  - use Xiao's solution to fix
  - revise commit log for the "How to fix" part
v2:
- patch 1/2
  - change patch subject
  - add test result in commit log
  - no change for code
- patch 2/2
  - add test result in commit log
  - add error handling of remove_disk in hot_remove_disk
  - add error handling of lock_comm in all caller
  - remove 5s timeout fix in receive side (for process_metadata_update)
v1:
- create patch
-------
Zhao Heming (2):
  md/cluster: reshape should returns error when remote doing resyncing
    job
  md/cluster: fix deadlock when doing reshape job

 drivers/md/md-cluster.c | 69 +++++++++++++++++++++++------------------
 drivers/md/md.c         | 14 ++++++---
 2 files changed, 49 insertions(+), 34 deletions(-)

-- 
2.27.0


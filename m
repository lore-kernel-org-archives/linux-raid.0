Return-Path: <SRS0=E/bP=CE=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59DFCC433DF
	for <linux-raid@archiver.kernel.org>; Wed, 26 Aug 2020 15:17:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 319D42078D
	for <linux-raid@archiver.kernel.org>; Wed, 26 Aug 2020 15:17:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="fmDvMQio"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgHZPRx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 26 Aug 2020 11:17:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([51.163.158.102]:49658 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727895AbgHZPRw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 26 Aug 2020 11:17:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1598455063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=83nDywxKZiZog6Nkd1X8CCOcmHdfRF/bXoRjPe6I/8g=;
        b=fmDvMQioQOmRz4v8r7xzYGi0ESAp0rd3E8wasqFhlhEZcg5ih/l7tD+XEE4M9TSvKHpMVH
        kSn10sso0+IYzh7OKds+WW72Bls2uZL5tAma/YF9NyoC0n+sb0ZC040yzlKxbDvWsqOmvO
        jY413d2EeyspFJakMiBJGaQTmKNGHnA=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2112.outbound.protection.outlook.com [104.47.18.112])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-1-Kr8bFC-4NNy2G8gVAsMwKA-1; Wed, 26 Aug 2020 17:17:42 +0200
X-MC-Unique: Kr8bFC-4NNy2G8gVAsMwKA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IxH+9AtTMMPo3DR+yqOyBU2LTvbXpMLJ9WEUXDShsiv2Gzq6c/VViseznt7cHc1iYJOg+4UC7g23YiLZoHLKy/tWmWJV4STmorclVPh70hiYUTOsQ84pmFqOkHIQJby+1nczWKrPuzhWi5JPtzrXr517oRkCZGBqHK/Ob3vLSoZsLQd94vdSKJ4RgfRCrwlutpoW7/7uTDd92zmG/klqcqRzAf+PrYVFYG+Sd/FAy/DKVOsNIjRkjz7jfMlsl/5Zl5r0XfRaRbPNECpC4m5z+EYuD4AyFNqiXSTVvAG6kPfPY+eGPyAiFxoxpZ6w6ITkRSWqGIBW2FTiFvYZO6PVNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xbN3/aVzjqPS0FfUxH4fiAQcHzRhD1CNxMeKNTJtyhE=;
 b=ZPn78AaH8+ERbNz9n4MY6JQCKXDiN5bJTLdCJCtU6qpiT/oEF1ochdoA6MUIfdmcLjQVG8HZoi96FhsJq0vUPTMqq7hK+ekT/giefWfe2i6iNMpsfi2slfeXYibMUXYbfnbavc/aGxBzrDQ1C2hNd7rVUv0rPaUyBCBCPU5i4AsST4h+DyCF1yp02EF7jg7HO+kpsN3yPeZR0KuB2IiRA115dI6eFvF9bkDEYW+BM5UpPZrsuLJXYkvkDYHD3wIdlosHGGHo8W5Jsl/i00S+b+x/8qDtSbWps+jfxFRNUMoVuofcdbG8HkGnZYs0WE5YS8h08+W6J3xN1FZrMMsSTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: trained-monkey.org; dkim=none (message not signed)
 header.d=none;trained-monkey.org; dmarc=none action=none
 header.from=suse.com;
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com (2603:10a6:208:16f::21)
 by AM0PR04MB6946.eurprd04.prod.outlook.com (2603:10a6:208:186::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24; Wed, 26 Aug
 2020 15:17:41 +0000
Received: from AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7]) by AM0PR04MB6529.eurprd04.prod.outlook.com
 ([fe80::c8ac:ffb6:8e0d:36e7%3]) with mapi id 15.20.3326.019; Wed, 26 Aug 2020
 15:17:41 +0000
From:   Lidong Zhong <lidong.zhong@suse.com>
To:     jes@trained-monkey.org, linux-raid@vger.kernel.org
CC:     Lidong Zhong <lidong.zhong@suse.com>
Subject: [RFC PATCH] Detail: don't display the raid level when it's inactive
Date:   Wed, 26 Aug 2020 23:16:58 +0800
Message-ID: <20200826151658.3493-1-lidong.zhong@suse.com>
X-Mailer: git-send-email 2.26.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::49) To AM0PR04MB6529.eurprd04.prod.outlook.com
 (2603:10a6:208:16f::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from linux-rzeb.suse (119.162.215.253) by AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Wed, 26 Aug 2020 15:17:39 +0000
X-Mailer: git-send-email 2.26.1
X-Originating-IP: [119.162.215.253]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21d2a12b-c1c6-46fe-792c-08d849d32c7f
X-MS-TrafficTypeDiagnostic: AM0PR04MB6946:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB694606625968B1FA68908CE4F8540@AM0PR04MB6946.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HvCVXLzIc0ctVhbfHrZjO76NUkI+GBGCiahVvxRwK2/36q4aEa1WspKjnCbbi/ZylB8JYoytxVjj7nKGVlGl1053PvjCF7wagmNhibDwXZT21dQsb2/U74sblZU+Ea45LA4RSLS248IqLVqVN92cOtl2l2wEFWnAo0TfQtjAgZfHR6cJv7KGXtJbxiKFudzmJIKKxxQ0/X68Lg99KEQv8OehQR5M0TQmQpMwX9Pxwg1gLzlShirs3UmWKJKNj32aFHPE0bAss/oQWfVlfulSNWZP5wz1CPoT3leeZ20GRfwKepxEiQ1v9OmvVq5QSc6K+I6hBP6CeKzLVsIP6KNwfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6529.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(136003)(366004)(346002)(376002)(44832011)(8676002)(2906002)(86362001)(26005)(52116002)(5660300002)(6666004)(107886003)(4326008)(8936002)(6506007)(36756003)(6512007)(1076003)(956004)(2616005)(316002)(8886007)(66946007)(6486002)(66556008)(478600001)(186003)(66476007)(83380400001)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dlbSTFJR+nYrsgcJkDCnqn4t6ZYE7OyIUVJhq6HbE0cpn/YtTgWFP4/CY8p30g+Cvy+NHO+quEWziTQrB9l7J6YOoDJxigQ78PfEhlHa1bbli3gr9OsRQTKe6blmklqqrGM66iG4i/fNFDZekB+Wdnt1D3eupRNE184Hw777UkB7EYPB52rMjmGxwEOok9mnZa9sF9zSvLmpW7euua7XYsO9yInU0nOoSsxm9kfFejMjC4rDQRfuCohJzDf38He4oP1jMGPqIf6qGZtrR1vaAJp9vJ2TAW467+4MMzCFKG2IZNJxno0VWXfhHtQ0FK1fEMIGeufvGuwtbc3JP/gjel97/ZO/giRbcZgSUcZm7lNQkrFVa2u0zngx2PpUbHlVW+q1c/qQPuqbAUXasV8A32NNR4OXzL3cc3dYR6Pkfy5kWn71N0f7GjHkxzhfMozyyLI19w4O3jfR1wuMfXCKzFQP5IJCSzeD9yPoXOXUxmGyqvWAnrN+mji5VWduy2NfJiLZbSX9R1foLPk0LMGQ3nv2YsbND1H8r9uVvDYuFuqtFOgH0VgG/wHrCmvO21FLc9wXhtgSNH3BSGgosY//sr+Sy4OhZtqKxw445cQUFti4uL9XBdUghtTi3ILqBRjIw6Ain+lRyR9xUG8VpHvdtg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21d2a12b-c1c6-46fe-792c-08d849d32c7f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6529.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2020 15:17:41.0641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b7QojWxqfYb+mo5Wv2kTxuQzrgRFhz8GZyMpbeeWH/7Ty/myJqgjbMySmaZMGrmw1BsmETQllqufb6CxhMc25Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6946
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Sometimes the raid level in the output of `mdadm -D /dev/mdX` is
misleading when the array is in inactive state. Here is a testcase for
introduction.
1\ creating a raid1 device with two disks. Specify a different hostname
rather than the real one for later verfication.

node1:~ # mdadm --create /dev/md0 --homehost TESTARRAY -o -l 1 -n 2 /dev/sd=
b
/dev/sdc
2\ remove one of the devices and reboot
3\ show the detail of raid1 device

node1:~ # mdadm -D /dev/md127
/dev/md127:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent
          State : inactive
Working Devices : 1

You can see that the "Raid Level" in /dev/md127 is raid0 now.
After step 2\ is done, the degraded raid1 device is recognized
as a "foreign" array in 64-md-raid-assembly.rules. And thus the
timer to activate the raid1 device is not triggered. The array
level returned from GET_ARRAY_INFO ioctl is 0. And the string
shown for "Raid Level" is
str =3D map_num(pers, array.level);
And the definition of pers is
mapping_t pers[] =3D {
{ "linear", LEVEL_LINEAR},
{ "raid0", 0},
{ "0", 0}
...
So the misleading "raid0" is shown in this testcase. I think maybe
the "Raid Level" item shouldn't be displayed any more for the inactive
array.

Signed-off-by: Lidong Zhong <lidong.zhong@suse.com>
---
 Detail.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Detail.c b/Detail.c
index 24eeba0..9ac49e5 100644
--- a/Detail.c
+++ b/Detail.c
@@ -427,7 +427,7 @@ int Detail(char *dev, struct context *c)
 			printf("     Creation Time : %.24s\n", ctime(&atime));
 		if (is_container)
 			str =3D "container";
-		if (str)
+		if (str && !inactive)
 			printf("        Raid Level : %s\n", str);
 		if (larray_size)
 			printf("        Array Size : %llu%s\n",
--=20
2.26.1


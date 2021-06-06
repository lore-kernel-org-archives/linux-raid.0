Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCF9C47096
	for <linux-raid@archiver.kernel.org>; Sun,  6 Jun 2021 15:10:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF4F861408
	for <linux-raid@archiver.kernel.org>; Sun,  6 Jun 2021 15:10:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFFPMF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Jun 2021 11:12:05 -0400
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:20431
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230201AbhFFPMD (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Sun, 6 Jun 2021 11:12:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyO+2VtnIFcMm96UYU4qLsSTmXfPJZ84GVRTm7n9YtRYU8ruXHPonSl5+aRiQYbcnbOSsI/b3UeAeQ5EmrLiD+BfY5+ZpfWkM0YwUVd5YaHFYNZZVvBL9onOLqsOQ2/zfgbAB3J1xu7lbFZ+JhX14sO7lr5dSRQ8xOxwDAnt4AluURkxyRaz7im4fj7A7QSupzTMUWPqWf8+Z+y9NIvxLx/iavHUyZUwEpg4O+Umni155QD49z8SYwMYAxaizwG2ppJ0GStv90iMoH7583AgU6l5o2k4CyhKEiP2ubvnuOGSp3L3ggdVQYDhpviyWlWfgHvs7tvR1EicRn3oJO6Hkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cSWs+qvsjXFSOq2b5xhvipPckONLIT/V4IWXBJeRig=;
 b=e2PKE9RoBwKYb3L4pHNkmzXm9hZr+LfO0QSRBljj9xpdoKVfF6UgHPjY/KNhCzBFxfmxHHo+N9Vtp2SQps1sejm/pw9jxLRX/1mzbrJ7qFCijNvkl0muCEav4VuaTHTUr1UsJ+j80MzUy1YBwJR4uuoUydOBdAgiCy6KaG74ib9NSiXE5OE42/3azN+TLaJb0TVTiLgpDChns1fcJfhzPUFdsqVLq2VX+W5K8YccRJSNN3TenwnAIwrC/Jb7ea/ml6NBZDJD2Vk28kwK4wYk7OlM/5yNLg5YHCl9LSft2r+V9bjU43vCi6oQBDcwWlgnNejgdnFcnvc6Q1rItyznUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass action=none header.from=storing.io;
 dkim=pass header.d=storing.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5cSWs+qvsjXFSOq2b5xhvipPckONLIT/V4IWXBJeRig=;
 b=CDZeZx0jMlYg93ykWTRNbPwo76KAEOqXJmX4kyljRpsCHvybTJsGYUT+ZJYfvqLsGdWfjDwybeM8mWXDvDj2qyhNq8RqenuGtWY4IvbyAJ1x8nQwttCzXMBnB7ib1WtBdzHYPjhXtKJGans5icZ91oQfxuc8Rsyb9V/51VL29R969Ve3CxsF37VX82P8zpwGy8p0IHpi4aTw5vsY6M1TGoX3qvDODO7VFpS8AL8i2BLnu7tlWCW8wLODpO3ZYGJApDAmI6ScU5WIjyNmz9+vWzFsjcsg5D2Xv9eRS5zAU8Vdd3SMLKbYVJkwnor5f/SaYanKUcOKsnYKEA+W2hpuNQ==
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=storing.io;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6584.eurprd04.prod.outlook.com (2603:10a6:20b:f5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Sun, 6 Jun
 2021 15:10:12 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::297f:63fe:225b:3d16%6]) with mapi id 15.20.4195.030; Sun, 6 Jun 2021
 15:10:12 +0000
Date:   Sun, 6 Jun 2021 18:10:08 +0300
From:   Gal Ofri <gal.ofri@storing.io>
To:     "NeilBrown" <neilb@suse.de>
Cc:     "Song Liu" <song@kernel.org>
Subject: Re: [PATCH] md/raid5: reduce lock contention in read_one_chunk()
Message-ID: <20210606181008.47de3aa4@gofri-dell>
In-Reply-To: <162285301456.16225.18270741645959810726@noble.neil.brown.name>
References: <20210603135425.152570-1-gal.ofri@storing.io>
        <162276306409.16225.1432054245490518080@noble.neil.brown.name>
        <20210604114205.3daf3e68@gofri-dell>
        <20210604121950.372672c9@gofri-dell>
        <162285301456.16225.18270741645959810726@noble.neil.brown.name>
Organization: Storing.IO
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [199.203.113.198]
X-ClientProxiedBy: MR2P264CA0018.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:1::30) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by MR2P264CA0018.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:1::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Sun, 6 Jun 2021 15:10:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8937cdb3-fee1-4fef-8299-08d928fd2e61
X-MS-TrafficTypeDiagnostic: AM6PR04MB6584:
X-Microsoft-Antispam-PRVS: <AM6PR04MB6584FD88C2E5BD331FDABF73FE399@AM6PR04MB6584.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ONXBT7186A8TSuJr2cKeARzP2bBAVFGxFJR4yp5i0GUXd0+2NhkCKSOej+jSFZ3EwU7XWDf0hx8ZangQ1D5qvaQ8Q81eH1kZBJ5k/t1ju8uWX4LfXlcxfdfun/WLnsGXW3AoG6c5YLUwzqScn343TCLPQXcABuehEtQMmVooj+PFDF875TKlHgZ0gLAR/IITfXVV4gqS47nGgYdd7AKnaSDIcxAmu+yPKUZ1K2FE9G6bcaxIN7SV9fpThEzuHRXQ246fJanVn4jf2eYyWshEcf8mtRczgXqyG3Ca39Pj8k9hNbxIYjNSAeDgQHD2tLx0RvSnne+OjZAGbV2hRS1OnZa9lPztSW+z2D6O9kez7upF6ju9pUob+8wmWOxzUZwkYclbJn+Yanwi9QkxTpKIfyfVUCrsp90UeaKirqwjJzY3x/QkIYtpI21glHcRF//y/PwztUeqKmIpborQLZ/NHvZ7lAWQvoiNhlYZvdP2WRGYBqqlZ1tzELtsJHHfyBYxm9JsStBQPBv2bWV8xuRqWxOjRRLvbfPTQX2/Y/NDn+cboio4cXod4qNDuhGeLi1hc46rdara8rSIYtwmGRMfcb35EPBzRXuXO9zo2Dk1WdjaEbqNot/z1DfvFdtawtJz2cLV21+plQPMoKVnuzXMzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(39830400003)(396003)(366004)(316002)(36916002)(6496006)(33716001)(52116002)(86362001)(16526019)(478600001)(44832011)(26005)(956004)(4326008)(186003)(9686003)(55016002)(6916009)(83380400001)(38100700002)(38350700002)(2906002)(8936002)(8676002)(1076003)(66476007)(66946007)(5660300002)(66556008)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cqQzkcrfkGgLtjqObuu8kINnPSjBHoF/SBZIWb0aj9dOsBKAbd0WtOvdDeix?=
 =?us-ascii?Q?FKgv63xdYgdZxhxFJDD+E0P6WtunwvAZ99E4/FOnYJiwsai7iwmva+8hYZ6O?=
 =?us-ascii?Q?AQ/tDhA5kvEM/oXvHD6YQBTMlvaVCs8T01DItY0BYsPE/wAR+4ghSRtWmMxz?=
 =?us-ascii?Q?2W4vTAFlkEkGbsExqjbRKxr3IwUQFwQVJ1dpdLKzfhkun/B5qc5bctLvxY3p?=
 =?us-ascii?Q?38DmMEOyh4wSjFIu4Of5y3Mly+wfOz0XRHrrF0wXYsQwTcAERyaEl6Ft6Vr1?=
 =?us-ascii?Q?1hzH5RHJTUjl+PLNY+nU3bx2xLJnKs5A00PUtJ4c9uuwiKoCgpllydtQJYTu?=
 =?us-ascii?Q?6saYa8GrX37jRtWIEWgDnCP4VAavP5KeQK1P54VXLTJuFaVLKO5NJ8h8NlGa?=
 =?us-ascii?Q?BNlWp+CigBveZGBsdwghPwTeIjcoPSCdMbccVjj7WelTxE0gG6OnsLl+Xi4Y?=
 =?us-ascii?Q?TZh9bwGJKKUerkjsh2xv+j/tfdPnPmeL2ukHjeHk1q9LaKRwvv/sgPixZGVi?=
 =?us-ascii?Q?YCpaBNW5sr7fLMgO8HJwZuH8Ryc1ASLO4Lm6a9WEDIcbRDn6GlLK1jPDLUBU?=
 =?us-ascii?Q?yOyKq4L+RRy2vfDlPeGoBaKnx2ecOtVwVze4mLyJDnSSF9ZATVol3ocsWTwt?=
 =?us-ascii?Q?YluwDXPGpWealJulLHvBfSfEq8F2IEyQVh8YzChUVtCc86JKoVPECJFTzyeo?=
 =?us-ascii?Q?PO3X4i+3zHTZivnwjrB2qKqlYs4qXoOIrhx71UeNl6JLwyn2Mp6aEMF9D5uA?=
 =?us-ascii?Q?KL5TNOxmuPeybSJ0s/Sqh8sQW5lfFHksN9HpuSGxmW9/WNSdKUTL8IOirWrD?=
 =?us-ascii?Q?+QUFWWIw9AJ3N8mpBz6Hr4rymhJlA2rjkvSML5t36sufYZqYCL8AYQaKyIDP?=
 =?us-ascii?Q?7c4WErTq9cRUi8KLv0ZcOI/RH8iyZleInNPAHJfFxfYfkalHgUroJkZi5CLy?=
 =?us-ascii?Q?5UhOMpBCu4uplkcXo6bEGANKHGaFZ/dM7FWFan1aZ2jT7B8YHRic0aR5ddi9?=
 =?us-ascii?Q?t/VxsqBnJeG16qkKHhbQk8jKqU6yHybCm4yzsapaDHu12A1xNbd5GZ8FhfUK?=
 =?us-ascii?Q?pXFzhEorwyWDM0HNqx9fZu6oGkMlAsA6a+kqhLiVYGPMCnOZ/I2r4DUkOxns?=
 =?us-ascii?Q?C0AtScQG1ujLuSuKaqAgDh99OmSJBSV1zCOCrINNC7vgedCmf9JayMK2Lz4x?=
 =?us-ascii?Q?ArxXOWeRMOsqPdyV0fIZ3F4VcKkDpAc7XLSg85BPy+KC34fugMY33xIWAeus?=
 =?us-ascii?Q?XspEdE+vY61Brhkf3NzHAFP1lenAIM/h3uLdO0Fm9RBBmWByXL4fJa5BABc2?=
 =?us-ascii?Q?raISu0m0+pUN1y3We6lp5Bl2?=
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: 8937cdb3-fee1-4fef-8299-08d928fd2e61
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2021 15:10:12.1238
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zDPahJ3V/U8jU8SU5ybzrBuP1xCr1goUTjeGu8kjWLTy5Uto6pP0hnaIY7YC5yVVitygyYyNobJ87ZSuspHzrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6584
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

First, there's this race condition, caused by the following code:
if (conf->quiesce == 0)
{
	...
}
if (smp_load_acquire(&conf->quiesce) != 0)
{
	...
}

cpu-0 [raid5_quiesce()]	| cpu-1 [read_one_chunk()]
----------------------------------------------------------
conf->quiesce = 2 		| 
----------------------------------------------------------
				| if (conf->quiesce == 0)
				| /* false */		
----------------------------------------------------------
conf->quiesce = 1		|
----------------------------------------------------------
conf->quiesce = 0 		|
/* resuming from quiesce. */ 	|
----------------------------------------------------------
				| if (smp_load_acquire(&conf->quiesce) != 0)
				| /* false */
----------------------------------------------------------

So we skipped both conditions and did not increment active_aligned_reads, which
would result in an error down the road (endio/retry/next-quiesce/etc.).
It's really unlikely, but it is possible.

So I fixed it by changing:
-	if (smp_load_acquire(&conf->quiesce) != 0) {
+	if (!did_inc || smp_load_acquire(&conf->quiesce) != 0) {

Now with this fix in place, there's still the possibility that
active_aligned_reads would be >0 while quiesce==1 (before read_one_chunk()
reaches the second condition).  I can't find a bug caused by that, but IMO it's
quite counter-intuitive given wait_event(active_aligned_reads==0) in
raid5_quiesce(). Should I add a comment for that point ?

I'm adding the new code below for reference, please let me know what you think
about that point before I re-submit the patch.

thanks,
Gal Ofri
--

@@ -5396,6 +5396,7 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	struct md_rdev *rdev;
 	sector_t sector, end_sector, first_bad;
 	int bad_sectors, dd_idx;
+	bool did_inc;
 
 	if (!in_chunk_boundary(mddev, raid_bio)) {
 		pr_debug("%s: non aligned\n", __func__);
@@ -5443,11 +5444,23 @@ static int raid5_read_one_chunk(struct mddev *mddev, struct bio *raid_bio)
 	/* No reshape active, so we can trust rdev->data_offset */
 	align_bio->bi_iter.bi_sector += rdev->data_offset;
 
-	spin_lock_irq(&conf->device_lock);
-	wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
-			    conf->device_lock);
-	atomic_inc(&conf->active_aligned_reads);
-	spin_unlock_irq(&conf->device_lock);
+	did_inc = false;
+	if (conf->quiesce == 0) {
+		atomic_inc(&conf->active_aligned_reads);
+		did_inc = true;
+	}
+	/* need a memory barrier to detect the race with raid5_quiesce() */
+	if (!did_inc || smp_load_acquire(&conf->quiesce) != 0) {
+		/* quiesce is in progress, so we need to undo io activation and wait
+		 * for it to finish */
+		if (did_inc && atomic_dec_and_test(&conf->active_aligned_reads))
+			wake_up(&conf->wait_for_quiescent);
+		spin_lock_irq(&conf->device_lock);
+		wait_event_lock_irq(conf->wait_for_quiescent, conf->quiesce == 0,
+				    conf->device_lock);
+		atomic_inc(&conf->active_aligned_reads);
+		spin_unlock_irq(&conf->device_lock);
+	}
 
 	if (mddev->gendisk)
 		trace_block_bio_remap(align_bio, disk_devt(mddev->gendisk),
@@ -8334,7 +8347,9 @@ static void raid5_quiesce(struct mddev *mddev, int quiesce)
 		 * active stripes can drain
 		 */
 		r5c_flush_cache(conf, INT_MAX);
-		conf->quiesce = 2;
+		/* need a memory barrier to make sure read_one_chunk() sees
+		 * quiesce started and reverts to slow (locked) path. */
+		smp_store_release(&conf->quiesce, 2);
 		wait_event_cmd(conf->wait_for_quiescent,
 				    atomic_read(&conf->active_stripes) == 0 &&
 				    atomic_read(&conf->active_aligned_reads) == 0,



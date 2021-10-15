Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C6FC433F5
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 16:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F373661181
	for <linux-raid@archiver.kernel.org>; Fri, 15 Oct 2021 16:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbhJOQ0s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 15 Oct 2021 12:26:48 -0400
Received: from mail-dm3gcc02on2139.outbound.protection.outlook.com ([40.107.91.139]:56801
        "EHLO GCC02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241257AbhJOQ0s (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 15 Oct 2021 12:26:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Osjcra24Acw5KUrxTJm9F4iAnrTun5XOdgbrfF7seFBeLMA51V4X2kunYYco9f5DAhZjgKNLJosG4M9X9YO6vU9QtgmIWNdyDBLpNDcuWLDpgRyOiuY8JGOQfY6SJY53HPZMyh6hKQ3uKDdTf7MfQa8Y6tfX6Bmcu2qwxHm1oYMX2kvSlnGheyZggr0AqqWACcTUQ+jW2WfKf2PT1zeXNQrFFhjfeBo0luqyMgaKaLWpFMDainXqJAMQVX1n+RqCRu5sPwOHniQICedKAd9Wn6XadOtZFw6myxmIu16ZyDNnVqHt4NYwiB/ovzAfEXVtrclk51arYoRVMR8p6RHGog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YmV1gHTxDDeK32w9gWf8YyOmN0E5SEHWK7blO6ck2S4=;
 b=ZtvZHz8VN8IPNFpYNsPkZ1H4tQEIiO25g1oiBJnAQAhMWvzzc7kcMpUnpMe3z4ckzgRTJwHbLTsEOnWAqZVNuBYauIIhwwW5TkJWwFlMhAx9yOOTV1hwoi+3OR4ekAKz7ektahe5b8wkxurIcF/UqstLoMuGQeTwvy7513AtpaZuzfWr1FbDf/s1O0Od01TK55shg0nQbAEPHI/DbWHr9d6leKSj7QNpqmvKiwtcrX4tUs9/2HchtaL56DV8Xd9sEH7ImP6MTs2++v6ERzGzV7nIQONcydz0p178r5U6SK/3rMkqWEbCNOcObT1c8DSQOMacmqmqIF8xjuZbmJyh5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmV1gHTxDDeK32w9gWf8YyOmN0E5SEHWK7blO6ck2S4=;
 b=Ae8+mCu/soLCM5D3mPGon+36XPHQ2zciFAgK9MpGs/kDgvqjNn4+A8qAtwetbUE05DJY/jQW6mFqnUkqP8ACePNM7RJHgH5lELJWuqQ0bP2+FM0Nq+4p5qi7wvB6wMAQI2KWMg9NBYFL5Tq3Y1FrhVhEF7oypO7gqRfUjaDSYou/UPs/xtimqG+GlhejSr3xwh25Jn7HbOHOygW27cM8VJiVqI0DQjzk8zzfUiGmbRtFaJ2rhvW+Rb37MUjWTji4ZXHmDBvDV+7gxVP3uldiujYxNTSfwQgEKvqJpFGqgy9ilyBYRPFOUbdm3fEc7tlg/pLD6ynpoiQcmipb5WxcVA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nwra.com;
Received: from DM8PR09MB6311.namprd09.prod.outlook.com (2603:10b6:5:2e8::17)
 by DM8PR09MB6696.namprd09.prod.outlook.com (2603:10b6:5:2e2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 16:24:39 +0000
Received: from DM8PR09MB6311.namprd09.prod.outlook.com
 ([fe80::1999:382b:bf5c:61be]) by DM8PR09MB6311.namprd09.prod.outlook.com
 ([fe80::1999:382b:bf5c:61be%7]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 16:24:39 +0000
To:     linux-raid@vger.kernel.org
From:   Orion Poplawski <orion@nwra.com>
Subject: raid6check lockup
Organization: NWRA
Message-ID: <a94404d2-1a5e-ef5a-1e2a-9d8b7c7388eb@nwra.com>
Date:   Fri, 15 Oct 2021 10:24:34 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050704090902060109070609"
X-ClientProxiedBy: CY4PR1101CA0010.namprd11.prod.outlook.com
 (2603:10b6:910:15::20) To DM8PR09MB6311.namprd09.prod.outlook.com
 (2603:10b6:5:2e8::17)
MIME-Version: 1.0
Received: from barry.cora.nwra.com (204.134.157.90) by CY4PR1101CA0010.namprd11.prod.outlook.com (2603:10b6:910:15::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Fri, 15 Oct 2021 16:24:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e11ab0aa-8327-4d32-eb78-08d98ff84923
X-MS-TrafficTypeDiagnostic: DM8PR09MB6696:
X-Microsoft-Antispam-PRVS: <DM8PR09MB6696D02113466FB343D4D610CAB99@DM8PR09MB6696.namprd09.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XI0T+O0xzMqBRoBNkd1HO9AFkTkSKkOxpFTSidnGB/85F/vBTrY/7E23Vurz5s0LChK6zE18VgmZMjVGPl1YgBSmniILJCHB86xoyph3v3SNljw0JTvbfBXs5pQR9ratVBpwA2ra33vfCFKa2P9GsEUMjiLWm2/l0oAhy3TeE20lNx3HJTaSygafC0VRn08YQ4wXcogsbdk5/t4Twn+/g0S0rWOk42OhmL3xyDFm3dRjZrFZfMzICoAyIZrgCpdVsD2uiq86FWsvViWEkFpKzM/d9dYmIcxA0ItNxrNu9q2P56Ooxsfh7LypvS385ZJ25brAYeSfNTp0vHvCDAcwVAwkWhE/1xv/wCSNMm+ZkzYIpEVYbEPTI7YDM34A1NDmlup4ns+lKnHC9eWPlYtvcLylHaz2RnSCmu016mcOgOAKJtmgI8ra2ZDG+BYIGbD5/RV5ryXxfM+VLV10GUlXMl7EaH8mHCMYhTwYW/KcQbsKsgNJzPx/KNebvR88MZsW8FO7QDuXjDmFjMfELmCm6s9zld7XTZ782RhlCc5MUv12A63V1bD3nweOlGJmZlhOTr3gMuMjWfC81sWTxmbR+WoHEr6T+OJvpaQgkewcxIdUmRoeh7mUA4qQ3h6dSq/fZ/7OZf52gO0KDSkuHHwp1flVPULw645cVwoir95g+EHyMBgTOd/wXcC5tg3KMIOwLCPLpW2N2o/LcMvb/wcA/FRsjSTRcGM8RfumXKL/GdRZ3iE/vBcTw/TbqwoGUwBX9HMBeZl/TfIvvKekqojYhRnzvO/AmyjDZi13zQWEFZlbfLKCwa+gTUtZMJxLkbgj3mupdX0d9GD9wlqUE3QkOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR09MB6311.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39840400004)(40140700001)(36916002)(966005)(7696005)(31696002)(508600001)(5660300002)(6916009)(38100700002)(6486002)(316002)(8676002)(235185007)(26005)(8936002)(7116003)(33964004)(36756003)(66476007)(66556008)(66946007)(186003)(2906002)(86362001)(6666004)(956004)(30864003)(83380400001)(2616005)(31686004)(32563001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UDk5QS9NeXRoTjJKQWVSME1XMmxXZ2ZtcktLNHpXY3Y2S3FRSGprVFU3OVNI?=
 =?utf-8?B?N1VxMzg5dnlqTjNSbEd4amdQRkYyRFV6OWpyVDNrbzN4ajNDU2dBSDlYOHJL?=
 =?utf-8?B?dlRQcDJxaW4vZVUyNndNSUZpVFBBVWNSZC8rcnZjVWtldVltbGhxNE1kV21O?=
 =?utf-8?B?SWMyb0xSWUdLS3BOTk9zQU54NWE4QXBGVkl5ZXZXM2orWUtWVHNEN1ZPTWxH?=
 =?utf-8?B?dkdHYWQ1Rm5nSTF5bG5yTzBHTWZERDNudElCTnpsMGpTSXRrMlZPc0NwUHZR?=
 =?utf-8?B?eUtiSFNpVHczOHJGOEpoelJGNWRjbDVBcURQdm04OVdJNExFMEpkd0VJOEUr?=
 =?utf-8?B?SEx5U1FOVUY2R2ZJYmJrSVhYNVh2Q0J3dll4b2U1bWg5dXl4WkVpRkpiQnha?=
 =?utf-8?B?ZVptcG1oT2VwVllrditqYkxRWEkxSW5JNHUzREZSL1o1VjlwNWphQ0l0RVJn?=
 =?utf-8?B?VlJ0OXMvRVF0VnlBLzduQ28yd0JZOXZxMFp6TklRZnZoWEZNZGFqZFFKWm1s?=
 =?utf-8?B?UUd3RGNWQThtNHZNYytYQVVhaENVODFnN0Jxa05Wd1M2ZmphSTJ2YWQweFg0?=
 =?utf-8?B?VGRJZDdPYWNEQVhvUEMvL3pUMDc4VXU4OVJ4a0NhWHlHbjZLME5XVlhnQ0hG?=
 =?utf-8?B?aVRsT2NVMWRJTkpnNkdOcDAySkJ5bVV3a04rOEVveVhZdGNsVmlXUkFaVGl0?=
 =?utf-8?B?UkM1VldxaXJiMkdHSmdMWFUzM2J3Z25jS25QQ0ZKc2hta2swTG1ZUUt0Y3g2?=
 =?utf-8?B?WHRsaGVUOVJtUnJrNUpsWHU0NCtjbGNhVHN1eDVLcURqK2JjYjlhTmhhdFcx?=
 =?utf-8?B?ZWgwRGF1VGhXeFJ4cWRka0tFc08vUXVBK2NyTFgvR1NWcGMrQW9ialNweFN2?=
 =?utf-8?B?SlpEV1hFVXd3SDhWNjhYcHJQZS8xQjBtZTJvRzZXa0laenlyREJud3FiaWQ4?=
 =?utf-8?B?SzY2WXEra2k3N2xVTTBkTDFlK3A5a2Q4dXhWUnlhQTZESWplVVgweWFSakFU?=
 =?utf-8?B?RDRmbEdxZ0grV2FrbFNIUU9xcXN2Q1dDak5sNG5KaExheWloSC9WcFdNSVFi?=
 =?utf-8?B?d1JWTkZQRnJNUkpKeDZWWGNFQkg5ZnpIbHhXamQ3UWxlTmhvNXpaQWJ3OEUr?=
 =?utf-8?B?OEF5anNQL0dJbE1QUzV4eTVJUUNqL01PWUd5dXlUR3lkVXNDK25SY0ljOTQv?=
 =?utf-8?B?eHYxMTRUd0w3T2l0ZHVNdWVKVEZzMW9DS29wVmo4RWZseitwV2ZJQ2cxVll5?=
 =?utf-8?B?TE5iTVVWWnA5YkhGSmEvNk1lWDlIczJuRUhuUVZZeFJ4a1ZqaEVuZFBkUjYx?=
 =?utf-8?B?WjZPWWhYeStGMS9tK0ZHbjFrTXZVNS9EOG1PQjlLdXNNdWZERVFXUnVpTGN3?=
 =?utf-8?B?d0N3SURUU2djVjVDZ1Y4MklIajZ0ZmFXY2Ixb3RFQ1VOWThjZFVnelFyTmZR?=
 =?utf-8?B?WnJZQkdQd1Brc1gySlI0dVJOMjYvRDZRenJTb01MeDFKNExDUllJWUhDV0p5?=
 =?utf-8?B?UTc2OUdTTlFFNVRZZ0FWNHArQ1Z2OXRvKysrODN6MytodFhvTlpDM3BqdUU3?=
 =?utf-8?B?TnJObWVjMzZIUXY0Qk5VWFFUVVA2T1p2bElLaVRVeENoQlJvUFpOS1ZQS1gz?=
 =?utf-8?B?Sis2dnNhZ3pzU2RZay9WRjFpOWNiNm5VMDRoRXBIRVAvaW9RRnNpT2V5eGNC?=
 =?utf-8?B?MHJxZGxEckJKZ09tR0V6WGo5ZEdoaGRPV2JTR0RQWTFGZUxaWFpQYkhZYXRN?=
 =?utf-8?Q?mHY9WquXKkoyCPvTsE3WLXZW5dF1JEDYr+6DTiF?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e11ab0aa-8327-4d32-eb78-08d98ff84923
X-MS-Exchange-CrossTenant-AuthSource: DM8PR09MB6311.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 16:24:39.2692
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR09MB6696
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms050704090902060109070609
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

I'm running mdadm version 4.2_rc2 raid6check on a EL7 system running
3.10.0-1160.42.2.el7.x86_64 and it seems to have gummed things up.  Canno=
t
strace it, and many processes seem to be stuck in IO:

19059 ?        DN     0:00 /usr/bin/perl
/usr/share/BackupPC/bin/BackupPC_nightly -m -P 7 112 119
19060 ?        DN     0:00 /usr/bin/perl
/usr/share/BackupPC/bin/BackupPC_nightly -P 7 120 127
20442 ?        D      0:00 /usr/sbin/pvs --noheadings --nosuffix --units =
g
--separator ,
20449 ?        Ds     0:00 /usr/bin/rsync --server --sender -slHogDtpAXrx=
e.iLsfxC
23386 ?        D      0:00 /usr/sbin/vgs --noheadings --nosuffix --units =
g
--separator ,
29908 ?        Ds     0:04 /usr/lib/systemd/systemd-logind
31848 ?        D      0:00 /usr/sbin/vgs --noheadings --nosuffix --units =
g
--separator ,

Got a bunch of hung task messages earlier on, but then not much:

Oct 12 18:12:16 kernel: INFO: task raid6check:5239 blocked for more than =
120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: raid6check      D ffff99102c5ae300     0  5239   =
5236
0x00000080
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31abf45>] mddev_suspend+0xd5/0x1c0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31ac165>] suspend_lo_store+0x65/0xd0
Oct 12 18:12:16 kernel:  [<ffffffffb31aad42>] md_attr_store+0x82/0xd0
Oct 12 18:12:16 kernel:  [<ffffffffb2edba42>] sysfs_kf_write+0x42/0x50
Oct 12 18:12:16 kernel:  [<ffffffffb2edb02b>] kernfs_fop_write+0xeb/0x160=

Oct 12 18:12:16 kernel:  [<ffffffffb2e4e570>] vfs_write+0xc0/0x1f0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2e4f34f>] SyS_write+0x7f/0xf0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395f92>] system_call_fastpath+0x25/0=
x2a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel: INFO: task kworker/u24:0:14899 blocked for more t=
han
120 seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: kworker/u24:0   D ffff99102b3226e0     0 14899   =
   2
0x00000080
Oct 12 18:12:16 kernel: Workqueue: writeback bdi_writeback_workfn (flush-=
9:0)
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a2d>] md_handle_request+0x8d/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31a7b69>] md_make_request+0x79/0x190
Oct 12 18:12:16 kernel:  [<ffffffffb2f55ba7>] generic_make_request+0x147/=
0x380
Oct 12 18:12:16 kernel:  [<ffffffffb2e8c802>] ? bvec_alloc+0x92/0x120
Oct 12 18:12:16 kernel:  [<ffffffffb2f55e50>] submit_bio+0x70/0x150
Oct 12 18:12:16 kernel:  [<ffffffffb2e8caa3>] ? bio_alloc_bioset+0x213/0x=
310
Oct 12 18:12:16 kernel:  [<ffffffffc05f6e45>] xfs_add_to_ioend+0x145/0x1d=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05f7475>] xfs_do_writepage+0x1e5/0x55=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2dca95c>] write_cache_pages+0x21c/0x4=
70
Oct 12 18:12:16 kernel:  [<ffffffffc05f7290>] ? xfs_vm_writepages+0xa0/0x=
a0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05f725b>] xfs_vm_writepages+0x6b/0xa0=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2dcb9b1>] do_writepages+0x21/0x50
Oct 12 18:12:16 kernel:  [<ffffffffb2e7def0>] __writeback_single_inode+0x=
40/0x260
Oct 12 18:12:16 kernel:  [<ffffffffb2e7ea74>] writeback_sb_inodes+0x1c4/0=
x430
Oct 12 18:12:16 kernel:  [<ffffffffb2e7ed7f>] __writeback_inodes_wb+0x9f/=
0xd0
Oct 12 18:12:16 kernel:  [<ffffffffb2e7f253>] wb_writeback+0x263/0x2f0
Oct 12 18:12:16 kernel:  [<ffffffffb2e6ae4c>] ? get_nr_inodes+0x4c/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb2e7fe4b>] bdi_writeback_workfn+0x2cb/=
0x460
Oct 12 18:12:16 kernel:  [<ffffffffb2cbde8f>] process_one_work+0x17f/0x44=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbefa6>] worker_thread+0x126/0x3c0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbee80>] ? manage_workers.isra.26+0x=
2a0/0x2a0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5e61>] kthread+0xd1/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel:  [<ffffffffb3395df7>] ret_from_fork_nospec_begin+=
0x21/0x21
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel: INFO: task kworker/2:1:16187 blocked for more tha=
n 120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: kworker/2:1     D ffff990d363647e0     0 16187   =
   2
0x00000080
Oct 12 18:12:16 kernel: Workqueue: xfs-cil/md0 xlog_cil_push_work [xfs]
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a2d>] md_handle_request+0x8d/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31a7b69>] md_make_request+0x79/0x190
Oct 12 18:12:16 kernel:  [<ffffffffb2f55ba7>] generic_make_request+0x147/=
0x380
Oct 12 18:12:16 kernel:  [<ffffffffb2f55e50>] submit_bio+0x70/0x150
Oct 12 18:12:16 kernel:  [<ffffffffc05fc283>] _xfs_buf_ioapply+0x2f3/0x46=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc061e6c7>] ? xlog_bdstrat+0x37/0x70 [x=
fs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fdc72>] __xfs_buf_submit+0x72/0x250=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc061e6c7>] xlog_bdstrat+0x37/0x70 [xfs=
]
Oct 12 18:12:16 kernel:  [<ffffffffc0620526>] xlog_sync+0x2e6/0x3f0 [xfs]=

Oct 12 18:12:16 kernel:  [<ffffffffc06206ab>]
xlog_state_release_iclog+0x7b/0xd0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062136a>] xlog_write+0x5da/0x750 [xfs=
]
Oct 12 18:12:16 kernel:  [<ffffffffc0622d08>] xlog_cil_push+0x2a8/0x430 [=
xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc0622ea5>] xlog_cil_push_work+0x15/0x2=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2cbde8f>] process_one_work+0x17f/0x44=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbf0f8>] worker_thread+0x278/0x3c0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbee80>] ? manage_workers.isra.26+0x=
2a0/0x2a0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5e61>] kthread+0xd1/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel:  [<ffffffffb3395df7>] ret_from_fork_nospec_begin+=
0x21/0x21
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel: INFO: task kworker/2:0:16943 blocked for more tha=
n 120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: kworker/2:0     D ffff99102afbd280     0 16943   =
   2
0x00000080
Oct 12 18:12:16 kernel: Workqueue: xfs-sync/md0 xfs_log_worker [xfs]
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb3386e41>] schedule_timeout+0x221/0x2d=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cd7449>] ? ttwu_do_wakeup+0x19/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb2cd757f>] ? ttwu_do_activate+0x6f/0x8=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cdab32>] ? try_to_wake_up+0x192/0x39=
0
Oct 12 18:12:16 kernel:  [<ffffffffb338952d>] wait_for_completion+0xfd/0x=
140
Oct 12 18:12:16 kernel:  [<ffffffffb2cdadf0>] ? wake_up_state+0x20/0x20
Oct 12 18:12:16 kernel:  [<ffffffffb2cbe61a>] flush_work+0x10a/0x1b0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbb330>] ? move_linked_works+0x90/0x=
90
Oct 12 18:12:16 kernel:  [<ffffffffc06236da>] xlog_cil_force_lsn+0x8a/0x2=
10 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2ce4d1c>] ? dequeue_entity+0x11c/0x5c=
0
Oct 12 18:12:16 kernel:  [<ffffffffc06218e6>] ? xfs_log_worker+0x36/0x100=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062165b>] xfs_log_force+0x8b/0x2e0 [x=
fs]
Oct 12 18:12:16 kernel:  [<ffffffffb2c2b59e>] ? __switch_to+0xce/0x580
Oct 12 18:12:16 kernel:  [<ffffffffc06218e6>] xfs_log_worker+0x36/0x100 [=
xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2cbde8f>] process_one_work+0x17f/0x44=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbefa6>] worker_thread+0x126/0x3c0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbee80>] ? manage_workers.isra.26+0x=
2a0/0x2a0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5e61>] kthread+0xd1/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel:  [<ffffffffb3395df7>] ret_from_fork_nospec_begin+=
0x21/0x21
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel: INFO: task kworker/5:1:17174 blocked for more tha=
n 120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: kworker/5:1     D ffff991011e226e0     0 17174   =
   2
0x00000080
Oct 12 18:12:16 kernel: Workqueue: md md_submit_flush_data
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a2d>] md_handle_request+0x8d/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31ac8c1>] md_submit_flush_data+0x81/0=
xb0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbde8f>] process_one_work+0x17f/0x44=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbefa6>] worker_thread+0x126/0x3c0
Oct 12 18:12:16 kernel:  [<ffffffffb2cbee80>] ? manage_workers.isra.26+0x=
2a0/0x2a0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5e61>] kthread+0xd1/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel:  [<ffffffffb3395df7>] ret_from_fork_nospec_begin+=
0x21/0x21
Oct 12 18:12:16 kernel:  [<ffffffffb2cc5d90>] ? insert_kthread_work+0x40/=
0x40
Oct 12 18:12:16 kernel: INFO: task rsync_bpc:17209 blocked for more than =
120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: rsync_bpc       D ffff99102c5aa6e0     0 17209  1=
7195
0x00000080
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31acb96>] md_flush_request+0x106/0x20=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffc095aae8>] raid5_make_request+0xc88/0x=
ca0
[raid456]
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2ce6321>] ? put_prev_entity+0x31/0x40=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2c2b621>] ? __switch_to+0x151/0x580
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a70>] md_handle_request+0xd0/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2f53dcf>] ?
generic_make_request_checks+0x27f/0x390
Oct 12 18:12:16 kernel:  [<ffffffffb31a7b69>] md_make_request+0x79/0x190
Oct 12 18:12:16 kernel:  [<ffffffffb2f55ba7>] generic_make_request+0x147/=
0x380
Oct 12 18:12:16 kernel:  [<ffffffffb2f55e50>] submit_bio+0x70/0x150
Oct 12 18:12:16 kernel:  [<ffffffffc05fc283>] _xfs_buf_ioapply+0x2f3/0x46=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc061e6c7>] ? xlog_bdstrat+0x37/0x70 [x=
fs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fdc72>] __xfs_buf_submit+0x72/0x250=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc061e6c7>] xlog_bdstrat+0x37/0x70 [xfs=
]
Oct 12 18:12:16 kernel:  [<ffffffffc0620526>] xlog_sync+0x2e6/0x3f0 [xfs]=

Oct 12 18:12:16 kernel:  [<ffffffffc06206ab>]
xlog_state_release_iclog+0x7b/0xd0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062180a>] xfs_log_force+0x23a/0x2e0 [=
xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fd490>] ?
_xfs_buf_find.isra.9+0x170/0x330 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fd31b>] xfs_buf_lock+0xcb/0xd0 [xfs=
]
Oct 12 18:12:16 kernel:  [<ffffffffc05fd490>] _xfs_buf_find.isra.9+0x170/=
0x330
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fd6e5>] xfs_buf_get_map+0x35/0x250 =
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062ebe1>]
xfs_trans_get_buf_map+0x101/0x170 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05daf32>] xfs_da_get_buf+0xc2/0x100 [=
xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e2a2f>] xfs_dir3_data_init+0x5f/0x2=
80 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e16af>] xfs_dir2_sf_to_block+0x12f/=
0x640
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2e291a2>] ? kmem_cache_alloc+0x1c2/0x=
1f0
Oct 12 18:12:16 kernel:  [<ffffffffc061de17>] ? kmem_zone_alloc+0x97/0x13=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e99dc>] xfs_dir2_sf_addname+0xcc/0x=
5c0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc061da87>] ? kmem_alloc+0x97/0x130 [xf=
s]
Oct 12 18:12:16 kernel:  [<ffffffffc05df678>] xfs_dir_createname+0x1a8/0x=
200 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc06130f8>] xfs_rename+0x878/0xaa0 [xfs=
]
Oct 12 18:12:16 kernel:  [<ffffffffc060d834>] xfs_vn_rename+0xe4/0x150 [x=
fs]
Oct 12 18:12:16 kernel:  [<ffffffffb2e5fec5>] vfs_rename+0x5d5/0x8e0
Oct 12 18:12:16 kernel:  [<ffffffffc060d750>] ? xfs_initxattrs+0x60/0x60 =
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2e61143>] SYSC_renameat2+0x503/0x5a0
Oct 12 18:12:16 kernel:  [<ffffffffb2e6166d>] ? do_filp_open+0x4d/0xb0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2e6204e>] SyS_renameat2+0xe/0x10
Oct 12 18:12:16 kernel:  [<ffffffffb2e6208e>] SyS_rename+0x1e/0x20
Oct 12 18:12:16 kernel:  [<ffffffffb3395f92>] system_call_fastpath+0x25/0=
x2a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel: INFO: task rsync_bpc:17214 blocked for more than =
120
seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: rsync_bpc       D ffff99100ad0e8e0     0 17214  1=
7211
0x00000080
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a2d>] md_handle_request+0x8d/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31a7b69>] md_make_request+0x79/0x190
Oct 12 18:12:16 kernel:  [<ffffffffb2f55ba7>] generic_make_request+0x147/=
0x380
Oct 12 18:12:16 kernel:  [<ffffffffb31a2180>] ? md_congested+0x50/0x50
Oct 12 18:12:16 kernel:  [<ffffffffb2f55e50>] submit_bio+0x70/0x150
Oct 12 18:12:16 kernel:  [<ffffffffc05fc283>] _xfs_buf_ioapply+0x2f3/0x46=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fde75>] ? _xfs_buf_read+0x25/0x30 [=
xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fdc72>] __xfs_buf_submit+0x72/0x250=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062ee39>] ?
xfs_trans_read_buf_map+0xe9/0x2c0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05fde75>] _xfs_buf_read+0x25/0x30 [xf=
s]
Oct 12 18:12:16 kernel:  [<ffffffffc05fdf79>] xfs_buf_read_map+0xf9/0x160=
 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc062ee39>]
xfs_trans_read_buf_map+0xe9/0x2c0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05db5a3>] xfs_da_read_buf+0xd3/0x120 =
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e1c36>] xfs_dir3_data_read+0x26/0x6=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e6056>]
xfs_dir2_leafn_lookup_for_entry+0xf6/0x3c0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e79b7>]
xfs_dir2_leafn_lookup_int+0x17/0x30 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05dcbb4>]
xfs_da3_node_lookup_int+0x324/0x350 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05e866d>] xfs_dir2_node_lookup+0x4d/0=
x170
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05df8bd>] xfs_dir_lookup+0x1bd/0x1e0 =
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc0610c69>] xfs_lookup+0x69/0x140 [xfs]=

Oct 12 18:12:16 kernel:  [<ffffffffc060da88>] xfs_vn_lookup+0x78/0xc0 [xf=
s]
Oct 12 18:12:16 kernel:  [<ffffffffb2e591b3>] lookup_real+0x23/0x60
Oct 12 18:12:16 kernel:  [<ffffffffb2e59bd2>] __lookup_hash+0x42/0x60
Oct 12 18:12:16 kernel:  [<ffffffffb33800e5>] lookup_slow+0x42/0xa7
Oct 12 18:12:16 kernel:  [<ffffffffb2e5d7ce>] path_lookupat+0x89e/0x8d0
Oct 12 18:12:16 kernel:  [<ffffffffb32dffb0>] ? inet_recvmsg+0x80/0xb0
Oct 12 18:12:16 kernel:  [<ffffffffb2e29015>] ? kmem_cache_alloc+0x35/0x1=
f0
Oct 12 18:12:16 kernel:  [<ffffffffb2e6039f>] ? getname_flags+0x4f/0x1a0
Oct 12 18:12:16 kernel:  [<ffffffffb2e5d82b>] filename_lookup+0x2b/0xc0
Oct 12 18:12:16 kernel:  [<ffffffffb2e61537>] user_path_at_empty+0x67/0xc=
0
Oct 12 18:12:16 kernel:  [<ffffffffb3235731>] ? sock_aio_read+0x21/0x30
Oct 12 18:12:16 kernel:  [<ffffffffb2e4d9a3>] ? do_sync_read+0x93/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb2e615a1>] user_path_at+0x11/0x20
Oct 12 18:12:16 kernel:  [<ffffffffb2e53fe3>] vfs_fstatat+0x63/0xc0
Oct 12 18:12:16 kernel:  [<ffffffffb2e5439e>] SYSC_newstat+0x2e/0x60
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ec9>] ?
system_call_after_swapgs+0x96/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb2e5485e>] SyS_newstat+0xe/0x10
Oct 12 18:12:16 kernel:  [<ffffffffb3395f92>] system_call_fastpath+0x25/0=
x2a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel: INFO: task BackupPC_refCou:17492 blocked for more=
 than
120 seconds.
Oct 12 18:12:16 kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs=
"
disables this message.
Oct 12 18:12:16 kernel: BackupPC_refCou D ffff990c36a9b760     0 17492  1=
7490
0x00000080
Oct 12 18:12:16 kernel: Call Trace:
Oct 12 18:12:16 kernel:  [<ffffffffb3389179>] schedule+0x29/0x70
Oct 12 18:12:16 kernel:  [<ffffffffb31a7a2d>] md_handle_request+0x8d/0x15=
0
Oct 12 18:12:16 kernel:  [<ffffffffb2cc6f50>] ? wake_up_atomic_t+0x30/0x3=
0
Oct 12 18:12:16 kernel:  [<ffffffffb31a7b69>] md_make_request+0x79/0x190
Oct 12 18:12:16 kernel:  [<ffffffffb2f55ba7>] generic_make_request+0x147/=
0x380
Oct 12 18:12:16 kernel:  [<ffffffffc05f6ce0>] ? __xfs_get_blocks+0x6d0/0x=
6d0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2f55e50>] submit_bio+0x70/0x150
Oct 12 18:12:16 kernel:  [<ffffffffb2dcdce4>] ? __lru_cache_add+0x64/0x90=

Oct 12 18:12:16 kernel:  [<ffffffffb2e93eca>] mpage_bio_submit+0x2a/0x40
Oct 12 18:12:16 kernel:  [<ffffffffb2e9506f>] mpage_readpages+0x13f/0x170=

Oct 12 18:12:16 kernel:  [<ffffffffc05f6ce0>] ? __xfs_get_blocks+0x6d0/0x=
6d0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc05f6ce0>] ? __xfs_get_blocks+0x6d0/0x=
6d0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2e193b8>] ? alloc_pages_current+0x98/=
0x110
Oct 12 18:12:16 kernel:  [<ffffffffc05f6058>] xfs_vm_readpages+0x38/0x80 =
[xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2dcbe1f>]
__do_page_cache_readahead+0x1cf/0x260
Oct 12 18:12:16 kernel:  [<ffffffffb2dcbfcf>] ondemand_readahead+0x11f/0x=
240
Oct 12 18:12:16 kernel:  [<ffffffffb2dcc410>] page_cache_sync_readahead+0=
x60/0x80
Oct 12 18:12:16 kernel:  [<ffffffffb2dbf39c>]
do_generic_file_read.constprop.52+0xdc/0x510
Oct 12 18:12:16 kernel:  [<ffffffffb2dc0179>] generic_file_aio_read+0x1c9=
/0x290
Oct 12 18:12:16 kernel:  [<ffffffffc0601f55>]
xfs_file_buffered_aio_read+0x95/0x110 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffc06025a7>] xfs_file_aio_read+0x87/0x10=
0 [xfs]
Oct 12 18:12:16 kernel:  [<ffffffffb2e4d9a3>] do_sync_read+0x93/0xe0
Oct 12 18:12:16 kernel:  [<ffffffffb2e4e3df>] vfs_read+0x9f/0x170
Oct 12 18:12:16 kernel:  [<ffffffffb2e4f25f>] SyS_read+0x7f/0xf0
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a
Oct 12 18:12:16 kernel:  [<ffffffffb3395f92>] system_call_fastpath+0x25/0=
x2a
Oct 12 18:12:16 kernel:  [<ffffffffb3395ed5>] ?
system_call_after_swapgs+0xa2/0x13a



--=20
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/


--------------ms050704090902060109070609
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
CmMwggUVMIID/aADAgECAhEArxwEsqyM/5sAAAAAUc4Y4zANBgkqhkiG9w0BAQsFADCBtDEU
MBIGA1UEChMLRW50cnVzdC5uZXQxQDA+BgNVBAsUN3d3dy5lbnRydXN0Lm5ldC9DUFNfMjA0
OCBpbmNvcnAuIGJ5IHJlZi4gKGxpbWl0cyBsaWFiLikxJTAjBgNVBAsTHChjKSAxOTk5IEVu
dHJ1c3QubmV0IExpbWl0ZWQxMzAxBgNVBAMTKkVudHJ1c3QubmV0IENlcnRpZmljYXRpb24g
QXV0aG9yaXR5ICgyMDQ4KTAeFw0yMDA3MjkxNTQ4MzBaFw0yOTA2MjkxNjE4MzBaMIGlMQsw
CQYDVQQGEwJVUzEWMBQGA1UEChMNRW50cnVzdCwgSW5jLjE5MDcGA1UECxMwd3d3LmVudHJ1
c3QubmV0L0NQUyBpcyBpbmNvcnBvcmF0ZWQgYnkgcmVmZXJlbmNlMR8wHQYDVQQLExYoYykg
MjAxMCBFbnRydXN0LCBJbmMuMSIwIAYDVQQDExlFbnRydXN0IENsYXNzIDIgQ2xpZW50IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxDKNQtCeGZ1bkFoQTLUQACG5B0je
rm6A1v8UUAboda9rRo7npU+tw4yw+nvgGZH98GOtcUnzqBwfqzQZIE5LVOkAk75wCDHeiVOs
V7wk7yqPQtT36pUlXRR20s2nEvobsrRcYUC9X91Xm0RV2MWJGTxlPbno1KUtwizT6oMxogg8
XlmuEi4qCoxe87MxrgqtfuywSQn8py4iHmhkNJ0W46Y9AzFAFveU9ksZNMmX5iKcSN5koIML
WAWYxCJGiQX9o772SUxhAxak+AqZHOLAxn5pAjJXkAOvAJShudzOr+/0fBjOMAvKh/jVXx9Z
UdiLC7k4xljCU3zaJtTb8r2QzQIDAQABo4IBLTCCASkwDgYDVR0PAQH/BAQDAgGGMB0GA1Ud
JQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjASBgNVHRMBAf8ECDAGAQH/AgEAMDMGCCsGAQUF
BwEBBCcwJTAjBggrBgEFBQcwAYYXaHR0cDovL29jc3AuZW50cnVzdC5uZXQwMgYDVR0fBCsw
KTAnoCWgI4YhaHR0cDovL2NybC5lbnRydXN0Lm5ldC8yMDQ4Y2EuY3JsMDsGA1UdIAQ0MDIw
MAYEVR0gADAoMCYGCCsGAQUFBwIBFhpodHRwOi8vd3d3LmVudHJ1c3QubmV0L3JwYTAdBgNV
HQ4EFgQUCZGluunyLip1381+/nfK8t5rmyQwHwYDVR0jBBgwFoAUVeSB0RGAvtiJuQijMfmh
JAkWuXAwDQYJKoZIhvcNAQELBQADggEBAD+96RB180Kn0WyBJqFGIFcSJBVasgwIf91HuT9C
k6QKr0wR7sxrMPS0LITeCheQ+Xg0rq4mRXYFNSSDwJNzmU+lcnFjtAmIEctsbu+UldVJN8+h
APANSxRRRvRocbL+YKE3DyX87yBaM8aph8nqUvbXaUiWzlrPEJv2twHDOiGlyEPAhJ0D+MU0
CIfLiwqDXKojK+n/uN6nSQ5tMhWBMMgn9MD+zxp1zIe7uhGhgmVQBZ/zRZKHoEW4Gedf+EYK
W8zYXWsWkUwVlWrj5PzeBnT2bFTdxCXwaRbW6g4/Wb4BYvlgnx1AszH3EJwv+YpEZthgAk4x
ELH2l47+IIO9TUowggVGMIIELqADAgECAhEAyiICIp1F+xAAAAAATDn2WDANBgkqhkiG9w0B
AQsFADCBpTELMAkGA1UEBhMCVVMxFjAUBgNVBAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsT
MHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5jb3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0G
A1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5jLjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAy
IENsaWVudCBDQTAeFw0yMDEyMTQyMDQzMDlaFw0yMzEyMTUyMTEzMDhaMIGTMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEmMCQGA1UEChMd
Tm9ydGhXZXN0IFJlc2VhcmNoIEFzc29jaWF0ZXMxNTAWBgNVBAMTD09yaW9uIFBvcGxhd3Nr
aTAbBgkqhkiG9w0BCQEWDm9yaW9uQG53cmEuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxBJrIv9eGtrQLaU9pIGsIGBTiW0vZIYmz+5Eoa69sj6t6QANvg0IuVgWZajH
2fu8R+7m/AbZ8Wsuzz+ovtDHiVqUGvGzYyN9a5Ssx94SwNp9zLPfdCRMdh3zJB7gc4GYE/fA
kMkieO8u05f/hSyf9zU5gpjl7SW6p8IjkoyxNOr7KCbI4CQ3+1LG8pn6tz/QJwQ/BJZa4dE0
asXfNlZf5kZtyWtJhwub76zH5uXeODDxY3RooWj1l4V2fQCoFX2ov1ENUW4hRov1cMAD2QHJ
KL0Boir36wISvzq8Z65MSMCGNRiWwRaclVwVZ+QYnlhGZ0g6tMvxVrK+sHnxxr/LOwIDAQAB
o4IBfzCCAXswDgYDVR0PAQH/BAQDAgWgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcD
BDBCBgNVHSAEOzA5MDcGC2CGSAGG+mwKAQQCMCgwJgYIKwYBBQUHAgEWGmh0dHA6Ly93d3cu
ZW50cnVzdC5uZXQvcnBhMGoGCCsGAQUFBwEBBF4wXDAjBggrBgEFBQcwAYYXaHR0cDovL29j
c3AuZW50cnVzdC5uZXQwNQYIKwYBBQUHMAKGKWh0dHA6Ly9haWEuZW50cnVzdC5uZXQvMjA0
OGNsYXNzMnNoYTIuY2VyMDQGA1UdHwQtMCswKaAnoCWGI2h0dHA6Ly9jcmwuZW50cnVzdC5u
ZXQvY2xhc3MyY2EuY3JsMBkGA1UdEQQSMBCBDm9yaW9uQG53cmEuY29tMB8GA1UdIwQYMBaA
FAmRpbrp8i4qdd/Nfv53yvLea5skMB0GA1UdDgQWBBSpChQTknhqMfb9Exia9G14q4j9ZzAJ
BgNVHRMEAjAAMA0GCSqGSIb3DQEBCwUAA4IBAQA15stihwBRGI8nFvZZalsmOHR954D+vrOZ
7cC0kl9K+S9u8j/E5nZd+A6PTKoDpAEYmPUYpe45tZLblnvfJC0yovSIIMTo1z3mRzldHYAt
ttjShH+M6s3xrqDtHfNAwt3TCf6H83sEpBi6wtbALfkIjKuDitgkdZsyUURoeglaaqVRhi2L
5wOOChQAyfsumjT1Gzk9qRtiv8aXzWiLeVKhzRO7a6o0jSdg1skyYKx3SPbIU4po/aT2Ph7V
niN0oqJHI11Fg6BfAey12aj5Uy96ztotiZRQuhWZPOc4d3df2N8RsdWViBp4jXt2hQjNr0Kw
pUPWRO/PENBVS1Uo1oXfMYIEYjCCBF4CAQEwgbswgaUxCzAJBgNVBAYTAlVTMRYwFAYDVQQK
Ew1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BTIGlzIGluY29y
cG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1c3QsIEluYy4x
IjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7EAAAAABMOfZY
MA0GCWCGSAFlAwQCAQUAoIICdzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3
DQEJBTEPFw0yMTEwMTUxNjI0MzVaMC8GCSqGSIb3DQEJBDEiBCAR1xJAf1hRbfwh9nlWdm7x
e6YieYZm7qTxA0XlFDwYizBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAuKbjRxe7jbO9a4Vanle87VeBFEdJ2VXvc7oVksR7Gv74
zYeRHZUq/l1o4JToTkzkUhaD/yjle1zMJXrMFCm92V+0MZSBE0d2tUEnWZxpOxqgXs4dHwpW
iHy3+MMw4O+kX7zOgvs4sqJ8sfWn5Q/KpxQsL/CFHJQhBOypoWGI3byEE2GawYsFb1H60wYY
+YEP3jqIpwHR+mv+N9uzPqOf8xY+eMEXA0KQ9mS6rTI+MYqRzW0YYyLHjdmV4hIig44RT3Qo
Qj4Ni8d/KAfHMah6pFN4Oxvw+7EUk0JjeBif+okt9mDzmfjKJNaMOjVvvrSGhfcgm/Wl5Q5i
+fa237b3bQAAAAAAAA==

--------------ms050704090902060109070609--

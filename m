Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08652C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  9 May 2022 15:32:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238440AbiEIPgc (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 9 May 2022 11:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238455AbiEIPgb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 9 May 2022 11:36:31 -0400
Received: from GCC02-DM3-obe.outbound.protection.outlook.com (mail-dm3gcc02on2101.outbound.protection.outlook.com [40.107.91.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E54F722A2D5
        for <linux-raid@vger.kernel.org>; Mon,  9 May 2022 08:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gR3bvxnahWoJFkK+tmruz770U4Ep1qVv8rnwYl8SP5tBz0K/FNkzGP1GjAqS3wzMqEMWzG1QUo9J3hYL9yWmK5+hTTPeoApNu18CoKMruCOIhqeV14JgTKjDpyaJmhQH5+tvnpKsITMpLoN7fY4iOotvGuKJbG9qLSC22KcPYbNoVTUimm1WWuz66ciWyLHQVymnlLINnq5qK/ualniVVckrq/u5osjsYEQOnLZzWg20IMo8nQnhZEoAc/fXbeBvDlxjXpAiX2IPjhDipS5mkFPw0T2ahrPKpdA2uH3YXR9eQ/Z5tw+osxdwdPekO/gjM3pp1JmFfaw9CFrbSmobsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T4hCH241K2bnyZyTY+31/EgUMVruPwlwsa3rkrBoNvQ=;
 b=V+smmXnN8dzO68CalFx+6BbI8bbQOWiCMIM6g/aNtUkW8pVnTHoDizR/aBpCIm7OYSgSK/NSQMHMDycc+LPSxQAKSdmT8WZ9gO5V4RstqPiykumWGtwmETJQWvbZw81jxyGZkZS+VmLvK92WoA4w5Uv+0ew0kDKo4pNxhj5xIdvRALaER28oVOwibaXNByj7YDUE1SpylrIfwAVUkEVCVY7XfqBYfyVR1KKbzUqM6XAyJ94uPRDkT6RP8szFjv0sskuO6TUUvzIfGLjn60rKkcA/61lk8HsAUVYkpWUChP5zcPu/XS1PdYqegos36D6zQxDylMEoemHq31nmVugVVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nwra.com; dmarc=pass action=none header.from=nwra.com;
 dkim=pass header.d=nwra.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nwra.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T4hCH241K2bnyZyTY+31/EgUMVruPwlwsa3rkrBoNvQ=;
 b=YPWetu9yMtQT8QEV/EuT7/Z1Rqp/cQl/XUKCiHH2kQK1rVtyi1SmvOEdj0JFrvScypfG3LNd6lQhdFjIKu/UYPfADdos9e8LIkC4bAnkyEz9E88AN/mkrurU4cgsAl7xssenY5R4kJxwqgp4JN9jbxQDTOCVuMSxNUSbLyb8KXO8lffbhORd1C6ZqgOifmC1tuW3a3LxxP8QAqITLh61+kl20M55RYD0GtMWSYKMaJVWbCrJ5uuCAz5ktZttAkBnpyg1nDVXymFWbbdAJ1963geTG+m1MHSuiDgUtlLojaig/uhcWbYZXkP9W6haRfrRND4b32gxUsayblz8bdB+Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nwra.com;
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com (2603:10b6:a03:26b::14)
 by BY3PR09MB8132.namprd09.prod.outlook.com (2603:10b6:a03:34a::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Mon, 9 May
 2022 15:32:29 +0000
Received: from SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368]) by SJ0PR09MB6318.namprd09.prod.outlook.com
 ([fe80::adad:368e:3553:5368%4]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 15:32:28 +0000
Message-ID: <d9a9516f-695e-3ead-6744-1510b13148c4@nwra.com>
Date:   Mon, 9 May 2022 09:32:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-US
To:     linux-raid@vger.kernel.org
From:   Orion Poplawski <orion@nwra.com>
Subject: nvme raid locking up
Organization: NWRA
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070205050604030800050800"
X-ClientProxiedBy: CY5PR15CA0042.namprd15.prod.outlook.com
 (2603:10b6:930:1b::26) To SJ0PR09MB6318.namprd09.prod.outlook.com
 (2603:10b6:a03:26b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e51916a8-ba1c-4f79-c9de-08da31d1205d
X-MS-TrafficTypeDiagnostic: BY3PR09MB8132:EE_
X-Microsoft-Antispam-PRVS: <BY3PR09MB8132479F23DEC51284A5E94ECAC69@BY3PR09MB8132.namprd09.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G5WBx5v2HOgPG2Rd+NLBOSRbQQMmgU/zNA4QWCjWpX/Mtwq2S50yC/hWO/K1SD9OEBCfql0v+kVH05QBZirvCulhRY37wjxXSOfxNkaUxezZ8r99Fe3lUTgexTfqfCVvly40gcECqDQVQIYbTFTZr4VnmEJO795PLmnqOKbulvAkPBvkewOqN6CZlSV2vtkaC89ArMlvacdRkYqXGo4JUzSzSHYASVXn9U9iFHUIbBhpMqb/byqPBoYZFVmnElMWaan6tFgFusRukB2REzVAgb1uO3z0wSGzCqL0s1vuFdUmn3UfUzMVAjhEBYTsVPNP6UF6mxWwHFfTGMzTyuCOI7c5N9uuIDZXqugTmLRWZrsbpZ++By3h2o1XwOBWpFbjEorKW/NHsBb1Zge99LpKIZrMIAMYPuwxDJAUx9f1Nx6OH/Rvhu10qq3gT6G6jZGgLP4yIpMRAIz/gLKhXWHD5CrUIyrgglVlfFCVxI9uYzjX5tX69LvIt7Qrcf+H1qpfL/x/qH8ssECrQWoNV0HTG5hHVJXHKV/H5zoteHl+bx3Jj+JqXbu4KJACgMaTDIqJRqvbVSoJa2Ygn/Xys0x+i864eYUpy0MKSGDWY5vsNZbtTy8bYd3/MiR5ObpcgZhAP7m5XdlPCqzGYVYt/jprOvujS8GNb8DYjfDN2afTkN9jeQg6CrGRgmALXNjF6IlwoeojZoQZV7l5dA34s9iiUlRT/1eJU0Ff3sN+BwetR7cp90r/3IKosySFtwXtuovbNlkuxdhbnqbZOs/hU56mAh6kMwRK+KX7w/04IjsxrkfWCZMEhFyrkHOYAwXRxkaa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR09MB6318.namprd09.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39830400003)(346002)(136003)(396003)(376002)(366004)(36756003)(186003)(66946007)(66476007)(8936002)(3480700007)(66556008)(40140700001)(26005)(5660300002)(83380400001)(2616005)(6512007)(235185007)(8676002)(508600001)(31696002)(33964004)(6916009)(86362001)(31686004)(6506007)(36916002)(966005)(6486002)(2906002)(6666004)(316002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bWhNSHRtUjMwYlVmWmprTkNiL1hzTEJ5QkxlSGZrMnh0dmJYazBZcjBpcmd0?=
 =?utf-8?B?M0VDc1RGOTRBWitkSC85MUtGbDkrU0ZpcnVMOVpsRWpCK0twVlRldnVHdWpM?=
 =?utf-8?B?R2ZDSFUzK2pWZ2Y3dEhURGFxaGIxWlRpMzVaaGttMkxsYkZzOUVJLyt4VXBp?=
 =?utf-8?B?SVRUV3BtQlFpSXVPbyt6aXpiQ1lUZWcyeVBjQmZKeGQvZnhNSzYxV1l2K1dM?=
 =?utf-8?B?N0ZTZ2EzY3liZUQxUnBxWlRyeVFJWVU1bTRHbnZrOHRyangvV2k0elg5Ykxq?=
 =?utf-8?B?RCtscy80Ny9zY2xnb2ZOdHk5TFBFbE81SGdGOVdxU3NsN1pxSERRYW1GR0VJ?=
 =?utf-8?B?aDliWCtuVGlOdWxPL0hvYUN0dEx0cDBIWUpjV0swb2F0cEJWbEpzdUlqb0N4?=
 =?utf-8?B?dDF4VDB1akxYSlh4cFlvNmdBUTNmMGEwTlZxMUcxQUNnUUdUVk5UV2N2d2x5?=
 =?utf-8?B?ek1uOGdySWZsWFgxUVZ2cHFtRldqSUlITWp5YWRIR09qejh2YXVXQmJEb1JJ?=
 =?utf-8?B?OWZBZHpqZVdMOEg4aktxN1lrbFZGL2NIU3dHd29GYXo3aUtmMDhQNHl2Q0dE?=
 =?utf-8?B?blhMSXFSRk1sMkFZcEFzTXlnTGQ0YWZHR1pMREhGOFU2UEtMaERYZWRWWTF3?=
 =?utf-8?B?V041V2hEeDU3em5tL1F0UlN3TVVQazB0VjRmUHM5VFhtL1hLSXhOZjE3SDht?=
 =?utf-8?B?Yjlmam1IZW50cVZvcUU5SSs4am4ydEZ1ZkJWVllkc1pVY3NOTUduQzdhdnFk?=
 =?utf-8?B?cHcvL0wxSEZPWGN5Z3o5bmExNFZjVHFSbktQMjJuM2RSd2VIbHFFT20yTXYw?=
 =?utf-8?B?SGh1MnVFdEJsbGNBbU1vQ2FRNXpTVE1TbUpUdEc5aVVJR0RVL3VNUFBnT3or?=
 =?utf-8?B?Ym91V3UzSlNaRXJueFJGZnc3cUJvOWVONnV2bkN2L21GK2dpa1hQNUhhOFNL?=
 =?utf-8?B?T1M0TXJkNW4vSk1rOXhHaXlsclgzREp5NFNmc1hFYmhVMXord2hpU1dxLzJU?=
 =?utf-8?B?eStjbmVVWi9iVFk2dlJkclBUOUFJRnV6ejlVdXcxd1hxY2dndnZLLzhuRDZ1?=
 =?utf-8?B?SEVOeGxlOW9DaWU3ZWZGV2dPMEdnMjcwWFBTeTBEbitoSWZuWUdxRW45TUlR?=
 =?utf-8?B?NlBtMlNCNEtURFJPbVpKb2tnOVpYWWlRVUJxT1FHbjZHYnB4MUJhUE1GeXgy?=
 =?utf-8?B?WXF2VmY1eWRSWXg1bVFIMFVqRUJTdjFzNHFwRDlKbk1vMG5sS2VRelJRdHY2?=
 =?utf-8?B?V2c3N2JBWlpXTWtSMW1aZGtjR09VZGJFYUt3alBwQ0F5OUVicmR1eHhzbTE4?=
 =?utf-8?B?VXBhd1g5T0dLZDhMaHJ5RE5RY3cySlc1VGxGTmpHVXQ5WElSYVYvS21DL09F?=
 =?utf-8?B?d09Jc2hDZGlaNk1vT2dLd3ZwWnIxeWo3ajYvb1BFRzUzVjFNeDQyYmxzRXlI?=
 =?utf-8?B?VnNqeFRmMDlFN2p3TDdvazRaZUtxdzJRUU1YS0FUbFJhcU1YalJKQnZJZE1Z?=
 =?utf-8?B?SWNiTTVIR08zdnVCbStaUHMzWWtRRnpqN3lCcll4TzJ3M1plZzd2MFA5T1dz?=
 =?utf-8?B?WjVzZFNGS0dFU0NMVTJCRy8veFduaUwxYUxSbVFoYXB3U2ZxR1oxdGd4RUhq?=
 =?utf-8?B?Z2ZhQ1grY2sraHhsVWlheklHbHZ5ZHV5MG5mUFQ5endsNSthUHNrUVB0eXln?=
 =?utf-8?B?NlhnNkhaeWdzMm1YTUN6ZVpQQWd2bUxxMHY5QzhjMEM1U3Z4NlFOSWN4OXY2?=
 =?utf-8?B?dlRSb0xzVEk1SjdyelhibWJJWENYT1QwVXlaN29HMXFtS2gxTnJ4NXVqZlFR?=
 =?utf-8?B?OTc4L3dhaWw4dDJWUnJGZGZJa2g4SSt3SEgrMzBjQ2FQUHNIN0FVQ29CTndV?=
 =?utf-8?B?RjhEUG8zeklFaFQ1eC9GaWpLc2pIajB5VGNtUXFmalFLbmJ6ZCsvL2Y5cmgv?=
 =?utf-8?B?VkY1eWl6SFFxd2dEMWgrcGUzY2l3RnMxazdEVHFDaXNoSWR4eEJHMmg2RTFU?=
 =?utf-8?B?OFN0dGU5eHkyZmkyK2hSeloxV0hxcHBJMkdJb09LSTh3Q1VYMmFDOVh6anJQ?=
 =?utf-8?B?Y3NwOEw2K2tOV3owazIrb2ZGK25LaEpHMWFmV3ZFL2t3TXFHODhIY1hoeTkx?=
 =?utf-8?B?TmorSVYzZjVGZUpNcmcxMllBUkV1aHoxdWdKMDhLMS94MnM3ckt3WXN1aTRy?=
 =?utf-8?B?SHRQUTJxRmROVEFVWG5rYnpGdGNNUHIvUDNPQVNBUTVrZGMwTzFQRHQ1ZTRk?=
 =?utf-8?B?MWlMTEJUNmV4WlBXWjM0Ym16SU52K0N3eS9xc2Q3QTcwM2wxSGh4UUJqcHA5?=
 =?utf-8?B?NW9yVXJKZ3JyY2p0VHdzYVo5NUh4RjhHdW5pVVBNZmRJMTdtcXZ2UT09?=
X-OriginatorOrg: nwra.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e51916a8-ba1c-4f79-c9de-08da31d1205d
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR09MB6318.namprd09.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 15:32:28.8227
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 761303a3-2ec2-424e-8122-be8b689b4996
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR09MB8132
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

--------------ms070205050604030800050800
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello -

  I have an HP DL380 Gen 9 with a RAID5 array built from 6 INTEL SSDPE2MX020T4
devices.  That raid device makes up a volume group with a couple logical
volumes with XFS filesystems backing VM storage.  Twice now in 2 months the
raid array has become mostly unresponsive:

May 08 03:33:21 host kernel: INFO: task worker:1798511 blocked for more than
120 seconds.
May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
May 08 03:33:21 host kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 08 03:33:21 host kernel: task:worker          state:D stack:    0
pid:1798511 ppid:     1 flags:0x000043a0
May 08 03:33:21 host kernel: Call Trace:
May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  schedule+0x37/0xa0
May 08 03:33:21 host kernel:  md_bitmap_startwrite+0x16f/0x1e0
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  add_stripe_bio+0x4a3/0x7c0 [raid456]
May 08 03:33:21 host kernel:  raid5_make_request+0x1bf/0xb60 [raid456]
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  ? blk_queue_split+0xd4/0x660
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  md_handle_request+0x119/0x190
May 08 03:33:21 host kernel:  md_make_request+0x84/0x160
May 08 03:33:21 host kernel:  generic_make_request+0x25b/0x350
May 08 03:33:21 host kernel:  submit_bio+0x3c/0x160
May 08 03:33:21 host kernel:  iomap_submit_ioend.isra.38+0x4a/0x70
May 08 03:33:21 host kernel:  iomap_writepage_map+0x422/0x670
May 08 03:33:21 host kernel:  write_cache_pages+0x197/0x420
May 08 03:33:21 host kernel:  ? iomap_invalidatepage+0xe0/0xe0
May 08 03:33:21 host kernel:  iomap_writepages+0x1c/0x40
May 08 03:33:21 host kernel:  xfs_vm_writepages+0x64/0x90 [xfs]
May 08 03:33:21 host kernel:  do_writepages+0x41/0xd0
May 08 03:33:21 host kernel:  __filemap_fdatawrite_range+0xcb/0x100
May 08 03:33:21 host kernel:  file_write_and_wait_range+0x4c/0xa0
May 08 03:33:21 host kernel:  xfs_file_fsync+0x69/0x200 [xfs]
May 08 03:33:21 host kernel:  do_fsync+0x38/0x70
May 08 03:33:21 host kernel:  __x64_sys_fdatasync+0x13/0x20
May 08 03:33:21 host kernel:  do_syscall_64+0x5b/0x1a0
May 08 03:33:21 host kernel:  entry_SYSCALL_64_after_hwframe+0x65/0xca
May 08 03:33:21 host kernel: RIP: 0033:0x7f969efb858f
May 08 03:33:21 host kernel: Code: Unable to access opcode bytes at RIP
0x7f969efb8565.
May 08 03:33:21 host kernel: RSP: 002b:00007f94b3ffe6b0 EFLAGS: 00000293
ORIG_RAX: 000000000000004b
May 08 03:33:21 host kernel: RAX: ffffffffffffffda RBX: 000000000000000e RCX:
00007f969efb858f
May 08 03:33:21 host kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000000000000000e
May 08 03:33:21 host kernel: RBP: 0000563f940b5b20 R08: 0000000000000000 R09:
0000000032f01b0c
May 08 03:33:21 host kernel: R10: 0000000e171e5000 R11: 0000000000000293 R12:
0000563f92a73bb4
May 08 03:33:21 host kernel: R13: 0000563f940b5b88 R14: 0000563f94097eb0 R15:
00007f94b3ffe800
May 08 03:33:21 host kernel: INFO: task worker:1799573 blocked for more than
120 seconds.
May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
May 08 03:33:21 host kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 08 03:33:21 host kernel: task:worker          state:D stack:    0
pid:1799573 ppid:     1 flags:0x000043a0
May 08 03:33:21 host kernel: Call Trace:
May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
May 08 03:33:21 host kernel:  schedule+0x37/0xa0
May 08 03:33:21 host kernel:  io_schedule+0x12/0x40
May 08 03:33:21 host kernel:  wait_on_page_bit+0x137/0x230
May 08 03:33:21 host kernel:  ? file_fdatawait_range+0x20/0x20
May 08 03:33:21 host kernel:  __filemap_fdatawait_range+0x88/0xe0
May 08 03:33:21 host kernel:  file_write_and_wait_range+0x76/0xa0
May 08 03:33:21 host kernel:  xfs_file_fsync+0x69/0x200 [xfs]
May 08 03:33:21 host kernel:  do_fsync+0x38/0x70
May 08 03:33:21 host kernel:  __x64_sys_fdatasync+0x13/0x20
May 08 03:33:21 host kernel:  do_syscall_64+0x5b/0x1a0
May 08 03:33:21 host kernel:  entry_SYSCALL_64_after_hwframe+0x65/0xca
May 08 03:33:21 host kernel: RIP: 0033:0x7f20c514c58f
May 08 03:33:21 host kernel: Code: Unable to access opcode bytes at RIP
0x7f20c514c565.
May 08 03:33:21 host kernel: RSP: 002b:00007f1ef4ff86b0 EFLAGS: 00000293
ORIG_RAX: 000000000000004b
May 08 03:33:21 host kernel: RAX: ffffffffffffffda RBX: 000000000000001b RCX:
00007f20c514c58f
May 08 03:33:21 host kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000000000000001b
May 08 03:33:21 host kernel: RBP: 00005594bed1f120 R08: 0000000000000000 R09:
00000000ffffffff
May 08 03:33:21 host kernel: R10: 00007f1ef4ff86a0 R11: 0000000000000293 R12:
00005594bd72ebb4
May 08 03:33:21 host kernel: R13: 00005594bed1f188 R14: 00005594bed31c30 R15:
00007f1ef4ff8800
May 08 03:33:21 host kernel: INFO: task worker:871154 blocked for more than
120 seconds.
May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
May 08 03:33:21 host kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 08 03:33:21 host kernel: task:worker          state:D stack:    0
pid:871154 ppid:     1 flags:0x000043a0
May 08 03:33:21 host kernel: Call Trace:
May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
May 08 03:33:21 host kernel:  schedule+0x37/0xa0
May 08 03:33:21 host kernel:  io_schedule+0x12/0x40
May 08 03:33:21 host kernel:  wait_on_page_bit+0x137/0x230
May 08 03:33:21 host kernel:  ? file_fdatawait_range+0x20/0x20
May 08 03:33:21 host kernel:  __filemap_fdatawait_range+0x88/0xe0
May 08 03:33:21 host kernel:  file_write_and_wait_range+0x76/0xa0
May 08 03:33:21 host kernel:  xfs_file_fsync+0x69/0x200 [xfs]
May 08 03:33:21 host kernel:  do_fsync+0x38/0x70
May 08 03:33:21 host kernel:  __x64_sys_fdatasync+0x13/0x20
May 08 03:33:21 host kernel:  do_syscall_64+0x5b/0x1a0
May 08 03:33:21 host kernel:  entry_SYSCALL_64_after_hwframe+0x65/0xca
May 08 03:33:21 host kernel: RIP: 0033:0x7f13d27fd58f
May 08 03:33:21 host kernel: Code: Unable to access opcode bytes at RIP
0x7f13d27fd565.
May 08 03:33:21 host kernel: RSP: 002b:00007f0f697f96b0 EFLAGS: 00000293
ORIG_RAX: 000000000000004b
May 08 03:33:21 host kernel: RAX: ffffffffffffffda RBX: 000000000000000e RCX:
00007f13d27fd58f
May 08 03:33:21 host kernel: RDX: 0000000000000000 RSI: 0000000000000000 RDI:
000000000000000e
May 08 03:33:21 host kernel: RBP: 00005594f48b9010 R08: 0000000000000000 R09:
00000000ffffffff
May 08 03:33:21 host kernel: R10: 00007f0f697f96a0 R11: 0000000000000293 R12:
00005594f2222bb4
May 08 03:33:21 host kernel: R13: 00005594f48b9078 R14: 00005594f4e8ee50 R15:
00007f0f697f9800
May 08 03:33:21 host kernel: INFO: task kworker/u97:2:1790841 blocked for more
than 120 seconds.
May 08 03:33:21 host kernel:       Not tainted 4.18.0-348.23.1.el8_5.x86_64 #1
May 08 03:33:21 host kernel: "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
May 08 03:33:21 host kernel: task:kworker/u97:2   state:D stack:    0
pid:1790841 ppid:     2 flags:0x80004080
May 08 03:33:21 host kernel: Workqueue: writeback wb_workfn (flush-253:3)
May 08 03:33:21 host kernel: Call Trace:
May 08 03:33:21 host kernel:  __schedule+0x2bd/0x760
May 08 03:33:21 host kernel:  ? blk_flush_plug_list+0xc2/0x100
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  schedule+0x37/0xa0
May 08 03:33:21 host kernel:  md_bitmap_startwrite+0x16f/0x1e0
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  add_stripe_bio+0x4a3/0x7c0 [raid456]
May 08 03:33:21 host kernel:  raid5_make_request+0x1bf/0xb60 [raid456]
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  ? blk_queue_split+0xd4/0x660
May 08 03:33:21 host kernel:  ? finish_wait+0x80/0x80
May 08 03:33:21 host kernel:  md_handle_request+0x119/0x190
May 08 03:33:21 host kernel:  md_make_request+0x84/0x160
May 08 03:33:21 host kernel:  generic_make_request+0x25b/0x350
May 08 03:33:21 host kernel:  submit_bio+0x3c/0x160
May 08 03:33:21 host kernel:  iomap_submit_ioend.isra.38+0x4a/0x70
May 08 03:33:21 host kernel:  iomap_writepage_map+0x422/0x670
May 08 03:33:21 host kernel:  write_cache_pages+0x197/0x420
May 08 03:33:21 host kernel:  ? iomap_invalidatepage+0xe0/0xe0
May 08 03:33:21 host kernel:  iomap_writepages+0x1c/0x40
May 08 03:33:21 host kernel:  xfs_vm_writepages+0x64/0x90 [xfs]
May 08 03:33:21 host kernel:  do_writepages+0x41/0xd0
May 08 03:33:21 host kernel:  __writeback_single_inode+0x39/0x2f0
May 08 03:33:21 host kernel:  writeback_sb_inodes+0x1e6/0x450
May 08 03:33:21 host kernel:  __writeback_inodes_wb+0x5f/0xc0
May 08 03:33:21 host kernel:  wb_writeback+0x25b/0x2f0
May 08 03:33:21 host kernel:  wb_workfn+0x344/0x4c0
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x35/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x41/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x35/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x41/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x35/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x41/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x35/0x70
May 08 03:33:21 host kernel:  ? __switch_to_asm+0x41/0x70
May 08 03:33:21 host kernel:  process_one_work+0x1a7/0x360
May 08 03:33:21 host kernel:  worker_thread+0x30/0x390
May 08 03:33:21 host kernel:  ? create_worker+0x1a0/0x1a0
May 08 03:33:21 host kernel:  kthread+0x116/0x130
May 08 03:33:21 host kernel:  ? kthread_flush_work_fn+0x10/0x10
May 08 03:33:21 host kernel:  ret_from_fork+0x35/0x40

I have another nearly identical system that has run without trouble, though
not with as much IO load as this one.  Is there anything else I can check to
see if there is a hardware issue or if this might be an issue with the linux
RAID system?  Is there a better place to ask for help?

Thank you.

-- 
Orion Poplawski
IT Systems Manager                         720-772-5637
NWRA, Boulder/CoRA Office             FAX: 303-415-9702
3380 Mitchell Lane                       orion@nwra.com
Boulder, CO 80301                 https://www.nwra.com/

--------------ms070205050604030800050800
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
DQEJBTEPFw0yMjA1MDkxNTMyMjVaMC8GCSqGSIb3DQEJBDEiBCAsao8NRElpdtwilVgw+ldw
DPQP9pGKc6Te+JB01UOHdDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjALBglghkgB
ZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFAMAcGBSsO
AwIHMA0GCCqGSIb3DQMCAgEoMIHMBgkrBgEEAYI3EAQxgb4wgbswgaUxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1FbnRydXN0LCBJbmMuMTkwNwYDVQQLEzB3d3cuZW50cnVzdC5uZXQvQ1BT
IGlzIGluY29ycG9yYXRlZCBieSByZWZlcmVuY2UxHzAdBgNVBAsTFihjKSAyMDEwIEVudHJ1
c3QsIEluYy4xIjAgBgNVBAMTGUVudHJ1c3QgQ2xhc3MgMiBDbGllbnQgQ0ECEQDKIgIinUX7
EAAAAABMOfZYMIHOBgsqhkiG9w0BCRACCzGBvqCBuzCBpTELMAkGA1UEBhMCVVMxFjAUBgNV
BAoTDUVudHJ1c3QsIEluYy4xOTA3BgNVBAsTMHd3dy5lbnRydXN0Lm5ldC9DUFMgaXMgaW5j
b3Jwb3JhdGVkIGJ5IHJlZmVyZW5jZTEfMB0GA1UECxMWKGMpIDIwMTAgRW50cnVzdCwgSW5j
LjEiMCAGA1UEAxMZRW50cnVzdCBDbGFzcyAyIENsaWVudCBDQQIRAMoiAiKdRfsQAAAAAEw5
9lgwDQYJKoZIhvcNAQEBBQAEggEAVxpHKhoF0CEq9Lw0wd3yopt6QNg2fgs4N4XV6IUgOWDI
5qAvMouYoAaKGYBQ5sYDFe6IP4RDB9f9DD+Pc6OH1lT6YynLqYKJLpqki5PERU4F3SSO809D
Y4JEoOJXULJDW8jDfq85HNsWfz0VRM6C63kIyoIwkaubptmDFKR2vcFRTF+CzMWqUpNhNuWO
YgjVgEBGHnVzihaFpLJLI1B6eiUceKiOJ92bPoHlxxifn8dPreeTAdRPHOMotebJH70swNEO
qBTMqnPdhjjgNPSe2Xrqec7TzFKiS9DRhNKxdZ8G8Y5oe1Jp24eExn8+8Ij343lRvAC8PExx
cLMwUnlx1QAAAAAAAA==

--------------ms070205050604030800050800--

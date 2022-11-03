Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361F8C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 14:46:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiKCOqx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Nov 2022 10:46:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiKCOqs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Nov 2022 10:46:48 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6266306
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 07:46:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jQXz/9r+5lqCrUnN0isGPvQF8uivlJRvpxbvsHwx/30LOmZ5p5QL/AhBu9j8ptcCPKdOJCNsCcM1VAfs1IBjVyT+j5mdcoeo5Hl2MTeaCOrxC2lACLK1bl2pKRQBwrNZm9z83/CJD9CpluvZkmwpxuIZMNH0Sy2O5K3nK0pYpaTwjWUaqKcnkVhIo5+b2FEsDSio28V7nm04SOiy176JhqK0ReU8kpc3RMJMrXUpD4ALCXj7NRuar4KvTXD6oFsJLfP1WwqbrkM+qf4Gb6n8toShCfaAyj42YX1T5R25u8AnEHGuLcyjn3pHcfE7zg1uk/K/ZPDmcIg/wPkAdM8j9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43CJudnNBoEF236fwZtRKnIh+EReFQEMemYTjWLMrHo=;
 b=jA1qFsRf4HiU0TzoF17UZyDN05Lh8uDUHwhhj+/JF+CF3qt06XnWStKz4F+EtjnG7D4AL6ZISZmJZte+xOS45A1BG9pqVcdTKrlrjxCt85EuM8R3KVB3YOF1OoIm1qlUP1ou6oC0PeTNERBth0KAtoaxR+XsSuWqb+xrFFy+CCtt2tGqWZ9XDeUPZHyHWCM7o8zGaWPWz+iFkRqIdKYrcO4x6XC4IGJIWJrUa1eXI4lLcjdT6L1VJCKl6I7jNpjF3dYFWs+RfXb9P+xhwFc3MoH+mIUHsWiJErZMy/VR1V1XU1UBt1v9LVwNyZsixLso8181pfLOOw5NLzCHi1tSvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43CJudnNBoEF236fwZtRKnIh+EReFQEMemYTjWLMrHo=;
 b=0mY/HLq6FcE6i00siGUqauIfyc6GleUaS86E6RVwy0mIvbF5wZePOm02qYojeeODImJOHzFkmTMsYiC15fnCU6JT4iTdf+BQ6+Dnb5/e6mntdtQi8pmCuasA5tCfhim3F0B0rSXakZEtljebeYkKJOdIQNq2f9dXo+6ehlGe+/Lcacx+QqcqkXdSMeVUn5hDc6Ffvy9255UY3vG5SVF2FJxmQFfbKBKBZZvuJr8kehUKXLvefjvlVhkaPcqMDVAULIHsvBZY2os9z7QjBOB0bKN7T0TmrpqEiQAWZQYkvDIVuRLVOjnznqjC+lShqd++skPKLgiUwaO7y1fboZ4b7Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 VI1PR04MB6893.eurprd04.prod.outlook.com (2603:10a6:803:133::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5769.15; Thu, 3 Nov 2022 14:46:44 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2554:cfdf:10b:487c]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::2554:cfdf:10b:487c%7]) with mapi id 15.20.5769.019; Thu, 3 Nov 2022
 14:46:44 +0000
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Song Liu <song@kernel.org>
Cc:     Zdenek Kabelac <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
From:   Heming Zhao <heming.zhao@suse.com>
Message-ID: <11a466f0-ecfe-c1e2-d967-2d648ce65bcb@suse.com>
Date:   Thu, 3 Nov 2022 22:46:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0210.apcprd06.prod.outlook.com
 (2603:1096:4:68::18) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR04MB4666:EE_|VI1PR04MB6893:EE_
X-MS-Office365-Filtering-Correlation-Id: a0fe2f28-7d2f-4004-15bf-08dabdaa39fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +fMzCBfPXw185RSWWWLR8MaoEY4dOXUJEpLXwdE9M9XWFRkZlw/KuV0SMdHp7aV+BeUkg8aEhjlrP/PGnptHyiPw1NhMJZvKOFYSmVadcps1MyFC/aTmtSVSGVHDPFmZg9y95IwGvq8YzjwB+ebjCbj16MB+joVT1++W87PXG1a7uAZ/EZs0/e97DSuFM5xj9mlHjIICRT9jykuphQ4vd/bJc+y+H3SVTU3dEF9mzGHwKrzLid9s4bS54AdgIuFg676H8UeD8Vu2N5yPfsv0TnhPtEg4bLwgus/Gd2Dw47X3GupOP+INqfR8oDeuV/0/5t5ZmmhwYZU5fAfivniAo26LIEr8KOVA6gue03WIy3DUSmTkKnZdcg8Ob1iVGk6E+1ItB0BKU+CCU/pBGmPlOsavI4u9aw02+Onoy+XjYEQxRo9bIHkwMlioQqeJikCqXw2KpofowbwOhBvqsHdifPNYVAR3O9AYBL+0bqWDxjeHCxAbceTkVEFXRP9Gq8bW+01c1tAeQxyHoeUcaRW7tMpvnVjQvS0SsxJGMGH0B6ZnJBaLH1iGFNIGhpsGV75igyVN+uQOii5YamUuaibfkP1utZZWSliD7A4mfjhYUoKoAG+J6AyVoIjZbKzZVjojTBQ5fhHCL//byXYtzbKQBSnnB/UIY1858QV8AtWg6R9rrWWzO+gWyVFXxUm+jiH7pq5EQe2y7Ft5C8kCPJK74etdnH2a8PyJVLyEwDdIaFFiUX32PK8dFPl342Oqamr6hwCFacNXICYAL6sOA0q9YLSlHP61XDL+7B+kTa+fJbkfa31VLgpsNp7R44VCeqPjMkBPu84wNiwNyaY/FMFE8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(396003)(39860400002)(366004)(451199015)(31686004)(36756003)(6666004)(5660300002)(2906002)(38100700002)(83380400001)(31696002)(86362001)(8936002)(26005)(186003)(2616005)(44832011)(41300700001)(19627235002)(316002)(110136005)(66946007)(478600001)(6486002)(966005)(45080400002)(53546011)(4326008)(8676002)(66476007)(6512007)(6506007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MDhnc3owd0hsaW5nV2Z6VUlsWHhtNlU0RW9LRVVXOHpkN3M5Qlh4dkRQd3FD?=
 =?utf-8?B?eGtEK1BwS3B4QnFRTklqditCSWlRMVQvR1VobUhiOG10bG9oTTFDcVRBSnY4?=
 =?utf-8?B?QmNBTXdWWUZvVWluYWJCUlVGWUVQaGJDbTdSWEx2M2V3L0Y2Mk1FeG1JY1dD?=
 =?utf-8?B?czkrY1dVbHZRMUhzK1lKOFp3VTgraEd0cjMxRkRRc2ZLaHVhdHZ0WEhDQXBo?=
 =?utf-8?B?UGY1L1ZZNUxTRit2RnBEQUpxcWZUK0ZDaUNzcmZVVWl0ZWY5eHh5MkhsQXd6?=
 =?utf-8?B?bkxCTUROeWlRbUJlMnFTMFd6QVJKT2N5c3JGUWlSeFE5MkJyZlMvQW9pRkNv?=
 =?utf-8?B?ZmgrRkVLRWJXNURpSHAreFR6U0IrWFBUOTkwSTUweURwcmhZTDF6ZVlLa3dC?=
 =?utf-8?B?a25MOHA1MWxHbXMzUnUzUW10ZDVNcnVJc3d6aG04eVgxdlZ0bzNBenBhQ2VG?=
 =?utf-8?B?TFdpNEtDSWt1ekgvVFdJUU5CRzlMV1NGcldpdENIblVWZGRHVzJCUUlYV3o3?=
 =?utf-8?B?Tmk0QnNQNzl5ZGxzSDd1NDBrZ0dUNGw5VW9XVENMcU9CRkxacVhFMVIvL0NE?=
 =?utf-8?B?aXo4YnpNWEpGN215OUNKZDdCdDFyWHlnWG9zV2R3T1ljMFF6UGNqY2k2UVRV?=
 =?utf-8?B?Z1hEQ2ZwOTdDT1ZqcllvS1JOSHg3Uk9OdmpOVkd3SjIvUWpDajJPOWI2cHJG?=
 =?utf-8?B?SHJ3VDN3TDc5TTRNOGdhelVRY1prdWQ3d0VudE9FUVYwZ0hCK0t1OFAwWmFD?=
 =?utf-8?B?OHU2eVBYMFNSby9DRDh5Z2o2bStpNHVJN05jaWIrbmRaZU1ya3VYMnJ6aHVa?=
 =?utf-8?B?YnA5NWxreWtpK1VtNlg0VkxpT3JaYndnYVVyMkFWbDNITFFiejV1K0h3ZC9B?=
 =?utf-8?B?T0cwT05YcitEK1ZoQ1BIVGFQY1dVQlhWN2NVbTdXRk9IcklPYkwxZzB6NDc4?=
 =?utf-8?B?VjI5RytFOXBIeFZRdStRaGxNUjIyYWt5ek9FV3M4TXRqN1FucUNRRmdVbllB?=
 =?utf-8?B?cm1MaXlsOGtCR3FTNmRNbklERzN0RTBDb2U0ZFBiSEd1cWRETU44aEJZSWgv?=
 =?utf-8?B?aHFDSk9UeFNJSWdHOW9kODdBOE40MUpvdnBYZ0t5SWVOeHAzclFPNUFqa2pI?=
 =?utf-8?B?OUU1ZkVueTcvNFBnMC9zQi9ZYWM3dEx1d0tJTDcycFRHOUJ2QkFIamswVkZL?=
 =?utf-8?B?Ti9SQ3NLTTRka0VVeWxxbUp3M3BiTnlaQkV0Mm5uNFk4bzR3VHNDZ2J2VFFn?=
 =?utf-8?B?c3d0SzdXclYzRmFiUkNkeWphTEpPK1pjckh2OW0xdVFoYkVzSEpQdHNtbnJm?=
 =?utf-8?B?MnNZS0k5bjdNMTZ4RGlpczZCSlIxdFdJcVB1TzgwYnljc1h5REk2ajE1YXJn?=
 =?utf-8?B?MFJrM1BoZGg5WEtXSWY4b3FiMHJWOWtxN1lJWWxZbUVtdTNKczNLeDU3R3A3?=
 =?utf-8?B?cG0vNHpxcGh1aGMweE1HMjRSLzhsOTEwc3NZdUZ3SUdJZVdZWWRCekdUelZS?=
 =?utf-8?B?OXExS2JSbnJzS1duMy9vOVNaTG9sUFptV1ZtZlpLYytndStwQ0Z6WVJkbXp1?=
 =?utf-8?B?VmVlcEZ4U0I3dnQ3SGRUKzJXMndUZjQreGVQVTN6U3haYnh3WDdKanhlYWhm?=
 =?utf-8?B?VUF5N1F2OWkwMkcyMUhqT1pMUWh4QjdJdkVLUEkyaTlwWEdzVlBxWFZHQXl2?=
 =?utf-8?B?VkRKMWtmUUF1SXZkQm9QLzF5Z3ZlYnlDcjNuTDVPN0xESVUvYVVSMGpCWHJ6?=
 =?utf-8?B?YS92QzJvWW9Sb1VVbkxrL2lTWE4yODFFZE1hd2ZqZ1k0NVNPeVZaTWhmVnNK?=
 =?utf-8?B?Z2dQK0ZhM2k4bkpaKzRQQ05uakVsT3RucEREYXdzQVZIeDY3cFprbGs2bHNz?=
 =?utf-8?B?bzRFS1VUaG4wbzV5dksrMFlISXhZMEFSZHBMNWVRQmhPdlUvdHRNVm5Rdk5Y?=
 =?utf-8?B?Tm5uemV6c3V0Z2hPaGo4OFBhR0UyaThvWjZNdXVnS1lzSEp6cFM3V0xicmxQ?=
 =?utf-8?B?RFF0eHJUclpBMk5HK3BORGJPYndZQlp1dzY2clhueGhmc0JqSXVacDhIU0R2?=
 =?utf-8?B?MXFkbGlXL3MrVzZtUDNWbnRuclVrY2xJMTE5M1VUSGxJZ0hZVUw4YWEzMGlt?=
 =?utf-8?Q?BTu27jK7lh+rlbZVlvOv6/leO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0fe2f28-7d2f-4004-15bf-08dabdaa39fd
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2022 14:46:44.2105
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqhRVWU5tsIBIEmg0aDzRnumWhPh8oDp7uXKUMHOXAz4sDAtSYNREzz+zGM6DuA2veMuRGG2cxfwB3avHixhUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6893
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/3/22 11:47 AM, Guoqing Jiang wrote:
> Hi,
> 
> On 11/3/22 12:27 AM, Mikulas Patocka wrote:
>> Hi
>>
>> There's a crash in the test shell/lvchange-rebuild-raid.sh when running
>> the lvm testsuite. It can be reproduced by running "make check_local
>> T=shell/lvchange-rebuild-raid.sh" in a loop.
> 
> I have problem to run the cmd (not sure what I missed), it would be better if
> the relevant cmds are extracted from the script then I can reproduce it with
> those cmds directly.
> 
> [root@localhost lvm2]# git log | head -1
> commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
> [root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh
> make -C libdm device-mapper
> [...]
> make -C daemons
> make[1]: Nothing to be done for 'all'.
> make -C test check_local
> VERBOSE=0 ./lib/runner \
>          --testdir . --outdir results \
>          --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh --skip @
> running 1 tests
> ###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
> | [ 0:00] lib/inittest: line 133: /tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
> | [ 0:00] Filesystem does support devices in /tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)

I didn't read other mails in this thread, only for above issue.
If you use opensuse, systemd service tmp.mount uses nodev option to mount tmpfs on /tmp.
 From my experience, there are two methods to fix(work around):
1. systemctl disable tmp.mount && systemctl mask tmp.mount && reboot
2. mv /usr/lib/systemd/system/tmp.mount /root/ && reboot

Thanks,
Heming

> | [ 0:00] ## - /root/lvm2/test/shell/lvchange-rebuild-raid.sh:16
> | [ 0:00] ## 1 STACKTRACE() called from lib/inittest:134
> | [ 0:00] ## 2 source() called from /root/lvm2/test/shell/lvchange-rebuild-raid.sh:16
> | [ 0:00] ## teardown....ok
> ###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh
> 
> ### 1 tests: 0 passed, 0 skipped, 0 timed out, 0 warned, 1 failed
> make[1]: *** [Makefile:137: check_local] Error 1
> make: *** [Makefile:89: check_local] Error 2
> 
> And line 16 is this,
> 
> [root@localhost lvm2]# head -16 /root/lvm2/test/shell/lvchange-rebuild-raid.sh | tail -1
> . lib/inittest
> 
> For "lvchange --rebuild" action, I guess it relates to CTR_FLAG_REBUILD flag
> which is check from two paths.
> 
> 1. raid_ctr -> parse_raid_params
>                     -> analyse_superblocks -> super_validate -> super_init_validation
> 
> 2. raid_status which might invoked by ioctls (DM_DEV_WAIT_CMD and
>      DM_TABLE_STATUS_CMD) from lvm
> 
> Since the commit you mentioned the behavior of raid_dtr, then I think the crash
> is caused by path 2, please correct me if my understanding is wrong.
> 
>> The crash happens in the kernel 6.0 and 6.1-rc3, but not in 5.19.
>>
>> I bisected the crash and it is caused by the commit
>> 0dd84b319352bb8ba64752d4e45396d8b13e6018.
>>
>> I uploaded my .config here (it's 12-core virtual machine):
>> https://people.redhat.com/~mpatocka/testcases/md-crash-config/config.txt
>>
>> Mikulas
>>
>> [   78.478417] BUG: kernel NULL pointer dereference, address: 0000000000000000
>> [   78.479166] #PF: supervisor write access in kernel mode
>> [   78.479671] #PF: error_code(0x0002) - not-present page
>> [   78.480171] PGD 11557f0067 P4D 11557f0067 PUD 0
>> [   78.480626] Oops: 0002 [#1] PREEMPT SMP
>> [   78.481001] CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
>> [   78.481661] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
>> [   78.482471] Workqueue: kdelayd flush_expired_bios [dm_delay]
>> [   78.483021] RIP: 0010:mempool_free+0x47/0x80
>> [   78.483455] Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
>> [   78.485220] RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
>> [   78.485719] RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
>> [   78.486404] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
>> [   78.487080] RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
>> [   78.487764] R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
>> [   78.488451] R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
>> [   78.489146] FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
>> [   78.489913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   78.490474] CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
>> [   78.491165] Call Trace:
>> [   78.491429]  <TASK>
>> [   78.491640]  clone_endio+0xf4/0x1c0 [dm_mod]
>> [   78.492072]  clone_endio+0xf4/0x1c0 [dm_mod]
> 
> The clone_endio belongs to "clone" target_type.
> 
>> [   78.492505]  __submit_bio+0x76/0x120
>> [   78.492859]  submit_bio_noacct_nocheck+0xb6/0x2a0
>> [   78.493325]  flush_expired_bios+0x28/0x2f [dm_delay]
> 
> This is "delay" target_type. Could you shed light on how the two targets
> connect with dm-raid? And I have shallow knowledge about dm ...
> 
>> [   78.493808]  process_one_work+0x1b4/0x300
>> [   78.494211]  worker_thread+0x45/0x3e0
>> [   78.494570]  ? rescuer_thread+0x380/0x380
>> [   78.494957]  kthread+0xc2/0x100
>> [   78.495279]  ? kthread_complete_and_exit+0x20/0x20
>> [   78.495743]  ret_from_fork+0x1f/0x30
>> [   78.496096]  </TASK>
>> [   78.496326] Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common [last unloaded: brd]
>> [   78.500425] CR2: 0000000000000000
>> [   78.500752] ---[ end trace 0000000000000000 ]---
>> [   78.501214] RIP: 0010:mempool_free+0x47/0x80
> 
> BTW, is the mempool_free from endio -> dec_count -> complete_io?
> And io which caused the crash is from dm_io -> async_io / sync_io
>   -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> suppose the io is for mirror image.
> 
> Thanks,
> Guoqing


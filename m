Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76630C433B4
	for <linux-raid@archiver.kernel.org>; Sun, 11 Apr 2021 09:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CF21610A7
	for <linux-raid@archiver.kernel.org>; Sun, 11 Apr 2021 09:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhDKJEx (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Apr 2021 05:04:53 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:21373 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231356AbhDKJEw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Sun, 11 Apr 2021 05:04:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1618131875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8/2wwDQT3RJsZWAltJOIn7vpBTbU4Y0A7OVDQD8flrY=;
        b=E+QAUwaO0fmg8xhP0po5GKlAETvyKD2nyzlcdhHyxx1YX4emKKEXMb9JDvISKM8eOkS6Vr
        RBfqYcyIZdqwmINkoTieZjmKEpie84d5f1oEsBt5WqmBK7taeVjUqHSDsyHfRZmVuZ6X4q
        emwVbwoc6m3zeMI+z7HAe+aUuygiz9Q=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2055.outbound.protection.outlook.com [104.47.10.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-18-oAf9VYqIPjeTVuACZFhN9A-1; Sun, 11 Apr 2021 11:04:24 +0200
X-MC-Unique: oAf9VYqIPjeTVuACZFhN9A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YO5hkEYqmG8JbGsMJMDIcEnT+YxqKEOQlDpN5SCPNw/rnQHBCwsRdnvgfUTJu/yl6J6GC+d9THnFXAvREgLtfzy1NESHFWRs5/hI51ZZgACzijq+ACnAEdiWPEOBrqQsQdrS1lyOh+jEoVqO5hzu7TQsm32Vvv11PJOuQVN4ZNG4vzGEH+yA41EKFAU9fKetJoDTcUU4fv3eXp7tTjJmPcvvt9pferyR7sUBrJkgryrllCCkBAUnPmmscAIlxzUzKA7tsrk2Vk3A/Wp/kCjcw4Yx75lRkmTtuVr8fAQ0gLolPM58z1tsv6UdN/WUMvz/SYUyNULs+5s3TIJNRGXF/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/2wwDQT3RJsZWAltJOIn7vpBTbU4Y0A7OVDQD8flrY=;
 b=Nyn1lU2nAyPBZ1+kkA7BAGj9olakNi1YBw/eTxU80HHE4upscmDo2fVj+ib2srfv9WqYPy+kxDSoC60+EQMAg+TBR0kXTUFQ3TS1O4au5VcqvJDve7M4eCigl4mbNjtJt9Uc6S5Yq0unYOunszf8S/IDulaUdRAAToCUw3nxE+lEuZV65xjVFt04QdJyznhSeMZDRL3iOjj85M4RpzasC97H2zuybsU6dQBCozkXzelTf7Rv11QHlZtlyA3OvGG2KoY9Oiw+BHcNjbdAoKUCmu6QIWneByn2wWTliY+BnhFOSH8MgyMPesg99pfxrjTYoI6RmAqBuWxLVyha8KkpCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6649.eurprd04.prod.outlook.com (2603:10a6:10:104::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.21; Sun, 11 Apr 2021 09:04:23 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.037; Sun, 11 Apr 2021
 09:04:23 +0000
Subject: Re: [PATCH] md/bitmap: wait for bitmap writes to complete during the
 tear down sequence
To:     Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>
Cc:     "lidong.zhong@suse.com" <lidong.zhong@suse.com>,
        "xni@redhat.com" <xni@redhat.com>,
        "colyli@suse.com" <colyli@suse.com>,
        Martin Petersen <martin.petersen@oracle.com>
References: <20210408213917.GA3986@oracle.com>
 <ba0f4827-83ae-b7e2-2230-5f4afca2538a@suse.com>
 <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <2becafd0-7df7-7a79-8478-b8246f353c9b@suse.com>
Date:   Sun, 11 Apr 2021 17:04:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CY4PR10MB20077F9F84680DC1C0CAE281FD729@CY4PR10MB2007.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.133.187]
X-ClientProxiedBy: HKAPR04CA0014.apcprd04.prod.outlook.com
 (2603:1096:203:d0::24) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.187) by HKAPR04CA0014.apcprd04.prod.outlook.com (2603:1096:203:d0::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Sun, 11 Apr 2021 09:04:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c94bfb4-346c-4f4d-c0d6-08d8fcc8cc62
X-MS-TrafficTypeDiagnostic: DB8PR04MB6649:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6649EEE9D2D94FCB983A4BA197719@DB8PR04MB6649.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L4mTdwGLA/XAFYVZjUkdOV1PZFc4AaqRdG6QqBFa/4Ob2nuEtLcFb1aYWKlz0+rCIOigJ7oVXt742SgPMzBqoAhMBmPSVO5XzmDJdxcUSfOVqY2MPKe27b9mAnIzZ/7s5NhGKcAcp5KR2QjDLA12OUoqFO5ruy8Qcm/9QhdihTdmfbIhwejpGckux+aIhCpkiPUt72DEh3QCD589Ag9mhDihxkQw4tVMVwVn16OHk8JInrWeS8OOp/n/Vg8K0q+aOs3a4Hy5KbMFGl2ZcPtrhMFY4fOMktfLoeRynzKg+fM3iQV06dBLf5IT1Hys5MR6yCHdcSUzvDWhSgcSr215p2MteGZYP+023Zq2QVJZ9Vwg7hbbeVekj4PXaLIyxSiTLxVZBqJtKDJ+gzWutFhMJlYmyOWhfK2hoIlzKFKjL6/B4dokRp130DO50TI2WNk2ZHN4vS1IwREYGpQzmM6R/iSJgCSuNF93KU1QHTEuZJzouHaS4Xcpbhle7K4q0kJUKGL7c+1kPUXhaUt+8YxyWe0xgTBPfNQqfpuC2GE0kqAxNH/cQOjkdkdBjpDoOI+06EkFUQbdNWClRpG9pjuc+JIWPbEOOlHiYCcz7jdI++h+B/jpCjT2CYvqsyHYzgZGpueqrL0y3RGuIgCjs4QXtjtwLc2vhQc0swcq0I9ZTqWWuFzIajN/dFS/uAzoGbEOZLEMTLXeHjMfsxakyn4oP5cohmKVYG9cHt4vm8nckp0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(346002)(39860400002)(136003)(366004)(6512007)(52116002)(66946007)(5660300002)(6506007)(16526019)(8936002)(26005)(38350700002)(4326008)(83380400001)(38100700002)(316002)(6666004)(53546011)(110136005)(186003)(31696002)(8886007)(66556008)(66476007)(478600001)(956004)(6486002)(2616005)(31686004)(2906002)(86362001)(54906003)(8676002)(36756003)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cVgySGluMlkrelpER0pxa2VPMmwvWmdqTVBhUnRxWGx0MWxvMU8wbkhwanVB?=
 =?utf-8?B?cDd2dE9nSjJjM28wUVNMeittNkVYWHd3dWo1OTRXRkRXZVNVaEpaUjJ3dXNB?=
 =?utf-8?B?R3E4bTV0dy91bGFUc3pvSitwdFZHMVpwSkxDRUtPVHBaUlgvQm9YZ3RnVUli?=
 =?utf-8?B?WWRQdmR5UEdqRHZ4ZStrbTJ1MFFoYmJjak9Lb3IxUk5YRXN1d0J2YzdLMkw4?=
 =?utf-8?B?OWMzZXBPZjBFU0ZFQW5Yd0VYM3BSSmdSN3FHNjc1RnR1cUxwV1g1Z3FVYmZU?=
 =?utf-8?B?K0V5UVlNOU1mQ0l5WXlYNjdzS08zYnE5TlRNOGU4Vk9OZHdUUStRVHlxc1NO?=
 =?utf-8?B?QXRZa0pvdFVQdXVyOFo4Q3RyZ2lBWlV5Unc2eXpaMW9sUUZkN0ZwdFVTY2hI?=
 =?utf-8?B?eEd4ZTZya1BFWjRjOVBXdlZVU1U5bmVsZUdWUnNVOFBZWXVMY3VWSmFxWGZx?=
 =?utf-8?B?UjB0WEZuTjBScFA5Y3J3YVFVTkJaTmViMHBYclJadWZlRDA5QjVpalk2SGY4?=
 =?utf-8?B?SlJYSHBPWnFxSUtzUkRSeWVJNHg4K1hxN1B5dlpSSldWK01pSFM3c21qekFE?=
 =?utf-8?B?d0RaMmVMR1NwOHFyazVLT3F4eWhrWHVBZi9CZGtzVWl2ZzNScnZ6Sy9xbjZy?=
 =?utf-8?B?aUJBWUgySlpjMnc3S0czSzVuSFV0V01rRGNvMHlHMGpDSzBrRkN4NGtrN3Y1?=
 =?utf-8?B?T093VjFOZk1mYlJKemRnakpRcS91QXJ2ZEVzVVY5UVpDQXlyT01vUkRsTExN?=
 =?utf-8?B?WEEyMjI5YURHcWlPVk9kSk1WSkFtb0lJQ25PY2xqV3FjZFFTMHNvME9wMU5T?=
 =?utf-8?B?VnIwaE5NU1lYalVEMWJic2t0Q0dSRkZWVHRIcWhLK1JkYnJ2NmRzZStwR3cy?=
 =?utf-8?B?c3IyZEtsL2lBeitqOENSajVnU2hENW8xOVZFY0x5RjVFZnVheDdqSXpHZERn?=
 =?utf-8?B?KzdVdUlIVWdmMWViTnFxaTFibUNVMGlaTGsybVJWZmVKbGFsQ2ptUFRlNzJQ?=
 =?utf-8?B?NnhXUmNyTnorYmJtemN1MUtrT1JDY0Z2ek54WE95cUFJdXdKT2dEOE9wN2lZ?=
 =?utf-8?B?QjZPSjlXUjBwVm15VU5IN2tRVHcyWU9CZHNiczdaNnhtOERKS3kyZTZMbjIx?=
 =?utf-8?B?QVBLWXJrbUxsdk8wd2J4ZGpvTDNhZGQzV3p0Q25CWWRYZ0UzVW9yUGJpdUhY?=
 =?utf-8?B?NkhLWmU3ckRKNTdyOHdNcXBFL1hnSitRNDZveER4TS9HZmYwbXBHZFRFaDhx?=
 =?utf-8?B?TUJwQlNvTDA4TGM4TE0yWlZWVkRTUlJycGo1Y2VZRVdPS1NSZnlCWURPY2tF?=
 =?utf-8?B?cHlpUmZORlpjOVJ5M3l6RFBGYi95Q3ZNZERxOWxPZC93bWFiZE1BemZMeFdC?=
 =?utf-8?B?SitxTWRzUXV2SWMxdXpZejNmekFaeFYwamkxMUVWVDdMb0dBY3kwSXhZY2pT?=
 =?utf-8?B?OE8wcStOMVJyRUdONkVmaXo1NTlPY1Fhcm5iNkhjR1hsV1dpb1RyTytzRjFI?=
 =?utf-8?B?VjNSSmdiZDdGdXB6T1YyMjRtRThNMTA2QUcybjhSTUxEVmoyQzNFUzg4eGwx?=
 =?utf-8?B?ZkZnVTM5MzBxUEttQ2NPVFhaSVAxRUN1aWR1ZzYwMEZoWXM2cFlpYjBtRFYw?=
 =?utf-8?B?S0x5RXlTWWozSjBVSzBKRHg5cVhyOE1oQXUyUzJ4Nkt4RWtOdjlrNG15MXFy?=
 =?utf-8?B?UkhzTWxFN2J4S09GbkwzSnVTVW42QURBd3JOZDh2SlRDSENBTjhlU29ZYnM3?=
 =?utf-8?Q?QvQjuKUzxPl0aPW0tWaU3YPS9R0rgNUfrOTEEyd?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c94bfb4-346c-4f4d-c0d6-08d8fcc8cc62
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2021 09:04:23.0844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nGemQ/PwnfpRkI4dhiJCSReSMNEuNXmkkvr0STkTJ8AmAYbhTdFvF5kFEUy2lD0e7SwRVTqIJ0lGdwiWqHECaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6649
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/11/21 5:35 AM, Sudhakar Panneerselvam wrote:
>> Hello Sudhakar,
>>
>> First, let's discuss with master branch kernel.
>>
>> What command or action stands for "tear down" ?
>>   From your description, it very like ioctl STOP_ARRAY.
>> Your crash was related with super_written, which is the callback for
>> updating array sb, not bitmap sb. in md_update_sb() there is a sync
>> point md_super_wait(), which will guarantee all sb bios finished successfully.
>>
>> for your patch, do you check md_bitmap_free, which already done the your patch's job.
>>
>> the call flow:
>> ```
>> do_md_stop //by STOP_ARRAY
>>    + __md_stop_writes()
>>    |  md_bitmap_flush
>>    |  md_update_sb
>>    |   + md_super_write
>>    |   |  bio->bi_end_io = super_written
>>    |   + md_super_wait(mddev) //wait for all bios done
>>    + __md_stop(mddev)
>>    |  md_bitmap_destroy(mddev);
>>    |   + md_bitmap_free //see below
>>    + ...
>>
>> md_bitmap_free
>> {
>>      ...
>>       //do your patch job.
>>       /* Shouldn't be needed - but just in case.... */
>>       wait_event(bitmap->write_wait,
>>              atomic_read(&bitmap->pending_writes) == 0);
>>      ...
>> }
>> ```
>>
>> Would you share more analysis or test results for your patch?
> 
> Hello Heming,
> 
> Please find more details about our system configuration and the detailed
> sequence that led to the crash.
> 
> We have a RAID1 configured on an external imsm container. /proc/mdstat output
> looks like this:
> 
> ***
> md24 : active raid1 sdb[1] sda[0]
>        141557760 blocks super external:/md127/0 [2/2] [UU]
>        bitmap: 1/2 pages [4KB], 65536KB chunk
> 
> md127 : inactive sdb[1](S) sda[0](S)
>        10402 blocks super external:imsm
> ***
> 
> All our system partition is laid out on top of the above RAID1 device as
> shown below.
> 
> ***
> /dev/md24p5 on / type xfs (rw,relatime,attr2,inode64,noquota)
> /dev/md24p1 on /boot type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> /dev/md24p15 on /home type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> /dev/md24p12 on /var type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> /dev/md24p16 on /tmp type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> /dev/md24p11 on /var/log type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> /dev/md24p14 on /var/log/audit type xfs (rw,nodev,relatime,attr2,inode64,noquota)
> ***
> 
> In such a configuration, the kernel panic described in this patch occurs
> during the "shutdown" of the server. Since the system partition is laid out on
> the RAID1, there could be write I/Os going to the RAID device as part of system
> log and filesystem activity that typically occur during the shutdown.
> 
>  From the core dump, I see that, after filesystems are unmounted and killing all
> other userspace processes, "mdmon" thread initiates the "stop" on the md device.
> 
> ***
> COMMAND: "mdmon"
>     TASK: ffff8ff2b1663c80  [THREAD_INFO: ffff8ff2b1663c80]
>      CPU: 30
>    STATE: TASK_UNINTERRUPTIBLE
> crash> bt
> PID: 7390   TASK: ffff8ff2b1663c80  CPU: 30  COMMAND: "mdmon"
>   #0 [ffffb99d4eacba30] __schedule at ffffffff91884acc
>   #1 [ffffb99d4eacbad0] schedule at ffffffff918850e6
>   #2 [ffffb99d4eacbae8] schedule_timeout at ffffffff91889616
>   #3 [ffffb99d4eacbb78] wait_for_completion at ffffffff91885d1b
>   #4 [ffffb99d4eacbbe0] __wait_rcu_gp at ffffffff9110c123
>   #5 [ffffb99d4eacbc28] synchronize_sched at ffffffff9111008e
>   #6 [ffffb99d4eacbc78] unbind_rdev_from_array at ffffffff9169640f
>   #7 [ffffb99d4eacbcc0] do_md_stop at ffffffff9169f163
>   #8 [ffffb99d4eacbd58] array_state_store at ffffffff9169f644
>   #9 [ffffb99d4eacbd90] md_attr_store at ffffffff9169b71e
> #10 [ffffb99d4eacbdc8] sysfs_kf_write at ffffffff91320edf
> #11 [ffffb99d4eacbdd8] kernfs_fop_write at ffffffff913203c4
> #12 [ffffb99d4eacbe18] __vfs_write at ffffffff9128fcfa
> #13 [ffffb99d4eacbea0] vfs_write at ffffffff9128ffd2
> #14 [ffffb99d4eacbee0] sys_write at ffffffff9129025c
> #15 [ffffb99d4eacbf28] do_syscall_64 at ffffffff91003a39
> #16 [ffffb99d4eacbf50] entry_SYSCALL_64_after_hwframe at ffffffff91a001b1
>      RIP: 00007ff3bfc846fd  RSP: 00007ff3bf8a6cf0  RFLAGS: 00000293
>      RAX: ffffffffffffffda  RBX: 000055e257ef0941  RCX: 00007ff3bfc846fd
>      RDX: 0000000000000005  RSI: 000055e257ef0941  RDI: 0000000000000010
>      RBP: 0000000000000010   R8: 0000000000000001   R9: 0000000000000000
>      R10: 00000000ffffff01  R11: 0000000000000293  R12: 0000000000000001
>      R13: 0000000000000000  R14: 0000000000000001  R15: 0000000000000000
>      ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b
> crash>
> ***
> 
> While handling the "md" stop in the kernel, the code sequence based on the
> above md configuration is
> 
> do_md_stop
>   + __md_stop_writes
>   | + md_bitmap_flush
>   | | + md_bitmap_daemon_work
>   | | | + md_bitmap_wait_writes()
>   | | | | (This wait is for bitmap writes that happened up until now and to avoid
>   | | | |  overlapping with the new bitmap writes.)
>   | | | | (wait flag is set to zero for async writes to bitmap.)
>   | | | + write_page()
>   | | | | | (For external bitmap, bitmap->storage.file is NULL, hence ends up
>   | | | | |  calling write_sb_page())
>   | | | | + write_sb_page()
>   | | | | | + md_super_write()
>   | | | | | | (Since the wait flag is false, the bitmap write is submitted
>   | | | | | |  without waiting for it to complete.)
>   | | | | | | + mddev->pending_writes is incremented, then the IO is submitted
>   | | | | | |   and the call returns without waiting
>   | | + md_bitmap_update_sb() - (This call simply returns because
>   | | | | "bitmap->mddev->bitmap_info.external" is true for external bitmaps)
>   | + md_update_sb() - (This won't be called as the call is conditional and the
>   | | | | | | condition evaluates to false in my setup(see below for crash info)
>   + __md_stop
>   | + md_bitmap_destroy
>   | | + md_bitmap_free
>   | | | + wait_event(bitmap->write_wait,
>   | | | |            atomic_read(&bitmap->pending_writes) == 0);
>   | | | | bitmap->pending_writes is zero, but the mddev->pending_writes is 1,
>   | | | | so this call returns immediately.
>   | md detachment continues while there is pending mddev I/O cauing NULL pointer
>   | derefence when the I/O callback, super_written is called.
> 
> ***
>          crash> struct mddev.bitmap_info.external 0xffff8ffb62f13800
>                  bitmap_info.external = 1,
>          crash> struct mddev.in_sync 0xffff8ffb62f13800
>                  in_sync = 1
>          crash> struct mddev.sb_flags 0xffff8ffb62f13800
>                  sb_flags = 0
>          crash> struct mddev.ro 0xffff8ffb62f13800
>                  ro = 0
>          crash> struct mddev.cluster_info 0xffff8ffb62f13800
>                  cluster_info = 0x0
>          crash>
> ***
> 
> Please review and let me know your thoughts.
> 

Hello

On previous mail, I was wrong to assume the array mddev->bitmap_info.external is 0. So my analysis was not suite for your case.

Now we understand your env, which is related with IMSM & external bitmap, and I have a little knowledge about this field. May need to add more people in the cc list.

Just from code logic, your analysis is reasonable.
The key of the crash is why md layer didn't do the waiting job for bitmap bios. There have wait points in md_bitmap_daemon_work, write_sb_page, md_bitmap_update_sb & md_update_sb. But in your scenario there all didn't take effect. At last md_bitmap_free do the additional wait bitmap->pending_writes but not mddev->pending_writes. the crash is triggered.

In my opinion, using a special wait is more clear than calling general md_bitmap_wait_writes(). the md_bitmap_wait_writes makes people feel bitmap module does repetitive clean job.

My idea like:
```
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 200c5d0f08bf..ea6fa5a2cb6b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1723,6 +1723,8 @@ void md_bitmap_flush(struct mddev *mddev)
         bitmap->daemon_lastrun -= sleep;
         md_bitmap_daemon_work(mddev);
         md_bitmap_update_sb(bitmap);
+       if (mddev->bitmap_info.external)
+               md_super_wait(mddev);
  }
  
  /*
@@ -1746,6 +1748,7 @@ void md_bitmap_free(struct bitmap *bitmap)
         /* Shouldn't be needed - but just in case.... */
         wait_event(bitmap->write_wait,
                    atomic_read(&bitmap->pending_writes) == 0);
+       wait_event(mddev->sb_wait, atomic_read(&mddev->pending_writes)==0);
  
         /* release the bitmap file  */
         md_bitmap_file_unmap(&bitmap->storage);
```

All in all, your fix make sense to me. Let's wait for other people's feedback.

Thanks,
Heming


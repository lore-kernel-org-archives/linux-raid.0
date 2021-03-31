Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B37A1C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 16:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80C6A6101E
	for <linux-raid@archiver.kernel.org>; Wed, 31 Mar 2021 16:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbhCaQme (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 31 Mar 2021 12:42:34 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:26333 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234588AbhCaQmZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 31 Mar 2021 12:42:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617208943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EUTUK/FnEFTMko0ehNnrKYdGfS/6yu+KHwnYjaOR11Y=;
        b=VuJ3xiHytLnGkueHUQ09Au9XuEc9BA24EJ9dozoba/UtGpxVpkCBurjXe5fcgaNuNVHblO
        Y8gYMut3a8x3YZgWOiZ6fiqZx5uWqkMe03XirFKBpFYd+wCIXdeclIoqWMUCqJPlIlpLlk
        Mu/EFcvgs4XihQVIWeIAyd8aN2WMzcA=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2113.outbound.protection.outlook.com [104.47.17.113])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-29-UKl8n5XxN7qV1k09VWlKNA-2; Wed, 31 Mar 2021 18:42:21 +0200
X-MC-Unique: UKl8n5XxN7qV1k09VWlKNA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c+WiiyOSwDQfbCYWsse6FkcBgwAbx7+nidGwFyIlMEJzMu9jJFVEr5GzqMfbEMYZt6BPiasFUhOk/tXX2dRDAdqp6RNRFD2EvAFS2XqMDPQYEpzgkpDuQNkmphgaoMnawSG/vw4t/avTzkRGBVV3WbfS4q4UIgVKt2qoEl8U1FC7UtS5TTTlfPQwsns4Ktopjl9e7tDl7iRq3G7rW12H4diHpHCWQ/KhoIsxUjs7encxeY2j7LmmJgyv1NoVYS6iWc3ZAPglW1NX9MNraJ3qlfC+6xxLWu7WwwPVsKToHDvwoprBu8u3dPEjbIoQA6iDjH2diwTT7RxpYZ1UiTwSXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUTUK/FnEFTMko0ehNnrKYdGfS/6yu+KHwnYjaOR11Y=;
 b=VjePLbAovDSiNh+n4uizfjmkXnnVQwJRdO011DaDDHgDBKYuXwh0LaiTVHPokYOi8vYk2ldEhGlbHoIBqinfbXXAGfHvZZ4dhrsUDhsYitfxM3zSfdaBqU9cMQ+HMdoZhXVSKDx4aPfWqn16YWnR6FKKiB/yL6p0907nQ1TdXVXtp1y6hBnyTZY/2sNerkzOBg/Efc6y18VF9RQLCUJaV5NPGs0M/XXco6bBsskFgmJ2/A5Xozbc5CFzD05I60jb5Be6L+er8y2aFsaXHrJKwzhsMzbbVVrnsAsgKQFKfjzPI9qBGHiWRvyH74exc/+N31Aqa3ffFPpRb6/OUi+a7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5449.eurprd04.prod.outlook.com (2603:10a6:10:8d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.26; Wed, 31 Mar 2021 16:42:18 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.027; Wed, 31 Mar 2021
 16:42:18 +0000
Subject: Re: [PATCH] md: don't create mddev in md_open
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.com
References: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
 <20210331065512.GA987842@infradead.org>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <7bef7b86-ad8b-b503-59dc-0c9c69974237@suse.com>
Date:   Thu, 1 Apr 2021 00:42:04 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210331065512.GA987842@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2PR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:202:2e::16) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2PR06CA0004.apcprd06.prod.outlook.com (2603:1096:202:2e::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Wed, 31 Mar 2021 16:42:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6228bfa6-a666-430a-7481-08d8f463f26e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5449:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB544985628A58D9CE005E67D2977C9@DB7PR04MB5449.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cJCGLBB7+Ma2VZTlyDBoreFltQiAmz0BkMgHsphZqkB4pmngQ7SUsk929bjs0Cu4wMeeVvgkLSM/OhDlu3GAoIah65fQ37w2SMx4/h7ejWB6fkdNXEQJNSFWiSj8UiYBqNtkA9CA4N2c6fHNjsxRDPXdirg8RUACBvsWF1Q/AWafcEOvHVZpNX9nDN+TIj3SOIsWPA/7xC6Vu/z4T8vF80CsGdNFAzFP/jJP3Hay+ZYlCKMXF0Tt9Dr3XuFeXFo3SRrRfemD4QzzzqDvhONUSApdWsruvQzDPbnQaw4sBht1AYuOX62MXbOFoPJlHXam+dFEsW8EXF7MS1vBawFwWIVFeUXWJaM3UpQxn2l0/48ScvuEwfbQncpSdhiBduBd3J+s7KVFJi9+J33P9RkwlwHnsjsE2OyMuKI3aGRsjRplKwk+SLED/WTWyMPv2M5zPR/HrKvULw71gzns6TBt3Iie5BY2tqSVo2AMDVStj1z19HUf+RYvACqtS8vm2t6AEei/NCCkL8lJ7LYJ2iA0QGwQD1C8MmOva5vWcjapLxs9P3Nqhv62Dv4z8wIEk03iGgZUj/aSXIxrqZDZm+Ba7Q58Hnc4oxjMOuYV5Rsh880LEqzwYAUBKDveHA8mCiR/rYhxNhJwywgqw37hislVFGrpjsTxUUoLBA9w49mVP0MXoFDzsb8C0Jia+jUzjr2Y4V12QPbgsi70+cB0LS0TFWgTugPA9teIBSavmC2Udxg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6512007)(31696002)(5660300002)(6486002)(498600001)(86362001)(53546011)(8886007)(6506007)(2616005)(186003)(38100700001)(16526019)(66476007)(107886003)(8936002)(2906002)(36756003)(83380400001)(6916009)(66556008)(26005)(4326008)(52116002)(8676002)(66946007)(31686004)(6666004)(956004)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?OE9WNHNPeWJyTmFCYU1wVEZBVWtXNnBLdVY3b3pvY1VPUjY3RFlGRUorb2Js?=
 =?utf-8?B?VDAweVhZMnJGbVVlUkxhRE9OaWpoejBwSytRVW1hcFdsdldDcUNLajJRUTVO?=
 =?utf-8?B?OFN6N1YyeHE0d3ZDaFFWQXpQbmdPcDgyKzdTYVRCM1NZem14WUpOaUlYTExC?=
 =?utf-8?B?dnJsZ2pRSnFvSlA4RTR5blVyT0NNVnljeTMxSXZucVcyVlBaRHhocytaUnhF?=
 =?utf-8?B?Z0g4cVZYazRQbTJjdkFuRFpTQWVvWUdoZEpCZHNENk5yd0w1T0hYSmRSU00w?=
 =?utf-8?B?cmVJUU4wZEt0Y0xqZVkrQkdXWGF1VmJnd2NHWnUrWDZXUTgrOUhoWkllc21s?=
 =?utf-8?B?UHczSGhCNVJkYmQxbTI1YzFqUlB2RFo0TFZmQi9mYTZZRFRsS203N1hDcy9C?=
 =?utf-8?B?b1N3dE41bUhVc3Fob1pjajJoWnFIMmJsTG80MFJsc1FCVzIza1JKcFNFblAv?=
 =?utf-8?B?WUJncTYwWnJ2cmwya1J1TUtLY2hJN1BITFZrM3Z6aDlJZnZhQlRFOGx5cnlZ?=
 =?utf-8?B?MFZ1bnlteElPNHRLRDVyR3FwUnVjaVVsZmIvMURLN2pBMnRuNEFmeEo2a1I0?=
 =?utf-8?B?YU40ZjJxZzMxaFlaZWNpbzhhcTBkdmpUdldublN6c2R3ekhYUW9IY3AzRy9S?=
 =?utf-8?B?dWkwV3dYUVJwRms2UmVRTk5QRXljclVVS0tpMUhjRzBjNkJDaWVzVlk2bUcr?=
 =?utf-8?B?cHZwTGJuVmkxT1FqMWd1ZEUvTkN4OTlIYkdZRXFqYVU0QWdQRnRSU2ZXR0Z1?=
 =?utf-8?B?TkQ0R09XbWd6UUFlL0diZXhFVDNaM1B4Qm91ZzRrZGlYdDY2WnhFb1NEaEVN?=
 =?utf-8?B?cWtmWGRqbXNGazU4RXVlaFg5bEdvanNuZ3VXN0NQdEFpdmllQTg1SjZHR2tL?=
 =?utf-8?B?TkZ4V0w5c0tBSHZBaFFUM1NxSXpyWm82U29MY1NlclpjblZDUWZldGZtZE84?=
 =?utf-8?B?U1FGUGRnUmhyZStkRmVrbW9UZjBxSlpVWTJsVWRaUVJRdXhHL1IyWlc0bFlz?=
 =?utf-8?B?Q2dETy9VMndvaWcxcG50NDIwOE1FMTlDMjdKdklEUjU1SnNmV0ZFYXhsbnJ5?=
 =?utf-8?B?TDRZRCs3WlNVaStsMm4vTGluWHhiQ1lNa25GSWxuRndmS09ZUWdVSEFmMDRo?=
 =?utf-8?B?MzY1YVl4MGZSUlBqVzY0Tjg2OEhRa2ZEcVovbW1SWUl5TWI3ZHJOcGErbWov?=
 =?utf-8?B?empta3A3V2hMcGNOQjZhaytWQnZDUnM3Qi9YMU8yUWNQN3ZzS21rbHlHdDdj?=
 =?utf-8?B?ZjdrVk5QOHhHcDRDRUVyVlVFazdwcmNXMG1FaGo1WXBId3gwcG04NnU0a2dq?=
 =?utf-8?B?cjl6Vm1UU01YZjBTTG5jY3F2TGladEd2VmRwaVFvaHVvMksvNnRNZVVNbDhp?=
 =?utf-8?B?MzJsdE5OLzd3djBSdklPYTVuVXROSUk3ZGxIK3ErQ2JQbDdqR3dvd2VpaUJ0?=
 =?utf-8?B?emxVSXFXZGFnRGJ4bytuT0krcUwvSjVLTU45UTdZL0pGU1U5eHFaYlJMdU9i?=
 =?utf-8?B?aFdGQVhKZnEvdkZoUkpTdjNBOEMzSVJMVGRNTi8rL3JVNzhSSFoxTjVsNXN4?=
 =?utf-8?B?L2dSdXNkRDR2M2diZS9DNERsRmxyUUtPZDF5NHVucWRxTFZSYnFuZzVFSkl1?=
 =?utf-8?B?OHQ1VDJrZUZMTnFNcTdwWXQ2VWdrbHFZN1JmMmtUVHBqZnkxVkpnT0xIMzRv?=
 =?utf-8?B?WnhKZTUyTVhSdVo4R1E1N1dNK2hodldHTVN5Z2tNZytHUHJxRENFMGdjdmFh?=
 =?utf-8?Q?zxJPJWrAvt+bmpAjXkSyAjzq49XoI7h0wCooyqj?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6228bfa6-a666-430a-7481-08d8f463f26e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2021 16:42:18.3447
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xek/ggghuXKQZn0aUMCXFgf09UeFOmSglPheo4nWLA4KUf2rNo35sC4a/B7xEdLesKrwEasYlU4OZVJQ/csD9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5449
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/31/21 2:55 PM, Christoph Hellwig wrote:
>> -static struct mddev *mddev_find(dev_t unit)
>> +static struct mddev *mddev_find(dev_t unit, bool create)
> 
> This just makes the mess that is mddev_find even worse.  Please take
> a look at the patches at the beginning of the
> 
>    "move bd_mutex to the gendisk"
> 
> series to try to clean this up properly.
> 

Hello Christoph,

Because your patch is related with md issue, I use this mail thread to discuss.
If you and other people think the To & Cc need to extend, please do it.

If I understanding the series patches correctly, the purpose of [path 1/15]
is to remove "return -ERESTARTSYS" path.

currently md_open, all the racing handling code is below part:

```md_open
     if (mddev->gendisk != bdev->bd_disk) {
         /* we are racing with mddev_put which is discarding this
          * bd_disk.
          */
         mddev_put(mddev);
         /* Wait until bdev->bd_disk is definitely gone */
         if (work_pending(&mddev->del_work))
             flush_workqueue(md_misc_wq);
         /* Then retry the open from the top */
         return -ERESTARTSYS;
     }
```

mddev is removed from mddev internal list in mddev_put, this function is
the key to raise discarding mddev job.

let's only focus on "mddev->gendisk != bdev->bd_disk" case. there are 2 paths:
1> in creating path
this path is impossible to trigger, userspace md device (/dev/mdX) only valid
after md_alloc successfully completing. this time mddev->gendisk must equal with
bdev->bd_disk.

2> in freeing path. (this is the Neil's patch really cared)
2.1>
md_open is running before mddev is removed from md internal list.
Neil wanted to wait queue_work to finish clean job. then return -ERESTARTSYS.
And on next turn, md_open will find the mddev is null (but in real world, the
mddev_find will alloc a new one. this is a bug, it's not Neil real thoughts)
and return -ENODEV.
Your [path 01/15] breaking this rule. you will mistakenly call mddev_get to block clean job.
In my opinion, the solution may simply return -EBUSY (instead of -ENODEV) to
fail the open path. (I will show the code later)

2.2>
the Neil's patch has a bug (I had said in 2.1), it's related with below case:
md_open is called after mddev_put removing mddev but before finishing md_free().
this time mddev is not exist in md internal list, but bdev->bd_disk still grab
the mddev pointer. this scenatio can't return -ERESTARTSYS, it will make __blkdev_get
infinitely calling md_open and trigger a soft lockup.
this case can be fixed by calling mddev_find without creating mddev job. it responses
your new [patch 04/15], the do only search job's mddev_find.

At last, the code (based on your [PATCH 01/15]) may looks like:
```
static int md_open(struct block_device *bdev, fmode_t mode)
{
     /* ...  */
     struct mddev *mddev = mddev_find(bdev->bd_dev); //hm: the new, only do searching job
     int err;

     if (!mddev) //hm: this will cover freeing path 2.2
         return -ENODEV;

     if (mddev->gendisk != bdev->bd_disk) { //hm: for freeing path 2.1
         /* we are racing with mddev_put which is discarding this
          * bd_disk.
          */
         mddev_put(mddev);
         /* Wait until bdev->bd_disk is definitely gone */
         if (work_pending(&mddev->del_work))
             flush_workqueue(md_misc_wq);
         return -EBUSY; //hm: fail this path. userspace can try later and get -ENODEV.
     }

     /* hm: below same as [PATCH 01/15]*/
     err = mutex_lock_interruptible(&mddev->open_mutex);
     if (err)
         return err;

     if (test_bit(MD_CLOSING, &mddev->flags)) {
         mutex_unlock(&mddev->open_mutex);
         return -ENODEV;
     }

     mddev_get(mddev);
     atomic_inc(&mddev->openers);
     mutex_unlock(&mddev->open_mutex);

     bdev_check_media_change(bdev);
     return 0;
}
```

Thanks,
heming


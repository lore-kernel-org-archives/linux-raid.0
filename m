Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C759C433B4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 02:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EE28761151
	for <linux-raid@archiver.kernel.org>; Sat,  3 Apr 2021 02:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhDCCpr (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Apr 2021 22:45:47 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:40558 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231256AbhDCCpr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Apr 2021 22:45:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617417943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VQfqUrTH811LTiHoshGUFTz4qRLRJCxhN1BHmXwGpwc=;
        b=cDi6Be6Iu9zYEhpmWQ6AwZJRZ/IBCgf4iZjFp3LC9lPbWO2drZIN5rH5mQIVkYh+bBGCb7
        ayP8A8F0kkbzgBXLIu/DShmd3noxwxcZpVLTa4Tyg+kT/D1hoovfhw8SN0hUWjdI3Z8zyh
        Jq5QojAuFRhhoo/Yx/e/mPt5fY5JA9Y=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2175.outbound.protection.outlook.com [104.47.17.175])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-16-HQuI7fqyNXCjbIeXjeTNZw-2; Sat, 03 Apr 2021 04:45:42 +0200
X-MC-Unique: HQuI7fqyNXCjbIeXjeTNZw-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ta9APlNCYoLdFpWgSmI7a6waY3L7ZeSKyZIJoheAznebFR+ZWq9C5LboG0y8MZQMu7gi/iWIxZTgJMFM1nkKk+Rw2n9IziHCgVHkq1Z4TVuaVZRii8J0cX+9UQvcJwTj67VvNWu442CKMJ2P8DWbOrHymx879U2hX1OrxYHldMQHyICeQewzXdK3QB5IhY8JwEsPWr9BOd3WFwJqj0Atp8XkUIZCHKRFaMen6fc8C+VWZm5jynu1Pigpk0W7BBQPGIX9S3iFq9qm2lrJgRo+EWP9+cGhU+IkvY8eYpO61pPS/XfIeryuYPhuLaiUnxo7iBY8zwcPrxXRP9xhhTbkvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQfqUrTH811LTiHoshGUFTz4qRLRJCxhN1BHmXwGpwc=;
 b=kbb81KkhiMHR479evZsWUBdSVDBzlzp6anznu8AkNYjMcqRvHcN0khefF5bYtLlGbUKQZ4OdVhaZ3qvL6O9YQCzSxh2/TWMmh7UmpWAvZnINUpwHERVpNqXa6TSf62AKgoEkqOzU/S8j87MMUuChUB21pKJJu3UXQd4l0ueegxmSMoA+mR+e4gu/zFAMNLwPHr/v6VCu5gifD3sM50mkuTh8bnaePwN0qYghwm0bS9xVD0sFWfHgHBQ0zvf7MF/mGnB44jWmYfc/ssaEgtl+eWHOwazQZPHdTKXjvBj/f9aB4X8hfJQNJEGttCvDZwWdAGYs92n/3G4DQIEccMyp0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6649.eurprd04.prod.outlook.com (2603:10a6:10:104::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.29; Sat, 3 Apr 2021 02:45:39 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.029; Sat, 3 Apr 2021
 02:45:38 +0000
Subject: Re: [PATCH v2] md: don't create mddev in md_open
To:     Song Liu <song@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.com>
References: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
 <20210401061722.GA1355765@infradead.org>
 <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
 <CAPhsuW6_9av6H=1LkD5qqpyOcA8j2jj8d660FUpadn3Jfd79Vw@mail.gmail.com>
 <b2288ab4-1da0-612d-8988-637cc33db99a@suse.com>
 <CAPhsuW6RKA66Nj6ncW3+dmx6tjEzP4yZnifQiyHPoy1NSdM_7w@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <98619c7a-6684-1727-e64e-70269fe2cd89@suse.com>
Date:   Sat, 3 Apr 2021 10:45:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <CAPhsuW6RKA66Nj6ncW3+dmx6tjEzP4yZnifQiyHPoy1NSdM_7w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2PR06CA0019.apcprd06.prod.outlook.com
 (2603:1096:202:2e::31) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2PR06CA0019.apcprd06.prod.outlook.com (2603:1096:202:2e::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Sat, 3 Apr 2021 02:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e2c9fd7-47b5-41aa-00db-08d8f64a9068
X-MS-TrafficTypeDiagnostic: DB8PR04MB6649:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB664958329DC4427F5DD554C497799@DB8PR04MB6649.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iIcSEOJIWejab4U4+bJZatIQC4rZoc5cufhXagVZh2zil5Cj9x/Bp0xAJLRGG5RUZSGyF5nY1NEO2AItEVu1YS9JIufffxfTHRWOFTdlrxNvZ7g42wX1DOzv9Fty+w820PCv1CIfKNLf27fExUNlu3+47yY2EACEeaKkzpnt08I/SiD1NAw0OK78HY1eWqkHZGuydvX4oNCe/cpq3mQr/N3zUiQPUHjEZS5ivGlPa57oVqw2LBHRmNrWvFBzqQZRPKMFIaoa/3n+HQkcmfMvCW5D+3tPLc0M6G6wsD6CUTqO6JDEpynFF7LPDFDN/ME17APDHWEr3KP9V21Q0nslT6Hy/0Labp61BHf8K7YAhtEsQFO0wK6XMJUPm3kr8V9rHBTBG9OuCxN0jUp8ZfS13RmNeXX+77uuobGn2nFWiOAZpdrwH6+uV8NqeQz10cCOUO5T6qf1jEPhv95lUkx126tcmwofcWjT8yxm4xPbKdaKa+Pc/zRa+ljoSVKYPXv+DbSmcqfbhHY0vVollHGhPrQkH+V7RPvY3pPaL3zmfoK99/Mgo5e260Xm7q1dlHR9+AVnObEzWe1a68YsJRr91ntMD51p9mZgfBtDvOWUbOJY/7+Zv/rsaDIZr1dzF5tavfi1w1YFX3wWaZD4SKuC8T/bssRmPPDb25elTwyO7SxTBoXZOZDyOfc/zLqYLDRpxYyzzNclG8HOkfLi7Eyi99Kq6T+2u5bPRg7gnM6zlok=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39850400004)(136003)(376002)(396003)(346002)(8936002)(5660300002)(186003)(6512007)(6916009)(6666004)(52116002)(31686004)(107886003)(4326008)(31696002)(66946007)(66476007)(66556008)(6506007)(316002)(6486002)(478600001)(8676002)(8886007)(54906003)(83380400001)(86362001)(2616005)(38100700001)(956004)(2906002)(4001150100001)(26005)(53546011)(36756003)(16526019)(9126006)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dkJIMFFYdW1JaHR6ZjJSeW42OEI1WDhpQkl3NzcvOU1BMDRmV1FleVBSOERL?=
 =?utf-8?B?bjcwUnZrbVVZK0I1VkNZK1NXVkNKTENwT1ZjOE16N2laQ1BVSHJJUzNmUEQ5?=
 =?utf-8?B?N1ZaU2l6R0RPN3g3WHBubWpxOGExcDVHZWhLTnZCWUJCQ2c5OE9GaTNGTk9j?=
 =?utf-8?B?d0hXTWdFbFQ5ck54SEFHaklseFZwaG5qbWRxNWNmVUJPdGVKS01tdE1Sempa?=
 =?utf-8?B?OXEvNXRTaHJjUU9jQ1krUURKVFdPVUNnQmNKNjZuZzdiMTFIQkdSYUpod0RC?=
 =?utf-8?B?MjdCTHQrR2ZmQldkUTVTbVNDM2tDZDlnV05mZHJJczk4OXM2OXBXa2xrVFp2?=
 =?utf-8?B?ZmhaNmt1czAzdE9DeWdxQWcyTWU5aUxObFVocWZ0UVMxRlgvZXZKRWlYd1I1?=
 =?utf-8?B?bEtNRThYdklsZkdzOENoZkNrU1RyMkVMQ3BMdjVSdjNCeVdIQlBQa2ZRNVdU?=
 =?utf-8?B?RStycWZzbVVuUWorTEJWNDQ0YnQxZnZOblczSVZPK0IwYmdHeTVXRXFRQy9E?=
 =?utf-8?B?ME1oeDFWdTBYNzM5ZnNTTmZKbDRTUVAyb0hPb2R0Uk1sYXhNd1JZWm1MbUhj?=
 =?utf-8?B?dHQraWJxWm9SWldxZ2czSXVucWdVZnlwOTZuRGZSbTc0Nkx1T2ZINzVpc0RG?=
 =?utf-8?B?ZXlvMy9lL2UvVHVyWlRVUU9tZzk3WUtPSVhscmdpN0IvZ2JZZFg2Y25IWnRG?=
 =?utf-8?B?NEM2NFFML1N3ZU1Uekp0dGVacXZTWnBxaUNyc2F5WGdZVlZxUDBXVmMyK0F2?=
 =?utf-8?B?QzFIdk80aWhBNmg2Q3ZUSGVPK05WZjkvWWpsbmdBYWV4cUZCVkdOUVhPRkZp?=
 =?utf-8?B?dWRyeWhoNFBqeE1FV0VGaUdEN0pHRjVTSERrbVl4YW93QVFyRUREZ2pVWFpR?=
 =?utf-8?B?WmNXUlliZmd1S04zWHNwRmhvRm9OVFNqd2gyeUFlTWlLN1NtVjJJeXJjYS9Y?=
 =?utf-8?B?eVNpaUVTeTlnc2k3citTVXhiNDFHdFRscjVKeDF0bFY5VEw1SnRvOTAxYnA3?=
 =?utf-8?B?eWtxcGhHY2hNenBVVDlXOXJiOGNjQ3VZWHFCY0g0TzFXZVFieDNSZHF5bS9j?=
 =?utf-8?B?WW1iTzdUYTh5UmhleXZpM256NFhwa1ZPOTBkUHB4TjBiZDMxelJsV29CUkJU?=
 =?utf-8?B?VmdhYnFIM3VGaEp2c0prdjNWcm1jcE54TTdlNThRZ1RHdmlZYkNselU5bkQx?=
 =?utf-8?B?YXNXU2lVNmJqOTBUMjNTMzFEbVQyVldpMDhsVDFhdE9jNHRjSnpWMy9JNU11?=
 =?utf-8?B?MFE5MnYzV1ZUeEU4Z2RrK3pzWGpUNVBtcW9CVzVOMGdsTDBHUTdzUmc3Y3pu?=
 =?utf-8?B?QVZIRys4ZTd2cUNmNlJvVW1hTGJ0bGx0S05JVWdPc29qS1ZTdURsdTQvbElu?=
 =?utf-8?B?blVhUHAzOVlLSjVaS05JZ1NWbEZHQzdtY2ZFVTVTTVFpVXRuZ2NkYXdKc1BZ?=
 =?utf-8?B?alFpYVNrQ3diM1kvcDQ0d3lSTTd0QmVsbWdKaWhLaG54Vm1MTzJrVzJXSVg2?=
 =?utf-8?B?SVZVenBUM1pFZkdUT2w3dUpsNG9KTnNMWWVnOEZzVURvR0ZMWENOTFlOckxR?=
 =?utf-8?B?MDBodFdMRXB5QUI1cTBGWElSQzVvVGNVRFZlYkFyMDdHOFB2Z05kYW9kM05N?=
 =?utf-8?B?ay8rMlNLbVFNSXJucDhDaXRSRlZqc28xVEtabElqMFI2T1BuY3hzcXEzcDha?=
 =?utf-8?B?cWFOMFhWUU9wenlwMjYvZDJqREpkRGpVdHJHVVlNb245UkQxN0NpcFZLNEp1?=
 =?utf-8?Q?bOc8qpthefp/ItKtXy2PC+vis3eALDB5hnb2/lq?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e2c9fd7-47b5-41aa-00db-08d8f64a9068
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2021 02:45:38.5591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9yYloR8khfcJM5cU2sgpbotmaej6GHxbVny+SfpTyWBsW5uV7XJljqQGVsUHixsmo2bgc9D1uvyT6nVIYV5a+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6649
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/3/21 12:01 AM, Song Liu wrote:
> On Fri, Apr 2, 2021 at 1:58 AM heming.zhao@suse.com
> <heming.zhao@suse.com> wrote:
>>
>> On 4/2/21 1:58 PM, Song Liu wrote:
>>> On Thu, Apr 1, 2021 at 6:03 AM heming.zhao@suse.com
>>> <heming.zhao@suse.com> wrote:
>>>>
>>>> On 4/1/21 2:17 PM, Christoph Hellwig wrote:
>>>>> On Thu, Apr 01, 2021 at 09:34:56AM +0800, Zhao Heming wrote:
>>>>>> commit d3374825ce57 ("md: make devices disappear when they are no longer
>>>>>> needed.") introduced protection between mddev creating & removing. The
>>>>>> md_open shouldn't create mddev when all_mddevs list doesn't contain
>>>>>> mddev. With currently code logic, there will be very easy to trigger
>>>>>> soft lockup in non-preempt env.
>>>>>
>>>>> As mention below, please don't make this even more of a mess than it
>>>>> needs to.  We can just pick the two patches doing this from the series
>>>>> I sent:
>>>>>
>>>>
>>>> Hi,
>>>>
>>>> I already got your meaning on previously email.
>>>> I sent v2 patch for Song's review comment. My patch is bugfix, it may need
>>>> to back port into branch maintenance.
>>>>
>>>> Your attachment patch files is partly my patch.
>>>> The left part is in md_open (response [PATCH 01/15] md: remove the code to flush
>>>> an old instance in md_open)
>>>> I still think you directly use bdev->bd_disk->private_data as mddev pointer is not safe.
>>>>
>>>
>>> Hi Christoph and Heming,
>>>
>>> Trying to understand the whole picture here. Please let me know if I
>>> misunderstood anything.
>>>
>>> IIUC, the primary goal of Christoph's set is to get rid of the
>>> ERESTARTSYS hack from md,
>>> and eventually move bd_mutext. 02/15 to 07/15 of this set cleans up
>>> code in md.c, and they
>>> are not very important for the rest of the set (is this correct?).
>>>
>>> Heming, you mentioned "the solution may simply return -EBUSY (instead
>>> of -ENODEV) to
>>> fail the open path". Could you please show the code? Maybe that would
>>> be enough to unblock
>>> the second half of Christoph's set (08/15 to 15/15)?
>>>
>>
>> I already sent the whole picture of md_open (email data: 2021-4-1,
>> subject: Re: [PATCH] md: don't create mddev in md_open).
>> My mail may fail to be delivered (at least, I got the "can't be delivered"
>> info on my last mail for linux-raid & guoqing's address). I put the related
>> email on attachment, anyone can read it again.
>>
>> For the convenience of discussion, I also pasted **patched** md_open below.
>> (I added more comments than enclosed email)
>>
>> ```
>> static int md_open(struct block_device *bdev, fmode_t mode)
>> {
>>      /* section 1 */
>>      struct mddev *mddev = mddev_find(bdev->bd_dev); //hm: the new style, only do searching job
>>      int err;
>>
>>      if (!mddev) //hm: this will cover freeing path 2.2 (refer enclosed file)
>>          return -ENODEV;
>>
>>      if (mddev->gendisk != bdev->bd_disk) { //hm: for freeing path 2.1 (refer enclosed file)
>>          /* we are racing with mddev_put which is discarding this
>>           * bd_disk.
>>           */
>>          mddev_put(mddev);
>>          /* Wait until bdev->bd_disk is definitely gone */
>>          if (work_pending(&mddev->del_work))
>>              flush_workqueue(md_misc_wq);
>>          return -EBUSY; //hm: fail this path. it also makes __blkdev_get return fail, userspace can try later.
>>                         //
>>                         // the legacy code flow:
>>                         //   return -ERESTARTSYS here, later __blkdev_get reentry.
>>                         //   it will trigger first 'if' in this functioin, then
>>                         //   return -ENODEV.
>>      }
>>
>>      /* section 2 */
>>      /* hm: below same as Christoph's [PATCH 01/15] */
>>      err = mutex_lock_interruptible(&mddev->open_mutex);
>>      if (err)
>>          return err;
>>
>>      if (test_bit(MD_CLOSING, &mddev->flags)) {
>>          mutex_unlock(&mddev->open_mutex);
>>          return -ENODEV;
>>      }
>>
>>      mddev_get(mddev);
>>      atomic_inc(&mddev->openers);
>>      mutex_unlock(&mddev->open_mutex);
>>
>>      bdev_check_media_change(bdev);
>>      return 0;
>> }
>> ```
>>
>> I wrote again:
>>> Christoph's patch [01/15] totally dropped <section 1>, and use bdev->bd_disk->private_data
>>> to get mddev pointer, it's not safe.
>>
>> And with above **patched** md_open, Christoph's patches 02-07 can be work happily.
>> He only needs to adjust/modify 01 patch.
>> The md layer behavior will change from return -ENODEV to -EBUSY in some racing scenario.
> 
> Thanks for the explanation.
> 
> Could you please send official patch of modified 01/15 and your fix
> (either in a set or merge into
> one patch)? This patch(set) would go to stable. Then, we can apply
> Christoph's 02 - 15 on top of
> it.
> 
> Thanks,
> Song
> 

Ok, I will resend a patch, which will replace my patch & Chistoph's patch 01.
Then Christoph could re-send 02-07 as v2 patch.
My patch need to work with Christoph's [PATCH 04/15] (md: split mddev_find) to fix soft lockup.
I will mention the relationship in my patch.

Thanks,
Heming


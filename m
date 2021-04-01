Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADD02C43617
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 18:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8444061130
	for <linux-raid@archiver.kernel.org>; Thu,  1 Apr 2021 18:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235659AbhDASK7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 1 Apr 2021 14:10:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:32335 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236421AbhDASD0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 1 Apr 2021 14:03:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617300204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VfE1dRSTm8gKXW0rIRwb6T4/jt5EMPAEOR7117uI+HU=;
        b=RoRx8lbLex+K/HxjK36feLhnnp5T/I3uv29/JHiHs9gdog9PhSvfOuJ4G+Ms5HHOo/ikPe
        6TWzYwRQslixlP15B2lKxGwW62XajxqOT9nHBatDRdL8F6McxhvuhDp6t+aKJOlCdZsdbH
        pkNu4CmbL0NugGoKNHphlGUuxWIyX20=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id de-mta-2-orhSqq7HPfigjgg1mKnt6w-1;
 Thu, 01 Apr 2021 15:01:20 +0200
X-MC-Unique: orhSqq7HPfigjgg1mKnt6w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JQGV0GpgKCz16u2SK4ucrwdkXg4yWELjCfNMJhoGxAADMtJEiaaontdCcH6anxgWLXKKWvKYBeZJcaoHXd5GQJwNTHgEpPyxAx9otqUJgc9dQJH8XQjts2FkR2EfqaOOuxqP9hOdQnHfFItgQJGg/pnu0n00q1mythr5xFB0IGlhq8stX1k9Tqnw8HhN5sKjGaClVA4JPjmgtc7pn0zvNtlOVQDeChjsa3DXipac0ZWiawMJz+LMSQXcFgMpLKha2fMvMRz0TiZet1cJO3TddKCR+9TTR13hxBsNeJFfZTKZJG4boOY0PCunvKMgdI7EzFp8TEZJqqZHUBaOOQIPuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VfE1dRSTm8gKXW0rIRwb6T4/jt5EMPAEOR7117uI+HU=;
 b=FsfyVBdcR58lHoHWSkM5blMnTYwz09YD8fdrwc43BSz00MUATLf11Pi+uNYE8kUV4a8GSLOLM2qSS657YKbavbkdV1VJ+Q+FPbTqKA44wmnOasAf+34ONTwjc+5nrtH1LRNIi+tn+J6rZxP3vFX83757taZWARP2pjuGCjAwZktqRDXjIMgoj7KbC9+WyZPvH7UlvgoU0p+zvIqy2XTr4BPvr4qO6aa5P2lTahIfPDImVtTPjjyAWUrEdWfeldpHoH/kstKeNbz4gzWysxW/JI8T6Ap+DTrVexuZ3WsMBEaHxDu4e2xOb5CMxWKAYg2fT2zT4RlJCxyO4AkoU2Ku+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBAPR04MB7462.eurprd04.prod.outlook.com (2603:10a6:10:1a0::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.28; Thu, 1 Apr 2021 13:01:18 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.027; Thu, 1 Apr 2021
 13:01:17 +0000
Subject: Re: [PATCH v2] md: don't create mddev in md_open
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.com
References: <1617240896-15343-1-git-send-email-heming.zhao@suse.com>
 <20210401061722.GA1355765@infradead.org>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <a96554cc-abbd-347c-ea24-37d2a41e6073@suse.com>
Date:   Thu, 1 Apr 2021 21:01:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210401061722.GA1355765@infradead.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HKAPR04CA0005.apcprd04.prod.outlook.com
 (2603:1096:203:d0::15) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HKAPR04CA0005.apcprd04.prod.outlook.com (2603:1096:203:d0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:01:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 024bf0b0-153d-4d20-cea5-08d8f50e3d07
X-MS-TrafficTypeDiagnostic: DBAPR04MB7462:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7462210F0EC92F93A61DAC35977B9@DBAPR04MB7462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kZ3zhqfdxSaepiyOuwvEN87u/4OXa//2lVZptWDq/lDAq0GhBEieKRAartWDe1sx2MeeNUlRoOlQ47776Z+eQ8/TRfp2qpcGyYXrLPA2uFPUYzlsCsIXh2riWkIL8XRSZ3JyCV1lNNaLo4EaAx/nzZ4+DrNiPaXm1wRNQaoNbyjGENHe7Vm/r7+5409sqv/3gtbrkfrBlFNuS/zbZ7vGVf4GB2wyE3HH6zoeOOvQ+i/XvvrRimxwm1cDmtBozUFyTsfLWhsURnKe0SjZX2uA2LgWBdm/yjlIYEyv90x3EZ/8UC0pNKnovWeaduQZr1OJ2MuUe3dDqa/e9Xqv+xreU3xKv6w8suzOrG8VHaLPZVpE8ew37i/8rR6pCqDJZbbayGD4aNOigRSo2vRf6B7lGhMNUwdcsj8eMNuoE0Crkkxc3NfV31lt6DCGEKKhX06zQB8o0ngCBoXievhGBri2vBUnsBVzsxcbE7shgLcyYjBYR9VWLr0f+E2E2K9/vOyWqWzQ6UajXV5Fg/qrio5Ebas1Q3Y3MCSrFufSQZEdYgvKDVPEr+VmIy1u1I8QuEiwmGKq+Dv8wrgBETrNAHwtR1NiUPyHz4zeKzWbMPz7dZOMit6eGThJASCyxFEgRKQ9Oar8iucv9N8Uhr96gEIvPIOBvZEpDzuhg9lX2Dnx5NMD94LPHIwRl3n+bkVVUsvpruQGSl/EyCfIJY+MjP/da49jNqBnWPPtGgWSnkS3pxV6V475w3Y3xmCS6F5XxCwj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39860400002)(396003)(346002)(2616005)(53546011)(8886007)(52116002)(8936002)(956004)(4326008)(31696002)(6916009)(478600001)(6506007)(8676002)(316002)(38100700001)(31686004)(2906002)(83380400001)(6666004)(26005)(36756003)(6512007)(16526019)(186003)(66556008)(6486002)(66476007)(66946007)(107886003)(5660300002)(86362001)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?+iSkNLwqR0RGNuYPYtZQLDctoIjD8YaeUO5mlHu2vrHVvts2AQ/VE9m9?=
 =?Windows-1252?Q?0FKeWOY9WWWyh+jt/9uKXOAwT55v5eEjnhJu60GQgmoKgdteb89rtN+L?=
 =?Windows-1252?Q?C2JZU6z6pTq2q88oEWZuBCg83MXZ2TOzFuHblYjcm9ujpM+pb0e9/XvP?=
 =?Windows-1252?Q?SH4DcCacCb4UpkhWlEFR5Ig/YkL8DQFWBoNRuNnFdh8id97Ey63jCP5F?=
 =?Windows-1252?Q?6Me4HHLdjTfKo0Grzx55nKWq/Goa0le0R1NoiLYamBSwX1ztcD1lGSb+?=
 =?Windows-1252?Q?rsjeNSfmnHBIoodNLju5ijFXmGH+WxYdCwNsirXcGiCaRX++nsAC1dRY?=
 =?Windows-1252?Q?1vNYuYGSeLt8KDm0kCd2rdsslR2nsWzRZWLJH6zfL3ku3opOseQs2lTs?=
 =?Windows-1252?Q?A+wMVN9CyT5joulrSaa0wMah6RjvQh/FV45eJYEuhhJeRL+CF+QG7pOe?=
 =?Windows-1252?Q?dsXUdaEtnd2amlXwYpipY0kaFYEioAawmZ4+fMxcIA6G49qPIq57WcjX?=
 =?Windows-1252?Q?Jt/TAW908zG3yDgFeOPWpFRGzzXL5Rez+m69NXRUYwQyB55UAFShnoBl?=
 =?Windows-1252?Q?ixON3YDAilb4OBNGcmdRKYWpdbi7R8Td1ChLHVrKLBZEMkRWmaXo0tzJ?=
 =?Windows-1252?Q?CyYJDtrOyTYGhfUpA5DjfekO1wQy6fd4hzNhoa3IbqQ+Cnr5Z/TSxeqy?=
 =?Windows-1252?Q?6Au65g+MtPhS3JyT0gkN1kYPD2E9XpI5Hp3MJXjASvSXJlAW0Qspk2H9?=
 =?Windows-1252?Q?KHvsok/6eu0t/t2UtwOTD4l7SoqCOoFGA18onD+SRvR7fu2NhX0GAibo?=
 =?Windows-1252?Q?TKJbKJyq+Xl/0+rVehXMOIgQ8ZZhPFtOugJnz8T+1j+VThXn89wdjdjw?=
 =?Windows-1252?Q?NSSl2lFZCA88nJG9xex9iOBxrWgZ5FZjvvYM5SKqsr1x5c3bIvu8d5oW?=
 =?Windows-1252?Q?J3hgNrLS67n8B47wJbzai84dbEyqOKpvvG9NhoATNtiNCE4bQU0P7YCB?=
 =?Windows-1252?Q?aeZ3yRhQ+/StDLQszNF4tFD4jXtLp5L1C/BUck7FYCxXMw1+7ciNaq1J?=
 =?Windows-1252?Q?UHS8zzdwLZucfySsZegcghJvQJHOKOgdtrQnoV2kz+QAXj3i5AQ0bUHq?=
 =?Windows-1252?Q?8A97dbMuB8QuaIu3vUS2IZuqIYO0oGDIhRFEQUiWu71IVHKhaTu4RNwE?=
 =?Windows-1252?Q?kC/HHqAe2Kv5+LK7BngcUl9F4oZIUgqOsLuVnFDnAPRJ+q0Rvr0iAwRP?=
 =?Windows-1252?Q?3EXnwx3J6HD9jmKBevLQrRaeYNOzaOHoHizAbIiDaS/42u/D0oEejRjl?=
 =?Windows-1252?Q?Y2Iy87zQbHHomuvqb/YYyhMyMJa56VH9oGQpbqEMstm4DUj4V3vMoY75?=
 =?Windows-1252?Q?GO8rxH04NnSYJ6QYYZUs0k6kg9u6fwKoqkENITG7iQbSsny12e7DrnPp?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 024bf0b0-153d-4d20-cea5-08d8f50e3d07
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:01:17.8042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: navl9WLuXyOv/s7DqRRcpueFWkjzyXU+NDMTEuDgrp6cIKDRGkVM2ZTmg2HON0hgZXWtO8yTNUEZLHwkyz0FEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7462
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/1/21 2:17 PM, Christoph Hellwig wrote:
> On Thu, Apr 01, 2021 at 09:34:56AM +0800, Zhao Heming wrote:
>> commit d3374825ce57 ("md: make devices disappear when they are no longer
>> needed.") introduced protection between mddev creating & removing. The
>> md_open shouldn't create mddev when all_mddevs list doesn't contain
>> mddev. With currently code logic, there will be very easy to trigger
>> soft lockup in non-preempt env.
> 
> As mention below, please don't make this even more of a mess than it
> needs to.  We can just pick the two patches doing this from the series
> I sent:
> 

Hi,

I already got your meaning on previously email.
I sent v2 patch for Song's review comment. My patch is bugfix, it may need
to back port into branch maintenance.

Your attachment patch files is partly my patch.
The left part is in md_open (response [PATCH 01/15] md: remove the code to flush
an old instance in md_open)
I still think you directly use bdev->bd_disk->private_data as mddev pointer is not safe.

Let's wait for other guys opinions.

Thanks,
heming


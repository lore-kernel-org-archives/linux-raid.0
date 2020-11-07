Return-Path: <SRS0=Jo7I=EN=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D272CC388F7
	for <linux-raid@archiver.kernel.org>; Sat,  7 Nov 2020 03:53:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDE920715
	for <linux-raid@archiver.kernel.org>; Sat,  7 Nov 2020 03:53:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="c1zAcVO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727471AbgKGDxu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 6 Nov 2020 22:53:50 -0500
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:47114 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbgKGDxr (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 6 Nov 2020 22:53:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1604721223;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2WN4sMMlk13S2y5JufTHoXvhvctpML5LPhGQErtfW4Q=;
        b=c1zAcVO/znpLjOzZBg4zUw6jDrklZqSSVSvE02HTDRuSQ7tWjp7YBBllxQmOhqnFj359BG
        i2UmY+NtrlqzCi32hzpzQFklHwqzvrme1/8dL/Duc9nobzyvA9aQ2rNWKXaUdn1BBEThpw
        DEuVijwIWrT3xCbck+HW/7sAUzJEnMw=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2059.outbound.protection.outlook.com [104.47.13.59]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-38-aRBfVV94Os-b5I7e-Yt3zw-1; Sat, 07 Nov 2020 04:53:40 +0100
X-MC-Unique: aRBfVV94Os-b5I7e-Yt3zw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CCa1tWnuP4Vquk4VWHufUapdmh4puGlF7zePknkDyQrXqNmiDNkFpzDRhgAdeb4LGXy4i2uReH6XQdHQTlk8cUfc+TYaEcszfVjvAFe43eWWh7JbumZNsfF/7R7gLWTaUuR1u42TXZGXfUIPUJP6xyUQGO/fppSFGaCN8a0mdAOY69LMwhm0jID8P2jQ/ai+bTeydjuVyToVvXQ/czik9UNQi4lBIqhQvxdoUcBecznkoSrnBqbEAG3Porm2M3SLVQZgp/di3KkD9Xy8PljPH5b0w7+5Vg1RsC/UETRHAf8EdzodP6iyApJN0u+eWQkGrH+QJ4XuSaYiQz9Nb/TBtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2WN4sMMlk13S2y5JufTHoXvhvctpML5LPhGQErtfW4Q=;
 b=bOxNBhAsarIC2pgLCBhXVzFdJeVTnGH2VwTveEN0mOAMpcGx8DQfPqMHfgNLC9O7qqqdgOI2UkLgQDU3ufOqg3pqldNGluO47/4pMTZ+jf5trmc0GGatKgdtYZQJyvmtmL+BbqjNmFmxp22PcEHluLwzXDC47ZyuW5aCvc8X9JwKWkWMPWkVPA3lZs8Mv16Qk9KHwq2HZ+BKbkFG3zhGSSAHnq+Nrani2QZIHnkizm1EGN4gI92NG6ON7Y1ubYCwxyFVUYZM3oNcZK/cMwpf2CxNWr+gA6wS0wOIPPY5POtFkb9D7Z+su4ynnt+IJCNBnLzAJcrk3Vs0TjhswlljLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB3PR0402MB3675.eurprd04.prod.outlook.com (2603:10a6:8:b::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Sat, 7 Nov 2020 03:53:38 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::197:4f2c:bd9d:ff7a%7]) with mapi id 15.20.3541.021; Sat, 7 Nov 2020
 03:53:38 +0000
Subject: Re: [PATCH 1/2] md/cluster: reshape should returns error when remote
 doing resyncing job
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>,
        lidong.zhong@suse.com, Xiao Ni <xni@redhat.com>,
        NeilBrown <neilb@suse.de>, Coly Li <colyli@suse.de>
References: <1604581888-27659-1-git-send-email-heming.zhao@suse.com>
 <CAPhsuW4GqAXQ=6Hx5FjYhECxmVHDKC0j2oiqx6Q5OLvqe9F9nA@mail.gmail.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <5ec56903-ad21-f3df-bf59-8fddff445328@suse.com>
Date:   Sat, 7 Nov 2020 11:53:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <CAPhsuW4GqAXQ=6Hx5FjYhECxmVHDKC0j2oiqx6Q5OLvqe9F9nA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.132.155]
X-ClientProxiedBy: HK2PR02CA0211.apcprd02.prod.outlook.com
 (2603:1096:201:20::23) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.132.155) by HK2PR02CA0211.apcprd02.prod.outlook.com (2603:1096:201:20::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Sat, 7 Nov 2020 03:53:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5a23218-fe56-4605-9fc5-08d882d0b595
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB3PR0402MB36755A81AB031D168D13ACCB97EC0@DB3PR0402MB3675.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RE0mvoP4qEJnmyDhslIC6N+VVROv2V4v7q7JDvHWWeg20y2xnWKFVWrZOg+3TtlTkbpCsYfnvcmXvYKv7Z4Acmbvj6/2/CNSMnPBlZlWV3Ez3RiDnzyrUNZTMAyJgjhCgcnx8PdNJs1Y4k8wNwbOUgiB7+wZOHZOhubyZuGUB4ATXqeMsoc3Ke/meqLRsQslg1IhOlY5tR0rfOhKXTd67KsuUbzm7y+4rAYfm4rCvp0pCyIRS7p4yPfq2yL+B8xc7Cnm64Nbl9Iu0zHAlQkU/zfvSGC5JMRRH5c0XY030MQ9I7gDPI8xwPxxvOv0jO069TZ/65Vn0P/HdMV+1dYWYb++JKmK7bXrzC3o/QD6mkGm+jipU30+tffHe1o4KTXROEoEEgJ4LeKJTvg/A7w7ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(39860400002)(346002)(376002)(31686004)(66946007)(6666004)(52116002)(66556008)(956004)(2616005)(66476007)(83380400001)(8886007)(186003)(86362001)(6486002)(16526019)(54906003)(31696002)(36756003)(6506007)(5660300002)(6512007)(478600001)(316002)(6916009)(26005)(53546011)(8676002)(4326008)(2906002)(8936002)(9126005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vc+cH8ZFYEcmhQNBG//RmRGKhEZo7ZHi7X5136rHX8DYuasWy5uMDGa3yckfqqbLcONJ5kLdoj2xbJPm6rUXQlMhLGYrU010tmvPMmpfi8az8O3SvGGWuhXjAxK+3kCnJK3mfHY25+Hv5vtSxDOHqxh3KWrf79vN7P7qnsrpMeFEP+ueke3HVmhyTvkmdzx2bdkb5/ZyGkoDvhi469xr3kzYquR9elgW3LlKWCHdifoR5BNQYh2R04exjDkwjo+AqTG32sRtton9sWGCuf2El4Gu/CMC/+l84SEGwuCrYyUm/cpNkwavVerwc1exowNkiIzgYwz0jZm8GeovqhlRs2Qx9zf5o7sOhcRWyZqh/wtFTMIqDNwYYf7Kem/FAo+jpjNHixh6T4lKRH/mcAJgZgWqR5GIlh8xONR3JmYOec87Oth9rv5zhuC2zsJjA42Ja5SABZqL5SDGv3Iycad4Fgy1rYlS/HOfDiE4O28OV2Cgi9glfLH5X+pnQuVCCWsp5WXeCtXORpwZZwhvzgNOMyyvwjHFJ2HFnVk4o9JnvNx9cCynKxcXBaFQl3bm8mUzrvNnIIrQjko6gGAf3hunrWtqNVb9GXPipMbXuufJAAZV5y49Iytf4IBlcfBJi8QEoZ+cQT2Er1YlJqCTjc9GDQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a23218-fe56-4605-9fc5-08d882d0b595
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2020 03:53:38.6993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Znp8AqIA50wjLwzcP9iIyACAPy++ohSAoxq6N40fF2Tdz1YasGcftQYmC7H4BlXkT2Q4J4qWb3xK5OkrkuZU9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3675
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Song,

OK, I will add a cover letter with more descriptions & resend these patches.

Though the test scripts almost same, there are two different bugs. 
patch 1/2 fixes --grow wrong behaviour. (the bug happened after second --grow cmd executing)
patch 2/2 fixes md-cluster deadlock. (the deadlock happened before second --grow cmd)

The patch 1/2 bug was came from one of SUSE customers. When I finished bugfix and ran test script to verify,
I triggered patch 2/2 bug. 

test script of patch 2/2 adds "--bitmap-chunk=1M" in creating mdadm & mkfs.xfs after setup array. 
These two steps make array to do more resync work. More resync time give lager time window (more opportunities) 
to trigger deadlock.

Thanks.

On 11/7/20 8:17 AM, Song Liu wrote:
> On Thu, Nov 5, 2020 at 5:11 AM Zhao Heming <heming.zhao@suse.com> wrote:
>>
>> Test script (reproducible steps):
>> ```
>> ssh root@node2 "mdadm -S --scan"
>> mdadm -S --scan
>> mdadm --zero-superblock /dev/sd{g,h,i}
>> for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
>> count=20; done
>>
>> echo "mdadm create array"
>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
>> echo "set up array on node2"
>> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
>>
>> sleep 5
>>
>> mdadm --manage --add /dev/md0 /dev/sdi
>> mdadm --wait /dev/md0
>> mdadm --grow --raid-devices=3 /dev/md0
>>
>> mdadm /dev/md0 --fail /dev/sdg
>> mdadm /dev/md0 --remove /dev/sdg
>>   #mdadm --wait /dev/md0
>> mdadm --grow --raid-devices=2 /dev/md0
>> ```
> 
> I found it was hard for me to follow this set. IIUC, the two patches try to
> address one issue. Please add a cover letter and reorganize the descriptions
> like:
> 
>    cover-letter: error behavior, repro steps, analysis, and maybe describe the
>               relationship of the two patches.
>    1/2 and 2/2: what is being fixed.
> 
> Thanks,
> Song
> 
> [...]
> 


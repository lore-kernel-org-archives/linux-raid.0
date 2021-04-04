Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A578CC433B4
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:02:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 703656136B
	for <linux-raid@archiver.kernel.org>; Sun,  4 Apr 2021 02:02:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236845AbhDDCCw (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Apr 2021 22:02:52 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:43868 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236782AbhDDCCv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Apr 2021 22:02:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617501767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KTpmGsVmERB6ukIoTU1+kgo5lfErwOe30R/le9L73ko=;
        b=RDW26yqQS6YEqC6YMmcI4Le51FT0tQcIMuynpzFNl4syHHEhnhRM1/8LohUZUN9OKDIV9K
        A7B18M6h1W5x7JuRRo9Cd4Nym8+r649VHbsb6Ue0F27Ewovc2cYZO1OFOF7P2QkwZkZ7bB
        kXF09wbyMZwiC7NqOhAs5OhlMI7U+rY=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2174.outbound.protection.outlook.com [104.47.17.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-20-ZLTY3vLhM8CLqautdE3jpg-1; Sun, 04 Apr 2021 04:02:45 +0200
X-MC-Unique: ZLTY3vLhM8CLqautdE3jpg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gro/t/MH+wfd5y7xzrh0j3QSNCejGs47kLRjQIFlwrtaTRFoNkuGe7xqgYMYDnAUwRESttBqh10GDv2FyDsVvdeaiRXTjyvRANaWVa0snhU47ywr+1S/NrF0+gb/jElWoSV5j/4B9fBPCUlUxuKKkAiDuoFAD1HVNAFs3pnsfOOH6f4iDWdeHKtFDeK7pVjeYVsh97SEdyISg6MZKyZo4WEHVSk26Ww8cz7eAyfJSFn/5aKAL1fVEpczUDZws7grJ8KX+IpjFBzsv3sbBJ+4dD0ysqVodtA31+ZlReML75npX0b8qmUGNgDS1DvY/EswUnt+F7bKGKDuH+insu82Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KTpmGsVmERB6ukIoTU1+kgo5lfErwOe30R/le9L73ko=;
 b=R0CxxXQPU+AMsud5nDbnhmBsi9pK1Ooaj5UyV2ulqkNlILjNCx4kYQz+IkFxKtPK2uRc+JG/IP5l3AvDKTLYQifMQp1Z6kIAPf/IwTx/yKQt0e5nofiGeOLbJaDS7xVUv7cxjlfELIAzXiEsjBong7kXAqm131mHgpDNcL5ekzgR/f5Wg/gjOMuw2T9QMFasxj3RzqNEVlSkstU3S8Ax8XM/e6b664wbDtVzSE4p3uRaUN+mSaiBFpq2ENDOtxYhQ8CnIK7pAgBkNu2jxa4kJIqOpXYBd2BQUVjqd2vKR6iJq7pLusakyNlCBYwozeXhsggAXKdymZxHMCVq48FU+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB4443.eurprd04.prod.outlook.com (2603:10a6:5:32::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.32; Sun, 4 Apr 2021 02:02:42 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.029; Sun, 4 Apr 2021
 02:02:42 +0000
Subject: Re: [PATCH] md: md_open returns -EBUSY when entering racing area
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-raid@vger.kernel.org, song@kernel.org,
        guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.com
References: <1617418885-23423-1-git-send-email-heming.zhao@suse.com>
 <20210403161158.GA4657@lst.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <66c520ce-6c5d-1895-f18c-886f2e729548@suse.com>
Date:   Sun, 4 Apr 2021 10:02:31 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210403161158.GA4657@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.134.184]
X-ClientProxiedBy: HK2PR03CA0044.apcprd03.prod.outlook.com
 (2603:1096:202:17::14) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.134.184) by HK2PR03CA0044.apcprd03.prod.outlook.com (2603:1096:202:17::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.8 via Frontend Transport; Sun, 4 Apr 2021 02:02:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fb1ec8d-3782-4cf8-13ee-08d8f70dbb0b
X-MS-TrafficTypeDiagnostic: DB7PR04MB4443:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB444358EE83D950324AEA4EFD97789@DB7PR04MB4443.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CCLO+/7j9w7O1mxUplDdP+t4RRunpY7iKG6TY2mbmX97aVqFDzjxBUor8FbuNj00cckBvYLFwKSIU4yC9gsYZ228r8ziYPlTSNpaHv+01gGUFN/RAIEw+DzqdSdwj3KiYThUhOJrpe6x9Ict+xBbqSuILgowi2YNP6Nwqs1fWFBVoYGpyJXrmdxIa2EaD9f38/T9CopeTcUqVFvdwbOd4WywLHEmkyhxkHUdcAnSy0TGjot/g6VvJqIAJxkDmZ2RKXArdEZIxOWmnEpes9p+RD/0+r3t9pk2Idl2oisWvYsMdllzrxzVoZRMZfNM9XCbdeNf3bg1CnD3fI0RUtvj9bk4dVBf+3QbtAYvWJyOR2yXgb505QwnSaR2/Ey6wQtmTlkvBY6m6LE80UPklm9fy0kUN/OG+jklai8p+ODLAG0E7RyPgsVdPfjL7k5Q2TM/r+aUfmqmTj5MIx+VHCUAa5Jhz2SHsm1P28ID+8WD/mEZeFfKooCrK+6dHvdsO+e/RRhkgzlpp/BeutwSVl+wXqCTrehrKfo21yilgEHuy1TUA5rwf1CYnrXGNrGQk5MsWZXhbmEZ1JPvNinCo2XOlBxb05UWA8VhgM/BAU5bCZM/kdNp01mRnG6JP3SvRE1SmcvXrAGskQklI2SLEQTkCkmq67FnpV4fJr4z7YNyBumg1YDacYu1Xe2MgqvpY50H4w2ZL1ydYMFT79H1YVAmslqhYVwTdh08QbjrGxsavAk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(136003)(376002)(39860400002)(346002)(38100700001)(6506007)(107886003)(66946007)(2906002)(66556008)(66476007)(53546011)(26005)(16526019)(8936002)(186003)(36756003)(31696002)(478600001)(6916009)(956004)(2616005)(8676002)(8886007)(6486002)(4326008)(5660300002)(52116002)(86362001)(6666004)(31686004)(6512007)(316002)(4744005)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWw3bXhGUjBkSmpxWVIrNno3NXAxck1pMkR3TURpcE9zeFlPM3dXM3JhdjZZ?=
 =?utf-8?B?Z0Q4aURickt1TlF1OXFVdzFKYlhmQkFHZzZiQ1ljc3NOeE4rMUJjcUlJTSth?=
 =?utf-8?B?TGZZR3M5SjFpcTNDWlBUS0pJblI3dDA3SndKMDVPTnFYZ09ZbW8rd0l6enVr?=
 =?utf-8?B?TmdLWUMycVJBS2huR29nTkFDeVBZT2lBc0FQNFd5d1RSUkVacjd1TGlBVmpj?=
 =?utf-8?B?UkFRTGVMSlFNWTZySDR6ZEw0QXpTcHUycC9SQUFDYmI1ZE1LYTh2QUpmYXBq?=
 =?utf-8?B?NE0vQzdiRjJ3eXZIeER3SHc1eitaSjM1V2RMUEdrYlc0VzgxWWZWZCt6TnRp?=
 =?utf-8?B?T1FCK05xalFMOUFWOCtCM2tlRDliV1orRkhEbHlmVW0xaWdQZlNxbGtiN0l0?=
 =?utf-8?B?Z05Rd0dmRGpWei8waGcycm5SRGpiRTNDajhXNE45aFNVYWRyRXpnbHE3S25u?=
 =?utf-8?B?S0NxUTVia3FYakgvVVFHSy9mZlBjMHg1ZXh6VWMycU52emd5a0JhQVhWN0xZ?=
 =?utf-8?B?WEs0cW5SRGhsVloxcHZBY3drOGtvSkxiYkNYWjhNSVZJZE5CTlFwd0cycTVE?=
 =?utf-8?B?eDQxaFhGUFhIaks2ZFZsdmM1UXBoUUZPSitHMEpOOGdLd3lDYWVzdUdwZnNZ?=
 =?utf-8?B?azZwUjIvbUM3TFJIQ0h1Z1FFZ0IreEJrOEovZ2QwMWZWQlM0cURnSVc5eEpB?=
 =?utf-8?B?L1hQQmNqY2M3UFFoOGVycFB0ejZOUmhlTjJxd3FCRVFmZnFKQ21iOGJxWlN2?=
 =?utf-8?B?V3gvY0RUMnRtd1NuOXhnK1ZIaHozT3R6WEMra3hHdHFqbFpmTVRtc2s2b21t?=
 =?utf-8?B?Uzh2Ny9YVkVaajc4UzZ1Z2dmZFF5N1pYdk1WcHRXRm5hR2lIcm9kUkRhZ1l1?=
 =?utf-8?B?aU1JMS91QUdKbFZSNUlwbmtNeTdMSFZsTDRPZGV6Z0xaUmYyL1VsV3VCaVhP?=
 =?utf-8?B?NmJneTBFdU9oelBJS2ovcnYvNHQxQm1YeWR6RlAweWlyeU4zT084VmpUWG9C?=
 =?utf-8?B?UzlrMzJZWnlTWG9xRHIrcUUxaVkxTmF3L2pBVStWdk9TTHJaRHZKcUhEdmV6?=
 =?utf-8?B?cHY1Q2tzMVF4VFM4Y2RaUlg2YTk2N2hvT1dpS1NXWkhuNldpeDhadUhpcG5l?=
 =?utf-8?B?TDluam1Nb1VpZnNxZ2lIdVA1cjlVTTJyaG5nd0NlakhPRjFUM2hKVmx4OVdD?=
 =?utf-8?B?MjhvOHBuOWNoYW4xNUo4SnFiNDE4TGF5OHNmUGVGYmI4VlVhRVFPSjIxaUNR?=
 =?utf-8?B?c2tlNTRFR1FidkRhR2ZELzBoMmt4TnhXSVFSaHJWZ2dUVTN2czQ5T2pNU0xz?=
 =?utf-8?B?M3IrVHAxQmRLd1hHZDRwcWFpS3ZuR0FNVGZuaGllcWRBR0xrZHBpUlQxUHBG?=
 =?utf-8?B?SDA3Z1U1b3ZqbTBzcHFhVzNmS0tYcVdWL2lVUktONmIya3d2VjYxYy81Qml2?=
 =?utf-8?B?Nkw2KzhjZENaQXJscmhkNk5DZXV2SnB1aUNJWWlwUmhoY1dMSW0ySHhhRWhq?=
 =?utf-8?B?bkliUjhZVEhmMGl2Y0picDc0RUltaHg0TVQ2U0dFNkh3eXluZGVvMERTNFlz?=
 =?utf-8?B?TEhrSkVFalRGZ1k2cWc4RHBjQ295UnNKS05ZUGcyUFlFaHphQXRvRkJ5bFUx?=
 =?utf-8?B?ZjgxdTFHdGlUa213ODY4M1F4WnIrMHFRVXZGNmc0eXh5a0ZWbDBqT1lUajl4?=
 =?utf-8?B?UU9oT3NuYytJd0pXTmlyL0s1MzBkbUVkOWE3bEV5dnJOMVRVc0NTVmlmNVp0?=
 =?utf-8?Q?ZyJ/bPzEsm8fjjoux2GcL/JpzPBNJk85SqhjgKy?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fb1ec8d-3782-4cf8-13ee-08d8f70dbb0b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2021 02:02:41.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bl1a6TZ5OyQrbUPhVrQBBL47IyKSRHEeIqJNV1ZZsLZZyVOztQZV/XiPKBTuReLa5nI5vl7v2beME4m74CgYbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4443
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/4/21 12:11 AM, Christoph Hellwig wrote:
> This defintively looks better than the ERESTARTSYS hack.
> 
> I think I'll defer the whole blkdev_get refactoring and bd_mutex to
> open_mutex conversion to the next merge window, so I think we should
> be fine with this plus the mddev_find split.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thank you for your review.

/Heming


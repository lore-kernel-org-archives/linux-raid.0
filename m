Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B145C3F6B0
	for <linux-raid@archiver.kernel.org>; Wed, 24 Aug 2022 20:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238135AbiHXUkK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 24 Aug 2022 16:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbiHXUkI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 24 Aug 2022 16:40:08 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2042.outbound.protection.outlook.com [40.107.92.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0512D4E618
        for <linux-raid@vger.kernel.org>; Wed, 24 Aug 2022 13:40:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HzmV2QX4z326B9A9jyZyl1ctK/WSXfDF7gqcFw+5GxbIdHGe2b0wS6cStUm6qhfBOVWl0FfMGK3gV/Wqn2JN88c6U4Wm5RNvcqb/4HAFRyzUs8PXeH4+5FiAT96m81baz/7B/ro/WSwRiar3VqSBnNYAlEOk8Y590X03AdR5BfC1arvv0ncMrkZY4yAW9UthH177N5X5kjf28+8OlQk+l/rY6yAwJcTviaOnMXL0+C/aXxT59Mut6os8f2IYPF1+ek0fDMJFkgGN0IS3ygJHokxAGGLRxUtcBvAUDRURfM9zzujFPkZcDmES///RdVVJVlW5uGs/M5EQ40hOXVM1RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tnTwolicnnInymMKrClDG9n1k3I6OVhSckQpWCajkCw=;
 b=SVeQxCSCM9Y/ly1gshihQLVXGoqmvmloXFY8gFbSRo4IXPMsUigaq8fhbN6Yth4pPDX7FzA6wQbXcK+GYznQ+HfshkVmfOxKsu95zF7pdDvkE+1zEz9DmaMisRlaLTa0aZOVFV6vj4KP75A/8VuJuMsodSzwN/oKpRCztI8SjfVnT2AgdHcjnfDqIIFCvVV/F3bWDdgZYaiDpVjyS2jNuykNjpViVfu+FF82Bmb7LET3zsZzKhY6kNocAPTJred+lIQt9jYvPCmLNcHIya6GNlgGasb+F/aV560aGJS+ZEv7sxCHNlIzdOaz39aBVxeSz7x6y0S5wWT8rMoNnC+oRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eideticom.com; dmarc=pass action=none
 header.from=eideticom.com; dkim=pass header.d=eideticom.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=eideticcom.onmicrosoft.com; s=selector2-eideticcom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnTwolicnnInymMKrClDG9n1k3I6OVhSckQpWCajkCw=;
 b=U1e6dTRGGKrOkGaw/5XDaCcyrRh9KQeUIIikf0uxLM0hLF3Vy8mZebAvipw8Fh7AybUNPTV0yVBlVHVFuNky5V4FjFcUV05ESG64ac2sk7wTUt3q4/klmWPS0GmXUlMpSBXC65580uv1NohVF8W3J7Sov8Ic/wg3gYUmoBKAL9A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eideticom.com;
Received: from CY4PR19MB0071.namprd19.prod.outlook.com (2603:10b6:910:7b::19)
 by DM6PR19MB4325.namprd19.prod.outlook.com (2603:10b6:5:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Wed, 24 Aug
 2022 20:40:04 +0000
Received: from CY4PR19MB0071.namprd19.prod.outlook.com
 ([fe80::65ad:b7c8:1fe:422a]) by CY4PR19MB0071.namprd19.prod.outlook.com
 ([fe80::65ad:b7c8:1fe:422a%4]) with mapi id 15.20.5566.015; Wed, 24 Aug 2022
 20:40:04 +0000
Message-ID: <494eee73-5da3-55c9-c374-4166f0117288@eideticom.com>
Date:   Wed, 24 Aug 2022 14:40:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Python tests
Content-Language: en-US
To:     Coly Li <colyli@suse.de>,
        Lukasz Florczak <lukasz.florczak@linux.intel.com>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
References: <11ab82$jvatnj@fmsmga008-auth.fm.intel.com>
 <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
From:   Logan Gunthorpe <logan@eideticom.com>
In-Reply-To: <8C1AB1D5-54FD-406C-BBA3-509F669C9116@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MW4PR03CA0138.namprd03.prod.outlook.com
 (2603:10b6:303:8c::23) To CY4PR19MB0071.namprd19.prod.outlook.com
 (2603:10b6:910:7b::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f2d8854-5519-42bd-44b0-08da8610d272
X-MS-TrafficTypeDiagnostic: DM6PR19MB4325:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrgfXYOSw+prDBcDl+oc447g2uZ19qiYuoAUW97z21BgWhj7WkEVmKIOI2qYv8hGPhfRcEHNx3tbF+rb1MpGU8KaceJq5g0mQrW3S1igwu03U0A73MJoEI6DNQfIYy6WcExAgRZS0FTJ/bZuOq0Py23Hgw3qUygzWGXTN/NoRIYiyDKtEPDwDDiGCqICSw817nmRKRkpqeYzNAtO9VM8/UolLt9SaQGwSSCWl1Eypp4W9IvNROgDrrz34IiimqfRIbGnFBNlZLh35I74VGBNiuKdtkAcCsII3y8RqKQ32pWZnf3sEnZ6HUlxkwr9QkNetp0D9y+i/jWIip75zxfOxGpl00fEX10fquyxXoJLyO1otdjWmxHkhDxUFEKw1nHa9wXkl2rGwRTzzdqYX3YQiEdPXzziql7JwTmMz0zdeV7gfBxaNLjMEb6qxLQ0DEAgI5ecB1AssKfY7beg6gi07c0XqLcSsqkqWxGg+uKEtakVSoxNhk7gwQiYrWvQ37VkQWU/sBYnJfE+nNYnxUjxOQB6fviScuZs/8i820sQsOphJY8E/00IQg+r+CbnBEKc234HtoGdwx8K6bNNWGAAsagE0F7c4hLgcA8EvdAZyZvHoX+jwiP4bM9E3rgPKtCAs1pglpo5+JCkGclIclE5Q1IFE6LnjvQ+hSZFa5Qy7XguY4SeFAupGDM2a6RhIY4zLpy2An9mczvR535tSBmPCXPOMra3TMubUObkYCa/zJxMCd2qXi6JJC+8VxAWx37u+l+nm6DLXhacUC+CRl/hqZIl/VH0yx/q8A2h6FSd0x2s/eqPzytJ3eK72z42g3QD300H8LOEGLN8RrlYlawadA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR19MB0071.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(39830400003)(396003)(366004)(376002)(31686004)(66476007)(2906002)(2616005)(186003)(8676002)(66946007)(3480700007)(316002)(36756003)(8936002)(7116003)(4326008)(110136005)(66556008)(5660300002)(31696002)(26005)(6666004)(6512007)(53546011)(52116002)(6506007)(38100700002)(83380400001)(38350700002)(6486002)(478600001)(966005)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eWJnY0dhQ3pFYjJZeE1wLyt0dmdWQjVNY3RieU82SWlSZ3hJbytITUU2dmZ3?=
 =?utf-8?B?eiszb3EwOFZkZ1V3eTdoQU1veVhJY2NFM3FzSElPUFlnSTREK1g1akRCRGNX?=
 =?utf-8?B?c3M5cG9NbXc0WVFHY3NuNGlrVGxLWk1FWGR0WW1qTVRhNVFTVm1yNW8yZlBm?=
 =?utf-8?B?YjJxZGRVa01sa3FuemVLeExqYlpjdUtHMXdZY1crYUdoVkdpbEt2dk9aNnll?=
 =?utf-8?B?Z3ZHKzMvdlJwNU9ZODgyNUd3TUVtRmlNK2VMZTdlZm9FWGM4TU9rYk9jWFh4?=
 =?utf-8?B?NHZLQ3VscStIWk4rSlFtaTRCRHI1VjZpM1ZRRXRBUWFJR1RTenpUc1R2cmZC?=
 =?utf-8?B?QkVIaGxBcmlSNVNnVE55aUJwMjRWemt4M3VDd3ZYSW95cnlWM0FFYi8yek1G?=
 =?utf-8?B?YUJ5cnZQaFNaTHRtT016bTJRNGVXL3RyM0IxYUVUVkx3a1NNOGxVV2hxYVFz?=
 =?utf-8?B?dWN6M3hyZnQrdmlIZnFkMHRwVHlsblp3Rjh0Tjg0NHczQlRFNmg4V1ZzS2dO?=
 =?utf-8?B?cU0zVTVMNDI2R2FLQTRZTzVldFAxVGxpcmI0Y2FQN2gyUDZIeVVtc1daTmFj?=
 =?utf-8?B?MXN5WlNzYzMrMUtJMDRCTGZqWDllWmd1TDlwSEhUclplaWQyanA0OVI5WXVH?=
 =?utf-8?B?RVh2YnFsUzVsV0ZNQnVLZ3huMkFrZFhoYVZ4SmI4ZTRSWkpKY0dJSGhJQTdU?=
 =?utf-8?B?c1ZaMUowb3oxSEJKL2Z6ZzdkSG9zaVgxVTlaTXZvVzRHZHRYcnhLY2tQWUdT?=
 =?utf-8?B?WGRQMnhlaEZzV1dXempncjJDSVg3Y1VkdGlUS2swUTNKVStRbldFTUo0YkJQ?=
 =?utf-8?B?dGpNZGhaVHU2UGExWmJpYkdJcEk3cHZCOEVvTmxUZTJ3UXRQNFE1STRmUTVi?=
 =?utf-8?B?Sm5qV1hQd0svaW9HVHErWmFRYUZHb2x1emRtQ2w3OWI4d0FQamlidDZxZldP?=
 =?utf-8?B?VjV6QTZXc1BDbmI0ZDZhUEQwRU1yMGN0K3AwQzhFSjZFYUtqQjgxNVlRalUy?=
 =?utf-8?B?WHlwNXpXMlpCZVgyVzlDeE5tRFArZGlUS3pTakRYU0o0VVlsZENMOXh1N0g4?=
 =?utf-8?B?NTBRMXlkbUpLY0JuMW1PdDF0K25KYWZvcE9jRDQ5Rlp2bTNSOEg2UTNlNlhn?=
 =?utf-8?B?Yi9NaTlYMlNRNWpYV2p5czdGRWFIZkhpaE5uTHZ4M0tZYkFpVDZBVXVLRkxs?=
 =?utf-8?B?RDB5blpQeERXOXFzMDQwY3ZDaTcyMUoxaUpOdFp6cTkxR1oxamoveVVYZGw3?=
 =?utf-8?B?ME1mdDJqbVFjcWN6RkgxQWNUL3JjU3kyYVFXM0dxemhlbll4MjdVRk02a3Ns?=
 =?utf-8?B?TmlycDB2UGJ1OHUrdGZxaVJDaWJ6enhCL2hvbFl0anVMeGh0WjNVdEJHT09s?=
 =?utf-8?B?djlNR3FiNks4UzRYdmxGMVV0OExrUFJLRzBZeXNMY0ZBc2svVVJaZlhvYXlM?=
 =?utf-8?B?RkVQRmpzTXIwVmYrY29sc0h1VllSQVk3SkdOMml5WWJIcDJITkFGd3VrUDFG?=
 =?utf-8?B?cTc1ODNVbFRnUjNmSjhweWpNY2ZuU1F3UGo5ek5EdVU2clhvd0ZLcUpkZXdu?=
 =?utf-8?B?YjBWek9EYjk1Z1JQeGRBYXFyV3hMV0hlMWhzeFZFZmhFdG04cTdzSm1yWTZH?=
 =?utf-8?B?RmdRUFlvVUx3TjdrSWgyRC9LM0NlSCszekRHdFRCOCsxQndxNUZ6RnROTEJv?=
 =?utf-8?B?MjQ5MmoyL1VQYjYvaGhweTZpZEtKKy9MMTdQM0JRTWhWbXpmMm5wdzQra0tn?=
 =?utf-8?B?OHp2bEtGTXVhQTJhanBsckEvU0U1V0cwdkhQWmtmT1I2Vk9jUko3V2dZaEdN?=
 =?utf-8?B?eW02NHVWVEUybnlXcGVodmlLdHhKaFpQYS9aS2hoNmhxU0EzV291bFkxODkz?=
 =?utf-8?B?a2pSdUtVenBHWERDaS9LTUg1SWdMeDlxNmlBN3c4QTBzb3JTcXhUd3lUWmJa?=
 =?utf-8?B?NzZiSnhxSzlnUTRIc3VoT3RUdXJEVytrRFdPWlRVc3RXSFkyN0RrWGljU2dO?=
 =?utf-8?B?VVVkdHdNT2J3cjBkNHUwR2JhcVdHeXZwSmJRdzBHWDB3TG40WUdiWDFNYklt?=
 =?utf-8?B?cUFjOHRSb0t2eU1rYUV6Vmh4M0xpSWhxL25QUmZ2aXJBUk9SOUtwZklZUVhv?=
 =?utf-8?B?cjBJZENVSThvZ0phblo3N1lub3lRS3FYRWtXU2lhQVVkMisyd25wWnJFZ2hu?=
 =?utf-8?B?NXc9PQ==?=
X-OriginatorOrg: eideticom.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f2d8854-5519-42bd-44b0-08da8610d272
X-MS-Exchange-CrossTenant-AuthSource: CY4PR19MB0071.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2022 20:40:03.9336
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3490cd4b-0360-4377-abb1-15f8c5af8fc2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfyuJ20gfzUmQ49Eop6cfKcene5XVjPQCdUJYnK1evhIMQMJlAEcBGXAUx/5ZkbKIiJcj/0ixovq3laJQTWaVpbeE8oLmKM46NyGulNK5lg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR19MB4325
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 2022-08-24 10:23, Coly Li wrote:
> 
> 
>> 2022年8月24日 16:15，Lukasz Florczak <lukasz.florczak@linux.intel.com> 写道：
>>
>> Hi Coly,
>> I want to write some mdadm tests for assemblation and incremental
>> regarding duplicated array names in config and I'd like to do it in
>> python. I've seen that some time ago[1] you said that you could try to
>> integrate the python tests framework into the mdadm ci. I was wondering
>> how is it going? Do you need any help with this subject?
>>
>> Thanks,
>> Lukasz
>>
>> [1] https://marc.info/?l=linux-raid&m=165277539509464&w=2
> 
> Hi Lukasz,
> 
> Now I just make some of the existed mdadm test scripts running, which are copied from upstream mdadm. There won’t be any conflict for the python testing code between you and me, because now I am just studying Python again and not do any useful thing yet.
> 
> As I said if no one works on the testing framework, I will do it, but it may take time. How about posting out the python code once you make it, then let’s put it into mdadm-test to test mdadm-CI, and improve whole things step by step.
> 

I'm not sure if this is of use to anyone but we are very slowly growing
a testing framework written mostly in python. Its focused on raid5 at
the moment and still is a fairly sizable mess, but we've caught a lot of
bugs with it and continue to run it, clean it up and make improvements.

https://github.com/Eideticom/raid5-tests/

The 'md.py 'file provides a nice interface to setup an array based on
ram, loop or block devices and provides methods to degrade, recover or
grow the array. 'test3' does grow/degrade tests while running IO,
'test_all' runs all the tests with an array of different settings.

Feel free to use anything from it that you may find useful.

Logan


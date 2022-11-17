Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E5FC433FE
	for <linux-raid@archiver.kernel.org>; Thu, 17 Nov 2022 14:52:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbiKQOwD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 17 Nov 2022 09:52:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238685AbiKQOwA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 17 Nov 2022 09:52:00 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C065210FD6
        for <linux-raid@vger.kernel.org>; Thu, 17 Nov 2022 06:51:59 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AHEpBuZ017087;
        Thu, 17 Nov 2022 06:51:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=rZYZq8rvInF5HySdl+idAk6GhZ5Fb3Ts09NaMP+5lq0=;
 b=gsydNh00KONJSIf5kIIm72kiT1ciPzLEvqfSFI+wxdJ0cY2qAzAN4qRBjDzZXMaVkcnZ
 I1083BWj5Lu67tRBqAYkuBDsc21EB97ZvRWA6log358UwTvYkuJxdklFmoVuANY4zyT/
 vZ41rsacyh3jmjlUhzepDigOJGpm+EFQywmi+9m7r/0LqVHcShfypZBb7KMBC9FXjoah
 9P4qml3XtjBsAXXMwU6Wex57LI4vXsDNzvT6FC5bHHjHrSvROrgMptjJVgFymWiG/zqF
 FQ7QxgeT9/bUw0DoqCuBvNapbD+3aiYjzODF9J5QNK07KYOyV+dOHPfapPaT4+fRHOpB dg== 
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2045.outbound.protection.outlook.com [104.47.57.45])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3kwq34g03w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Nov 2022 06:51:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OItPijaI9OH+MIMQ8nwVspdFtdyN+QfsKALnQXXd881WLA61IFmRQBWN9DpZESKQc8ckPBvmhRxyqM/Bk0bYwBCo8/evSaT7gHBubzo2x/bwydQ3oHiEnn8Wq4Q6NIU3xX8z+lOtAWhqJOVF62xOolEGeITYT0W2ATR7hSa8+TaCv9e8xNL5k82JoaZfnZ0ff78Q480/2j9PkY3ZcJKqqh70IyNG8acRO88WxfDhTu7anPxvwaTwamP2H1ooo+72dypqugc2bVPthwZdYlr8v0Pax+XMwkilZIkXp1XolVvT89LucS8uketb4TlO07Q5X9xI8TfxM3y1oYefFTSA5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rZYZq8rvInF5HySdl+idAk6GhZ5Fb3Ts09NaMP+5lq0=;
 b=e+/IjUWV2bdWzF52WZmD59xU4LzszG4vxpSj++OUARJX6+O9DqEfyGvSenWQU4ymF0joLxZA7xhNggYqVGQLLNJ7o6msPKixHEaEgk7Vqh8qjIaYXD1PGqeGZkHMu3KospjDPJjBukTcGcUu/zlGxNMvUxLm6B/w8oHJ9sQVIOrnhiTvraCm9U/qA/fFO8rn6rTdeEpusV6NKSqDfJrSnUWOL1IEQBuozm738wRvwRcNP8K8exb2P15jU0HhFg5FLy7FJMC9uan5UoRG0ofoZNttUjvIPPRRkXZqAkLKRmqdzKzGNLGW1tNn5dLD6np3NsQ+Tsf29M9+ZAWuBWVKFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from PH0PR15MB5103.namprd15.prod.outlook.com (2603:10b6:510:c0::21)
 by DM6PR15MB3051.namprd15.prod.outlook.com (2603:10b6:5:141::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Thu, 17 Nov
 2022 14:51:40 +0000
Received: from PH0PR15MB5103.namprd15.prod.outlook.com
 ([fe80::b200:202d:12f2:2c27]) by PH0PR15MB5103.namprd15.prod.outlook.com
 ([fe80::b200:202d:12f2:2c27%9]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 14:51:40 +0000
Message-ID: <91bba138-8713-eb8a-015c-2bc6ba9b5dc2@meta.com>
Date:   Thu, 17 Nov 2022 09:51:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] mdadm: fix compilation failure on the x32 ABI
Content-Language: en-US
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Mikulas Patocka <mpatocka@redhat.com>
Cc:     NeilBrown <neilb@suse.de>, Jes Sorensen <jsorensen@fb.com>,
        Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Zdenek Kabelac <zkabelac@redhat.com>,
        linux-raid@vger.kernel.org, dm-devel@redhat.com
References: <alpine.LRH.2.21.2211040957470.19553@file01.intranet.prod.int.rdu2.redhat.com>
 <20221117152843.00002f30@linux.intel.com>
From:   Jes Sorensen <jsorensen@meta.com>
In-Reply-To: <20221117152843.00002f30@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR03CA0134.namprd03.prod.outlook.com
 (2603:10b6:208:32e::19) To PH0PR15MB5103.namprd15.prod.outlook.com
 (2603:10b6:510:c0::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR15MB5103:EE_|DM6PR15MB3051:EE_
X-MS-Office365-Filtering-Correlation-Id: fd4ece1a-7faf-48c3-30bc-08dac8ab3c2e
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wksIvE+1VTH6HVVLF+9/5WpztL9SKTOfqoUYZ7N7fIJArVMd9rH6g73jIYMAU85/7wW/KV5RMJC5Y/ivibebeYfhA7rbyrznJd+Bu6THgTWO9Oj38leiiQfvTkg7YRWZPcWQLqReKH47Zu6j4oJ8wB85739fsVjnNapH8oUXHD+jSRb1BUwvLE+Cj/2Tmtk0glZQQ226oxYeTz483ugzg5QJllyCiEHKfd57+lY9Rt3UGmNRZk3XJMR2E4W/PiST9HkXcsRf95Pc4AdIrUqDYI6gGF0SMGFu9WkVxgdfB6fpcGfHpIlghnDgVuZ5jPE+6kmc8dfePpQOI+t9L0ZvKQ9ectXkIpd0GEgeD1WAbcG2Z9ER3mLqh5pImH6QI9tONqBXPqTlLy7Z5lYN0zEBnOVOBprbF9LzVx01Lvl54oLfyZ/48fCArVVkWMmA5r0dQDkXQfB1GjFx/ELKEZTQbz+pIamCdJmmWsmKcx7T4Bn6adjLmSkw4siX3TdBQ4CTfbSF3lTBkaWWYJNih6CXUV9IBCZy7LLgaiFQql8FDhCw1Cy2VlZeYjUxHJ2mse5uE0292ruoGYznj/192QJjsXpWvBc4tbMqcAy0qr53np0NQgtNdYc2pxfzRJpWH2LKGZHDi1jQajmafI2HUUN2AxPmwBhzYcoaMg6PaoWtTv4OznYGc9X6OC56mdNMI5UL9uBjrUR+UcVnaJTUsf7T3PzTV53kooyoEqrEHpKibDszzb27Ai5PvXmEsA10EWxx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR15MB5103.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(451199015)(38100700002)(83380400001)(86362001)(66946007)(66476007)(5660300002)(4326008)(66556008)(31696002)(8676002)(41300700001)(110136005)(316002)(53546011)(8936002)(2906002)(6512007)(2616005)(6666004)(6486002)(54906003)(6506007)(478600001)(186003)(31686004)(36756003)(84970400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?emxXTGpjOTVpKzFRRmFYUEM1NW5ZcGVVYXFHcGpYQjVPNU1xZmozNmtoM3ho?=
 =?utf-8?B?MjNoZkRsblVrdi8yVDd5c1lnejdVR1ZnemdNZ01SMUJFdE9VNFM3c1NiU0JX?=
 =?utf-8?B?NXd1a0l4aTBlWG9Ga2RZT09Ib0hHbXZmWlhWdmVSN1FKenlqNzMvZnNaRnA3?=
 =?utf-8?B?TUVWUzNuaDYvUVk2Q3dSWnJoN3l4Q2ZwOXFxUGtsSW1ZT0RlbklramtyOXEy?=
 =?utf-8?B?MjdFT3VLWFQ5MkxZSUlBbitndVJUR3pWZ2ZyVE1DVE1lMFpONW55NklISkUw?=
 =?utf-8?B?Q3lLUkNDczZPMTd4VTJTQmlBQVdtQ0NiQ2h1Q0hSTTFyb1c4QmJCbEdmZFJl?=
 =?utf-8?B?c0gxdlRYNVIyS0t3b1d4SWE1SlQzR0h6VmhEbVFIVERTMUtmSVNZbVZwUVlp?=
 =?utf-8?B?Ti8xZkVSR0NNZGJxVjJYazFxai9DZER0TTliRzZ5b3FGQ3J0T3hEUzFIcG9w?=
 =?utf-8?B?T0RkaWlFbmM4TkpWSEJUTnI5OFEzeEpOVGE2RzI4KzR0a1ZNdTRpbGZiZlNQ?=
 =?utf-8?B?M0FZY0dhWjFWNklKNmR0ZngyN2NYcWpuVC9IWDlMYko4b1QvTCtUN0FBRWZI?=
 =?utf-8?B?QkxqNXVOUUx6RUVhWVZWdDVKL2ZpRmtBTXJjTzArRlhLWlo4L2xmSWtza3p5?=
 =?utf-8?B?SFFNUldvODJsWDYveHdwWkJ4U014WXFCVUdIUGFaVGtMQm5FaGdmajVDWmkz?=
 =?utf-8?B?LzJLUnVYZlhQajJZMk1JZG1mcy80MWdwSm1OUzcvclpLWURRcXJkNnBVZkY5?=
 =?utf-8?B?NVRvaFF0bUxSZWk1WHdaallZY3N3VDNsVDNsakVDdVFEUy94bGFUK3JHcW5k?=
 =?utf-8?B?RXZ2SGxESEJGMlFWdjFMOG9ldWlRSzZNZnA0bkY4aHdyRnFIYWpQbEM0aG8x?=
 =?utf-8?B?dzcrMGJsN3hScFo5WHZFYUI5bTJPS0ticDFpcXBYamZwK3o1TlB4SmYvUjdS?=
 =?utf-8?B?VS9zMWo4UU8zMEppY25TUHBydVdtVWVHZGU2UXRRNHJ3TlZwQ1Rscjl2UTQ3?=
 =?utf-8?B?ZkFFbDdoQ1I5amhVTkN3MTM1SzhlbnZPZlNxeGVuQ1ZTeVBaSGlmRDg1U21T?=
 =?utf-8?B?d2FWdk90VlVTT0VQQVVleWtPek9WMVkzM0Yxbnkxdi96TlFrRXRBYjJ1WU1F?=
 =?utf-8?B?NTJlajhyTWlHRFgyMm1TYmQydUJMaFNhc25BVmxFVHV4bFdXUUlhc2JSb0cr?=
 =?utf-8?B?em1IL2UxZzFTVEk3VTc0TE5ENHNqdGtnWXFWdFNMcU5TZ1B5K0dpTm1XS3lq?=
 =?utf-8?B?dXUrTWZMaXU4QkRqRHdpbGtOR0RPa09pU3pPMzRIN2h5U3VScVUweGhpYXgz?=
 =?utf-8?B?N09PYXh3R0dmaVpmMWNZTTlrVTFzZ1ltOUUrVGNWalhrYTJ0ZDRBT0k5eDJl?=
 =?utf-8?B?SnV3TXduRWVvUUJ6VDJScW9WUVl1ektob2xtWGpxSzdhaVFzcTVjbUVON0V4?=
 =?utf-8?B?MHB5RVFaNytEb01udit1L0J1Z2pqVDdic1pkWHRPZVlSVmtFZzJ2bk1wRE5F?=
 =?utf-8?B?VXJqR3Y5azRxemhIUjNDQXB3UkdJeVB0MjZrY1Z2U24vRkx0VUppblI0bGNN?=
 =?utf-8?B?ZXA3UG9DcnV6eG1qT0lWSUtrbmZoTFYwV2JKVzFoRUZxWTJvZXJ5R2FrVW9k?=
 =?utf-8?B?K05SbzNoUkFUMWFhOXdZM1RPWitKRWNHWW5VMGJjWHlyRWNOYzRTWDdxSjBt?=
 =?utf-8?B?OWRSMXRkN21FWlUxMzZhZ3BPRm9zRG9NQmZySFJKQmNmcGNGbmM3Z0dpRDJh?=
 =?utf-8?B?UUhDQWlOTXVjRXVrcVd6dytqdmxBTlZSejRJSE8zdUd2Ty9sT3VzTTNhV21X?=
 =?utf-8?B?aC9PR25vSXoyak4vZXpsc1NGMUhnVFY5WHhuQkY2anNWanU4K2Mwd2hJcnB6?=
 =?utf-8?B?U1RIWkZCb3ljUFVrRFp4S1NKdXEwQTBUbUxXN0JUSkZkY1VYcFkyMnA0bXFj?=
 =?utf-8?B?Zk9RQTdYeGdVL0s5Z3VaL0Q2azNVbm1HVHlFSG9xcHo2bFExQXBKZ204alI1?=
 =?utf-8?B?bElMK2V6TlMwR0hKZXcwN2FLY3d3QVBwL2huRU85OHVUMFFaaVBwUk1qb0pZ?=
 =?utf-8?B?eWxnaUQ1Ky8yVFVoQVJhMmJ5REp5Szdkb2tpTmU0RTA4TXJJUGJiR0FXKzl1?=
 =?utf-8?B?QVBDZmp0N1RFc3VHYTZMbXFoa2RHMHlEWkpPQ1lLSG8xVTJjczJhaG1kUndV?=
 =?utf-8?B?dWc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd4ece1a-7faf-48c3-30bc-08dac8ab3c2e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR15MB5103.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 14:51:40.3468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Es02O5zJb6173Q2DGGpLV+uHY61uj46fHqzQlUHlBTZzCWMnfF2e6fof3dmNS0qjNMZHlBlqdO9AAqrHXd0mKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB3051
X-Proofpoint-ORIG-GUID: b6G08ryf3o08-ibyUS-pPxFbWC8hvmIQ
X-Proofpoint-GUID: b6G08ryf3o08-ibyUS-pPxFbWC8hvmIQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-17_06,2022-11-17_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/17/22 09:28, Mariusz Tkaczyk wrote:
> On Fri, 4 Nov 2022 10:01:22 -0400 (EDT)
> Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> Hi
>>
>> Here I'm sending a patch for the mdadm utility. It fixes compile failure 
>> on the x32 ABI.
>>
>> Mikulas
>>
>>
>> From: Mikulas Patocka <mpatocka@redhat.com>
>>
>> The x32 ABI has 32-bit long and 64-bit time_t. Consequently, it reports 
>> printf arguments mismatch when attempting to print time using the "%ld" 
>> format specifier.
>>
>> Fix this by converting times to long long and using %lld when printing
>> them.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>>
>> ---
>>  monitor.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> Index: mdadm/monitor.c
>> ===================================================================
>> --- mdadm.orig/monitor.c	2022-11-04 14:25:52.000000000 +0100
>> +++ mdadm/monitor.c	2022-11-04 14:28:05.000000000 +0100
>> @@ -449,9 +449,9 @@ static int read_and_act(struct active_ar
>>  	}
>>  
>>  	gettimeofday(&tv, NULL);
>> -	dprintf("(%d): %ld.%06ld state:%s prev:%s action:%s prev: %s
>> start:%llu\n",
>> +	dprintf("(%d): %lld.%06lld state:%s prev:%s action:%s prev: %s
>> start:%llu\n", a->info.container_member,
>> -		tv.tv_sec, tv.tv_usec,
>> +		(long long)tv.tv_sec, (long long)tv.tv_usec,
>>  		array_states[a->curr_state],
>>  		array_states[a->prev_state],
>>  		sync_actions[a->curr_action],
>>
> Hi Mikulas,
> This is just a debug log in mdmon, feel free to remove the time totally.

I second this! :)

Jes



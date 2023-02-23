Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FEAC61DA4
	for <linux-raid@archiver.kernel.org>; Thu, 23 Feb 2023 23:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbjBWXud (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 23 Feb 2023 18:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjBWXuc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 23 Feb 2023 18:50:32 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2083.outbound.protection.outlook.com [40.107.7.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AEE51FB3
        for <linux-raid@vger.kernel.org>; Thu, 23 Feb 2023 15:50:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlopEVpbDMGRflkjcmcLG4+O7rrpzRpoYPrZ7lLKLmWQ6C5xqLU/d9siBqMaYZ4/XIX8tT5vMGo2GitSRJ3kbUyU6j00buGoXD37QIrefflj/4eoIZpX65wxrLCLb1W5HWp/f+CIl2e3r3SNa7QtM2pqbPiYfSSiuphFcc0lWfiiuCOjRtiGpIe57JHUrgMMOJNlhqe6e9gd9GF61LU5k+DmK4oXBq0HYCuOAadNMb0rRkHByC2cMO6orZyN4MQedM3ZYr9aTS1UifmWWuP9ktKTvmivIZJ4ZnZJpWThb8i+hT648TlJlAQCT4c/wekypBYFX2IeoPvy6nTnCmgrnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmN+CJ6QGxB2cOQFfe4ry6jjYl60FN1lSYJc4x09Ej0=;
 b=ghrdfQshwkzr8lpxWiYaxyF3Or/FUr/ArroNSgTNSC7gdZ9BKGqRD5zj7SyZD+ybNiTCMevE58ol+oT1zLV0J4OffdOmixZNSfXIOYPnvjFqdtdtiPvoVmmEJDZQTwTE4GGZcONy7wXbeDA4h3zQVonAJlIiww8IGsiJiPjM8Exc/jLvQfOtMVxW2ycr5e01F3keymX03eiUP/2eaU8yaGQaAsJCuYWL2jXebSYNYLV84if6tgOqUZ7qPOXHSRTDl1wlUKcitHkQta9Ib0SOeyVDMAMM8I48Cf4FbSzcmjf1N0IoHVzIStp5B2Y/uSJU9fRCjD88KSP5+w8SbgllZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmN+CJ6QGxB2cOQFfe4ry6jjYl60FN1lSYJc4x09Ej0=;
 b=DclM95/pzqlhjrwPP/5dH80pP53AQkJA+laHVTLmTqu4idIFJt4nZ1bNroQbbIAI/RQubjG19EAZ1nNui/pv9bRneEkePf9701SIXQ2qrUfHmh8ibZCIuUpcAV9nYdtgOOSSTOTtTsM63GNFvdJUoE7rkawHlrTMesALkeMD1XNmNKYfQM9qy8Qq+MfQwViGjl9N7ZIvZwgsnXyODO+4v4OeFZdPoT/lldYdjfA5osVUGVcyjXO/A5wtx5SKNT+2ZGae404Admq8CuvnI+ZeJ9v0yD+MJ2nIpXqI0UI8/uQpS6eYOxsZ7geHz0j2Hw7Q+c834713pADR8Z+GG1Nllw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com (2603:10a6:102:c9::6)
 by AM9PR04MB8082.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.24; Thu, 23 Feb
 2023 23:50:27 +0000
Received: from PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a]) by PA4PR04MB7997.eurprd04.prod.outlook.com
 ([fe80::8b1a:ccfc:b5e:4b4a%9]) with mapi id 15.20.6134.019; Thu, 23 Feb 2023
 23:50:27 +0000
Subject: Re: [PATCH] Grow: fix can't change bitmap type from none to
 clustered.
To:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        ncroxon@redhat.com
Cc:     colyli@suse.de, pmenzel@molgen.mpg.de
References: <20230223143939.3817-1-heming.zhao@suse.com>
 <dc887716-1b95-709d-07b1-fe0c6ddbcfe0@trained-monkey.org>
From:   Heming Zhao <heming.zhao@suse.com>
Message-ID: <5e5b885a-b77c-0d5a-d41f-0cb3cd0d33d9@suse.com>
Date:   Fri, 24 Feb 2023 07:50:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <dc887716-1b95-709d-07b1-fe0c6ddbcfe0@trained-monkey.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0051.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::6) To PA4PR04MB7997.eurprd04.prod.outlook.com
 (2603:10a6:102:c9::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7997:EE_|AM9PR04MB8082:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a17a840-e4ce-4a61-3dbf-08db15f8bd30
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SDujc7kHLn22G4digBmVdRmVEvaOv+7BV653v1ieXkSHfrfMDHCAeGkvR3zWuFWRPSrBbIBmViFlJzhnRKz+vSQn2DkoBUN5NcvitHFTLg2rZX9/8+lJ4PxirdqkqnplMrirvE/L1ImWEZUCaSip6++Pupmx01n03okodo7Z/MUTYtxTe+NE2NiuAy9o8MP9I5j35EamJe/AIeAfhBi1t9euLm47YJ9fokjLqr8VE5gy2Lkoy6P36Rkxtlwpfr03XCadciM54RUNd42Zu0z+XAjcbT8jNrdXAiwqUCfi9Z1rzfG77YowdsxJ92SOUElh/yse3JAiDSOpRjjwKb5CQxykrOqrqnbSEbS6fT8yag4QyqgdnkY6IOAQRenJ8LWSR018hNaBjBHxn+y/fEO8X4h5VjTjzZcFJ6vooJrhCV5yBOnP962LYzdpg8Kt00wWDM/G6esaVTtx+j+7OFDASXwoLoXlFSAmyza0LVcr+oVaEWoYnTGo87PHZ+yF6C9pridNb3ZqH7ydILDtyslATd31uJ+FuaXsrAnbf83iX1fPPPRdZiHhC5eCac8DPnMYOrUJife5aRnbii2chAuSToH+FHrILp2x69j4CaTBpWJeTwWBgZR7Fo17v5UqlSpu8u0/shWgORjFJ5dKfqZDQzp/r4KTihbxCT3gBEUSeYsYcZDvlCuqNzPb3xDPpI5nR5lx1Tm4GLnWTrdbNenb4y3Qrv5wloSPFQSDv3SU8SY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7997.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(186003)(26005)(5660300002)(41300700001)(31686004)(8936002)(8676002)(4326008)(66476007)(66556008)(66946007)(31696002)(44832011)(86362001)(6486002)(2906002)(6512007)(6506007)(53546011)(2616005)(316002)(478600001)(38100700002)(36756003)(6666004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZWVTVDBmTVkvQ3dYV0tMc3huYWpKZGhLRitsQzRVbkdQQnhmZ0Npdkx2cUdu?=
 =?utf-8?B?MHRET0o4SmpoOUQ5b0Z2eG1GUklYa211RGtDQm5WOVMxZ2M0V05mZUNlSW5J?=
 =?utf-8?B?MmRBdjVyaE9KbFZiWWRmOTJjVXZuYlZTdytlRWpycGU1ZGtpUXVOVEwyc25J?=
 =?utf-8?B?RjhvQ3loT3JySmY5bnljTStTb3Bza3Fidk03SDZ4QWVoYXpmaVN0Y1ZvSGYy?=
 =?utf-8?B?eVArN1RUWlRhbkZlY1RPWUYyV3YvTkEwWG9xZnVOWDByVFA0NEtkMGNjUUNq?=
 =?utf-8?B?Y2pyaE5waWZoOWM0bUxXL0RqUFdZRkVGVEFJZ1grQWRHMG56S1RvTStKSmsr?=
 =?utf-8?B?NWtRWi9NcEYraVRmV21QQjdZTWpmaUJFRmd0ZzZ6NE1mKzlIZmtSZXhkYlNo?=
 =?utf-8?B?dmlSNW9UQ0xxNE1pMVlXR0hPRkxqSVhOdmlMT0hTcXJ2d2dVMm8yQ0QraE0v?=
 =?utf-8?B?Q0NZY25USXQyVm9rOVVqZ2lRb2VnZVFnM0FIYWcxL3FaaFRIQ2gvcTdkWUFz?=
 =?utf-8?B?a2FoQUFkdmwwSmI1MklsNmNSS0tmeE5KbUdBZ1llSVFrUlZ6c00yZVc1QXVD?=
 =?utf-8?B?VGlFaFkwWk1BY1IzWHZMOXNtME9vTWtUNVNpbHorVDV4WHlYQW5BMng5bWxZ?=
 =?utf-8?B?SFMzRW41dWE5ZG1mUHphTHJJdkNWVERZTG5YVzNPNEJyVTlma0VIU2hZcmJB?=
 =?utf-8?B?TFBjSXhuZXg1UWNqT3NUSlVGcHova21LYk1kYVBWOUtMZ2o2c2xhUm92VWEw?=
 =?utf-8?B?Y2Zod0dObWc1cE1GMlZJM2pjY0cxWXoreUJMaFNxd1IvTjd5M0Q4ZGE3QTZk?=
 =?utf-8?B?Tkw5ZmpRLzdrWU15RnRNMTRlZFhtN3c2L3QrN3JmZzV1QVVnd2ZueFRKdm9E?=
 =?utf-8?B?c2NMTzZTWEh4d1dJb3lXVzhuaGlKcDVzZWhEWUp6Q2V4NWhRekJBY21LZ1Jp?=
 =?utf-8?B?RlExT3p1WThhdGRkQmZDMUVNN0syOGVOZHJDMVFHWlN3YVZPSkxSZFZraDhK?=
 =?utf-8?B?bytWcjNoblhWSWJialBDdDcwNUttdk1SWVVZRVRYc1dlbmxmZDE0UXc1Y3pm?=
 =?utf-8?B?b1lrSGMzYmFramFDMzFRQkJtTVY0bFV3YjBMSHRmNWRDK2RCbDlaWHIrOVRo?=
 =?utf-8?B?NWpwY2xneUJoazREZFFEYW1xWXh5WktUdnRkSzh6bWZrZTFTdXBxdkZRNTBM?=
 =?utf-8?B?L2tjeXhaWmE3bW9IQnN0eC8wZ242TUxHSDd4S1pDS1ZLNFJNYklrY3R4LzlZ?=
 =?utf-8?B?alNiMDBOSzFoSmdqOWl2ckhwV3RpT2VCalVwd3JvVkxPWHh3d3IzYnltYmVs?=
 =?utf-8?B?ZlZ5cXp1UEZudjNIajVJVHJZbE1Jam5uQXZIOVRWRmlKR1V1dlhrVC8wemky?=
 =?utf-8?B?ZlB2eEpNRnpvUStaQUppL2xEdENCVk82SjUzZzNqM1NPZ1BkeTk1K3N5R0NC?=
 =?utf-8?B?VXNzWExzUjRzVk15cms5LzhBcmoyaEkvNVk2WW9xckVLL1BmaGdYZ3NJSUl0?=
 =?utf-8?B?ZVBBY2J5UDhaWkpEM1FuS2lBNGladlFzd1laSXZISU1vcjVuR1VxaThqM0ZG?=
 =?utf-8?B?WTRQR1ZDM1hJM3NRd2JFUlRXWUpwa0hBekM1S0hBMWxvTjI2b21HUGRUL0hH?=
 =?utf-8?B?Q0NybHFydllrTkE3ODZsVks4b1FKVXRrR0lBeVNzU1d4ZE8wK2FvczdLVmdv?=
 =?utf-8?B?RDJiZnpybVFBbVcxZEZoRU03K0FWRDR5QWEwd3ZxV2dWckhrMEFHa25jTkNR?=
 =?utf-8?B?ZFEydmdWSW4zd05oN0VldWNpSWxkNDk5Y0hFVHZZSysxbnpBVzhoV1VqOEhB?=
 =?utf-8?B?dytVcVpYUGMrUGx1MUlEdXNJSStyM2VkRklzUVVpcC9hTGRSUHdhOWFJRXFC?=
 =?utf-8?B?aHRwV3JLazVaalpzRGg0SlZMaXJpYzFOOUswcmgvSTRNWFBtYmZpdXdtVkl1?=
 =?utf-8?B?OFp3b2JsRXpPZEk0NFdvR1cxTGNxY20rK0hrMEF6Y1pIdzk5WERHaXFSMTVa?=
 =?utf-8?B?SFU3V3lBRGF0eFRwT3NhUXNLTzh2ODZabFEwdnAyMUlGeFJFL3BTK1I4dThX?=
 =?utf-8?B?NUlXQjB3cnVlUTA3MnhVYzJkRDE5K0JnSktOc0VRb1lXdzdzNVVTSkd1Wk5F?=
 =?utf-8?Q?StkCIh1zI3Sk58Sg4DAjKOWko?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a17a840-e4ce-4a61-3dbf-08db15f8bd30
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7997.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 23:50:27.4434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p8Pu2hx6PryPyHADYLKVFA+2+onpXbc5WiK6qei24LGMnatFdQtMjUm0WV/95xFDsCJRGCux1J2xPqrgMs0RMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8082
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hello Jes,

On 2/24/23 2:23 AM, Jes Sorensen wrote:
> On 2/23/23 09:39, Heming Zhao wrote:
>> Commit a042210648ed ("disallow create or grow clustered bitmap with
>> writemostly set") introduced this bug. We should use 'true' logic not
>> '== 0' to deny setting up clustered array under WRITEMOSTLY condition.
>>
>> How to trigger
>>
>> ```
>> ~/mdadm # ./mdadm -Ss && ./mdadm --zero-superblock /dev/sd{a,b}
>> ~/mdadm # ./mdadm -C /dev/md0 -l mirror -b clustered -e 1.2 -n 2 \
>> /dev/sda /dev/sdb --assume-clean
>> mdadm: array /dev/md0 started.
>> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=none
>> ~/mdadm # ./mdadm --grow /dev/md0 --bitmap=clustered
>> mdadm: /dev/md0 disks marked write-mostly are not supported with clustered bitmap
>> ```
>>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> 
> Applied!
> 
> Thanks,
> Jes
> 

With Paul Menzel comment, I will remove the dot/period in patch subject then
send a v2.

------------------
@Nigel Croxon or other people

Yesterday my brain only focused on fixing bug, no thinking the a042210648ed
use case. Why or what reason makes the rule for clustered array denies to use
write-mostly disk?
I could image a scenario to use write-mostly disk. In cloud env, VMs have two
legs, one is local shared disk for speed up IOs, another is remote shared disk
(e.g: JBD) for back up. If anyone think this scenario makes sense, the best
solution is to revert a042210648ed.

Thanks,
Heming

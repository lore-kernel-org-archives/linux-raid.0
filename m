Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3355DC433C1
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 08:29:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9B066157F
	for <linux-raid@archiver.kernel.org>; Tue, 30 Mar 2021 08:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhC3I3N (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 30 Mar 2021 04:29:13 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:30679 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231481AbhC3I2x (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 30 Mar 2021 04:28:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617092932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r0EMWIV8cd0nPp3tgF5S/iBz6x2K6j67XaiQj5EfHFo=;
        b=M/EGXJZl6jynTveNSRGafuNXsuDYjzOvgbQKL4lmcurWotyaM+U0AyMM5BrtOzFN2oMr79
        1iYjoMuhvlYOfv6onQVLctbO0YKJFyYuRl2nCEcai43WIWXObmtbEoSKsNTNPsIJtlTiAM
        O020nPCvNzHBQuI5pSuBiCvLWk7Zwt8=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2058.outbound.protection.outlook.com [104.47.1.58]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-35-EYIAFHq5M72nMU2X4gfsNg-1; Tue, 30 Mar 2021 10:28:51 +0200
X-MC-Unique: EYIAFHq5M72nMU2X4gfsNg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F1pcr3x/WM2m1x7LN9LF2JPvMZ5l4lDX91XOadsm7ztSf4ElbePje8w+BpkAxIqZ34jmG6o158CN+MVG1R6UXEZH/+OcNccBGPT+l6A4rio+I5Wy5qU4z1F5lYh9K5Sf1luqyziPSUyXE2S0imPB4n71VrSCUuffEeNl7a4z6cUTXSVauOHX4sePvSxM2Ee5QegyIR3Fjtyny+r6FdscZJI2UXBFdMTVxqaGi0KhyBHbYfL6/tkB6m+iFeT1D5Tfv/T5gyj+UIbntOpBqrPH8P31+xHIWjbrCyDPOQQssSfrR8B1LOdfO5TvUT8zAS/dAYLVDv0AsOqtEvUy5MbJ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r0EMWIV8cd0nPp3tgF5S/iBz6x2K6j67XaiQj5EfHFo=;
 b=PpL0Rf4sjGAXMpIWmTTVh6Y9EA2CP8/LTdjJGfZ0xxKLVavMjndyMjIuC+Go9KAHjM5VuwcsI9+3pN3lq5d5UBBO0SFXOuJfhcOPwL3lYpm1qx6vz4WeljeJ4s8hvLe0EWPQ2YYxW5M77Ia8uRsqBMbYf/080LcNfoz9Z/tKrj8FK/FICO0Gv5Lr0672+zFOLsMphxMagMvDxx2jr6+shcOaiC1xbATgk1CPturLSzfz8ERDCGydQwNTivvTBQCL5+05gx6mGYUwA685DVGNeX0cV7zqMM8bdLfwm/bIDWrQ+ClPx162Vv0RrmftueobaJ89OqCf0sTsTavEbha7ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB8PR04MB6908.eurprd04.prod.outlook.com (2603:10a6:10:116::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3977.24; Tue, 30 Mar 2021 08:28:49 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 08:28:49 +0000
Subject: Re: [PATCH] md: don't create mddev in md_open
To:     linux-raid@vger.kernel.org, song@kernel.org
Cc:     guoqing.jiang@cloud.ionos.com, lidong.zhong@suse.com,
        xni@redhat.com, neilb@suse.de, colyli@suse.com
References: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <159d5840-836e-b85e-5b72-d152e4bfc608@suse.com>
Date:   Tue, 30 Mar 2021 16:28:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <1617090209-18648-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [123.123.128.150]
X-ClientProxiedBy: HK2PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:202:2::29) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.128.150) by HK2PR0401CA0019.apcprd04.prod.outlook.com (2603:1096:202:2::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26 via Frontend Transport; Tue, 30 Mar 2021 08:28:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 582174f0-ed1d-4fc8-25f7-08d8f355d7a5
X-MS-TrafficTypeDiagnostic: DB8PR04MB6908:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB8PR04MB6908AE084475D012A2815BAA977D9@DB8PR04MB6908.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:989;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: elQkMB8fIVtjrX0bF5InPCuz0p1vQlje70/TR3tS11UnjF8ouH7Z9emIxx3Og3tqgxofNo0LuMbwYvJ+yu3X4ZIOHzLFaT/LKdVfZtenYbwjiAz22GYsXw00JfWjIpP6H+Mb5nAYYbWLEniSSXUnVX22QMkJWnn4oAP7Aj1l60/WdRLV9xEP3tv6gb2YWvUtdY+QM0Ghf4e9vvcMDJHLZCO435Vh7LE0VP63/QSge4GXnUMgH1+7jPL0kfuWceLVAZJ9NTICFLtY9afko/kvsipSp4UZlel0tq8qDpFfRidqKWYGJcfutG//JjIieydSwe7YCq0vISNw69M8vzWZfQxAS/5hqzvl7ec2dgF0s/3wEZ/ylseWKPfa/IjlvBwGzplhD5qJCRE+JADTN6Mj+EsJWVsonfXFK2HLm0F8H84+Qwu7SOHmwRsAxKdTxSm6gt7xcRO66iUcuuywxs1aFA8Mw3Knp0AXUIh368XmtF3Y5ydp9Ts8gZY+MyQyh9FlNBt/u4MZGGNTUeaFc2RBEFGopdBxESsbZLwCejLhR/RC/PeBrB+yCfe6OpWQp0QqzFkNARBkEYXjreoAB0nXC739gIweQZTL1jIwr58NLVHnUh0yiEL0dzIZjfysajSSpCEt7siNuV9ucBFfWgkLV4k/kgUccDme2K8zGhHiBOJ70Lndf144IGNyiHhOGPNC8oKAOYas52VF6XRxhMmS7mDcp0ThaHIHcGS6BB+n9T8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39850400004)(136003)(376002)(346002)(36756003)(478600001)(31696002)(52116002)(6486002)(8886007)(53546011)(38100700001)(66556008)(6506007)(66946007)(86362001)(6512007)(2906002)(66476007)(16526019)(8936002)(6666004)(2616005)(316002)(26005)(8676002)(956004)(186003)(5660300002)(4326008)(107886003)(83380400001)(31686004)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UWdFZUI2K1NQcmlxUHAreWxNcXMvbWdvVHlNd2hmTWdqSThEQVNHSU1QaUJF?=
 =?utf-8?B?YnFIVS96OWNBQy9PRVExeGF0K1c0bEkxaGxua3FvcHJzMUtLWkxrZnVyOTM1?=
 =?utf-8?B?cGt0QVNPa1ZCVkx1Wll2SUZPWWYveHlIcWNTdUVYemVsVFVoS2h0QzJNZlpq?=
 =?utf-8?B?Q0lSbzJKSTRxcG5hNkxnTUcyMnFJcDJ1ZEpjbGF5QUpzMndZT1QwaDB0YXI5?=
 =?utf-8?B?NWhLYTV5aTliclc4TlBxeTFpY2R6Y0lZY3lYdVpRTFNlUW44ZVVvZ1RxNnF2?=
 =?utf-8?B?OW1hUjhyOTE1engwaTBHSVhXM2h2TTVVaTVzNi9waXNBQVRXQlZuZlhDRmVh?=
 =?utf-8?B?c2JPQWIxQlJrTmFZTVpZaXV2dVRSeUsrVTh3VjJZMFhpVlBoUExPa3Z1UkZm?=
 =?utf-8?B?RzZ2bEVXd0l4ZmpnZS9HOWxlNVNtTitJVGVJVGJBSFNJWHJhMFdwR1h0REdu?=
 =?utf-8?B?U3NtS1kxSi85NzRZLzhVcWVFT0MwL2gzRElyZ1pZNUgrNXF5VjZyUUNHYXdH?=
 =?utf-8?B?c2k3a1NYN290dkpXSXZCRE0zWmJxQSs5TStHcTlyUFNFcUJMV1ZKOGZHNVU0?=
 =?utf-8?B?OUhZeVRtOUxOTE80UFgzSXhhdDY4V3pycnN4Yy9rYmE5UE1QUUUxWWtmcWRN?=
 =?utf-8?B?cDBQNGJYQ2I4RnlSQk9tOFQyK3FINzc4YUdDMmlvRTB3aE5iU1owN0dZU0M2?=
 =?utf-8?B?c3BaaWplemhRM2wrai9TdEU0c1llMDJjQytmNmpzcUJMSHZjK2JNZGhIT1JB?=
 =?utf-8?B?VVRIbjdZc242ZVdHLzdiL295dnROdDNJNEkvZFdlWGQ2WDYzU0xINUU4bm1P?=
 =?utf-8?B?WUdIb05wa0c2Z3M3ZEgwSk9RQnNFTHVYVFpIQ1BJQXRmdFNuc08vRXBwUHJF?=
 =?utf-8?B?aTNIYi9JL0FiNllpb3BZQXZ1Rkl6dmtPVHdYOVZiWkMyelNweW1pZEorUkcx?=
 =?utf-8?B?R3NGbE8xbHArYkZ5cHI1d0h0Vk84dWZLbE14WDE0dUJMRlpPeFFmLzhWMTlJ?=
 =?utf-8?B?MXA3NTQ4Q0lYRlc5b3dMclVFUlBFb0xvWm1OczN4dk1sOWh1WndDNHNocmZI?=
 =?utf-8?B?Rjc3MkY5d1NrMTlmbExPME1JL004NlUyZ1k3aTczRnZyM3FPQmdhYW02em5l?=
 =?utf-8?B?KzNzVVlVR2dYWFdhV2JhcFJvOSt2Rm1SMUw3ZDhmTGY0d1pDVlBqRzk0NXYz?=
 =?utf-8?B?WCsxMTczekN0YVluQWRhUWNsWVFaY3I2TmlNWUZYTFZaeG9NcDdhRDh4Rkl6?=
 =?utf-8?B?MHBwZnJrdERTajNqUUN5RTJZcjhJWVF3NzYwTEM0UEVtTkRoendYZld4aHRi?=
 =?utf-8?B?ZDB5SkU5Tm1lNW9uZS9keE4rdk5lWTZZMGhDWnlOU2NnNlhTWHUydzRpV1Ur?=
 =?utf-8?B?b0MxWTNZTjZKR3ZKV0RRdEpGT25zZUc1OEg3ZW1Jc3dWM3kxNlcyQk1wb0I5?=
 =?utf-8?B?Q0dFaUdnVlh6aTJRYjVNWHJiREQwZmFPLytibEVPVHlHNHJ3MDNDZ1B6cE9C?=
 =?utf-8?B?cFBERUFEclBzbEFXQ2Z1RDlETGdyTE4ydTN5Qm1VNENSM1pLc3R0UnZ3ck8r?=
 =?utf-8?B?VUR0M0lITnhhaHU1My9oQ0lGTVFNTEV2N1dBQzhoZnF2REVNZCt1c2tEYUp0?=
 =?utf-8?B?NVBTQWZ2VGdvTHFHNGg1VnRCSWhkRjBNYXNEdEFmSlFrRXc2NkRIc2pLV3hO?=
 =?utf-8?B?OHptbGJERnhoVG9hNGhFTUNzUEc3R3o2NHk0UGFZMlRDVzNpNEhwc0FQelVz?=
 =?utf-8?Q?F+rQ+cgE35CDWWUV0p8IMLVobEugQ5Sw17YJAj9?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 582174f0-ed1d-4fc8-25f7-08d8f355d7a5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 08:28:49.1907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /mR/QxwFZ0qsJ3tZB73bGmpB21KGXmRd6M6/C0oBr676oLgK1rmlVdM6DInZu+3Pt2+9+/3g7IskMHk4pbLQfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6908
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/30/21 3:43 PM, Zhao Heming wrote:
> commit d3374825ce57 ("md: make devices disappear when they are no longer
> needed.") introduced protection between mddev creating & removing. The
> md_open shouldn't create mddev when all_mddevs list doesn't contain
> mddev. With currently code logic, there will be very easy to trigger
> soft lockup in non-preempt env.
> 
> *** env ***
> kvm-qemu VM 2C1G with 2 iscsi luns
> kernel should be non-preempt
> 
> *** script ***
> 
> about trigger 1 time with 10 tests
> 
> ```
> 1  node1="15sp3-mdcluster1"
> 2  node2="15sp3-mdcluster2"
> 3
> 4  mdadm -Ss
> 5  ssh ${node2} "mdadm -Ss"
> 6  wipefs -a /dev/sda /dev/sdb
> 7  mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda \
>     /dev/sdb --assume-clean
> 8
> 9  for i in {1..100}; do
> 10    echo ==== $i ====;
> 11
> 12    echo "test  ...."
> 13    ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev/sdb"
> 14    sleep 1
> 15
> 16    echo "clean  ....."
> 17    ssh ${node2} "mdadm -Ss"
> 18 done
> ```
> 

the non-clustered test script. (again: run on non-preempt kernel)

```
#!/bin/bash

mdadm -Ss
wipefs -a /dev/sda /dev/sdb
mdadm -CR /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb  --assume-clean
sleep 5
mdadm -Ss

for i in {1..200}; do
     echo ==== $i ====;

     echo "test  ...."
     mdadm -A /dev/md0 /dev/sda /dev/sdb
     sleep 1

     echo "clean  ....."
     mdadm -Ss
done
```

the value N on "/sys/module/md_mod/parameters/create_on_open" is useless.

Thanks,
heming


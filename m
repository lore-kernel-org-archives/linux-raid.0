Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FACAC433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:13:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5059B6115B
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 07:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbhDHHNo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:13:44 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:31753 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229517AbhDHHNn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 03:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617866012;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q0K2KG9ldGYzEgMCs9hsehgGtZZfl+M0N2mTOiHBSzY=;
        b=nXNYnpGFmjmntHGPTi98GKIDLI3FfMQuGe08O6VfpX0MGb36OsrPw5KwPU9lfx1sBRFYT4
        zhVwH+wtWGkcGXYE62zX7qof7AeIH+GjPOy6IWYU6K8uR4mwRD4Cv/Lx4hwE0w5KLFLWIt
        HRkHfKOo2xe5Bm7grLOiUkZWwZjlIUw=
Received: from EUR03-DB5-obe.outbound.protection.outlook.com
 (mail-db5eur03lp2054.outbound.protection.outlook.com [104.47.10.54]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-13-P2pZbhGWNhaH3XF02c4Aeg-1; Thu, 08 Apr 2021 09:13:11 +0200
X-MC-Unique: P2pZbhGWNhaH3XF02c4Aeg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Enkw79RbjI8ZBMm8CJLhhh2Kv+qAg1U4mZIfOLhAAMrH+Cd/7ojmrEXZxYn1mehk3xAfQItvVysmlgtXc8q6cbJmHOTkdgI1mTwZ1bFAwKYIWCs+RZq2VEZvSgey11wabnREfKNQGaUHYsI3OM7ECN81YEMVhPCxJp5LXVGv17u3sfZjWks7wzKu+9lH3v7wPKYQzEDyGHI7oD5TO5JNbP5FJWm1EGFIO0+cG4zSL9mOXbN5F9s0s4V/khra85Z4g6pOXqJD/qrZJlzVRandFNfQ1zs6PuloR+XmAULncH1Q8w7QCM5eXe6lgVr23hqlrDTuGo7iS8g9wf1AWDje3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IYWRffGi5zkoA7bNSDc3AhkledWYK6eRVwYwbIHiETU=;
 b=e5g3Wg6tfao7LKBkFvSkAXH9aWcAfLfJC592ccszs0+EU9KHelU9eKDHos05lqBUBJqhUoAHrfWIHoqcrNafurkKA19cGj1rvBgQXUPUueXju0QTOl5ExdXG0s2m4f5ZVYJt11Q9BO+B+Mtfdcqn146njr7IW9MRmCAda9WxPGLtydYSlQiAGI+wSzt0iORJoirCKMEWAfl62+8JydP17ThiJ9NldOc8bM2Q78qYmMavpgKH0EOSs18CjXu+7yWfiOQDt4P8oOapT5WrdmF+UR2utE3S5iCKmoPpp0Fk/DiKmYSM0JAwvl+F+JTuht39E+uYFEggdbUNuc6t7X4Pog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB7PR04MB5451.eurprd04.prod.outlook.com (2603:10a6:10:8e::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.26; Thu, 8 Apr 2021 07:13:08 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 07:13:08 +0000
Subject: Re: [PATCH] md-cluster: fix use-after-free issue when removing rdev
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        ghe@suse.com, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
 <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
 <3744902a-2e35-ffc8-7de0-f0ad7dac0cbd@suse.com>
 <7889c84f-b0f8-7ad9-cd10-793362234771@molgen.mpg.de>
 <9ebe2fab-2875-ad4c-98d8-f62723fc2b3e@suse.com>
Message-ID: <87f4d633-6aab-ec49-95d9-840106676644@suse.com>
Date:   Thu, 8 Apr 2021 15:12:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <9ebe2fab-2875-ad4c-98d8-f62723fc2b3e@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK2PR04CA0078.apcprd04.prod.outlook.com
 (2603:1096:202:15::22) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK2PR04CA0078.apcprd04.prod.outlook.com (2603:1096:202:15::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 07:13:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcbadfee-d865-43c9-231f-08d8fa5dc30e
X-MS-TrafficTypeDiagnostic: DB7PR04MB5451:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB545181AE4181912C803C3B8997749@DB7PR04MB5451.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r8FzW2Up3+FgZ+BTRs7p+0b7+AXYTHMa3aG+kHKlScgrYUfT+wRF1NRZ3oVerOpZKM+GitK3XBANrM0YpZA9ry3xfKIB2A75EH/+79nhgYiCQFYveak2S9uJsZm0g2hWAsDgNEiuOhkQ9BkD2gA0/63E2y5bRlZvJZLQqe1mwCPTgaRNo4P2zUIDQXyRqryRP8wHC/AZLKjTTRT8LK87fP3/cXawcVULpkPF3KsejnGPNRjiWXULqNqsA0TWHgcY6XEviAx78NDa8TGTiq6O0OmcGDAGKlxcSGrMGduJeCTEyvMzY3e5csam4cAibpB0rMwOBScmRFvUbXwSuZbv3sA09yVKJoo7/vezjHjU8LSwMp2tLV39y2hXTc/Elf+I7TU4/LOiK+Ae+6QmlCaYHbGueYx67Sm5IPk5n6AH/DdCDslqV1ayHHynNOscOpjzqEx2kmZaMt2Yjo6QuwrB5125xSv/2gaASZqdJleVO8lhgxGm5M7Nsy1WYZTqqx5qtb6i7jjTRymnShi7jivlwxwVKmUsHYwi8keKHP5d7B45U5o4Z0PSEQDs5wI6Y1b8TbGgsoAWzTxg6hlpKDYtkflDrxCkeJk1edEcyJ1zd2anutl05BcsVpj6C4eJPRK0KCbvANz6wjqY2DCale4VUvOM38qn0b8Xmh4gjFPzogRJ5LeDtFj539V4MDQ+UwfjsbPYr+n9lWLYaKSPOgw66Fy7cW7EinEwVzw9YZEirpu9DFwMyXoSXCKv2cIwj/Qg3/sjab7rJNwHptjzlWm2oYe0gRNP9/GGKiJ3Y9W70YH4k44A7VUP6dtJ3xlUhgG/Z8TWfRgcDr+S3WPUUzVrs3qSAig0I6ZTG79RWcRq4h8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(376002)(366004)(396003)(346002)(53546011)(6512007)(6506007)(6486002)(478600001)(4326008)(8886007)(31686004)(956004)(66556008)(52116002)(186003)(66476007)(6916009)(83380400001)(38350700001)(5660300002)(36756003)(66946007)(86362001)(8936002)(38100700001)(16526019)(2616005)(316002)(6666004)(2906002)(966005)(31696002)(26005)(8676002)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6+06bdChgCZRb0mwNkSZSW4DM78uduvTcKmARfjh6ZQn6RaIccSRX1LBFTOe?=
 =?us-ascii?Q?/57oyG31AgHttI5IkgY7Ve2q0kTmBRhxBfgerJoJXknmNXA4bMLSj9EdR3Uy?=
 =?us-ascii?Q?D5pvsDJ8mhINRzZsme6MIDUvKKzzOQqa5F0MQu2FcyePlEqpSaDspz4Nl1vO?=
 =?us-ascii?Q?+kTGPszjHkcat1Dj7t5lAvLbrWD/LybxcklmJuvnP9x3O+nl6/wI6yXtVSyz?=
 =?us-ascii?Q?mBmMfTXSE5dJncLbU9eNoD5WjhRhCdDjry4ax2HnxJrk0ctjYkwAmPVNQ+jS?=
 =?us-ascii?Q?f24bYG15suym9LjiiOAN3TApFLoN1ZwI2uJFrY3kv/tQiu0+urTSPCvDYshL?=
 =?us-ascii?Q?ikD62k+PxjhxyNkoNrgi/MJ7oLzWqje0cqIhX1OOVcUaYeclq7zWfGWf0FRv?=
 =?us-ascii?Q?aeKpilKLr2GlJLdkFNzI87VqKnohO7w7+A2kvpD2TmsVBEV55hB8F9ykmiaa?=
 =?us-ascii?Q?Ky4XhbuHwPONhJH3SjzJjm0TKFXlqcX/pJVpepLbPKODLY4LEtOIaDcsv9l1?=
 =?us-ascii?Q?JQJnM6X3jYZDihIyIVbJFNP3B3pakDhHh+An2YzsGD0FBCt2cvuuEmlJHTMM?=
 =?us-ascii?Q?hBufcNRMcGudAtxvwQYQ6Do/9rS1iqb0W2tRDfSLtqVYkYeO2LALronOwYoK?=
 =?us-ascii?Q?YT8Vr7bfJOmAuHukq59lU17l/0mxfEvFgHPJgVylTOlq4E4mnbaNKUP2Imax?=
 =?us-ascii?Q?JTrehDpiCBYeNdaNYez8D9rC7nmLXViySG6hBLIAIl5BGzbT/bkAMGwJdqBC?=
 =?us-ascii?Q?u+CmH/Sb5xhiuZawaZYoeKBdmuVhBkf1BeGkKTMd+YnNnGLduNBkM30Xocfz?=
 =?us-ascii?Q?wJy3UonTOHXXqZhhQO4YbjksHUsDsYe744bmuAddhb7tWtN5QnzEYtAmNTdR?=
 =?us-ascii?Q?gVy1BcP9JiR6ZBEyObAPMN98D2e/mwYdNLwWtXkMooFEXwS8pH95D6jZeZjY?=
 =?us-ascii?Q?3UzmBM3w1oQc8k8K2FvFXCsjD36G0bEGjeSc8n4/ZnblQRLrbMCrDhG3pcCE?=
 =?us-ascii?Q?ZBCrlSoCOrRouZES6wUBxl7Uyt0vIbdPdXOsOPANFPl4AYoUksujQVbq7+CF?=
 =?us-ascii?Q?U5F1+73Th9I/b5sNoO2WvcosWaw3QznN63g6bOG2BcZVSnipSoU6YtFp10g1?=
 =?us-ascii?Q?tD4m2tntNNSGJyDKLXtq9YXHCinNMZZNO5L2MhqdsWKZLLKeUOsQZJVJ6xPa?=
 =?us-ascii?Q?vViWn0WNAX9pm7mdf5srAt15NfY/wDI1ipIcoPLrGHMzdAuQAI/mYFUcyjJ2?=
 =?us-ascii?Q?6t+nx4DViezxQmF4sA0vFJ/iPfxMX6D7vhPlMDRDbfsXXfIfD4EwUKwmsjxX?=
 =?us-ascii?Q?c6ErGR1iBGS/XSGTg6tLcEXX?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcbadfee-d865-43c9-231f-08d8fa5dc30e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 07:13:08.5530
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WWTHKafGX//XVuTQlqKJM838yqD5HKywHq9jk607WZXKvh4kHG5zSsLtLtRXrnfymYSQQTPLZc6fSPxQK4h3lA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5451
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/8/21 2:45 PM, heming.zhao@suse.com wrote:
> On 4/8/21 2:33 PM, Paul Menzel wrote:
>> Dear Heming,
>>
>>
>> Am 08.04.21 um 07:52 schrieb heming.zhao@suse.com:
>>> On 4/8/21 1:09 PM, Paul Menzel wrote:
>>
>>>> Am 08.04.21 um 05:01 schrieb Heming Zhao:
>>>>> md_kick_rdev_from_array will remove rdev, so we should
>>>>> use rdev_for_each_safe to search list.
>>>>>
>>>>> How to trigger:
>>>>>
>>>>> ```
>>>>> for i in {1..20}; do
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 echo =3D=3D=3D=3D $i `date` =3D=3D=3D=3D;
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -Ss && ssh ${node2} "mdadm -Ss"
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 wipefs -a /dev/sda /dev/sdb
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 =
-l1 /dev/sda \
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /dev/sdb --assume-clean
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm -A /dev/md0 /dev/sda /de=
v/sdb"
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --wait /dev/md0
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm --wait /dev/md0"
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --manage /dev/md0 --fail /dev/sda --re=
move /dev/sda
>>>>> =C2=A0=C2=A0=C2=A0=C2=A0 sleep 1
>>>>> done
>>>>> ```
>>>>
>>>> In the test script, I do not understand, what node2 is used for, where=
 you log in over SSH.
>>>
>>> The bug can only be triggered in cluster env. There are two nodes (in c=
luster),
>>> To run this script on node1, and need ssh to node2 to execute some cmds=
.
>>> ${node2} stands for node2 ip address. e.g.: ssh 192.168.0.3 "mdadm --wa=
it ..."
>>
>> Please excuse my ignorance. I guess some other component is needed to co=
nnect the two RAID devices on each node? At least you never tell mdadm dire=
ctly to use *node2*. Reading *Cluster Multi-device (Cluster MD)* [1] a reso=
urce agent is needed.
>>
>> ... ...
>> [1]: https://documentation.suse.com/sle-ha/12-SP4/html/SLE-HA-all/cha-ha=
-cluster-md.html
>>
>=20
> Your refer is right. this bug is cluster special and I also mentioned "md=
-cluster" in patch subject.
> In my opinion, by default, people are interesting with this patch should =
have cluster md knowledge.
> and I think the above script conatins enough info to show the reproducibl=
e steps.
>=20

Hello,

I will add more info about the test script in v2 patch.


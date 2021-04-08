Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27891C433B4
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 06:46:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03E9661132
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 06:46:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhDHGq2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:46:28 -0400
Received: from de-smtp-delivery-102.mimecast.com ([62.140.7.102]:20033 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229630AbhDHGq1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 02:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617864375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v0zqyRQOl6r/igeOkn0xUyfspOcTJtBTvbwW1wMK5c8=;
        b=IfLIPRqB+FnjFBMwCeadixZyDkso4FzLRJ6eQcKnw8RbzNT9+CLMJn+Memli2KHPLINe6q
        9vp4dq9zDu6aXXN14ycpubtpJPMhjWkgKZL7AaaSmAliO6UfZVfiPvcFM3afMseIp/PZbW
        oDeXJaa8PW3jFTwre78oxREt61X9WMw=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-34-KWFdsO6gMa-uRc__enYYNw-1; Thu, 08 Apr 2021 08:46:09 +0200
X-MC-Unique: KWFdsO6gMa-uRc__enYYNw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HW93OvGSCPpeJC5UMSTJjVHlP9co3ggqgO0aZpi5tTvwgYkvTOoiWK4Rl3M2Q6rDpUrIvsrcp+itL6IX7PwVuCzxTSVQmTs+7GCGcU2y49rmwS8k5TSvOTID2eJkjFcivXbuZ8cqa5wxK7J2/XJZWoNsEK3TEmjOGl7+CUjvZmKrGVxJ5cWEOGt97Pu05RMEqaJLK2b8olyw6tPsim9zhjMvsAHT1rbwyqrcaUtiUt8RqjI04OUjhBEjaTPWbJ9jAsuf74VaSFF/kpuS0lW9sGwbCx5BqYLJ5risa6w0GO48VFceAsAFPYLts5v9QY+oCu7Sbf+JOhbc0GAIy5mH0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKIx0KxX6JXWf8Q4DHeePEqZ6H8NkeJiKTPs45RDlbo=;
 b=I9ewQUOYcuw3N3xHLT0GAzVIHH9riB6e1PX38c9Z6wrwH8UF6C/54XcsSroLePGzGVlN8D3hCw0pRcJ3cynbINfe75VvVY5VxWffLE9szNDW8+ucN1Hw/At0ynk1LwQojwexGGdo8TEn/fBbiN/T4zInninzDUVXIt+8X0j7UxLEj+vo5KgqIthbiRI+DnTW9HAm306cxxyFaqcYuygeZtHQfDcNE7ZhB7Ox0zYB+oNby4hEORlQpIPVWrSle9zy6ddN017z84i6SxJQ05HwCu1mg1w7CZdNU9I+wKJPMee/gEIXL9xLGox1Z9qFKn8xHjr53EXrrB6L9neCGSMK+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DB9PR04MB8185.eurprd04.prod.outlook.com (2603:10a6:10:240::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.16; Thu, 8 Apr 2021 06:46:06 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::c5e3:4b14:8fc0:b393%4]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 06:46:06 +0000
Subject: Re: [PATCH] md-cluster: fix use-after-free issue when removing rdev
To:     Paul Menzel <pmenzel@molgen.mpg.de>
CC:     lidong.zhong@suse.com, xni@redhat.com, colyli@suse.com,
        ghe@suse.com, linux-raid@vger.kernel.org,
        Song Liu <song@kernel.org>
References: <1617850862-26627-1-git-send-email-heming.zhao@suse.com>
 <00bcd9d8-4199-7d4d-32b0-ece055f2186d@molgen.mpg.de>
 <3744902a-2e35-ffc8-7de0-f0ad7dac0cbd@suse.com>
 <7889c84f-b0f8-7ad9-cd10-793362234771@molgen.mpg.de>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
Message-ID: <9ebe2fab-2875-ad4c-98d8-f62723fc2b3e@suse.com>
Date:   Thu, 8 Apr 2021 14:45:56 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <7889c84f-b0f8-7ad9-cd10-793362234771@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [123.123.133.231]
X-ClientProxiedBy: HK0PR03CA0117.apcprd03.prod.outlook.com
 (2603:1096:203:b0::33) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c73.home (123.123.133.231) by HK0PR03CA0117.apcprd03.prod.outlook.com (2603:1096:203:b0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 06:46:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 62a1a18d-4376-4146-ea44-08d8fa59fc4f
X-MS-TrafficTypeDiagnostic: DB9PR04MB8185:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB9PR04MB8185D657F8D1606E0ECCE64197749@DB9PR04MB8185.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qzsETrgAjrXB/qtW5FTSv2MGlFo0hhkphPai713Ocu1NYLlEfo8wndt+rsRnx6Ai5TPNFG5NUtVunRq22KSPxxn7iDBNaCbIRmQknEKejhWjlrf8BbHt4jGpWOeI9tNQ5/PHMVAwknagn18e5hoRlC2DqvTFEC1Vod+EAvLa6NJNZiQ/0PkZCwxTltstFBP5O+qVpJ6IwS6jzdxnBcyt7/luswqVXly/FXGHWqtRtIfRu9BfxK4f7wur+JcmFYWtEkPzSlenbw/ubEZYa0jZaQNSzFuBq7qduuegBhLxwcoWXESBc1nujw+j/V4pIY6VRSHLCgA4eyI/DhOgB/S7AXiVEOIS7JKZgrYHJqj1qoLhulj0QI2ZxlGhKSJS5/xbZHxA9iFnG55cl49j2CfZLo2p5+EOXfHriiPMTMrEwu/VVceseSXXfvH4+PtLU7EoIl5cpNm7nE/jNWuvoeflyUOhgNmta1nP9IXYhSwz4iQN/GRm92eHuGCTSiSREIt+cu9WxnmJhZbBmOPNsmvKH6YUpJ24UMZxUM9U+u2scOiDJtdpWY/0a0431zBQ9ElVTnOf8zhGL+ilW81JpEDPRzLi0CJZyEVuoMhpTx1uMOjRr2keekA7ggqJZZoHfpOw/Q/jhFwPrhYQ/jdBulltr9335fWbKRP2BWACNJqDGM3nmVn1v+5ziAu4392l/Ol9m8o7USfGKl50HGbD1A3HbxQDVdhDK1x/AYP11OX3YAnaoZ6J9HPtCRu07C0N6AiEb+hacj8/RWMRuz0OH36DwlzzZxlG2CfxCZFP8o+afJm6rZpXbUX59X/Le3jvB6uGHMtbnIHH8kJS5O3N/r9Vl31TuDIxvbF4Uw5OqOhvjIo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(346002)(366004)(39860400002)(376002)(66476007)(6506007)(53546011)(66556008)(6666004)(16526019)(966005)(31686004)(8886007)(86362001)(66946007)(31696002)(38350700001)(38100700001)(186003)(6512007)(83380400001)(956004)(26005)(2906002)(6916009)(36756003)(8676002)(8936002)(316002)(6486002)(52116002)(478600001)(5660300002)(4326008)(2616005)(9126006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PPgKe8hqawjGf6mCzJy0aI9KAZc021LHZnU7f78VHIeNYotsVxurk4PAkkat?=
 =?us-ascii?Q?OoOJwJ4x+ee2f+Jpa9jEmNH7PdS9qXeIBudvWltXkjG/V4wLMUbEP0pvrI30?=
 =?us-ascii?Q?65Oz/fgwMQTqT3T8eKI5xgxuSOrq3p7yov7cUoOa8xMP0w0UmyFXOKS3yJkS?=
 =?us-ascii?Q?oCWhoOf8WAXyZuOmwHH/vRyFH92B88E63rvP5ZqhNNiQU9YGvj3vxNMNHRtW?=
 =?us-ascii?Q?8ij9dPqWGfTsEallolis+PX6b6MQwJVl+ddm05diYHRX05GEpsEu+WU5UX9p?=
 =?us-ascii?Q?QqiFisYbx90zfOkeSkg4NzQa44C8kMFb9Hb5JU7dJKgL82wJG7nKoHgXVFl/?=
 =?us-ascii?Q?Nq/K7Oej4iE0XN14dc9d4w7OmTjKPNCQmeZN3+NstC4sS98ZZmCHyip1bgsz?=
 =?us-ascii?Q?AgLQb57pAy3qjauwGrsHAIeyTwNAbBNog5+VmMe2j3WIC37cE7yrrhIBMgJ7?=
 =?us-ascii?Q?Wo/R40lLDT9YQwRYLRGaoKvfMT9zMH6IY5ridS6zkantJ3Pl8cHEH6w/h+ol?=
 =?us-ascii?Q?yioTxz3CHNfSWLh6MZeJzdQ9yD9YGCQnThB9S+Rn6mYibmUsF3IZ8fBDtQUc?=
 =?us-ascii?Q?HWeahhoFqqxoLviKb9FbQa0ulMqWXHsJn+5EzZ4ORu8Pp4YAyuQFg0mGk4c7?=
 =?us-ascii?Q?q1g2vjwEIpfvUgrAZh3zZy7TtmnWJ4w+jPmqrw/rAkWKhtaaAHD/X1WYJQF/?=
 =?us-ascii?Q?zndwytXuCJsRwSAZrC9s914stcQ249FqPOOaR+osPqW0hWA6Mxn1rcdALTjx?=
 =?us-ascii?Q?u5i6FcDAjY2S1oQWMQrhyeofmJdAxq07C9y/FpMmWwcXsUapcwIlbSNRNaQV?=
 =?us-ascii?Q?uYjsF6mG0geqdPJ7Lghlmll0L8QqMoks5vcgdcPXfwLFDXyrFkqOSjALcCiv?=
 =?us-ascii?Q?FboheodCsNgBWdG+ZNiSRZmzc8qeemhl+sQVxd1kqaxlNRwL7iNiAbbZljGK?=
 =?us-ascii?Q?5XsP2qRTqN4/NDE2DNSHqMbf2GCblrLfqEWiFzk4zDSmmVhe1ijzbINfmatq?=
 =?us-ascii?Q?UtMvgbhQb3DGYbfOJa+gzU/oVzQRKXds1aLobuinJS5nPpkmn42yW2fCXPM2?=
 =?us-ascii?Q?3p6/zdCELNslJDDIdfJ5WQkFEop2IVQFaxF/3xc+OR8ArsaQCacYOjM2e5ru?=
 =?us-ascii?Q?F1uHfSWdBBMZRC3GdeEQyz/pQhw821ezUPSL4akin4KbyOywBx0KbNtodrDo?=
 =?us-ascii?Q?Tu6RI3Q99KqQY32cybrBmO5uHy6J9mvdltIlFNBQGK84z4iv9WEsE3GSd8w1?=
 =?us-ascii?Q?HwFEAJAST46DCznP2lWxo0m3CJvISN9mNiPYZx1llJwRtniwKF5BATH8ruTc?=
 =?us-ascii?Q?uloVXhdCkNrlyF9of8EXTSKF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62a1a18d-4376-4146-ea44-08d8fa59fc4f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 06:46:06.6203
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JIQ+FJMgI76ZIp8i7YQte/tYuT7qCoDc+l+kXhSwTzhcZM9gnMFFnfuNl1oXOA58vYhPzDQZBn03KrQhFg1XA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8185
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/8/21 2:33 PM, Paul Menzel wrote:
> Dear Heming,
>=20
>=20
> Am 08.04.21 um 07:52 schrieb heming.zhao@suse.com:
>> On 4/8/21 1:09 PM, Paul Menzel wrote:
>=20
>>> Am 08.04.21 um 05:01 schrieb Heming Zhao:
>>>> md_kick_rdev_from_array will remove rdev, so we should
>>>> use rdev_for_each_safe to search list.
>>>>
>>>> How to trigger:
>>>>
>>>> ```
>>>> for i in {1..20}; do
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 echo =3D=3D=3D=3D $i `date` =3D=3D=3D=3D;
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -Ss && ssh ${node2} "mdadm -Ss"
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 wipefs -a /dev/sda /dev/sdb
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm -CR /dev/md0 -b clustered -e 1.2 -n 2 -=
l1 /dev/sda \
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /dev/sdb --assume-clean
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm -A /dev/md0 /dev/sda /dev=
/sdb"
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --wait /dev/md0
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 ssh ${node2} "mdadm --wait /dev/md0"
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 mdadm --manage /dev/md0 --fail /dev/sda --rem=
ove /dev/sda
>>>> =C2=A0=C2=A0=C2=A0=C2=A0 sleep 1
>>>> done
>>>> ```
>>>
>>> In the test script, I do not understand, what node2 is used for, where =
you log in over SSH.
>>
>> The bug can only be triggered in cluster env. There are two nodes (in cl=
uster),
>> To run this script on node1, and need ssh to node2 to execute some cmds.
>> ${node2} stands for node2 ip address. e.g.: ssh 192.168.0.3 "mdadm --wai=
t ..."
>=20
> Please excuse my ignorance. I guess some other component is needed to con=
nect the two RAID devices on each node? At least you never tell mdadm direc=
tly to use *node2*. Reading *Cluster Multi-device (Cluster MD)* [1] a resou=
rce agent is needed.
>
> ... ...=20
>=20
> [1]: https://documentation.suse.com/sle-ha/12-SP4/html/SLE-HA-all/cha-ha-=
cluster-md.html
>=20

Your refer is right. this bug is cluster special and I also mentioned "md-c=
luster" in patch subject.
In my opinion, by default, people are interesting with this patch should ha=
ve cluster md knowledge.
and I think the above script conatins enough info to show the reproducible =
steps.

Thanks
Heming


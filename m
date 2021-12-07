Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7418DC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  7 Dec 2021 12:34:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236358AbhLGMhn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Dec 2021 07:37:43 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:43303 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhLGMhm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Dec 2021 07:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1638880451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I6WOnsOOA9A3B7KuJfzOQMWXS2rC3jv0i//C4OcL9M8=;
        b=NkEJOIRAZrtSo4lsJ2cALSkNS+TqrUoHsBLUNEwMitz+M3PjsyLysXDlQVje66OZQU6Wpg
        Vb+A5GHRMYb4/ijSJVR5SeVwa8kE7WmZRMDkSpMD4zTamhXdgbdU4pG5ufL/18PUBYwt0M
        fFAdP0Fx8/i7JTNEF7AWWJzv2ZGHhOg=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-geKviUp1MGOZ83PlS3cyow-1; Tue, 07 Dec 2021 13:34:10 +0100
X-MC-Unique: geKviUp1MGOZ83PlS3cyow-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IEZx6EqFOW+wLB6TIqzLlXLW9oSXdJxWEbXE5wfLyC1u8dNnIuw0Y/+kifCx+hBwrXaqNDb/osEsjMgw4R5Bbt3iq5cO8Mf/y7w/yXrOJEVRDqJ+PcYGRI1VATYmRL+xUOtyyZvIXA01/ivfTMaGXbatR4NH9ILcGuyg+XKuyvAdGp5eIgCOUFdYSvflWUJ5T06CcLW1wPFgMOFfJZYh+A+r6teXyb+5MZAhzy60GkvZhqB26i2KJ6o5dbRJoaGb0Ub2Pttpc8gNcmZjfsMgT8+39HFD0e3D9+CzFvgwhb5SSSCiYx0ZewbPVyVhgwBGlxtGCZyS+wwlAGunAi6cRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F/l3h3E6wXX3b2iQefF6KmRqRuJAUpCeg3z4QtVtXCU=;
 b=jix8sdAKfHGYnzKw5sMV5Q5ZQMdMd67bGaEG9FGerRSU4eC5A2ezK0DoyZaOckag+SlFDHfCLoocy9D3NsuuSd+9iyZfHlplm+vzTIGqMHC/dDtdVRAw+9gC5r/Bh8N+6a4ywthzGHVJAAZSOsj+l+kk4jNsxa+wZL97bdATybfgPY8K0QLf1lhrFt8NgpgHVrf0dlI51NE9dSMYwUJruBzuJ+OEkrMBrV4TzhrQMvAfAH2UspdfG8EdxmGiDEtS5v0ngQWhP8RiiuIBt6zmaVT/XIllQcWv/PvoAU5TkqyAhon6Uwnmqec1Wq7GGNpC8IqMcUY39R1NnTSzd0dWXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM0PR0402MB3811.eurprd04.prod.outlook.com (2603:10a6:208:d::27)
 by AM0PR04MB7041.eurprd04.prod.outlook.com (2603:10a6:208:19a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Tue, 7 Dec
 2021 12:34:09 +0000
Received: from AM0PR0402MB3811.eurprd04.prod.outlook.com
 ([fe80::1c74:da4b:e5d9:21af]) by AM0PR0402MB3811.eurprd04.prod.outlook.com
 ([fe80::1c74:da4b:e5d9:21af%6]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 12:34:08 +0000
Message-ID: <28a04276-d338-2db5-bb3d-49616e14206b@suse.com>
Date:   Tue, 7 Dec 2021 13:34:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH] mdadm/systemd: change KillMode from none to mixed in
 service files
Content-Language: en-US
To:     Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>,
        Franck Bui <fbui@suse.de>
CC:     linux-raid@vger.kernel.org,
        mtkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Jes Sorensen <jsorensen@fb.com>
References: <20211201062245.6636-1-colyli@suse.de>
 <20211201170843.00005f69@linux.intel.com>
 <9ee380c8-e43b-8f58-c7d5-5bddb6f2e688@suse.de>
 <73287b77-33aa-a9bd-7efa-5816e098f02f@suse.com>
 <39d432ad-b451-082a-e52d-ffa32155529b@suse.de>
 <163839547917.26075.6431438000167570600@noble.neil.brown.name>
 <dabe438e-3eca-8ad4-553e-ba8555d126bd@suse.de>
From:   Benjamin Brunner <bbrunner@suse.com>
In-Reply-To: <dabe438e-3eca-8ad4-553e-ba8555d126bd@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P194CA0043.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::20) To AM0PR0402MB3811.eurprd04.prod.outlook.com
 (2603:10a6:208:d::27)
MIME-Version: 1.0
Received: from [192.168.178.80] (87.164.29.157) by AM6P194CA0043.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16 via Frontend Transport; Tue, 7 Dec 2021 12:34:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a1e7128-1c53-4196-0426-08d9b97ddd24
X-MS-TrafficTypeDiagnostic: AM0PR04MB7041:EE_
X-Microsoft-Antispam-PRVS: <AM0PR04MB70416C29C3503FA5D5DE93D8B56E9@AM0PR04MB7041.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8YD41qCGApZqTdi8K+wL6PfZwfFpnMxwmhFPAPhyyfhXlOjSW2K/eToLjJCnArOMS1SeuICU5gkCNiqEmPLO7fr7gnnXnLSgIuWnxqAQJ7FpICU1/FGSMNpamNH8X4nNO6S/cqGG1N9BALDstJYfQVmVztfJRvp+7tLIstl5Yma6dbaQ2iFSzLrmloM8UR+ItpXkf/Ykxm/GF70NtsHqueEm7FNx4AN6teV4B664w19DaeFMdTLC3gMlMp1TDEybi87mjmkTuxZFBttKQDw6Eo+HpS5Fhjpk7xaCTNpO26a8XPxTPQENF3iLDmBru6daRmPG2OSno1Cp7ZYp8tpQ3W9XzidHctt92lzUQ7oKTmupWCrLTc9IBEnTC0zTF1lAYpDi+Gflgr0VOk/jB6sYi3bykCU4OEgnc8PtOZNoDwnPsaaWCy/ziBVkIQj441HiKcRRhX6S/50Y73GDqeolAhyylyQONc7cYVpPFJsNy6KEoVRWXhCif9rt+YVhjGbrP4HCR1EfZUKbrPYq5IBzVqVbealmF9tANg9y44ySiZDfADZra3VoT4vtPjaVv3eDfsAcHPTyGDHcruzo0p1p4Wc1WLUBiefosO+jxqU2xegT3VGwIMw3m3utmZtDsy7cYopvLctdjLxGbMs5XiGuDSQlDqKlyiECYVPcM4EoJkzmmHkYtXzFTM0TNhT5xTv0Owv+Jyz5w9P6u6je9eIqwCJXDnv/ziwGT9Q9nBwP98c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0402MB3811.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(83380400001)(54906003)(86362001)(6486002)(186003)(31686004)(66556008)(66476007)(966005)(316002)(36756003)(110136005)(508600001)(16576012)(31696002)(5660300002)(8676002)(2906002)(4326008)(66946007)(38100700002)(8936002)(956004)(2616005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jLANy4pVFSr438lMBuYffUQ/LQMXaWU0MfwC9REwJZhXC9ckXXIwPmeuZONh?=
 =?us-ascii?Q?KEMd7f78FrOFjIMGCi54bi9caDXCxNd+lKrfoTt3gaSuXQgGzzLiLf1+V0Xk?=
 =?us-ascii?Q?WYSZG/QbYvlBNufmLQIj3Hb0a7aoj5MDDEhoB6HJ7r8wlyMYOfYWWqVRXweb?=
 =?us-ascii?Q?moUuzzUs5O6tM2V48VWKS76G9HJz0NTrrBTpm6cmsxbNfx5Xxf4as4Hinu3o?=
 =?us-ascii?Q?9+8TcP6S1nijWxYILugZVfWsE6I1GFTEhXjRKn4O5iUScKaTyyRbHhDkOQCb?=
 =?us-ascii?Q?KAWRJRURGll5JKhMxP3lFjARSt7gk9DsJ68l+gYU562cvVCcC2VAcC7IJuH/?=
 =?us-ascii?Q?FOJp9p3E4j3qzExHTdwzborCydUOpTRreBIFaAydmKj1fisqDyQnO+dnJnvq?=
 =?us-ascii?Q?n2FjYNleOHSed5Mibbdz4rkqbEsUWsp3nxWhxhsjaEIoubc7J6uyEtLlESB8?=
 =?us-ascii?Q?Vm+0+GrUHaYtzHCx04daVcwhrCwpKpB8b8D6eQ7C1qOLzmKRoXOzMnj5WVvn?=
 =?us-ascii?Q?tWjEAfw/ea9dKdU0+9/E/I1cJYTgr5b/POrrpKGZd6JpM9dgWWYxDzYma1/t?=
 =?us-ascii?Q?w92I6MVfTT7XpDaQwZ2WkBoAzgVBz5gsa6yw3s3gh9xPU0OHFuTp36vdtGac?=
 =?us-ascii?Q?LqpYGT/dRoy9I9fXxDyT28Zw2LnVubxA9M9vU8410Xdi42oFR8vNsM/ux83p?=
 =?us-ascii?Q?Rwknzk3WxhEPZMKH5cTUA+YiWVq8fxrxhoYWTbiuT0aIoZJEX7FW62SxBOuM?=
 =?us-ascii?Q?KWJG9weUNRNENQaup8P6hEqwkhnRlQuxt8/gpM8DzquSH0zfEdRxE7noiwLy?=
 =?us-ascii?Q?e6ej8aHmZPEX3k1r45qBXTpbjz40X3zeZ2X3/sw/FzFIli9+zH3zjR3vBne/?=
 =?us-ascii?Q?lg442ZyElUmtP4TeRWT7+fvAEDSNYDPqLGLbLTVeQ/CRTUBL478pX2hnXgyX?=
 =?us-ascii?Q?3h88f6kuUfE/RQOwujO4gQZakk2EIyLBnT0CkjW9LNZuWiUMUwz2U3El579D?=
 =?us-ascii?Q?GXMnP8H6DXN+ISuXd1JZmT1u65xQGSy3Dk3fKl/mENxV1qA4gcU21VaYqfv7?=
 =?us-ascii?Q?I9roH6wBe+ltCuPAVJ+b8Shke0jOMqddY+XoggVNqeOCwtMgBbZMWml8I/YE?=
 =?us-ascii?Q?WuQvIH3A/1ozMSHT/plsGo7IPuB/vFFCdWCOwiZ9iAvdFH3pLZVYpuhFEN+6?=
 =?us-ascii?Q?97d8wxq+y6R7AcssFRZoun271P43MXEIdvfAT+NftBJ9VdPeFMi99D4rgv2e?=
 =?us-ascii?Q?CT1q3/UkJEfoGwZDpe3Xm1zBXCLl6vdwUeeSy3O9EZ0+hzBMK29a5koljOE0?=
 =?us-ascii?Q?n6YY3xAJ+wQHLo8ywBvPSt2CZTQK3UdSfXu8FHosXAPDa/lQPy2DPqZLkaeP?=
 =?us-ascii?Q?TvmnZSp0DtZ0P2GqOwrJfhheB+p9nCbjxjWNSBtrozQKtYvxlQ4NF6pxQJZi?=
 =?us-ascii?Q?7WiA420ldhqlcQdIvbwRNy72eA/YE4yYxNkREpHxawhXa6Ac/bJtXjjBtJeT?=
 =?us-ascii?Q?ztyiUUBtsT4hhsNb3BaFT24p3kXmU8hwuiHpmcDyv9bCATxR1Grla0EkBOYL?=
 =?us-ascii?Q?EAnSinyK7JlMY8Mo+P095liNqWHch+jdd+kMb/uW0+ReAjEtSjMtfFDYYoW9?=
 =?us-ascii?Q?uHomlZFhpFUytov7Vf7qcTw=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a1e7128-1c53-4196-0426-08d9b97ddd24
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0402MB3811.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 12:34:08.8529
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UfsP4WLb80pY7H+xwB3O3jGZqwRCjhLRIqgw0Bhe9rCOfuiq7/ckF8BOOQuvIWGLesj6ydapzcj5GEEpLPS3lQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7041
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 05.12.21 14:42, Coly Li wrote:
> On 12/2/21 5:51 AM, NeilBrown wrote:
>> On Thu, 02 Dec 2021, Coly Li wrote:
>>> On 12/2/21 12:28 AM, Benjamin Brunner wrote:
>>>> Hi all,
>>>>
>>>> On 01.12.21 17:23, Coly Li wrote:
>>>>> On 12/2/21 12:08 AM, mtkaczyk wrote:
>>>>>> Hi Coly,
>>>>>>
>>>>>>> This patch changes KillMode in above listed service files from=20
>>>>>>> "none"
>>>>>>> to "mixed", to follow systemd recommendation and avoid potential
>>>>>>> unnecessary issue.
>>>>>> What about mdmonitor.service? Should we add it there too? Now it=20
>>>>>> is not
>>>>>> defined.
>>>>> It was overlooked when I did grep KillMode. Yes, I agree
>>>>> mdmonitor.service should have a KillMode key word as well.
>>>>>
>>>>> Let me post a v2 version.
>>>>>
>>>> JFYI, when KillMode is not set, it defaults to KillMode=3Dcontrol-grou=
p,
>>>> see https://www.freedesktop.org/software/systemd/man/systemd.kill.html=
.
>>>>
>>>> Therefore, it shouldn't be necessary to explicitly add it (as long as
>>>> control-group is working in case of mdmonitor.service, of course).
>>> Hi Benjamin,
>>>
>>> Please correct me if I am wrong, I see the difference of the KillMode=20
>>> is,
>>> -- KillMode=3Dmixed stops the processes more gentally, it kill the main
>>> process with SIGTERM and the remaining processes with SIGKILL.
>>> -- KillMode=3Dcontrol-group kills all in-cgroup processes with SIGKILL,
>>> which I feel a bit cruel for the main process.
>> There is no point sending SIGTERM to a process which doesn't respond to
>> it.=C2=A0 mdmon is the only mdadm service which handles SIGTERM.=C2=A0 S=
o it might
>> make sense to uise KillMode=3Dmixed for that.
>> For anything else, SIGKILL via KillMode=3Dcontrol-group is perfectly
>> acceptable.
>=20
> Hi Neil,
>=20
> Thanks for the hint. So it seems remove the KillMode=3D lines from the=20
> systemd files might be best choice.
>=20
> Hi Benjamin,
>=20
> How do you think about removing the KillMode=3D lines to use SIGKILL as=20
> default action ?
>=20
 From my PoV, this should be fine. To be on the safe side, I've added=20
Franck Bui, our systemd maintainer, to the list of recipients.

Franck, could you have a look as well, please?

Thanks,
Benjamin

> Thanks.
>=20
> Coly Li
>=20

--=20
Benjamin Brunner
Engineering Manager System Boot and Init
SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 N=C3=BCrnberg
Germany

HRB 36809, AG N=C3=BCrnberg
Gesch=C3=A4ftsf=C3=BChrer: Ivo Totev


Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CFB9C433EF
	for <linux-raid@archiver.kernel.org>; Thu, 31 Mar 2022 08:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232789AbiCaI1E (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 31 Mar 2022 04:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232748AbiCaI05 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 31 Mar 2022 04:26:57 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE40C6EFE
        for <linux-raid@vger.kernel.org>; Thu, 31 Mar 2022 01:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648715101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QoAUhvtLfNQoERzj/mmCD+4THVXt9OW8t/wg8cl7HVM=;
        b=Lv1JaII7sVjAaEQA8lt02x4n2xs+0pJoa0palW5UTMpD+0JIh37XsDm6z+RWBZYLcHpq4n
        qWW/nC6Vtloab/iv5rasDJntLYhJ+f4UTHpOQqdz+HLtEIV39lkWAKUux0KJ5G8KwQ/CAY
        pmx1WFRR854ucTKcitRUJa8p6KBWOoQ=
Received: from EUR01-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur01lp2051.outbound.protection.outlook.com [104.47.1.51]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-MVSOaAN4MTWRS2s57Ji1LA-1; Thu, 31 Mar 2022 10:24:57 +0200
X-MC-Unique: MVSOaAN4MTWRS2s57Ji1LA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BXvc4gCUHRORZyi0K5VEUQlXRTCHB1lmbMDnGyBqvytVlJiPuzERRWawBmd9VdMPHCrY0KfaQUst+Y+t3BhNc6K+E3EiCLd1D8ctRm2pdmAxMRO2d8GV47EiI4XBOOYIfIYABdCnpawsEONGP4r8v6ZIlMqChYljTRM9xkKN3XijKf+hwMFPZIubKMB4Wa3NyoHghXZGj9LtXJl2RBa+x4iD5N99grwUsE9TIBz/tCwtoq12y99cClmJ0ikUJVJdd6D7bszjcEfWzsipXa2wZ30FfePoxlTDJ/vZdcRY27oIYNGb1O8o5rL72v4BT8ziMdQcGS0c1CHlxcJOKruBWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kKBOmYlnj2WIZCU2w24pvj/QX/lAIfde49INBXupTps=;
 b=U9IHSPuDc5U+4CBlm9XpB7OH66bbTtEqlgimLNshapyr0HJr5aDliO3sZ2HGcalMr76mDC86kaSulPbX1Pb5YTcygLXdpPq3977STJOo7OH+ZZRfCMUDK/yHfAC369Rv/rzneOVMIjhoT41Sq8G9dWtWKHUK8HyqBCyAszMQyUuJ4MwId8LjtHlscVHjK3wfu27nk1S67QVpFgdxkEsLF2rfkNttekzXxLbR+5WFwH6yydAESwiw+SbAJTGbAkoIn+D2tijVIl/FqfUrvXqlYb9gEeM940YileGbwSEbpFCpOxmn+P1ayUNDdJg0Cz3PD4KBF5sEkJ6ggyNgaSfISg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com (2603:10a6:5:2b::14) by
 DBBPR04MB7868.eurprd04.prod.outlook.com (2603:10a6:10:1f1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.21; Thu, 31 Mar 2022 08:24:55 +0000
Received: from DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764]) by DB7PR04MB4666.eurprd04.prod.outlook.com
 ([fe80::34b0:c774:609d:2764%7]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 08:24:55 +0000
Message-ID: <77739a6b-fd8b-a5a7-d681-59cd0836e5c8@suse.com>
Date:   Thu, 31 Mar 2022 16:24:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] md/bitmap: don't set sb values if can't pass sanity
 check
Content-Language: en-US
To:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        linux-raid@vger.kernel.org, song@kernel.org
CC:     xni@redhat.com, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20220330102827.2593-1-heming.zhao@suse.com>
 <8c4070a6-1e40-261c-35d2-00078a1cf1f5@linux.dev>
From:   "heming.zhao@suse.com" <heming.zhao@suse.com>
In-Reply-To: <8c4070a6-1e40-261c-35d2-00078a1cf1f5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: TY2PR04CA0020.apcprd04.prod.outlook.com
 (2603:1096:404:f6::32) To DB7PR04MB4666.eurprd04.prod.outlook.com
 (2603:10a6:5:2b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb39c7c2-ff6c-4783-b6c0-08da12efefb8
X-MS-TrafficTypeDiagnostic: DBBPR04MB7868:EE_
X-Microsoft-Antispam-PRVS: <DBBPR04MB7868940EA7AC34074107B84197E19@DBBPR04MB7868.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cXRPObI+P7bPM4I6TuOWfbUXyhW0w0DIwOlu1EAEppPS29iP4rGt9IJH3HojprIthNkEZAfR5OJi43Vd66EmNbDl/J7qPpUlnBaZD1bUlW4Ppb550QPYy6kei+3ZnV17mxycwXzTjd2nkqJk2VUqSqrlEt9R7wMn6Fe7NtBHeE6sI5WWP+I5+A9gzC8uc5oAaLRJt419kGe2zilJwKxMDGn6+ij0M9oV7rUkMTB/sElWh0OG8gdougacdypf2wrfvsubdvLcPZAwXFK/+bV2SYCF6ySMAn1V/rVdyNxJLJePgddHjqScLh8lTWUNGjy/Q7cqRzEW7wvku4k2r4U4wpZ9BKWE1fhQAdm3ZKDZI2XBAirMM1hQmNAQtKibYz62wtwnu7FBQDTTdTLTqWdtLOEN4q63YHLWDzHN5jzx3jHhl89J0nFX6ns5bSQ/ZmcP+BrhXHy2Tyl14mZm1CkINP52cLOLQMr/azLIEysHyH/6Dr30Q4XgB2F/9IgiPFnpoBGTLRMt9q0r+YFy1R7jMf+ysdIgxPkzyEYlWY2se8W38u7ScWAkbXBCSnrQ1h0ANrpOhSg3OGhkX8UXR/p2Hw+IkTSQhLtaKdkZfJkkp57wYoMdiUX2bVbo3t9Kw/uMGNX5H7UndvWyOFJWQB5osxMD3w66k4iIcV1uVZi73OW+56f96Iy9hgEbeQLz8uMEQgjuxM/yMMX72vYc1NGgbWWqGJ0NM4jy8L6hPSplSw4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB4666.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(54906003)(316002)(66476007)(8676002)(6512007)(6506007)(6666004)(53546011)(66946007)(31696002)(86362001)(6486002)(508600001)(66556008)(38100700002)(26005)(2616005)(4326008)(5660300002)(186003)(83380400001)(8936002)(36756003)(31686004)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ati8vyqIbvPctXT024URbJ9sWunSy2P7P0ABD1TVHTqJY2bo5/iiVqGZBoxK?=
 =?us-ascii?Q?/xCpcbX/LWyyFgOjuUA3PQboTIaDIJsyvi9y82j3B0zq6czRgjUzvb/FFp/3?=
 =?us-ascii?Q?vca3Jed37YUJsiHGlIJ8eHto6sp44Thfq9pqmERFQWbyUNESKHaIG/mMhVFR?=
 =?us-ascii?Q?Pt3g7aGbmRUhiR3RL1YsUi4PsaWVGj8efEteCpLbsQJ3JMnjgCuFpAgZMuNm?=
 =?us-ascii?Q?vUAqM1RI0+fdjc0YCBLbuc29f/LVYxgxvYLjeRAEziJJ+vX0b+sLKhv6k/rx?=
 =?us-ascii?Q?URBxho/JOKYEDaWxjZX+x2cig/eQ+o7Z0cOmGgkQwWtN39bqMYb/oaTpO6IL?=
 =?us-ascii?Q?SwSbuTP9+i6uBdRv0xwtoZPdsOlBsrMXJBX+1Y6hKd2RRv8UOHO25SvOgFkx?=
 =?us-ascii?Q?2iczi2zHtJ69bvWqyq4zQjB9M4rdD6CgmOTB/wKRWO5gLXIbZGk45HyExvEm?=
 =?us-ascii?Q?S85oq1rdxSH+IMM3vLZZ9wB9/urOY8iGFUbqr/cng3rUKTE8sVo7hdy2NVP3?=
 =?us-ascii?Q?x5O6//9Qq1p6RwD9iHvh9RJC4rJj+mSaI6ttLU8TPMl4q750RUovMSkzeWDd?=
 =?us-ascii?Q?6cxqW5IT65s2R0wO3XW7U06REoLrA5cFdxNF7q+27MLfEsS6iM1iL45++wv4?=
 =?us-ascii?Q?oB8dqZnJqwakJXaK8kZixe1/yKzJXeSF4ebz3Gp8KM9ejYfHC5gREBjFMVcj?=
 =?us-ascii?Q?t8GZaYlDVShjPU/I+nDGp/S2+xUZaTMFXr7nCaumzsxfYm0JqIqCWaftcPxn?=
 =?us-ascii?Q?8s8lbEHhRjeCRwWYtEoEfb6JO9JliP3Z8+OweX0DcVoP02f3g+/lPyj+0xyd?=
 =?us-ascii?Q?99Xo1AwUNcqUNtrsj+vijnc5z1ytyYclIdL74hRlZn84yBYxva9nxcq/LCPL?=
 =?us-ascii?Q?WsFLS376GnYTOgQbSWy2aVAZsnQ/6XUY3cLmWt4+BzycFRq9dW3+WitF7ewx?=
 =?us-ascii?Q?PKLslmdydKOuKlVxBX9MiXAAxbMitM/8BRee6qtDI+V1WFdrnwyh9hm9bIge?=
 =?us-ascii?Q?Pr9Bqw5HE1FFqxVHVyZS/+fx17BaT/BcHUnqNxdjXUEwFUcb8f4dwsZuvfmW?=
 =?us-ascii?Q?i8kWqlnzIq8pNpzwq3jUgTKZ8D5iwV1F0MXvEfygkZL2J4yc/kcrRkqgVflL?=
 =?us-ascii?Q?+t5jwhtjefREvQKHqTVoq5Nzk1V94BTxZZ3Uf08QueJmU4BjePH5QYLSagk/?=
 =?us-ascii?Q?GJ9Bkdp5NLZOUuXWu83vpdVCd/hmxXrKQBN3Rd9mdh+C5PuYk20J1PaR0y/2?=
 =?us-ascii?Q?e7qhUQCEfsGvGuXJ3G5D8lAwcOL3cF2q9rQwp9y6tXLC/cvixDUV5NIxAqzh?=
 =?us-ascii?Q?FHerSa6diC1ZqsaXd2vfuRhQi5uMshd1meaWJhNJt6vZI7nphkDL+qIWIGzI?=
 =?us-ascii?Q?k8KcCMZfFFeilsdlcNzLMGRqhFVwzx3679NrUJ/ji52a+gHu81+dokPX8uZx?=
 =?us-ascii?Q?KqU8L6BJtDTxqu6uIJwvELB+lbhhmSSCXxARNdIwEWvu9ARVVMldkRKESFUD?=
 =?us-ascii?Q?r38ngI0cGVcPWkPMB9neY2Q37V6d8Q5Ym8pi4DYP2R+v4qmZklwQ5pQbNjyA?=
 =?us-ascii?Q?O+DboUTggZ+clZyyodHrsOK2lEIuU58GNwuxhKpyGcAMstYiOglpoLD6miN+?=
 =?us-ascii?Q?DzFaNZ/nKRlMd4TPUfYI9Ffu6WDUyuwT/QAbvwfVO+66Zf9jo+Okf0XrP6o3?=
 =?us-ascii?Q?Qb3GFgRWhZaMONvb9i+bBpYidSLM95/gsc3u5ZYYzK+d8QmA02R2n1eqD9Zo?=
 =?us-ascii?Q?+0J959Kc7Q=3D=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb39c7c2-ff6c-4783-b6c0-08da12efefb8
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB4666.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 08:24:55.8127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tMfD41K3Cxb3YMTn0H+HvY+D3Op/ugKcNM7FySSfaNsfEkA5WnMR3aF5aIsf/Dkqzu7+GI38Nni5QR7CVyGBNQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7868
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/31/22 15:06, Guoqing Jiang wrote:
>=20
>=20
> On 3/30/22 6:28 PM, Heming Zhao wrote:
>> If bitmap area contains invalid data, kernel will crash then mdadm
>> triggers "Segmentation fault".
>> This is cluster-md speical bug. In non-clustered env, mdadm will
>> handle broken metadata case. In clustered array, only kernel space
>> handles bitmap slot info. But even this bug only happened in clustered
>> env, current sanity check is wrong, the code should be changed.
>>
>> How to trigger: (faulty injection)
>>
>> dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sda
>> dd if=3D/dev/zero bs=3D1M count=3D1 oflag=3Ddirect of=3D/dev/sdb
>> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
>> mdadm -Ss
>> echo aaa > magic.txt
>> =C2=A0 =3D=3D below modifying slot 2 bitmap data =3D=3D
>> dd if=3Dmagic.txt of=3D/dev/sda seek=3D16384 bs=3D1 count=3D3 <=3D=3D de=
stroy magic
>> dd if=3D/dev/zero of=3D/dev/sda seek=3D16436 bs=3D1 count=3D4 <=3D=3D ZE=
RO chunksize
>> mdadm -A /dev/md0 /dev/sda /dev/sdb
>> =C2=A0 =3D=3D kernel crashes. mdadm outputs "Segmentation fault" =3D=3D
>>
>> Crash log:
>>
>> kernel: md: md0 stopped.
>> kernel: md/raid1:md0: not clean -- starting background reconstruction
>> kernel: md/raid1:md0: active with 2 out of 2 mirrors
>> kernel: dlm: ... ...
>> kernel: md-cluster: Joined cluster 44810aba-38bb-e6b8-daca-bc97a0b254aa =
slot 1
>> kernel: md0: invalid bitmap file superblock: bad magic
>> kernel: md_bitmap_copy_from_slot can't get bitmap from slot 2
>> kernel: md-cluster: Could not gather bitmaps from slot 2
>> kernel: divide error: 0000 [#1] SMP NOPTI
>> kernel: CPU: 0 PID: 1603 Comm: mdadm Not tainted 5.14.6-1-default
>> kernel: Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)
>> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
>> kernel: RSP: 0018:ffffc22ac0843ba0 EFLAGS: 00010246
>> kernel: ... ...
>> kernel: Call Trace:
>> kernel:=C2=A0 ? dlm_lock_sync+0xd0/0xd0 [md_cluster 77fe..7a0]
>> kernel:=C2=A0 md_bitmap_copy_from_slot+0x2c/0x290 [md_mod 24ea..d3a]
>> kernel:=C2=A0 load_bitmaps+0xec/0x210 [md_cluster 77fe..7a0]
>> kernel:=C2=A0 md_bitmap_load+0x81/0x1e0 [md_mod 24ea..d3a]
>> kernel:=C2=A0 do_md_run+0x30/0x100 [md_mod 24ea..d3a]
>> kernel:=C2=A0 md_ioctl+0x1290/0x15a0 [md_mod 24ea....d3a]
>> kernel:=C2=A0 ? mddev_unlock+0xaa/0x130 [md_mod 24ea..d3a]
>> kernel:=C2=A0 ? blkdev_ioctl+0xb1/0x2b0
>> kernel:=C2=A0 block_ioctl+0x3b/0x40
>> kernel:=C2=A0 __x64_sys_ioctl+0x7f/0xb0
>> kernel:=C2=A0 do_syscall_64+0x59/0x80
>> kernel:=C2=A0 ? exit_to_user_mode_prepare+0x1ab/0x230
>> kernel:=C2=A0 ? syscall_exit_to_user_mode+0x18/0x40
>> kernel:=C2=A0 ? do_syscall_64+0x69/0x80
>> kernel:=C2=A0 entry_SYSCALL_64_after_hwframe+0x44/0xae
>> kernel: RIP: 0033:0x7f4a15fa722b
>> kernel: ... ...
>> kernel: ---[ end trace 8afa7612f559c868 ]---
>> kernel: RIP: 0010:md_bitmap_create+0x1d1/0x850 [md_mod]
>=20
> l *md_bitmap_create+0x1d1
> 0x3a81 is in md_bitmap_create (drivers/md/md-bitmap.c:609).
> 604=C2=A0=C2=A0=C2=A0=C2=A0 re_read:
> 605=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 /* If cluster_slot is set, the cluster is setup */
> 606=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 if (bitmap->cluster_slot >=3D 0) {
> 607=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sector_t bm_blocks =3D =
bitmap->mddev->resync_max_sectors;
> 608
> 609=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bm_blocks =3D DIV_ROUND=
_UP_SECTOR_T(bm_blocks,
> 610 (bitmap->mddev->bitmap_info.chunksize >> 9));
>=20
> Please add something to header like "because the chunksize is zero, which
> caused the kernel crash".

OK

>=20
>> Reported-by: kernel test robot <lkp@intel.com>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> ---
>> v3: * fixed "uninitialized symbol" error which reported by kbuild robot.
>> v2: * revise commit log
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - change mdadm "FPE" error to "Segm=
entation fault" error
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ("FPE" belongs to anoth=
er issue)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - add kernel crash log
>> =C2=A0=C2=A0=C2=A0=C2=A0 * modify a comment style to follow code rule
>> =C2=A0=C2=A0=C2=A0=C2=A0 * change strlcpy to strscpy for strlcpy is mark=
ed as deprecated in
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Documentation/process/deprecated.rs=
t
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 - note: strlcpy() still exists in m=
d.c & md-cluster.c
>> ---
>> =C2=A0 drivers/md/md-bitmap.c | 46 ++++++++++++++++++++++---------------=
-----
>> =C2=A0 1 file changed, 24 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index bfd6026d7809..c198a83c9361 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -639,14 +639,6 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 daemon_sleep =3D le32_to_cpu(sb->daemon_s=
leep) * HZ;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 write_behind =3D le32_to_cpu(sb->write_be=
hind);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sectors_reserved =3D le32_to_cpu(sb->sect=
ors_reserved);
>> -=C2=A0=C2=A0=C2=A0 /* Setup nodes/clustername only if bitmap version is
>> -=C2=A0=C2=A0=C2=A0=C2=A0 * cluster-compatible
>> -=C2=A0=C2=A0=C2=A0=C2=A0 */
>> -=C2=A0=C2=A0=C2=A0 if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUS=
TERED)) {
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodes =3D le32_to_cpu(sb->no=
des);
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strlcpy(bitmap->mddev->bitma=
p_info.cluster_name,
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sb->cluster_name, 64);
>> -=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* verify that the bitmap-specific fields=
 are valid */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sb->magic !=3D cpu_to_le32(BITMAP_MAG=
IC))
>> @@ -668,6 +660,16 @@ static int md_bitmap_read_sb(struct bitmap *bitmap)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto out;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * Setup nodes/clustername only if bitmap versi=
on is
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * cluster-compatible
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 if (sb->version =3D=3D cpu_to_le32(BITMAP_MAJOR_CLUS=
TERED)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 nodes =3D le32_to_cpu(sb->no=
des);
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 strscpy(bitmap->mddev->bitma=
p_info.cluster_name,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 sb->cluster_name, 64);
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* keep the array size field of the bitma=
p superblock up to date */
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sb->sync_size =3D cpu_to_le64(bitmap->mdd=
ev->resync_max_sectors);
>> @@ -695,14 +697,14 @@ static int md_bitmap_read_sb(struct bitmap *bitmap=
)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (le32_to_cpu(sb->version) =3D=3D BITMA=
P_MAJOR_HOSTENDIAN)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 set_bit(BITMAP_HO=
STENDIAN, &bitmap->flags);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->events_cleared =3D le64_to_cpu(sb=
->events_cleared);
>> -=C2=A0=C2=A0=C2=A0 strlcpy(bitmap->mddev->bitmap_info.cluster_name, sb-=
>cluster_name, 64);
>> +=C2=A0=C2=A0=C2=A0 strscpy(bitmap->mddev->bitmap_info.cluster_name, sb-=
>cluster_name, 64);
>=20
> I feel we don't need copy cluster_name twice, pls double check and send a=
dditional
> patch to remove one "strscpy(*cluster_name* )" if my feeling is correct.

cf921cc19cf7c ("Add node recovery callbacks") introduced the first usage of=
 strlcpy().



b97e92574c0bf ("Use separate bitmaps for each nodes in the cluster") introd=
uced the second strlcpy().
from this time, the two strlcpy() were same, we can remove anyone of them s=
afely. But see next commit



d3b178adb3a3a ("md: Skip cluster setup for dm-raid") added dm-raid special =
handling.

and the "nodes" value is the key of this patch. but from this patch, strlcp=
y() which was introduced
by b97e92574c0bf become necessary.



3c462c880b52a ("md: Increment version for clustered bitmaps") used clustere=
d major version to only
handle in clustered env. this patch could look a polish for clustered code.



(my v3 patch changed strlcpy() to strscpy() for deprecated API.)

so strlcpy() from cf921cc19cf7c became useless after d3b178adb3a3a, we coul=
d remove it safely.

IMO, it makes sense to remove the duplicated strcpy().
I will send two patches for v4:
- for the new comment
- for strlcpy =3D> strscpy & removing duplicate.

Thanks for your great comments

- Heming

>=20
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D 0;
>> =C2=A0 out:
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kunmap_atomic(sb);
>> -=C2=A0=C2=A0=C2=A0 /* Assigning chunksize is required for "re_read" */
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.chunksize =3D chunksize;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err =3D=3D 0 && nodes && (bitmap->clu=
ster_slot < 0)) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Assigning chunksize is re=
quired for "re_read" */
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.c=
hunksize =3D chunksize;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D md_setup_=
cluster(bitmap->mddev, nodes);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err) {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 pr_warn("%s: Could not setup cluster service (%d)\n",
>> @@ -713,18 +715,18 @@ static int md_bitmap_read_sb(struct bitmap *bitmap=
)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto re_read;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -
>> =C2=A0 out_no_sb:
>> -=C2=A0=C2=A0=C2=A0 if (test_bit(BITMAP_STALE, &bitmap->flags))
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->events_cleared =3D b=
itmap->mddev->events;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.chunksize =3D chunksize;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.daemon_sleep =3D daemon_s=
leep;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.max_write_behind =3D writ=
e_behind;
>> -=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.nodes =3D nodes;
>> -=C2=A0=C2=A0=C2=A0 if (bitmap->mddev->bitmap_info.space =3D=3D 0 ||
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.s=
pace > sectors_reserved)
>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.s=
pace =3D sectors_reserved;
>> -=C2=A0=C2=A0=C2=A0 if (err) {
>> +=C2=A0=C2=A0=C2=A0 if (err =3D=3D 0) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (test_bit(BITMAP_STALE, &=
bitmap->flags))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitm=
ap->events_cleared =3D bitmap->mddev->events;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.c=
hunksize =3D chunksize;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.d=
aemon_sleep =3D daemon_sleep;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.m=
ax_write_behind =3D write_behind;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitmap->mddev->bitmap_info.n=
odes =3D nodes;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->mddev->bitmap_in=
fo.space =3D=3D 0 ||
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitm=
ap->mddev->bitmap_info.space > sectors_reserved)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bitm=
ap->mddev->bitmap_info.space =3D sectors_reserved;
>> +=C2=A0=C2=A0=C2=A0 } else {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 md_bitmap_print_s=
b(bitmap);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (bitmap->clust=
er_slot < 0)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 md_cluster_stop(bitmap->mddev);
>=20
> Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>=20
> Thanks,
> Guoqing
>=20


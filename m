Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20710C433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 13:01:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E16706008E
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 13:01:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhDHNBt (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:01:49 -0400
Received: from mail-vi1eur05on2107.outbound.protection.outlook.com ([40.107.21.107]:3872
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229751AbhDHNBs (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Apr 2021 09:01:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeqjjiwJwwU81ucWHi/meMNpAro31woKn+BYQC2vtSrc8r50q6UQxxKgOpdynb+Ny7q0D4sYbmkkvMMaoF2t8S8mATLQmOExOEnatI/2vakk6su7xEhCQg06Wu0BA+V3gale+W63qmieN5kdsTu+DZo5t3d6S+yo/sb0MR9VsBq2b6UbJpLdlO13fE+Qt3XroUrpoSVyBSYytaZVOIgMnSHPXk78yyCoatRNbPiPzura1HzPP8503+rOzOrZhDyM0H+6y8Hk4wzWfCx0yomKsR2R73h0Cw+CjDJdjBI2gm+EW9kFBo89/cTad9zoscRrefNBFpPDPVMjKUkY1+kUSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy2su43V6V6ZS8GAOVEFF6RDFMiKMoGl40WXl6KHVJI=;
 b=KRcbuO0/K1U7BJBP44FfVQIM4miBebUYae/1GR+5krPIAvtwNMj1mjpYa6nH7cPkdmosdm7KNsURtDe9SIBl0oPhf6ZDQ+W3U2rAK5ubkScexCpGhJUiZvEi4T0Ixz/w4sF6YXh2g5i/aL62dW87d2DVOfG49+VBYD8HjUC71PMeni7TirjeZKZhnzVq/qrQKACRLnjVbq15NHwSLaMn6LF2xadKQtFcIuLh2j72Cjf71mLJIn/I1wExT8WQ7mp+eXOBGzLAZ2M/i9ZOfRFmBY+5EKC6HLNbvk5qsSqN0FXWGULMWporHGMKLR51uv5d+7ka5C3bq8WiQUfBkBTMdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=storing.io; dmarc=pass action=none header.from=storing.io;
 dkim=pass header.d=storing.io; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xy2su43V6V6ZS8GAOVEFF6RDFMiKMoGl40WXl6KHVJI=;
 b=W5kh1Tr9jXYJczmVVHnHELOxbfeYOtyCGvz8MExDyR6+9EjX+P0dNW7Y1N3IzgCzKIrjKx8dPK82qHumMBM93WM3xhfVSIyUkOPZtKx9kZxNt+Y2b3VjWq2ysR9VwEtXlMXHCmwlfE1HTE85cPtzHRX0WZ4oF1YfiI17t0liWR/3uYZfypWXk5ygPWlhfsnM/ibuEDf5GtGkPDuoQSoNgDgArngpoG7mE4utxJl7h5wAeUDxTHugh19FUw3PKyFV4OzuIqP/7uOpVvFLQhXieyYe0ndvT3q2xO4Oklc8UCXfmFx7ZlkOeTj/2p29U1HRK8HBEBqGa7vN0P1Dd2eatA==
Authentication-Results: nbi.dk; dkim=none (message not signed)
 header.d=none;nbi.dk; dmarc=none action=none header.from=storing.io;
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com (2603:10a6:20b:2a4::6)
 by AM6PR04MB6344.eurprd04.prod.outlook.com (2603:10a6:20b:d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26; Thu, 8 Apr
 2021 13:01:34 +0000
Received: from AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::8d7d:a6bc:16f2:89cc]) by AS8PR04MB7992.eurprd04.prod.outlook.com
 ([fe80::8d7d:a6bc:16f2:89cc%3]) with mapi id 15.20.4020.018; Thu, 8 Apr 2021
 13:01:34 +0000
Date:   Thu, 8 Apr 2021 16:01:31 +0300
From:   Gal Ofri <gal.ofri@storing.io>
To:     happe@nbi.dk
Cc:     linux-raid@vger.kernel.org
Subject: Re: OT: Processor recommendation for RAID6
Message-ID: <20210408160131.3fbb88a9@gofri-dell>
In-Reply-To: <0950b0da-e2d4-d530-50cf-5c322a303fdd@nbi.dk>
References: <CAAMCDedmGUcWY=9Nb36gXoo0+F82rhq=-6yKZ1xPf74Gj0mq7Q () mail !
 gmail ! com>
        <0950b0da-e2d4-d530-50cf-5c322a303fdd@nbi.dk>
Organization: Storing.IO
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [199.203.113.198]
X-ClientProxiedBy: MRXP264CA0014.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::26) To AS8PR04MB7992.eurprd04.prod.outlook.com
 (2603:10a6:20b:2a4::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from gofri-dell (199.203.113.198) by MRXP264CA0014.FRAP264.PROD.OUTLOOK.COM (2603:10a6:500:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 13:01:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d15065a7-a6ea-4903-98d5-08d8fa8e6ff3
X-MS-TrafficTypeDiagnostic: AM6PR04MB6344:
X-Microsoft-Antispam-PRVS: <AM6PR04MB634470A1EC45C4EEAB70D549FE749@AM6PR04MB6344.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1443;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AbMCqpUFoIR1EvwMl4b1VTSP/7wXTnPu5DNLtVXBnwLc/GhX3/wa1VLtw8IEYkZL7TgfLMaWHbVBXoXrZS0xZpCNimRPUcGeFhQEDp7Q8JJS9fQRGbjxM5ySwvCxfuW5Y8oJalkkPWyIqYC36rN6K3J6ehw7XZf6Th5yIs5+bkiIuAS6i/6Czeu0lkgqxwNsTMdY8P5PPh52XKNIxZ6CQamJL0ydnC+66tXNv3AWW2lUNlkr86EhgjISSAwwvXfc3TLF04AW8PV1Rn0b7owcId3tPxqCywkCNOSfN/MJSTV9l2PGuBLv/AriOJtQPewGg+ufS6UkwM1Y9LHHqboyptsFQ5IbJalp+9ZvmA1AWD5m8Zrk8tjZ+LXhML+03EvJgxEBoTyjMbkzxMmr0Uvb1dDtzAumfQOl6YokTKjpMRABYy2Z5vLZCmbUzq1C+azD2ynXrWnMwUWTwLhragma1b/oafdVpcUKYW4b9G9dqVwzVBk1pthkozpxt80ollUzNKF9GgzTvUqWOdDbqo9yORd4j5vwgxTg9CvDfU6J+q5Ks9iyRaQNwgLOAOfpNOBalvVqb4bk11tvC6j+cL3ItpEoWWVvEBuLCwnFRY/ZgiBGJAy0/vr+ZIChIUaVLSm9RT2OBYOTYknoPrxLJwf+IqrpyUppQtTVPTYqjGgTtPITDiRyZeuzhx+3SF6t+KGHwy0kO2GoyJ4S9yP5gI5Kpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB7992.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(39830400003)(376002)(6496006)(1076003)(186003)(66946007)(2906002)(66556008)(16526019)(86362001)(6916009)(38350700001)(8676002)(8936002)(26005)(6666004)(66476007)(52116002)(4326008)(316002)(5660300002)(33716001)(38100700001)(956004)(53546011)(55016002)(478600001)(36916002)(44832011)(83380400001)(9686003)(299355004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6jjjIi/nZvgUr03eZ2JeRrnHm2as39s1YcwixpoFN5yZ3z4ueS9YRkG+j8mg?=
 =?us-ascii?Q?yZwRe9O55q7e45Y4p/3QQjgl2yF0mVyXgoVTgeGQhbzBrjtIeCKDkAtbuojq?=
 =?us-ascii?Q?ocUx2vvLLvypIf2CS4nRP5cigXAEpAIqAIsXmT907HdijjuFYdmUBX1+/kgb?=
 =?us-ascii?Q?Fl0CBdaYUbAdlYILjRxMTaRUN6iBWLwDh52z+xxRo/BE5Jf90yJmGc42PV5P?=
 =?us-ascii?Q?Kz9XePLK+0eN0lmJd52xaZoSP33JT6pPoprZS4VBuzz5nYRJR2IxgRt/r8qM?=
 =?us-ascii?Q?pjq3FaE63W6A3x/ZB3UWnLCStLC+AVEjIeRIFqKOLKSJNhWTfLZJwE0iIxOr?=
 =?us-ascii?Q?q2McGUd/ZargzRbIYo7U4jislCpuaAbCJ5YhzUXmwRpwANLkU5104l6ijnVF?=
 =?us-ascii?Q?W7fZ69Hhx3aszpwY3BHHT/EDsD3kgk5a7EnJ+ek5lbi/1cfWTJEkbTTJz/cz?=
 =?us-ascii?Q?pTXvIPItOoGYPnAVT03HZkJ6IMsKh43ONjiFlT5Mcd7BdAmhRXp+6paWUr0L?=
 =?us-ascii?Q?kPhWStK8RvU2lIGhqfqFhG14cjoH8qZo7y9l+fbjhELO++5Go8vyidtB/0kH?=
 =?us-ascii?Q?6eZcfmznHMeEDJt24r4njGBVyYvuvN/pI+6GlzSZr8i8TrPcclcCEt4zSJUS?=
 =?us-ascii?Q?7XrklkS215p9o9scI3Qd73mnNfnstI9oVeCDZaFf0fudUpkOaj+G6wj1BgwZ?=
 =?us-ascii?Q?O3/JwMraKbvnUBNv7sat2b3dw8EExJUcsRTJEdBg2E6PUKtlKfU1GE/AnYb8?=
 =?us-ascii?Q?oPEGzuYKJWOEMq+BuHkfiAMmK2zG2CAFIAT4l60Ev6mvAFQ4MCfJXYw00KAf?=
 =?us-ascii?Q?Aba5HIIIYHAw9wTyJzACsgVtHyl5kIsiUJT3AlzGnxk7TA1eJUJDsAXXAtUn?=
 =?us-ascii?Q?wSzd4AmzBtJzhWRmyt5SkJYOIe5XJr4PjdxG/GlQGgZ06Lxb7HrRmgwlEZiG?=
 =?us-ascii?Q?Tyo5EMgO8ixgAUwICHqWqy7f0CK0LnKr67wujpxp5X0D0U0NeBatdOhtdm2c?=
 =?us-ascii?Q?7s0P09LplZElllKG8Yk2FTjBCEMs7xsQasABKBXd2+4LJUTMSFYfod76xUTq?=
 =?us-ascii?Q?dD8Ej5RzTuPte5URzI/qvJ+fP0Kz8Yi/iWttNYrfZeRlxLr/pzThggs/QOmm?=
 =?us-ascii?Q?JeP79TXmNUleUKI8odHxH9wXTdkUM+d+CvhQbU5OT4ivwizlI9n7Ohfs8dea?=
 =?us-ascii?Q?sf4r82DKdA8tee8CViJRstPrStZvrxSDDAx4bYRD3j5LhX3SCC6zdrl4OXeL?=
 =?us-ascii?Q?ffBokWpUmnFKkL7/0om1yV2xoficX6n7wn9enubCybGM8y7o+0ONlOBNDj9H?=
 =?us-ascii?Q?pP6pVeZ5ADsz8eejHqeALm6T?=
X-OriginatorOrg: storing.io
X-MS-Exchange-CrossTenant-Network-Message-Id: d15065a7-a6ea-4903-98d5-08d8fa8e6ff3
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB7992.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 13:01:34.4675
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKnhWrUc7Y0ofSge3CErF4F6CL+9dUwe+njWmjl/moM9gJ2FxkbkDCoAK+uAP8hv+PHHxM2kx82A69eJdOV7JA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB6344
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 6 Apr 2021 23:05:46 +0200
Hans Henrik Happe <happe@nbi.dk> wrote:

> On 02.04.2021 16.45, Roger Heflin wrote:
> > On Fri, Apr 2, 2021 at 4:13 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:  
> >>
> >> Dear Linux folks,
> >>
> >>  
> >   
> >>> Are these values a good benchmark for comparing processors?  
> >>
> >> After two years, yes they are. I created 16 10 GB files in `/dev/shm`,
> >> set them up as loop devices, and created a RAID6. For resync speed it
> >> makes difference.
> >>
> >> 2 x AMD EPYC 7601 32-Core Processor:    34671K/sec
> >> 2 x Intel Xeon Gold 6248 CPU @ 2.50GHz: 87533K/sec
> >>
> >> So, the current state of affairs seems to be, that AVX512 instructions
> >> do help for software RAIDs, if you want fast rebuild/resync times.
> >> Getting, for example, a four core/eight thread Intel Xeon Gold 5222
> >> might be useful.
> >>
> >> Now, the question remains, if AMD processors could make it up with
> >> higher performance, or better optimized code, or if AVX512 instructions
> >> are a must,
> >>
> >> [=E2=80=A6]
> >>
> >>
> >> Kind regards,
> >>
> >> Paul
> >>
> >>
> >> PS: Here are the commands on the AMD EPYC system:
> >>
> >> ```
> >> $ for i in $(seq 1 16); do truncate -s 10G /dev/shm/vdisk$i.img; done
> >> $ for i in /dev/shm/v*.img; do sudo losetup --find --show $i; done
> >> /dev/loop0
> >> /dev/loop1
> >> /dev/loop2
> >> /dev/loop3
> >> /dev/loop4
> >> /dev/loop5
> >> /dev/loop6
> >> /dev/loop7
> >> /dev/loop8
> >> /dev/loop9
> >> /dev/loop10
> >> /dev/loop11
> >> /dev/loop12
> >> /dev/loop13
> >> /dev/loop14
> >> /dev/loop15
> >> $ sudo mdadm --create /dev/md1 --level=3D6 --raid-devices=3D16
> >> /dev/loop{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}
> >> mdadm: Defaulting to version 1.2 metadata
> >> mdadm: array /dev/md1 started.
> >> $ more /proc/mdstat
> >> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> >> [multipath]
> >> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
> >> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]266
> >> loop4[4] loop3[3] lo
> >> op2[2] loop1[1] loop0[0]
> >>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 276
> >> [16/16] [UUUUUUUUUUUUUUUU]  
> >>        [>....................]  resync =3D  3.9% (416880/10476544)  
> >> finish=3D5.6min speed=3D29777K/sec
> >>
> >> unused devices: <none>
> >> $ more /proc/mdstat
> >> Personalities : [linear] [raid0] [raid1] [raid6] [raid5] [raid4]
> >> [multipath]
> >> md1 : active raid6 loop15[15] loop14[14] loop13[13] loop12[12]
> >> loop11[11] loop10[10] loop9[9] loop8[8] loop7[7] loop6[6] loop5[5]
> >> loop4[4] loop3[3] lo
> >> op2[2] loop1[1] loop0[0]
> >>        146671616 blocks super 1.2 level 6, 512k chunk, algorithm 2
> >> [16/16] [UUUUUUUUUUUUUUUU]  
> >>        [>....................]  resync =3D  4.1% (439872/10476544)  
> >> finish=3D5.3min speed=3D31419K/sec
> >> $ sudo mdadm -S /dev/md1
> >> mdadm: stopped /dev/md1
> >> $ sudo losetup -D
> >> $ sudo rm /dev/shm/vdisk*.img  
> > 
> > 
> > I think you are testing something else.  Your speeds are way below
> > what the raw processor can do. You are probably testing memory
> > speed/numa arch differences between the 2.
> > 
> > On the intel arch there are 2 numa nodes total with 4 channels, so the
> > system  has 8 usable channels of bandwidth, but a allocation on a
> > single numa node will only have 4 channels usable (ddr4-2933)
> > 
> > On the epyc there are 8 numa nodes with 2 channels each (ddr4-2666),
> > so any single memory allocation will have only 2 channels available
> > and if the accesses are across the numa bus will be slower.
> > 
> > So 4*2933/2*2666 =3D 2.20 * 34671 =3D 76286 (fairly close to your results).
> > 
> > How the allocation for memory works depends a lot on how much ram you
> > actually have per numa node and how much for the whole machine.  But
> > any single block for any single device should be on a single numa node
> > almost all of the time.
> > 
> > You might want to drop the cache before the test, run numactl
> > --hardware to see how much memory is free per numa node, then rerun
> > the test and at the of the test before the stop run numactl --hardware
> > again to see how it was spread across numa nodes.  Even if it spreads
> > it across multiple numa nodes that may well mean that on the epyc case
> > you are running with several numa nodes were the main raid processes
> > are running against remote numa nodes, and because intel only has 2
> > then there is a decent chance that it is only running on 1 most of the
> > time (so no remote memory).  I have also seen in benchmarks I have run
> > on 2P and 4P intel machines that interleaved on a 2P single thread job
> > is faster than running on a single numa nodes memory (with the process
> > pinned to a single cpu on one of the numa nodes, memory interleaved
> > over both), but on a 4P/4numa node machine interleaving slows it down
> > significantly.  And in the default case any single write/read of a
> > block is likely only on a single numa node so that specific read/write
> > is constrained by a single numa node bandwidth giving an advantage to
> > fewer faster/bigger numa nodes and less remote memory.
> > 
> > Outside of rebooting and forcing the entire machine to interleave I am
> > not sure how to get shm to interleave.   It might be a good enough
> > test to just force the epyc to interleave and see if the benchmark
> > result changes in any way.  If the result does change repeat on the
> > intel.  Overall for the most part the raid would not be able to use
> > very many cpu anyway, so a bigger machine with more numa nodes may
> > slow down the overall rate.  
> 
> 
> I don't think it's a memory issue. I can read from similar /dev/shm
> setup at ~20GB/s on single EPYC Rome.
> 
> I've also experienced slow sync behavior on otherwise idle CentOS7/8
> systems. Even tried kernel-lt.x86_64 5.4.95-1.el8.elrepo. Setting
> speed_limit_min helps, but that should not be needed when the system is
> not doing other I/O or compute.
> 
> This I first noticed with a RAID6 of SAS3 HDDs being far from fast
> enough for sync. Also writes vere very bad, with less than 1GB/s for
> 10-18 disk sets, no matter how many writers.
> 
> With 16 writers on the described loop setup I get this 'perf top' output
> (similar on HDDs):
> 
>   33.92%  [kernel]                  [k] native_queued_spin_lock_slowpath
> 
> 
> 
>    7.05%  [kernel]                  [k] async_copy_data.isra.61
> 
> 
> 
>    5.81%  [kernel]                  [k] memcpy
> 
> 
> 
>    2.44%  [kernel]                  [k] read_tsc
> 
> 
> 
>    1.65%  [kernel]                  [k] analyse_stripe
> 
> 
> 
>    1.64%  [kernel]                  [k] native_sched_clock
> 
> 
> 
>    1.32%  [kernel]                  [k] raid6_avx22_gen_syndrome
> 
> 
> 
>    1.14%  [kernel]                  [k] generic_make_request_checks
> 
> 
> 
>    1.11%  [kernel]                  [k] _raw_spin_unlock_irqrestore
> 
> 
> 
>    1.07%  [kernel]                  [k] native_irq_return_iret
> 
> 
> 
>    1.06%  [kernel]                  [k] add_stripe_bio
> 
> 
> 
>    1.03%  [kernel]                  [k] raid5_compute_blocknr
> 
> 
> 
>    0.99%  [kernel]                  [k] _raw_spin_lock_irq
> 
> 
> 
>    0.88%  [kernel]                  [k] raid5_compute_sector
> 
> 
> 
>    0.82%  [kernel]                  [k] select_task_rq_fair
> 
> 
> 
>    0.81%  [kernel]                  [k] _raw_spin_lock_irqsave
> 
> 
> 
>    0.71%  [kernel]                  [k] blk_mq_make_request
> 
> 
> 
>    0.70%  [kernel]                  [k] raid5_get_active_stripe
> 
> 
> 
>    0.68%  [kernel]                  [k] bio_reset
> 
> 
> 
>    0.67%  [kernel]                  [k] percpu_counter_add_batch
> 
> 
> 
>    0.63%  [kernel]                  [k] ktime_get
> 
> 
> 
>    0.61%  [kernel]                  [k] llist_reverse_order
> 
> 
> 
>    0.59%  [kernel]                  [k] ops_run_io
> 
> 
> 
>    0.59%  [kernel]                  [k] release_stripe_plug
> 
> 
> 
>    0.50%  [kernel]                  [k] raid5_make_request
> 
> 
> 
>    0.48%  [kernel]                  [k] raid5_release_stripe
> 
> 
> 
>    0.45%  [kernel]                  [k] loop_queue_work
> 
> 
> 
>    0.44%  [kernel]                  [k] llist_add_batch
> 
> 
> 
>    0.42%  [kernel]                  [k] sched_clock_cpu
> 
> 
> 
>    0.41%  [kernel]                  [k] blk_mq_dispatch_rq_list
> 
> 
> 
>    0.39%  [kernel]                  [k] default_send_IPI_single_phys
> 
> 
> 
>    0.38%  [kernel]                  [k] do_iter_readv_writev
> 
> 
> 
>    0.38%  [kernel]                  [k] bio_endio
> 
> 
> 
>    0.37%  [kernel]                  [k] md_write_inc
> 
> 
> 
> 
> I'm not sure if it is expected that 'native_queued_spin_lock_slowpath'
> is so dominant. Seems to increase when adding more and more writers.
> 
> BTW RAID0 does not have this issue.
> 
> Cheers,
> Hans Henrik

Hey,

I'm not sure if that helps much with your processors dilemma, but I'd like to confirm your findings:
I spent a while investigating raid6 (/raid5) performance recently; That spinlock is indeed the bottleneck, especially when you go beyond 8 cpu cores.
I tested some io workloads and found a limit of ~1.6M iops for rand-read-16k and ~100k iops for rand-write-4k, and a limit of 1~2GB throughput on seq writes (e.g. 128k).
* For some reason I get only ~1.2M iops running random-read-4k.

The bottleneck is originated in the device_lock which clearly dominates the code - even in code paths that could, in principle, run in parallel.
Actually, I also spent the time "defusing" that lock, and I have a p.o.c. with ~1.9M/250k iops (rand 4k read/write), and ~25GB throughput on rand-read-16k.
I'm working on making this p.o.c. ready for sharing here, but meanwhile feel free to contact me privately for an unstable version, if you find it useful for your needs.

Will update soon anyway.
Cheers,
Gal Ofri

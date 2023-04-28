Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A494CC77B60
	for <linux-raid@archiver.kernel.org>; Fri, 28 Apr 2023 16:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346227AbjD1QcF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 28 Apr 2023 12:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbjD1QcD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 28 Apr 2023 12:32:03 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9C41A2
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 09:32:02 -0700 (PDT)
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33SA6ePM010373
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 09:32:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=sToafR+DjZYMFKBP5rSESR68pbNJOliFsLNlSrhrtB4=;
 b=k7qh3ON5/fHZyL/iazp1tLjrbSQRj1hg1FkBJ8ye3CGUMZN+VyjJO1TBKGubBizS66B/
 vcA8ykjztgsUxwQR5axkchNBFXjiZRDvmfLdj26ansHXPUFryz7AtD/RHVy7K/9DmUKj
 gG/3o9tUc/xpXCSHpZMdB2SBtZk/afQ9mYqnJhxbMBlpcpTKd3QEO78DLLIGDzZweS+T
 64z3XxOOpQWyroTGjB4C0mGocR+nEJfETDbas2Ui4W8vBPpY6P8oy7k8Q9zEbKcwhEQS
 AFKArGoDyyJhOnlST4ydA37NtvkDBnVs5K/xdj1EdcQLi9aO6nIuZcNp0DwWVykReW5J Lw== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3q837unhpu-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 28 Apr 2023 09:32:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LoDcFmFOlOjxfJfAV9X046K0LY88XSRxi8D81gHDd4MPD9XSEQ3nWI3YHUP81jXQwR5ZoKdcLodyV51sLx6KDEFZ8+LshRyRxoItK7/1TfEHlsz+nkBQuFavi/3stKD+Kv+bbx3i1U6R7J2oWw3x4sJYr0Nxud/P+MkH0xvLZsZvFX7tdBKjaK6PLH3+StjAmfUpbdgXU5l2425zhSwan58CkzGBzzBZYuIEQZiAdFM58aHI5xeDbDFx/BtgtWH7z2Ro1jpTKJl+dTSTYIP5QRbN72dIVxvHORN1t4WmqRKxq0D5V7lEppcBPfm7J1/rBssjyER9pHH6ZBItOV4EWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sToafR+DjZYMFKBP5rSESR68pbNJOliFsLNlSrhrtB4=;
 b=ilBTEETHuJU+J1TfjhkHxkux77hZX9P5bSSLNb5A5iO4t5+wDKuHP8lwngJpi3T/Yoo+UDFvRxcDOIwlnFPxeg2ScyhB00vrB4AlvSww5eKOIQFR24xCh813SoMUF9T6lLuhPg706vu5iEstwY/POaFwYmDw1PfSHau+gyZMDnWYlDLLZXMgO7HH5Y2CLZZ6BEPkhxDy6QM4okjmrmPWQIRPsRUwWtYNqoBJRJksziNWsfGqhR3g39Pic8N9XZbo8WlYP+opERBd1WMlwPrWOfoY2Z8UoOcU3i+gJ5OKO3CYiVDNJZ+XVZ86aE3Y7OkAJhh8VzaXN8OCJfLR9VaOQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH7PR15MB5149.namprd15.prod.outlook.com (2603:10b6:510:13a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.22; Fri, 28 Apr
 2023 16:31:57 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522%4]) with mapi id 15.20.6340.022; Fri, 28 Apr 2023
 16:31:57 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Jan Kara <jack@suse.cz>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        Yu Kuai <yukuai3@huawei.com>,
        "Reviewed-by: Logan Gunthorpe" <logang@deltatee.com>
Subject: [GIT PULL] md-next 2023-04-28
Thread-Topic: [GIT PULL] md-next 2023-04-28
Thread-Index: AQHZee7zOFzT1s8210CqR3pH8GatsA==
Date:   Fri, 28 Apr 2023 16:31:57 +0000
Message-ID: <64602C04-36AA-42D2-A6CE-6039BF4D8EB7@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH7PR15MB5149:EE_
x-ms-office365-filtering-correlation-id: b21c1cbc-7d4f-4fba-de4b-08db480615b0
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XrBnC+WKtdn1GPJEbyJxZL/gnpK3xkM8AZNFw7qrBf/4afSvKFEiqDrWl68hWDXw5EFyg5iuCKdAoZkTQXBpljjpHb6PUG/jaWjIbK9S6luvc/H0BQLpUnp6gpbh+q3r8tgqgceJ82aaD1g2Hpv9cHC6QHIdwjK1VcuxZ2goiF4kHIAJ14GxbX1l1gijY5wKyVzxs8PKlTN7B2HsMYpCL7yiuiDAFAYA7jBm7muU9+KHda8Qn6mSwNPM5CD3PWJQ9e9lrPRAyAAjghUf6Ck/xZVdt7f9IeN0YcQheSaEV1bzdgbCMsW7qtiPezo3mLe+CPjPdClqfWeRFdscYW4jnESv93hxoauOnszp2rQzm2HUozi0doaASB44DZFzGDQr3AyzWYuwozLR/+q6j5PkcoLg/NThT1Mgvilc/WgriYxIuKwfAwH+Ha52zhhXSlZ4BLdjmCKA+4Vxq8dswSBZJZYZmdevPapC5RklVu7U4rdbH0wu+Nz/+5q7C6SbhQ8vKilvRBr0uDgZg6Y167GMpI2aS6hyXusTmGFlwe3hbHMkfZWjJPskpQukEC0K7CVhKNqo82mKTONWDblFzYf8FOdxs0WE14S+xNsXZK3M6PY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(451199021)(86362001)(41300700001)(9686003)(6506007)(6512007)(2906002)(5660300002)(966005)(8676002)(8936002)(36756003)(38070700005)(122000001)(33656002)(83380400001)(478600001)(38100700002)(186003)(54906003)(6486002)(110136005)(71200400001)(66556008)(66476007)(66446008)(64756008)(4326008)(66946007)(316002)(76116006)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?22n544bcKIqvw8NJ7fs5Yl9kyb3jJ/Sp4nIM4UsJJIkaqrIlpIC8dkah6086?=
 =?us-ascii?Q?m6IWqy5skYk5reY60a5zwy2AHzacHorXWU22SnWmWRYQQYo9lpKezD1ow31h?=
 =?us-ascii?Q?81psUUndzfdudqxqFhw2wBtua1ynQgAz3mzrIzLzyAn2xZWodgB1ZuVgksb0?=
 =?us-ascii?Q?ULKvUgi6JIwD3KX9HfjVgoFK1jJqsibI69+o9vffYELq1DIU/oVErJA/Rgn9?=
 =?us-ascii?Q?LSNApGmHJRf1HqPZBjLgOSjd/WWGy5MfP7zk7A/U66srIVDYjtDsAZqiV1dn?=
 =?us-ascii?Q?8PXuatTKiMqWmmblgFxU5mV4uahlim4b4lzJmzIiELHgoBsDy1sFus+xMGYm?=
 =?us-ascii?Q?M7Fe5XLiL2UPg26THBL9zio/pVCU5EHjST1UsOrV02g/X9VjNE8FRksuqFD5?=
 =?us-ascii?Q?fJ34x0sROl+0/n58lGBBf6WxVrJiPCEknfnLMnGWoAngkjjgeB06PAcMAgcu?=
 =?us-ascii?Q?tefjFKVmCz1rzFsvc5L+PkbaVUOor7fjNvxpveaLR/OIaeZnDy7Hud7O5OgV?=
 =?us-ascii?Q?4pnxfGFLfxc3cRgDzO7EC7bfz/e54vJpCYD7hNuArjsxxr1fgdJcfoZN/x0k?=
 =?us-ascii?Q?dM5zTMJYUagekKWCblLY8801HQzB/t7Un81wMSgwFj/j4LJPWkgWYSsdpbV2?=
 =?us-ascii?Q?+r6S+yolPhTR1GC7AmG0fzr5Ste8BuZPTS3SUIr32osBVObHR+qGFg3PhPnk?=
 =?us-ascii?Q?NTfbL0Dgjo4fKiuVrzZQxFf/qM1qAIzvwqtDR99KXXws4f/PG/+fs4jCqVhh?=
 =?us-ascii?Q?8DscaO5Dmi+y+2Qhi/UQ9UAKuU33y0oF1Jzf1jw9zTLKs4AmNM7z0He05S16?=
 =?us-ascii?Q?nldkmAaF1PEmLEGDMAaKMHYNql5A6MIZQnX0xkZS81JYT6St1xKuPoHeCCjR?=
 =?us-ascii?Q?y8RbV8EsANq8VlHXYPv9BVF+NkRfX3S2zFti8D6xtEqNnaiSpW0GqbDZSN8b?=
 =?us-ascii?Q?3TYYMxIJcVHIJiAc8NKYQiRgoNzirAEl6U1r73wzPZSCBD5rZQXNm3Yh5NOl?=
 =?us-ascii?Q?GEIh6WCJ+irXciQr4qSsqL8cTSQzYO3dUL/CePn+WH/ivdTwL3YB6NHVasbD?=
 =?us-ascii?Q?Lvw8y9G0lefafmpJSJS4yHXrwPpXD4ESY8eVcln3os5yzGEnRcVVufiWfq89?=
 =?us-ascii?Q?DB6W/HDW6oKYwYKblRQB5M1mmaBCbCMZABzR7aSmQzBduYdIE123bhKAfpN5?=
 =?us-ascii?Q?swPmYMsOs26AxWasyECi1qgB2BGJ0oTXfPOVd6UuiWvheo6epEOn5T3gLE4p?=
 =?us-ascii?Q?laD64h7pu6FFxsI/GYV9tCNlfPvDTE2p3xgC0WOJ7A+17/GD3vj1j1jFzGGj?=
 =?us-ascii?Q?/ByeMs+CAMpIq0QFF0E01Jbu2adGSY0xl48VCr8nM2fOjgaHTGF6IW52AgcO?=
 =?us-ascii?Q?r9pBX+vMn5tjMeDxc2uq6Uh2Z7mopCm6oFQu0Sq2YN6MQaQrTLAjpYnaPcvl?=
 =?us-ascii?Q?r38EmBiiyUbnFY9ODstwL8unCdalbGfpJnsX5jQr2K/E2zeSaxm/VYXnSqM1?=
 =?us-ascii?Q?FzFvgAgFYT6fNQhijJxeW0fejZgcoPvKi2R1CeAA6Vgy/AlpgqVmrXmizyOR?=
 =?us-ascii?Q?mJwPWi39vtbdmyjXtY3dBZrOAZPOzKOkCCayN84swHCDUX8/GAIV/qNzYK8Q?=
 =?us-ascii?Q?C5gZ542zmVbJm6vRzuoqENg=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1C3D39C2DB05A04CAF2DD312A8FF6F0B@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b21c1cbc-7d4f-4fba-de4b-08db480615b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2023 16:31:57.3538
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HBD2hVml3Uj1dGkjW7TcsAQ1POQe0nrzrawuF4QhMQBHPDLEZvlgxosxqzQgUjzgTU6En6AWNsanmjcsj3As2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR15MB5149
X-Proofpoint-GUID: zHAmuFB4Mtp3hYRt185ekXQj6PeP7P3p
X-Proofpoint-ORIG-GUID: zHAmuFB4Mtp3hYRt185ekXQj6PeP7P3p
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_04,2023-04-27_01,2023-02-09_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes for md-next on top of your 
for-6.4/block branch. The two changes are:

1. Improve raid5 sequential IO performance on spinning disks, which fix a 
   regression since v6.0, by Jan Kara.
2. Fix bitmap offset types, which fixes an issue introduced in this merge 
   window, by Jonathan Derrick. 

Thanks,
Song



The following changes since commit 952aa344bf4305ab6fa0d9962ef8c2caa2afef4c:

  docs nbd: userspace NBD now favors github over sourceforge (2023-04-27 19:15:11 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-next-2023-04-28

for you to fetch changes up to b1211978ecf19bceb63a04f53fea4b5d73832a4a:

  md: Fix bitmap offset type in sb writer (2023-04-28 09:21:06 -0700)

----------------------------------------------------------------
Jan Kara (1):
      md/raid5: Improve performance for sequential IO

Jonathan Derrick (1):
      md: Fix bitmap offset type in sb writer

 drivers/md/md-bitmap.c |  6 +++---
 drivers/md/raid5.c     | 45 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 4 deletions(-)

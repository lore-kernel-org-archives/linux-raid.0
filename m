Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB958C74A5B
	for <linux-raid@archiver.kernel.org>; Wed, 29 Mar 2023 18:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjC2SxY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 29 Mar 2023 14:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjC2SxW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 29 Mar 2023 14:53:22 -0400
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DB055596
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 11:53:18 -0700 (PDT)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 32TF738x031050
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 11:53:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : content-type : content-id : mime-version;
 s=s2048-2021-q4; bh=audrXtwljcmsrKvuIYCmzLeDi9aZrJKDfugmRF15ReE=;
 b=jZeodNBZP/vMottdRI63uBHEAnzMoAFSccBAYVeeg+qTOKnpu2h/rf5Q1hWR0xDdx6xy
 7RzoJdEVikxOcZl3RUQP1VfPjG/0mLb8Tiw9RDsA9u5iLDNVYYfYtKP8HvgDbGy3185R
 dsHb2BfddaWexXrW/eHVNMOsM+3ejjpyopOlEPqMcAy88pANCvzXWVG08PEOBhArMHM3
 2L32/GVsb8FckqHyGVRVIiI+XMcou96kWOnhRFSdUhy4sidxTmQft13onr749h1dtLK0
 UVTpa5UVGUSF5ubXPJBXM9eeDsXJr+Hpd3EKZYVaY+wqkBjq3wu+uJw8OUwqmVSt/+QS ow== 
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by m0089730.ppops.net (PPS) with ESMTPS id 3pmcamd2h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-raid@vger.kernel.org>; Wed, 29 Mar 2023 11:53:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUp6u1vHwrVH8PSBOJqSJwUPlpG5TpWvKxQaUPWSdTrZ68n88RIORVFUMLBkQX2rslN2cGqdsMG0PYIgxRJ3K9eUI3Yocmp0X6VJfplxQUVe+Wksu2ud8eb/IhU3wHjkaEyKk50zhajpx6CZNqRrGdBiHQ6JQyAsGyG8Lc7Wjez96ixKDXdesO5zAZiqhpO67LBeBz+J3mlE3zjzENpV0rVmn8ByANBaNs+b1/tTff4YpuEfrxxT6GVAKEGzx2tx1dTdC/EZV9Gk/OEkOfz16N73HCfcrbAbLTM0dbdqulCuBSVyjdwJnzziplabJtqUimZZbf/OBt+BU1gamVAgFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=audrXtwljcmsrKvuIYCmzLeDi9aZrJKDfugmRF15ReE=;
 b=ObBjog4xD+wb2BAclfn1kcwpTJaHUsshcIAh58QTevoZN3rV/cE7VdbM4ldsVgZusQ1nOlyygqhuV4DaCa4t2iAdiH2LfxkEHmrhdQAElOMXXu/d+Kwq19phi1T2UmWftfuyShxS4amaJCWob277xWEznHoUmlDP3gfKMhEpGDVw8/pjzKPx1VWcvtZdQ8TYoJyzvnENNxCA1Pk6WlHyCq17o1myQVlaQkgbYGW170ie4Tb3b2/wBk/U9lzIFcp7cZ8HXdRf42ODkEpU2F2wPT+6du9sAQVuISxnrPv92sLsQLyC7OoTiH9MC7L9AvcTS7CZRu2xKd3svBqWwnm1vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by PH0PR15MB4445.namprd15.prod.outlook.com (2603:10b6:510:81::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 18:53:13 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::e868:d4eb:382:e522%3]) with mapi id 15.20.6222.033; Wed, 29 Mar 2023
 18:53:13 +0000
From:   Song Liu <songliubraving@meta.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Yu Kuai <yukuai3@huawei.com>
Subject: [GIT PULL] md-fixes 20230329
Thread-Topic: [GIT PULL] md-fixes 20230329
Thread-Index: AQHZYm+3SwFeLojBSUe1COTVbkU6fw==
Date:   Wed, 29 Mar 2023 18:53:13 +0000
Message-ID: <B94EC4B1-8772-4A2C-A454-625B661C03B8@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.400.51.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|PH0PR15MB4445:EE_
x-ms-office365-filtering-correlation-id: fb2b88b4-15fa-42ec-88c2-08db3086d996
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q9tCWeWN9yzAvCAaeZmqw05lZUNIFVtka9qc9+JkR+OcxE8tr1kzurJv30S8btu9nYU6JyvzHCGDyDnUfMGQ9KlJj5tz2hD6mtLbPc3YippQYiKnMhZWC8DltRClNYxjwksV28xfVQaQDvCKvRH+BIe1JK2PlIO6V/xXC+Jgm360PiEmS1tXlbCrwK8xzzfgCuVjy3jo7aa+f8UNQZ3cT4zoJs6LrJ4fdMsWBLc4pQySmzoJpXV1fFARRtaCcoq9FTI/FpTpEj7LImkDZyx6BzneI8xyUQJzlMQsYRXfV7zgHD+yfBtqgnehtTAiDcgbn1bwVSy5lIfuTlGqUrdLw2kAx4qP9GbnHFMyoYFNpLztV91Bl48MtrjFGiE94WByFm9c5jZP+ldIk8JYPtLx9Mhqnk/jV++FRYitCGI8HxXW3COCdzMmqdrUXXDDj1YNvmqJNiv3Ztz+f2IfLHhJ+oP40iZuRb8A5t3NdEd5LjnNGVBKDSD3IG5EDsXlg41SJoiGffM0IPoyfae3bzhMuxrkNRoq+W5xtUHQqxO5UqSY1SIXvans3Lhc8o1KVat3Ijsj5Fs2k3qe8ZXVzpwcn9FdS9DVqnYVpLhdRq/wkQQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(366004)(451199021)(4744005)(38100700002)(38070700005)(41300700001)(122000001)(8936002)(4326008)(5660300002)(2906002)(86362001)(33656002)(36756003)(316002)(478600001)(110136005)(71200400001)(6486002)(966005)(6506007)(6512007)(64756008)(83380400001)(66946007)(66556008)(66476007)(8676002)(66446008)(186003)(91956017)(9686003)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dlU7wR+yqZjkUfLpDZGHuQrSvloZjkUJGFWlYfkMDneQ9hBQ39+WPTFpM7Iv?=
 =?us-ascii?Q?xUnfFD6gZ7vwRcTvYzqEe5lMjzd8VGITjO6CqgIN/k9dOF+yOHPh3EPY6Rg6?=
 =?us-ascii?Q?ktC6EFjrAY1ZQuhW2Lw87vWYXfa9ImPBr5c5hOB1zBQouCeRl2MRo1SXGXJL?=
 =?us-ascii?Q?lugNZCISEjP/fWuvkFQ2rPIgSWCCj+SCU4xbEtjBffaVBmoIqnSvnJ/RItjm?=
 =?us-ascii?Q?cM7aLYuRQZYxzD3J54yeWbLhP1nioS3bqZwZJtVu3kk59l6LFOUFqCdcRPlK?=
 =?us-ascii?Q?QnQj6MW4n6NcpiN0t4xqj3V7xu8U2Wns7rFsMfrqPWGZHqIt1PtoFizPOW56?=
 =?us-ascii?Q?f9vsDjHMAP9KZWHKsMWcyD3hGbhbebXLg/VTXHMNVvN9IwRBxtYlYkQtFrca?=
 =?us-ascii?Q?EFvb65R0aP9fIEjCloVEOGFZBzXNfBvaRZnfUxHaMm4rzT8Eb5isYluaE3Em?=
 =?us-ascii?Q?t4+cw9FaxBOcj0ZoyEOuVa+ocvV8qVy7wfrxfZySYadsvviaDMP3gTqYCvmx?=
 =?us-ascii?Q?KRjp8rtXNjABtQTo2wLeMrVpBdNYs4vCMENaQh9sihYhkLrHi2hnVz4cQ0vJ?=
 =?us-ascii?Q?a3AaK2GfWLpHcTf2pVfk9lvf7c4vM4Pu39fW5aeoNI7QsiG+pwAOSjNVNaBz?=
 =?us-ascii?Q?CU4cnTN9MMBEhlkv7IhwF7Fs88WPhpfYZhFOSTmaxJxnE5OtVVKrG817poai?=
 =?us-ascii?Q?rWyjZc3EVVMsHYomr2IFiC6Hs7Jqa1PfYLiB8ya7uqerZil+Ii+Qd9Sv4wlN?=
 =?us-ascii?Q?r8oYB6AV/zkuSmtRn6iHRt6wSKaVQ+1Xl4YMC5AphKuSY3HcA4vu7U9AvtNK?=
 =?us-ascii?Q?mc5zqi+vgl+PEOCqcI7j6enwRUqfH7/4paSech4+Fo23tDWryTu/Xb3nUydF?=
 =?us-ascii?Q?Hd6cegnsG5r8j8qq4+qRL0ftIjBA75stDlMrqohoB2zDvvtnEd91kBULVcVC?=
 =?us-ascii?Q?5CF4GQ/3lcjAk/2oEwePNS938ggTc7w+mIb26PVFCqwoAZlx3i8qjpvz5MYV?=
 =?us-ascii?Q?9ELClSrSTimHhe+LBXWfKjxkVuo47Gulnu4q2VcuvOa1Yneh4WrGyikbpZpL?=
 =?us-ascii?Q?L5SqaQ9htmHkGnpKwM1qR4X3gVGAPK0vmKzYEqaZdJVDGmkXUvAhPZAWcN6C?=
 =?us-ascii?Q?0di9lOISveCzJHWOH+h0aWPjjjF9boccfDR5GZSwgF0QPSrNc8apAShaAso6?=
 =?us-ascii?Q?lkpGmhKy0gGAbYP/4PpVsuFeZRa9/KSL+Hi9xI8gdv4C3cU6Zcm7aYIIcm54?=
 =?us-ascii?Q?9+rtT/NBtzWjKuzxrPw5Zgd9VIDv1ur2O9Vg/jHMmyeV04tNEWIGkzJ3KmsM?=
 =?us-ascii?Q?QX0x26NnNSFmC3SRo6qrC/gWBoAJD2+eXuqigPY9X2c4dCa4u1ZWT0LsItXj?=
 =?us-ascii?Q?7LZwER7b64VHTyRQfOvNCds389QXv80ryvvWiunFA6S2l62nsvq5S4j63xPg?=
 =?us-ascii?Q?NhPneYRCutxEFuEEvTh2QA0pjm4YdCIZI9+RK93JoBL9Hx8zRNBI5XSTYfdP?=
 =?us-ascii?Q?re2OyfrgZc14FUxZQWKgGIciZ0fZC/o6P+oqzUmY4fFtmNnBEUjKNkm8ypiN?=
 =?us-ascii?Q?6hYcr2ypc/oxb51l1QCfTnLrVP9O0NcunPMhFbeeEh0wP/Sn4pYsDENGofj5?=
 =?us-ascii?Q?oHkzotEWDI0LdENluQqp9Cs=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DA4E3A8D3A6D6468DB82FCA0628304D@namprd15.prod.outlook.com>
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb2b88b4-15fa-42ec-88c2-08db3086d996
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 18:53:13.6971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eN7akquSx9KdGd2rITpDTLjyyOpE3PVy4kg2xBFnBEPdefZQ5vokVobKr9IpfjjB6vzenUjIj4YgyMEU37H5dA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4445
X-Proofpoint-ORIG-GUID: MBeJ4alF5QYS76T_wRLn5yinPz0BOVtu
X-Proofpoint-GUID: MBeJ4alF5QYS76T_wRLn5yinPz0BOVtu
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_12,2023-03-28_02,2023-02-09_01
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following fix for md-fixes on top of your 
block-6.3 branch. 

This commit, by Yu Kuai, fixes a null pointer deference in 6.3 RCs. 

Thanks,
Song



The following changes since commit bb430b69422640891b0b8db762885730579a4145:

  loop: LOOP_CONFIGURE: send uevents for partitions (2023-03-27 13:27:06 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-2023-03-29

for you to fetch changes up to 433279beba1d4872da10b7b60a539e0cb828b32b:

  md: fix regression for null-ptr-deference in __md_stop() (2023-03-29 11:30:20 -0700)

----------------------------------------------------------------
Yu Kuai (1):
      md: fix regression for null-ptr-deference in __md_stop()

 drivers/md/md.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

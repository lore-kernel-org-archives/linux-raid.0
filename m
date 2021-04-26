Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE755C43460
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 17:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92C5361026
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 17:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhDZRM1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Apr 2021 13:12:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26448 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236135AbhDZRMH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Mon, 26 Apr 2021 13:12:07 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QH59iB011234;
        Mon, 26 Apr 2021 10:11:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=GfQwymdLXqKe3Undy0xak9wsX6TFLLl7hZez9gWC3Jc=;
 b=ERSckBcsI1/p40aSQo1EFdY6gFh2lAeP1Vovu7dnO0CA6P62kZroYVjzwa0BJI3O5Wua
 U5PFsmwuMIjHvltXQ1dnfyfpEfwT2e39V0Cu/ucDo+WJBIG1KXzVxehm385Mra99lVeC
 +D5tUAEv9wNO5xDYbP3mDTbd4XrfM1rVIag= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38535ypn24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Apr 2021 10:11:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 10:11:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZCpnaKs6G0rp8GEePJlD4gYjg4Fz0JpIXT+xEvSBnwGzcuDW1rlBq2uKb9oMI+ddhupar6rYvk8fqUQKlxf8brWMgb11HqdVEt0tFQ2q1osYyPwoZT4+LApfUmEr/rYeuuqJfJsRb0WzrPwPAyw3jajLgSRhmvNPfCq7UI/4f408e7ereOPvIbKm3Y4fMw9l5OUxIyjZ3FT9IPFw5et6y/fk09OC1XspgA87xmGr1dHg668TPMdy1hhEnDv5rfqPd+K8+2KqYGonqs1Q14/HvK1W41o0/a1zcUmLDdljSIFScGrSMiK17f9Xwd/HrhiR4MyIL3E/FL/A1Fh1j9bC5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cqwgW07WGlTng2ob7TBXwp9tucuqbuv5pDo2Ab1IaQQ=;
 b=ZOJ9KKwHjDyIM/YYwZYqvILLlRjPZtvZvG8yF5pTZlkiRRUh1qAuQolpkDOx8YPxcU1N92kJBn46D7Y7pbkZAir+tu+cp02NB+p8YTZ0g8p+98JVaGVEuE6dENr0sJ4xSFAgt/BMokqRshDtzn5EBpN9ccxTUK4vGTTE5BoegkZk52hhpolE79nj/hJiN4bbPfTCPQgDqDreud5pytQGIe4cYxH6KeNakXEqiHnTXh767zKguM2aIAwAZi5V+33gCE2I78rkPU8DDgjyhGpcN6MRciaojTVJq+4pjejswZoOLlUdwlWeu6yvqjlj4Kdw/tBb7cuBclzzuadwJt65lQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by SJ0PR15MB4203.namprd15.prod.outlook.com (2603:10b6:a03:2e8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.23; Mon, 26 Apr
 2021 17:11:18 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.040; Mon, 26 Apr 2021
 17:11:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-next 20210426
Thread-Topic: [GIT PULL] md-next 20210426
Thread-Index: AQHXOr8spy30KKd++0eDWG0MDGQQjQ==
Date:   Mon, 26 Apr 2021 17:11:18 +0000
Message-ID: <0BF1557C-1D28-4C7F-833C-FD57623D6F17@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:1382]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f834e0b7-b6bf-42db-1c1b-08d908d64ee0
x-ms-traffictypediagnostic: SJ0PR15MB4203:
x-microsoft-antispam-prvs: <SJ0PR15MB42034BCEDAC3C70F60B62AE8B3429@SJ0PR15MB4203.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AbHFqjcVs8eCk+ck0znamvBC31+TCJS5DvIwmzP27EcmaZvqTxsyhbtVNR5fIDIgAK8HcypbmxFa3IxdQEX7IPgA/BdKVZvGt0B0I0UEl8TYhpN8U60+pq49WG2SCtpsHhT5F7y8yc6udXxr+k0sLcwsfzPPpQkaip2rEyDyPehuOLLL73aTrNy7Bk3uYcxgXuBsMwZuCaVNSw64uGE4ydlKzEZIm/x+FJwndpFvL0v8UbG00YMU8HvQhxLG5urQ3uRV3N3lzYyb5RbLO2VY5qplPijPshjQuJf85CjjKMG6sAHZY5hB1wf9WvUPucnsQxafi4Ahu+xWVBr/GlylqIBKdXULFiGBl/DbhGetBmBJ+aKbbj5VJkE7VyFMZp5wHvFtvYcM/1Wn076vmlKGLoHaFehp09g1ZREWMZy4405qDqwww6CaKaIC4egdyi91oKZieJBUJ7TZ52VphdMnmbHrpAgeYB2EjZh3afwxH6tSxmxp8/xz8w2cITmS0ZcIPPFY5nU6RukQxxNWGls4LilNje/o91UbcMy+ZpuxWuVUjcSjm4zB4EaZggwzWiRFAfykEuBDyU3Q/R9qFR4gPInEv/8B8v8TCjPdpyYIcDNR7M/0n6ytTOJghLRbzRnFzkS8aMGHWpC53bmqYT7PJ10fYpO+6mcIBoXygKc0WKZub6mE2q6KST2iM+8NitrUIN1z2EgQCke3g13C32b6Fi4Aidn85m+4zQJwwUZHkeA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(366004)(346002)(136003)(6486002)(76116006)(2906002)(38100700002)(91956017)(64756008)(6512007)(66556008)(66476007)(86362001)(122000001)(71200400001)(83380400001)(6506007)(66946007)(4744005)(4326008)(186003)(966005)(36756003)(8936002)(2616005)(110136005)(33656002)(66446008)(316002)(478600001)(8676002)(5660300002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?oXlKCp/2YF9QR0CR/2HU80jKmcY3rq4NbcpcbVZijsUlggW84zp98rXQB9/u?=
 =?us-ascii?Q?BgYptDF41wx/IGa8mCbBFehB+46xMR1Rc0vW0b5Bkku8hsqjORZXMALbm/AN?=
 =?us-ascii?Q?uYGV0bKmuPJhl/KQKO6SV2BqZNaWWP4t1oJM8rTz9cbPGfjcH5RhCclEmJus?=
 =?us-ascii?Q?U+TSSJ3hLuyk7qfyvMQSBxSOyLVYS+mdPTIp6nuUzEGzmkD0LQ2Wh6stbPsI?=
 =?us-ascii?Q?yno9/f9gxSPkXWKtEW5v70RacOjoC1AX2iZP4GUJ1MLOSLmcGLznr+5o5K9v?=
 =?us-ascii?Q?zrUYS18hfddjZI43NdlIcS//5GvYbqF71VVsHFoLoTRodiGXNL3ZBu+w/JGq?=
 =?us-ascii?Q?N3aD5QrizlGa28ZXJEFI1AvqeHPKYXdLZwp3FOUKiczwd1z5117K1T7E5Jbw?=
 =?us-ascii?Q?NgBBTQidkX2HHA7DFFpu7/qRXGtfcf/+ciCjWVMsNW3hg5xMX9cGTLLj5xBz?=
 =?us-ascii?Q?16EcPPZx8yeJur2poyfzWwc7g7AIi+H+2XfxT+fX++xPQ/UcmBVtZ33S2nn0?=
 =?us-ascii?Q?7LnSod1uJhtCxZnwJN7EKN7rSmLHmhdvkK+CJEkhzE5d6xdzg+WIpePBbhpv?=
 =?us-ascii?Q?MF8fqlKQ3GuGXQMEWj2DU4Y6b1Nz5RtPDxwGhveRNT/T33luuGkU4xOtHT/5?=
 =?us-ascii?Q?oDdZcK3t7n1fjSkQnGzXx9UIEyjnewQTwWIUoSbqFdZ3MSeB4e6z/rkH6Izk?=
 =?us-ascii?Q?8kDzXeCVPG2wcHEtcG/JK8WvGz6hFE0A9HYaNFmGM0AMxPX9cb40InfEs9UP?=
 =?us-ascii?Q?hVgGyN1KgGXF/oLhy3HBwoJNbncsTg4l03Z0BBznSpE0372zYJc8I0z0tGaT?=
 =?us-ascii?Q?O4Rfq0SR5m9H7MCpo5QjVXA+jZhIkrK8oUX9VTp0VcdfonO2XbjvA6dVbCLf?=
 =?us-ascii?Q?IMoGj6VBMr2ILfTWzDpMac5Gce3pFQgBxCJrYwkdxmt7KgZjpu1f/JtoJ1aF?=
 =?us-ascii?Q?oZxGSAywJAppRnJ5gS9sWdm/ZixzEm5txc/4clE+7WWymI2vRWhBcwRjYCIV?=
 =?us-ascii?Q?GG7gGXoq+mdU5UU78qEGrNhlDcp9XZMMXQgxYvOZA/+EW+qaeMHDfBHRgk6d?=
 =?us-ascii?Q?QjtOxTaNCI03PzmCHu3adqMNxsOHtqOTOFXhGA/m/cbw9QBZtKdM+2r047+M?=
 =?us-ascii?Q?n2wtVSl3hL4DwuCv/cd6sjnBpoMk39JlTJSMNRLbBmvDsGdz+CfmVxomqHyA?=
 =?us-ascii?Q?s4iSvtoOmT4egyXQjgrvaxSxPEHco15G2KBcpsRsX+8rdLYoWqYijALkfnpF?=
 =?us-ascii?Q?c6tHB7ESaHZc0cFw4xatrydLgpaKi6y39JK1dxj/jCHhczQZgmg5N2TzRdM2?=
 =?us-ascii?Q?oHrJ6C2TLYB4jvvZ1Vb2US3e5OowiTxv6iZfQjBv4KKdrHj0BPIbTiDlojPz?=
 =?us-ascii?Q?Af5jh6I=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DEC498970B18704F998816F9A3823236@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f834e0b7-b6bf-42db-1c1b-08d908d64ee0
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2021 17:11:18.7270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZObqHs3hWLOMV9+NYItw2RZ78jrnE8X8mGx9udRVKsPzccADzD8mdHtjv04a27BRWqNe+FEAm/v+4bkz+HQFWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR15MB4203
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: Y2FcIdn-kCrFkTaTLFpVrXFoeIvvi8TL
X-Proofpoint-GUID: Y2FcIdn-kCrFkTaTLFpVrXFoeIvvi8TL
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 adultscore=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260132
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following fix on top of your for-5.13/drivers b=
ranch.
This change fixes raid5 on POWER8.=20

Thanks,
Song

The following changes since commit 72ce11ddfa4e9e1879103581a60b7e34547eaa0a:

  drivers/block/null_blk/main: Fix a double free in null_init. (2021-04-26 =
09:04:40 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to ceaf2966ab082bbc4d26516f97b3ca8a676e2af8:

  async_xor: increase src_offs when dropping destination page (2021-04-26 1=
0:06:12 -0700)

----------------------------------------------------------------
Xiao Ni (1):
      async_xor: increase src_offs when dropping destination page

 crypto/async_tx/async_xor.c | 1 +
 1 file changed, 1 insertion(+)=

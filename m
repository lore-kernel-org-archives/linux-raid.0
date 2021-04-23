Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0B9CC433ED
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 16:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B8F613C4
	for <linux-raid@archiver.kernel.org>; Fri, 23 Apr 2021 16:53:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243236AbhDWQxu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Apr 2021 12:53:50 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51984 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243229AbhDWQxt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 23 Apr 2021 12:53:49 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NGr2QW005889;
        Fri, 23 Apr 2021 09:53:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=evtuPaelD6WUm/WO0HoSStQJpi2RmyUTc4z5/pbB9zI=;
 b=jz9ZFWaB9i4mgswR5SWJlLUyHKay21zGXq7Gl2lBBc9kItIeMYUMYtFmeGhC58votIWi
 tce3R8bvUecgFi9JGSlLL1PXey0u70DgcwKmEUkFHj2+8+qnEOaKvmE13UU/N/1bs8wQ
 tWs/BKAmMwRj6X2YDfkp+vigvjM1YZwMYII= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 383257a9h2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 23 Apr 2021 09:53:08 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 09:53:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BdmcHroM/UHfhApJ91guDjh8i7m7wGAXuTZiyyHAocK7QKLLcSN1JGo7nWA0K4bscniVI8POvl1KoJW+BMrMmj3bD+kOa4IlbJ0bFpwGYd8EEeSLoDTJuDhjYH9MYpmGhGn/LjoocSJC72JeWokouqAfi/rFOLL1G0rZWNkG3uUKLbN+t/V9ccctnoiOMtQGTY63rTIeN2Od0xRZiqoUdcnima29gxoRFAqZRmoz5isdazblicvTePEpdCHBfd7BXXKYKGOqIvtai3GemV8gqfdFvz/IeFZ6FGYKh2zS9FIvSyMQOMJn4iZkW3AiiZXfq2YsVtJp/a2vtzQXwbnPXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lk2aVTyyBe/tVEn4aa43FbShggAGxq2zvVQDf0m4FwQ=;
 b=Zfdfxwspfg3EWJ2t1QFG0IFeqJovAOqbpQtIcdPLI0XJ32VftcXjLGDBnuCBof8sAmNP+iIPkAmH5UGD/6EduviX0VP7B3Y4FEQJJDOdAaq+pBvFrYRJR0sYQfZOYFybEGBkkYELTnbzENcStCwvC3wiTQ5DvP4c+9rC+lj6XAe3saUUDhq9UNbJdlXbH5c9sFbPYv9WVG5uRBolp2BJXKusP/4SJwlW3EjskFPc9NDM3IJUB2r/qIpz7C1MajIl1i0ULRIhEDOHLsenOiwAhtefrWLUqJCswi8zZEttKG6jx2zF6GMrar8QLEKWG8uBlWOVGayD6/uDq8Rn3vgeDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2696.namprd15.prod.outlook.com (2603:10b6:a03:156::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 23 Apr
 2021 16:53:06 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::1ce0:8b27:f740:6b60%4]) with mapi id 15.20.3933.040; Fri, 23 Apr 2021
 16:53:06 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Zhao Heming <heming.zhao@suse.com>,
        Paul Clements <paul.clements@us.sios.com>
Subject: [GIT PULL] md-next 20210423
Thread-Topic: [GIT PULL] md-next 20210423
Thread-Index: AQHXOGEhLEWOf1RMXUOyL1Jl7pYDtA==
Date:   Fri, 23 Apr 2021 16:53:05 +0000
Message-ID: <008BB114-41A4-4534-A06C-24F2C3701009@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:52af]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4a66f23b-303c-4f68-a829-08d906784446
x-ms-traffictypediagnostic: BYAPR15MB2696:
x-microsoft-antispam-prvs: <BYAPR15MB269624F404E89657E9852CF8B3459@BYAPR15MB2696.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DDYFJnqz0F8+uzODr0L9IQX7T0EH24Yc/zHeUZbQGhaZpdn/WdXRfqE9C5Wmtq2WOP6uSAXBHZoCPovPeUyyOr3Q3G1PC+e/SRE1qD7KCxLBFMlzPWHznNst9ITZaTvifw4GyLCJce4KbNpHxJ7J7yVpeeMFotWq/6BI41rqd8SFNqUUWA0daPUlUyYojKlTO+KN7ABh48KbBHyc8xK6xobFCNano0ZMiMNupqKPHPxZS17e+Lt4NRge1PMf8nrDxbdOYmEXNhGV9Z8GLhphWs7zpEXuPEBC4vRLjiP0RqQFe4Pfw81EWcHAUPDHLnk4gbmvv1DGkaSryw9H6eKhmjuhlVjuEqrF8rLoPJxWk/N2uyA5pxdCPrskhdmNj5pGA030Bq0p6qqAB2bq0bFPzfYawW/idlkBe7R33fR6vy70uvXycG2qehyeEpjNAFR8djDdyqAdPz1bItD1NEUFTiSjCrw3X7A/RHWtg50XOn63z4hpfDZOkBbTi8y9G+l0haCT0wtijixtKg7lxjDrY2URmgbgb42TYfPVXS3zsRTVz4LOe5nisaQZP2UDG6uv4tFuBnsiQiQprCRnvRO/smPV0WEKBSFOGJ8RBKeYUZul9rbu79HqLZvcOdbem3B6QsmIKZgZGBT7pAwNSBzLeEd0mAf8IYaPrtpVQRubXYUTKajV1CZVFtbdVk8xDoLMZeoXfySB+P4TQPozkkQVdntoJ81VKWvgOCQWVr9VJBS3Di9Rv8XycondR/IZu+ru
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(6512007)(8936002)(8676002)(110136005)(6486002)(316002)(2906002)(54906003)(2616005)(33656002)(478600001)(71200400001)(4326008)(186003)(966005)(5660300002)(36756003)(6506007)(66446008)(66556008)(66946007)(76116006)(83380400001)(122000001)(66476007)(91956017)(64756008)(86362001)(38100700002)(4744005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZkatRjjQhlYfZnXWeUEspzKybAqf2llDitJHU1Vwi3RENjiqAUkaocWBHMPv?=
 =?us-ascii?Q?LUzX04L7N5qWzwIMjISN5I9xkrLkT77is/9xw5K/kHi/ci+Ui4BrkLmHWIHf?=
 =?us-ascii?Q?6boE0nthJ3/UJhTJai8wzIF7/RIl7ubEA1Mkopp9iaK/TRxF8KXUDDKXbJas?=
 =?us-ascii?Q?eLKtluZryKIhDF5wGDLUyIEtmb8uU/l6cmZU9CGi8++CbjNFdkWk0pSlx34q?=
 =?us-ascii?Q?Y2jMQuktvCp+e7HT0BECCKmvdEkP3k60OF3EUUePGeiZ4qmZ5JPBtSQKRmct?=
 =?us-ascii?Q?wkgy4PxmK6S8bRx2THO+FZctHPYSmmo2yFO92qMPlXhv50LeopSSZvQ4/PUz?=
 =?us-ascii?Q?qO9Mr4hrSMFttThzCEAGjC5WKsxFFCERgZIF1JW8HsjoX0xLjSHei+Zp1bFi?=
 =?us-ascii?Q?m1Tn70GTB0gcjoeweec+Kn4HSTYIY6rayMc/1k9HInn6kagB//JpNhHWVfWG?=
 =?us-ascii?Q?e13EGNpwcLqObZQLUrdLNXHothyqV2PNqwJQS7SA6i++O4L2414ytJjT51D3?=
 =?us-ascii?Q?S0bksTvqsrson9dLLyjsUip9k9bjl4x3LySQc0w2D8LJi0pOCRWDisBIryY2?=
 =?us-ascii?Q?bUO9sKfsquj0PtKhtNQq/sGNqO0ong7y/OxWcbX0wgvSSWoAHYra7fQCybJp?=
 =?us-ascii?Q?G1Eh4EBTwYQdU0vLH8Ovsl75LavDVWkhgfVFxG534VVylNYFRSyCHLjDuCv+?=
 =?us-ascii?Q?eDpAOkpMyKbx4PRodK32PcnMPYSuOz71vY4rWo2XesO/JEBQ1Tslv1Pwy2Kz?=
 =?us-ascii?Q?xOtwngVLu8/LQrdmSTzTm1q9bFaFeA2AcIEZOikae5/sGBDS4Emogp262OXy?=
 =?us-ascii?Q?5ITYu1QDV1DnJra/KBut044zsKtcdxuN17uVt3cZqQ39U2FpGqJ6isDGzJR4?=
 =?us-ascii?Q?FB24dPlCIFNOC7kDMnLyoFpCJnSyGWQQWhLGm+7KToaXC5uj1BNbEGpXyVNt?=
 =?us-ascii?Q?1VRkREsD6nX+Od852RdaLcouNGz26PfjJ1E33eO2m99TdGlKbfgb9jvthw4L?=
 =?us-ascii?Q?vFvKgj7raTOmQBAf4rNgjO4yKfiRJe92SPo4c8VL4NNoB02Kffd+4GHrLyRm?=
 =?us-ascii?Q?aJj9gUhsfRM9Q9JUkY9iIMCT/IjKl8xslLCv3KfmZqg0onloPv3R0lVQXg2l?=
 =?us-ascii?Q?gPRQQ28wTybjm5ZgKlhALvnhEptdBkeuPI0QjOI+uvhsJ+Vf8xW9vHWfn+wt?=
 =?us-ascii?Q?hnc8I82lN5VJaqZulM5SRtQdHETKErpKZjWFdX/xM8KtqUQPmzRrLtnEMyCF?=
 =?us-ascii?Q?4THAtEqQJbOGczqydtz7RNtm/GyHYzEDr3hkMt1YeksKHzSBPFJObRJTMq28?=
 =?us-ascii?Q?MnkSgdcICMo+qi7cO5vq6Rlah/W+iGhHnvZR1hZ2Uyo1+mKdr1jiYVr9z1bY?=
 =?us-ascii?Q?hiRC85s=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D414F1B8A5A1DC4EB2AD4E1CE74AC1B0@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a66f23b-303c-4f68-a829-08d906784446
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2021 16:53:05.9190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: plA/tRfyvNmcQzotthlzltb95U1b9kGYbey/FFNOP0FiguW+YSPhoh6a0wXkjJfK1JtZ6bpGxbwxSCxbGSdUVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2696
X-OriginatorOrg: fb.com
X-Proofpoint-GUID: kMUnv2JLzvSBc7gvHfRSPKcjEkkYKlDH
X-Proofpoint-ORIG-GUID: kMUnv2JLzvSBc7gvHfRSPKcjEkkYKlDH
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 adultscore=0 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0
 impostorscore=0 mlxlogscore=999 mlxscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230108
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please consider pulling the following changes for md-next on top of your=20
for-5.13/drivers branch. Both changes are bug fixes.=20

Thanks,
Song


The following changes since commit 87d9ad028975e8f47a980fffa9196b426f69f258:

  Merge tag 'nvme-5.13-2021-04-22' of git://git.infradead.org/nvme into for=
-5.13/drivers (2021-04-22 10:23:55 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 2417b9869b81882ab90fd5ed1081a1cb2d4db1dd:

  md/raid1: properly indicate failure when ending a failed write request (2=
021-04-23 09:40:17 -0700)

----------------------------------------------------------------
Heming Zhao (1):
      md-cluster: fix use-after-free issue when removing rdev

Paul Clements (1):
      md/raid1: properly indicate failure when ending a failed write request

 drivers/md/md.c    | 8 ++++----
 drivers/md/raid1.c | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)=

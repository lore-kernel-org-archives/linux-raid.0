Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	PDS_BAD_THREAD_QP_64,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F01FC433E0
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 07:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE4F23109
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jan 2021 07:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbhATH3V (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jan 2021 02:29:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53404 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728251AbhATH3H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Jan 2021 02:29:07 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 10K7S0Pd025389;
        Tue, 19 Jan 2021 23:28:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=PglZAnShRrLRc3Qam5ycv4Mjs4wv65m7+EYIyPaiOhM=;
 b=UOw79VievoRmv/swYCd+Pk6RSZ1viy2OTD874aGtnQUFKkohk1mLK0Ys4aCjWNja3Qo+
 0JFnXOO/KakO7+i8lVHUenCHIR32z6+yLcM/dO048mw93LW+LEgK2lxx3kgf/6vlsNXz
 oPdkcMY7li131G0v/imnfzAUvvUOhFuaMng= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 3668r3stgh-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 19 Jan 2021 23:28:22 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 Jan 2021 23:28:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mT9351XTS580Hk+31YZeGLoeIfzPPvtYM7vvZu29vt5jPX52F81wdwXWDkjWDkrWnkebi0TzbZ+0ATWdTvHl7CFMq+KdI/LnrWL2KAwmwQIDv7PbPJxg4P46cgEAiBP61vf4WwHDXIhvyn81O1VYuX4Rcxut8mbGtfEfTP83YulDyFtb6ApACzkyEjS+X4imBc7IzLIYSpH5koapN0ZdjlYp7bRk6Gti0kHROhfTiscKH/kWLAxPioBs55q0uFNX0h/ASDodAueJLoKnYaFEqGdue2JaMfQUXBlj2o5Ysizw9DNzPeWqlXhAuvOcuR/9Ry6LpitkG3eP7Ukd+EayKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LzKbxOKCHYWg2x7ReCPfuUMwDVf/I1i2VqUgL2noMc=;
 b=NXUndx0IRM6qjAtDMkHipcffU5/OSHr6sUOnUyVAcQEMT00hWT+piyrmFWFjQmTc9O8hw4aWSCyveheRw6WrxXAodUcEJ/HA71+IKAAaUD7QlyskWc9UWQO4fPhyw8+HFrzIdzHuFuaCdSiNcKPcXsAr63jo/3bBpxfvb+8tovZqfa1sM8TxErKtli/sEJrjHVw+ta0fDalGc5GWBTP+e1ju0Jnv/nFq/WI4HGLvNCoRAIFHwXfoDt0GPAOukg+cWL0sPWL+ubO2k57epBac8glgWX34+gFQnAOyuxFNwzmi8ZAUJR8Eo7tCSIYnRIq3M+ABKdIFvEEYp418haEZKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2LzKbxOKCHYWg2x7ReCPfuUMwDVf/I1i2VqUgL2noMc=;
 b=HCjTZj8YdEi4rng42Gh6b9zzZmXfyo0zcOo6/R5B5HUbLRwbEpnux2D0pPEjL3CJtVJ+Wr4YXEBP8VAaA2nC+3miJLw4TBsRFnLHfb55zP7VFVGxPvHXUShdDeUjTWdY7XPydEBfjq6FlJB2wRbvJrKbUgOEyN8ggAA5zC7nbO4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3093.namprd15.prod.outlook.com (2603:10b6:a03:fb::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.13; Wed, 20 Jan
 2021 07:28:18 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::c97:58e4:ee9:1dc0%7]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 07:28:18 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Xiao Ni <xni@redhat.com>
Subject: [GIT PULL] md-fixes 20210119
Thread-Topic: [GIT PULL] md-fixes 20210119
Thread-Index: AQHW7v3SNXpVURyQ8E6TS+NQW5S8mw==
Date:   Wed, 20 Jan 2021 07:28:17 +0000
Message-ID: <745AFA65-3D87-4D24-9B16-D1DE59CB3AC6@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.40.0.2.32)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-originating-ip: [2620:10d:c090:400::5:ad14]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e984dded-a849-4497-1b36-08d8bd14f505
x-ms-traffictypediagnostic: BYAPR15MB3093:
x-microsoft-antispam-prvs: <BYAPR15MB30938D7B6784A90F2064324AB3A20@BYAPR15MB3093.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7ljNkmDxD+XziD2VCRy0QZ9jsN8tcJeGzoEwLvp1V/NQE0GO0jgH/GdryOFDetsf4GRV4eX+Xz8v5jsLybTHSbfnu41eZqt4KvR9VgQZReZ2hmBQfWG26B6dLVSfZwgFtFgTkwpwGTiaUJ2jA3wRmGv+/9l4rxi++bLPN4EbXhvbf4SxuADaldDNMigjpJvi47sFHoU6UJEUk+CAr/BB3wYsi5lOCFdF0iTn2dDGENVirwQH/I83as+LVtOGIK3lzoc8DthwS8aYtTm/EudkiQNQ+oyzWY/wlwSyfXJt2LK8J38TMNMOZLcijW+8lH8QH7Hk0KYMPFBGfaJAWpPqSP9NPxtWfdraa36L/IV9xl0YEFe3F6EBERZrCHsGmWFpW8UnH7tf9ZIorEwF9TQ4jWDhie2ydq1hejA8aZV8gY8HJDLpFLNTN4IKvut7FHtvEjM7ixQiH/Kw6VDiw/VhzBUS0NjZ9GDspmxtgHuNC10tvqtFyJKxyvvarTEhNrfIoS70N0RA+gs9eIRpbrde1g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(346002)(136003)(396003)(376002)(966005)(110136005)(64756008)(6512007)(478600001)(5660300002)(66556008)(86362001)(6506007)(4744005)(91956017)(316002)(76116006)(186003)(2616005)(66946007)(8936002)(66446008)(66476007)(4001150100001)(36756003)(8676002)(2906002)(6486002)(83380400001)(4326008)(33656002)(71200400001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?mM52x6WBfZFbNbZYC/SgJE+1N7m2NZw4xV6dmD+6kMdh5yaJve3yhlm+a18y?=
 =?us-ascii?Q?0DK/C9opVHUwszafKh8IV9xWbtUsRPqA2Pz8Trgq05hV5Y2/p0DK2/TUDVnD?=
 =?us-ascii?Q?1QhX8r6ePENeXOBkHJ7Vr8VuQPYGCQcShwBP5tZwjaQkT/wk6SrhyN2JY1rN?=
 =?us-ascii?Q?Qky6V2b9o0JAexmhGiUVnOOLHyyzP4yF4bxJq/kKIEOpsPutpTEmhPQQ+wdP?=
 =?us-ascii?Q?GsPecgl60is7JT8HkMyvdq6LZmz2MWxnPn13pvLNMpw4fOOXstOK972wPmkw?=
 =?us-ascii?Q?624VAtLWAoGuaYKx3d9xcHHNmtVHDD8J8FQAAq1uIU4J0oOeNhiRhT623eta?=
 =?us-ascii?Q?gTiZY+gsHeJOcw3uESxZNmjyuXxdGHfSfQMvOhtavbDrGV26/eVJVH+HejNP?=
 =?us-ascii?Q?arbxfaQ0wlSzzN/a495jutnL59LzKOSOCRNqYsqgapTYdtlje2/dniGLwlKA?=
 =?us-ascii?Q?3FThjvvipflkx0OKh/ZSclTo1gXkrf8yho+8BVCSdygEMMdAv03zqU0Fpwbd?=
 =?us-ascii?Q?NNa1mBmoS4EyEUmHNCd3eovLt5GoDXdJ3jAGeztXV6PXYDX2tVsqRGooX8vc?=
 =?us-ascii?Q?0yHE6//2VMmrspiMb3wD18TyXTz6cYF6P543eaz+778oQJq8OfXu8q+b1G7q?=
 =?us-ascii?Q?zXeUXkvsyv8R1ek1fSZ9R1CroSINSY6J0rHqyH6CbgXLscFyYCXfRx6z5gqz?=
 =?us-ascii?Q?BoN2mJwpns6BYt6XOW3rgecir7rQa9G1Fu7kw0PE5B8peF6naCziY1DbwcSz?=
 =?us-ascii?Q?8G2UIwrDSfYN9i0qRFSrvxEq+KR0N48kGsxq6PMNDpw4aWJHtWJ7jVHgot/v?=
 =?us-ascii?Q?rvk98QAWJw06LGZJDFzLMiayAXvJ8+rRavzDDri867RfOuKvcM5RCoH9SN4h?=
 =?us-ascii?Q?3JiyoEmZwOloqxtRv0rECEy8DzUdaAwWcc9tkMi5DlXfwyj8v7N4V9Vdr59d?=
 =?us-ascii?Q?wG3ENTwxri5nQG5Z73bS9NL1QvdKv7NnVkrWurf3gHlcjwUaPHL0NPNyQ4Uu?=
 =?us-ascii?Q?W9sYgNj0UrZd0qxLvarkRY18DjFfxr4nw0CAGZz87u7JTZymAgO7x+dvO5jC?=
 =?us-ascii?Q?FcPt490JFAX6BhWaHbBXpnk7xQq/SabOVKiMZU0ttuPiFQ3SSzU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <66468F99C4A31D4AB369FE5F684073F7@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB2999.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e984dded-a849-4497-1b36-08d8bd14f505
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 07:28:17.9623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kIEWtRls9B4qqzS8lv3QE/u/sMQTK8Yn4hk6ngnMCF+0Is4JInx+2ywVY9/PpNYXcGtN3HgbvxBhAlMxt1Fv3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3093
X-OriginatorOrg: fb.com
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=999 spamscore=0 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens,=20

Please pull the following changes for md-fixes on top of your for-5.11/driv=
ers=20
branch.=20

This fix won't apply cleanly to stable branches, so I will submit patches t=
o=20
stable@ separately.=20

Thanks,
Song


The following changes since commit 03dbc6187db574badc8599967622ac079e2b1c85:

  block/rnbd-clt: Does not request pdu to rtrs-clt (2020-12-16 07:19:59 -07=
00)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to c5d9dcfb1d340591e04e976469ac38cf2dc1707a:

  md: Set prev_flush_start and flush_bio in an atomic way (2021-01-12 13:24=
:00 -0800)

----------------------------------------------------------------
Xiao Ni (1):
      md: Set prev_flush_start and flush_bio in an atomic way

 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)=

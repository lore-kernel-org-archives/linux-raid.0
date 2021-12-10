Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB463C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 10 Dec 2021 17:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhLJRUn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Dec 2021 12:20:43 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56760 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236247AbhLJRUm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Fri, 10 Dec 2021 12:20:42 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BAD9rrh012907
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 09:17:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=bttfPRXB254WkbHNZPOvYvfoh9b4MAHt7oQtyi3K0wU=;
 b=L4814Nxu0DwUgG9sP/TfXgFq1oJ54d+SVLFtcmosNsjswKtKUQnvst7Xy8D8esKAhYsf
 8KmPIhUoAqdiLktKs6BupW4lgmx4zNjE2Jz/pE9oEF6H5Qyq2bzBMnbDR6eFW2FJ6Wes
 cXi7QsoSongBmpsNUP8pQuoOYGw5O7qeFmk= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3cv7h2htm2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Fri, 10 Dec 2021 09:17:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 10 Dec 2021 09:17:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lToMZn8NF3IMDznBasmGbsVCk7OPwdbOBCi3LxE/OUDuCWRhOuJD9prGXkQolRC8Z472PUqm9l530JiyFiNz9RzpFI2E7PrnkrLGL/6Ll1i7pY4wNAY4RAzlKUSWmIjhpLzlChY2LuE5U+6LqS+1mA/ezAPb/CK7H9kz8WLHgeuK4q8IPhA+bLfJi0CNnzVA9mKHqsZKlLj/RZObAX2NR+hIkrcBTbJLmR3lmAnblcs0PjLdMHwpYp81wh9LebQXyM+8RDPXQazzz7YuY1GUiKFkAHGGE4UfY8rmxbtS9JaAZeJ7dn0Kp5OH6MUSETTVUPkrnJWTUdvMgE6EKmGDWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bttfPRXB254WkbHNZPOvYvfoh9b4MAHt7oQtyi3K0wU=;
 b=VGxAslX8i402qe2lEG9awIlXS7Ieplt1yh6HXdo1C2SLNwhqrANJV/wguEXafLICgnM2Wc2OPObZqGW8N6FpCxFTq0cd3zynI5V69IX06MC03aaXTV8WNPQCA/apmkfJTD3Fd2Z4XOxYJPhC/yGluYGomag61ixv10GIOkrqUbzoH+l60cGNxK7IbbYYLAgGAeLEmLgO1MAZmUbNnWLB4fyNp0XUJo+lnNBB8+snXKQ7W7FB3dLfG1vn06KuYTuFBvUBIbP1wo141rpM/8TExUgcBGwtolDCENE2x5b9IURcOo2CLbAMlTuYRXRanDb6h33/MdWYNCCZrU0RIeClZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5080.namprd15.prod.outlook.com (2603:10b6:806:1df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Fri, 10 Dec
 2021 17:17:04 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::f826:e515:ee1a:a33%4]) with mapi id 15.20.4755.026; Fri, 10 Dec 2021
 17:17:04 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     zhangyue <zhangyue1@kylinos.cn>,
        Markus Hochholdinger <markus@hochholdinger.net>
Subject: [GIT PULL] md-fixes 20211210
Thread-Topic: [GIT PULL] md-fixes 20211210
Thread-Index: AQHX7enAh3uDu/r/sk6gQFBj2aRWzQ==
Date:   Fri, 10 Dec 2021 17:17:04 +0000
Message-ID: <BEA088C2-322C-4398-B43A-E231CC3B05B0@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.20.0.1.32)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3e3eb83e-7fc3-4159-0b28-08d9bc00e321
x-ms-traffictypediagnostic: SA1PR15MB5080:EE_
x-microsoft-antispam-prvs: <SA1PR15MB508051163E52DDD826BBAFFFB3719@SA1PR15MB5080.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yxJ0TmRBI8xkmvPAlUmGxpo3yqCmUf4Z4LX3g7Mp6WBKauD/1eSXKPrsn62RnbXXuGxWYXJK1djHO0aAjafwGPgOfQRjciSfE+IrRNO6vNc9sw5iTyZyIz1jcbpQQME73XSq+G/B/teLnfMMUImqSJu5N8JTAojusT7PD0qOV/vHsHYtDErRnCe9uYG7Mjp2+YntWUImo/eO4TSFEicXeTQef1+WmLKribWXn/8Pj3m3IgEY0UX30xT9cwhirtw915OqoEO3xAbsdNYVwBsxFoccsqBpaoA+pBHaIdq6h/IU8M6d6xIihYpx0AffuMtIhfeGPydKvEjRHkNtCHuWpg1fog4pMS2IgLJV0wkIlQ/o5vkngHVF7z3I6zlTKx67kPM2zoGFsrjgAkYcMd/ApoeWaEb8T9plmjcWdn3T2BcOEuLIH6ilsOo7nVwjlyadU0LmJmjg+uigzvqczdYz4aLb9f3LnThtmgttyEjoFZxlUPP71skioran/QU3iY+09n0Y7i5v12UlaaqK72SE6XzDoyVNr8E7FvQlH1K8lAxo/f6173RorZRN+VOn1W/a/usYjVrxdfyZRPdUQyPh8k6sQG3INEBvF+v9i/hMGCAF9Jg3bHAwwigkvZC34+268YG7D5LTU8lds+Z9aNVgV3iOEZ/zuZ2g4PGIRlPiShPSeag61TmEpBYYAGjjqslDPLfUk+hK/EuJQp0UaObb9wMCQHzphageyr+3HSK9Vj6cHRG13WO4fO6XXrkhhVxwUdhT4MAE3RbnJwlKkUr3Bxy2c0ept3A4CxCT9+bpF9YOBugY3SmX+4nTVV15h4rJvGRd29NdD35gbQDVJt2OUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38070700005)(86362001)(66476007)(66946007)(66556008)(64756008)(66446008)(122000001)(91956017)(38100700002)(76116006)(316002)(5660300002)(966005)(6486002)(2906002)(186003)(36756003)(6512007)(8936002)(4744005)(6506007)(4326008)(71200400001)(110136005)(508600001)(33656002)(54906003)(4001150100001)(8676002)(83380400001)(2616005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uhxrKty+JRbVOonFLDl9vMOj5oBp2qW7b/2OC9p9qIUofpv13WkeL+hw5RFR?=
 =?us-ascii?Q?drN3r4zCUCat8dIXkd4Xq6dhc54MFpqUMiyfTkbDyEqTu4QkqjlKWdoxTSON?=
 =?us-ascii?Q?STK2C85cFjdg05q7kJYpP+vSN1igCq73y2/eTn9JKzq/Dqz/1niG7Nb7c3V7?=
 =?us-ascii?Q?XvYaEkOJoJVShgTTWaNgVK4xeyACuhQpab3fchEDvJGg14ccVXTQN+NtIjNQ?=
 =?us-ascii?Q?nsX9BecczSoe/RAvqlY8I5ybMRjUXlbZBD5wQzo5H54ORnb6+WLTNMBNJzDb?=
 =?us-ascii?Q?Ze1XdP+HzjgJF+8UKnSXWNkEjtB4ZlBTgOgqXIlnoXfQZd2zMxLblT/gC4r9?=
 =?us-ascii?Q?16nPO4MvCAU8uDFF0iFurk+waHirWnG65NMFj4o49uZIEUPjAAK04V7Imjcm?=
 =?us-ascii?Q?O8G5SVDdkEQo3/E1s5vDO7SlsbpW0n87oJACyq5NxI/JUNZWsJEfCGajMIfR?=
 =?us-ascii?Q?4tzrzVBvEzsKabWIotQzRYi/dVu8hU2/auNjEmPO6sILNlXu71C2Txo4ov8/?=
 =?us-ascii?Q?AmUxP0LfngGT31/wK74u1QgvE41aVlift+fFP3InMMEfXX/AarUNzfJDxFVL?=
 =?us-ascii?Q?ADv547deJI1jMgN0WfdJh+2FZK0kWD83UtltQ/Q4n6sEqgB30qb5z/NmnlyU?=
 =?us-ascii?Q?+uWyQxRbZFYVW2ORnsOA1RNpvML6SHQGK6U6y68UzgqJJf35H1zrnNocraIC?=
 =?us-ascii?Q?rQh+xfz0l0AnxScqml/SlB5X7xuhl3YxA+TaOiyzZQz78yIH6EfTB7V/HqdH?=
 =?us-ascii?Q?wMz+8o8MCTAyPA+RCtj5AmnWzGGQV4hvBebKGoFG6+cH9KpB5fZUIiNjmZdy?=
 =?us-ascii?Q?M8+ACCNvv2xDaKlijSwG65gYLdfq7O+itAVAeycK3svcFREx81xbhwKWaK37?=
 =?us-ascii?Q?qTB3qyuZtUqCQS7CbKimnfWmhS9iHaKshWlNGpmvbRymQCotO439RE6iCEk5?=
 =?us-ascii?Q?xwc+zgsi8EJNPm7jvzJpcvLbyP1UNJQjVuNAJ+5ctJj3aNWkdSp4FxbbdN+K?=
 =?us-ascii?Q?zKLr/YgmWn+qjr61yXu9KD1J4KhCkljMkyhkR6CU5eXNKAgABblbiowOGwRx?=
 =?us-ascii?Q?zTWIropFfztIZ1j1xtYRvGT7HlRRiqjgcIcDfmFywLBgFqrpqFXO6nnQezZv?=
 =?us-ascii?Q?w+oywo7hyNr8SfAnnIftuhGVa01C37SYLu4ANaxnObStdtQ3wWGilQnDY9Zq?=
 =?us-ascii?Q?NFgpQWmMBh/Bz/4v9ItX5ioBYjbtBm7C7JSyjURbznJk/dpp3X0Sok5H8EF1?=
 =?us-ascii?Q?HK7++4WuERWkz9kQu+Vo5c/rQXm6eM1UUn6OXGoBdQE8uRpS94z7QwnAflCC?=
 =?us-ascii?Q?uofvaf3xin6ckx1SACbiT82n/iTouedZgiqNz3XuE/ezNRVzbPxjv/OqCJof?=
 =?us-ascii?Q?S2lZAhlvvvi6b6Opfld+dbvPznOwIFFs48l7IQ9C0orS1XcuE8bGctAEynw2?=
 =?us-ascii?Q?OUJv1df6mrRw9niUMZGKOxm4QnbqP6jVCYFe+C3dK6Jwrvgsri4CCqC1X57H?=
 =?us-ascii?Q?saKJvkPthRG7yz4XsXvdWkRdLuNB4E2KntvI/+M1iO1KSJndoNrYZ1ptd95i?=
 =?us-ascii?Q?wlOIamDMp5XzWwCSKvivO3W1aL0Ty+kcLMZtiWxqjCW9BA463Y+z+rp4UnjV?=
 =?us-ascii?Q?O5mCCTkBrcK/3a6crNxshWRTURd3p+aURGoliDbp4GIaRfHOm2W+nbO7iVkM?=
 =?us-ascii?Q?MuBR+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1D5078AE2611B348A30B40B8AD2B70A3@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e3eb83e-7fc3-4159-0b28-08d9bc00e321
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Dec 2021 17:17:04.5395
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 20NfxjDdc1CaB3I7kFDEM9vXw0qE01xK6srrLeTAnz7rxl8qoAC/LkESMHuZLuhmdvjTELhmA0mUg3Z7mvTkgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5080
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: KE0xEp6G6w2sNILed01KW8eqiSlLmmPU
X-Proofpoint-GUID: KE0xEp6G6w2sNILed01KW8eqiSlLmmPU
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-10_06,2021-12-10_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 mlxlogscore=742
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0
 spamscore=0 clxscore=1011 priorityscore=1501 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112100097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your block-5.16 branch. 
Both changes are straightforward bug fixes. 

Thanks,
Song  


The following changes since commit 091f06d91cbc8a51b63c26007e29baae49282b16:

  Merge tag 'nvme-5.16-2021-12-10' of git://git.infradead.org/nvme into block-5.16 (2021-12-10 06:44:15 -0700)

are available in the Git repository at:

 https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 07641b5f32f6991758b08da9b1f4173feeb64f2a:

  md: fix double free of mddev->private in autorun_array() (2021-12-10 09:11:07 -0800)

----------------------------------------------------------------
Markus Hochholdinger (1):
      md: fix update super 1.0 on rdev size change

zhangyue (1):
      md: fix double free of mddev->private in autorun_array()

 drivers/md/md.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

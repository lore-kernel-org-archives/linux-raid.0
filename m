Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F7BC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Feb 2022 18:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353565AbiBCSui (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Feb 2022 13:50:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54742 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1353537AbiBCSue (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Feb 2022 13:50:34 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 213I6SJo027497
        for <linux-raid@vger.kernel.org>; Thu, 3 Feb 2022 10:50:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : content-type : content-id : mime-version; s=facebook;
 bh=cpVrfWgKz6LkbhqtG4mg4ydTLQz95jSm476qaEwdwqc=;
 b=C23YP++MMK299VJa0/DTJ9qnR9DAFUeG4YsStzWsRzoSxaILdEUydHWp4nsDSxm8N22g
 nQZlmW7XiwOeVQS/eDAFc+Y2amueurBIA3W7k+6cMqpb8SR9mhZvPBYu0aDFog1bvb+N
 ThJDG+4TV0nYMPboXOFlmDoVBHjaOcf4itI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net (PPS) with ESMTPS id 3e0703mw72-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Thu, 03 Feb 2022 10:50:33 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 3 Feb 2022 10:50:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOi4D4lmuYRT1pKTNLocf5tC1WzCK4tc1PIo5M08DsdW7pdTUSczXIg2HKNppiswFCv+klCNxpc9JB/1pc/AAj3mibPbMdE6kunjFMBYlyfZG6064K3I2hQAUu/iMfFiIVlg1ArV9kP4toeLE1i4yCHEw/tcD35s4zfz9EAy4fiEzS3VPZ0irpLmPGYg0MEh3EDq35iqyUkCxdHL8Nke30fGXSrzfbm0wRQk1Y2vbH80zL8PapZEXvgicEJAacgzWkRuDwhVZ8k4AroRsuH1L5AD96yvxUcoTKHtMDCfPf5+BouPpTmMtfTD/U20yTvPNuv4ir8T5vMQezyz2AGKhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cpVrfWgKz6LkbhqtG4mg4ydTLQz95jSm476qaEwdwqc=;
 b=Tc1te+LPffAggVxD1wqh5b1nuJ2UunOnErZBn/Tf3/Fd/mC5+jgPe+jkUaoSjx996g0np5tN9PsbuV6Lh2+nY9bWt7/2Gk/ajODigfAKGzakQsuDYxik9DfHe1u9khdcCqTUJEefYl7y5qInccx/w23j3qmnPty4/lIifaVsfotMgQZghONKdPlCXBPqhfXD4BeMAPKrpdLb2LXWF5q3DVSRnYDAjoRy/Z0tO/UoXcFm+lC4bc6HO9HOr4gmwhvS87KnjrCtUVYk1qeVCiMYZHn9P03o7hpmsuQSDoLL1IUYj8X8FKv4Waal921woAW+7SkbYtMHcFIb9B7W+6RDOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by DM5PR15MB1546.namprd15.prod.outlook.com (2603:10b6:3:cf::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.14; Thu, 3 Feb
 2022 18:50:28 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::cd7f:351f:8939:596e%4]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 18:50:28 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
Subject: [GIT PULL] md-fixes 20220203
Thread-Topic: [GIT PULL] md-fixes 20220203
Thread-Index: AQHYGS7pJFIewBnVA0Oww7rPpyOc9A==
Date:   Thu, 3 Feb 2022 18:50:28 +0000
Message-ID: <367A4982-7D31-4E62-8867-3912D5B9FB5C@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3693.40.0.1.81)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10ecc694-20eb-4d6c-e07a-08d9e7460bf0
x-ms-traffictypediagnostic: DM5PR15MB1546:EE_
x-microsoft-antispam-prvs: <DM5PR15MB154663ACAF1829594F2F4F52B3289@DM5PR15MB1546.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/c5f5ci2qyPw1i4pjv0ZgG6IvqbcfQVSUmYrpG/n/oZ42N+yj5dDJY8tLuv3NH2ybXkShBnVegIJ82/KEu55vQFt+xCrGHCz+xbElWhubfHbGngTKVi5jos+Tlw9kcZ3kjiEu1uK7D+GuKZM+teXELhvTJvC0gWIUHdjsO2PpNIPjizHNGajWU65AmQyqlBNhmALZSMY6Pht4fncxn5R7hYmeci+fy46Hj93jTgAVXz/3tbo/U/AJnv/NuxjRgU1KGhDGAXUhfULjLppyLGqoGnxi1r802mgAeHwWUkU2mezeZP0zRu1qldfMdnc1bQMDTG5w3c6P+3ypcGv21jr7gxTTDBvKD2CRJ+uayHU5HjHqouS6H+TioyF4BSwRyQ5W9psJY8s203iKDIPLF8rG3ewDu63IPCNYUivuKJ/Wi+hi3GrBxPrDP+rr+56gUAaDB+oJJg9cDY81hrTKHaTvPoNPpaw5jcONDsKgfDCh4T9DWOzYln3lHTr7KzEN3AFtxBebVNwuzUokss2GfSRc4yIYQZ9a0aVmlo4Xi7Gy2cV8djQmzwibxzHae7oJo+h86ZZ+hmusxGxW27mL/0EiHTAMIdr5jpXDbofFuyKyB9702aV7o80c+Rvpb7ploEj4D7wCzCO6BJugvRQr/8qu9DGejTQ2fBzgWmMGBxKrQhgNOOh/DAEw5lU1bveSkFABXrYeGu3nn5Db/0/DyvusIbRPEPnIlxOzDWoM48HfNYlGiub0gRYH16JlJsRJQWSOkrczUSXLzF4uyJobAtidi9gFoI0GQojaWFi7usfDbZL3XkVi1ETAxHmXDiUeac
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(33656002)(110136005)(71200400001)(76116006)(91956017)(6512007)(83380400001)(122000001)(66446008)(66476007)(8676002)(66946007)(64756008)(316002)(8936002)(66556008)(38100700002)(2906002)(6506007)(186003)(86362001)(2616005)(38070700005)(5660300002)(6486002)(966005)(508600001)(4744005)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?fINd58fw/7YpsYKQploziyHS1TwKJ9i3MQeaRSHs7jt2wcCaqmZG/CpQStsj?=
 =?us-ascii?Q?J8vI2t8fzLgFL35INrZIqsJAuRciZM35qFq5l1OTbq/bG5Gig90Y+NqPPqTs?=
 =?us-ascii?Q?L/NNYcS6PvET492ksl9pfEY6X0SmqnN+K5F0m7G2GgGF2OQX7oknVg76yXT9?=
 =?us-ascii?Q?mhk0A61Fx1IXOs0ITQa/A0GM1tKxgVLU0tVentPO+GvVKmrnmxqeyoqlxrQW?=
 =?us-ascii?Q?sbDrK3nCUHZsNZMyKnyDiyX10JMcKnVk/uUbJlJdUL1ubvrz+U5wt00DFnzO?=
 =?us-ascii?Q?LYCRAY8I4LVLDFFzM6oChb/CoDJc6j5yTd7qpVW5uSyvGP8FEM6qn5ND9vOG?=
 =?us-ascii?Q?TTqLIQCDCjWFSGED3ses4tQvanPVL04eVlyg/0mXJxmxkQ7xV5g29mznzPS/?=
 =?us-ascii?Q?t5JI/92A09AUAACtqjuxWDC9AFk69AiuDIMIz3R60Pb/hQjJTt6tTxj8VahB?=
 =?us-ascii?Q?AbbMCkdZuEkBxwT3MB10zlfjS2z0pzp0KK2ijlnrVnjkdmw2ctt9ANV1XlGc?=
 =?us-ascii?Q?a8yrzxns0Nv+CK1M3z0OSiKkrrj8G5uPiFFHkDBPC3fa1y5JmpwMPVMJgAWU?=
 =?us-ascii?Q?DFVuKYIZzmVhWDiDZ649Oo0TinEl8ayvAmHR7XkIajqJNzIJnjHPmR7p+tSh?=
 =?us-ascii?Q?aDLDqC+dURp0kGbMniGGPN1mnqP/pGEisUCps7tJAC6SNEvtXdP5c515GNZp?=
 =?us-ascii?Q?8Wyjp6+rAuMwCoGAuBOfWvkb9whFyj3G5Tm8OMKdz8iGheDn2ZWh+hDMxmAk?=
 =?us-ascii?Q?hY8QrkDJbXcW9tNMCLIHPUojM8ihN3W0qCwsaJIaBzGZM2quiQzu2/Mtt63p?=
 =?us-ascii?Q?8mXuGb5h+iSmg/xWAzSxCc/WJcQRVdJ9lo36YaA0/LbjG+tr23et3OuF4nRI?=
 =?us-ascii?Q?9xlsh7ePi5jKkch/bxhYHyWk3Pa4qcRhirRzpRaD62wNwoZv1wiO8EBjC86y?=
 =?us-ascii?Q?sPB+WYOmtx6GkMo266jrysVKcClRxOA7f6v7Ish438ZUdFaegEtR1sKr11sK?=
 =?us-ascii?Q?60I73Bq9hk5Z3SI2aqeos20hPvXX6ARlevuMn5HSQUFwxaFoK/u7TM7u1O8w?=
 =?us-ascii?Q?smJnCqZ+Tzzn1GiO01pemnQwBBIMC3PRYRPJHjbOrzzEVOxRsPYjhI/5NlSs?=
 =?us-ascii?Q?9W512JmHd4NdVWkXG9QO+eU2o7/JFzwJ7JdQXvkYHnFxU88Cvc/8swxLuafJ?=
 =?us-ascii?Q?04aOIuCxhzGH+mcCS60yt3mOnWp6TZ0iW8skc5YyJ4ZLD0VX86eFjircSQCs?=
 =?us-ascii?Q?LHHkm2fIvOxaDCRPBRaSvg2mGGEo7WXLnhoyifVeOWYw292XDy0lCtfRZ375?=
 =?us-ascii?Q?9stApwaEMOYTG7aF1nl2qWi/3Ibp6j+DzFOWoT1p7uhF64unqCfSHsRmYT4e?=
 =?us-ascii?Q?rFSa66cwcXnjukNp0Duj/iIk/CbDGrPJg/R0QsZv6xZ/Jjd/dovW/onLSI4s?=
 =?us-ascii?Q?ktfen/DDU+pLFddnvUxqzXJhVNlbDSi9A6IrYFHvprLodbNuOrnS6wQnC27t?=
 =?us-ascii?Q?0SquRpAsxv50OgFw9Ngwk5UvNf7NGPrzpVJCs2p2DhVLXwm9LRfqjxtnA5y+?=
 =?us-ascii?Q?bjloEsLY+MqMMzYVvbSdTxu7ZMAKOVG+91NdiY+Tjv6ms9BdmIyeXYaPfRvi?=
 =?us-ascii?Q?IocbNIr+0H92v48SXvbYoHIDiHjfKlaIz1h1nz2XGdUjvRfLoWM5Dakb5bZM?=
 =?us-ascii?Q?Y1daxw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7E8ADB9830B5BA4683D231FE7CF7144F@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ecc694-20eb-4d6c-e07a-08d9e7460bf0
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2022 18:50:28.2760
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: os5BY4HjmpvlZRxcqQ8Fl3pUmZcxwwTqteSA26fn7mbXG1Lk2wXnGAmuX0NCmsI9oj2jxQYemZGHn/COGd3q4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1546
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: OMPnnzB4zfi6R5BDLfmov78R-j7c5cj2
X-Proofpoint-GUID: OMPnnzB4zfi6R5BDLfmov78R-j7c5cj2
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 mlxscore=0 clxscore=1011 malwarescore=0 suspectscore=0 bulkscore=0
 phishscore=0 impostorscore=0 spamscore=0 adultscore=0 priorityscore=1501
 mlxlogscore=824 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030114
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following fix on top of your block-5.17 branch. 
It fixes a NULL ptr deref case with nowait. 

Thanks,
Song


The following changes since commit 3e1f941dd9f33776b3df4e30f741fe445ff773f3:

  block: fix DIO handling regressions in blkdev_read_iter() (2022-02-02 07:48:27 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes

for you to fetch changes up to 0f9650bd838efe5c52f7e5f40c3204ad59f1964d:

  md: fix NULL pointer deref with nowait but no mddev->queue (2022-02-02 10:14:07 -0800)

----------------------------------------------------------------
Song Liu (1):
      md: fix NULL pointer deref with nowait but no mddev->queue

 drivers/md/md.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

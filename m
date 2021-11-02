Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E8CC433F5
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 18:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 232FE60E78
	for <linux-raid@archiver.kernel.org>; Tue,  2 Nov 2021 18:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhKBTCa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 2 Nov 2021 15:02:30 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:2400 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229778AbhKBTC3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 2 Nov 2021 15:02:29 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A2Hmlc5024950
        for <linux-raid@vger.kernel.org>; Tue, 2 Nov 2021 11:59:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-id : mime-version;
 s=facebook; bh=WgK9UWJXQ6cjy3smZFMfbeSam5C+a/w4Il3LS7nVRGI=;
 b=fyOc+rxGwu3z9UQgH3lBEs3xi4VbNu2bJJpEdut87HUJHST7iMupIjzs4YZmfbGe2q8Z
 ZLehTOrErQOpTyAhvec0Go+4jXa9L509o6cau7vL9v2XdSgd6PBNCEYw3Ir7TMx59KJx
 IyQvEShcRyT2ih9IFng15lpt5gaB2EuoPyU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3c2w4rwjcr-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <linux-raid@vger.kernel.org>; Tue, 02 Nov 2021 11:59:54 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.198) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 2 Nov 2021 11:59:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zc4vl7CSkaeb/yngK+4NzKDWKn/kqS54F8IcYY26tKOB3boQf52BWvk0Yd0hw5Ho3QxJZO8Gw9oMq+yQrQeIfcYUelmLft8Hcf0tnZuxOP7dZigRDBp8T2pptOjrBWj3PG6UqesxCqCQsKP9tlssIFIRuUso2iXrpn+hWqDUdrryqdxdtmKm/vhVUdAnjXhS2/ZDKsv/mU8tlm7uD9TGEVx8J+mTj+oHDmobY94jv2XjWVoh5S+IEfzj7FbZ1LCI/KNaepUZjQU5KE2+clPIwCKKCwaziOIY11nDm41bS8mEw3Z5g+rOW78gA1h0rk3dHPyMLDJWfmjivdSs24JJww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgK9UWJXQ6cjy3smZFMfbeSam5C+a/w4Il3LS7nVRGI=;
 b=WjgKzCrCcaWdwGSDxz5000SeplnibSuPR+X9Geu7Bm5VK7QmFGG6Sul9+sxxwx02E9mhmI8w3zU+wztGt0oKqMbySfM4M7t3kC9c30tIGCrhwlN3UXoA2hgJXyxh4e3XOV11MwMzmuOuObVWugIYZkfe7j9IrUb6B/6Vw12sahTMg8HEBlH393o4XFYj+JMv2tPLGkya5dWZF/4FfuH/am6HgYn4dd20DehJP5N+0XWM7EcYInRE0Sy5cq0eIHVWQjqlP0Zk4hbJkywus88wSgOSr0h3fElJC9pMRptAFBx0FLprY0fu3dHDJBnlWlh21lEBDDiqQcJ/hf9mHZTL7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5185.namprd15.prod.outlook.com (2603:10b6:806:235::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.17; Tue, 2 Nov
 2021 18:59:52 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::30d5:5bb:f0af:d953%9]) with mapi id 15.20.4669.010; Tue, 2 Nov 2021
 18:59:52 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Jens Axboe <axboe@kernel.dk>,
        linux-raid <linux-raid@vger.kernel.org>
CC:     Guoqing Jiang <jgq516@gmail.com>,
        Yang Guang <yang.guang5@zte.com.cn>
Subject: [GIT PULL] md-next 20211102
Thread-Topic: [GIT PULL] md-next 20211102
Thread-Index: AQHX0BvRlyFuhQG1F0CfdSEjDtOucw==
Date:   Tue, 2 Nov 2021 18:59:52 +0000
Message-ID: <B99EFF4D-AF56-41FB-AA4C-E42E05263D20@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.120.0.1.13)
authentication-results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=fb.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a78834d2-ea0b-44ff-9461-08d99e32f396
x-ms-traffictypediagnostic: SA1PR15MB5185:
x-microsoft-antispam-prvs: <SA1PR15MB5185F223A2AE32CFA0AD9C27B38B9@SA1PR15MB5185.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pdIsLcDXvvAMrWcdR/gifQQq6LLkcYvYIZBL8beLeCuM34GGcwE/TXKgbqTWgRYnDt25jn8Vqrxp7N5N2T9oP2252QV0NOLavIzQrCZbdBtUCfqBWnlEDsJ1ssu8KlA+hOhHYmnvyAW7ehf+8XCjdMJBCKB2XHxJYx6GpBbuPrwTNycJaQVyghlk2TRksu96KnAplP2MUKgwFwiIs/2PrbRSCsoNnkMCafG77LCPq+ATIIi9APe6FMxUP9zrYsH5uLLqEfr5Hv+fUotR4keRtqeamAaqnilGHQq/PrK2PAFdqrka9bkbrncE5880XosXORcHCPNY2/1a0vuN3DOfN1TOjJq1vME72mE65eOxN1eiFLDcaGoNDDhfd9j4Wsom/vgh6fyO9IzfGAYhFB/TBwuxsTQxb8vHQPvGPCzILLUP2firSr7D0+62X4KmIb47w9zrDt6mgS3SYjc2VeuMHK8bav39UzvBgJd8vn7u4Do0h00Z2LeiFhv40bQ2anVG9kOSMW2c0PbospXmX08vGbk5BG9kDKrjjAGDEtjKLtiSHfA/QQVRwJTQD3e7vvnRa2X9HkfkUUheBWCzNZwX2bpH3t94QndfAiI01EJ+JL5S5tM7QWrfVn9Skdx9/nmm46+xhpBRVfQqCpTIX2g5S+PhxTWU7NsNPTMAGscOhBfm9qDHBI8nUAr/MSA1CdS4PNFYFSoE/zsU5JRUvR4Zlq0MB223C+2EFlKBP/wjLt6jdwL4goeyKaL5FHdxFKGpl2s+hyPLjDC2pQhDB3uHFnaQv7vEIhivFy+bG2ynuPMTOFIZVV6UNRQNiSblsWeh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(66556008)(83380400001)(66946007)(38100700002)(64756008)(966005)(66446008)(66476007)(91956017)(76116006)(8936002)(2906002)(316002)(110136005)(86362001)(122000001)(71200400001)(54906003)(36756003)(33656002)(6486002)(5660300002)(2616005)(38070700005)(4744005)(6512007)(6506007)(508600001)(186003)(4326008)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yzLKe/+4j7pGHpc15BQriKkgPqC/i9VnPIbwgFqePwPL2fCmHd8Ngi5goK1W?=
 =?us-ascii?Q?qCyUROf/iM4LtllMYJnrqw5R/mBk6NmqoST2x1m7zoZ/7WbndZGCKZYELTaE?=
 =?us-ascii?Q?J+DWvSR9760lY9Vs6AgMALzQgCLskSziy+MS0oh7QJ95FE8zhku8Dga3Cjou?=
 =?us-ascii?Q?j6Frty+jTVMzAdgT8EGI9xIvgpXoQMGuLJz2u89GE2nHA/T09ZGSUxyi1JXB?=
 =?us-ascii?Q?jCnQJM83sgiuioDRvJPc/ZVPI02FONjTebRiq/EKAdDyoTpyLgZ9mYFJEGcV?=
 =?us-ascii?Q?RfMj+CmAYXJhOUHazaqXr2aPG3AZGDOb6ASbn2WHIsZ9oRY8xfLGL7InLQqo?=
 =?us-ascii?Q?+Yl3PtHWTb6FmjtS6lU/OU9LUsEJBrBkFa/JuYZfVPpGQotVWbidnFRJ9neY?=
 =?us-ascii?Q?tmkZICfzWMEe7VAcnbRWwp4qNUiwF7RZrxs4puJh07DZxDAJS3JMjrv9Dzn0?=
 =?us-ascii?Q?w+KHleOHwWBMMxGZ8ZloqMwmxKv2YMrXSJgFX+CKIbbplbEZyORCupqucbH6?=
 =?us-ascii?Q?AbiyOeq3DL0XVKL9Lh6M+7YMaP/d6c7B1IG6eUHU5wxSJ6+JV7vg5DfI8D9F?=
 =?us-ascii?Q?NN31iJn3tU1GwiFYTwCqjnP4EZOw/6/SXdxTDtfI8L5gKvyyPzkoBOxGsY43?=
 =?us-ascii?Q?1knr1JaVU8VRUB3ymJ2ok8j5pmGdnZSVvIpGDfupNg/GwSZzH7muTwwZNmdc?=
 =?us-ascii?Q?Pch6+BhSAGDgR2t67y6Q7fAxpuelKek9MqC+k9apa3TWo7e6bCcXg3a6DW8m?=
 =?us-ascii?Q?hAZnnl2RM2HC81Kba7MM+Msmdr2NwK75TMgiSHi0LkyKuTeMlodDPlaF10e7?=
 =?us-ascii?Q?c2/3Y5N52QsOqbwMzvDFvTpBqCJA+lZ4fz2Jfx6E5YFcoq+UiisST5F8saoB?=
 =?us-ascii?Q?k1IXrOCSNjp6qTsBpjZ+Mmo6f75oChOB6rwVhCUwSgdp/7Gp36TZYPurRS5/?=
 =?us-ascii?Q?2C0/lA0CZ+wcQySu96PHOSJS+thNMlI/3liDTcKlARLh51hPmkTU8PZFxyhF?=
 =?us-ascii?Q?km/Bw3p8S2rLb7OjoBI9HO1csX1hhLRlb6oCRsMLsKpAs55b/XIE7BtH5t5z?=
 =?us-ascii?Q?+ZwzziGpnoCjwPMZXng8hbgmdSexHXEUhcwoewMQ9RBctPkqcvvKJ/VLdVwM?=
 =?us-ascii?Q?Z/ElHJGbdS95Jk1k/maEMhlLgYLnb/716JOQEEBYCG0qLdO/oOy37FkJV65X?=
 =?us-ascii?Q?yFyIQSon2D1PKOyaO1MN+4bDwROmF3i8vwzOrIBA8dJPA7L5RQLyuGfr+nYa?=
 =?us-ascii?Q?slTjqhZDGlfk8x5JiMOajJjnO9EnzEXZJP1uZ0hT6Xo06zFERpu/JpmFVo8S?=
 =?us-ascii?Q?BRXg8pmS2jvfXsDtRBhRFEl34IJuWAVUyBzXTL67MibBcnG98+3+4W0Js/7u?=
 =?us-ascii?Q?mqd44B/PZAxI5VuwEyiEieH2Y9kLEtLFy48WPMVE3bRWYO0neUTzTsfThUwJ?=
 =?us-ascii?Q?rifYcv12neKI69VvAM/8ETyQ1DI4653PdRItxn6HqiDlWIp3tf2VeYO0PJJh?=
 =?us-ascii?Q?jfGW8FQSa1ogly6xjIizyfXBz/NCEhNlkOb2MXman0X/lnUFcYnYeH2dTqiL?=
 =?us-ascii?Q?qPtQmYfduv0v3wMVt70pv7LPQ01HHChuBRxq4vwY+da2gP2FxDkVvKxaCh8u?=
 =?us-ascii?Q?hF6d8R0uk/6dZjxk57gn6NFkKCjKHfMkrncbc/cahZgfCyRbdx1I9Dqish09?=
 =?us-ascii?Q?Srl36w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5695406BFD0C78438C2EA835B01C3916@namprd15.prod.outlook.com>
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78834d2-ea0b-44ff-9461-08d99e32f396
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 18:59:52.1124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: blnVBtgBfYZTK/9HpeTu+fQ/jBkF2UPztspLA63G4uFhSlVgpEHJh+qPDxkA16/f/D2vBERcrhoULmeK9ij2yQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5185
X-OriginatorOrg: fb.com
X-Proofpoint-ORIG-GUID: PP0ZQYmHwvZ4CGf1FNHwNDX64VF7NL21
X-Proofpoint-GUID: PP0ZQYmHwvZ4CGf1FNHwNDX64VF7NL21
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-02_08,2021-11-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 phishscore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 suspectscore=0 impostorscore=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2111020102
X-FB-Internal: deliver
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jens, 

Please consider pulling the following changes on top of your for-5.16/drivers
branch. The only significant change here is a fix in back_log sysfs entry, by
Guoqing Jiang. 

Thanks,
Song


The following changes since commit e2daec488c57069a4a431d5b752f50294c4bf273:

  nbd: Fix hungtask when nbd_config_put (2021-11-02 10:50:27 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

for you to fetch changes up to 1e37799b50eccb79c59c660b330746a7848c346b:

  raid5-ppl: use swap() to make code cleaner (2021-11-02 11:41:45 -0700)

----------------------------------------------------------------
Guoqing Jiang (1):
      md/bitmap: don't set max_write_behind if there is no write mostly device

Yang Guang (1):
      raid5-ppl: use swap() to make code cleaner

 drivers/md/md-bitmap.c | 19 +++++++++++++++++++
 drivers/md/raid5-ppl.c |  6 ++----
 2 files changed, 21 insertions(+), 4 deletions(-)

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3BDC4361B
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4A2F22513
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgLDD13 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:27:29 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5718 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgLDD12 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 22:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607052448; x=1638588448;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=Yu++wpqm7nVdvkyf7BL/PKY03VqhX1j1F+nUCSagzkc=;
  b=DSIbpVEoCpxCMqDFhuEGF1W7FFMqFGWCJ6QUFcZFwX+wBeWlEZjKUie/
   MPN5wzzzrgB8vfFpWYw0Ue3nfBFO+eksmTWpaHaAeBT0IOj9en0AH3uHU
   nqW64lZo8Wa/01JtIGvgrO9X/XAEqbwOoBaf5Lph/QjkqdapqKpjf4R5W
   2+o6n7ygiLS+8/EbVUlc8WQ2bTePwgjQr5bbwr4XA00oYw6g5D4zx6HDe
   K3CuvPpZxyHGjZ63sUoRk7+xOQmelhrA5NZcwljCJaG7V/t20Dx6d/Wwk
   ciTvAz5y1/n30ypzxYX/0Pncbdz56jl8xRjqeAN6UU9c/Fu7koWQdmenZ
   A==;
IronPort-SDR: YXlJoeMZRlFvpnNuov4S3+4RSS3+fsNmDrW+FpcU16ytnMvEwdu2rxW0oFdbTSBeDUiWu/4Nme
 /ZrajKu0OKBuFVa+cluOkBRTDCXpvyVvsJgfkQPk1WB1AZrO/E3m2M9Tk2uABan1mk/D2TOTW/
 iotjUoBFpV225xZAzR0YdjBDeri5ERAg4ulSftAOpHvGOx8gmt1lrQikMosqkxX9oJetdwZFQF
 rsWFmZJKkC/woB1jDlFSEWGb+Y90kWsf1eUYCedh8BgmDrp3gZ4M+RdbaEY5V2AUXWo1/x8JPk
 jWc=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; 
   d="scan'208";a="158871714"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:26:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRAhBjL/qD2jZOFQK836Nt2dmfHaOTsC3+I3tOqDsMqaMT04oio1ewDN9fmbB4SsKwdf0TB2Vg7XCYtRGENb04Tu6alJ9wMmiJD1ltazM8Mt6/XAAdJmmb61nUfRphGwa0WEjfUzV2FXgo+k3B3OC79fDj4xQLhCTB5o2xJ9zP4Ly3KjoWNCRjC8xX5EPoGVncQ+Ofu+fC2p/UxhYtwVBlnisa73zlu4TevypPetXyRMDDUU4q0w27ARVEYeED0cuhJ7jLsozxcq1i8/djnLpZK0sBXpCOFQdu2Nrkfw6bCfFqYTlg+ekWY/HSrNERkHsJoZMsyk7N8j+VB7sp/IcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu++wpqm7nVdvkyf7BL/PKY03VqhX1j1F+nUCSagzkc=;
 b=Q0IdU7gUBBAnKLJJE+0kdSjx3h0N43HKlMdfo2VpvRffNJD7LnwyzrhlXxjTh1xpQ8R/0uqYra4Z5692ZrLVdGp9WBb9XxlJr28Gin6hSerq3vqMALEFjNmZBTJRiGZi8svdn5t76kbhq7/nAcp8dnhntOQXhH8c0lak01rKqUcBlE9QZFppvcISTMIxxSGADS9KSc5k6/n4wqCWmyjJ9NRuFWfO6VcNYDTanbYkrjp+P/wDC4ll3nKT7y6pyr/LfRgkKE9pqnSzCImrZeCWn4PK8ONzyVVtDYnFwQAZcCGXbaFnGuFOW6wbUUx6CQgic21cIo6iCVSaPpUbQo0Eyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yu++wpqm7nVdvkyf7BL/PKY03VqhX1j1F+nUCSagzkc=;
 b=oecfVqe9S2BwWC9aZFwM86OWygxiG6BstTBjhSOnBLo7ZJxmMU1YwYuYBy8MjZK6ozDMZvOZTK1J9c/NJOXPFSoREf5GJnaFS1IMLuzkx+X/BsU4Lvvy2KkIy5ew1ORRgkzIvBSi8kYCxvD5Cu+qVuomthgptykvYXwdEXEXHE0=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 03:26:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 03:26:40 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/5] block: remove the request_queue to argument request
 based tracepoints
Thread-Topic: [PATCH 5/5] block: remove the request_queue to argument request
 based tracepoints
Thread-Index: AQHWyZEH9I3HmpQdbEaAKFJpCqVEAw==
Date:   Fri, 4 Dec 2020 03:26:40 +0000
Message-ID: <BYAPR04MB49652797046268186CCD404286F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-6-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6ddbe082-2b03-4175-3ea3-08d898046aa2
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123CB88A4B36159ED4555E886F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LlyA0bFNcOTanvc7/1m93CKrT5Cg00O6926GiSUGT/+bTGzWe3FRonO7M05O4GWaqHGV0nbsh0CLngsT9F1b2c1RpI+02SgxBej7ofeteprgi6nqpfwt+esO0nmB7/ov+bIixlGXQbarGHWU+O9OJ3mX+I/ILmE+a4o8ZVSnf6m1/rYiKztwzepci0ZHWR3jGqE725A7Rjk0K+Ea3T/NPdBs9AEIacK32Byr5QfIFkUPZsWTa6kWW8s6ftk5FJ+C2Flu0CRzQXBmKeCo9GiVUUNZDb0+xln1O5atcr3aLOB4sm5K+T1n+DKSk11zVZd3oViu+a+Iqms/X6N2tHEz7g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jehvkHj44GzbPPhJiu2rVqCyEtd9gao9KwB/nFR4yyp5+KkLu5HslmR2S4i5?=
 =?us-ascii?Q?aMf71l53ySFYec3C+AA0GdU2LAq15HgHFTqa+lqE/uHb1HJ0BFS2X36b3Vd3?=
 =?us-ascii?Q?dmGUl2TuE9QyBc145yNJv+zHUWBCYdJ/mW2ZysVin3j8tdOL1Ne6I1sxqaTe?=
 =?us-ascii?Q?GRQhQr5v2mCi0gl4K9z6layiRdAqqD6diYycypgkx81bDqOTXQ7XNZxYH73L?=
 =?us-ascii?Q?dcC6wrtpJJ3Syj/w90SmsYp4NkrgcN3xfdpoCY7yVn5ojk7VOGEqPyRSBSoM?=
 =?us-ascii?Q?PorBt2T6uo4/q3H9yiRqH3kYnoq552OGkZ0X2colPmS0pAozKNM5fuJ+z+fk?=
 =?us-ascii?Q?Cpyv5LqvOrAkJkCVEQbs5jH9VMPhmZ+uQ41bEuKbusnB2K34nZeQDtfhWoEL?=
 =?us-ascii?Q?NLXZ0jqzP9j4Jy6zJhr2du7PJry2zbsKsOyH9edFEcWXWjyytNA8YK6TDsUO?=
 =?us-ascii?Q?6eDXDYvsBmEP67tyaqeOQXypqs8dPIicvbpiRL8F8ygD75mUEro1r7QvMv+i?=
 =?us-ascii?Q?WemKEGgmfvwcsCGr9HCfwxqz+hhehKW7runWzUUgSdvfoLAt868FBbFsMis4?=
 =?us-ascii?Q?LY1xMuwCdsg5t2R3PyIMLA/mouPn1sCJ+3qT1OI4prl/vzf9VYP+W+FGU21+?=
 =?us-ascii?Q?KMaO5W4tmJxnUKEmNSKcTwttvwSYcdppCelTeHMEFzfT5OBXi25UTRL6M1Jz?=
 =?us-ascii?Q?XXorpEdkSa0TOYDwb4kk/YRc/loebj9hpOP83mFJPMPCCT5qgzdS7+c+r8rj?=
 =?us-ascii?Q?EJEyMk+XNSoIUbHaYq6P6RVGj5iAmA95se8hK/xxzNujYM5oK8bDCrHa0S3z?=
 =?us-ascii?Q?67/ApvmA6ijt1dswYnT666zz+85P8mp9NGxHNcC0ov6lKvPGhwxbAbZpmeh6?=
 =?us-ascii?Q?/vq7b9dbXEN6akgXATVivjX2flz79HNBMDbIuDZfVTRSO+j+OfrMCBQmL95R?=
 =?us-ascii?Q?Dlas8PqqPlUdrOLFG19DmegW9Gwemo/b0xk58JJJsj4rsFu8JPw65iUOr4Ah?=
 =?us-ascii?Q?cVrH?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ddbe082-2b03-4175-3ea3-08d898046aa2
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:26:40.8794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kkx3FLELLfmQBOqX6XmzcsGGKoYAUnrl/yFty+PBxSBW1XeD6oi0RJTxU2M+rsV+ifPNliF40tyf2/7lnrkaChmyz3qsy7DXyRynrFBOTkA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 08:26, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the request.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
> ---=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=

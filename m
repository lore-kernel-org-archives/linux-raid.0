Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52EF2C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F242E22517
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgLDD0s (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:26:48 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:5718 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgLDD0s (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 22:26:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607052407; x=1638588407;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=xru84o4wdpqwtbimJyNjRjF0tFVl1RDIxXrfxPGQV0M=;
  b=f4Q0SsUssTe9jvIgK++ma/KcAQLVvwh9Dbau6xlb8JVoT0LcbHBLHtpF
   pp6FpsCUVcGnF9DyA1vvbta4tVPu9fay+X+Pb7F38ko+2/ahQzZ0KdVSA
   DILWXkLmQLiGoChci974fP3JaRMeLmtajRlsZ75VJBPh7jPlc1BuHhlcp
   MxV/gJk8t9xrZB7CJc1mPiTbP3FjtLHP2UM40lRPi5fDJVVR1CEATwvxg
   FEyuze21cOvR/w66jgVICneAi08pzn+XEJUnZM1UZ3aw617zw7PdxSKDp
   rAoszOqBxEFQfiC93ioGcvakmKJq6faD06roKVacO1+aW3ovJpj5jlIVl
   w==;
IronPort-SDR: O9LN1l2oY9cZQakA+qQcogrRIeadm3DIscpuadbFTjZ5wItaKY9ewSqXCjl1+eOpkMUQFFIi7y
 KS2re6rvYWk2t5sjjCwSuTbHRwTNqGQPEi3TAzNlPh7Y13OIyKmuLFYT6Wi0HPyK+h0SqgFlZ7
 QKX5udFYbegLf8DGK4YBip8aomBevwGNGkm+AT2h9Tf405DhdniUe6nWD8v2+Xz3PQb+PAVBYm
 fVaAqCuYr/H/tx7EbDpwBfY7ntf03PoJWmpQe5RoLxBqCN5O/f9Nsl9H6qXOQQI9SQ5DxgEonq
 ibs=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; 
   d="scan'208";a="158871665"
Received: from mail-cys01nam02lp2051.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.51])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:25:41 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RzDmJHDRWEgM02DmxKBh3rj5qZm0R86qwDCdI9pTFIIMkvv/8x2gK3GOUEFUli6tlCQDa9fkmBLjc5PTis2vA9K3oElQldS0ChIVbkmTaUxbdF3cjQ8EhVSbm8SMpVKeHcZv8qZLEnLvlOGQsVPQ53dQmHEBps6xzpHtGETWn/6FTgoibHiRpWIgrDj31oVITfebe0QbLAJ2tUPv7z+HrF8aQTgGrHD8tr16cLYz/rI0XP51KzKMJGdookpWQrgWCpbqhffxttE1cMnvVr7/BKeqOaaTLD8rIV0O27Sf1vKGZxRIgwFEgZqnhdVykHp/nSuWkd5TRZoNTfvEKbvZ5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgBv6To9vANB6Mgt0F3zokgckGIyUOVTHp7qtfTUwLQ=;
 b=JD5q1V8cY+RPv6a6R6nEna0u8+M/pk/zNrSlD8PyNBoIYALjA4LgPL52KmQaeiDmHuR70fwndV9dBWZ96K8Jny9wKDCbkejlFPa7qiPMfMos7WqcSOes8OQ45JgKez2u+QuAMt+1/AvMPuHAVHFBPa0V+UvN6PnNADlEF6SjO95kSW4nwif2edaz1ivj+lW/Q0tOesISXQ0/VEJDPyE9lVfHD4tSC1FZ9q57Wvhe4w0ugNFLRfnra2gV7v36JiAHDckoLAKgUYySQFuoSdCtPLF8uY4Qwp5iGFgrXEKxVmFbIiIfq9b8DQ9MnUDJAFOQAE0jHG9vwnHC3FaFf6fHzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AgBv6To9vANB6Mgt0F3zokgckGIyUOVTHp7qtfTUwLQ=;
 b=VF/0mjnTtGPPawOZ5tLWvcYdaaGO8iKeJBrWoZETC4yuzXNvqvVjz6tuDX/WgK0SEovLJw39wIuhBjvxAl0vTUjtiQ0NtxGX/CvWVaA4DnjTTXPXThkeP5WhOh5ejLgfQGyvVLxHQJTezgD8mr66UiOHgPvTMgEWY/yc+6fOstQ=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 03:25:40 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 03:25:40 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] block: simplify and extend the block_bio_merge
 tracepoint class
Thread-Topic: [PATCH 2/5] block: simplify and extend the block_bio_merge
 tracepoint class
Thread-Index: AQHWyZEHILLHp+PoBkqSaJmYfzy5PQ==
Date:   Fri, 4 Dec 2020 03:25:40 +0000
Message-ID: <BYAPR04MB4965479E53991BCE68F1139386F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-3-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: ac388c11-9e74-4781-5a86-08d8980446e5
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123C6F9E3F0FD169FCF49A586F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vfB7oPv/185w2bm/l30Fscpz2nhXNa+DngFtjep4noRPtLXbBbnIgG+HjmcN9obpc4zjKg8n6tGwTz+ZkuD2OiejZm+o+Y3+gFuUUZpDLyCR5XHAY6Gw0WMo8ry70lhYVE0IjFDXS44aXDfPZY/+tHWhrczoTlTdYZ6bNuDEy4Igrh16znKD4W5qfI6xpdAWVGy/lJMr367KfKL/qlD043ESf5yavlhI5ojZbI97wMPbGYxV1oCYDbXIlgC/gutsENwpi9TVqVWSVQGK7oe2Cx8rIocr4MPlsbeKoOaMA1glsq0/dlDQhAzU7/dDYSyNpbgmgzxOiDaicXEsAENppw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4744005)(4326008)(54906003)(316002)(110136005)(26005)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?pCGITpCFpePEjcgAI/h+eeaeUlrHCXP1rHBleEBsIho8OqmsXqX2oxphHNWy?=
 =?us-ascii?Q?WGMgJ6Cw7wWksZ/3kks0wHEuiGY08EPddgfZxglkgByNMJZbFxzAci8S8BiN?=
 =?us-ascii?Q?gO+XgDM7sZAIEfdhXky3etzuzctJ9tiI3ynmeG3BVVWW9xw9OtLAShiOjTRu?=
 =?us-ascii?Q?DpJEM0quzd1Zh/KAUa5hy4+91clUy/NSWs5xzDqbtyGKqQGcJEC+Wekx4Eqp?=
 =?us-ascii?Q?DFd0Qrrg9nOQrw9q9eCFMevpWeQcTDMM1peGDrkyA6jX5aFeyw2mF8i+oKFw?=
 =?us-ascii?Q?Og7kE8r+NlRFxK+r+0FOGSPX3EZ0vL++q+FR96R05TX6O8O+jgzGZOKL8/ev?=
 =?us-ascii?Q?osFiojUxLnQtBLIYb+U5frGo3Gyj6OoygpJr4L/9L/yok3gP2skqLBKViZXW?=
 =?us-ascii?Q?JMVwdPfEd4LxZCRhIvpWI624BQHMLjps1Il09uo1khFvk5amddvOpoQBqnUu?=
 =?us-ascii?Q?LzVjeNede0aa5tz5RKrYBTGZk2vik+y1DcNprg6qFQlx601KV+Szw9pKuhu7?=
 =?us-ascii?Q?mZRDqScjyPQ2jCRByIypFMAvM1W/IQwihd/A1uMU6s83gXmwrTm1391q58XD?=
 =?us-ascii?Q?UMuIJtZMB3rl/R7t2UjWwGcXrfgoq8IZjZ6EPRlB7dKxuS5/xSufyB/v0XjW?=
 =?us-ascii?Q?YfU+KFbgUpb8oyOPTkRf+yvCyCWPRXAxo4LxlFazmpMAXM07ftyBMmUBHafe?=
 =?us-ascii?Q?IQiFDldydjzCfLAjIUb9se7vJ5VVQHgfFhF4mgO/JuEGb0ObuzQWU4iE+B7Y?=
 =?us-ascii?Q?v542c0BRA/LiQIxEeDzasFNbADx/v4ymVHyGxM+s0hXPA5VBVpOZQIAPiycM?=
 =?us-ascii?Q?wyqJqISD40XkpYmXToLc6egkdHQDg0MOASn8z4+K4yWllBybqVaQ0zF/5tGw?=
 =?us-ascii?Q?OP27fO+9Pfp4SRT0Tp1FJSZErDgoftqHEoeUGv7zEqEjnf/PaQ14BJaNwG+7?=
 =?us-ascii?Q?yLsv33S7X/f8NK+upMzwcmkS3itpSwpq2HVGZ2dqKG4okrjv6rfouMKFNOuH?=
 =?us-ascii?Q?G5Vi?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac388c11-9e74-4781-5a86-08d8980446e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:25:40.9002
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /vJ5Fcen7HhPxLGdM0BQLmC8yeSosIiQZXBSJv+zrHvPW0Yu8AoDW6bBd5/AYH1rUY2Mx1Cn5nHqLumma7q+8CgLt1dfuEMjuj3a6XNSZks=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 08:26, Christoph Hellwig wrote:=0A=
> The block_bio_merge tracepoint class can be reused for most bio-based=0A=
> tracepoints.  For that it just needs to lose the superfluous q and rq=0A=
> parameters.=0A=
>=0A=
> Signed-off-by: Christoph Hellwig <hch@lst.de>=0A=
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>=0A=
> Reviewed-by: Hannes Reinecke <hare@suse.de>=0A=
=0A=
Looks good.=0A=
=0A=
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>=0A=
=0A=

Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F651C00A8F
	for <linux-raid@archiver.kernel.org>; Tue, 24 Oct 2023 16:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234899AbjJXQzj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Oct 2023 12:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjJXQzh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 24 Oct 2023 12:55:37 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 24 Oct 2023 09:55:33 PDT
Received: from esa2.hc4949-98.iphmx.com (esa2.hc4949-98.iphmx.com [216.71.141.110])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1BC122
        for <linux-raid@vger.kernel.org>; Tue, 24 Oct 2023 09:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=openeye.net; i=@openeye.net; q=dns/txt; s=CES;
  t=1698166533; x=1729702533;
  h=from:to:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=UujI/hp9N3CHeL2Jefq7+71oWG7hZe6f17nT7QRsK1E=;
  b=UOAdGz03VSPBkD+quAdVz0VcDra3qg0HS4/5SYtUeZ6xjBFkvyMhNGTh
   RIh9EE9u7OMCSY9CSbkC2o3YJb+xIrmSGGUQvrIndq+1o6+juyDoscZpo
   zrV8mZ2eY+K95gu/EHNLaCvcwLXO8E7CsRbgB8ox3GbxsbAIIiJaLkJpY
   s=;
X-CSE-ConnectionGUID: KraFb1jmTva5Gm9WOUeICA==
X-CSE-MsgGUID: Cgf8L8cKT6iN+PPxSAVawA==
X-IronPort-RemoteIP: 104.47.70.100
X-IronPort-MID: 83250976
X-IronPort-Reputation: None
X-IronPort-Listener: Outgoing
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-bn7nam10lp2100.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.100])
  by ob1.hc4949-98.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2023 12:54:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPQSjN3he+DgAiezC/1rzAG4gI+cA9iU+EEATYIh4jftv4H+9zcWAddGLf0f3LooNF50ap9nhJGngfhLDIAb+TAOLLIKh4nkA5/d07GHQl6qIWwITzlr5cFQtVMrhFOHOmiwoYiReznu36nfZP9gHVLsIPcKEB8hLkT1bQ126qCdQiHN7zq9PNGHzmBlPoEV4CRl02ozldmtKkpyRXLcpuZ3OJ52nkVZ+XjSoFYgKjtEjhxXL+9J3D7zvv69rDgJgV6dYxe5FboGjqe9dUOu8wZhmsnfVczYINfiTdlqqfN5TGMyRIdwqO+UqMiJLLpKsp1AIEOV2NjJ8WjbouywbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fiGaLEn5iliZN9RNHD42wf096x0tulPXOYGlanWpP6M=;
 b=BHI1OHKKGjxS+NnWeM80952RgPMRuK+eZ8lsbI9RjlMEiLaWinH0bkjz5fRpnzhdHVhU7k/5PbvYym2F5QamnH992YmSuNM4a81z6dTnmA4VLTofZ8vpkT90Ad9H41tJ+1sJIormOYu193AAEOr7FXSWGnHKDyWXltw5DluPgZRHWZmFQ9s9ruW1XL+u18rAhAWCYFl1CerJVbhnYicyrGpWpHUNDxuqymNBrMvUpLZKFjS31mQUiRa8Qx+3FHEnnHXSxOovmXIWVkka4YbYcpQwtt17fQof7fo5MDFfdPsHxtda8ZXKYkR7W3zNOtiniaPdZhf8GdxqQmJmJTioLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=openeye.net; dmarc=pass action=none header.from=openeye.net;
 dkim=pass header.d=openeye.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=alarmcom.onmicrosoft.com; s=selector2-alarmcom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fiGaLEn5iliZN9RNHD42wf096x0tulPXOYGlanWpP6M=;
 b=UlMTMQAlw9KABvmjFUqqGQXK9KrPHtm0F83l774lgGd/s8wCokJkprAGn3Rq0uyF/bxyk59R7p2GejWi4vGm440BlB0ZKP0Smw4q8uTROeOxfB14nKvIPl/PKCBWlCu2mMS3g2nNCDk0TU7Iy63i/zuLmatpPBm+WEVCYMGxTEs=
Received: from MW2PR07MB4058.namprd07.prod.outlook.com (2603:10b6:907:9::28)
 by DM6PR07MB7066.namprd07.prod.outlook.com (2603:10b6:5:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Tue, 24 Oct
 2023 16:54:26 +0000
Received: from MW2PR07MB4058.namprd07.prod.outlook.com
 ([fe80::df66:b741:8129:ca69]) by MW2PR07MB4058.namprd07.prod.outlook.com
 ([fe80::df66:b741:8129:ca69%4]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 16:54:26 +0000
From:   Laurence Perkins <lperkins@openeye.net>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: mdadm + Intel 12th gen.
Thread-Topic: mdadm + Intel 12th gen.
Thread-Index: AdoGksiTIATBqevxTmykChrDuuWQGQ==
Date:   Tue, 24 Oct 2023 16:54:26 +0000
Message-ID: <MW2PR07MB40585189F6AC1CF7E8113790D2DFA@MW2PR07MB4058.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=openeye.net;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR07MB4058:EE_|DM6PR07MB7066:EE_
x-ms-office365-filtering-correlation-id: 2002b993-95da-4e28-cf9b-08dbd4b1e1bd
x-outbound-auth: mysecretkey
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4b6gxSz/6n+SBS5WR1HawnVgJaubRo2Z//IKiNtwJnZ9dy5F07QIL2LlCh8n2MypYJqF8Kusc/YAMDbCkldGG7ux2GnEGTTg2iPFa12CPL35oEppmfv7twVEPxSX9ZKRmuQOJefHv7bHWNkXI1mZjzU0IwJ099NjKB1iWusfG3g90Zhc8H73joM0LRZeS+s/a35w5mUhS2aLvbu7N/6+Hik/vSMHMee0PVSgyehsjf8kDlWRvFdgcYhrtQXDBNmDoNZq+Nc65d7M1BBuzU4AHzKN+sPVyms6s4u8m5/cdhzFhjPtGIv91UF6tk57V0/JjTx4yCLbyyvm7ietyGvr9aXLX+V+mKtEbTeztVBVLpYqpnET/aGjEgWa5h/zVX93oM6aX6nPt0wOQIHB+XM3NHcJgQPQqY5eJZDUlpqTw+wocQHTPyV24iOCwFx7iXNVwmrcsDdL94EJEoF1W9a6CD1zlT/xgosGoUTyGymUFBmgDk+RkMjH4lC+VmXNl8HxmuilZhcEBL3b+kRNqxVTzOGRDCHEVjt1lzzaBij1KjNjqPIEK6i6iQeRzY5jHiYC5xyqyXoK1x6jPma6DWa41tsce1JEdM5waqUCy3z/cTg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR07MB4058.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(346002)(136003)(39860400002)(366004)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(38070700009)(86362001)(2906002)(55016003)(41300700001)(52536014)(5660300002)(8936002)(8676002)(38100700002)(64756008)(66446008)(6506007)(76116006)(966005)(71200400001)(6916009)(478600001)(33656002)(9686003)(26005)(316002)(83380400001)(66476007)(66946007)(66556008)(122000001)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TILGtii4MWupkp6Ix4/rHlveZ407g0pO3KCuDHjGrcZ2CFe3xBr7mxpUx3eT?=
 =?us-ascii?Q?CNJiS3imWEepBljzwHK304T+O5QrZil0Qjv6fv44wKsDlUlN2uVW9POLES6K?=
 =?us-ascii?Q?wK/DMZn4sYSM4uCocXC0sro/6Dp1xtaxH0FWiwi5c7aqTF0eRsW/6DpzFuBH?=
 =?us-ascii?Q?6p0fjgkA69QOimGBvivhfJy/AwXKC7wdM5uOFixqtnraCVcek0o96/SfoJiE?=
 =?us-ascii?Q?LQcpqE0nvLNGdz+Je6NONfu+P8BbLe2XJCFVvn//3kYkU23FJSXRShYHdmdx?=
 =?us-ascii?Q?6igf7dlzG75KKlhdwb/xPmv145itrUfR3JlQX9pAvQ4eJq2ruFUOlRdOUYg4?=
 =?us-ascii?Q?8hMBfKrBKKB7Tx3sj/9wnn222iMGMZsU2gJAoPqgKkvp2nVB0VHJziva6iY7?=
 =?us-ascii?Q?2EBQ9IFb/hYhNw7Uz2880X6j8p4qf8WiqH6BAwRQz7bYS3xn7cuO9xnIIyKB?=
 =?us-ascii?Q?Lrtevk1IjQPHcvtGkk7ey8f9QjDNzMayrtXE22Dl0fUv5IapCLIBmcFgQTZJ?=
 =?us-ascii?Q?4c6h5RBx8dWKl8111fY3Fii12dntaynPU80nDj4K8fG+ANfVYeKpjeygdS9I?=
 =?us-ascii?Q?ZOCETABTRkL7VL80knhTNTjSD/oFiSGV28VR6bRbDf5zjKYUH0jsRr+rQfkU?=
 =?us-ascii?Q?tpJNm6bLfdwwqc9N7Iz3tS03QGJ0tM4PzsboVJCmr2L8JTGEgwNWqhLPbtuX?=
 =?us-ascii?Q?jxolSk1qt4z8mZaNrNHv3kdyaEZbAWv048EodMAyuLq407wDKszQw9DRmFYD?=
 =?us-ascii?Q?lgSe+wgy8uUpZi1B0uC9hyJrp1M30TYwjgBPdJAEqltViwO5uAg9HDwuA4eQ?=
 =?us-ascii?Q?dYcvcu6qykClvLbn8xQSRm58J5wJj19axp5GpRJ3R/X8VNcwOHNEUFXbrhgE?=
 =?us-ascii?Q?shyz6EntGHIUCWCVV+iqDxG0rbnWHN9ArYb90i3Zi2JeJnqXJ6rqWtYvURbK?=
 =?us-ascii?Q?zTeH6wfN49Wv6+aCqw63TMw2k741YigpWJRx4KUvgy/4Z86gEAlWfFlw47S8?=
 =?us-ascii?Q?QRmXQfug+rTa+89P2CCRTqtlBQptzkbk22WnX310scjX9vAOMrkxG2eJzq9e?=
 =?us-ascii?Q?1G1iQ/kE2zrObvrUcp2xYQ2M2B/u2mt3CCyqZf/4jIldfporMs8NhxwNZfpR?=
 =?us-ascii?Q?8ErsCdy1CjoCTJdJBKRwIc5oBuyNwZ4nQ5w7G0ZQscxtcoFIcpBr+/9HDCcE?=
 =?us-ascii?Q?6sFDr4FOhMGi/FLIJXQ4zYGFe2l8d0ROf+Y3K0ZLlVUlPijIbT3HPCyD0Vtm?=
 =?us-ascii?Q?z7WeHTfXIakkOBp5W9xr/vQGT0HK7/maxdpIggWP1ChefaFT0wIo1c9H5c4K?=
 =?us-ascii?Q?KcKZKE1upOcpgTl8KmGSLW03Gjs1uDuS1jIjriUKgWQVgTVKJ+W0CPrjCfWj?=
 =?us-ascii?Q?xGt+GAHrzWakE1tg8J0H91TXIvTX5iku3XRKrzb1k8QEidhSk954VmjLXBzC?=
 =?us-ascii?Q?iggbY49NHgdpD4XzA0nu6c26iueXRILs/EZHM6zQnvATq/7DW42RS89BbETZ?=
 =?us-ascii?Q?KATBg2pYCpyYugG72HoRSDEHEUolnZKMMbVT1a8IwM7S6zhIM/4ve3cS3ArU?=
 =?us-ascii?Q?PHyMb0pyF/5srZWstm0pUAkVlJAQ1rr+KrgdK3/S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 1sMOw5aFcpavoF5opt1zZ0UibSxWhgC+wec3NJupAUKGij8WxY422p+/ZyE1BZ9jtRz/I8MAZti96SbXJg7JCA0ch8r41Xmk+RIrvyOqQcAFp40hjW75A5JYYAD1Bp66afDTpTlAsgf2AJcn3D0rirZUQHBUPNRie6Pi3J5oQ/W0WFLWODlDr+qqkhAp2tCulrf6ebAY/GW086blBw8cy0Hbe8URax3F6GcYmbvg6ggT+OZt5kgRF5wZbNI1B9mzOBxpe1nhUIGvk+syk8YZVmI4hRAEiC5Ad8u/KCPmSr+9PnYsDmi6rKImWBihtIbkPt7J/VpT09LHIMng3b4i2zUNWEh5ktVZ6cMcjo294fF7CvH7w6JIsY34RpPxY45PVPCkOAYRDrrDbdxSEt6TQqC/x6z8LxP9GVEJgT5brjH4NU5fchDGY2cttkwkFgi6B6dZjjYFXlQ7S04M/dmw37o/TvW7bUKeDqwZLje1lwEMUxUw3Npt/oooh5py+FrOPwdu4dT0gDuK0rgnV9vGoAVhdG/5Dh2gpwRnxl6VZpEoVfnvpuVyIkLNVNYrfnvbTkC6+ycp49JArrcMRiI12qRtNw59GW6qmMk79Qujt7fkzYY68bdmjUfnEWoAfZ00uGjb02rDHUOAdSN1/MUSEtehHW8+AbwmiHy9r0GXg1y1JINGDlR39xMEsBL3A6aTGxeXGWHHBwzrQRJIngJizGpRcRR+il5TogOcRcpIGO0rUopj4n8dnrd58T3+mSvUqJ+rwTN6LWNEivLY5QPu4w==
X-OriginatorOrg: openeye.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR07MB4058.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2002b993-95da-4e28-cf9b-08dbd4b1e1bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2023 16:54:26.4177
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 01aaba89-c0e5-4a25-929f-061e1350d674
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zk0m6M4dI2Nu9KuuMXEk95+xVr3Wo5fDx5G6NZJJT1V7+4NR1zcoz8PzkHROORnB2wD2GmfQ5qXK8KnoiO6ong==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR07MB7066
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings!

I have a Gigabyte motherboard:  https://www.gigabyte.com/Motherboard/Q670M-=
D3H-DDR4-rev-10#kf

With a 12th gen Intel processor:  https://ark.intel.com/content/www/us/en/a=
rk/products/134591/intel-core-i712700-processor-25m-cache-up-to-4-90-ghz.ht=
ml

Which I've set up to use dual NVMe drives as IMSM RAID via VMD.

And I seem to have run into:  https://bugzilla.redhat.com/show_bug.cgi?id=
=3D2053593

As I understand it, mdadm is ignoring any IMSM RAID arrays that don't all c=
ome from the same SATA controller in order to avoid users accidentally crea=
ting such arrays with a selection of devices where they can't manage it via=
 the BIOS menus.  Up to now that was sensible.

Unfortunately, VMD now lets non-SATA drives use features that used to be SA=
TA only.  So systems with NVMe drives can use all the BIOS features for the=
m, including the RAID configuration and monitoring.  But then mdadm sees th=
at the drives aren't on a SATA controller and deliberately ignores them.

For now I have hacked the workaround from that Redhat bug report into my in=
itramfs (IMSM_NO_PLATFORM=3D1), but I expect this kind of configuration to =
get more common in the future.  So perhaps it would be a good idea to make =
using them a little more intuitive.  So since I don't manage to find any si=
gn of the upstream bug report mentioned by the Redhat user actually having =
been filed I'm going to mention it now and ask if there are any plans for w=
hat to do with this in future versions.

LMP

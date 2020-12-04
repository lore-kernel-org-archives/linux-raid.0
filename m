Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EB88C433FE
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:28:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C4ADD22518
	for <linux-raid@archiver.kernel.org>; Fri,  4 Dec 2020 03:28:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbgLDD2H (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Dec 2020 22:28:07 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:30553 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbgLDD2H (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Dec 2020 22:28:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1607052487; x=1638588487;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
  b=UPXRQXxq7kdz9NmjDUSKUZa7hD/h68UyWXn4L1xkdkqNvS8fK2mGpqRF
   gsJaWlO4NfQztaxLhLSsZ9ZpZ1lN2l4Tzd4RpIChy4qx6xOiFhpbsjimM
   sp77SYXhaf2DZsYbSaDR44scpEO61UOK+b9A6/wgIDrVV8wxpFYRTuZNI
   CSUAQdNyQvmtuwmJ+W+Tf+XmIPNg17GcDhGBfBU8VGa5AK90RObcj00Ig
   1D4BK3MZK0fZM/nCfTdScI+LlYgHvQl4KKq16mDWPyBmWwbvdpVOne9yB
   8Oarv1lKFJIAVyaSNU+n65gmW4Hicw15TLuVfuzyOXIPBfb6ph2nNOP+i
   Q==;
IronPort-SDR: yUq91tqXF2LsarP7EtILDOBsI4RalTlpr+6bx0CUT+/p6GVafo94M3ZrpNYw67lW8IQgiT7W9u
 km3dx4nkAyirCKVxRkOTqzJZx8O9QEh9nWPbcCAgLXfXhsRUv3Flwb7erp1QyFEZAYiCsZuPwj
 Y61lC7VZ7023690lHXAqRIHks8MQXUt5ridAJREtC6u/GB7KHMnm5ZiV9P+gLuRNwn8Jbiqrob
 GLx8Dw37AzZsob0lcPj2cyhM9or0OszzR7svXGNOIJkM9s4KZDDg5Rf4J3XxBplnRhz80FveWe
 HGY=
X-IronPort-AV: E=Sophos;i="5.78,391,1599494400"; 
   d="scan'208";a="154367154"
Received: from mail-cys01nam02lp2054.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.54])
  by ob1.hgst.iphmx.com with ESMTP; 04 Dec 2020 11:27:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSS1AuauH3HoNhZBKJ6bhSOfHCsTLXm2ccD2xOIHrGLRUpa5AAPDf7QVchEfOgHQn0SsBxIyWnQGhP8T5aNwWt8a84uWR1zhuPVzAXkZIkJVUomGRBIhcVysQiFLTq1x2nFLcYniZedM/UNth+8ciISWC/Eb6mGNkJ2w0vjwAootlEdz+GbjAFD2XkZgved9LsVnKhmhx9cn6rp0V0rVvb+N2MUJpC4lrUaFcILU1ElTlUfC032pGvoOhbSMZIjLCP67ROA55lgcRFy2zHyJmyUaKcGMR9XLM0/9en+2IVk46L/3qf538DOVAV6hV/fdp0Rep5EbhcY5FFhbi19MxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
 b=gnlWFtb1mIx4MGJdRD5GBWqUivnNDdvw9hGq6uOFuY64W7WxElb4LDWhauCplysCAeZcXqb/saytA+E4rARhZMSv04rhhTcCYQWw10IOCTDLyLGkzOABNew43tZ459krJBdf1QOAFg9K8aQkJ1K+BSDJqm70TtgDAjbYwPhwTRn23QIoxRlOnAiusS4BQFlbDM2PX3Uhczu552XTPiwuwPpaSq3mG9tlLmS6rNbC1BEhs9l0v3WiqpbNgu/nf+FpSE94nbLWfBMKghpJr+CjF7idhayMcXmEt9PFamRAd0vhVC6Ec8n5cUCvp9b/TGtRbDHAbWuB1N/XOpmRDoWEOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wWO2+DoWaprIN+ldI6tSNf2ap63KBTYEr/zzwHBX9eo=;
 b=b7toHbMTWaCDwpHrt13CKUSr8BeGBcjCa+5Fez51y/VfFqgl1V+9Mp+0h7j5q3g50sB87qMjj2Uqfbhldjzkx//pn0OfGj9pc6MCG0lNtyYWBCCuCVMfRtqQv7pBb09yw4wuLEidUZzmFbY5fuewPBMiwZky4y2wmwYnppTNFJ4=
Received: from BYAPR04MB4965.namprd04.prod.outlook.com (2603:10b6:a03:4d::25)
 by BY5PR04MB7123.namprd04.prod.outlook.com (2603:10b6:a03:227::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Fri, 4 Dec
 2020 03:27:13 +0000
Received: from BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4]) by BYAPR04MB4965.namprd04.prod.outlook.com
 ([fe80::99ae:ab95:7c27:99e4%7]) with mapi id 15.20.3611.031; Fri, 4 Dec 2020
 03:27:13 +0000
From:   Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Tejun Heo <tj@kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/5] block: remove the request_queue argument to the
 block_bio_remap tracepoint
Thread-Topic: [PATCH 4/5] block: remove the request_queue argument to the
 block_bio_remap tracepoint
Thread-Index: AQHWyZEJoVE+oQs4z0qWLLn8W3RcJw==
Date:   Fri, 4 Dec 2020 03:27:13 +0000
Message-ID: <BYAPR04MB496575248C66C4AB2877445986F10@BYAPR04MB4965.namprd04.prod.outlook.com>
References: <20201203162139.2110977-1-hch@lst.de>
 <20201203162139.2110977-5-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=wdc.com;
x-originating-ip: [199.255.45.62]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68c24a4c-f4b2-48b0-48d0-08d898047e3f
x-ms-traffictypediagnostic: BY5PR04MB7123:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR04MB7123388399DA578319F5129486F10@BY5PR04MB7123.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePi2l043tN8CtI5QSJRecw050P7c/r84tFQIc6e9QM1RetHr0pUL2ZXkpzXlgBsjvcTWs/R4X6IwTsIf7gz/d+k4DqnM0Bq0yU1k7Byga+0ALKX0SfjXim7VBLzLXT1mkWjCjQy7GVUwUwhjo7aa3D5dMJ2LRBnsJ9TK2TZwHcQt1x+dxLPkj+W+NXbBavHMnH95YzlJtDSFtLEzB/W4mdcTKMAjopQEaXWJQORvYyUz40M4qsxalqxG0u2DE/gVl7stzvTgQrEwfhbvrL3SGv5iX70i5sNDthVE8LyBCZCk5/k5m+8DwCHqQk8LhHEE2Dmxp0EiEizaBu8L6ST7XA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR04MB4965.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(366004)(39860400002)(346002)(478600001)(66476007)(66446008)(66946007)(64756008)(186003)(66556008)(4326008)(54906003)(316002)(110136005)(26005)(558084003)(2906002)(7696005)(33656002)(6506007)(86362001)(71200400001)(53546011)(5660300002)(76116006)(52536014)(8676002)(8936002)(55016002)(9686003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?UP1o6D+b4Ihym0hj217FRpSNmpmUzpEwAhCoBaqMYHZ6ubcKPk8Es5t2kctR?=
 =?us-ascii?Q?DClV54C0ru6+fy4LbMJnwZmvyfVLX9wEShZtZL+GvfpBYI8EiOiK9mzOkpTB?=
 =?us-ascii?Q?Pm5pjGxY2gU/vzpUuRgWHa6LF7dEdbVlek5o/W5xXZV67g2xnD3oLxZNJzDf?=
 =?us-ascii?Q?A46RJS+NHKyd4flZLzmhrrLvBVSI4lzdP6ad6brdVC6XfQXC1qJurcb+vhJA?=
 =?us-ascii?Q?0buwVqmoII1nCrwgXrAYIgiKxvsuAjCrRPPSfxlN5iOYWXk1wXIRqxtSCrZS?=
 =?us-ascii?Q?079BgwrR1kQMBYOx/caTYA2I8YxNCgUOdJWECaGygsy+7tk17bYeTxhplD4X?=
 =?us-ascii?Q?tH0I0meyU/Odk1CFCdSXE3Aqkfdl24JRL7pkkLOHsBKprNTlmrZ5UrLeLsYJ?=
 =?us-ascii?Q?YS0U7r3hTj4OfaMbtiQZeWKLGjs7Ex8+E3Ac477sjPv7Ttgk6sitGCFIgSgi?=
 =?us-ascii?Q?5Fx72MjTpnDW+XMbKtyYpT7hNK3JJBDdBc6EZIXMeD6Z+zdkEY7Mkrx44pMW?=
 =?us-ascii?Q?tN+fY7XYLXwwWp+oRpSmjBN7eVGFTH0KG69aMnNrI/mAKX9AFCkEfDnKE3MS?=
 =?us-ascii?Q?1BtH4qBI0kcuUHqhdG9Q9sM8BKtbbKplkRnMSkERfuR38qEPhx1fSl/EDo6x?=
 =?us-ascii?Q?Z1y//SxWFaahSnDge6ChSHGWOIVtnhRd5H1y71f3bMo033eTpgqGSB7Elaj2?=
 =?us-ascii?Q?Y0dGx3ZKyv3Bb2FdiRKJx8d9yAsRppjx48aKEqiT4wD3Z5Ak82OUKsLVrKg7?=
 =?us-ascii?Q?dR0CbEYWqkQcllFQQOkr626eOk8fkBZOBECd/UKh2yWiMlNJRzb3LpaE+qL2?=
 =?us-ascii?Q?iOj+aKlvfPfhnlY0lG5Ewqf7jzXRijK9IYxF8DNNncsGQ4xlnswS+tRbzTVv?=
 =?us-ascii?Q?yL0le+9rgNyPdc3/0I+U+6k9veN4KcB4I9efneIOenwcuBzX8OA/6AMe2Jd/?=
 =?us-ascii?Q?lu6TVB+8uJfml5XX/DbPME2Kx+wbJwB9vU/JeDjbq4hSiTUEE/5xnvJeO2we?=
 =?us-ascii?Q?KFJQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR04MB4965.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68c24a4c-f4b2-48b0-48d0-08d898047e3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 03:27:13.7173
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LBtDKIFQLlcIfmYgchMeh3j1swFuVC2I2k3lAVErrnVdZNuXGLWxjm40YinIjc0xW+BMhn2UZQu1/ZOqziFIIoopg5hd2KMDq6GjWbWJqJA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR04MB7123
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/3/20 08:26, Christoph Hellwig wrote:=0A=
> The request_queue can trivially be derived from the bio.=0A=
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

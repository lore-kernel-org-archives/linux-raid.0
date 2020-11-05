Return-Path: <SRS0=7RKO=EL=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76DAC00A89
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 09:31:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 674D52080D
	for <linux-raid@archiver.kernel.org>; Thu,  5 Nov 2020 09:31:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=intel.onmicrosoft.com header.i=@intel.onmicrosoft.com header.b="KGOmkC39"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgKEJb0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Nov 2020 04:31:26 -0500
Received: from mga18.intel.com ([134.134.136.126]:18573 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKEJbZ (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 5 Nov 2020 04:31:25 -0500
IronPort-SDR: xCzKCnrU43yjdqdg830F2gaa3qz+yz6xXU2AcJEr0Z9TyQSGoUe5gm/dOT/96b5Plrkf/F695C
 ZWqHwjog5Fdw==
X-IronPort-AV: E=McAfee;i="6000,8403,9795"; a="157133404"
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="157133404"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2020 01:31:24 -0800
IronPort-SDR: KdL5M2vyHofvM+Jrxg9N+qKmKD6YJXj8vwV1zbSFyBJJ7CkogBYbBr2u7q31emE5NQJQyyDE3i
 sZAGSL2KkV3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,453,1596524400"; 
   d="scan'208";a="354213100"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 05 Nov 2020 01:31:23 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 5 Nov 2020 01:31:22 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 5 Nov 2020 01:31:22 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 5 Nov 2020 01:31:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NyyB783oNmZuWzRDrC4Jo3VUmTIyhCUJ43wduvw+OqkKYKXO7sNKON+B7YTuadzAIc8C/r5p4qyjaPsAQnhdJyP/VYQnDMvK/XjorZJ8PalpSG5LU6oCrmPO4ZzCdZtSLY0hHa4n3yapZzyBr8lvlj7Uqt21wv0UAmUzkmKQLv9hknr8EolPfrs7zTAuvAyIfogx3Y82YNsrLFH/NYN70Ms8d/MBOfwztjVY/zTp9aAIEm6LZBs5atn2v0ELU13shPuhXdT3Go7HIabe22TAroVNSGdn/03iRcUBhGKkI9tLgFcQm+VrWfFsOLNJwQjWphmmg5Hk+FVccdqOmofrhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc/r6L2SRb9CvYwSxlkSoHKW9oOYaFTmcsJWqhpc3nE=;
 b=PqXQdPYJAYB2IknWOmV1efoh7/ZJ0bWpfN0fLyvpxj6fgFNfwD8jCu/smJDbPu3OmIDJ1dBacj8rRLsSkjhZohjr97o+vQiT8q1PUn9Fk0nMJ482UrzkHTaXV0tr5AllKx1Jib+fzspmjjXwy2qxjL4vh7ZiL23HYeRfWCiM1yKuGhuXle5Rh5lKVLUf22g+Y+a5DRVZ9uK9IULO/nqnne1GCHBUgGNaOWnWnX6jIQb0rAYbfSu94gEg99wQQRE128+C0brkrkPg3Yq1Ci44RsfABJxmVSgTJ/y+ApUcfWRlaBXQLK3thZUsPxgEnZl0LatHfpmB9+Aiaa5WnpkaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yc/r6L2SRb9CvYwSxlkSoHKW9oOYaFTmcsJWqhpc3nE=;
 b=KGOmkC39CmcSp6zXWavgl20q/NfA+j3LY0nMsNGTD3698THNy0P46yYLZrZ5FPerA4x4PQ+mi7U2RBEzJXAvloQN3A9yaOlKIJTWy0A0An5PCYEez229GpLDtOqjC1KWseoSbgg8sdGUX4uMGG4U/zb0CqhHJQVxlnAVRACaiNM=
Received: from SA0PR11MB4542.namprd11.prod.outlook.com (2603:10b6:806:9f::20)
 by SN6PR11MB2847.namprd11.prod.outlook.com (2603:10b6:805:55::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Thu, 5 Nov
 2020 09:31:21 +0000
Received: from SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974]) by SA0PR11MB4542.namprd11.prod.outlook.com
 ([fe80::d863:c0a3:91e2:3974%6]) with mapi id 15.20.3499.032; Thu, 5 Nov 2020
 09:31:21 +0000
From:   "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Missing lock during partition read
Thread-Topic: Missing lock during partition read
Thread-Index: AdazU3gB4A6lkH+6Reug4L4m83e+ng==
Date:   Thu, 5 Nov 2020 09:31:21 +0000
Message-ID: <SA0PR11MB4542ECA84F72506B39C3C9F1FFEE0@SA0PR11MB4542.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [89.64.117.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 83e6e39d-aa86-4dc8-fd10-08d8816d8e72
x-ms-traffictypediagnostic: SN6PR11MB2847:
x-microsoft-antispam-prvs: <SN6PR11MB2847F78579909C08778051A4FFEE0@SN6PR11MB2847.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +bbhhST4N10qbM/TsQsAxA7QrzDqpaQuzX6UcA+4I86G5UhAr3EB/Qu69XOanMPkn0s7nnIUSPzDt8O9+G/Y7tp/uOmgrrKkx498h/TLzR7F9l6hSK5bSt6eaa0VSzb9t5WtkdmNKJONczIPcuu/XZ+CWMlMNRkFUYHIlVspOTaLA7Kz7b3y+i3ttzwdLnlzVTXB/r7Eq9GpcN+K3oZuwTIUafH09DJ2X3iuJZU5Bk4aXgvWwm+L5MnAAJwRVk7OKg/iETOhcJSqEHPNXgNCZloOIoCYLiY0RkosFI+C+P+/PDAEh5xGcrSgWDmprQf5sqcBOUUcgF9U8rvngq05GA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR11MB4542.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(186003)(8936002)(26005)(52536014)(71200400001)(478600001)(83380400001)(5660300002)(2906002)(8676002)(66446008)(316002)(64756008)(55016002)(6916009)(66476007)(33656002)(66556008)(86362001)(66946007)(76116006)(9686003)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Y+HTatsSmu0KzWIPge0ITJcMZ7wGpmr8iEiPnzEvKUxxxyH0sb+plthPC32yi0y7sxAgXcUy/k7iZHHLHQGW/GM26xl4U9kkovd9Jrba0Mpxt/mXEBJ2RWrlVz117lA9mFVCqwbEOQJMInliWGLPUs7FI1NQjFLM/DWmyPJvXCCyN92/0BxRmudtfsvGG/A0RJ12baAgE6OE6gPtjZYJf0sDGPgAY+06vzSgAcfB6ovoN2lW/fYyLR7/79vshyJfkUah3ik3nVIs6mr9UVdo7fz+SlEFGlHLEI8qA3IXq++B01oYsNQ7G6Zbu5bz2P9c4KVJ97SICA5LJSNXdDZKNQ4ZI8PFsL/1r9pLM07HhnMn4Jx4vVZoS8D9vFQ2ra5g3/HWBb8jn16c7BQ7hRqTPHfQVNzKw9fSYOwvaQ2+7/q7NWW0UU/PW82rulq9GX/FUIT1mLWlORxFetQ+zauBByP9Et+/yHhDY61RLENI/BLJ9FANkU5Tdoqh7h6CSWZtV7acMrv5Kmp2t32Gw1R0ZZ3Sv8BF2d0RZfS8I28YZ10w9W1vR+0BlcILli4UM4xM7gnOSKUdRvzSMJQqrOrP4YwawyIGHsp02rZeKFPki2lodwRL7KghjkEpPECcJPYD/Bru9MfiRI0z9/lxFlRmxw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR11MB4542.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83e6e39d-aa86-4dc8-fd10-08d8816d8e72
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Nov 2020 09:31:21.3178
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZJkVu8Jv9PHINasmSOH6ev+KA0F0iXmlW3W4Bgagn8g4ZDmRxLzPl0QWTMt9UVbkuOLvIo5gyXn+XVqa7ZMxctvzwj6N9nLsE5r4n3OnpcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2847
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi all,

I found an issue related to missing locking mechanism during partition
detection process. I'm using md raid 5 with IMSM metadata. On top of
array I created GPT with some partitions.

The problem here is that partition may stay read-only even if the parent
device (in this case raid array) becomes read-write. The issue doesn't
affect every partition. I got result where some of partitions are
read-write and the rest doesn't.

It is related to raid assembly process for external arrays. First
array appears read-only and later it is switched to read-write mode.
The read-only for array is well respected and as a result, if partition
detection start at this stage, then partitions get read-only mode.

The mode switch is done from userspace by mdmon, it manages array's
sysfs attribute "md/array_state" and kernel changes to read-write from
this context. This is done by set_disk_ro() function
(see array_state_store() in md.c).

So, as I wrote before partition detection starts when array is read-only.
I investigated that the issue occurs if mdmon changes array state during=20
this process in background. As a result, it changes state on already
detected partitions, it doesn't wait for rest to appear. Udev reports md
device change event (generated by "md/array_state" update) between adds:

KERNEL[85844.484805] add /devices/virtual/block/md126/md126p1 (block)
KERNEL[85844.484853] change /devices/virtual/block/md126 (block)
KERNEL[85844.484912] add /devices/virtual/block/md126/md126p2 (block)

It ends with /dev/md126p2 as read-only. It can be fixed manually by
partprobe, but system may drop to emergency shell or dracut, depending
on configuration.

My understanding is that those two actions aren't synchronized and time
race occurs. To prevent from it, common resources should be locked.
Looks like md problem, it cannot be reproduced on standalone drives.
What are your thoughts?

TIA,
Mariusz



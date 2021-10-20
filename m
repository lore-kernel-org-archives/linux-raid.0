Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF83C433F5
	for <linux-raid@archiver.kernel.org>; Wed, 20 Oct 2021 12:43:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E116A61355
	for <linux-raid@archiver.kernel.org>; Wed, 20 Oct 2021 12:43:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbhJTMpV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Oct 2021 08:45:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:35636 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTMpU (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 20 Oct 2021 08:45:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10142"; a="314972506"
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="314972506"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2021 05:43:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,166,1631602800"; 
   d="scan'208";a="720408822"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga005.fm.intel.com with ESMTP; 20 Oct 2021 05:43:06 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 20 Oct 2021 05:43:05 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 20 Oct 2021 05:43:05 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 20 Oct 2021 05:43:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2dHPm6WOMywYeO1kM5Ol5UtMmfmoH/w51JHpEGPN+ljvSaudm4CYUFoITNC3zzhk6tBv5YF9D3ukHGIoxAKMFdt2FMWGSP0Bgv9RqNak8ESb8rKja/7ssAh1YJgy0HixLb7v/G+S4yDBgFG+Yj9PJKgZ+gSljoLkwvbd7WhlVR+KZn1cV7+LUU97RYEl2nKtWozhmw8GicJPITtdHePBqZZ7ots3PPZaBB6z7DhdSWy2HMWR7hKd+Lpm5qe2jBdMpEqBGEAqsEZ38fhlqhfn8nLaC8EQtiYlNKmE9SXn0R1FFrKGw4fOw9W51GQ12gIcBMUziKxAoiGO06ZTFMZgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S5LoCrpLNhPyLE6iM9NncyBH+2vUhqoha2LDqbnNuTA=;
 b=WBDPNJsJHvo4Akw8lOnrargLuaV9DxFMpxiSyMHfsNitAiMW78PRAYuO0/xe+AYtpUnVDzbEnNM3fKj0Dbodkw/dLUTZ2/x8g1v/T7wBXoCxYp6n+ft/cYEoevYcV0A+SvxsPSOpcG/2Ckf+cR9uAN3ypH6l0sb2U50rD3fJtxxEStkdIL77yFCAg/ZQYCD8pCDsMaDeXZWtGWnz0VpL+odMiiJrZg8hB/CwPwqbejbmnoGFFEluxXCHj81d+svK52MeFdF4MesNS2Fm856kdyDlkr6zKnJEeMAlWBgRfMQjVTcBIjTcbZUTw7dQizWH+2FlEKSi1A/PTtSl6JLxQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S5LoCrpLNhPyLE6iM9NncyBH+2vUhqoha2LDqbnNuTA=;
 b=xX0xbWqoK2W3DCoWdSHwy1DU73M/5nvXSzMpXdQBMSGIksf/IKJ4c946KZrzwVWL5Tu5K13tguKC6rOqq4eTe2M6SbS8mVPGQ+mU9xlud/hlQ1GZx3Rc2/ZGUB75Bo3ggeeuWUL/5b3OdDGLYTVOQOEMHwgUpUC4IqgLUGy7X3Q=
Received: from MN2PR11MB3776.namprd11.prod.outlook.com (2603:10b6:208:ee::28)
 by MN2PR11MB3598.namprd11.prod.outlook.com (2603:10b6:208:f0::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.17; Wed, 20 Oct
 2021 12:43:04 +0000
Received: from MN2PR11MB3776.namprd11.prod.outlook.com
 ([fe80::a0d1:f7b3:e6a1:22f0]) by MN2PR11MB3776.namprd11.prod.outlook.com
 ([fe80::a0d1:f7b3:e6a1:22f0%7]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 12:43:04 +0000
From:   "Tanska, Kinga" <kinga.tanska@intel.com>
To:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC:     "jes@trained-monkey.org" <jes@trained-monkey.org>
Subject: Proposal of changing generating version of mdadm
Thread-Topic: Proposal of changing generating version of mdadm
Thread-Index: AdfFr6MMVNj/D8FpSZueHpbUecryiw==
Date:   Wed, 20 Oct 2021 12:43:04 +0000
Message-ID: <MN2PR11MB3776740E926BE3FE37C8B6E389BE9@MN2PR11MB3776.namprd11.prod.outlook.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b64fa7e1-027d-4f1b-e267-08d993c72906
x-ms-traffictypediagnostic: MN2PR11MB3598:
x-microsoft-antispam-prvs: <MN2PR11MB359883B45BEB4DEE1FE180A489BE9@MN2PR11MB3598.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YMgnavhYWzAqdsO2l94CeRVUoWvT+UGbw4G/OA4nlG7sGpua4FvUNvf/VLhwFlIfwVj3GNh3/YHCWlXXUSEVzCq5CZx4WbrzEO4wUc6rAiNb6yo8bD6ZqyRwok/mIc+5rY17/UvxhvcDuObXruZ2cZZFLcVrl1wP23g/iH17DUH/obwy6gnCeGG7nQH9W9wFjHyoymlMdxKA5PwYH07NbeH7Ec8RpMZ9waYhuETSjeUlWtt9sXT+VItyCwvLRtF50gtiVPiVd0Hjeli8Pl7h+nBCvE3qPxVEVlq767fedS1caB8cHSVsrjlVJKviZNP7XAYNetWLEpuMdpvyaKLfehR1qFTdVkzGx97Hl4ns6+qKqi3pzd+Bz0bDXIHEe4aRa0TakAmoRxOZBOnIeRYB0m+RDXR/6jog7//P53WU2DCaTeiY5AUZ1qEW8g0mwV6YjJX+H72/BplBtGKnpGAj6qjLp6ZymGrY36jLhf2tTVBLguvvxpf3rlLhtVjJjxvinDNPZyMF9ffVHfXnHwDFlpQkV9nL2Wz4opTfa2C7mARJce/kKD7UAneRD4ESRJ/hse8A84YhGLXdj/ntWTK6RhxSQCa/4HSnIVhoNOWP1jdTtU2PykZYGSTY+E7zK5q95kyitB2T080lmIGc9vHsRezyxOPgrbwbSTR/8/I5cLM8/H05SnWLAEMPo+mBfHiM9tXipO/mkr+QuZGcwJfn6V1Qs7jvgxzBnBEtgFdyGok=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3776.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(9686003)(508600001)(66476007)(66946007)(5660300002)(316002)(7696005)(4326008)(76116006)(8936002)(186003)(86362001)(66446008)(55016002)(64756008)(66556008)(8676002)(82960400001)(6916009)(38070700005)(71200400001)(52536014)(2906002)(6506007)(33656002)(38100700002)(122000001)(26005)(83380400001)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NiajTEr4us5YLByJ1rbbXDdbZRaLCSUJxQsAimn8YRM9Pe4q1lTmh28H4mkN?=
 =?us-ascii?Q?hxso5npBy8ylopOsrv9SM1bEfjxEj0KRDG4dMSpM8PU3y9+zp3dJ3nV6HFuV?=
 =?us-ascii?Q?miWd1krIfwFVCjjVV5SRN2GHDIC5nZZjF0ln7MozXwSyYVPmAZKTI2/qdZ33?=
 =?us-ascii?Q?feaEpQvq8TX0I5R4K6OYTQuFLUdWGGqOocb+Ib5YWoFgi6HEmrYLlGZ44/Tr?=
 =?us-ascii?Q?FgLowFjszH7NEGRuBi3l4cc3LeNzqyXd7CbRkd84ORp8OUFa9vS/rjS7/D+l?=
 =?us-ascii?Q?ButaTuYdRYE6nNxH5BVvspcv1o5A8yDeDJoAqK3dsBoHCP24pkHaVnwijfCp?=
 =?us-ascii?Q?1qe7SXL8gOjsVWiUGdAFe2C50WB9FM25xRn36Tln1dDds2MEhW4cHYzejEEl?=
 =?us-ascii?Q?bA9PefckFlUfkPPs1kDYSIRRYiwd/RpklHPD02UZ341kn5zuZEq6Hf3Lp9m+?=
 =?us-ascii?Q?KazwaGlacRM5SoEZHhbuEuWTnI1kjNJgiLb9a0wtiWIxeW1mA/DIxgcYhGbC?=
 =?us-ascii?Q?/YmaKf+MnncrFkZJPU/S0rnvAG65PigiidiaT/G5gwgxBdAx+hnQ7DvCcLLt?=
 =?us-ascii?Q?i6gK/cOAZrypuqkgqCTE9H6chYBgO9JnyKe0Y5vqEFpt7fpUCDVT8O7fiXrG?=
 =?us-ascii?Q?wwx1KCdff1EEvPD2J8nd0QWQ7O7Ton4IBC7nT8cRAlFDnAWah8Tc6bKlWGll?=
 =?us-ascii?Q?ZF1xOUPAlzVdlNLjkfks0J1fAfB5f8mw61sCPlND9/d0AnUG34nV14q775D9?=
 =?us-ascii?Q?iCmC13sSG6syEZ1VJUGBJ5eBERuGjqCqtR56xcboCMD0y2xrriWUjpNEnOTR?=
 =?us-ascii?Q?O6Vnq8xRl9VvnyPuURx7DfMg7gninBXOiV4Z50FL7oHS7lfmGEwYv1u5O8Xq?=
 =?us-ascii?Q?DdhXLLUQojM1AYVGZOgiFCvHUdhXb/ME0OqnZ1lFDjeCl49cc6SaFBfqS/kb?=
 =?us-ascii?Q?5Vr9P+iFkaztuZN0dowWSjgIoYO5Caq5cCNN444FRnn81TBXCwgkTf1WpcdJ?=
 =?us-ascii?Q?ybY8/REUiL7fb4VdVfGhdYZRZ/Gw6znaKtMxqquJn08jjIEJ/ln7stKqkFzV?=
 =?us-ascii?Q?hpDMC6n6GYOZAccNfISs8VNGTK8qUWF3oWCR34j1WLKHjtRB+1WBPbgasmZr?=
 =?us-ascii?Q?a1A6lOW1OCTz1AkClsviTA9kU78VvmgOIyH8PedJuKCXa0kwK2a6u9lyxmwt?=
 =?us-ascii?Q?cb9OsEho39ygSVoryIab78D6P3AhLTBwRlwqzpcke2UOTs/1KgxBW+VNmUSu?=
 =?us-ascii?Q?aCT1LL8+288z2zyWmdDRpFt2luIM1/on9AjlRw0JRpP02jVluLA7T4aqCLOu?=
 =?us-ascii?Q?QqBL7Y/wkKJPo5llUWIzx4a6?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3776.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64fa7e1-027d-4f1b-e267-08d993c72906
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Oct 2021 12:43:04.4748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXHf/kOQUhnni3iGxVJ//nCv1WdXKhzyQnp510sWIlmG/iXezQ4izI/iw+ZZgbU9BetcJeQRT56d3MDI5Qg9Pg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3598
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

recently we diagnosed few issues with 'mdadm -version' output.
Main problem is that end output varies on few conditions. We come with
simplified proposal. First let's describe current schema:

mdadm - version - date - extraversion
(example: mdadm - v4.2-rc2 - 2021-08-02 - extraversion)

or

mdadm - version - date
(example: mdadm - v4.2-rc2 - 2021-08-02).

VERSION could be taken from code (see ReadMe.c:31), but when git is
installed and .git directory is available in mdadm workspace, version
is replaced with output from # git describe HEAD command. It is assumed
that git command should return last tag from repo, which should contain
information about last release. This might not be true, especially if user
uses tags to mark internal milestones or custom mdadm spins.

The second problem is DATE, which corresponds to date of last release.
When few patches are picked onto HEAD date is not reliable. In my opinion
DATE is not needed. Usually, packages do not contain this element, e.g.
-	# git --version
		git version 2.27.0
-	# gcc --version
		gcc (GCC) 8.3.1 20191121 (Red Hat 8.3.1-5)
-	# yum --version
		4.2.23

To make it const and reliable, I propose removing DATE and always
use VERSION from code. VERSION shall keep general release information.
I would like to move the changeable elements into EXTRAVERSION. This
field will respect following conditions:
-	user definition first
       	(by respecting EXTRAVERSION=3Dxxx during compilation)
-	if not defined by user, result of # git describe HEAD
-	else empty.

Example output:
mdadm - version - extraversion (example: mdadm - v4.2-rc2 - extraversion).
Thanks for any opinion about this proposition.

Regards,
Kinga Tanska

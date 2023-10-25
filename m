Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80920C07545
	for <linux-raid@archiver.kernel.org>; Wed, 25 Oct 2023 18:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjJYSSm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Oct 2023 14:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229626AbjJYSSl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Oct 2023 14:18:41 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 25 Oct 2023 11:18:39 PDT
Received: from esa1.hc4949-98.iphmx.com (esa1.hc4949-98.iphmx.com [216.71.144.186])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E10C9D
        for <linux-raid@vger.kernel.org>; Wed, 25 Oct 2023 11:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=openeye.net; i=@openeye.net; q=dns/txt; s=CES;
  t=1698257918; x=1729793918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mE1V2ZghdS8l/X0KaYCi1thbdA0Hkf9wWvXT93LjSQ0=;
  b=lRA3xmqdGKI5Fu3/gC5tvztYQzop1CsVV1+yWkEfa8VFudhEJgrLprJs
   ZPeDkMWv4Upko4iYdsPNXPAB5iuxSjX31yQyuPydFmcTOHpWAO4Gcas3m
   MN0ExqxlKSlmLDoS2iba8NLdaY9Ne0JNGf354CKb2un5Mcp8VSjTY8mJl
   I=;
X-CSE-ConnectionGUID: Yw1QOA4VRAWZdi5tlXSBNg==
X-CSE-MsgGUID: bgq5YLpNS0udaIgUKIlHBw==
X-IronPort-RemoteIP: 104.47.56.168
X-IronPort-MID: 85828749
X-IronPort-Reputation: None
X-IronPort-Listener: Outgoing
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
Received: from mail-co1nam11lp2168.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.168])
  by ob1.hc4949-98.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 14:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MUdMZK7HuDeTLE+iV2CBZMQhjmIiwob8HxBGI5gu6wATxk2x4rQ81Qcr5onnOPij7OAdqOFpCmQamYYV19XijTh12ZwD9mLNpTmK0FSkZIKzlmVhD+5op15TrH8FOCzhnzyFbMGfbhjv9aS13fWoZMvQ1qNCUEy3xZPANae2uzNdHq+nELpikqakXCfyD4dOtqOsmdFU2ryR1kJ8eYV6ZqkGmEnudboJk9EykF2SjyFuDEHLRQAMu1w7sJ/2CBCmtrJ7w8AzobISlLXj2N7ljEA8TNMWSILKgAWwjo4sqp+oqV/4mhDvc6WseKVg3CnC8oLvSE7PmE80kq0K0JLzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFNewq9Me/VFDSW9ESuNo8jUYPiNkQaBFNHi/b9aK/E=;
 b=Cclw0C0ZDkIW3+lRb5QuMn1Owd38IANvWqYGE9p5zFabFs1W+CCbXhY1cSVzwOzdoud4iNLQsbo4TRl2bhpuILJHno4eljiRj+f9SWgzuG7OJqpjHmnO6moqErsR1ee7YCxbxVduYv2f0n2aSnMuynQ6PM5LsxJgbODfmj8Ve47abGOLOL370+ZUGrwfrf20svSViZR8g7n77zM0OdbWIxNGBJYdjgD9Zz5YkggjKWf+T8E8H06nbvySwgMXgLvdM6A0weHwN+lTSwlIHLPfTPbWI0rQlp/AnPFU5VSFq92zB5XKI7dRVO4dotNLo6NIyY1agxk6BSrSRV+eRXqWaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=openeye.net; dmarc=pass action=none header.from=openeye.net;
 dkim=pass header.d=openeye.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=alarmcom.onmicrosoft.com; s=selector2-alarmcom-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFNewq9Me/VFDSW9ESuNo8jUYPiNkQaBFNHi/b9aK/E=;
 b=AgmnQFa+2VTZTco700ZRsoN7UKXVZhwQ2SCNrrBzsT5xI+INEL4cGS+olVU4VcYu1cQnJ2eNlnXnV81n1GzZbTe/x0D0mEK/mNx6VUm9qDUDzE5KWzvkYWWo8KUiG8Jq/AFI0rYUmtIV09kwopAYEbsBIEG+9pFnFF955zSm6F8=
Received: from MW2PR07MB4058.namprd07.prod.outlook.com (2603:10b6:907:9::28)
 by SJ0PR07MB7679.namprd07.prod.outlook.com (2603:10b6:a03:279::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.33; Wed, 25 Oct
 2023 18:17:33 +0000
Received: from MW2PR07MB4058.namprd07.prod.outlook.com
 ([fe80::25ca:738:49e:a984]) by MW2PR07MB4058.namprd07.prod.outlook.com
 ([fe80::25ca:738:49e:a984%4]) with mapi id 15.20.6933.019; Wed, 25 Oct 2023
 18:17:33 +0000
From:   Laurence Perkins <lperkins@openeye.net>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
CC:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: mdadm + Intel 12th gen.
Thread-Topic: mdadm + Intel 12th gen.
Thread-Index: AdoGksiTIATBqevxTmykChrDuuWQGQAgxVcAABVeWtA=
Date:   Wed, 25 Oct 2023 18:17:33 +0000
Message-ID: <MW2PR07MB4058B58407C1AC063E9E5715D2DEA@MW2PR07MB4058.namprd07.prod.outlook.com>
References: <MW2PR07MB40585189F6AC1CF7E8113790D2DFA@MW2PR07MB4058.namprd07.prod.outlook.com>
 <20231025093546.00000d91@linux.intel.com>
In-Reply-To: <20231025093546.00000d91@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=openeye.net;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW2PR07MB4058:EE_|SJ0PR07MB7679:EE_
x-ms-office365-filtering-correlation-id: 40477c1d-9494-41e4-68af-08dbd586a881
x-outbound-auth: mysecretkey
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QGmFAuWjZy9CEzpJGLIpE7mfXrGUyPc3fG8eYKyioRMey9U6uWEtTrRAatRZf5jgeeRrsB+CFRh9vHDl3TxvU1KUoeO+1QPTQ7D7Lfb+1z2PaEELIiBl2zRFNvta1qFXe0n3ASA35KinY490eHp5FFtw+PG2spr0mfqgYaj1lhRDgH5zC4g+o6RMlUwzfv5ioG3gxkmktYW1djA4QCPe2G4svmLb3kalDYWh+Ej2BHSco3p8GAAR5ll0WaKHIsWQ/XUU3SeAwqW9cdPbRyU1/cnt/qiiPZt4PlHdevR6ooR0Y3zpKa5RjJMF6HC/lA0qP6f/8Bp6DN7gjzJoLj3jrNIdzuUSqhzt9QurKqFiuOkRBLpqYIPtWwtAy9EypsH/mMzjckDdQWtZ7bEUk68WMKhVcfayo/DfMY2IrNl71XgSjm8GiehNgodEflv7LxE8DUyRp11e36VoKzfKUwFqUsiJcxs48ZS0vm0xFXpqAn3VRCdXOwuwTS58KDGPvfSlEFxQm11BX6+mjowGsBaic8QgZe04RSW870qx8RYWRFtWWX44ixPn7tjMkpKZlN06QxueFqlybdrkiAECE1whfVqgrNpemP+lklaxTt7+Rxc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR07MB4058.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(396003)(39860400002)(346002)(366004)(230922051799003)(1800799009)(451199024)(64100799003)(186009)(38070700009)(26005)(38100700002)(2906002)(55016003)(86362001)(52536014)(33656002)(5660300002)(4326008)(8936002)(8676002)(71200400001)(7696005)(6506007)(6916009)(122000001)(66446008)(41300700001)(66476007)(66556008)(316002)(478600001)(66946007)(76116006)(83380400001)(64756008)(966005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?kKA/q/85m/vFIWsSacCRidCk0f+lyKNPi69yA7bYCR6BlcF8TrJvIeo0K93m?=
 =?us-ascii?Q?gim5srbJG+jnrIunU8musxqzG5Cl2pSz/YxgpXTVItabO2A6i8Os470Z7RUC?=
 =?us-ascii?Q?YuNejCBIK2WAPdO5gVYBe3rXUP46cw71O2l06AnA9lVft1rVmvKpd2pshFTG?=
 =?us-ascii?Q?xOECrIU0nbcdXs+LNFpRX9FN+yifUFwWJCGQgEKh0X62+OQ+Szn3sxwkeWSr?=
 =?us-ascii?Q?UA7s30c1bYCqBs2OvWlmZVdWdnIWhD2UunUXu7PjNpwRLwHeUgLr/JIbFBCj?=
 =?us-ascii?Q?kyJVWfrJ2mQnYQyJkikXaljMTdFThbL0TqxoinDN6T2qPAtgfVOLKIinMWEs?=
 =?us-ascii?Q?bWC1V7deQ15BPddlFfIAJaIh2xjbFsTN00NsE5V794jGTMyXXsGX0ny/jjph?=
 =?us-ascii?Q?BjTADXcrO0PIDqnmEbKsTfx+b3o4FuNKnSomPL1ZyFMzbjnSqei9SoGiRx8q?=
 =?us-ascii?Q?XlqrCqlpBD5VVHwbw4uLLqj2zM7Ul8pkVMzJx6IINC01QPKYAX7PSQYlFRTz?=
 =?us-ascii?Q?T3IDLwXzhpItfCQCZlXQH07+Kfd+tGG40/6jilylR5GdCAs0E8h3aK5lHo+t?=
 =?us-ascii?Q?1I7AK9rb3+NW7SADrWZ5GyYy+4ibh961rz9Pc7Fs9g7PQyKEq5Nd/bcCX4wj?=
 =?us-ascii?Q?cZIaVCtMwdab0Wi2CuLYMs/pKR+jyymwQyJP9451ODSsjDvuI0sWGDgLdc2p?=
 =?us-ascii?Q?X2jHUcbx3xMzn0mc7ZbrFqGZZfXCLxxbEHmJXbObaW2HS+pF5ZGRGAM9D79/?=
 =?us-ascii?Q?75o/dKi2+k/EK8xpHQYEN/QiVkLhrFMoxwRLSpYK+RyqFh2Y1nAJZNI18NSF?=
 =?us-ascii?Q?HVClq929PrBD9VNDtpGX0vLlrEy7d19Wl7dcBs9SYuLVVI+oOlQAKVjdH6Lg?=
 =?us-ascii?Q?G95bcH/Qxm/e9IMNkQ2SEaZfnR2ElBWNZk11C5LPUjDKPNGIqrC+cdblQTJ3?=
 =?us-ascii?Q?I9FL1N7u2azC1Xky+tdAS7WdSsiLeTS24doK9xg9ZxGXlp1vCjm+y/yUK90e?=
 =?us-ascii?Q?+yVJcbyS7DLs4MAUM9jW8Nj9uTbcXm1JksxxxqdkjBedhUVPUsafb8tA4f8T?=
 =?us-ascii?Q?QDitLE2h21kY3vRQFB1VtVLEhSpBwErdVHEgZtWNAx/Hh4xEdPQNfV86n6PE?=
 =?us-ascii?Q?iLiX0DQ95digc/vMcOL0Rf0Xd3uqhOhTKL6ZF7ZkgR/u0Gmn4cu8ke3DABKQ?=
 =?us-ascii?Q?af0F7MYiU0Qu8PuesCF0QIreIPhDwtF+ExdidJLESW2WF/AIiNH0iLmNHkce?=
 =?us-ascii?Q?DpLw03PVf2sq5MoPOBUjXUMw5zVgidTLrTCqAu7PBGq0aQ4Iz9Yb19RYOAwi?=
 =?us-ascii?Q?fmyHF8knN48wwconZjha0GR07k/hezVtY0K8dvFf3DYnA9yqrgz+vfEkJmIG?=
 =?us-ascii?Q?UeM0RHmDomkYkcLHzBrfzhmjHeLTFid/edWyUrNZwaZnfW6D7Q2USVcHhHPF?=
 =?us-ascii?Q?AKj4rQb4KnTDBzuQaTGwkIon8uo163OaWdidJ0iglTXDd9X3XnOvGHH18MOk?=
 =?us-ascii?Q?eVq6MvbJ/W9Kq2nLDMHD/dnFUwSv9QIAybH4lmL/F8yuMUwGGny/Asg+XHyb?=
 =?us-ascii?Q?tOHQ7jt4BM3zd6WH67iLdUSGShoRor1nHkt9t2YP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: VsxjKGHiY9uNlQZDvHnyr/lyEkmG5jT0pjflRUp3oZQh33HizU6XAIrhM80OVs6puA2CxjF2WU1bFOVp6eDLG4YWzxc4W9iC0nRDXr8bXCZkrg3C3L5NZZ85OOuE4Y3AnXBOLJfPbfxKOmQkGnr3cEhzTFtTC9usxoO/6mcaTmybhIorLKdi5YOdTa8OgfMpOIlE1PdHBKFQloL3dIQHRfJvGgilGKqFChe5MBTQSj7yur3sfvAivXPmVk0vJPKW2FddNrPXH77BgQqUkxPCI3UMi94RaxfMU80GuDypM+xmE7P1l8c0gcauke/Ik421sCQ6fLYI6JG0qP3EA7LZd4G1V39YyhyrUkr9H3rXr+nKZTZAItAbPBk2yzwFFWL3Sy18CQZ8WA5KguKeK8AiaEq5mW4MU8j1VaK7qpOrGXzgMHITavni6uy8WtHQfEePXGdU5PbqLs7minaEpcedfnDz3wN/dzGMPTXD0BB/0N8actHRfEf/QrcYZ66BztYv+wVcSU96uwL3Ytsw/8Ah8c+TcU5rNErf8oGftom8H28p4niQEEYJ/DICFS+GpaACmzBZa8UQy0/HWmL4f/R30ht22eWnfAqQTNb6iWz2LbDWwAcpNstlVznc+RCRRYdqlPj4fBzZ6axyn8GZ4FN+e8x31dIoVpdtEGDbicGAMSbSWYqnJP45+Yv+oU7akBruI4N/40XWXYEaVuP0rxgPG1rIeo3vd8+RJ7TPjfdvxh8EmQy9IY6It8IUobQIErNF50W9Vxl8d0LKaph4uwtbJqBNqabVYMjQUaNXm0ZhV4k13obA6UClBU2zUryygN9h
X-OriginatorOrg: openeye.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR07MB4058.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40477c1d-9494-41e4-68af-08dbd586a881
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2023 18:17:33.2086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 01aaba89-c0e5-4a25-929f-061e1350d674
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: li/rf9euDrRBC1KlQU8VgpIYC48chFF5S6alNo8VVm6nojVTy3O9FCc9SDfXnQ6XtrdAF2c5Bf76TSWGqdtR7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR07MB7679
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>
>
>-----Original Message-----
>From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>=20
>Sent: Wednesday, October 25, 2023 12:36 AM
>To: Laurence Perkins <lperkins@openeye.net>
>Cc: linux-raid@vger.kernel.org
>Subject: Re: mdadm + Intel 12th gen.
>
>On Tue, 24 Oct 2023 16:54:26 +0000
>Laurence Perkins <lperkins@openeye.net> wrote:
>
>> Greetings!
>>=20
>> I have a Gigabyte motherboard:
>> https://www.gigabyte.com/Motherboard/Q670M-D3H-DDR4-rev-10#kf
>>=20
>> With a 12th gen Intel processor:
>> https://ark.intel.com/content/www/us/en/ark/products/134591/intel-core
>> -i712700-processor-25m-cache-up-to-4-90-ghz.html
>>=20
>> Which I've set up to use dual NVMe drives as IMSM RAID via VMD.
>>=20
>> And I seem to have run into:
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D2053593
>>=20
>> As I understand it, mdadm is ignoring any IMSM RAID arrays that don't=20
>> all come from the same SATA controller in order to avoid users=20
>> accidentally creating such arrays with a selection of devices where=20
>> they can't manage it via the BIOS menus.  Up to now that was sensible.
>>=20
>> Unfortunately, VMD now lets non-SATA drives use features that used to=20
>> be SATA only.  So systems with NVMe drives can use all the BIOS=20
>> features for them, including the RAID configuration and monitoring. =20
>> But then mdadm sees that the drives aren't on a SATA controller and deli=
berately ignores them.
>>=20
>> For now I have hacked the workaround from that Redhat bug report into=20
>> my initramfs (IMSM_NO_PLATFORM=3D1), but I expect this kind of=20
>> configuration to get more common in the future.  So perhaps it would=20
>> be a good idea to make using them a little more intuitive.  So since I=20
>> don't manage to find any sign of the upstream bug report mentioned by=20
>> the Redhat user actually having been filed I'm going to mention it now=20
>> and ask if there are any plans for what to do with this in future versio=
ns.
>>=20
>> LMP
>
>Hi Laurence,
>Please provide what OS you are using. I think that all you need is in upst=
ream:
>https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D75350d87=
c86001c47076e1f62478079bdc072223
>but your mdadm has no support yet. Please consider updating mdadm or OS.
>
>Please kindly note that what you are trying to use is a desktop RST family=
 software raid. Implementation in Linux is for VROC (formerly RSTe, enterpr=
ise raid solution). Metadata format used by both solution is same, that is =
why Linux is able to understand it but since both product has been separate=
d many years ago, there could be differences. Officially, we are not suppor=
ting such configurations.
>
>Thanks,
>Mariusz
>

It's running Gentoo, which currently provides mdadm-4.2, which appears to b=
e the latest stable release.

It also appears to be almost two years old.  So it definitely doesn't have =
that commit from May.

I'll see if I can figure out how to pull the latest and make sure it works =
as expected.

Thanks for looking into this,
LMP

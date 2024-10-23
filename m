Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11olkn2094.outbound.protection.outlook.com [40.92.18.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D07217741
	for <linux-raid@vger.kernel.org>; Wed, 23 Oct 2024 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.18.94
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729655418; cv=fail; b=Ysnna8S5lsVYs7wit4JHVYA+G8+YNggD/r7Zl7KDtQnSqwqGU8jD+OJ4Meqat4uQXrJ/9mZTnWISOppxfn/5k13QsWPOmm5USq0ygJjudaVk11ZG3He/gScG8mAP3hq5qXKnFq9FV9hzKJHWz/1d7z40TxIJbu3/2x5gNhkyD+o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729655418; c=relaxed/simple;
	bh=ClvfvoKu78ah66hLq8M+Lm9OOW4tQPIv7h0U87jAgHs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=PlJEdrwzswaKNcPpyylncPIJQN61DxMY9BCCvA4bpNE4JzjFaYPV7a0P8y9O8wk/OzhiIqtfnxYqYHMMqIWsNhN1MbSjy4kxx7EMkBS6U8ep6Bub73vbgn1zHfr1xtgqAJI/3tE3F4SmJuYatg1JcVBUw0Z8+WqiZlzDuTfH81I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=vUBZuiRt; arc=fail smtp.client-ip=40.92.18.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="vUBZuiRt"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XknbOEMCOv4URXNevNGNEEivP3vK55vC0pBextR521h6TLx1z42Clk5UUraVRhq7/rHRPt//3NVY6E2w4PWRMpa6LnLl8UvfFm+4xgFETpMoI5cOke/xoEq6DEWZMwHCkxbbUFQOLUGCm6xAvrXXSVfm5K1dKjbORu4mJJ01QbRfWkmXJclYWG+FbsXKpnbq76Ii8YrxzDK96tmsqobq8Aobvz8mGnnHobnndh5vkGmq2NplKCMLuzrP9Gyf1t6f6pwSiwK+4asmBgGsXP7Qj5wuMtIDk9b20GcbYtywYkM8y6DZccLdrP4Rrd3wj+ehF50BW8XkORNLrLr1diV8Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClvfvoKu78ah66hLq8M+Lm9OOW4tQPIv7h0U87jAgHs=;
 b=qxShACrp/zz8TK7sHTZMrrUyfzl3s1UmxcddP7d00h6SPAQge4QfR5Ez7Y3mwqM8TJo12dmpbThQ6V4LjtOTFWsucWUEBadtcgS0qaDS/eaE4ywXCpGEEihHSywi+UeDaqSPF4tmFq+soff7GjcVzVKOyZD8NLDDwL6x6KGz1rSoicou5Once1VRP0Sf20CZ9mmfC3OlYV7eRhxwTtPqoaFWJrGSBlkcC1n9UFkDDXgFThpfEdERirvLpc0UG7fEUjsflO4NBBx0uuphfg+6KkEZ+DcgKCbP3Wv3V9gmRPo2ShhK0kPl8FD9445pRbeTVsQs6mq/RaDgPiNGMpA8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ClvfvoKu78ah66hLq8M+Lm9OOW4tQPIv7h0U87jAgHs=;
 b=vUBZuiRtxv6LFh5mMVp/0Hys4ohVPWsPEDQ44oamDSxU20PJcXBR/shiVSsMR/9+V2CsvZRnfoCXgx4h6EYnhM0i1deWAhdo9EJsffzrQLjyFESN/Gjoh29FnplsXJQ3svlsjsg6lsnyGCJYOi5xOgc8h7WQ89SiMvr2ktAr5Cxov9Of8fP+JJaTzGDthWUJ8+Mr/ZXchwsuxRUgGrSthl80dqO+chhK1lov4QR5tMJoLfcqiPQ1Jp/bJHZAb86+EH2NzEuk4SACvxe256AHHu7M2451ngUqwZrcAWeG0+MpyhqR7lZ0WycAzLVAocuLxNyX5aEAg/Q+pGPh29rT8Q==
Received: from SN7PR12MB8792.namprd12.prod.outlook.com (2603:10b6:806:341::16)
 by IA0PR12MB8747.namprd12.prod.outlook.com (2603:10b6:208:48b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18; Wed, 23 Oct
 2024 03:50:14 +0000
Received: from SN7PR12MB8792.namprd12.prod.outlook.com
 ([fe80::c127:f0b6:fdf2:401e]) by SN7PR12MB8792.namprd12.prod.outlook.com
 ([fe80::c127:f0b6:fdf2:401e%6]) with mapi id 15.20.8069.027; Wed, 23 Oct 2024
 03:50:14 +0000
From: Juan P C <audioprof2002@hotmail.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Kenny via
 xwax-devel <xwax-devel@lists.sourceforge.net>,
	"linux-audio-dev@lists.linuxaudio.org" <linux-audio-dev@lists.linuxaudio.org>
Subject: Junk Mail
Thread-Topic: Junk Mail
Thread-Index: AQHbJP5622dxzLSDH0y6bTR6+Gz7bA==
Date: Wed, 23 Oct 2024 03:50:14 +0000
Message-ID:
 <SN7PR12MB879204CC754E85A870375FCDB24D2@SN7PR12MB8792.namprd12.prod.outlook.com>
Accept-Language: en-US, es-CO
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SN7PR12MB8792:EE_|IA0PR12MB8747:EE_
x-ms-office365-filtering-correlation-id: b33235ca-3f30-41c5-507a-08dcf315cd52
x-microsoft-antispam:
 BCL:0;ARA:14566002|8060799006|15030799003|7092599003|8062599003|15080799006|461199028|19110799003|440099028|3412199025|102099032;
x-microsoft-antispam-message-info:
 YNMzUyi7Pk37/iYttKrbXhV9I6le7kWsdLCxbpd2WMQ0lMjSn+K/2UuY/slLNiI90hwWPlpEPZJ2jIyWoRjZVVmx91FNod8+3WCWL9FV7e7CiKDD6RfyEIIPaegf3jES2LiqRg3ZcaEv62J5b2TicG2UitBqwCt987fpVSGcVdFgdDsH3R3yxPiQ0qERZ8lw7a6ygQVeqP9bSvY2ioCd0hw+iK8+4s2kzSMru5b0qWjhOQ5dkEvtUoD2DYFvQa/M1yC3Ixgz4vvRrvd1ndS12SWqO/OtF6jqP9ZBpAgZBV1LqvGoaPsPa9IPo3QvAFUpsixwrUoMSGERXIYzhdJl9Yt4/4eZvQtN0Y3xN20rfQkJYuS77WMpRjQI6ALIDsJ2UNe5C87tnSblZWy9uTcvF5QOL5ehoj4q1i+xn/GtadsCkRN2DWYCQd8OvQHhL2/UrK7s+Uj0VjHt2rsE3BIVN7K5sBRhxkPNVMlkjI2MTFYgOmLDyzLHNbQvUmXNJjhiUSAuHOFDjxyTQHRL6dif8gbOBDCqFQwcT75FMLPODGyt8QIhQ6iF8xN5e6tl5ZShAyNe4bhSErGwP74Iy4sHbuDNTqAtzaThZkYrLt1ZExg8Z1FMuG+u5nxHvFr5VWuSo4YyFMClQwiri881Tj0/h98I3YU1Jd7g8DQuobzmPEeHOvsDc2g1dC26Gvhcq5F/T8cwQFkWLVQTxyBMGl+7owtWyw6cyO1Wi/wOD1gwXbxRhrvR6lG0+vg0WKAuZ7zGv6W0B8YHjray78cVzO/X3A==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?422JuQNoCgp+XJDosHMiYUOrsqiw+b1Itk4MVR/K5c0UidWtimF/cogLME?=
 =?iso-8859-1?Q?7hJMO6FSnrQlt5HeEuD1diHnQj57o5KkiVTgEkxcL59fr7ausmVLXwO6P4?=
 =?iso-8859-1?Q?d8CXyYANcfkZ17MeCKBlmpBzVgmy1XhAqMqjfa6DImhJrCdOBHNGA7Ecsj?=
 =?iso-8859-1?Q?SaeylMtRpudlgZVx6iifpeYEe9DW6Pt977U8XCcJk8KC6Nb4mWTyUj566Z?=
 =?iso-8859-1?Q?hoLad964nuRoiZlmriqZwECK1lJs7m6WGX5TSbtrN4dxfbfwPGNiHWNXNy?=
 =?iso-8859-1?Q?h/DXtlTtTH41xELgsihFR5YX3GNT9wr7nIV6DlbtOYJi9be/tem8ey/ojT?=
 =?iso-8859-1?Q?7r1JpyyeiYVn7ff/Gbq+uWHhCTRiUbyejUQ1xadBASOpBJuXBhryXJhZTO?=
 =?iso-8859-1?Q?NsA46XXttKWuKvtv1RJlq4MpqU2p+rHvPwjJoNrQmoK5yH0qY2nUJueuQu?=
 =?iso-8859-1?Q?bCC9KHFYryALrjueIG8RJuJ9+FjfUrtcvJ2kwa+fSF8bWNfPAWb2ADmpL2?=
 =?iso-8859-1?Q?Q3yJOqaULslG3SjWnlL5NnjUBYB4vcWe4bgZh5C+rJ5fXEOX9OoTIQpHHc?=
 =?iso-8859-1?Q?VaVAx+FawIVjzy0Pkr9y1grnYEJBQVywEgZNErNFnFhP6QFnmPrxwJTQuJ?=
 =?iso-8859-1?Q?swQshXCUyYYW/Km55kA7VoRvsFDg17UK/+m3L8JXaP4mZbufZW2VRmGDpN?=
 =?iso-8859-1?Q?yteED3FhphEinB8Nj1xfPekx9w2ccb9cyghyFTsuBDI6cC6tcy5mwvK/P6?=
 =?iso-8859-1?Q?QksnA7MuPmvZtvCUMBb48J1o9y1aaFnkLkcdiQtUbnhWlnPCfT2jqJU1ld?=
 =?iso-8859-1?Q?GmSrofRX/Tng3bYQpuEzocwhzMYpZg2fC7E3qzod25STyMnELGna8yt3GL?=
 =?iso-8859-1?Q?o6WRuWt3wV+vRro149Xp9/c1sK/C1zO3PYWLuk4pegEDhx0d8h0dY+JemL?=
 =?iso-8859-1?Q?pYzvveLwdbiO/KHPdOt3rNM9f3Yc5WYM7f3MXq1lNKCi3DEjptJdm68n5W?=
 =?iso-8859-1?Q?9EFZklHS7+BkXsa67AdewW6+9LagS55AVEEPOdtLQdKqXtVQL3RsYOFE6t?=
 =?iso-8859-1?Q?+uZqIpbOApNHfWuOg8YQBMqvkuMsYg14HFhIANJ6RCX8K5pDAcMyjZk5Pk?=
 =?iso-8859-1?Q?Nu0ju7d0IqUFY/XsB9JRZmgJlZKakad46AoATDuhgeznUgCcj5shk2r5fU?=
 =?iso-8859-1?Q?jw14kbrEp/ISN0G4JopxDu1lvFjjzN+5JpBJ0iXL6yCXYX92b4/JQSP49q?=
 =?iso-8859-1?Q?y0RjRLYjQlAS3d+3eieCEn8KYRxWyN5TJx8fl8hqw=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-7741-18-msonline-outlook-1cf9b.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN7PR12MB8792.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: b33235ca-3f30-41c5-507a-08dcf315cd52
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2024 03:50:14.4312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8747

e-mail lists,=0A=
are crazy...=0A=
=0A=
i cannot edit mistakes,=0A=
most emails are sent to junk automatically,=0A=
=0A=
i have to manually unblock all emails,=0A=
=0A=
crazy.=

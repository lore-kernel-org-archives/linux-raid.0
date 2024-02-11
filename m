Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02olkn2034.outbound.protection.outlook.com [40.92.44.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275D2FC19
	for <linux-raid@vger.kernel.org>; Sun, 11 Feb 2024 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.44.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707677884; cv=fail; b=i5RJGIf+K4cWSStmAm4Sq9h2WLRsI5nUZghyipzYJTfzebVBX3T5HOwmDpRFbfY8iwSH1VzzKk60MBuq8MyjDFwKl02+eldwAeQpXq1y2OJmSRdndZ83KkO4WaoYXBB/AnGEdGz4QLb+qm9behT7KbJH9zM3E66I22Nh/TJIX1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707677884; c=relaxed/simple;
	bh=WtnnL26WvklUfWAf3HvMoDlm0hMEKvjPLAjlcWLHUpc=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=BoaNzMKyXlwpoYkulMhNovg8HBYttPj4moLsJNtl1F7lZaMutuZSwUV39B5FSWP+z8orr/VUo+9Ze38KbecAJa3gJtiBwIYvYNtSeI4TWJ8uLmLq/FCQUleBKwFddasx10wHinIAsmOa2PEW+nPZyxQyMVi6ERWjQ0/BmpZmQog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=ToiYowpy; arc=fail smtp.client-ip=40.92.44.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="ToiYowpy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vc7Q+KnW1BGozXofyJmfDshNbagbyWZAJZMO4rwTdPwFb1igZ3fUXCUzK+uYn5IIARjcvi4ce+HNFroGZeQAxjoLW5vrpWlzrvKGtRZTlv11rC2t7G4HaXBNvBk/Dpml5lFeLc7wgX5qwFwqm1elYyJdRFEFthZ+aJHsLfokMLhOPkQEjCkYimA5Ijcx3x+NLDJPR2Y77hRPOg5WMGh0ILzAa+zpR8/JO1brLEvaGSO1YfDttK9bAqyY5wI792RhbmO5Rsy8IPOZ7dOgm6VyKl89gT89mKahgXrtmb4BmNZ8T3OPMwHe/gXdBUMNr9+q+LF5GAdt1lE2Rpp5nriDfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtnnL26WvklUfWAf3HvMoDlm0hMEKvjPLAjlcWLHUpc=;
 b=lk2fKZQG6Ny4NXrvQ9YI+zeOdL4mb1IADZPXdsrNSpdkPuXfHojB+qn0rck1ASrk24qWp/4pIc3AZS8F4boNHPaLqmj3TAv8USYuEblm3zK7YIEVwFgFG4l6WQUZZn//se947OLcPZrTG7H3I7n4LnmcNmBZMma68/XyFXpIgDukmTXX3+n7KePSpA+9XbVrozFcf/nbUkXf9tvQV+6hE0IoQalaCURDWqG+NqhuTvQrwUhBO73SlGTPEX48KhgR/IDMVbP5hOvtNd2eE6xWceRzEnuxf3tw7/PxNUkmLcOKnnLGdGPut5hVbFPxuXMV6WZ/YTx1f5zMcbN1oOz8HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WtnnL26WvklUfWAf3HvMoDlm0hMEKvjPLAjlcWLHUpc=;
 b=ToiYowpyKdr9UC+TlnLHlL53e0pkOQPkzqinGdt88QcmcMNKTUQ307aBGIxEHeskybQmZmJ/Mfxmb8UOoxyoK/IOeYHBmdba4FRL1KcEbcaGB4mtTX5Adq163pHky7iIDlTshVozACrnF3fFsFobIGGEFKsSfXVS/63jio0BIi3CfSO4c7zzE94HFG5aKe0l1T6hFNHCTDkVLSmJuPx1Ehe3pV29mo0RcKNgTP4K+eJsSQoUWNR4imVvGCypzGJMt86RJKRJOm8f95Nf+cXBhvWyRREaa0hZ5Eqhi4bItcErA6Sx5Lu1HFCUiVX6xudXcIofb7NcaYaVEVKJmAZFTw==
Received: from BN0PR20MB4088.namprd20.prod.outlook.com (2603:10b6:408:120::12)
 by CY5PR20MB4844.namprd20.prod.outlook.com (2603:10b6:930:23::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.33; Sun, 11 Feb
 2024 18:58:00 +0000
Received: from BN0PR20MB4088.namprd20.prod.outlook.com
 ([fe80::7cd6:4ed6:fbad:fbd9]) by BN0PR20MB4088.namprd20.prod.outlook.com
 ([fe80::7cd6:4ed6:fbad:fbd9%7]) with mapi id 15.20.7270.033; Sun, 11 Feb 2024
 18:58:00 +0000
From: Juan P C <audioprof2002@hotmail.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: missing Levels.
Thread-Topic: missing Levels.
Thread-Index: AQHaXRpCn7T6cwcIfkiQEk3gdtwuqA==
Date: Sun, 11 Feb 2024 18:58:00 +0000
Message-ID:
 <BN0PR20MB4088BAB7BB75BACB62A29567B2492@BN0PR20MB4088.namprd20.prod.outlook.com>
Accept-Language: en-US, es-CO
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [USRN7aZR2ga3V9Ef7Srpo/+Xem96YeN0]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR20MB4088:EE_|CY5PR20MB4844:EE_
x-ms-office365-filtering-correlation-id: 87de7229-cc3e-4cdb-0add-08dc2b335e10
x-ms-exchange-slblob-mailprops:
 feAVlmA1hHWEWlDwXnguHW0y9Y5mki6m1h7h2pZm6+SONVYx0NuHpygCOjeRRcw/ntr58Pb/8IBJc2cDzKfF+tUE2jloOWfDKZ7XBfzbEqZ8oqg2tHkhO/1MCtBbJEQkgX5+BgWttNSNsULnus97OFsZhvSEEhBVC1JhoHPUbR774sEH0uHhvRbmc+fY401VAsha1XOyK5gIi7qa/1136ASd8qrcHoOuU4uHnydkA6kq7a9s7zGwkM9Ze7WJyOSuB7g9uwrgCA7UwOB0FwU5P1Ly34Kh/cYiwSny/f8ueQYEY9Kcj1ykzGSIaTfxlYHGuXLsraeIz+UuELxLuNQLofLeIB978VSSITOoBkY+fL8+Jl4VCzr/bbQD8iFyn9xz9KJFKG5j/nRyTk4J0FVo9QJYjM9DD0VjwQGXwFWbHy9aJOpfOPvxt2l+B1/wWt9h0zQs9ec2ZGN7oUEp/8g2VHW7fVBoMdOx4bFeBtSjlqX8OjPuEauXkNALXjuNUQpk3GueRBgIt6DJKZHFTuOukHUMf6VzulU3aIl5lzeZdSiMpEgENR8f3oU7S6D0cpjdvDGLqeUHYqBvQahx9ouNFQR4sKxesmon2McLToJXXLZytGkvNKvA08Q/rvgn1HgtkwNT9d4HpTcNS7V7mUtSoh5UfFHuIGf/Bajyq8EAwJVYGlIb6J08UFx7ip58BHwmjXnfnFn6s7sExQItfsKIbg==
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 9x7iDHU6Nci3P6p0/tWpemwCYrhuhIGn8QQiXjZa9khB240KW8j3RgNnoiT/y9Tzz9LUVmxOJM8g354U6gpP0dAM/XZWq0ItUv68ALQXLw/B7ysSMqI7sLaNNzvk0S5dyHsNHb9Vu6eR3gMWvffn2XtHpvn0czTNyP+if3561YJUZNzC6N+RLB1/RA4j9JoDIZ5yhTc3KWtjW5UDmB936igqQKSmCJlLKmLrd1oqhUE6CUR3OHvjj66ACSO+BCPWSvOSyH/adb0PokiDPSyL7a5V80IrwunsVv9xLVevqL7ctxW3+WVkheRjqE6eCJq7fmor8wLltOdbMG14M/428eN+Qq2P7+ivrrjPSiphfvBwi/8pJf2B6ATW64FrFTx1LS4b8KR61Yd1+r3lFxssNie6pFTN/p3npoTmngrJPTY8pgYxqlBulMXdj1DIw0D8ID44/6WdxaoimtioYREaTYUvwMqHBFgE8y1w4UzE/RGcWI/X0zfB5VbF4mL0sL6N8qFadCe6reyxpnC2K4ZW+KsXYNjbzVa7RSD74XGaiV56BX1sXkaWltbScEIjiL9l
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?OxAobzerdor5LzMkqxffXUUQ+0213JFFTGXiIEyty2NNYvsbMKdFMOE5t6?=
 =?iso-8859-1?Q?Ut1y+F5xsmsjM+W6RTQ8CrBQKohymaMlTPtFysMaXSa8ojdNBhIDN4PUHB?=
 =?iso-8859-1?Q?Kdg8CDP6gnyWex7YZvpiLX5r4d1frzIj94vNlXL/rnkPF0zk5aRjprQHjG?=
 =?iso-8859-1?Q?bQaQgSuZZg8zPIVR+HUilfrqBnCbUAAy3DHu4lH/iBpnrOqF6ltz88Xt8v?=
 =?iso-8859-1?Q?Ta+F4HaXPdO798XUHsC0xWRyaGZ3Ppukl3VkjVdbaKPohF90u8WFtFmmDu?=
 =?iso-8859-1?Q?B17Ywippfdg1s4H8mqsg6gCVGeQsvXYpKBug0Q8EoPAvJcKpRkSRRDxYkG?=
 =?iso-8859-1?Q?FK7jP//mkxocq1GKLvLCusX1TU+07u3nPPRmBFfcdMiZ62WnSQXljrhLsn?=
 =?iso-8859-1?Q?8l2xwgTVzIspmCHlbMQdPf9ZiLSWJz3rIl4O97jx4pA2HVc02RgnTbCu8E?=
 =?iso-8859-1?Q?KdJit5uE9t8Rv6Im4bsVlEUXakwuBBjGqViLRsTgqspx6VlTSYgxlBE9eR?=
 =?iso-8859-1?Q?ypX/qyPo8b0fBJmpMAjM7KkAkCZymdgSK1kd10tATq6MBjrMhueg0ul6TK?=
 =?iso-8859-1?Q?fOl00+vBDbByTlpTnVAftZNOB3ZdUFjpsMFx8jT3vDeOrSCTAgzIhQ62ei?=
 =?iso-8859-1?Q?AIcYGk3UB4B2WTtEkH0dNUpB1SyoHA1wPkzF3te/UjAigmkoHepsgn0PQO?=
 =?iso-8859-1?Q?Ki/gcdm2FtsYRo3JcAe2/PewXTu6ub+qJvpojVia6glGpnegbrg6ASwSsk?=
 =?iso-8859-1?Q?eGyxSIceUXqzmkToTwNzqVPnHOQRfP9FAzXQUiIHT34jqvdOd9THWmA/vj?=
 =?iso-8859-1?Q?BQaP7pmHWkMGPh4G/QmKe/COvJUdHFvOrGn9KciWR0m6T7FkGGtv7GHrf+?=
 =?iso-8859-1?Q?mp+xG75r5R3/yJouRJYydKoOWLxjBEUy5GSc+cBZBbkAvEGWC+sN98HucB?=
 =?iso-8859-1?Q?JeYUKRspaxDgLaWxOgylG+d4A44Hl23YhcnOSp7hORkzC3BMXFLPJi0ZG/?=
 =?iso-8859-1?Q?aJfh4kvZcAFwkQ3l7UG3KDPbsqs99rv0pmlqGHc+7I9dtcF+B0c02oDP8O?=
 =?iso-8859-1?Q?0LqU5AN/M1/78o4ylcWzJJiz1SNkCEByAcuhLe5mIRePHP0CyTjlPF3vmU?=
 =?iso-8859-1?Q?u9Dbro7SzegOJUB4M2h0SJpmSqMQGKuFFbjhYpy7297y0bMJcEC2u3vsQn?=
 =?iso-8859-1?Q?ftTh5k7ErMDQOSC7nk7wNCbQyS8y1ETottnCCx0VNdKwD7mE9huO8lHVN3?=
 =?iso-8859-1?Q?T7bXXKyoTTBVEiPGz4a7qFpHvWyaB/q6tadkmair0=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-9803a.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR20MB4088.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 87de7229-cc3e-4cdb-0add-08dc2b335e10
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2024 18:58:00.1146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR20MB4844

Seems odd, there are missing Raid levels.=0A=
=0A=
dont know the history of linux-raid changes log,=0A=
but seems someone made a bad decision in the past.=0A=
=0A=
Let me explain:=0A=
=0A=
Enmotus FuzeDrive 1.6TB its actually a QLC 2TB M.2 NVMe PCIe=0A=
that Requires Windows Raid drivers.=0A=
=0A=
Has built-in different technologies, All-in-one.=0A=
=0A=
#1. Smart Cache RAID mode...=0A=
Small fast SSD + Larger HDD.=0A=
Similar to intel Optane or Apple Fusion Drive,=0A=
But both solid, smarter,=0A=
defrag the ssd,=0A=
moves most access files to Cache drive,=0A=
and files with less access to Main/Large storage.=0A=
=0A=
#2. RAID2 mode.=0A=
the drive is partitioned in 2.=0A=
1/4 of the 2TB QLC is used in Raid level=3D2 mode.=0A=
=0A=
The reason is to emulate an SLC with QLC.=0A=
Increase speed & longevity by 4x=0A=
By reducing size 1/4.=0A=
=0A=
Real SLC are very expensive & power hungry.=0A=
QLC are cheap.=0A=
=0A=
Basically 2 Raids in 1.=0A=
Inception.=0A=
=0A=
=0A=
Linux-Raid, should have at least Raid level=3D2=0A=
To create SLC, MLC or TLC from QLC, TLC, MLC ssd drives.=0A=
=0A=
for example:=0A=
Samsung 970 Pro is MLC "2-Bit" PCIe v3.0=0A=
Samsung 980 Pro is TLC "3-Bit" PCIe v4.0=0A=
Crucial MX500 is TLC, =0A=
Crucial BX500 is QLC "4-Bit", No Dram. =0A=
etc...=0A=
=0A=
Smart Cache Raid is interesting,=0A=
But more complex, =0A=
would requiere creating a second Journaled log file, or an enhanced version=
.=0A=
=0A=
Temp folders are usually better on Ram drives of 4GB.=0A=
=0A=
There is a ramdrive for linux, with Cache or Not, just drive.=0A=
Called rapiddisk on github.=0A=
By pkoutoupis=0A=
But the lack of Raid level =3D 2 is devastating for Linux.=0A=

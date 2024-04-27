Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12olkn2101.outbound.protection.outlook.com [40.92.21.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F77ECC
	for <linux-raid@vger.kernel.org>; Sat, 27 Apr 2024 22:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.21.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714257359; cv=fail; b=a1uPymqC1resntTHGOJyueJo671N/PvfagwJNnz4Vt1jZVLEyk2I//sZlHBmQwN/gWHiMJ2Za1I078EZeNU6INLt+Wd5YqBA0Ba9YZR4kBWKD/DpuVkyXQil92RjhZHh7lksb2U3n4xakF69JCKGbu5cfPNv2Q1rHvTLXJh5phc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714257359; c=relaxed/simple;
	bh=9W5sotTojzsRvIL0gHM9oU7V5FlybYv9GpAD/qv8TnY=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=cGF03Q1xK8HyuylI6Y8D6dblbkX27MYWnh928D8P6941v+BGU9UU6VP1oG8ZIS+P89yq/zyuC/+VstMIB3SGIUtNRgSWz49wmZuWoqdILsvkPVy5qaXyh18s3F5A6qb/zY2exWQSQfw0ZRFPfKkYbYGI3o+u/Ydz1cgPxaZuCJo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com; spf=pass smtp.mailfrom=hotmail.com; dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b=BDvITWab; arc=fail smtp.client-ip=40.92.21.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=hotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hotmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hotmail.com header.i=@hotmail.com header.b="BDvITWab"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aN637lFKgsAogP/mea5hUt6VGSrixuJENgCdFpRIy38aygwRNMdZh9AmZuZH/0+2/zEl6XwYyIcpYImdEHo21MSiBSwT1ZshRsFczLIVQwJu1pr12xwFVV6jYvQi5MWbHzN9uVgnJGqHp4sfRNGWiuVdrYBa4WF4RNDH28xKaOg6ekCJuryuyjQjjD2h8bU+j1ilq7a8/52x123ohmqPvl0soqPBmTXTPjQteQCxsVWiP5OEZjvbnmyN/WuQercxAmxjfn4hU+tZHj6cqfJ6pMwB0YbNVnY488YstvCdWl48jwWzAbmZZ6Mzjktr4Pi3dqbLkZ9UmprUtPIybAWYoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9W5sotTojzsRvIL0gHM9oU7V5FlybYv9GpAD/qv8TnY=;
 b=IH85dyxl1/wuiyACG3RXON/u0f2ETyupwRjE1hJlJ6Fz/uJowhcO1rjWljnbAD3Gf5i3/2geq564hD+zx9mzYtsbMBjF7ilmTFDtgPAkahF0Ye+olwuHYLiKdH6+UGaDTTsjj0OEVqVVwcyPCd8EFhK9vIihgbYQjWAJjCn/5jML41VQRYhrqvWayh+hcAIOob0pwL1yLS6pwOcNDvDTq3rOrAfpVDORjBBUx6fltyIZtHcimU4IOBBR3IGoHZ+hfdZ+KI6bMLJeYVNOpvj67XIKdjaKq8w3OdZH4iCyXL8Y7BDFOsNhJ2eXaG8+6rcOqXsqHs16f8zfJZM4X5lb0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9W5sotTojzsRvIL0gHM9oU7V5FlybYv9GpAD/qv8TnY=;
 b=BDvITWabI4S1nWFRs58fDe8Ozd8pMrTTi+E/jVOc7eAg3W9ta6V3gzaFnEEKo2MZ32z3dtUBFNuOFFlnb0OliFqeWTdHlVGql4F+Z9o32M/uIWth+Na1fqk1OY2WlvhgBXtOWm2rzdrAZnwwCIC9pqdNHu04elijoqc1j7/wilDxQ/ZDHmzAZXJK9zw15CB2B17CBMHcc37ghhWZlN3IAUoyhtKkiRkv7hBhj12WYdHPzMfqbH4JPMb5MmNhK3c1ck6oJq3qeSs9mJ580uuccsWmaifodhbHHRC9rNWCF8sdoZh01/pkLCVu4EsnFIRUEPi87Cmjx0KtPl90A5VgJQ==
Received: from BN0PR20MB4088.namprd20.prod.outlook.com (2603:10b6:408:120::12)
 by CH0PR20MB6419.namprd20.prod.outlook.com (2603:10b6:610:181::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.32; Sat, 27 Apr
 2024 22:35:55 +0000
Received: from BN0PR20MB4088.namprd20.prod.outlook.com
 ([fe80::1ed8:dfc9:9a79:83f8]) by BN0PR20MB4088.namprd20.prod.outlook.com
 ([fe80::1ed8:dfc9:9a79:83f8%5]) with mapi id 15.20.7519.031; Sat, 27 Apr 2024
 22:35:55 +0000
From: Juan P C <audioprof2002@hotmail.com>
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Temperature sensing, behaviour modification.
Thread-Topic: Temperature sensing, behaviour modification.
Thread-Index: AQHamO9QPkr26C5/iUieGSyQVtzeyg==
Date: Sat, 27 Apr 2024 22:35:55 +0000
Message-ID:
 <BN0PR20MB4088A979B801440FA654F044B2152@BN0PR20MB4088.namprd20.prod.outlook.com>
Accept-Language: en-US, es-CO
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn: [l8Tpl5zqAOJR2yd+LaUbDsSyilVlsBOv]
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR20MB4088:EE_|CH0PR20MB6419:EE_
x-ms-office365-filtering-correlation-id: 69508fc3-7b5c-4783-fcc6-08dc670a6705
x-microsoft-antispam:
 BCL:0;ARA:14566002|461199019|102099023|440099019|3412199016|1602099003;
x-microsoft-antispam-message-info:
 sJB46aRsD6ORBxHiQlIljX3rubLD/9xKH2Yocwpi9q6pFvDWziSg8cXnTtEPGD/PiPJxAaJjsy0+6LE0oB4IhvgY4Vm3gkSF535j2P5zGdH1Nw5F3K+Wl+vdFxnKk1FzesXT7gocOedqqTG/eILtSsv/QN8mxu4rnkQQO1aKRap+iBbtNSdxAp65o85LbmY3KNzjZxFooDoIONA/CdWndxxxqW95rGknb4uYMdJtx7wCRN/rHruZRp9q5GdX3hYsd+ZMWVZh4LbfHRh/79dSve12DE8YVIfn1k+SupcSX5sfAm6XXvPRrRO5hyzb5yZlQL6KsVv5WVFrfs5O20ALMEtkwmtw+A9/Y1j225KsD7s/mVdZ8A/M0blJoWyGtmdyBYNwTUKlqu414qNm4qvYaYxJvFObU6MLyIHac6DoGPYdkGxvtJTtDs2Z3cLOSpygT2pJsLgydUFJpRgwRMy8Nnc/Yhm1wpaqc2YoyIv9HBZkutADRbJdDcIVrLN9tRa9MkN31twDaatvN5X9MqssWcSRz4ZcEBfDfex3nznS/KTPEHjA8MZTVk/ISt3j7BfC9q8BK9hJn0K51oBNr906h4t3s8Mi83nyp03U2Mc1oAES4fnczwRLe/b/W4UxBjTLP3JwWyFyvVqTO9ROQxQKRBU4JzjIfC4zE3245erPkOM=
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?o/p2IUxUQz5F4GebHrKYvA07lXcoZpiEYLQojIYU9tT6sc+nwKU6Vfw7B8?=
 =?iso-8859-1?Q?xNuMA27biWyWgBLECo1+mutH0b1H+nzFxD8fv6jnrlNqxEPfz+tgDlYhXg?=
 =?iso-8859-1?Q?xy614e07bzr4cSouLHiGvznw18MqHLG0Avl1mHc9YqvXvBLY0xZXDc6BRE?=
 =?iso-8859-1?Q?3Zz34mPA2SNQwPBh85Vk2OiAzZHB1r+lpooBewQizv9cqgdd78ts8Qpic0?=
 =?iso-8859-1?Q?gMd+6ZV+2DxBnKhM+NfSVqt0EmpNR8XSzNaNlnXxJCyVhN9jxVAtdkVudk?=
 =?iso-8859-1?Q?ywyfCJ0/GdYLon+LKwSOBu7r8sI8DIQg0Xo7pDmYnlCu/hXeTnA/HA6/4x?=
 =?iso-8859-1?Q?Jtv4r/htUXvwo+W7JvBGlOA1ChfM5Cog9qCYrf22ycEwHJmTcQJwupeeFI?=
 =?iso-8859-1?Q?QuDdfpNjAAGU6QTJywdHeKmJi9kzOE49LEdiWgP1AoaYAcgqIi5AlZuRK8?=
 =?iso-8859-1?Q?vtGvFgE8Grb+1IUeUo6N/lrEHZ+UxQk/JdqjjoOb5sTo1rmrTrMTfJnYy8?=
 =?iso-8859-1?Q?Z/ALiRv+cbAtumz/YS80sbXv/vw+KNj0Lw+4e0V7ac68uo+v02rdoUtN5F?=
 =?iso-8859-1?Q?q0KIq83EHVSk/mk/TIxF3DuH4/n+s13AMkGcmok7ReGfNGANfifRbkjZ0k?=
 =?iso-8859-1?Q?CMV2lzL/gn7FA6zC/StLdSTCmf+QHZBL3iXNmlOYubDhA2RDnKaTtnIAL5?=
 =?iso-8859-1?Q?DDQFGw6yq2rm2IW5B3Pm/czPZllCcgtwGcYT3ufIRdVzbqzgixcAdNAeoQ?=
 =?iso-8859-1?Q?poQwNeab2CXbZw+5qcX89yEjG9Q82HcDAkYI4D/U4XO7e7OagZGSNkJMID?=
 =?iso-8859-1?Q?YZmAwS1goBp8m22u6CMkMy9wLm9PaIB4wAVL8761+yX21DaJB+KVW338+L?=
 =?iso-8859-1?Q?4KB+w2m+WDailDx9bxPeq4gxUDjaloum8Muf51xMVp7mFyGKrRP75ZZdIu?=
 =?iso-8859-1?Q?BfUchvMUwLo+YiFli0QbMEM6qGvke7ZtlQRkdUTpkwO5zbuFZxyhai2VD2?=
 =?iso-8859-1?Q?6bmo+FTxGGl2VidOwaTS2q8/7yvDDN4h3vWL/LPNxoFqh6yU51ur4z8Ff+?=
 =?iso-8859-1?Q?Oif6a+hRZSGmX7fW0zH3zpEJSpl1tpbD6yoQVonJhXxB2a7v0JszxeuJTG?=
 =?iso-8859-1?Q?CTY1ezET8D1VH9U3kFcIKwVmYebM93qBB79DgoIH+CeBJw0o5/STqCccEK?=
 =?iso-8859-1?Q?r9nbq91wtkrbbn+AMNUi7rCN/QyGGd+s4iI2RTbkqhhLA2eq1uuhc3DvJA?=
 =?iso-8859-1?Q?qVQDxVXdMCZrEsd6dHB7LIvfj78PSgkB7sR8jcZZw=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 69508fc3-7b5c-4783-fcc6-08dc670a6705
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Apr 2024 22:35:55.5370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR20MB6419

long time ago, i purchased an 64GB Lexar 1000x =B5SD card, =0A=
wanted to go faster, and made the mistake to format in a wrong block size..=
.=0A=
also made another mistake,=0A=
sending several GB of files in 1 copy & paste.=0A=
Result:=0A=
=B5SD overheated and got permanently damaged,=0A=
=0A=
Fast forward Yesterday,....=0A=
i purchased a 2TB PNY XLR8 CS3140,=0A=
formatted to XFS,=0A=
sent several GB of files in 1 move & delete.=0A=
Result: =0A=
CS3140 overheated and got permanently damaged,=0A=
New, 1 hour of use.=0A=
=0A=
The problmem is low efficiency,=0A=
low MB/s per Watt=0A=
Low Efficiency =3D Heat, =0A=
Heat kills NAND modules.=0A=
=0A=
you can blame PNY switching to cheaper 112-Layer Kioxia TLC (BiCS5) in the =
2TB model.=0A=
instead of the original 176-Layer Micron TLC (B47R) in 1TB model.=0A=
you can blame the CS3140 2TB Firmware,=0A=
but in the End is Temperature...=0A=
=0A=
Linux OS should monitor PCIe / SSD drive SMART temperature...=0A=
and Pause File Transfer Automatically until Temperature return to Normal.=
=0A=
Give a Warning, and countdown clock or cancel transfer button.=0A=
=0A=
There is No point to continue file transfer if drive gets damaged, after tr=
ansfer is complete.=0A=
Rabbit vs. Turtle story.=0A=
=0A=
i was using USB3.1 enclosure with RTL9210-2 / -CG controller... <500MB/s=0A=
Drive is Rated for 7000MB/s=0A=
Enclosure has No problem using higher efficiency M.2 drives.=0A=
=0A=
https://www.pny.com/company/support/solid-state-drives=0A=
https://www.tomshardware.com/reviews/pny-xlr8-cs3140-ssd-review/2=0A=
https://www.orico.cc/us/product/detail/8039.html=

Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550E5204091;
	Tue, 29 Oct 2024 09:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193171; cv=fail; b=Qvhj0ARK68Bt/fRhkcFMI2oAiV+pJiBTLOdhqrHG8FTkis4mtFtqQy0t1CbbjWnjys8PTxvOFJI1z3RooS1guqQ6LSRUNNlrSwZVfnQmGxSEDJuWaCGP/8Wd8LgAxpudN2Ci7r0P9OMOCVbLYgMWko/V8qwG1ltHURBt/ZmeDL0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193171; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OenolrqyyHdMhXt3xYDi8xy8w8pg7NH2IiE41ARhJVeOosppLMDSMy07PtDWa3Ab2GwmJaqh3rPOQMBt7FI4ghbIIFTZWwMTXT3//2Teyxh541Hfx75PCbTV0yLJMOib2CZYF/6TDmXCy1sTjsIsBnB5fu4emONq++2F6F9g3z8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=eAqMtxSt; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=ErUNr3n5; arc=fail smtp.client-ip=216.71.154.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="eAqMtxSt";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="ErUNr3n5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730193169; x=1761729169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=eAqMtxStqQ9B+Si+PlilQHS5yICrgnAi+K3Daa59vsnaANq/Jo19B3s1
   wbvlikA2fWcP8Mr44RfjQnBhQh1n/SI9iFJDIDArGo69W3vu3/48rb041
   tDR1RB7hUovOlb0WCYVRfTiW8OmvKX+sWlid0aLtMA0laB6Ei0zdFQ/6U
   zGgtMY2oDpobnwlk03RZMbXizbhdlc2S+YVOg9BEx1qTWu6mQoDZP2xKN
   e8EjpN/lLDdDNRixtsgla1q0FbBTLTw5HSNPoK85/szhGzLto4rMlIEXo
   e6ZhJe+t5nZDIVXL/s9+ZISxdpwK8XmlKeUWu+ooZ3Ju6MH5cVoB4Dfg1
   A==;
X-CSE-ConnectionGUID: eJew0CUpR7SoAcX8dgHmDw==
X-CSE-MsgGUID: KlQ8IC01TsS2Bimq7MrHnw==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="30111079"
Received: from mail-dm6nam11lp2168.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.168])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 17:12:47 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5v4D00CFJlMYAd7R9+Y/t69B9GEw4qayM8adwqe5kRtDJN0BO1k5unogx1Obu4WB/0oSVlQxKn5JRR0zirE0QX0f2H2iAxCjNxDobZwzDQQyHY4XxPUM79btpJsFjlKD9IjJb0VuriuM1HWjHOsRJUn2+EdRb/qFQZbzt9KhxiQHNXe8H4+Yr5qdRYZfyufLJ/uhpChZhpt6ipF1GDaVsI/EpxgU4tDGFcGNMfumR0p3PxJmbn5t5cPCrRYBEqAcbqWuoMOUt3zx1mZ9/cUQVMmNaJBHZdlYpQslB6/5S7K1XdAkV4/W2YRLR+o2AKkHgbdbj2m2maun7Poj6Lgog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=wUDq8ppTJa69AEsXQPJ3EjIST1qH0NMeGaqgorIe2DSvFLAYCY7lVSJfPv4bZPwm/WRn4FpTH9nma1/Hgy8lFKeFepp7h6y9wwCtek4r+301haLNPYE9WvN3g3WxppikyrTNxpSs+0R8X1J/ZBTfFZwRNk1V82uJGUCx0d1rirCZFjkXKOQhLTVt9gHJDUHtQAaHcnFe6RgE5hoIuwqzWEy8+JJvevu0XroqzyQBgc8cuiaJQJ9U/valz0DRKBaw/EzrgvVR55CRg6FSV1PUHQD/66CLQmJlYbxb7WPTuw7zVUiK8kN+WwcSuu30bIIXT3glQjniE78C6lhWIy8SvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=ErUNr3n5Iv3wpQ9TonYia0G8USkXkDdnRTAE6cGiS7wHI27Q11oAfi+NOGpsmQ85BxY8wfQJ6NkJ1QcBZb/noBra6UQOt8cfepLIaiaoYJeIEfrlOzIs5R9oJo3oSIVSUiiB+OqOANtnmMwa+81tEwejFIHhfVpJXdgL42evZhk=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM8PR04MB7846.namprd04.prod.outlook.com (2603:10b6:8:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 09:12:46 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 09:12:46 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: John Garry <john.g.garry@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"song@kernel.org" <song@kernel.org>, "yukuai3@huawei.com"
	<yukuai3@huawei.com>, hch <hch@lst.de>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hare@suse.de"
	<hare@suse.de>
Subject: Re: [PATCH v2 3/7] block: Error an attempt to split an atomic write
 in bio_split()
Thread-Topic: [PATCH v2 3/7] block: Error an attempt to split an atomic write
 in bio_split()
Thread-Index: AQHbKU4A10ZpJtQbjEG6L9hhKLnUtLKdctKA
Date: Tue, 29 Oct 2024 09:12:46 +0000
Message-ID: <4382d9db-3908-4ad6-b1b2-60d5b1578f6b@wdc.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-4-john.g.garry@oracle.com>
In-Reply-To: <20241028152730.3377030-4-john.g.garry@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM8PR04MB7846:EE_
x-ms-office365-filtering-correlation-id: 0834fb46-7698-4fda-c5e9-08dcf7f9da62
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?dVVSR1RlQncwdWxFYjRLN09WRGcvMTYyV0l3NjhUcFcrc21tblhlRDVlZEYz?=
 =?utf-8?B?UG4yTmxqam1CcnMwTmZreVE1dW9tVVRpTXJiQUlJUzk4MGRLWHEzN2tsbkY2?=
 =?utf-8?B?d3BVQWlPQ2R0bkZYckQ3dTVmRHNna2dIVEhvSUlYOG9YS2NvSXVWTEdUVjZX?=
 =?utf-8?B?REt0SWJxbmdFRGQ2QVp5ZDRHMmxFRjdtbWFWMEZZSEJOdFBWNEV2S0xsbFdV?=
 =?utf-8?B?eVp4ZXVaNEhsNlVBajl6V0J2SWp1ZVRBZElXVFY3cFR1Nm5GNVhvemxadUND?=
 =?utf-8?B?ZXBNbTkva1YrcHVjUWVIQTRkVU9la0djWEpmMXByQXkyd2pyRDVXUCsxSUYv?=
 =?utf-8?B?U2Z3QlhMUVFNeXNYbDNmeWRPZzdLY282WGs1aWlsMFJwQzZXbVpsWk1WTXI1?=
 =?utf-8?B?VmR3WGxkUFROSGlUN0dhSmdqKzZSL08xRFBMQjZTSldVbVV4UVJMUE1EenJm?=
 =?utf-8?B?bGRwbDRrQ3E4QmxFNlhOc0xxNm0vZ1BSeEFHQUtudU9DSzZYRkRKSHk1MzhP?=
 =?utf-8?B?a04wK0dBUzBQV3dKZ0llQTN5RWhYL1E2VzNIU0thd2V1VDRiV1diYVZpamEy?=
 =?utf-8?B?WEZEZE05aUJCelVkdFJWMGpqd0tUY1htYU92RGF0Z1RZZytCTHd6WDJxTFBR?=
 =?utf-8?B?MUcvV2gxUVpyRkdOY25PUGs1NVg3UmdWQVk2V0t0QkcrcWY2TU12UE9GMTZ4?=
 =?utf-8?B?MGlUTDdEUHJaNjF3aGlBbmRiUk5OZFhPY0xzODhWdTBoeEVKV2haUmdLQTAw?=
 =?utf-8?B?cmVUK2diVUZsLzlvNEZyN2dnTUFhT0FlU2xzV3NudFMyQW9Gc3BMeDRtY3Z0?=
 =?utf-8?B?ZXl3ZlBURkFVcThuL2c3VTJ2OGhleHJXV1psbDZaV2RVVm9jbmZFbmpsMEJR?=
 =?utf-8?B?TTQ2amZPZGlFejZYSTJtazgySlNSdDA4Ym8yd2RnYnAvWGxzdkdOL2pZOGtQ?=
 =?utf-8?B?bUc5a2QxU3luZVZQSjFkMTYvSmw3N0kxS1JYeUlpUjVBTzJLclQyY0RjZU50?=
 =?utf-8?B?TmJmaDVwUjUxV3IwOFdrV216RUVPV0s5cGxvSXA2Z3IyRWFIZURaUklLcGts?=
 =?utf-8?B?b2x3VzZubXZBL21veERYWTFLNE9IZndoSjZ6QWtCcThNUTBhWTk5U2hvdXhh?=
 =?utf-8?B?Wi9NQko2TmptZDZ2TmwwcnVrMFA3c29NOG5oS3hUcWRtTzVPSWo5ZThkbVE0?=
 =?utf-8?B?SWNtVFJUd3ZTSldXNEE5TDVha2pRU1h4b1VMdEVNSzVGdFhFSTNUYUwwOFN5?=
 =?utf-8?B?NHNsVFFETEhBKzQzZ0NKRmZNd2VxUDlEZXNaTnRCbGZCbGEvTmIxQlRpZXFm?=
 =?utf-8?B?cEdMdlJDWllXNkRUWHJmODFzNWI1QXEwUG5SbDBRRWIyTzhPMG5leXpNZWJB?=
 =?utf-8?B?Y0M2RlB6RklFZ2RBRWUrbFlTNEZRMFhobUlpa0xHSldGM3JPOGpSSU5oRnZZ?=
 =?utf-8?B?a3lWYzcrRVJaZHZHOThUcXVycmZPREdrWlJnL1RLUFJVV0lZQmhQeU11ZDlz?=
 =?utf-8?B?SGVZeWdBaGlRT2NnQlp1eHQrMjRVWE04cHlvSW5mYytwL0NXZVQwRWQrVVJP?=
 =?utf-8?B?TklRK1BzQ21NeDNtcEJHc0tGVmh6S0d4QldaVVZuZXJ0L3dUdG5QRU5JQzFv?=
 =?utf-8?B?cTc1KzExQ053bjVrY2pBWi9VeVJUZ2tyRENKRnY0SHF5QjU1QVBQM2l5UTdp?=
 =?utf-8?B?bTF6bGtxaUtkS0FpUk9QYTVJdE9MblBwdmNhemlVRFVBMmNsMUtUeTdQeE51?=
 =?utf-8?B?VW16enBXK0xKVEU2R2ttQ20wbGtyRkV6UkczWGlqZXRpTWNzMDlpNGpiQmU3?=
 =?utf-8?Q?LmF6lOPCHgLU6o+/CAwnhEUe71itYFS2ksnqM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?N2tDYVoxbk1kVXgrZDQwekVTMlE0OWpKcG1kUHRUU3hRSU1QcHE4dzIvdEkv?=
 =?utf-8?B?QWx0a3g2WTJnajdtdWRKRGY5enVSMU1ZNGZnVDIzdFhJRXQ4czl3ZFI0cHE0?=
 =?utf-8?B?SGZZVlUzcHF2ekEvUG5GSXFPcVBWeUFLMUNmMDlYU1ZSSlBVYmFYeXJtUTJP?=
 =?utf-8?B?RUgreDdZYWQ1bjBEZFQvRUU3UEdKSjFRSzhURDFLeXhKK2xVYTZGeXVxdDUx?=
 =?utf-8?B?K1BFbVc1UC9hRGxqcjFKa2VnckhJVzZ4RUpyS1kvdWV0N0ZqbHZrRFZMajI5?=
 =?utf-8?B?akU4cGQ2aHo3RXlxVHBhWW5HeEVxVG5LQWNqdFlnSjhWRVB4K0RWWGJlTEph?=
 =?utf-8?B?S2o1MnVab3ozYTdlS29RUDR5U280ZS9sdGFqUWppNS96TjFVZXc2RkxUdzlq?=
 =?utf-8?B?U1FuMzRxNVJ2K3RpUWFBTTF1RGNLeEN4WDZoLzFZNmExYi9DblcwUFkyam1r?=
 =?utf-8?B?RGUyVFdSMmwwazVuby9JRHZ4NndUMGZWdVI5azg2Y05Dd2Fydk0vakdCUVBD?=
 =?utf-8?B?QUhLTTNJVkhyZmI2bnBpOTBZdVJTRTdCTnVuZHJQS1NUWTd6aFNDZC9ROG12?=
 =?utf-8?B?QTYyWEtldXFtcStNTTJqM0ZiZm90RmkyZ1dxenhnL3VEQ1VFc1duLzVBT3M1?=
 =?utf-8?B?aU5qSEV6K2YwQW1ybS84Sms4b3kweTBPWk5lQlN0SGZRVWhRTUQrSHFUei9E?=
 =?utf-8?B?VHFiTUhJSmRDVFlXVHdxT2dTYmp0T2NJZkZQQzJpK0ZPL3VmeGtwZzNRUTZX?=
 =?utf-8?B?YXVrVG5TM0RJVnpxQkp1bFN5WlgyRFRVencyRVA4dGlOZytYS0E4Vm5zeGRP?=
 =?utf-8?B?Z2JBSGJzRFI1ZSs0L1htQm12bVVxSk5lUW9aVmNSYW5aMUl4K0ZKRzRYNUds?=
 =?utf-8?B?eGxJT0xucmxlODNpTzBFek12S1dmOWFSazYwcGUzUDVYaU1ORW9ZcVhQSmE5?=
 =?utf-8?B?VjZXR0JUUFVXd2ZVVkp5SUtMeFAyVmpYUUlES0VXejNJRkx6eW1MRExIaUpU?=
 =?utf-8?B?SmpsdG5EV1M1emxicjJUZWRJd2U3RUt4TC90SnJPV3lyeG94OXloVWFVYjBP?=
 =?utf-8?B?L25heUtBTnJSR3BDM1JNQWowby9aQXR4OXZrbG1JSHUwUmhuOUxTa3VXd0Rn?=
 =?utf-8?B?NW5ueDFBL1BEMVd1UGxraXJybHNhZDAwRGttSERCVyt5UjVKOWhUbDVqOGtz?=
 =?utf-8?B?N28wMEp4Q09SWjhIeTgxeXk2V2w1RGh1dXY0YXNZOTV4NlpHcmRLdXdKbCt5?=
 =?utf-8?B?YU9PSDh6K2xRVUl0ZFFRNy9Td2FNSFhzZ0xnM0xudThFRm5FZ0k3SXp1WkVW?=
 =?utf-8?B?RmhlZXZ1L0FZVm5CYjhKTnN2Tk9UZ2NVK0pJOFNUbmMxcGRwVkdwQkxDV21z?=
 =?utf-8?B?WlFxNE1Ea21xeHorU0FxUG96YnB2bWxpWTNBT2V3alRwV1JCSHdXaGJGT25r?=
 =?utf-8?B?Y2N2cEFaZFI0WFp0M1BvS0tWbWdtdG80SGNZa2RwSU8ySHZNdVZDRGpJTlM4?=
 =?utf-8?B?UzN3RzVNd2tZcTMvZkdkMnpwa24vZzVLb0NReUxiNnh1a2hTcWJrU0lTWEhm?=
 =?utf-8?B?Y1BEWjdNOWhXekRobjd0ZlVMOGpBcll5YnJkOUNCVmJMeEdlV0gxRTFEMUJx?=
 =?utf-8?B?S0llWXhVRG9tdjhTZ3IyR2hxRUFBeG1va0RDbnN3anB4M1pXeEdmRENuNExS?=
 =?utf-8?B?NE1QRlJZY24wOE9vUi8reGdHU2FvNngzcU9GRVJydzZldE80b2hCWnBXOTNj?=
 =?utf-8?B?Tnh3N25Bb1NJSWYvbDU5Sk5hdEt0dThaUTlzQ2o3VFFLRWJncW9jWHUyQW1q?=
 =?utf-8?B?djdKcUdXenAxSVoySjZLZTdJbGxiUXlvOEFoRDhXL2xHeVF2K2JwclNNaU9t?=
 =?utf-8?B?dzgrQlZkMUtCS0RnZWZXVFRZTGhHaEVEMkxDaGpQMkxzbGdlTkFDQmcwTXQw?=
 =?utf-8?B?UTNCbjRRK1NwWVdqL0ZWWjh0SUpjcHZrNERySGUySTJuTHhkVE92MURRVWZq?=
 =?utf-8?B?T2JjNkdCRTArd0YyOTg3cDdwQVUzeUljSTRiNWZOQjhjRUtLcDc2UWoydzRn?=
 =?utf-8?B?OGMrZU9WWCtrWDhBMng4eVZEbnlJK0o1TkpXcTNKQmpiVkJNV2tYeHYrYjF1?=
 =?utf-8?B?aExidmM4WFc4VGN2dmZQUmsrY2J2S25MbUppcjB1TklJUGV1NkFmZ3YwSDFp?=
 =?utf-8?B?R3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3649505F5E48C8418F468690CFA1B7C3@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6rpy+Le0de5nB/cOV+5YS4w8CPFN0EG9/RORvxN6oE2qMzzit2d/8D0N0Ht6mfCC2VzW4GbgbAL2NFMy/D8AgUifeQI9d5Yoxt1PSZFiA+QlQzYg0UQ4WhRUTNcvikp7YdLMqAMhal9eX/4Oo0crhgxw6MhI6ii2TnyoN9OnOldbimQDGMTaQTnXMBuZf15TUaPR+phDaUjQ1pBga0vLlBVKCWS3nEYFynEZRNxvwffjmkcnjNJk/E6aOXGR9kHXB8vVmvxicbruaLWYzeoffbVKIN7+dZSIckgRrBlfdXfDwAhTnSoOSMKBpbUQmRs1kFAa/00F2sky4zzdjl1bQR3EDHJIOXPj62YeaLrQG9BGUD4UCjM1liynKs4lTu9hJKwvQhlL6L7BHAEOPGHtyoqxK7zsn9ukL07cSzSH3mypoi4uMFtqpwCyinAV3hJfna37X9+wvm4GsfiwBRA8k6/96/4PwtqY8nm4AZsm0bujhKcHn5GfmmYx5HjdTDNNwuzYLngDnAzrEukk5rRSLDpQwZfA8NXgRsXcSjQn6VALqRY31MACWdjkE5jTOZ59OSFcESkd+ktJcmdlCfFvJLjk3eHv9MVsIC3yQtALdn8e30k4nqTG579pRHDgIiKA
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0834fb46-7698-4fda-c5e9-08dcf7f9da62
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 09:12:46.2046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Z6mCmdPRCi+juhjWoqK+DzbLA3JmlVpcVE7iWXMGhwwQBYcwaEuvBNW3usQ8X7UneoweccxjxddFO7J3OSRxxmHc65b4bs0LPHGePYphqUY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7846

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K

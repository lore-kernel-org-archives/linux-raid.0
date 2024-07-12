Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575871DFD8
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 15:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720798903; cv=fail; b=QA/0RtVMF5KPz6DX1RSSz7G7Trb46lUfCfKpnk/uVlcU+XGL6S/uju00K1ieQxbBpOtABKkp2S1EzzsCUOB5jUqReCtTq5ozGiinMGjo/mbWohMPmE1mMCjjo6Lc52Ypd+XlAR2GFGfUnzyHk6esHDZRkPwZpZ/f6xSUUNCt9lo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720798903; c=relaxed/simple;
	bh=0q8lzId/sNLb48kL4aKqzBX8pzT0tN5XAm3TytoSWsU=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=M6G2URNNwyubgF05phgLnO8xRv/XvH8iwlmzRPcYxJWRWv+jYZNh/PpSML76KiGYagSBTnE6IpizPfuCxn2JPmTswlqgyIkR0MvfdSCRv1RDeKij8CYkwgNs4zAPfxMKqzDxBCGyXSID2sl1CTTvfD/i74dmHVRY0FVAEteTnus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=WrLwE6l9; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="WrLwE6l9"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 46CECTSp014209
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 08:41:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from
	:to:cc:subject:date:message-id:content-type:content-id
	:content-transfer-encoding:mime-version; s=s2048-2021-q4; bh=0q8
	lzId/sNLb48kL4aKqzBX8pzT0tN5XAm3TytoSWsU=; b=WrLwE6l9a1dFjhNyH87
	fDysKPI0rgSOPM1McjbRA8f+RRQeuRuSsZZ8uMcsmPMGw7Ju/bQaUo5MmGyQaQwn
	TkmiYue6WuuNXyu8Dg2IHJsvvGhoyuFEPd3HJ5nI0f/3czCanaFxgN2d9p+6gaNA
	03a6GmgGYFEsIwhiI6crWcE0Yc63BuJiHeGa8FLJPH0+H/I+DNNB1vfEFuB46Dvm
	6nWclaFX5XIJU2ZswG3JpwkYRngmwm9wpuf/82a7+6myZQG6ohK81LNjj27dCViz
	jkAKvLWP0a3d90wbaxNFRQ3HgNeWaPkrt9dpxdeO7gEY/labENSH8lvDivZOBh9B
	7uw==
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2041.outbound.protection.outlook.com [104.47.70.41])
	by m0089730.ppops.net (PPS) with ESMTPS id 40arf9v41m-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Fri, 12 Jul 2024 08:41:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5sKrbl+1R0i5T8a73SWiBkw/IXxhy5NbMK/BmhefGCgc2M0if0JlwH8vy9BJPN2XO7qYRE0toVo14uyJWJ2f0GyDsudVER2vaUS/ZQpwT+b12oUgSSEhc56G6ZywF1Ih+z0/e+kRN3aNF5eSQQgPbcVxlTYaSRwdsMeVe9R2azrvUVw38ds01wbKZ405F/ePvq4uKVLF5yGsG3dj5YOXWXsDrh39qnOUqD8hg7+UA+0KPjHVAdOOZi/6+ljn7rwXmLNFQdGVly22XIHkeOjwaRoh+aIshEQMz72D2tLCb0YQXHZ72H+e5J0MWxmixv+YBper3rd5EUp/hazP0uETg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0q8lzId/sNLb48kL4aKqzBX8pzT0tN5XAm3TytoSWsU=;
 b=BqmbOWiYwH27GTAEdnUsPinrRlQUm/GbUCnb6JcfR72S6iVoR7MbJm6Mdfu38C4IV2c+7a+w0GAWXe9tLUma/7MccxFj4G5MBbhQJnkmwWR319UsJy2MPYZC6Gk0ZpxOB8Uq7sV8qQeVmPggQ3VCVDWrYSVzvu8WCsd2RxhE1L36I4vPoeVh7ApBIidmIPpDfBrhRazShongj2FEfBIB4uJ9hNfVEbwozgKnnRXu+9TY3gIIEKRrMnqZ02eX/ZGVRMr8lt5O1NYQxBAEHyOQpN5kAIDaJzPKUa5tH8I1mUVYV9t+yX3Jrx4/kSpsvvgNYsutUKtaXTK4NbUv9HqRvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA1PR15MB5235.namprd15.prod.outlook.com (2603:10b6:806:22a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Fri, 12 Jul
 2024 15:41:36 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%6]) with mapi id 15.20.7762.020; Fri, 12 Jul 2024
 15:41:36 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>, linux-raid <linux-raid@vger.kernel.org>
CC: =?utf-8?B?TWF0ZXVzeiBKb8WEY3p5aw==?= <mat.jonczyk@o2.pl>,
        Heming Zhao
	<heming.zhao@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Yu Kuai
	<yukuai3@huawei.com>
Subject: [GIT PULL] md-6.11 20240712
Thread-Topic: [GIT PULL] md-6.11 20240712
Thread-Index: AQHa1HH6onPcO7Dl00+m/gZvc3RFWw==
Date: Fri, 12 Jul 2024 15:41:36 +0000
Message-ID: <7C787382-3238-4D49-92B1-ED09A4A59AD4@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.600.62)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA1PR15MB5235:EE_
x-ms-office365-filtering-correlation-id: ceb88812-5eb6-43f5-0fd0-08dca2891d41
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700018;
x-microsoft-antispam-message-info: 
 =?utf-8?B?MUJSdGFZS0hLMVhmOFFRSUthS3lmYVVFQjM0SkVQKzJEWG8zY2pTVWN3ci8v?=
 =?utf-8?B?UDZzZUtRNEZoL3JUSUJiTkh2ckgrUUovTWZjbmJHaE9BZGlua1ErVHcyUHEr?=
 =?utf-8?B?NG02TjZjdktSWHRaNnpqRWdmNk0zQjVCeEtMOE44RUZ5R1FzeHJ4R1lPL3hs?=
 =?utf-8?B?dUdsUnpRZ1ErVFB1V0s4a1FBZU0rUmdvdUhZTytXcGxLSzl4UU43YUd6Mjl0?=
 =?utf-8?B?djY1RVlBUVVDT3hZZitwSlhqVG1kQTVnc1VLdXRJWjJ4eFhlMEFJYm82dGJE?=
 =?utf-8?B?RDdvbHcyWmdjdHZqamsweXo1Yk4wRWdCN0krbkNheWNMa3BlblhFcklQZjJY?=
 =?utf-8?B?UTBWbGxvcEJCc2dka1gvYmZBS2dDMFdxYVcvck1iUUJzMk05QXozSTlaUFMx?=
 =?utf-8?B?eXZRL2NFTXJpZnh4YXNHZFJra3ZvcUJHRWVwOWhpRmprMGVQOGxZRTRMTjVS?=
 =?utf-8?B?Mjl5a096NmZyeWhCOHlXajh2VGxaNGh6Qmdab05FU0VrVFJsQVBiTjRzT2p2?=
 =?utf-8?B?RThzblNqSFo3MVBhVVpod0V0RHhFTm1ndUtaWmtqRHFHUDdmZWZmY28zNVFG?=
 =?utf-8?B?Nit5eHJJTVdmMy9EVVBPMjdYeGU5TElpM2Q0OXNwaFp1eUdSRzJ1ak02OGpV?=
 =?utf-8?B?bTdwU0RTUFpoaUkrK2ZScUg2ZmRnL2p4NXlTVk9EcFhoQU8yNStuY2d1Y3p4?=
 =?utf-8?B?aWhBZ1Bxd3RxUXRON1VYSE44Mi9SMFhPUXNLVzdaQ1M3ZW51elFieTFESUV3?=
 =?utf-8?B?U0x4bUZ3SDJWZFB2WmFIT01VSHljM3VmWE5QTzRSOFNmWHN6R0FyWS9UbWdV?=
 =?utf-8?B?blpkb1ZuOXoxaDM0YW1JL2NZbmszeGs3UG94MHorVlVyR2pZbXBJV0FxWDJW?=
 =?utf-8?B?RjVwNXVueUlKNjNXL3ZoUmIrYU0wVHcrVjhSVGJTTkVhRzk2Y1UwbUh5VC9J?=
 =?utf-8?B?MjhLRmZhc0Z0ZFBVSlNsdFdrWktobkRNdjBxRDR0UFU1RTBwOVY0eWQyWG1W?=
 =?utf-8?B?YUIzTGR4dnIrd20vNW9qczhPZTN6WlpVUFBvTTJ3T2t1Q0JtTVZWUm82OXFQ?=
 =?utf-8?B?K3lQT1liem5LTUVvdWh5eXJKWTcrRTgzZFQ5elJDTDA0cFlZbkdKcEdQQ25m?=
 =?utf-8?B?eGN2Z0srcU5Ra0U5aXRwSys1R3FyUE5rbWliL0FIYkdpaFhoZE5ueU1EL3ow?=
 =?utf-8?B?TW9IdktEeUJEOUtzeWt3cWpOQ2tzWTFkRWZmeVdWWkhvYlJkczEyVzY2V3Zo?=
 =?utf-8?B?eVR1dTBqcTdBUHZnT1ZLQzBSY2U5NGNVSndLU2U2L0ZxancwUWhXYVVCQk8w?=
 =?utf-8?B?bHFwSEI4SnViUjc0T1d2cmR3S00zOFh2YnZiZW45L0ExeUlRRVpROTFZbWJ1?=
 =?utf-8?B?bjJUUGkyckVuV2RJL1B4SnU5WEh5bUlmZTdoazRFcWIzUlRqZ1ZadFJxQkVT?=
 =?utf-8?B?N2VITzl3TjQreUJyUlM3Um5ZamlqdWNrcGdNYnV3R1lhMUVlQXZiUnBoUHBa?=
 =?utf-8?B?Y1hRUHQwS24vS0Zzem0rNXN1NjRrS2xTRmlCdlJKbmYzWUZ0c2FFamRhS2dr?=
 =?utf-8?B?RGJ0Z2UydndQcXZLeVVLUWx0cUNKWjdwdDFjdHBMQjFOcmIrMnhKL1BQRXI5?=
 =?utf-8?B?MmZzVVZsL0JROUVXR2NpNytJcHFXdFJNL0VoZC8vTFI0UWVMbjdFNkdIU0Yw?=
 =?utf-8?B?V1Jjcm96eUp0elB4a3Q4cjkrN2p1VnhOY0F5RVZ3UHh6cExKMUxSNTZQZlQ4?=
 =?utf-8?B?eTIweUFhU0lPZ1lEbHdtQkkreGkrRjloY2FBYTE0K0RUSkJVUjFuUHJvSUVJ?=
 =?utf-8?B?ekFjd2tkakR3L1JOZ1FKdWlkdWFvNW1UUGhWR2RsWFFRUytuUDA5bU5oQ0lm?=
 =?utf-8?B?WndJdFFuYjZ2R1lHaExHRjlBTUxnaTBkZG9RNzdIN0ZJaGc9PQ==?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?OFdEbFVaUXRDemNoY2J1MnFzdEF2cURzbFlwcnZzeWkrRDJSaTVnVmhLZWFU?=
 =?utf-8?B?dExDUmVUL3VyTmlabVA2SlRBcE9JQnBNalBFOTN2QzFLOWpVSnhmbkw2OWtq?=
 =?utf-8?B?YnZCSVRzV1JvVUNrbjJVQnpkMEl5RWhTZnZvS3haU1YyWnB3cjQ2c2VHNUkv?=
 =?utf-8?B?endFRTBOR3QrSVNVcVI3RFRMWk8vQ2tWQ3lVaExabnc1RC9MMDZJcDU5a040?=
 =?utf-8?B?MUdvVEEwQlVHakZXS1B2M3lYNzg3SlVkOE8rWFBncTVDVG5oWFJGTW5ETXAy?=
 =?utf-8?B?UUpaY1ViMlNzcG94bjEvRzJQYmpycUFJOUZVK21DRHg0Y0dpbGpXc0VpYTZX?=
 =?utf-8?B?bVhMc0lxQ1lPdzNDbFNQajhDTWZzSzhLMTN6eUNSNitTdU5naDg0dWk2Z1cv?=
 =?utf-8?B?cmRhV014TU9JbDVZMGpQaUVDYjZjMWtvMmo4MkZvVURlekd6TjdjOWdVK09s?=
 =?utf-8?B?TFB6bnloVVNaeDJYT3c4cnNRSnBCa0VsYmpkTXlGbGhpOFQ1OGphR3AxL3VM?=
 =?utf-8?B?YXNoaDlWNE03THBkMGw1TEQvVjNINlpybjB0UUc2K3BFK2t4U1JyRTl0bDM2?=
 =?utf-8?B?eTVHNWpmNk1LazA4QjFmeVdSQnpjb1d5TjVDS0J5N09iQzNaZnFWMko5a0JM?=
 =?utf-8?B?UHY3SFNPYVlaczgzaWtrdkcrWXNySUtnTHBYcjhRYmdwcWZLZlVvWFdVYWpR?=
 =?utf-8?B?d1kvd05WMEpTeVN5clp5OFk3T0tJb21xSFdmTzJidjZwQ21NYnNMMU5SQ0tq?=
 =?utf-8?B?aHpZRkM2cGZtOGtjbGZhU1ZmQTR2YnNXakNRWHhDenhnU0hXOTRwdFh4alZB?=
 =?utf-8?B?Slg4dXdpZWJOL09uVWtGZEVDcTRDRWttSWVqL0pDTjRrK3Vla3VrTXNoNFIz?=
 =?utf-8?B?RDdsNmd5bXpnR0JBVldXU0ZUeWNsZUI4S0NIMWZCUTE0WDdPOG02OTVGQ0ZE?=
 =?utf-8?B?Y242N2lHMUZKVGxxRk1vanoxZ1pMNUFVWXZzb1pnSWMwZWlKUDhKK3N0aEQx?=
 =?utf-8?B?WEVFNnIvQmZ0VmgvUHlGWVZoeVdjKzlHUDd6K3JUaElrWlBvM0JlcDVMUUM0?=
 =?utf-8?B?UGNDSndJK05OZXZ3Wi9BeGJZNzk3elpvaXdqUXllY2s5UUx4ekVOZk0zS0gr?=
 =?utf-8?B?R3pUK3FCaENNcnRRa0dpVEVUZVFSRnJKeVZQa2tBSTJ6WTh5YWcrWm5iZk9X?=
 =?utf-8?B?djJXYklDNHIxRS9uT3NIaTRWZE9UYXpNUVRsZEMrU2UxOUVWVzJRMG9YVjNK?=
 =?utf-8?B?VysrSE5LaC9OcmtML042RWZkN1dvWnk2MnJjdVRhMzJwcUNacU5HTWw2RWlV?=
 =?utf-8?B?Y2pqR2cydFAzNTBVdzRQcm9SbmtyR083MnZmck5ublFrNk9HNDIzaXpSWS9M?=
 =?utf-8?B?YU1yMmYyZ3Y5NU4rckk1WGIvaW1tdE5LMTFYamx4Nm5LQmVZRVJ3OGNIb3JD?=
 =?utf-8?B?WDdJNlhtK09JTTVrZHpJL203OTlBVTNFblVHczU2UDk0b28vMDZJM1RoNW5E?=
 =?utf-8?B?SGp6b3I1VThEM0NWRHMrWEd0L0p0N1RGdXJhU3pTYlZjWW5ZbG5qYVJZQkpD?=
 =?utf-8?B?SElTbVNaSUx6TUtxNjdxMkhLc2dFOVFGNzZSZ2pBazB1UisxRE8rbDRkWWVO?=
 =?utf-8?B?ZjJ1SWxWMnNoNXoxUnpUSlZBViszOWliK3VIckZBYWYvUFQ2cDBwd2ZGVGtJ?=
 =?utf-8?B?UXNpUlFQMks0azZTSEd4MlcwemZNM0I5L2Y1a2RBaEI0YWxnVmpLdHZGMlc2?=
 =?utf-8?B?SlU1YlJoY3pDUFB0TVR3SmNyUjdzNGpmM0tRbEEvdjlFckZHQWR6SGdsWmU5?=
 =?utf-8?B?bkJ4bmNVQ2U3TkYwUWpvRFVKTlZYakxaRnNQU1U4OW9kVFJ3ZG1BdDdrMTRz?=
 =?utf-8?B?aXh6RVVuV0RTUzNMYnBhZU9VRmRTTGpRMzRWcGFmUHRFNndiNjY2b2MyYWVu?=
 =?utf-8?B?eGgvOUlMNitveXlOcGhENWNJOUh0blJsOXUzRThsNG9sdTlGd1FRM3k1Z1Fq?=
 =?utf-8?B?OFNaa2JKaGwrbWRCSStkc1dVY2dSaU1PNmN5QXdHanNnVTdsSm9ManpGTDk0?=
 =?utf-8?B?ZTlmVVdJM000ZCtsNGZOaTRzUUVkdDVSMFJYRWFRbGwrZW1WNmNZWVZlaWZy?=
 =?utf-8?B?Y1BLRThUU2xCUllKZ3IyUUNXOWovS0VuemZtNEVVNlpHRWV3UnNGSTkxMVAw?=
 =?utf-8?B?VWRTSWR2SFNTRXRhdjdvSzlXcGpGYm1PY1BBZ2NveDNFQUJId3MzT2o3MElV?=
 =?utf-8?B?ZzV1bVlNbUV4b2xtY0plZXlEOStnPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B8B24CA9FA02240A600BF8970C74C90@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceb88812-5eb6-43f5-0fd0-08dca2891d41
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jul 2024 15:41:36.4770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yVholM+xCrhRQkcjPqhuVcqQVlBN+lJa4Nxo+knyRFpDiRh7s39e/N5E7tKUFwKZYP98Z3oTJfni1+2njVLkDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB5235
X-Proofpoint-ORIG-GUID: Bt__C7SNyNG3zsMo2-2s217xSWNzYV0p
X-Proofpoint-GUID: Bt__C7SNyNG3zsMo2-2s217xSWNzYV0p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-12_11,2024-07-11_01,2024-05-17_01

SGkgSmVucywgDQoNClBsZWFzZSBjb25zaWRlciBwdWxsaW5nIHRoZSBmb2xsb3dpbmcgZml4ZXMg
Zm9yIG1kLTYuMTEgb24gdG9wIG9mIHlvdXINCmZvci02LjExL2Jsb2NrIGJyYW5jaC4gQ2hhbmdl
cyBpbiB0aGlzIHNldCBhcmU6IA0KDQoxLiBtZC1jbHVzdGVyIGZpeGVzIGJ5IEhlbWluZyBaaGFv
Ow0KMi4gcmFpZDEgZml4IGJ5IE1hdGV1c3ogSm/FhGN6eWsuDQoNClRoYW5rcywNClNvbmcNCg0K
DQoNClRoZSBmb2xsb3dpbmcgY2hhbmdlcyBzaW5jZSBjb21taXQgM2MxNzQzYTY4NWIxOWJjMTdj
ZjY1YWY0YTJlYjE0OWZkM2IxNWM1MDoNCg0KICBmbG9wcHk6IGFkZCBtaXNzaW5nIE1PRFVMRV9E
RVNDUklQVElPTigpIG1hY3JvICgyMDI0LTA3LTEwIDAwOjIyOjAzIC0wNjAwKQ0KDQphcmUgYXZh
aWxhYmxlIGluIHRoZSBHaXQgcmVwb3NpdG9yeSBhdDoNCg0KICBnaXQ6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvc29uZy9tZC5naXQgdGFncy9tZC02LjExLTIwMjQw
NzEyDQoNCmZvciB5b3UgdG8gZmV0Y2ggY2hhbmdlcyB1cCB0byAzNmE1YzAzZjIzMjcxOWViNGUy
ZDkyNWY0ZDU4NGUwOWNmYWYzNzJjOg0KDQogIG1kL3JhaWQxOiBzZXQgbWF4X3NlY3RvcnMgZHVy
aW5nIGVhcmx5IHJldHVybiBmcm9tIGNob29zZV9zbG93X3JkZXYoKSAoMjAyNC0wNy0xMiAwMToz
MDozOCArMDAwMCkNCg0KLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KSGVtaW5nIFpoYW8gKDIpOg0KICAgICAgbWQtY2x1c3Rl
cjogZml4IGhhbmdpbmcgaXNzdWUgd2hpbGUgYSBuZXcgZGlzayBhZGRpbmcNCiAgICAgIG1kLWNs
dXN0ZXI6IGZpeCBubyByZWNvdmVyeSBqb2Igd2hlbiBhZGRpbmcvcmUtYWRkaW5nIGEgZGlzaw0K
DQpNYXRldXN6IEpvxYRjenlrICgxKToNCiAgICAgIG1kL3JhaWQxOiBzZXQgbWF4X3NlY3RvcnMg
ZHVyaW5nIGVhcmx5IHJldHVybiBmcm9tIGNob29zZV9zbG93X3JkZXYoKQ0KDQogZHJpdmVycy9t
ZC9tZC1jbHVzdGVyLmMgfCA0OSArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KystLS0tLS0tLS0tDQogZHJpdmVycy9tZC9tZC1jbHVzdGVyLmggfCAgMiArKw0KIGRyaXZlcnMv
bWQvbWQuYyAgICAgICAgIHwgMTcgKysrKysrKysrKysrKystLS0NCiBkcml2ZXJzL21kL3JhaWQx
LmMgICAgICB8ICAxICsNCiA0IGZpbGVzIGNoYW5nZWQsIDU2IGluc2VydGlvbnMoKyksIDEzIGRl
bGV0aW9ucygtKQ0KDQo=

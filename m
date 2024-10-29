Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FB620408E;
	Tue, 29 Oct 2024 09:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.153.144
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730193208; cv=fail; b=K6zt4qdlkPXLeE6R8qMB1OHV79/tUtEFhNyQCSUd94a7kZLoEMZkWYdxI42uTTTAs1C9Su6zdCfHTHaTzl4XuuBtPRlmXzluKditJu3RvTcIvxUx36hoS5FClm1dHfZEF5HZXtIvo0Po/lxJ17nxe+A2FN1ySMYXMI9w5n8l/Js=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730193208; c=relaxed/simple;
	bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TZsgPfHrf7JezbH/eFIKVWRo72ywlcmxim45CRro3lBk8T7HvafaBiKMDSsHV/nxsPcLfm+Z8lNlmAgpMke/8S08DAN6IvR7GKjA+jPvf3rHOZr9jHjE3k2FwLVw0ibkN1BJLc2Vg0GeZcpeCOMcCh1l7a2rSrxYQ9tIESWffOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=YXMsbCcB; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=KGr2JKkC; arc=fail smtp.client-ip=216.71.153.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="YXMsbCcB";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="KGr2JKkC"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1730193206; x=1761729206;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
  b=YXMsbCcBjuTWstNNedONX7juqi8Z5OtdgSUazhtbRmPwILmgtjpXWeno
   MLIt563XHYblyv5rB/VjNrwRSVY2f8kAPRuGH3+5+XKxjmtRM57WQ8yUM
   t7fWJhMzxMmTSw5nacosOvq/ixzSRvaWuWk1sIFAImU502EuKFwKez27d
   D+tw2v/Id3NAry/Hiw+HPXmZsBhqfKckMDkCiFIFNlvRCAghtGtbyqTSO
   3bTSrBXnrlC8whIXu4CpN9ngD5AAC4MIeXGTpkO7hIxePo6/HY0KhjGiP
   aIgj5FAKkCDyoZCHAZqKAcp0bEnX79WTb2POgd0ZdpsgdnMeusF9N8QP4
   w==;
X-CSE-ConnectionGUID: gypU3IQETSqNIcrdEhnudw==
X-CSE-MsgGUID: LBzKBm+ETb66cHxZSe9g2w==
X-IronPort-AV: E=Sophos;i="6.11,241,1725292800"; 
   d="scan'208";a="31226535"
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.174])
  by ob1.hgst.iphmx.com with ESMTP; 29 Oct 2024 17:13:19 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UO2poZ/xHRDQSKUPlxUXY26RZdP4dL4FmBR9ZESZcfR8SasOp7LLSLn6l8O2DB72z2C8C0DHshzdPvj+2CT6JEEGm1C+7jy5+vCqcRpBoHuLaJF6J2z/Yd4vQxJ69+aNFUgxpgrEoN5vlslPcyiePN2igWVrCB2xoq2FktqZ7ZOqlzSzc0Gt629C0vgXnBN+uraj5YbYEAGFK0NSjdARO7bDmM+yEyeEczd2QY7/SmeIIEOZCZWYhXr00kPaBNJhFfwNj9WYiulaxEEXtQFgN6tMF0TD6jUKdneQj7wFwqXMCGiJE2Mg/cQENxxL9Kn6TbhVroVzUD8OHEUvC+50pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=BRixqhfyOE1eSOePqce7afvUHclwbBYTZn9j1pvwkuSBVqdLDB6cSkSoCfnx4GfAUYnf2TI1eueZy34QOfkSwhNkMN619JOkQoMN7rHDaOB2rg8jbfRjDxLW8eKvMzQPjpXqOqfmyWTtnNrilyp1X9G7GpcTJGBUbtmeo9Gv0LXYi6Njg2irowg+tzmy0Qi4ds1tuzG/ml8lNp8AFxVfEkV7kSGM/te7DOKMrMhAYfn4ku5f8em03QUOR9gNKsz54iKFXSnP1cT/dn3S0ggiMLKjhDc2hRYKaYBkamUaN5Q/2C7RJG5ELxfcwQPVmcvEXfWisvmLMCsgbvNNbWjzFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joufdrNO2/FLdgGzlnaieoHfZ28FYCwNXGhrZ08f24E=;
 b=KGr2JKkCOdsgAwqr1+N+BTvBS3Q8bLD5m9bEmeGA4zGUXE1DVVl2MOekFjidEPQTeDxI2cU2JXcAiZcx/ZBkWJ8cC9Wlty/HduO2ztGLGtBm4S6kNPA+fqPc2XvKEKXkuRnZRQ6vmzw5R5SGKZVXbDj3SyxNNK0A1OGsdNpBxbc=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by DM8PR04MB7846.namprd04.prod.outlook.com (2603:10b6:8:39::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.25; Tue, 29 Oct
 2024 09:13:17 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%4]) with mapi id 15.20.8093.027; Tue, 29 Oct 2024
 09:13:17 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: John Garry <john.g.garry@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	"song@kernel.org" <song@kernel.org>, "yukuai3@huawei.com"
	<yukuai3@huawei.com>, hch <hch@lst.de>
CC: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "hare@suse.de"
	<hare@suse.de>
Subject: Re: [PATCH v2 4/7] block: Handle bio_split() errors in
 bio_submit_split()
Thread-Topic: [PATCH v2 4/7] block: Handle bio_split() errors in
 bio_submit_split()
Thread-Index: AQHbKU4lu0Vl7EyJJUCAEUXKD9SicbKdcviA
Date: Tue, 29 Oct 2024 09:13:17 +0000
Message-ID: <cf951c05-59ff-4746-a860-d0f55948038f@wdc.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-5-john.g.garry@oracle.com>
In-Reply-To: <20241028152730.3377030-5-john.g.garry@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|DM8PR04MB7846:EE_
x-ms-office365-filtering-correlation-id: e1a23f3b-5bcf-44a2-3747-08dcf7f9ed2e
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?RnFrZzhJbVMyMHNBeGFtZEJJNzloNUhOdzBrMm5ybC9IRXgxbXNEVmtaM01a?=
 =?utf-8?B?clQ4YjlmT1JVSFdTMEIvU1hGcHpiNytGM3pYSkYzYXdFNERjNXA4cFozY1Bh?=
 =?utf-8?B?c2E4UnZKVkErdG9ZU09TR1ByMDRiV01iTlovbUVQZjRXQzFlWXY2YW1aQkxs?=
 =?utf-8?B?MlpmcnhlaklvdklQY1duVVZQYjV3WE0vUFVSQjQrRHdmT0JQVGZoczV4eGl2?=
 =?utf-8?B?dkZZZm9DWEVoU2RFRmJJZ1BPODBpbVZlVmhkYkp5NWVaTDE0UjdtWHJvdkpj?=
 =?utf-8?B?aTNNWW5qN2lZLzFQblJsQVhPQ1hmK2pacEJSTGI0ckgrT2xPdEhjOTUvZ2s2?=
 =?utf-8?B?b0ozZTVpM0I5YWhWM0g5N1hOaUpaQWVEVnRUbDN3aXgrMzJWRldmS0IxZkNw?=
 =?utf-8?B?L0d1V3VGVENlTC9uZFJLT1UvYWl3UkRxRXFyR200TTIzNnpGR3d6UUZzVWVY?=
 =?utf-8?B?T2w3bUlHUStuVmxFMmN2bEQ2T1hCL2JHd3F3RlBiZVBDQ0FYcXdWWW5TbXV1?=
 =?utf-8?B?TFB6QStDRzM2bElNZ3c2WHdwdG1iVTVQNVAxNlFlc2F3UFQ5WkVpcXZnUXRF?=
 =?utf-8?B?QnhaUHMxNVVyRkJweFFGcjFUQndFc3FKWDNYN0M5ZjYrNG1TVUxQM0MxNDFP?=
 =?utf-8?B?VWhLVy9wVVRlQkloenRJS01VNW9jUGZES04vem9RTVY5ODExTnVqVFVjZWp4?=
 =?utf-8?B?dC83Q0pnc0orUmxrTnZ6eUdvUXVwUTIzN3lGZENVcTJkaFFVOFZ3eGRpSkdB?=
 =?utf-8?B?WkdPbXhMUENiYjFwS2Nnb0lOSElOc2p2dTB3bDM2VG4wY2lCcmFZbTAwajZ5?=
 =?utf-8?B?RU44b1lDZ2MzSEZ5U0VwSUNOdU5XRGN4WDVITWUrM1lTVTh3RTN5QzZuYkJh?=
 =?utf-8?B?R05LeHFac3dSSUNMUEkzUkhPbWx4TUJ0UEMwYllyT25uYm5kWURwL2taUlMy?=
 =?utf-8?B?V1pDU2t1dXozZDFLaUNWYUJSdXpxYld0SHZ6NXlQQ0YwdnMxcjg3OWtwZSt3?=
 =?utf-8?B?OW9HbXk3ZEMwY3c0bHVQT3J2MnlVTTdkS2hEb1VYL2ZxZFZuUXIzQUQ3cUVt?=
 =?utf-8?B?dWVMQ281ZmkvTHhHcDBpeDRIUEkxZGdIMFVpMWZFMXdGR09ib2ViZ1Y4bEVv?=
 =?utf-8?B?N2RZU2VCRkRXdmxSWG81NDZYd0VUZWtQN0pSY1poQ1ZNajRuV0F5YTJRd2U0?=
 =?utf-8?B?UnBrQTc1OXNnNFpnYnk1MEhyLzFmMnlUR3JHUGJSZGtwaHJ6dy8xdzdLU3Y1?=
 =?utf-8?B?M2NJYUNCTDlLV2wzRXVHdTVpb0hFMlV0RHpKSmk1NXUvdml3OGtJekVoVmUy?=
 =?utf-8?B?WVlzdHRvS3YvWGxOQUlCYXVGTGdKY0NjNHZkekVXNjdKUC9WM0U4RDV1cDhD?=
 =?utf-8?B?SG4xQVdCOFNOUFcxU3NDbllWbHhCaTRYUjJkWFloN1RmZjE2bkl4SzBVR1kz?=
 =?utf-8?B?d09TeVhzNEs1OWdJMUp2eU4wMUozSVpWMkU2ODRlUU1XVHRnaTZlTytGTUIy?=
 =?utf-8?B?YlpDVlVXNUR4bWp4cXpidVFmRE43WkNZS0k3dDhTZjRCZE1BMkhCRERzMVlq?=
 =?utf-8?B?UzdmY2Y0TVVVNTNwZEVyS3FmM29VdG9oSGVZUjd3M3M1cmJ0Um1CR1hDSmNL?=
 =?utf-8?B?VXRmMDdJK3VHUXRlUHVJY29WZmwwbGZhUiszY2VwNTV5R2ttWlhOaHlONGNG?=
 =?utf-8?B?amhVTDhVUUxBVm52Nk5rM0dwWFlyanNONnhnZHVKM01mb0ozZjNJa2xFMVg3?=
 =?utf-8?B?ZnhaYjdzajNzM1FNcTY0WFBoeGVnRjBzVXhob1Nid3FGOWJMVmdyY2RQcS9W?=
 =?utf-8?Q?wPgZpi/LQdpMPvLBGEy/k0axBgeq0/sk1R32U=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eDFjdDFzZ2lKUktSVDd1U3lJenp4RDFOWUR0WmVVbDFtRFUvUGdGcUlqWHJ3?=
 =?utf-8?B?YklnejZUeHIvbHN1aUphTE1yVlFpTW1PYzVyMnNvSm4yTUdtWmF2ejdJRUNk?=
 =?utf-8?B?Nm91eWpsS29jVVk3Qm5CTjdmZzA2OVlkcCs3dk91NkFBWWg5S3lFbTVtK01m?=
 =?utf-8?B?V3d5NVFsQ2RQNmt2Qlh1TkhRcWdqd0FiNUtMb3BKaGtCd3dzMUVjakg5WkQ5?=
 =?utf-8?B?eC80Y3p3VDIxaUQyNnVWNlVocE52SXJ6U0lmdzdncHRVd09CQUI2eGg3eEpO?=
 =?utf-8?B?SWlzREx3aTJuanY0OTZST2ZnWVBpclNzaFA2SUF6M3ZaY0lOQ2JGY3FDcEFL?=
 =?utf-8?B?OHlCampwNldrU0lxNlZKN0pzWHhaTitjVm1DUXV4amVwZnEwd0h5cGUvU2c2?=
 =?utf-8?B?N21iUE9aRXdlQTRqcVJtaWxJRFZ6c2FkZzVqYzFyODFXenA0SUNuemhTSTNZ?=
 =?utf-8?B?N0pYUFJDOXZFN1paNnIwcTZyVmthenFyb3ZKbm1Pb0FsUFI4T0l5RkYrQ3Vl?=
 =?utf-8?B?ZDN0VVJKSURleTR5Z3JGSFRyOUlhS3JhaHdDMnNBbEZ4K21NeTVrdjRmSzBZ?=
 =?utf-8?B?c1hRTTNUV1p4SDhYeDlIeWVhbjJvRnVmV2dZQjJqRFRFOEdkOFN3YUc4L291?=
 =?utf-8?B?SUdWNlNtL2kyanNQOFhPV2dtNllBLzJWZFlDVHVYRVFvR3VnalRwUWdrYlFa?=
 =?utf-8?B?NXVZQnFkTHlXRXE4d1lqRzg3dHZPUTJPK0gvM0hjL01BUVBNU2F2aG15M3BZ?=
 =?utf-8?B?bWJQdTE1blM3V2ZuaHRqMndCRVJRZzRBRFVTTXAyMTBMZEdQelhiVTFGYVhH?=
 =?utf-8?B?OW00RGtmK0x6T2JuZTZWclduNXJLL1E0a3NsZFpIYkxsWTZEQTNncDVBUEZs?=
 =?utf-8?B?Tks1VFVSNTJVeFhSQzUvOXBLWEJHL2VNalQ4SmI0U2dDR2QzcFZhVFNlWko3?=
 =?utf-8?B?QXEyV0ptVVJua01JclBOSVJCYWltM21pTzhyUThqQmFjQVMySmdXdmhscnBs?=
 =?utf-8?B?OE9Ob0VWbEM1VEl0UHZrSzdnTDMwWmVnK2dsWE56emxZWUVVZnEzNyt1UHRB?=
 =?utf-8?B?UWJ5b3dkMVhjV3MrSkxEUTlqQ0tpWEh5Y0R0clhoY2s2U1VpTEJqcnhWcG1U?=
 =?utf-8?B?TGczVlVpbEJPbDg3clZlSGE1UGpielBabk15NXZxUGtHU2g0U1JkWG1uMUQ1?=
 =?utf-8?B?ZmNXU3l6bVVOckZEajhBVVI4QkZ2SUJlS2FjTTQzbGw4Z0p5cXRUbHM5Tits?=
 =?utf-8?B?TGZXMjNWY1J6dDZhV1hBL3l2eHExbXJYcjRtbkVlWk5tZjVGNTdyN3dyaExz?=
 =?utf-8?B?UEg4YkJYL1p6SFFFcWxpd3BCNFZkVk1qWm05aXJKeksweGlacCtJWldTZURX?=
 =?utf-8?B?Y0xvUVZmcUFOUkNISDl2MldaL0pJZHIzS3hBZDFrNW05dzJlZm10Si95Qy9W?=
 =?utf-8?B?bng2c09DYVBneE1NSXJER1A0NC9BUDdJYk0xeElmeGg3RVZnM0J4WDFkcTVY?=
 =?utf-8?B?MkUrUUFiS1Uvakp1U3pmTUlBb2Zpb2tTUHl0K01mQjB5ditFQTkzekk5VEtF?=
 =?utf-8?B?VVQwN1d3c09vRnZobkErN1RHWG1KaU1YMHdCZWJpVGR3SU5CU1FIdnJ5TGEr?=
 =?utf-8?B?akJyTXhvbDlKVkllR1V6cUg0K3VBVEpXam5sc3ZlWlpFdmFOTk9TNGp0WVd1?=
 =?utf-8?B?RytJUU1JTlFCb1ZaWUlFVk1VMHFaUVZqOUxQSUFOZ3k2akowdUZqZUM3Q0lk?=
 =?utf-8?B?bjFZdzkxTnNXNmRlK3YxL0R5c2dFQVFPYklKbUdVYk9tTU01VTFyeVlpbnc4?=
 =?utf-8?B?OGM3bFlFZVJ4VkJuNEhmZnN6eWQzWmJQeWJnQXUyQzFuY3ZRS0JPbFZmZ2Rn?=
 =?utf-8?B?V0J0d083RDN4di9uZlJ5bStYSjhaWXR5UFA2Y1k4V1FVSWI4RmdxWllXWnBK?=
 =?utf-8?B?QTRRV3BKV3NoQkUyak1RWU5JNWFBVGRMSjhDbmVzVS9pYWlGQVZtRnpSWFhC?=
 =?utf-8?B?Y1Bsb2hQeURwYUlGVFVSYjZIRDBIQWt1VldUN0gyOFh4ek9KTDJNYWhHRmF5?=
 =?utf-8?B?ZlBjU2UxSTFBbXNjc1o1ZWM0YUpYd2pOTEg2L3IvWmVzR21rejBQUys3dHlj?=
 =?utf-8?B?Vlpna0krUUIzcWdWQVdzVkVxd2ExZUdMVGJRak80bC9mb3hWZTFvL3Eydmgw?=
 =?utf-8?B?ZFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A904C70B85F0934B8FBC57CC287FF33B@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gQ9M+mfSKG9Tw+DHFc/dKJ/stageW9WgYRQKa1wllGPh5Hx9Or4HBMlxXRBGkItNKAykvALSW9n+1CZPHSDYbG2lgOwxfHAtczjPdC2cxNWcZUe+buVk5369OzBHJbjJ59PBey1xGpaZekzmeO5sVOXw9kuRC7TdWvi553zEvwYEtuLSgv07CGrB9mCOPQtm5rC7NeA+ITe7vYcBUofKER+uSyUm2zQQjtFwiImVVhIuSl3QcWLGDX9YP79+V7c+0QxvS+2hn1bTL96Oo7ysrlkNzmYGLpri1bU2prXh4KMMVZQeLx/CdFi6UPYNbo8dTuVzpP+4DGsmm7oqnogIeoYwX6U1eKuu7dIGF05Hq25Tll0vjsqeYUbCzoOmqeLB5OGpo/NExtyzI691dnTRtAs88rgTrGdMeQaYsKs5ms5Pcvq7G3ZgW5EMEa2W5ZHq5zEqFkEjUITpiVi32gFiTiYQulAtkp/fouGPayJBkY0rVkVbkVtspsJazukLeqWfNM9BhCZhS0rg+Qg8nd+22ATNYyrpcp3ueAxqfpU/ls4dFFn1qRwE2PXW2otzA722KHNSw44vBU2uj5cszNka5lx3wCjy6xp4L/OEXjKGWVQl91ynsqSRkVbIexOO+bR6
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1a23f3b-5bcf-44a2-3747-08dcf7f9ed2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2024 09:13:17.7378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DQYWIPzWhf2mqxjiHVRBmKjrifYxv4fxoS8/OLaKa+Xp43gdsHp4awWyEK5iWJOp35JyIkoPgiP6QtS1vbpi2CtokCCTSMiDBqqI1XVl8MU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR04MB7846

TG9va3MgZ29vZCwNClJldmlld2VkLWJ5OiBKb2hhbm5lcyBUaHVtc2hpcm4gPGpvaGFubmVzLnRo
dW1zaGlybkB3ZGMuY29tPg0K

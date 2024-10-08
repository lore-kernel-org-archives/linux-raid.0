Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E511E1D3588;
	Tue,  8 Oct 2024 07:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728373096; cv=fail; b=SyiPV+wYUS0E8zsSKmomBLxV3PDBTfVp93nCpqGp/ThM2QwruX2mDATQhDbBJ5pgKEyrdGcxLn5rRmi5jhMCqg+UUp/n/WJodBQhjmjkZgt15pqzHi/h+higaRmD68lGrGyokvRJmDraiR+vMf7IrCY5gtShSOL1cDSA8lI17s4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728373096; c=relaxed/simple;
	bh=g9vxNBAaF0zz7HKtp+xKa7FmQXsdHYZWlV+yZnWIp8Q=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V6mQP9IwAIsipIGsDeUEVJzFNqJvF3WoKjnfl+CGskGhqT/vO58NlS0ifz3ikrUrSBGtU5YhtUKNY3eC3NzdYaeCmsEpQTR+ohrbmgrarcxSgB2jySH6Nqaib7gup/c44M6amVY6IT7gbVQ7aISASO7msIxB9IZd5jFwZhJkbeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ORV3Exdz; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ORV3Exdz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728373094; x=1759909094;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=g9vxNBAaF0zz7HKtp+xKa7FmQXsdHYZWlV+yZnWIp8Q=;
  b=ORV3ExdzO2N3NBfEkpUefg2/rjfX/MQy3DBOg6DJ/98kp9mhGjnCUBJW
   KOOViBItRBU/7hdgbq1eIyl5mkW5J0LlPdcHjoIirqNuVNZDMmhAxdskh
   zwIWBFhimySinnuxqCHXqxVL+qc5Q+YThSXu3ZA4wQBIsje+rHPchjIds
   wQe+xaX/RVYlUUpLI17cAPmO88tmCIzxT+i/QRNkhvIcig2dg7oUayibj
   ryzuuOQyRhsccvoLmrJuNS2DdKXCsKBsKBGMYaI1xqfLuoH5RHdhTEU7a
   qS8BoxHjyIPpTOg8LhpqNtw0QEnoqhozLuFm1zUuChvgP0QwPYw28Veh/
   Q==;
X-CSE-ConnectionGUID: TJhvtoZmS16XPKpDIDbDEw==
X-CSE-MsgGUID: tNa/l65GQwu4YvuYAYz1Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="38148833"
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="38148833"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2024 00:38:13 -0700
X-CSE-ConnectionGUID: AbaQP1KXQ+y7cj5LWeqZXw==
X-CSE-MsgGUID: sX/jMGpPS6WamsYfrQBDHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,186,1725346800"; 
   d="scan'208";a="113201324"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Oct 2024 00:38:13 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 8 Oct 2024 00:38:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 8 Oct 2024 00:38:12 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 8 Oct 2024 00:38:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.175)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 8 Oct 2024 00:38:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=P4JDxmGN6aOZ1kv4DlBsrJRDv0yl9NWk6L98ILkIGh4za1gO+7iGBHb3BKgNxoQPgZ3CFhWzntkU5kxcjAuEIvn4XhQlco8lYZ08gBkkxr6PdiCJAOKrFoZ1KjppnAWHIUlUuADKurWD4WKqSz2O7AsU0d5UYiYMUr53W/QJCQQWB0B1U6DJziEsQu3uM6WhNcTw22LE8n99LQ8LXpzSORlrN/wvHEzcrcsLy0zLS8Dxg8jbmuq7Mo52GnTbA23Xt9wEPGjagqgy24ZotWyPhMxQ1fzXB3EUdzkUnmo1ASaD2fYDmGHOubRl6oo63jslGPo/k6m62nkzUET5HhmPXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FDUDVWccKqvUYjwSMKCCRAlDCdVEOwl4y/0SYt1J8wU=;
 b=LKhW90Why9mDaqVetqpW10rOL1BEEgua+BPvJpToZ6Arw3M1UIJDTKwQVInrJU1XX/JuGe5P/BtfO0jTPkz4gmhFjZoZM1516uD/OBPkyXvun4/naHhe5kFfaNJdsvh+QrtMqukX8PlDl8JJwXHRhaLlDbon1rPReAzmg8wsOw0LcjHdyl409Hkjun+TgaDDgytUka3/NsHAzLqshSrgp5SwUgsx65jC6ogmKPxdqLP9FkLzqSviB4UuGZw3BmhpIbDCrhpJHS0dEgwrjC8StH9tWL1mJNJ4vML8iumOJUXrrnRyGyYrxhMuW/qBGCu0K/CQ/BiL3hud+kVOB9y5VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5)
 by CH0PR11MB5266.namprd11.prod.outlook.com (2603:10b6:610:e1::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8026.23; Tue, 8 Oct
 2024 07:38:09 +0000
Received: from LV8PR11MB8724.namprd11.prod.outlook.com
 ([fe80::a82c:ff8d:7728:65fb]) by LV8PR11MB8724.namprd11.prod.outlook.com
 ([fe80::a82c:ff8d:7728:65fb%5]) with mapi id 15.20.8026.020; Tue, 8 Oct 2024
 07:38:09 +0000
Message-ID: <27983c29-dbf0-4105-8176-739971a071b4@intel.com>
Date: Tue, 8 Oct 2024 09:38:05 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid5-ppl: Use atomic64_inc_return() in
 ppl_new_iounit()
To: Uros Bizjak <ubizjak@gmail.com>, <linux-raid@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>
References: <20241007084831.48067-1-ubizjak@gmail.com>
Content-Language: en-US
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
In-Reply-To: <20241007084831.48067-1-ubizjak@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DU7P190CA0017.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:10:550::24) To LV8PR11MB8724.namprd11.prod.outlook.com
 (2603:10b6:408:1fd::5)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8724:EE_|CH0PR11MB5266:EE_
X-MS-Office365-Filtering-Correlation-Id: a1743e94-63f6-4179-821c-08dce76c27f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?QVNIR2wzbXR3Z2pZSjhiKzhncU1HSklDL0NYTHlCQW50V3ZiTU5mMFYzT2ln?=
 =?utf-8?B?WU9VZXJ2THBMRS9wUWdrSXhGTndTdUdNR0J1cWZ5dmNSV3pBV095UkRwL212?=
 =?utf-8?B?QUUrdUh5VytuZjMwcFBKU29TL01hekEwTWQ3RVQzZU9WaTQ2Y1JrUEEycGV5?=
 =?utf-8?B?bjdNME5BcjBhbWRUM2RmMEp0Y09Uc1pOWEk2b2JlbEZJb05kazhvTzhoR05z?=
 =?utf-8?B?R2FxdS92cUEwUG9lMjFwdEgzbndaQUE5UTFXSDRkZWl3YTFWZ1ZKUjViM0hR?=
 =?utf-8?B?V1hjdkpGbVF2aWtvcndhMXQxYW84L0RlbjEraFJPSEJWdktoa0R2Q0FLeTVJ?=
 =?utf-8?B?aGlDWnp6dDVsMlR6bWF5VzVKSWRyUzdUZ1dtQ01FcVFhRXJxWTh1aVZPUnpi?=
 =?utf-8?B?eXVzNW9nYmM2TExBNGIwNTBtVXlSQkVuQlpEOE1PSi9aNm5VQjJhNllHak90?=
 =?utf-8?B?NWdwU2puK3ErcUp2Rkk4RXczcnZ6R0FUd0xaQldId2ZqdFNPQXJCYWk1bm9k?=
 =?utf-8?B?bXk5M1VzUThIeU1ibVR6SWlhN0pkdTYzdmRvVE5ac3ljZFNzcWkvanc2bVZ4?=
 =?utf-8?B?ZVdnOFEvYkg3bVA1OTR3aG9SckM0MkpKWStzQWNGZFhDS01PWVBLLzN1OFVm?=
 =?utf-8?B?eGpCU2NzaENYNHJKdGtqU05xeDhwcStjM2FmdStCd1JyNWxmR243YzlZbHJ0?=
 =?utf-8?B?ZkpWK2VXS21ZdThXNW5qdkJLb2lmSnFxUTAxTVVxbFFIK0Z0Smc3NWVnSTdG?=
 =?utf-8?B?YVdSbkhSVzdxRFJBZVdQcUs5K1FZaFNJbnVsN0dvWVNTN2hoTUM4cGR2K2hY?=
 =?utf-8?B?VjBmZWIyRjZkOTdoaXlkcDF4WGZoNmJIdS9GdmlvdklleUsrcnlpS2hZbjQ4?=
 =?utf-8?B?cDhpNG1YR2VMMU1mQ0VvZjRLcys3ZXNZYzZMNVVnOXRSeGNVL3hPTFl5ZldO?=
 =?utf-8?B?SUQ1THpLNExGa3pMcUd6eFpXWTUvYmpBdHo5ZHhiVDZiSTZhY2pqNDJyMG1M?=
 =?utf-8?B?MWJYZk9qZFZkYXl4S1o3d3I3ak9FN3k1b0thNUpYaHpuU0F3OFNHaS9FMExN?=
 =?utf-8?B?cHljVHlsYXprQnJaaDNaOEZMRlVDTS94R0QwNVloZGZidERQUWZuNG5URVhL?=
 =?utf-8?B?QkpYSjBITFhMWjF4d0svSGtidDlMd0NTTXhwM2pBRmM4TVYzY0dnSHNBVWtj?=
 =?utf-8?B?NVNxUElpcHlKM2xjbUJHNFQ4YVhoMHNoU0hTbmxSY3RrS1lBNXRhSDZXS0lT?=
 =?utf-8?B?Z0hWa0dlL2IxS3ZZb3hjdERoZXdUQVNoRnBvRHYvMjdMV1ZKMXpDcTJ3b1pi?=
 =?utf-8?B?b0pjY0t1N3FmR01zOVZsMUduWG1BRWxlamtUaG9NRUdmMkNoaEM5c21jVjhv?=
 =?utf-8?B?d1FoWFBHWmRHWi9IYmxRY2JvUVpsd2JBTnNtOUJyK1YrODBXUXJLZ2tPZFIz?=
 =?utf-8?B?YVVpU3duTVJRMVZHdUh2dUsvUG9XdmRaaTYrM3YzTG00ajkrWExzczU4NDJX?=
 =?utf-8?B?aVhGU2ViQUtUQ1FLNjIyK0w0NnJ0MkI4M2I4aFJIaGMyc0RJUVpuZEQ0MXRK?=
 =?utf-8?B?LzRLd0swSzJaZnlKbzN0OEFRM0lxMmgzdnh3bnZXdjF1ZkRTTUJxbU5zeGZt?=
 =?utf-8?B?L1dMUTI3TEF3WDgzNHEwQ0kwNlVyQ2pYd3k3cU1lV2pPTTRraWI1bHVZSnBR?=
 =?utf-8?B?eDNwT29sbTJyK3poN2JMK3hXNnFaN3RjbHFJbXhESlpuWG5QY0libWx3PT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8724.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHRGV2xGQXYxeWFjeUlzWU1Pb1lDT0UxazhCbWRlVWlWeXJjYWtUUWF4bXhQ?=
 =?utf-8?B?UFF5SlVZYlBPa1BLRDkvU2FqOGNXamU4Zy9NdEdYNm9SSlozU1pNRzdOQWlv?=
 =?utf-8?B?T2w5OG1NTGFldG1KL0xETElDUVp6NmpXRUlsRmRpTlBUVVZ0eFZZZ0dRWWNK?=
 =?utf-8?B?RG9BazVMVHV2elkycE8zMkZsSmxhQ2ZDdUh6Q0JUZWNPcDQ0RDhaUWlKZmFS?=
 =?utf-8?B?RHBWT1paRmNvc1Q5UHBFWldLRjFZTHIxZDVIdDU2cDNQaTJQTXN5bWVvQUd2?=
 =?utf-8?B?R3dTdkFDT0pSVzlhZVFKS0xMZCtyU0krbHU5TmFBTmJjRGVicW5CU2RCdHE3?=
 =?utf-8?B?WWdFZ21FQ2M2TUFmU3FhUmE1Q3JkWUlLbzg0ZUp4SkhCVW9RWm45NVczeVpz?=
 =?utf-8?B?T2ZKbTV6eWFQZjl0bVN0ZnZCTDhMRWN1Tm9Nd1BPa0xldkNYRlFISkxscDVv?=
 =?utf-8?B?OUlDWC90MjVyVVd0Qi9BS3BsR1RBOGYvUUkvdk5XWVZ6cVh0aElDUWlWV2xw?=
 =?utf-8?B?RFNVaXc5ckdNZXhkdzBLWmQ2SXd6THZKMEhYVVlVUHRoWXAvMDVjeEVGa0N4?=
 =?utf-8?B?Nm1pMFZNWDNRWUgzamxkTVhISUcwZWRTUVFNUFF0NkNOOFRkYXZMRXZpL2lQ?=
 =?utf-8?B?YlhMT0RDQm9EdjNsencrbjZDVjFUSC9tdTFUSFM4QjRQZzFyT0F0OTRiRGVW?=
 =?utf-8?B?T0FMNG00TnhyS3dhUHFLSEM0V0M0S2tiSEhZSFMvUm9jS1RXMUNsZkViNjFG?=
 =?utf-8?B?bTFNRm1mVTlnMlNlaS9vQ3VnME84ekxGN3lBVElTaUkyMmZyWkhudCs0aHR3?=
 =?utf-8?B?SzJsbWlJZ2dtZUJ5NWwvd3FmMVR0K1d6UmpKWU0vWGdEWlVhei9FR1J6N0Q2?=
 =?utf-8?B?aGFlZ1k5NTJJWnJTV0V4MFZVbzdPcTJVUjBIM0doZTRGVmozbHJ6U3Boci9t?=
 =?utf-8?B?MG5JYVlpM0YxYWxxWUxyUDUrY0oyYTRCdWE2bisxRkdGK2F4YU5MNDBwY0lF?=
 =?utf-8?B?NjRKUXJLOTMxb0VpYm9kZVJFaGJpUkZrcExtU0ozS3dzUVJEbm5MTDBqb0NG?=
 =?utf-8?B?b1B5UTRrN3N3Z1VoaXdINjZzQVpxYjRRRFBPQ1lhUnBRd2prTHZBU2h0UGRS?=
 =?utf-8?B?UVFhVVpJVDJJVkMxT2FydWxHNUdEZ3lZSzRVLy9DbzgyTGtYK3FYNG14TUY1?=
 =?utf-8?B?b1QrUGNVVjlESTRIcHd1aGdTTGY5UHJRMUU5b1NqUGU5d3U2RFIveU16dE05?=
 =?utf-8?B?WDBXa1RYUi9PdWZQWHlKQ2JyRjlJOXVIYkRFMFFETXpVYWk3dGlpUUV2OTRy?=
 =?utf-8?B?QXFUbGtURnRaNlV5UzBpOVhZcWJrMTY3VTc5Wnh4SmQ1aFdkV1NWRW9TbWhE?=
 =?utf-8?B?SUVDUGJsUEQyZlBrK1NWNDFtQ3Z3NXdkSDZ1MmJaQ2pNWVowSWY3OVY5V29y?=
 =?utf-8?B?eVo4dUFvTDR4ZjJ4VlBXT1dxdFV2SUo3bHB0TmZxSGNuZzJPVXVPWmc3K0la?=
 =?utf-8?B?WlJmMlhWMXdWVk80dEljNWozdHZoMTNpZWFrakxGMWVBVUpZeFVVaUhLTlpy?=
 =?utf-8?B?bHZSME9KdTFtRXd5Yk1STitZcjBQVjArdEFkOVBWWUg0b3Ixc2RLMTR3NEpF?=
 =?utf-8?B?RkRSUVNoL0ZZK3ZPMkUySytuNXdIblc1SGpLU3RLUUpDKy9DY3JoWk0zWDhj?=
 =?utf-8?B?SW9UQjhGdjlNbnBiWkVoM3N4VGZULzhtRXFTU3dhdlM0YWJXbncveVBBNHVv?=
 =?utf-8?B?dW15R05DVkdjR0MzTmhPUjhHK2tMNHpYd1BoZndHbXpjVUZZK0VpZWRzWUp4?=
 =?utf-8?B?UThZa21BczU1b290a2o3QkRMRXRaMlhXSS9jdDlmNDljNVNPeGxaUlBtQ2JH?=
 =?utf-8?B?eis2QlQ3cmw4cEZJNkY1YmtKd3FOeVE3aEZ6aEdsenFZMEI4YXpMeG5SSFJn?=
 =?utf-8?B?RU5XUGdUSjNrSXlML0hPNGhUSTR1ZDQwWko4YzlTcnBKaWQvaVZpVzR0MWZm?=
 =?utf-8?B?YkdzUk5tc1ljL0E0T1lLd1RzNTlqeldLNk9uVmhpZndtZjEyU3hjeE90TVg2?=
 =?utf-8?B?QXRveUdMbW9rYXdEeWo3dmFyc0tTNGRPaGl6aDZjeTFHTy9tUzJJcGxhUU8z?=
 =?utf-8?B?TnlPRzdRUHlvb2RaenFJVmZyQmtEUk9XdEN5RWw2YktyUHQxcFB3d1JMSjk1?=
 =?utf-8?B?Snc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a1743e94-63f6-4179-821c-08dce76c27f1
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8724.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2024 07:38:09.4290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6uwXRkYRHCNK+Orh6pHwfA9CbWI8KZDCZUpgcAEnDQ7Qi4xdn3/2ltA/Vm5CPxK4FwO7l0wvDKI6/eAXpsmtzRcXJdPe14lYbF7MFj7pQdw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5266
X-OriginatorOrg: intel.com

On 10/7/24 10:48, Uros Bizjak wrote:
> Use atomic64_inc_return(&ref) instead of atomic64_add_return(1, &ref)
> to use optimized implementation and ease register pressure around
> the primitive for targets that implement optimized variant.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Song Liu <song@kernel.org>
> Cc: Yu Kuai <yukuai3@huawei.com>

Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>

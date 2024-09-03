Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C01AD262
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725355594; cv=fail; b=dmK5mUkOJBh/aH5Iepv2XIOyyyB3xx8WdEsOQFbnBporOzg6rc3xXfm1sfuTPL2WBa9GBsUprg+HARuvKTROSmvflBwN2WZCYa3hDKbF5NMng3ZannRwA/NtLshVIBFdFVxJml/viIKzRdD5VV+Q0XMNfq5HHfPGEdLPRsH630I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725355594; c=relaxed/simple;
	bh=DTp7Nssm6eaJTcDV1IJ8UwjSH/SqUKpju+cmNapJ2AY=;
	h=Message-ID:Date:From:Subject:To:References:In-Reply-To:
	 Content-Type:MIME-Version; b=eJ67JsCsVc0EYUzuKsohQFdUQX5afwEmiY4AIzQk7iBbEUy4BlScQ7qeb0n/q/bxV0ecEi5UzEXVp3SMKiKWafCf1rAcS0TIyNL9xKJzi16CIUDuFaYEBH9DcIpT0xcpGBhvo204ojyd59twc7ggb+5Y8v/Zz7/nAA1mm5o4qgo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YZiw/GlP; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YZiw/GlP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725355592; x=1756891592;
  h=message-id:date:from:subject:to:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=DTp7Nssm6eaJTcDV1IJ8UwjSH/SqUKpju+cmNapJ2AY=;
  b=YZiw/GlPYX0ORfELTJ2FgNrPalkSqvjH24cXpzMesqoNrmg60BR+Btrm
   vjTT0HT8FihMNLbfT9qMYG4JLxW5aNzirsqkpyqhmyWRamPK7+UyoIZ9p
   WhPTM9+O+EoxEORQcr8zSjIuGPQrTL0zQWbcyMODMv1ii10kSxBUlVG15
   uZdYOU5t9VdkQqPEQUhCtjhlEAvDm65SfDakW8IX6wXK0yQ500vUMrKCC
   VT8brtJE1qCPpJkCZgpCxsSv7odf3FHdPF+Nmw6sIrXhN4tpK1sNjJhmN
   fr5HYF7QXZX7DoXdXgrMK7oxcKxkxZxK66Sh+7QaQFDcsrxHQ6TRFv15H
   w==;
X-CSE-ConnectionGUID: mdA05KDGQEqsNGhl/7s5Ug==
X-CSE-MsgGUID: LUf13nD/ReG0tVIR9WjYhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="23508545"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="23508545"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 02:26:29 -0700
X-CSE-ConnectionGUID: qkB+HhTTQsGBDtfTZwg8pw==
X-CSE-MsgGUID: 1OzWOUWUQ+mE9IAxJJmdtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="65205865"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Sep 2024 02:26:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 3 Sep 2024 02:26:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 3 Sep 2024 02:26:29 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 3 Sep 2024 02:26:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vUMIh5M4TXmNSdm76w0/MYAjdE18UOER78lsPmiNTHuuGXK3c7NgqrYrqIllMkQhtbFJ3zLwRKfAgL5bKTgmi1rMEBiJwCueSnuirqo+2kXr1LQAFe7FilU4RJINirQClQSiH95CK315fyLSr5gQAG+NpbleNs4gpndyCyFHk2r5/T8Yh4mxXZ/Xr6+9pUu6VP9rRnXmzF1JuHd/Rdih1i2AUJSr/tpSnRHVHvr2hEnAq76qcu4B+4ODC5/HtW5bVvW+81FN8/R2OUOSySCgl08DmIeBrBqHjOTpgELWJZHAIOrZNlTAEEnrE/kkVkmznV+OzBfrYeJbGIZUGI1dqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xp9zq6MBibS+bOjRDUaUgK+V1Q1T6nuDBZCS7SmWl38=;
 b=GwnnFlTmBhl2RClcxIttsvNSoz0vie45NFHOwMcA7XECq3jxbPSzqJl5cGxHJrgu8z2y6AG1vPTuA7Yckcv0jgaRwjtr4QZgjNht/uX+x5/cAkxaYHtghcv/qxMAFCsmaALl/hTTiZsF8EBWjU9HJ0YivAL9DlDJx8tDtQQsIDg+ilzqGjmzjyCH7gFerRmO3yJPEpEmyXfN+34+8mI2wkz27vwNF7p01lbgk3AsGSJXGkBN/7CB48xznvINZ0wOxJyJosq/8VK2LlIIa0BKztq4fic6CiIJ9b+PAJf9/1qgmiWS6G5ArWl5T1xGwAMiRjKoFE3PGGOOJBupw6d+tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV8PR11MB8724.namprd11.prod.outlook.com (2603:10b6:408:1fd::5)
 by SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 3 Sep
 2024 09:26:10 +0000
Received: from LV8PR11MB8724.namprd11.prod.outlook.com
 ([fe80::a82c:ff8d:7728:65fb]) by LV8PR11MB8724.namprd11.prod.outlook.com
 ([fe80::a82c:ff8d:7728:65fb%4]) with mapi id 15.20.7875.019; Tue, 3 Sep 2024
 09:26:10 +0000
Message-ID: <578cadc3-fc84-44de-92fa-b32809197b2d@intel.com>
Date: Tue, 3 Sep 2024 11:26:06 +0200
User-Agent: Mozilla Thunderbird
From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: What RAID Level is this? (found on Refurb drive out of package)
To: "David C. Rankin" <drankinatty@gmail.com>, mdraid
	<linux-raid@vger.kernel.org>
References: <e7956b07-f838-4282-b179-9883da259d9c@gmail.com>
 <ee66876c-c927-4387-b1a0-34d2db7212f6@gmail.com>
 <b34de424-9f7f-4057-a59f-c031939b4a6a@gmail.com>
Content-Language: en-US
In-Reply-To: <b34de424-9f7f-4057-a59f-c031939b4a6a@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0046.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:469::14) To LV8PR11MB8724.namprd11.prod.outlook.com
 (2603:10b6:408:1fd::5)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR11MB8724:EE_|SA1PR11MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: e35728fe-b39c-45e7-a4fd-08dccbfa7270
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VGZvdGVHamVveVZ3b2lIam03RmxFU2VRdjNxMUNnZHlhTGpabU4xZUJUT1Mv?=
 =?utf-8?B?eFh3K3QzbGNuS3BmcmdwQ3NkMXlSQXJSTGQxNENERklHTlRieVJQS1dKRWJG?=
 =?utf-8?B?bS95ckJ0TjV4eDJhdmlicG1GZVkyaXA1eXhLV2k5M3o4OEpQQVNuekZYcUJY?=
 =?utf-8?B?WSs0S3ZLNUFkcmhxR0NzS3FJRzgwSjV0ZUlnS3pPc2lGRnBNUTBXYzlhcHNL?=
 =?utf-8?B?b1dOc2tDZ21WR29nK2FIU05DeTRMZnlXOVRKUkFMZDFPRnpqdm9MMS82aTJm?=
 =?utf-8?B?UWVEaDU1dG1iZUo3U2xPR0tXeVpiVm9VMHFNMnB0MzVQQlpmN2dRZ1RVcVE5?=
 =?utf-8?B?Vmk5Nzl3b3Z4QmdHdWRCalpXWHJCbFo0bjRKTlV2SjE5Z1E0dEhOdU10TlFN?=
 =?utf-8?B?SjFRcDZubTVWNTZUT0xncUU1SVNrcE02WUJWM3ZrZVlKY2kyZFNPZ0V4L3dU?=
 =?utf-8?B?YldiNFRaWmZsWHBJVFhwSGE3REdqcUJEcUJWUlRvOEU3VTVJT3ZkM3Q1WXJ0?=
 =?utf-8?B?SXQyZHRKdC9nbnoyN094dVlxdGpyMlpSckxvM04wdVI3MlI5cENyL0JoaEw0?=
 =?utf-8?B?TmlBS2ZsVlF2Mk5BVzFJdzRzYzV3WlR2RE95bjBkTXVuandrc0VxaDljc2hQ?=
 =?utf-8?B?WmNaWWZlK0JYWExUUnFhUHVOYTBFUXNWQ0dUYm9ORFlWR1RMcE5SYmNLK214?=
 =?utf-8?B?REppRDk4WVI4S1hHM0RFaWIzeTNWbUJzUjN2L0tPbkRpR2pBTkdRTDl5NGNp?=
 =?utf-8?B?ejNneUZScGY1dkc0VnFEWTVodEZIYUlTSmU1czEvY2laclBhM09ST2RJN3RH?=
 =?utf-8?B?T3paMTZpS0gxWTNOSG5QZXg2NE8weXV2MlRNaWFJWm95aFI3RE45ODU3MjRs?=
 =?utf-8?B?Z3dMbS9mY1Awa3llOUtJKzh2cWZsMzNXVUxMazB6WjcvUmpubmZBWTVJS3J6?=
 =?utf-8?B?TVJrMVQzd0l2dzJaSkwrNXVtMmxaOEZzS0p6YlpnN0llMGdmOTNqYVM0dmZK?=
 =?utf-8?B?dGIrNC9rZzVEWExuN1BUaFRSL1h4VFRUMWl1Q29iSFUxWHFZSVQ5UFduQ0dB?=
 =?utf-8?B?WXRHcnBLV09pOUNHQ0pXbEZQY0dnT3FmQ2xxTGdReVVvRGRLdXBrMGs0c2V4?=
 =?utf-8?B?MW14Q1Z4ZlJMbDZjekRkYVJIL3lhQXFkVDNLTmFBL2RZTkhOUzVtTlZEQU42?=
 =?utf-8?B?OGVQL2ZFVGdwZFlnWkFmbGFRNWJneEg4NFBrWW1CMThmbXRaQVhPUEJTU2Fz?=
 =?utf-8?B?WGdnSzVnVEpYcmtKNW5pQk82RnQ3ZWw3WDVwT2RNckllTm5nbnA4VjZMeFVE?=
 =?utf-8?B?MGoxakxRaEFTN283cXZLSnAzUnI2MG42L0pYdmU4MUNkUFJ3MXVGdk9ub2dY?=
 =?utf-8?B?aCtDeWhGYXMxRHphUnZzMEtEdDBwNEZoeGcwaWZLQVV4SHZTZEpranlaSVJ2?=
 =?utf-8?B?ekFVTTFDVDRETklTUGRqZVRBVUFkTW5Wa3RkbndGWDB0NEszeGt0ZzhMYndn?=
 =?utf-8?B?WEcvc3c2Tjh0c3M2N05RMEFxeFRIM09mcGZtaHJRSldzUHlmTEF2YUJzVjA0?=
 =?utf-8?B?elpTcHliU2hUL0tBRVdwT2xuL1pYWm1VM2lBRW40QXlXdGNaaWdGQzFObDFz?=
 =?utf-8?B?KzRUaXd2NzlEaTlHQWk3ME13L2lLMldOQXo2NGxva0h6dmFVRHhDY2dTaVov?=
 =?utf-8?B?TjNNYXN3NlhWLzlTdTdFV0FZOXRPVTE3UG1TT3VmM0Y4K21nTXF5LzhUOXRM?=
 =?utf-8?Q?4+fxHCJHvYlNlXES8A=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR11MB8724.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cHBkUzU4MllpcHhzTnZnZTZyTnd5eFFDVWpBVVo2ZjRSMWZiQU13SnBsODR4?=
 =?utf-8?B?WTZJdVlDNkYwWXNrVEZZRW5HOTB6QThXcDV0SkM4U012R2k4bitFUDd4ZXdj?=
 =?utf-8?B?aGsxVzViVFJXSVFWWUplK3NmRkhYS2lPTllTVkdNMzVJY1c3ZmdkR1RzZ2FO?=
 =?utf-8?B?eFlPM3k1eHNUNEd1amZjb054anFvRUVXNkV0YUtFSFRoY3lTcHBKZWVHRmZy?=
 =?utf-8?B?Zm5VZU5ScWU3THBaeFNPZEFBZ1RBb3c0SXRaTVB3MnJYNEFtVHJPTzNWOVBo?=
 =?utf-8?B?UkxxVERlTUt0aU1HZEs1UFI0cXlmdjZZN0pJU08zVDl3YmZscHoxTzAzTHps?=
 =?utf-8?B?RUgzT3pmd2QyU3JYQUNXMEo5dnU3S0pIV0VJMGNPZ0NmSmJJa3Nud2Y1T2JE?=
 =?utf-8?B?WnZWOVY3QUQ4dFExNnlEWDNLcXRaLzhrbTNTWE1IWTU3TVI3aS9BTldUN3M2?=
 =?utf-8?B?akl5TW1jb3JHQ1c0KzVNL3VnWG5IVWhLdk93bUlIazNHOGh5RUlSNi9rSi9W?=
 =?utf-8?B?S1BMN1lHbkJxTWNtMVF3RE1malk1N3habmhSN0xUQU9vN2haVDNWSVVpTFRL?=
 =?utf-8?B?bTY4R3VzRWZmN0tOUVg5ejRBUHByNzRxSDhzMkJYa3EwcUVyMEtWaFJSaTJy?=
 =?utf-8?B?ejdxWTJlU0h2Z2RSak5OT0k2UDdvWFZ1dVhXdGx3RndJY2VFR1pqa3ljenhJ?=
 =?utf-8?B?T1VlVFZjN2ZkTThmelNLQ0p4VnVkbytkbG5Ib1IyL3ZBWEFZMmdaTFJmd0Fx?=
 =?utf-8?B?Yk0vbEppdXBPQlBod1FWMUIrOWcvNmlIM0ltMkhURlVyMkFnejNEaXVkNDhN?=
 =?utf-8?B?cXdFRmpqTFZUWjhqS2U3aVB4SW5MaWltVG5zVGdkejkrMWRmdlNYQWxKLzQ3?=
 =?utf-8?B?eFhaUExwZmYvMnBFZVU3bk1WWExoamFxT1NMNDBtNU5TNzBJWTJscjBCM0Js?=
 =?utf-8?B?bmJRZG5ycS93RnNCZ2JZQ09NN2VsRUVDK1ZTdW5JNVE3MWFZSjlDL0NER3k5?=
 =?utf-8?B?bm1DU1d6UStUMDV1d3BrSUJGVDErZ1pCNG51QVZWcWZuQ0R0c1IzNHZhM0RL?=
 =?utf-8?B?YnlYUjd0Yi8zUmgwNldsemdCOHFPRmU3TUFDR01BajNsNDFtZ09GWXlYTDVk?=
 =?utf-8?B?dkhodXBBakF3UTFrNE9tdDRRdU53anNjZnZuV3hGeU8xQytJMlBzN25VNGF5?=
 =?utf-8?B?bkRmZTVWV0J5aUJEV2tVUFB1bXBpMmU4RlVxNm16emFGV3ZyOXFmZ2w5S0tD?=
 =?utf-8?B?Q1VlL0poaWF1TUZBMnM0K1U2UXNsY05YSHdxOG1qWTVkcFlRVTdzelAzTUkw?=
 =?utf-8?B?WkhWSngwVDY1RkUyVDdML25LTkpPcWVPckhSQktGZFFGZEVUSGwyQjJnSzY3?=
 =?utf-8?B?bGRQYVJ6Q2pHV1AxaVZwYkpjQWovaHhMS2Z2YVNWUDhCb3lPeFRUZGwxekhk?=
 =?utf-8?B?ZDVYMDJoZWUySTd5UjFVSmdIVjg4N1VIcHZyWWpDbFJUeUZXcjQ0YzNXTC9X?=
 =?utf-8?B?MzBiRW9JaWpPdENMbHhueDZ4cUcvTEtVUmorSDFpSzdneTBQM2xPQVlab0F0?=
 =?utf-8?B?dm9RVTBKM3dMckdTaWJUNDNqUENJa2diUlRWS2lnQ2Z2NzluQTNESXV2bmw3?=
 =?utf-8?B?cVk2RXJMTnNDM1YrdDZxdW5XZktqZStDUkU3eHNsQlJESVpGS3V3UkhYbWdr?=
 =?utf-8?B?eEVYYmdCQXIzWVR4cU5OS0VITVEvSWhQdTdxeVFDNnQ4UnA2NUFtdUVuN3dF?=
 =?utf-8?B?OCtZMTB1clMwcys1eUl4elVUYXRKSXZsS1Uwanc4UStpZTF5UUdhOGIwTlZC?=
 =?utf-8?B?QzdwZ3d4VzNyWjdVV1ZEazI5MGV0Z0wzNUxZcVZxdHlYdmg4bU1YOEVjN2ls?=
 =?utf-8?B?TlZaSVFkdnNuWGRFTUxVSTlhK0ptR0ZnbmR6a0tXRjl4T1Nvd0RXR3U5NnZH?=
 =?utf-8?B?d2VaQ0dydzRVNzJPUlg1b0p6YkhmcGRiQk1vNGpiTWZscWw0ekpNNTgxeWJr?=
 =?utf-8?B?WHZEc1ZFbnJ0S0IvVStJRWNXWnliWWJxVEtmLzU2S2MyamN2Ym5OYWlxQWpM?=
 =?utf-8?B?ODVGTlZqV3ZnZDBNNm5XODBJdFRGYkRXTzRZZHNaYWlza2FXWjYxREJLWFpJ?=
 =?utf-8?B?dVVnN2JpZ3E4UW4rdXQxNE1Vby9xSnIwc0U4SEVNMXpqckxiSzUrODBWeVlu?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e35728fe-b39c-45e7-a4fd-08dccbfa7270
X-MS-Exchange-CrossTenant-AuthSource: LV8PR11MB8724.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2024 09:26:10.3780
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JAncM/fXDTcZQZETzgcHBcFo75xvahOvVTEdlrm/95rOSY/ujMXie9ljgfCvOq5hFPXrpzcnQQm0P/kGmAdFb6Y3WsunGy6YBZfx+OoM06Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6967
X-OriginatorOrg: intel.com

On 9/3/24 01:31, David C. Rankin wrote:
> On 9/2/24 8:15 AM, Paul E Luse wrote:
>>
>>
>> It shows the RAID level above as 1E which is effectively RAID1 near 
>> layout as described here: 
>> https://raid.wiki.kernel.org/index.php/A_guide_to_mdadm
>>
> 
> Thank you for the link Paul,
> 
>    I've read it, but I'm still confused as to just what that raid was. 
> Yes, I read that Raid1 2-disk can be the basis of a Raid 4, 5, 6 setup, 
> but where I'm confused is the output shows:
> 
>     Secondary Level[1] : Striped
>     Device Size[1] : 2925241344
>      Array Size[1] : 46803861504
> 
>    Which shows the Array size as 46803861504 and Device Size as 
> 2925241344. So the best I can glean from the wiki is that is some type 
> of Raid0 setup made out of Raid1 mirrors.
> 
>    Where I also have trouble is with:
> 
>    Physical Disks : 255
> 
>    But earlier there was:
> 
>    Raid Devices[0] : 16 (15@0K 16@0K 17@0K 18@0K 19@0K 20@0K 21@0K 22@0K 
> 23@0K 24@0K 25@0K 26@0K 27@0K 28@0K 29@0K 30@0K)
> 
>    I guess the 8-bit worth of physical disks that make up 16 raid 
> devices (or 16 physical disks per-device). I guess there is just no 
> Cliff's Notes version that outlines all of the ways linux-raid can be 
> fit together and extrapolated to make all kinds of things. Just glad I 
> didn't have to work out the command line to replace a disk in that...

It looks like it was a part of an LSI RAID using DDF metadata. You
should be able to find the answers in this spec:
https://www.snia.org/sites/default/files/SNIA_DDF_Technical_Position_v2.0.pdf

Regards,
Artur

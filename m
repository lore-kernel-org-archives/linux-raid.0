Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB551A76BC
	for <linux-raid@vger.kernel.org>; Wed, 25 Jun 2025 02:36:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750819016; cv=fail; b=k2PuH28p4bDQ/2qQXXAuedzGwDiBcOZTP1Hk2oyLIU1qweA3FMPd+RnYrQ4t/vyuXALY9/fkeI36e1FRMan1NLgypw+ntszKpElXavq42+FpWcf7A5z458z42BCj30SVCLodVFU/SS2yNhQOnNDwJDAe/a0HcvjxwQEW2pF1C7A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750819016; c=relaxed/simple;
	bh=tVudsIyud7tSmD021NBFrEGzG4pED0DOlYg8NBziuM0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DcEz8JNZdDydhbZD/Hs/3JSeFhH28TfnLgRiNlkOMqYFOwpBcSk5G8JhJJtvrCP6w1tVnxCLwiGPR2zM93/4bWdyIqbW7AguQnVRuU1zVYTEbzbv1be6ZJc6aQOsLR5Osuf0eyzSNvj1jPJ4DYlTysmBR6p9MTDHGFUicq3npbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bSebeTgz; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bSebeTgz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750819014; x=1782355014;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=tVudsIyud7tSmD021NBFrEGzG4pED0DOlYg8NBziuM0=;
  b=bSebeTgzQrDd/SRgoPoF6ppCfP5WmMa/uULuLaQxYWYHDN+SxXOktPyq
   aDppHjgPrUaUVvaF39iHLTTQtELXByMHeM8cm4+6sbvtWZ0K43Pb4kvUB
   9NDDdBtPJm0EEqt/jal0/UcAx65+kcGHeRmWrAzoaGnwvZUaUe90idXsV
   796r2Sfq+e+jSDX7UudNStQ5e+rP17TtLayan/ZctWOBuQzckZhatcu6X
   hdHiRWZNdJNbfgN1g7n1PdegXBcvLJufbpJIBbyiRmF2T1cHJErNBoweu
   GvCkkbdYq2+i5n9rLqP1/ktpSO1BVuJk12xq9r+ZpMcWsqWZmX3g14DOa
   A==;
X-CSE-ConnectionGUID: 2GzfbgaQS5e44h65KAIErA==
X-CSE-MsgGUID: 8LEkKkEJSkO1DGe9c6Rclw==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="40696262"
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="40696262"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 19:36:54 -0700
X-CSE-ConnectionGUID: VLgNDFyTRWybEj6ogzlH7Q==
X-CSE-MsgGUID: 6Qfp2JhmR7CkKjl82D2Lrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,263,1744095600"; 
   d="scan'208";a="156115659"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jun 2025 19:36:53 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 19:36:52 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 24 Jun 2025 19:36:52 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 24 Jun 2025 19:36:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d9yh2s2iqrGrnypzbZjn8BA8bDNj6nAwXMBQiwH0ojYiqLogjUv1y8j9OnY77pH6yrjqC5R6+wvyFqAnwF27Wk/Cn6Ox59zDHwp6JZaz9eEXJR6Z0NMBiIdQgIYIa7rRl5R9kfAbZexxod3Df6EhnBpjtng9lJhDe2S9ERVWEWv1B5qJgFg70s75j6tjmLkb1LJwNenAPNsUue5BQwroDvDIWJ2POlzjSt6Q94ggZxFkUb8Rv3vDi2qw1cFhNP6yrP5IzOC2nZFxKtbCE7yILk+ww7LBW9oe7EK7ItYBZuiA4+mVsf6Eqs6RE478fI4L5nD6wKtXII0qe83ySjWOLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xpLEt2iHC5WkziXMNn20gw+StubW7jpb6a68VRN7aDs=;
 b=sVxbjOCQmTRieuOv+I34MXmZ7oucPorGeeW+PEC6R2xPTD9wtd44JS0t+/bwFay9+1JwdbanedmRwBneCRb1ZaAy2HYIhdb0adR4ZG+1fxWdsBkcPDQr05zHWa5PmEUGcVSiYDRur7/LWm0KmhmgQ/Z4xUvoOwaS0goLIuSaULjKX+XSBboGR9XsnxAgZboYvLrI1L+mA69LdbN5W7wCQ8JgtUngx/mK6ppVDsHBtgGc2RZ3bP/rCJ8VXjsJCj9Wy1pPUUNkmeIav/TXQLeYx4u31Mr3ix9arTdIrEJeD6Gwd7aF0KQuSxNqXYvKSJWngcrdzSdIzUTes4FASPlkDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by LV2PR11MB5997.namprd11.prod.outlook.com (2603:10b6:408:17f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 02:36:44 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 02:36:43 +0000
Date: Wed, 25 Jun 2025 10:36:35 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Xiao Ni <xni@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Yu Kuai <yukuai3@huawei.com>,
	<linux-raid@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [mdraid:md-6.16] [md] bc8ce8eaa2:
 mdadm-selftests.05r1-failfast.fail
Message-ID: <aFtgsw+bARwZSQQI@xsang-OptiPlex-9020>
References: <202506201427.baf6fdc2-lkp@intel.com>
 <CALTww2-0v=60uxbgd=ideL8XQM0Tp_ZOwOkNhTrthC-U+zt4Hg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALTww2-0v=60uxbgd=ideL8XQM0Tp_ZOwOkNhTrthC-U+zt4Hg@mail.gmail.com>
X-ClientProxiedBy: SG2P153CA0010.APCP153.PROD.OUTLOOK.COM (2603:1096::20) To
 LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|LV2PR11MB5997:EE_
X-MS-Office365-Filtering-Correlation-Id: 0254906e-1a0b-4a10-676e-08ddb3911f77
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VDQvYUtMRDBHQjBQbE9WVC84TzduR1BQSFFpM3U0VFpIS2ZITC94OTEwbERD?=
 =?utf-8?B?QURvd3Y5L1h5S0taRE0xYlZGdzdYN2h3SEI1RXJyYlUvZTR0eUQ0a2xaaFdJ?=
 =?utf-8?B?VWpubHJRZEt5OUxXYmNHTUI4MnhFdzBQS0s1bmlsWXRwN21ESkxILzhtL1hQ?=
 =?utf-8?B?SitjT3JtbnlXeVAySFNJYTY3N0NQY3grVCtjWlRTcGc0bTZEMXBxVlRDdlY3?=
 =?utf-8?B?S0JyQlpIaVRHUTFLZlVwWTlmOEs0RHhYMUJKak1wck5lMzRGZFdvNDV0bE5T?=
 =?utf-8?B?UmJHdFJ5d0ZqSnhYR1drVGoxUGV2RkdqSjlBNnVzVmRiNFY4MmdxaS8rK3hZ?=
 =?utf-8?B?bmxyTGlkVVJiZlVXenkwOC9xcUJxSDZsK1gwL1FaL3kzRXJVaVB4ZDJudEVF?=
 =?utf-8?B?SEVvUWVQaW1GVjByejNYeDFweHZiUEFyUisvOHJndXVUc2V6WmhpU3FQU1Bw?=
 =?utf-8?B?TStOVGgvYnZWNzdjL1NYYjlnSnR4SEtwaEFOS1JMMWs4WWM0cUlxYm9IdzhS?=
 =?utf-8?B?VUpiRFJLQzZHdWUwamF0YkNCM0dOdlFldGYxNVZiTGZkdGdiSThrWlAzMmxt?=
 =?utf-8?B?TGU5ZzdhbytlVkI2MjFvbFVWblVXd1ozUE9TbzRXOGQyeW9pLzVTOVZrdnNM?=
 =?utf-8?B?N1dYRXVnL014Z2FWUnFCUXVNUFNraS9jcm8xazhpeEwwWXJuQkcwY3ZBcFlE?=
 =?utf-8?B?aDNEb0Z4a045eWM5cC9SMEU3VlpZbUF2NlhqVDlVN2JzN0xoRzdCSlZTc1Rj?=
 =?utf-8?B?ZUJPSVkrV2IySEZZTzZENGxxTWVOaitQTE9lY0FkZGt0RGxoSnd6SlFrM0JM?=
 =?utf-8?B?Qm5WUnhhT0J5OXdiSXlEZHVEZTh3dmVDbTZWQ0ZPbTdSN2k0VnJKWFFuVjZ2?=
 =?utf-8?B?WnJ3V09IckxzTkpqYTREcUVxM294LzY1azFDSFNoQng3TFR4SExkYlBFbTBo?=
 =?utf-8?B?MG9VNkRIRkZFVWkrNEhIcE1zWWxSUGlYek1ib1psRjlnQVBzUFFLQkRpaXBv?=
 =?utf-8?B?NUlpRkpCOTdscERXQU9ROStYYVV1WFpKaXIyZkJ1V0FJcHVJKzNLMzk2a2N0?=
 =?utf-8?B?T0ZSMHFkS2Y0Y2t4c0lZQURjSnduTlZYR09kMWFPd3B2dU1vNEdtak1Bcm83?=
 =?utf-8?B?ZHRoNlQ4N011aGpNOVA2MVZ1OEZHd0tVa1l0d1hwb0pzSWljTDNUc0RYanFD?=
 =?utf-8?B?SzZaaDVLd2ZsWTZBTWgwSWZEaXJldnBZUi9ISStrU3VQVDlOYlRCVS96Q2p1?=
 =?utf-8?B?aGFoWFFEZkppdFZOL2hNTHBGaXEyZ2IzRllXWm0xRDFreVhwamorcFhaYVU3?=
 =?utf-8?B?WnhhM2xvVHhtUHY5WE1tTERWcHlXTlpoRG53aFNBVjl4ckNmRlhFVnU0L1dQ?=
 =?utf-8?B?dVpzQ3pkdWFnRlk1a3doaFR6blpldk1QUUg2N2RVNkFFTTRLT1FETEhwUFhx?=
 =?utf-8?B?VHhPbHNWU0JTRXlIU1V0T2JYY3I3WkZsNlZWektLMmZGVDBnRmFuRy9OWEpo?=
 =?utf-8?B?S0tIdUk1OXlnb2U5bkZycWF1dHBiMDYwRVdGSHUvcHVZQjkrVUhqeHhLaTNN?=
 =?utf-8?B?TkdoKzZJRVdpTEZITmFMeU44eU0vSzVPWjV2WnYySzU3NElMN3kwYVI4K0ln?=
 =?utf-8?B?MHMxL0NTT3U1QWxKeTZUOTZzd21uV2xOTXpUeE5zbFk2VGJLcGZ3NEUrcFI0?=
 =?utf-8?B?U25uZXBsdzhYakhTMHpEa1UyOUYxNFcwRHAxRVdGK2g3WmVaeVo3K2lJUkIx?=
 =?utf-8?B?MW1jSWpqeWdvUi9HMHoxeDdxQnJTNm1RNXRXY1pBZFE5T0k3VzF0QmpUSWRn?=
 =?utf-8?B?Y1JtQkl1TTVNblBoa3Mxck9PRWdnNko2MUxsa0Fmc2VQMlRDVmpiL1RLUFZk?=
 =?utf-8?Q?3XCDUHgEzmYrz?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aXlVbEhsTVNuYi9mWmR5bWtubUpZejVZMVRPRXdUUUNWa3Jvd1pXSlIvNlNy?=
 =?utf-8?B?RFd3dUlKUEtSQytZQWFUNHJueEMzSmFXcUdIV2tNeWpTTXdUcmE2aDBxSnFz?=
 =?utf-8?B?RkJmbzFSSGoybVFXMXN5SXdVdmx6U2YxcnkyYUdlbEF3SkpGTGliVTlRNTFW?=
 =?utf-8?B?NWlIczhtallXMXV3aGF4NlUwYkk2TTVVandvc1FScW5nV3ljaW5pOGEvbEEr?=
 =?utf-8?B?SWdlS1dNZmlvME4zVG1Wc3VaSTN2cTU3bklOS0dQcy9Db3NrSm51c0lZRmJL?=
 =?utf-8?B?ejR1aUt2SlRMcC9XLzFVQU5oTW1xd2dKZ2lCem1XS2IvK0ZSc1lZRW1EdWov?=
 =?utf-8?B?d1lJald5cmM1RWoyTUUvTEVQVk9sNWVuWFZac0k5NThBRGdFZCsxa2lvRk9B?=
 =?utf-8?B?ejRTZkRScDQzRmYwRVk1Z1UxelozSXd6V3hpb29zWENPKzVPbGl4aXpGRDVE?=
 =?utf-8?B?aWRhR0xTQllUekw1RVJveUhocFA5NTdhT3o0cjhjOU1JaGtwS01icVQ2QzNI?=
 =?utf-8?B?eGdmK2c4Mi9RWXVSclE0aFQzNGR1a2NsOWFlWlVwdHFsT2I0U2tVcnczcWFU?=
 =?utf-8?B?T2FEcUtHSXk4Ukl1Yk9mMFRoYkp5VlVWYmNHNk13VTNVV3Z6QzF6YytqVGxE?=
 =?utf-8?B?Z3VRRWJsUjg1WFRiT2xZeHhZMEEvbGNlZDh0S2d1Mk1GUm5PeEhxdDJyRVVi?=
 =?utf-8?B?UHlKZ0dyb1EwazZGbkg2UnRtMzhLYmtTQUZXZHAycUhnTGwyYXh5djlnTGJw?=
 =?utf-8?B?NCtWMnVodkFuVURNU0FJWU1FSm9qblNlY1NmSUlzSlVOUzlpLytPUDFtSXho?=
 =?utf-8?B?czRpTWdzMmNsUWpVa1ZwRU9tRjIvbW1Ea0kvL28zcUI1Z2Fib2dsVlFWMy9F?=
 =?utf-8?B?cUM1TUJhaDQ3a0FzNWRxKzFqaHFwNFVEaGxTUk1aRTREWENjMGRkOWdmU0ZU?=
 =?utf-8?B?RDZIbmFidGN6TXZvWUczclEwT3VzVGIyVytDZjlEWEx6M0w3VTJOcjFDU3h4?=
 =?utf-8?B?L1Y0OUZzcW4yR0JUaWZPU3lyeXUwdURuVWJpYit5RmF5UFlMZEo2d1dQNkIr?=
 =?utf-8?B?YnhLNWFiYTRIakZ5all3QjJrZTlUMmNremZqVmlqTW4wak9Ya05JTlliREp3?=
 =?utf-8?B?SU9ab1pvRlpuWUNRcjVNajZUcnJhNDk0TE9GbmlUUkJ2anB5QUN3SzE2ME1O?=
 =?utf-8?B?OGZhTVJxekdzMG9UTjJaWmdVOUdGdEQwWVBhYlQwWWF0ZThOUTZpY0k4TlpH?=
 =?utf-8?B?c2RHaXNkcmNuVTkrTXpTZ3JVRmZNMktkUHNiWVdOdlpCbHAyekwzRGZZbCtN?=
 =?utf-8?B?VHhwWmlnTldnWlhQL2tFeVVUQmdscmFNS01URG01Y0VMak00b0xXTXU0ajNX?=
 =?utf-8?B?WmJKVUdpSlRXVWYzZUNhajlxdGxNUDVGb2Y3UGtVcVVhR3RiR3VYOTROaS9B?=
 =?utf-8?B?MGdlQXJ4V05OZXR2c2cxQW56YnQxckc0RWlmSzFsRFZkbzMwa2lJejA2WVpM?=
 =?utf-8?B?OW9CaEhMdXQvVm11ajdacjkvMzhRZVFkRFdXb1JHNGdLNEpxSTVTekF5SnlZ?=
 =?utf-8?B?NTJFV2pYK2JSWjZlOVl4WGc0allBeWtFclJ5NHRnaFlPWGxza3BneUcxVUtu?=
 =?utf-8?B?NFFkeWpOaGhlM3EzbSsxc1NGQ05jaHNaUklzSXgxNk9LK2tFQlNpR3Y2L0RC?=
 =?utf-8?B?aGFkQWlmc28vT000Q211U3QxaEhWenhhTkVNTUYxMWxEbEVXeG1VWExrNzYw?=
 =?utf-8?B?eHJwWmdvNjBkT3didDEwMS83ZDZPM0FLQTh4djV6TXJwdFJoWS9xbG9xRTUr?=
 =?utf-8?B?QmltYmFoRm9YdG13dnBZREMxV0NLTy9rZWtSbEYvTWJsOVNOK0xKMzJXcTVG?=
 =?utf-8?B?Sk5uVnhLajQ5aXM0SEFockhGR1NYMy9MeWlnRnJydjNhUVRhNXRGMVZiVkJF?=
 =?utf-8?B?SkovLzY0VXRQRGtqN0E3UENtTFNKdnBNTldCNEtJekROd2c3eCtRYUQwUUNQ?=
 =?utf-8?B?OXFISlZGNUg3OHUvMTJxMVRHL29GTDZKUFk5QmtPazZpN3JkUnUwbG5FajU5?=
 =?utf-8?B?YUlEd0IwTHlBWm43WVd3bW9ndHl5Z1NCQmx0V1c4dHBhWjkzL2FIWWtBUCth?=
 =?utf-8?B?Mlh5ZXR3N1NsK2FXdkVFZm9pSW1HcnYvSCtoNHBYNUptaFh3N0xhUHFJKzlN?=
 =?utf-8?B?ZlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0254906e-1a0b-4a10-676e-08ddb3911f77
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 02:36:43.8036
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jbu+IsT+4wX56do7HZGGERjMKbznzxHv0W8I5rPA9z6t4p9J9AVSmDbx/P6byXgk8LyIQPgk3zHGsUWbM4i13Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5997
X-OriginatorOrg: intel.com

hi, Xiao,

On Tue, Jun 24, 2025 at 04:36:45PM +0800, Xiao Ni wrote:
> Hi
> 
> It needs to use the https://github.com/md-raid-utilities/mdadm/ to do
> regression tests

just FYI. we really use test from this link:

https://github.com/intel/lkp-tests/blob/master/programs/mdadm-selftests/pkg/PKGBUILD

pkgname=mdadm-selftests
pkgver=git
pkgrel=1
url='https://github.com/md-raid-utilities/mdadm'
arch=('i386' 'x86_64' 'aarch64')
license=('GPL')
source=('mdadm-selftests'::'https://github.com/md-raid-utilities/mdadm.git')
md5sums=('SKIP')

> 
> Best Regards
> Xiao
> 
> On Tue, Jun 24, 2025 at 3:55 PM kernel test robot <oliver.sang@intel.com> wrote:
> >
> >
> >
> > Hello,
> >
> > kernel test robot noticed "mdadm-selftests.05r1-failfast.fail" on:
> >
> > commit: bc8ce8eaa290a198cb5303181041aad037299b7f ("md: call del_gendisk in control path")
> > https://git.kernel.org/cgit/linux/kernel/git/mdraid/linux md-6.16
> >
> > in testcase: mdadm-selftests
> > version: mdadm-selftests-x86_64-0550fb37-1_20250518
> > with following parameters:
> >
> >         disk: 1HDD
> >         test_prefix: 05r1-failfast
> >
> >
> >
> > config: x86_64-rhel-9.4-func
> > compiler: gcc-12
> > test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory
> >
> > (please refer to attached dmesg/kmsg for entire log/backtrace)
> >
> >
> >
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202506201427.baf6fdc2-lkp@intel.com
> >
> > 2025-06-19 10:07:43 mkdir -p /var/tmp
> > 2025-06-19 10:07:43 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sda1
> > 2025-06-19 10:08:14 mount -t ext3 /dev/sda1 /var/tmp
> > /usr/bin/install -D  -m 755 mdadm /sbin/mdadm
> > /usr/bin/install -D  -m 755 mdmon /sbin/mdmon
> > sed -e 's/{DEFAULT_METADATA}/1.2/g' \
> > -e 's,{MAP_PATH},/run/mdadm/map,g' -e 's,{CONFFILE},/etc/mdadm.conf,g' \
> > -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.8.in > mdadm.8
> > sed -e 's,{CONFFILE},/etc/mdadm.conf,g' \
> > -e 's,{CONFFILE2},/etc/mdadm/mdadm.conf,g'  mdadm.conf.5.in > mdadm.conf.5
> > /usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
> > /usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
> > /usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
> > /usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
> > /usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
> > /usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
> > /usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
> > /usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
> >  [1;33mWarning! Tests are performed on system level mdadm!
> >  [0mIf you want to test local build, you need to install it first!
> > test: skipping tests for multipath, which is removed in upstream 6.8+ kernels
> >  [1;33mWarning! Test suite will set up systemd environment!
> >  [0mUse "systemctl show-environment" to show systemd environment variables
> > Added IMSM_DEVNAME_AS_SERIAL=1 to systemd environment, use "systemctl unset-environment IMSM_DEVNAME_AS_SERIAL=1" to remove it.
> > Added IMSM_NO_PLATFORM=1 to systemd environment, use "systemctl unset-environment IMSM_NO_PLATFORM=1" to remove it.
> > Testing on linux-6.15.0-02014-gbc8ce8eaa290 kernel
> > /lkp/benchmarks/mdadm-selftests/tests/05r1-failfast... Execution time (seconds): 8  [0;31mFAILED [0m - see /var/tmp/05r1-failfast.log and /var/tmp/fail05r1-failfast.log for details
> > Removed IMSM_DEVNAME_AS_SERIAL=1 from systemd environment.
> > Removed IMSM_NO_PLATFORM=1 from systemd environment.
> >
> >
> >
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20250620/202506201427.baf6fdc2-lkp@intel.com
> >
> >
> >
> > --
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> >
> >
> 

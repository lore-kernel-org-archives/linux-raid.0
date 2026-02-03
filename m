Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79E23A1A31;
	Tue,  3 Feb 2026 13:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770126870; cv=fail; b=qaQWm2oya20SAkn5aoIEbBWqzHsoRYaDp/9XudD5UR/Otmd7udZGrNmE0W78iUQmX0UTJc5fUFCw4HpWyBqxQfaYU6ZahevjlQA6OMqFA+RiME7v202PMF//7Pu6D1Gifhyd+zzfy5NFn9KTKu6KhbSGqH/4+mKFsaLm/Tal7xk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770126870; c=relaxed/simple;
	bh=aOuJNUArTL8xJMZ9jbfY/SN9o+3vXVLsR2owvAksAxc=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=oF0N9Gg2PLWwJa7wlsZqgl7rNglKL/mf7FMWchyBq9z2O1l1Li2D7zO2CAkd2HXLAUW4AV3G0Iuz9CGR7eHZJGI58eW9A1jvCqk039yEi71GOkE2/vGQMXVelMGY8nqjUf5Ncvxo1C+HNJ03igX2ZDtzYzT7RC+MW/vfXh4BfdQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ckdqO+j8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ckdqO+j8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770126866; x=1801662866;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=aOuJNUArTL8xJMZ9jbfY/SN9o+3vXVLsR2owvAksAxc=;
  b=ckdqO+j8hjqp1pE4X6fR4JXwN1OXeLj7vHXjWnHNgigmckMYLeCi+u0j
   H5iwEAhW4oIVbdH1Gbk+rzUQ6nfC+qKpb3xiS1+WC98GOeTmz96OFjWX4
   Q7mF3FLdrhjhmp02WilZPZKOEx0Rv2zRDlykVJpXGV0v0abHGCHRAWKBz
   DboM+qIZLP4rvZv8Cr0imarVsmxiIEX1ceJMStKs7YKn4fimmeeJCOKro
   zUDNpc2o+kIVV3nARH+nl8F3c3Nfgy0agZNTMcHhTtPBbH7AVeFOu6tuH
   rht3r9EXL4odRpJwBsquMyJIK/tcQlcGXeZlge3FrmBZue4uzG/fzHTC0
   w==;
X-CSE-ConnectionGUID: OybBYqlOTLCaGh7g49hsgw==
X-CSE-MsgGUID: 1pczG/fWSf6x8+6WskbSAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="74920409"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="74920409"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 05:54:24 -0800
X-CSE-ConnectionGUID: 8SYtYv4fQ6GUKrflVGQe+g==
X-CSE-MsgGUID: FH36fxgATXywbfjKrWcasA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="209567094"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 05:54:23 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 05:54:23 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 05:54:23 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.50) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 05:54:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=anWD/03RTyt7T3rg/n9kSkwA0jLVyrNbt+HMTEM6p1b4hJ0G2vE0dL92qjZurC7OM0hgSgQrc1HM2Q0+H35WQfh9AR0dhDRvuW8AmZIwQ58yxQ4exnzocbc3n67U9tXur6DfFdXtxWCtH93dYdcsmNhBEJ6fTKlWzkMO9ETPt91iJybfniugF3QBkbdFjwYgTfOF6Cwd8nVSfGIkoi22KQgSMs8THGH4eSKpOVLBAFRbeTi6O1jOFGJbdtiU0a7zkHPUe9vHbkfTKsoIhtAkiBIEsqJuE/6yhdCzP1ReK9W1uI09seAC/wMF0OOGTf81gO76rzz95NqmdH9FeI+rqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=45T8dnfYGQ88mzutasgH/npTrOx8/TlxIC9o3vEJbKU=;
 b=SIZH7fLVwgRPXu3KjxaCPADBn4UdOYNER0ISnPS0URqcAZQ2ZR1XWytsbcQt3LpxUpB6Ixc4cm8SHTFRfBbFM2ESyhex6yeLldXfCXbdTYE5XEbN8imabjaMhBJMQ+TCavtB3tMpNpdr9ajxWewFqYLU/M4EEldchHVUsCC7hn9W2BUmqpnj92NI3yByBkqScij/mSLLBQaNY79Pz9JXA0OACsA+EOnnV+sh8zr1ygsycGtJxd8gj2Uhf9V11fdlHwV8JvIiQgbZ7CkVEfX8FuNRFJT598R/OVeAWU7maHgqYILDRy98d1C4orvRyWyhzRzegM9z3MYmHmjcrv/Ylw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA0PR11MB7329.namprd11.prod.outlook.com (2603:10b6:208:437::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Tue, 3 Feb
 2026 13:54:19 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 13:54:19 +0000
Date: Tue, 3 Feb 2026 21:54:08 +0800
From: kernel test robot <oliver.sang@intel.com>
To: <sunliming@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-raid@vger.kernel.org>,
	<song@kernel.org>, <yukuai@fnnas.com>, <linux-kernel@vger.kernel.org>,
	sunliming <sunliming@kylinos.cn>, <oliver.sang@intel.com>
Subject: Re: [PATCH 2/3] lib/raid6: Optimizing the raid6_select_algo time
 through asynchronous processing
Message-ID: <202602032100.d8e49b6f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260128104923.338443-3-sunliming@linux.dev>
X-ClientProxiedBy: KUZPR03CA0019.apcprd03.prod.outlook.com
 (2603:1096:d10:24::17) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA0PR11MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 62ce0793-6496-4db0-2c9d-08de632bb9f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zUJtdQ+TKjZH9cmFHV1PKI14Z9hBYzN/Vo3Z/s+dAnCJbft/NAmX3IxtWw7n?=
 =?us-ascii?Q?yuRLgnPvY1vDZWhgUXEwY8dV/XY8ELYen9iMT0zw+trtX/mgtQ7QAgE5lb+Y?=
 =?us-ascii?Q?CWQN2cjWTtYvKq53wsVWVTPJKSGRRofhaG/DAWg1pj8XXYEMmdUrqfi4KVNX?=
 =?us-ascii?Q?FWnKFWbTTOJyaQ6Hb83y9VEH1PKOt62lGdc8E6m5B8w3i4VU3jjj/5Ir5SpL?=
 =?us-ascii?Q?VySQOD5JtOK6nKjlZquCdVHAQTbTtldsxrbb2/Sj+02JEKR2EiDJJvIH4WVf?=
 =?us-ascii?Q?uNLyRjbs2ESEuPAHX2HWsq34tW0OpeLsB+GdQ2u+fy5nnGKdiNgQgzpgwYqz?=
 =?us-ascii?Q?K4sRI98zHs8jBguMgPQZWcO1mIahhgjRow9oFyRNsprvJNvAbd2oRim85iD2?=
 =?us-ascii?Q?t9/jsdc33zYU4lDNo7Mo3r3bbS3xmP70kU89tr8jg1RnTgHFJ4RNhUYp9vUa?=
 =?us-ascii?Q?cMCWpxcSPERz5aZUaL+r+DLi3E69oykr6josfxvXz4uMC05kPUa1vud6q8d3?=
 =?us-ascii?Q?7hpPleOTzxJn5f+X6Mp7KZWbftuSRJkCWyOPOighpEi+10oJuCnBS3lIjBRi?=
 =?us-ascii?Q?167a0umKTHeLiAjKXIep2t8Nbf1NXWtSLB0VxAeDC/IfHM2hu7nK+CJBK/br?=
 =?us-ascii?Q?W/OqSUFPUeFNcTNys9NQe3Hl7wlxl8rVf6twDmlgN/tZbtNKJ14UF1466+o0?=
 =?us-ascii?Q?5+xI+qVhzu54XmZntUQ8Pu8p6n7L2EqDIIVOOpkhM0PWGXuFQ0IyRvhrRU7A?=
 =?us-ascii?Q?COIUj1J00q+QzW9nwb3qFhSClmbBbTC57iag7inWTCcnIXfSVxLVomDp9MtV?=
 =?us-ascii?Q?pCoDHjK4piaxslKEqCwI6dQj/KSiKh/3sGA48FsdmuaAAnTLzgCfnIZ/nZIQ?=
 =?us-ascii?Q?qNVU8Q7SRfoe6a21FPwbcuZxRd6P5uOiw6KjcrZzsVaZT3+NUgqmV/9tG3eH?=
 =?us-ascii?Q?b93orNq8j7ZO7obT0BEc2z1VBEXuDnoFmuAtnOaQOeauXyWJf26c3qccEc2X?=
 =?us-ascii?Q?YSyoTTnG6hFkprkU35pyGOtImIzrQCMDrPvTQaeemYCTXpznLm1fpqS9pjGz?=
 =?us-ascii?Q?z0lTYxBZ1/vNfR8jTHjVR0wYLysVq3lxuh3PwTnHaDNg1eQqdynG1ShD/1at?=
 =?us-ascii?Q?qyWtsLxZDWGFYD1ZFc2WELBQk8tPP6RyCScxxL190+HSonw8eDAkVoYfLqBw?=
 =?us-ascii?Q?x/m+M3bBF/xz/h2SvUrrN0K7PhatmpxM4xV08ApRPW1QEel/KuUismGVnO9w?=
 =?us-ascii?Q?QjKYXmJolSrq1PsBWbb7YFjMjyf62RplgEIOC4zpi1MranR+AEdzz+TKrltc?=
 =?us-ascii?Q?2HxLUqKVTg10YadXy/+eJX6vrnrSzb4nbUKKDQO0r/TWvNYTjLyWacDmy5/j?=
 =?us-ascii?Q?NiQ7NrgRtsv4yEMQHFzHgYouFVrHqBscQQdQf50DxoiWu+e+E+Bm6O6d8jl7?=
 =?us-ascii?Q?YGk6u8CSWT2mv31O2Lq20JBtocqWwTrz5iVJ+pSkD60CNRr/r7MLyC2YYdRi?=
 =?us-ascii?Q?50EkxtBjAz5/1SpI9ehqsii4HALSU4A8yklg?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7juaWJALIQd1T74P2P8+2bVIInTqufq7mp14X8EaOJLWXozx/yG9FS22lknr?=
 =?us-ascii?Q?+RkwQCMnLCdTRnXaz8Fqeslp/z004PZnaEYBkkYk6qleq9JpJ6ENVZWBXzG+?=
 =?us-ascii?Q?dyikkfIvyBFCEb0tdavlAtpp0bRk6WrzFnPgo603WAXOdgHKfeEqCcXrTXYK?=
 =?us-ascii?Q?KudQ028Hp9ypcviZ5wbjKrLxzVdxQYxGtOs2t+poIctfp+fJe5g/C79ZbeXy?=
 =?us-ascii?Q?PmCOyKGVUSMci2e00+b/b+4LSPPGU+21lfmW7UTu2GK2rtaCrXcr6Zz8swN1?=
 =?us-ascii?Q?IazydvLrOUFArKJulIL5PQWXwcYaUCWdEwxIMQNk+EtwgIafinUopfF8G4Jm?=
 =?us-ascii?Q?Y0dCmGeYSw9kfTFYbRhuXVEA++EsWaJRM8JFVOlZIZhgpSvTuIhe/KyooA3m?=
 =?us-ascii?Q?KU7Q0UeDnbzp731tYu5ysgR3ItGot2dSOV6XwNd6RwqZ8cAhtjLC1Hirj8DD?=
 =?us-ascii?Q?Y8xAh6kpHItAu/yrkoJt+zu0HPJ8/pSi5d2hD3FCM6bP7BwIgl3cSMphYtIQ?=
 =?us-ascii?Q?7zNhquadsSbsEL/jBvwhdkoxnsX0hdA23AGpARXjM7+qXw9Bpj+J/cftRzPj?=
 =?us-ascii?Q?aviwnbSK53633E8O3QAegWGQsQ/i11v41lEa4nIIEPa+ZST6qtCvNBy8vNud?=
 =?us-ascii?Q?EjzINW/MwoBYt+sNKNp0UQIssMsmTydVdorcUoaXz75BQqN3xleqC8bj25DM?=
 =?us-ascii?Q?vyfKbeV9xDA30F8yTJnvlaJ7gDrKSJ2Sp49lb9pO8KlrRG73ok5TPFSC6Mju?=
 =?us-ascii?Q?F5bGMLMl6ahEit12JK5R3DixYhr/zM5xc11Kvkjf1mUw88DaXs6e6aKHTRXz?=
 =?us-ascii?Q?xolJdwoSjRgZdPVGwiuxXNUVzk8/XStemI025ih05hYBqKNRSmMwINKEspii?=
 =?us-ascii?Q?kkmgitjlxSdZ3CGw/iiiXxAJO8U4iZrksmJxrQMTeqcvD+JrOzZSY3x+T0mA?=
 =?us-ascii?Q?TEkvoIo9Z9v8I7KqOrq8xLDGo6vtojIWL9HaWsfODCAFZDA8U1avQZb4tACw?=
 =?us-ascii?Q?4U2k6dVdGAVPy4mioEOAQR95EhPeOHY1znr4KBVnw9nzOjfwMxOKPXjmbzMV?=
 =?us-ascii?Q?XpFtmqjLMBOcP6NQo7c7zU84mpwei9kSIjd4Nqzjt1sQI/83T/n/yOGRt0po?=
 =?us-ascii?Q?yu6pH4EyaDhkdqM0l8eCIZ8hCgrkQJMIK7bhtzX+mj0lGrjl5uVGPuHR7sYi?=
 =?us-ascii?Q?K/bPchAsJypqTQEXWfCP/GhJqSgGcdYYfYEHcgTYZQTZOEs0kSvryr7DIYm1?=
 =?us-ascii?Q?2ymwnipLW0s8WanEOnljUAsfwuh2EfTPeOXcR8Jv0zBI0l7X4uCRWKWnSXdG?=
 =?us-ascii?Q?QFusk/rZ4bc8L1IxQ6i8xZKYJdaF7Dq9th9oX+jCt/yzx5gLsV3j1l6brQUD?=
 =?us-ascii?Q?aoo+aC5LWY9CQ+43YdwBvEtedE++zF1ng9unQOlcPhEoZ8nOafWSjY21LUnG?=
 =?us-ascii?Q?PsVvEpCWGomRTNi7jDYMu3Rcbdeeo+loxh2uaAdYzY7I3ktW6XVW99mh3JLV?=
 =?us-ascii?Q?I4MreYacr4Sz3qwSTQN4pAC/0OL0ZZAJcmP6IDRbI9sa9mdLOa8CPgPVIgdk?=
 =?us-ascii?Q?sF206+XOvFhAvl3hmC98M4rKSvvo4VsG3xFPrCuywRM1b+7+A8FhkdR3Yhkf?=
 =?us-ascii?Q?u3YChE/zsOrg0i9GxTyv73cyYfZdh9xpzNcn4A/SRVksYhkVGEzPWq2nzZA1?=
 =?us-ascii?Q?xzivU9VZAdU7FFhRwmod5WvwyJO6STEYnQOL7v2YT+hp1qv6FZXzd1Y14D4P?=
 =?us-ascii?Q?ERa8vjwe1w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 62ce0793-6496-4db0-2c9d-08de632bb9f3
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 13:54:18.9740
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QFSksX/uppo0DgrkvBmMInCXfMQ2lr1CHD0GF1RuFSAttF35HxpZtYpqmyX0Ex1gfb8/Cwnm5NtxY8wtEby3Aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7329
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "Oops:int3:#[##]SMP_KASAN_NOPTI" on:

commit: e806b74f91ad2c995a3313d4cc369c85fab1da5f ("[PATCH 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing")
url: https://github.com/intel-lab-lkp/linux/commits/sunliming-linux-dev/lib-raid6-Divide-the-raid6-algorithm-selection-process-into-two-parts/20260128-185709
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link: https://lore.kernel.org/all/20260128104923.338443-3-sunliming@linux.dev/
patch subject: [PATCH 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing

in testcase: perf-sanity-tests
version: 
with following parameters:

	perf_compiler: gcc
	group: group-01



config: x86_64-rhel-9.4-bpf
compiler: gcc-14
test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz (Coffee Lake-E) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202602032100.d8e49b6f-lkp@intel.com




[   81.117339][  T479] xor: automatically using best checksumming function   avx
[   81.122258][  T109] raid6: avx2x2   gen() 17654 MB/s
[   81.157936][  T109] raid6: avx2x1   gen() 10371 MB/s
[   81.172813][  T109] raid6: using algorithm avx2x2 gen() 17654 MB/s
[   81.205659][  T109] raid6: .... xor() 12927 MB/s, rmw enabled
[   81.221136][   C15] Oops: int3: 0000 [#1] SMP KASAN NOPTI
[   81.221144][   C15] CPU: 15 UID: 0 PID: 109 Comm: kworker/15:0 Tainted: G S                  6.19.0-rc6-00161-ge806b74f91ad #1 PREEMPT(full)
[   81.221149][   C15] Tainted: [S]=CPU_OUT_OF_SPEC
[   81.221150][   C15] Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.R00.X188.B13.1903250419 03/25/2019
[   81.221153][   C15] Workqueue: events benchmark_work_func [raid6_pq]
[   81.221160][   C15] RIP: 0010:benchmark_work_func (recov_avx512.c:?) raid6_pq
[   81.221163][   C15] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
All code
========
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	cc                   	int3
   e:	cc                   	int3
   f:	cc                   	int3
  10:	cc                   	int3
  11:	cc                   	int3
  12:	cc                   	int3
  13:	cc                   	int3
  14:	cc                   	int3
  15:	cc                   	int3
  16:	cc                   	int3
  17:	cc                   	int3
  18:	cc                   	int3
  19:	cc                   	int3
  1a:	cc                   	int3
  1b:	cc                   	int3
  1c:	cc                   	int3
  1d:	cc                   	int3
  1e:	cc                   	int3
  1f:	cc                   	int3
  20:	cc                   	int3
  21:	cc                   	int3
  22:	cc                   	int3
  23:	cc                   	int3
  24:	cc                   	int3
  25:	cc                   	int3
  26:	cc                   	int3
  27:	cc                   	int3
  28:	cc                   	int3
  29:	cc                   	int3
  2a:*	cc                   	int3		<-- trapping instruction
  2b:	cc                   	int3
  2c:	cc                   	int3
  2d:	cc                   	int3
  2e:	cc                   	int3
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	cc                   	int3
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	cc                   	int3
  3f:	cc                   	int3

Code starting with the faulting instruction
===========================================
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	cc                   	int3
   8:	cc                   	int3
   9:	cc                   	int3
   a:	cc                   	int3
   b:	cc                   	int3
   c:	cc                   	int3
   d:	cc                   	int3
   e:	cc                   	int3
   f:	cc                   	int3
  10:	cc                   	int3
  11:	cc                   	int3
  12:	cc                   	int3
  13:	cc                   	int3
  14:	cc                   	int3
  15:	cc                   	int3
[   81.221166][   C15] RSP: 0018:ffff888101557b58 EFLAGS: 00000282
[   81.221169][   C15] RAX: 0000000000000029 RBX: 1ffff110202aaf6b RCX: 0000000000000000
[   81.221171][   C15] RDX: 0000000000000029 RSI: ffffffff81513d9c RDI: ffffed10202aaf5e
[   81.221173][   C15] RBP: ffff88836aad0000 R08: 0000000000000000 R09: fffffbfff0b21df4
[   81.221175][   C15] R10: ffffffff8590efa7 R11: 0000000000000001 R12: ffff888101557bb8
[   81.221178][   C15] R13: ffff88836aad8000 R14: ffff888101557bb8 R15: ffff8887887c33c0
[   81.221180][   C15] FS:  0000000000000000(0000) GS:ffff888801e6a000(0000) knlGS:0000000000000000
[   81.221182][   C15] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.221185][   C15] CR2: 00007fbfb077d000 CR3: 000000084d2f6001 CR4: 00000000003726f0
[   81.221187][   C15] Call Trace:
[   81.221189][   C15]  <TASK>
[   81.221194][   C15]  ? rcu_is_watching (kbuild/src/consumer/arch/x86/include/asm/atomic.h:23 kbuild/src/consumer/include/linux/atomic/atomic-arch-fallback.h:457 kbuild/src/consumer/include/linux/context_tracking.h:128 kbuild/src/consumer/kernel/rcu/tree.c:751)
[   81.221199][   C15]  ? rcu_is_watching (kbuild/src/consumer/arch/x86/include/asm/atomic.h:23 kbuild/src/consumer/include/linux/atomic/atomic-arch-fallback.h:457 kbuild/src/consumer/include/linux/context_tracking.h:128 kbuild/src/consumer/kernel/rcu/tree.c:751)
[   81.221203][   C15]  ? lock_acquire (kbuild/src/consumer/include/trace/events/lock.h:24 (discriminator 2) kbuild/src/consumer/kernel/locking/lockdep.c:5831 (discriminator 2))
[   81.221208][   C15]  ? process_one_work (kbuild/src/consumer/arch/x86/include/asm/jump_label.h:37 kbuild/src/consumer/include/trace/events/workqueue.h:110 kbuild/src/consumer/kernel/workqueue.c:3262)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260203/202602032100.d8e49b6f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


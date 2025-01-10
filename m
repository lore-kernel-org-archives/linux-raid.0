Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFA920B80C;
	Fri, 10 Jan 2025 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736521727; cv=fail; b=JVHWKAu65hEr+hmTVLMntWtel6GYwbcq2OcrLggsjM14fW2VXIQ/eVuuCcYA0npAxX+1pW3Xlek+f8JTm7YGo103b2W4F1Aj7RWGeWtYDzKVwnhZ9HRqWccWsSWoOHWaxeGxgRlwSM2K8CC4xXseTrqfbHQlkmJ50uAPDtZWRsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736521727; c=relaxed/simple;
	bh=VX5MsxX1Ign7e2aPv04zoWGJ1Qh49k6FK8K0yNo/jIg=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Z70gEoJcy79PwXpMYnjtNZ6oTZEP+vbvqlVym2HwFmL7yViIenuoipvcm/7zjFRIi7KMD6pMpvK31onI/MlPDhpSHcab3coui5w/Y/J01gxCxy32y7WV8kWxOEbly3xbBDIY8mDuougveIzPjJxgzdqYg7vGX5//r9WKrtssBlk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PgT5WJek; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PgT5WJek"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736521726; x=1768057726;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=VX5MsxX1Ign7e2aPv04zoWGJ1Qh49k6FK8K0yNo/jIg=;
  b=PgT5WJek5oR+oH/D7ouF0K2qmkzzw0IGOCD91fHY3+RVWWqD6AMHQ6oa
   28nPow8h2KC9nNnXV2ed3U8iFjF3bt5OGj+jbOTXjXwx9BiFSlH2+EOXL
   gnEUHOHfQUiqWjtFu9ERodpq4Tp9D5CZgPMunoKUoQS/Cie5haJ58VgXi
   mD93GzU5yMm+XZvy5fKXPa5ThEQa0q2kSFfL/zZe2VLfURCfSP4I71aEf
   EN+5ncAnX0oubVgmJTjy/8HPMULd7VdURZ3jI+7vU7HL8DjDFun7N615d
   BkSUOU+nZM0IR4mR8354086DHVZLI4kJT0E36HUMl/RaTKN35ob9tpvyQ
   g==;
X-CSE-ConnectionGUID: IM07hpLwQReySnjQR0uu7g==
X-CSE-MsgGUID: WLN2Yg3GQoCPYqcUE/blpw==
X-IronPort-AV: E=McAfee;i="6700,10204,11311"; a="36926568"
X-IronPort-AV: E=Sophos;i="6.12,303,1728975600"; 
   d="scan'208";a="36926568"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2025 07:08:45 -0800
X-CSE-ConnectionGUID: 8ahJWyXnR92tIaMsH4jlNA==
X-CSE-MsgGUID: LeaK3pz/Tiyr6F2mhkI/og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="108800422"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Jan 2025 07:08:44 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 10 Jan 2025 07:08:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 10 Jan 2025 07:08:42 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.49) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 10 Jan 2025 07:08:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cdhLPs73dRLWbCFg5+gM36lMMiZSmGgGClXsh2m0RAQOD0AC//pb6irGoY6jdPconTzOLvPsLVwm+0D7bO2mYf6Gvw/BiG/OunlJcNu9HThGQ8VxX6m1IoZuBqe/7pdds7dlGQinJhZZFQHE01yLnMfdF72FY1W+Y8d+Mw/zXU3IkbUnvsFTLzf/g1M9T5lMrPmrauPVI7rNjqWRBMKObrEefg6qz4vIobm4eIybIsZEwpJk1eaUvgm8s5SYF/he4i/cdI/uL1WUU1T277YrsMfBXZB0bGsy6gs9AJokdKATJ/+d5Ijgdl/92cOV3n9AIiS+dzGRzDoUIuRXh48/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aRMibW0JkD+NkMbD6YiSBHu3YARE7RxHZWhoo5L7wb8=;
 b=YvDz1PWKf91FywoMnNnJB8KYtLWPcCbWTnXXz1vflKqjsesz1PLlQg/Ki4ts2+EU8aseJ6kJAiktNZJiqA+pxCyGw69QYvKmdHslyvxUaz+O4BQDhAincNP1LDreGb8oeAtmGRSa+WyxaQpq8izJCVVFioM4zIPZ1CojCsfL+goQMzLLaBgUDgF78lpxaFjG/MpmSo8yWk587m8zO1Tb/aPUhH9a1tKpa90sWfdWP2t5C0GtYDxqB/CpvHtDzp2Uj8fd3EObkkPJQQHKNwu2HAY6KAT6w4gGQ6yyuYPyt/dN4mvkLZ+yga1Tfo+B+ixAvpzyZNvmIfwXFhdBpBX83A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SA1PR11MB6733.namprd11.prod.outlook.com (2603:10b6:806:25c::17)
 by SA2PR11MB4825.namprd11.prod.outlook.com (2603:10b6:806:111::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.13; Fri, 10 Jan
 2025 15:08:39 +0000
Received: from SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57]) by SA1PR11MB6733.namprd11.prod.outlook.com
 ([fe80::cf7d:9363:38f4:8c57%4]) with mapi id 15.20.8314.015; Fri, 10 Jan 2025
 15:08:39 +0000
Date: Fri, 10 Jan 2025 09:08:34 -0600
From: Ira Weiny <ira.weiny@intel.com>
To: David Reaver <me@davidreaver.com>, Song Liu <song@kernel.org>, Yu Kuai
	<yukuai3@huawei.com>
CC: David Reaver <me@davidreaver.com>, <linux-raid@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Krister Johansen <kjlx@templeofstupid.com>,
	Ira Weiny <ira.weiny@intel.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] md: Replace deprecated kmap_atomic() with
 kmap_local_page()
Message-ID: <678137f2106fd_167faf29436@iweiny-mobl.notmuch>
References: <20250108192131.46843-1-me@davidreaver.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250108192131.46843-1-me@davidreaver.com>
X-ClientProxiedBy: MW4PR04CA0203.namprd04.prod.outlook.com
 (2603:10b6:303:86::28) To SA1PR11MB6733.namprd11.prod.outlook.com
 (2603:10b6:806:25c::17)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA1PR11MB6733:EE_|SA2PR11MB4825:EE_
X-MS-Office365-Filtering-Correlation-Id: fca427cf-a041-4bbd-7d62-08dd3188a9d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?ndacynC6W4WQ0fPF+aOgUT/rR9d4ZUqzGpdHfH4AHu9YuWbYLuHuuY7vViIZ?=
 =?us-ascii?Q?VgIkbzXv9+yFHKL4G9/vZEN5CXkjc1U6aUv6rNkOtQO2IMaT/kvVFwfJyH9r?=
 =?us-ascii?Q?kmjK88nWxFWsDLcUmK1l6Hz5K65VxC52VVPiwbY/Nk3Budrq3LnYPRj9qDlE?=
 =?us-ascii?Q?Q84nkqodc8fb4c2A9v/kEbTwWVgkZlk5+liFhftwfTPTIuiwjQI8FdIIMwjH?=
 =?us-ascii?Q?CJ1uIwmGDD/2E0xNU6HkLZR3ssgWd4Y7xEaphS/iXZuxmFOiY7ushWPipGhI?=
 =?us-ascii?Q?0795AM6HBX6J/vL2rIPfgOWslKbLBTOJqpt/DBz6XakTF8X4Yb19DWrWp2aH?=
 =?us-ascii?Q?ppP1KDbJcSK1phLxbw8bXPgH0gCgICwMsW0EPL56AXkwSalaY0nHr2z6MZ/p?=
 =?us-ascii?Q?ctDUay3MSm7NuAH92EnxJxxlSZBuZvNMBlFt4FumyVzBm1sAE1PcPUEnWzuY?=
 =?us-ascii?Q?YICC1cm7cR4xQVAwpQysU57yRFQezw0tRhsbgIr6KSu0k4M7GZz0wwl+i3Xi?=
 =?us-ascii?Q?6gUKnCEtiBRGdxLUzI38Jl70PCQGwI9Rr1K/zvYrhlFxVBfEFGSQ8dMsqYv9?=
 =?us-ascii?Q?mr7uRAZueqGXW/TXukHCSu0sBIlGW40nGtKYwLUkMmrqcy10ZGbq3gxWSKgz?=
 =?us-ascii?Q?GwffgceBrgX1xYOkv5DWXYFb0jCNYGO7TTvNbPMiQNDkL1jYBkUgstJ6P6Dj?=
 =?us-ascii?Q?0eYvRCFPdoG6ixFGf3D2qI7eT3awqlz1AX2DrkrCDxTass9gt0xAyM+yg8g7?=
 =?us-ascii?Q?C09mum4RoSY0QOJdcx4gIQ/YoUmoS0bfF0ROjzHaAto4zhPb2A09b5E8W44s?=
 =?us-ascii?Q?egMJB2znLSueBLyhTWArS3uDarAkWzw8kSdG8JI+GK9zy//V4A58Q4SQb0ME?=
 =?us-ascii?Q?J1+y3RSRRK4otgSVvLfxNjta4ofBoYZLrw90idR9FUTf9AX7lCQkVKtVHQER?=
 =?us-ascii?Q?n6AeOGjvyt5C8nGAAOqy07xxoC7s4XxISuArOhvv1Ace3R6ugJCwMh03STr7?=
 =?us-ascii?Q?DomgoSvHJePDHr8JKa/OQDFyri5bBzWonF+uv7YHTfyRpstD9bLn64nyKdRv?=
 =?us-ascii?Q?wcmDG4f5G/FdvN9GOP9gbjmC8l42VcAFYWUVYbwvzjcv+VOmyH5J1GsUz8Lx?=
 =?us-ascii?Q?t2OFc392v1GBbeixl11j2Wd7Rs1w0ZxPJCcJ6/vAyR0Fcjn4x0tScdFW4PnO?=
 =?us-ascii?Q?AZSfFQoAY1TGruLzBvWmqnwOofUb1xyrb1GU1G3cZCrCuwTQKmpiz5UCTDor?=
 =?us-ascii?Q?VC/WfapNXgrJT320kAwy+q2UyJeXIQP2tZtukHGITUu5ngIn5qyRl9yQ9t+4?=
 =?us-ascii?Q?Z6qeSaR/JsGXWCc6JiuaLpnzyPG2/cRHeu70KDUf4phj1Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR11MB6733.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n7hwtWNJnKBfI8+SRCIuYnn1dyt3qht9MOovQyRBl0XchVO0B2E6DlWzGV3d?=
 =?us-ascii?Q?t7BdkoEGfYBQ/SEai2+FHsFUZrLnurmCGFMTo/rR13dVwkfkTzoNG4M2vu2U?=
 =?us-ascii?Q?aVuZNQmq4RwhPCmm9H5g2y8fjVq3IVfy8gzxyncOqILGsvjTFqCeNFfiCmJT?=
 =?us-ascii?Q?PzjfQ7koLK/Hw1kWgjt6rY1usHwC08QuWLr7kBh51bykhPlgN1+NYwscDdko?=
 =?us-ascii?Q?JqxjqeanuIMDSn/pOGp1YjoNjGJTk+6JZYgt0wv5v4Dl/zmTrOqNXZ0RXnXp?=
 =?us-ascii?Q?iTQx4QgrkbIrizOzAQkI2E8klBp6xIgTQUBU+bGwAyynoKtJmFAOHWYPuMbz?=
 =?us-ascii?Q?ua3xYmzz8u42bdMQL4IzML1GirTuuuAVQ+aOseU4NkEr8I+rd6MhG0Oa6cwv?=
 =?us-ascii?Q?B1RxuyaP3AFQ7KUlRDKDgbhlUudHTPop6lL202HkjPEph0QeyxXEU+tpWpoq?=
 =?us-ascii?Q?JchOxfJqsIcqw3lrwf5hIR6UOzX9sVRTl1UrexhPH3q465aT+2+2djYMRspv?=
 =?us-ascii?Q?S+SWQhX5rBg1BKV9CgNGEwtgeXJsKtLEAGe8SZeA8BynmfK9DguZJVLYTHOG?=
 =?us-ascii?Q?w08gebApCwHLNCuVZYC4+tI/Bs+T8/RGvfLlWHt+bLvBahmYQ1sot+DdthlM?=
 =?us-ascii?Q?Xidk6oJSwFQeJDYkQj9tlfuslFIXG+CWZz/DbRhSJ9wqgUNzTMbalk7b51WP?=
 =?us-ascii?Q?rMvDhNaMDvtX7ucEgCqjsayPOPcy0EfreIsDR7g0Zr0bg8EFqqenONQbxrGE?=
 =?us-ascii?Q?7KCet45GNpnjNnuMfZnfFo8cXhXbl8LuYz2xiwj/6yJobCBhRln7jTz9sbay?=
 =?us-ascii?Q?S4FriJXmAudxtbS7MG969HY7q6Uh2LiKGoME7HEFcwbvepZgWxjssCvixlX/?=
 =?us-ascii?Q?OHJJW5dJNhYcTFw+OQfo3okzv74YdtmskSk75eUQJVExwjOks+593BYBrtZJ?=
 =?us-ascii?Q?Pvn2aYtm+JCyRqrbe8GdELrS3sXfFSnzW/5Q6aK9XX8ZWHfaUWniE5kKrFfP?=
 =?us-ascii?Q?/Nc2c39qh2qe8LPZlUH3yqgMOyEyPPBJsCE6YWZSJZi1JKSu/qmnFXWqomIL?=
 =?us-ascii?Q?4jbpuMGb10D9pFuyN2Kw4+G0RLVTYaxxZkQBnZJZKfpn4//M/i78p14L0GEQ?=
 =?us-ascii?Q?Hn8mnlUB5CGog+JD11fDKVlNR0CBHd4mPIlSyOsSzD3SVvPPQV8hZScb9xLq?=
 =?us-ascii?Q?McZne0G1jKXduLJYPirkUxsj7V/Dz36vKf+hTQ5FV0dTUm9vevmAVV2DXvxN?=
 =?us-ascii?Q?XMlWWKR2Fyr8wMXdcSUEvfLGxQNxASAM42Aqyj5xNtRlxeb5fyqblP9Y2ZK5?=
 =?us-ascii?Q?wSy26kUhCuelgB6Uq/woH2uRYq+xLRT/ddQSq1raDGOQfQ9j2warYlZM2tiw?=
 =?us-ascii?Q?pKCXlIPZYbw9VrTUFWUC62k+6wkRFJ6L1NtrQs2K9TnEFtGeMr9iPnvoE4Jg?=
 =?us-ascii?Q?JU/aNnCollCzjoypJY5xrzmezEFZxQq+TDx0ckgjDBQKVeYQxNhrcAt62k0/?=
 =?us-ascii?Q?CvPxbqQttu9KmCHEDYTOZeJlJHKoCrRrDgzHFZWTsxEtEH/IlC1WtyHSOQaJ?=
 =?us-ascii?Q?Z2U+syfFunbqGvAbyw5kEaHa9ONOMoAcFeVVIfQW?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fca427cf-a041-4bbd-7d62-08dd3188a9d2
X-MS-Exchange-CrossTenant-AuthSource: SA1PR11MB6733.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2025 15:08:39.3329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7nfb/wHwvvAYR9iPTeswv7MvhpOK/h5VvNtFI4C7sPzHtNXIv51zbUmDh4bPRv3ohG9S64UkFBiphkhmfJDakg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4825
X-OriginatorOrg: intel.com

David Reaver wrote:
> kmap_atomic() is deprecated and should be replaced with kmap_local_page()
> [1][2]. kmap_local_page() is faster in kernels with HIGHMEM enabled, can
> take page faults, and allows preemption.
> 
> According to [2], this is safe as long as the code between kmap_atomic()
> and kunmap_atomic() does not implicitly depend on disabling page faults or
> preemption. It appears to me that none of the call sites in this patch
> depend on disabling page faults or preemption; they are all mapping a page
> to simply extract some information from it or print some debug info.
> 
> [1] https://lwn.net/Articles/836144/
> [2] https://docs.kernel.org/mm/highmem.html#temporary-virtual-mappings
> 
> Signed-off-by: David Reaver <me@davidreaver.com>
> ---
> 

[snip]

> @@ -1387,9 +1387,9 @@ static int md_bitmap_init_from_disk(struct bitmap *bitmap, sector_t start)
>  			 * If the bitmap is out of date, dirty the whole page
>  			 * and write it out
>  			 */
> -			paddr = kmap_atomic(page);
> +			paddr = kmap_local_page(page);
>  			memset(paddr + offset, 0xff, PAGE_SIZE - offset);
> -			kunmap_atomic(paddr);
> +			kunmap_local(paddr);

For these we defined memset_page()

With that change:

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

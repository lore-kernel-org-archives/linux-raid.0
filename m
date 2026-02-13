Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A28347DD;
	Fri, 13 Feb 2026 02:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770950072; cv=fail; b=bcT4Pe7Cj5H1XRukqbd4opk/Mkfbn3XlCkrfqXlIDcmZwUXT3WHdkYCJD0HEJhHiVGP6FXpY3fyLedO5mEK7VhDjhaM/T57YUeQX2PJtsCa8BCW2AXZZfyvdFhDzmDzobstGp9+fuOoOcvkP89pZos8ahzcNy72inUXhGv28hhs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770950072; c=relaxed/simple;
	bh=M/QZHxMaMYApG7LG0Iom+FwEsVYLc0C0RFUnw/FI4To=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=rcVouanbRn5NibvQYFlbCRvBiTlErVJ+eGoZc4ILFd7d6lIIxbYlN3dkq3Ug2NPnclhKzn8IT9lK3hO23aVvXjhs2lOUsmIOypSy2qE/gytoTd6O/RxeO2SOkH5nxh+c3sYtVGnwy1Sj5ccOX8J7EZ37SSESbKrXr97T8ah2Sm4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P9HywcSx; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P9HywcSx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770950070; x=1802486070;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=M/QZHxMaMYApG7LG0Iom+FwEsVYLc0C0RFUnw/FI4To=;
  b=P9HywcSxfCXn7jYzSNzTW+4OcNPzDRwHxNmxYcsf/wNGPkpPlmYDfw2P
   LeVbMfQ1X7HJNhieIai0CmgA4GxRcaLHhB8myJKJUayUcK0JPrE2nVNF8
   i5T+2qYYv/jeruMzmYHbsUZpfAYOtsXI29SRjVyetjuFBjJkqVugHETSg
   Occgv2IsOgBHxbCs3/s//cSYNNWhIyuZdVFVPMR7A2FClMN2aQKUzDlcY
   S7gGpF5U6AFWvEHxjbTc7wIML74K/qZY6GFhCwWrqbP64HbIKfwpkfOJW
   hZrFXiz/EOGUKAxK9M02H0NRu6/HLlTb+UvMbsBpy24UhNQ5hWUwXeqjQ
   A==;
X-CSE-ConnectionGUID: XAYLKA9hTK2hGM3/Xgl4Rw==
X-CSE-MsgGUID: ZfbH14zuQI6QmBG7hO4Lgw==
X-IronPort-AV: E=McAfee;i="6800,10657,11699"; a="72028182"
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="72028182"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 18:34:30 -0800
X-CSE-ConnectionGUID: oKT2LXPJRV29c0cyKgSrtg==
X-CSE-MsgGUID: shGeDhLRRDm50Y7esMsrHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,287,1763452800"; 
   d="scan'208";a="235767300"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Feb 2026 18:34:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 18:34:28 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 12 Feb 2026 18:34:28 -0800
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.48) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 12 Feb 2026 18:34:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=djOYoMyTuHWUHOYlYWuFvbSQ1BWtfQkGJOAAJoxQ4t/7hUZz7Aur8iDMH4ilgfD2SyDk/HtjuJJN5NsSPTI0/Kw4SF9/3O4p1XLumyys5txeP0+Rn9GDFtC5qodeM4/ux1om6z/Xsl2uBkY9T7PdOSnM0Ka9hw2DHYHBn/auIjIeKNVYyGGkRUkYulJWIvDnPlax80Ugw0sYDQqlwyEutLRCXrHje6hyYbYvik0fll5870/irqF8hA2ImAfNpTTukmUKvRiHNZB5cJn3nmez25XosczvmVdtJocRP3Ig+XAuYbK4vbbnPn61DdxEoBzkvYyM/AS43LwwpodIfHy8Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zRZkvjx4NOxu+Kz3Kskm+cutGjAAuuCnRHJGGOXcYo=;
 b=YZ/jMsoQhr1E6X4VPDBwgR1CAnf8IjflGBhxOq7qQx64J/rq9z9AFvYeHSw+svVbG6GDwT/616bQYcofPxYIj7AqInIYC5xh38mtlyOcHektdQBryVJAKSSOy92YQqYxy8NZlt/hBZ4I5FRhstkiYQ0sxkfWuuzdQrwjDLIpNqlqM3Or3qGhilKYrP0gKK1hWuHIIrbukJQ0mijtTFgSTP3JzAYS476MOEWSERkejxp4t7c1DobWD922nnp8JNGgHj5kKA2JoBTYSWkCiuc09WmbsYmhHnv6j6MxL9pquFlXUfOGz/QJtOTZMz9gGwa3EnYbAA4pafV72fZ8EIhdaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB7823.namprd11.prod.outlook.com (2603:10b6:208:3f3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.13; Fri, 13 Feb
 2026 02:34:26 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::e4de:b1d:5557:7257%5]) with mapi id 15.20.9611.012; Fri, 13 Feb 2026
 02:34:24 +0000
Date: Fri, 13 Feb 2026 10:34:16 +0800
From: kernel test robot <oliver.sang@intel.com>
To: <sunliming@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-raid@vger.kernel.org>,
	<song@kernel.org>, <yukuai@fnnas.com>, <linux-kernel@vger.kernel.org>,
	<linan666@huaweicloud.com>, sunliming <sunliming@kylinos.cn>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time
 through asynchronous processing
Message-ID: <202602131016.5ce5a38e-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260206054341.106878-3-sunliming@linux.dev>
X-ClientProxiedBy: TP0P295CA0017.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:5::11) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB7823:EE_
X-MS-Office365-Filtering-Correlation-Id: 96a12cf2-f725-4517-2d13-08de6aa866c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Ad2DMZjFZe/eKYrClao4d6Zbwisv9SXtGTbygD2EOQMlZurOFj4y32aK9wtO?=
 =?us-ascii?Q?K358As0rPRiIBGx0NfNDiHdHfw3tGJBTc95z/rYcbPKqlhMCLJ4EMx61npGU?=
 =?us-ascii?Q?L+gag/ocQPCmAxBc3tP/iBm8IOm/Xney2hmhg4wzWd0Yz34O7DKr1rEM7dNH?=
 =?us-ascii?Q?XfP3jIUCQvs/aeVZJNmZdbsDKTr4jzx/djWJBAb6RO2qov2I9ygXAivJkhgK?=
 =?us-ascii?Q?rfKfuyvrydp8oWTQXNOVnBhEQCRjzerM1XXZb1S5hTYCH2JWDZJ1zmgZEOQ3?=
 =?us-ascii?Q?Ob+xESz2tG0tyEaaRv3gZ6QPWQSaYcq8nVaRdSox3JLS6ZM4iY3qrtKoXa0D?=
 =?us-ascii?Q?Mhqhrm+rOTCGZILCcWKSCu+c0/dewXscmRYul8zIdhE0q5amWnMADSu2BiKd?=
 =?us-ascii?Q?Jh9UcuU/XL0WRc3TFjhzIYWS0RE3majduxostdiSe+2/W0/ZSEEVepSoHtSM?=
 =?us-ascii?Q?OAlS4BKd266Dy4qkBNLGYU9bW1xi8fQXWxle2Gsh/sTPtKJAeAQoNRk9DQg0?=
 =?us-ascii?Q?1MJY8vaZX8C7ynE1X/SQ63Sm7Ac3naeF7YmNvqwRJGpNNTFIBIuCbBm2jdti?=
 =?us-ascii?Q?x+H9SvLTBUIOsUVThAzSrjDu/H/mgfdtoOpOAUH6i0K2IPI6N2/oD0j4hvTs?=
 =?us-ascii?Q?WJeTvJx0gO5cmpFyLg0z7n/Nf4kokkDRmoT8nC7ycDWt7mm7M6E2v2OuGVDb?=
 =?us-ascii?Q?GMYCk9BG+wDyXrXKwnCrrg5pFNV8mUHbWdUcn/uMvHHiF8xZIo1V/+xSdsHd?=
 =?us-ascii?Q?k8MhS49IpSPRRmsvtdntlydpmkaaTlNf1oEZKbvdXlI9eOd7TAA6a2IUkXvo?=
 =?us-ascii?Q?YrGJfEhxF48gGqRTTuRsHyamM0oPPRwwLbutcQFCWbE6l0BbwC++WBvUuy5J?=
 =?us-ascii?Q?Js+LPb1CDE9gcQvTKtVzRIJT92bo0x0nfy4Tr4ADrEmpug+6uXHVPOhYRDrN?=
 =?us-ascii?Q?pKnLijkCOke7ixmqML80ZfdwZMt3G9QIIRiOERUbbPTkRMKmeAsmqkd8DeMz?=
 =?us-ascii?Q?8k3PXXF6E6ZXxOWOraD2azrCByvK3cWjt6s5zddZug6TL+5YDvcuxcTXooo0?=
 =?us-ascii?Q?NuUd6JlCBxmSTv9w1kQffPxBcvadmCgAbfwE2R1UWlcLtdb4KKII0PqUB7wU?=
 =?us-ascii?Q?rLusWIFGFOqkwVwxXQYBa/lB4pziOlS0McMknPVvU0KRPq1QQiol5s033sMB?=
 =?us-ascii?Q?K47i9NXhYhM8lsUmePdQQZPtqbf2cuYztbvEI7DsKuW+rIMDYZ2oRTuP02hb?=
 =?us-ascii?Q?oRbVDtfkUUqslk/j0qeYnT3XGSZBouT5Qd3OzKNB2KFoaHG/F0la6gUpZ4Ux?=
 =?us-ascii?Q?L81SD2qYsS4PQ+c18fe+iykAivQCwmPvlSVUJ/HbF0GnrVuErmPuhMETBmxC?=
 =?us-ascii?Q?eUmqYeNvqecEg4uUtRBn5H/oqToLGugWYqhfsWPICxA0FiKiDkA3LzeIkPeu?=
 =?us-ascii?Q?HXHvj/ls6ui/iswxVpzCzkfTBQEe1RSMIZ5LfkOQ+wQW91qoIsWlnJ3tszTq?=
 =?us-ascii?Q?XDyAFnvbBwOwkH3PszpEtWtgtm0A/s4JGlkc?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FBPKGnFiztiAH7Xr8jpkKPoql8Qy0hG2oj2Db0iYxHCdzhKg5xdOXUN6iXlK?=
 =?us-ascii?Q?1itZZsG5oNS8Ec7Q63MReiaSXUiww5WUeWKdzw3ccZtCY//unFw9/WkyM0cx?=
 =?us-ascii?Q?KPGv2+5A4AxjUXd+g4eWYPqnWspbOf0vQON+8zvDCVTnysKKGXR9IJ2kFtb2?=
 =?us-ascii?Q?BPXwevisGkQSMdsnFZuJ35WxnU+uLWf/jwSj2MCtlWKGkX6KwDevhJJ+fItg?=
 =?us-ascii?Q?o7vIEKAjFbadJKKdWIgrnWCS7AOygPIQY0qh6es3hOWqkSJVQDmVQpcyN6n1?=
 =?us-ascii?Q?UqQCeMyXC6Zc9jUz6iHNBtcR/4s4Jm+ULJchSK49CI7wITRXuGsER9QuJAjc?=
 =?us-ascii?Q?HzRNB3kYTxaafGOV8OpI7U0yFGTGsvsH60rC2XjifeYmUpiGT3CcMp4Oj9B/?=
 =?us-ascii?Q?THSjcJkYH8oipW1Iu9jt5wyqYFrs6d13vBtmhf3Iclk31DgeoZYAUNZRe8zX?=
 =?us-ascii?Q?a2bDu+R6ss9D6zTYnr9pDOH/Axxkq8gPQ/aVDomhHxDZVEv/2g3222eHRxZv?=
 =?us-ascii?Q?3rJFqsOXb9vQt1DboZKZwzmPtH0HHuHOb54HCCiCUh8TxSRm5bYCjPDbitc3?=
 =?us-ascii?Q?6kHzjwLETfnLC8z4lCidPAsZfhP2numWgalqfAijqma6egnvwW05vQVwkyRQ?=
 =?us-ascii?Q?j4U9M1Im/C68AnbyY4GscXzecq2wKAalijYlnl8pkS6bZH80Hx620B983A06?=
 =?us-ascii?Q?FaqWWmY8c4qPJmyNscocO0OvNCBB8FprxVazC3kYfzxnX9iOhQzxxLE+xuRy?=
 =?us-ascii?Q?KuFZkAgXVq2QqnIscoEpz5OIwasXzd332cIHJkaZpMf9auk1EY2cVZ2yuhIs?=
 =?us-ascii?Q?CCr57QqirdQeNYNTXcMW00M4ZxbIWONK0QQs9WRdrkLeefMWLfh++Vq6116w?=
 =?us-ascii?Q?bMHR3qv4ugqUwAl3ny6ePTD3wFPYa1T9UqnJ2Ey0IXDpMU3Wqs1mBPZG+8BW?=
 =?us-ascii?Q?6/YhQdUXRtYhsDdGp0I93xnUgubznxMFEdHo6d3fIpsVxuLabVOyBusR/wvd?=
 =?us-ascii?Q?ZVmmHVjIqTgHJV8ax1A74Tg2VXPies9Rt/vLsXrXx9HPlLiw4gP6zLtBUjQ4?=
 =?us-ascii?Q?SwK80iJPX60ZloxsYPDuG5Cu24kSgoyqqe3dG6dPcWK4BP68RPzLhf7XVT/u?=
 =?us-ascii?Q?v46kFHZSW0mzlrh20/6e2JkjO7iSEq3IR0P/8DuNGNY90B+sNuZHe7NaYxak?=
 =?us-ascii?Q?h9/WOfjN6dWJerbBnXJvywV91NwNIw3Un7tOx6t4jMncnY4pSqO8jyXPLEUD?=
 =?us-ascii?Q?hm7h6r3JfmOCwM2DaldCqbDOGUT3gZ6zFw+K93ylZNdRFm7SGkhGy00KLtFe?=
 =?us-ascii?Q?h6N/ZRWRUwDX0OEJEPN5L3ulBw+O9zvnTePbt8zmykr+7Nc47mt8eoYdj9CH?=
 =?us-ascii?Q?yIWw+P/rXGs4NUyjaeV4L7F+FEAbzcHkSJxID/pmY8dk6MUtDKuzLB/5WFF1?=
 =?us-ascii?Q?HL8HT40PNpEY+Gt9rIu//8t6LPnLMPv8E7xDZ8S66WN52z86beSm5pyb0wmG?=
 =?us-ascii?Q?Lz7WBP9AevHRnPVcWnfVSdwhMvjbff8J/8ZmLlVO8kZPGWdABC8dplY/5edU?=
 =?us-ascii?Q?S295a7y3DmTtQbrUPOAn7mFX9yeaN/hzU2PksAzI095I/kHanTEKZDxymIgY?=
 =?us-ascii?Q?xw0WNdVs76g9yix+CoTrgr9luGKlNYaP6t0eLoyCIrtDwpnioXLwlEBhm5sL?=
 =?us-ascii?Q?nDWoD8rTaR8VBFZbgblrwUol7ms5KoaRu46cE5UBHfjJ5lKgLOhg+X9Xt8+t?=
 =?us-ascii?Q?yf21ETaKAg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a12cf2-f725-4517-2d13-08de6aa866c5
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2026 02:34:24.5795
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1WJYX+doY4/hRnWxACOBSSvHCS4HiteZdGoUl1/Q//v3gw61qtMAL6YljVa7kvFlbSBPXH5+wM5E3YD6mD/ZPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7823
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "Oops:int3:#[##]SMP_KASAN_NOPTI" on:

commit: 9931f8d4a042e5e2cbf74d9ee99ece44da404284 ("[PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing")
url: https://github.com/intel-lab-lkp/linux/commits/sunliming-linux-dev/lib-raid6-Divide-the-raid6-algorithm-selection-process-into-two-parts/20260206-134850
base: https://git.kernel.org/cgit/linux/kernel/git/akpm/mm.git mm-nonmm-unstable
patch link: https://lore.kernel.org/all/20260206054341.106878-3-sunliming@linux.dev/
patch subject: [PATCH v2 2/3] lib/raid6: Optimizing the raid6_select_algo time through asynchronous processing

in testcase: perf-sanity-tests
version: 
with following parameters:

	perf_compiler: gcc
	group: group-00



config: x86_64-rhel-9.4-bpf
compiler: gcc-14
test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ 3.40GHz (Coffee Lake-E) with 32G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202602131016.5ce5a38e-lkp@intel.com




[   81.049609][   C15] Oops: int3: 0000 [#1] SMP KASAN NOPTI
[   81.049615][   C15] CPU: 15 UID: 0 PID: 109 Comm: kworker/15:0 Tainted: G S                  6.19.0-rc6-00175-g9931f8d4a042 #1 PREEMPT(full)
[   81.049621][   C15] Tainted: [S]=CPU_OUT_OF_SPEC
[   81.049622][   C15] Hardware name: Intel Corporation Mehlow UP Server Platform/Moss Beach Server, BIOS CNLSE2R1.R00.X188.B13.1903250419 03/25/2019
[   81.049625][   C15] Workqueue: events benchmark_work_func [raid6_pq]
[   81.049631][   C15] RIP: 0010:benchmark_work_func (kbuild/src/consumer/lib/raid6/recov.c:65) raid6_pq
[   81.049650][   C15] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
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
[   81.049653][   C15] RSP: 0018:ffff888101557b58 EFLAGS: 00000286
[   81.049656][   C15] RAX: ffffffffc115b5a0 RBX: 1ffff110202aaf6b RCX: 0000000000000000
[   81.049658][   C15] RDX: ffffffffc115b6e0 RSI: ffffffff81513d9c RDI: ffffed10202aaf56
[   81.049660][   C15] RBP: ffff88886bdf0000 R08: 0000000000000000 R09: fffffbfff0b21e14
[   81.049662][   C15] R10: ffffffff8590f0a7 R11: 0000000000000001 R12: ffff888101557bb8
[   81.049664][   C15] R13: ffff88886bdf8000 R14: ffff888101557bb8 R15: ffff8887887c33c0
[   81.049667][   C15] FS:  0000000000000000(0000) GS:ffff888801e6a000(0000) knlGS:0000000000000000
[   81.049669][   C15] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   81.049671][   C15] CR2: 00007f33621da000 CR3: 00000002f20ed006 CR4: 00000000003726f0
[   81.049674][   C15] Call Trace:
[   81.049676][   C15]  <TASK>
[   81.049680][   C15]  ? rcu_is_watching (kbuild/src/consumer/arch/x86/include/asm/atomic.h:23 kbuild/src/consumer/include/linux/atomic/atomic-arch-fallback.h:457 kbuild/src/consumer/include/linux/context_tracking.h:128 kbuild/src/consumer/kernel/rcu/tree.c:751)
[   81.049685][   C15]  ? rcu_is_watching (kbuild/src/consumer/arch/x86/include/asm/atomic.h:23 kbuild/src/consumer/include/linux/atomic/atomic-arch-fallback.h:457 kbuild/src/consumer/include/linux/context_tracking.h:128 kbuild/src/consumer/kernel/rcu/tree.c:751)
[   81.049689][   C15]  ? lock_acquire (kbuild/src/consumer/include/trace/events/lock.h:24 (discriminator 2) kbuild/src/consumer/kernel/locking/lockdep.c:5831 (discriminator 2))
[   81.049694][   C15]  ? process_one_work (kbuild/src/consumer/arch/x86/include/asm/jump_label.h:37 kbuild/src/consumer/include/trace/events/workqueue.h:110 kbuild/src/consumer/kernel/workqueue.c:3262)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260213/202602131016.5ce5a38e-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


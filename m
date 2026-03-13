Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA821DF248;
	Fri, 13 Mar 2026 09:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773395820; cv=fail; b=Nd4YCbpDcuQir7W3zZmZG16fH8QocEPlgDvXWOJtCFUUJPQ0YP07vArbyjglYTrE48Dbk0x2EpgYbAmslkzD0iBSnA/QSDtiVqsbI+6l5Jp3FKeH/6NVNNNbT892Ogxt2WhnIv2hL9WQdvQHtErfYWn8CUPOCwqEM7yU+K4EB2U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773395820; c=relaxed/simple;
	bh=yTUxVyl8JhyojkiDwcfCMCO1D0+ReXBHo0/2Dohca7w=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:MIME-Version; b=WoBhcbeKVXeVCwMEbkyS2/+7eKiQMwzBODhOcXbGpUG3+VW2BSxzBOG7/YOaOfmYBuqA3DbaLoh7BEjdcD1TgLSn87IJINbl8OTz+d1j4gg1TX/4tz0LnkaP7fl6PVCw7ahBlFnqJa/xZ8+nyc9yJepK9jjVyMhdDVno+e7kacs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NZ8VO8z/; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NZ8VO8z/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773395818; x=1804931818;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=yTUxVyl8JhyojkiDwcfCMCO1D0+ReXBHo0/2Dohca7w=;
  b=NZ8VO8z/DatoFURlPoEte9js85Uwn2yh3UnLDIfI8Nb8u6OZFyje4jwq
   xmQz0ddMx8GmbMx1/907kvdJgxox0Z8JBRL1/dArK3VmjXERcO+VUHm3s
   iDfmthrAU/LTeFoWAC0umnLXv8flgdsaRFDGFKfzyl5+lSJmFoqazJkfz
   rGJuyJ793YPOH/bSHzrR0D7eYplAGTHgA9LdxFNBdB0qfRQWYrmaDBaXX
   mx7+iZyK//ShzVGAA+aRnpmXHN9aceKZdJMxRpSyx4UFailJ1Lx/fPhSW
   k8nJQiGdF0tZPbNUlbKQlDznEVJsUFsHGY2ub9eVYOameU5OgSm7R4fk9
   Q==;
X-CSE-ConnectionGUID: 5nPtJAGaRb29OEdSPd0Spw==
X-CSE-MsgGUID: av7aqythRvaTTVv0MTZKFg==
X-IronPort-AV: E=McAfee;i="6800,10657,11727"; a="92076768"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="92076768"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 02:56:57 -0700
X-CSE-ConnectionGUID: SsYB9uzrSvOBGZZtFLdDsQ==
X-CSE-MsgGUID: CUsSs/J7QTCUeW6lSskUog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="246321804"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 02:56:57 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 02:56:56 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 13 Mar 2026 02:56:56 -0700
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.11)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 13 Mar 2026 02:56:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ezn11fnwkr5Dvk99kKfWz1SDX1t6CrcZm1DRI4vrCw+jq7I6d9z0F6+WczaE9hfTDBZ8RQ/uQ3eG47Jv9kPOLNT5jTGNd5KoUPdV7np6hqrH5VkdUojjiahC7U9+2GehYrq/j9iGPutuEnrEYzVNIelxFXTjl9DoPxkAKI2JHysC2wr3cEhmT53MGS4t6l8e3k7tqYhOcoKYIPkBcLneFygU0Lh+tzK3sTZImwPpoB6dCVXa0MlmGoMaXhitSIV9AHb+TiBGDldlO/GcvojnXbE0QblXsXMxJB+XggS/94q9X+LFPD/07oiht8Nwk4L1zCQ8mNNwUrqAWoUDpxAW7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aHDx/LNnSII/61STVxctxtWkFS9qt/sy1W44x1bejQ4=;
 b=CKyb6hcJMZsnzvsseegAh/12SL8USN3zKB9q3GT7egxaOcP2ERqR+HMulQPoK8vNJNkiIBbJB972nMwjs6G1a85YaSFvmZEkgbXIh3JrzCVGjYmS6hInz9HTcCSpFeeI/4wt+KEcMDE1a3GB+An5FkMemxlrEc3cdtECa7VwOZKGFwyff+/Ml+SxoHGyqJhQcZmt1P09NJ7YacRS61KcgIc3k6T06x6k0qF2Jp2Hf44Ye/KDp42fK9GqanvK/ZOi8W2CxVIgLIXitEN5frPjuFeBsS1LQ1eI1e0xBFHa+P/Q17XxXr+Y6ZSERq4RZAOJCklkrXk49fO81aeuiCsErQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 09:56:53 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9723.004; Fri, 13 Mar 2026
 09:56:53 +0000
Date: Fri, 13 Mar 2026 17:56:40 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Christoph Hellwig <hch@lst.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Albert Ou <aou@eecs.berkeley.edu>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, Alexandre Ghiti <alex@ghiti.fr>, "Andreas
 Larsson" <andreas@gaisler.com>, Anton Ivanov
	<anton.ivanov@cambridgegreys.com>, Arnd Bergmann <arnd@arndb.de>, "Borislav
 Petkov (AMD)" <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
	Chris Mason <clm@fb.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>, "David S. Miller"
	<davem@davemloft.net>, David Sterba <dsterba@suse.com>, Heiko Carstens
	<hca@linux.ibm.com>, Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter
 Anvin" <hpa@zytor.com>, Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Johannes Berg <johannes@sipsolutions.net>, Li Nan
	<linan122@huawei.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, "Magnus
 Lindholm" <linmag7@gmail.com>, Matt Turner <mattst88@gmail.com>, "Michael
 Ellerman" <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, "Palmer
 Dabbelt" <palmer@dabbelt.com>, Richard Henderson
	<richard.henderson@linaro.org>, Richard Weinberger <richard@nod.at>, "Russell
 King" <linux@armlinux.org.uk>, Song Liu <song@kernel.org>, Sven Schnelle
	<svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui
	<kernel@xen0n.name>, Will Deacon <will@kernel.org>,
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [xor]  ebbbf58989:
 BUG:KASAN:slab-out-of-bounds_in_xor_gen_avx
Message-ID: <202603131751.7ba6ffc8-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0024.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::6)
 To PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH7PR11MB6522:EE_
X-MS-Office365-Filtering-Correlation-Id: 3531b7fe-d99b-4242-d08c-08de80e6dadd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: knWOee/1e8RpXs1EIwJAiCnOBdhAjwS7Z1B5xeaD6RInlaznCl83u0Kh9LONMgdkJaLKMePrrFfG6A6dv/d3DE8o3NYP3L4/q7c0cHs5r7qDd7b/LwTm7Dl+WKJfVeiM+9ml7qqHgy0FxGFiv2Q8ZFjxvi0AltGettgwABs3KW3j9mG2IgTY8wgsNNEIj6N1OkQh2QWADkyut9DQoT/1ytHQ7sqSigUR9oWl0vHbT1R3ofdB4HYZ/ZhFrUbjaZpg+891yWdqT0meujBbfOPBNDN0bkQE9ldeAfxHEQ0fpYO8tGRerjP7Rx2Mmg+9kW/XeZExq+GUr2qCIJ4j9KVV5yW+M9+uBxGTxCza08JnjoIUSMiuDeG5OEedzfH4ohGtVxw+rURK1RhbfRnY/76Lj9ZldEvMYVsOm1L2A/Xd6hbSI+/XvU5zwVmOSSZrAaU8v3Qt071WodZwctoGSW643CBHX9Zau5K/DGpvS0MI1sqd0aqgiELF9TExXA6LTdAu36BhRnuCkd4Mo3NMslYeaSveI+tSMIug3/txbR+FdntMlEtqLE0hI9CdS0d8G3H8TJ+fiogEgAzPlv9cPzI5Gwz1xbhZbLc9VZX65WVd2FRgUyMBoEfPT8mmzYAeOAbi8OUvIrtwg3nq0D/wwnKkbjn65gitg5udkUEMtVW0UApMASroL3SZ83N5C9CYQ9SO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?js4HvQPbyUjPSg8FF+HjSwZYqdw5p4Sx/kDx/riUomNpepDCEV9tEtvNe6wy?=
 =?us-ascii?Q?wMoh8/QBLQ6ArLU625E1vAHtiJ9MKd9szIOBuulrgfS70Dv8Gbv1qRZu6Sc1?=
 =?us-ascii?Q?C63nrHCVJqREIzILSO9aB6b7aFiu7Psu6beL/M9xvfkwTNkG6x3wepdsp4Bx?=
 =?us-ascii?Q?1eomv1WQtVYb7YPIObI1nkgy9Hm9DL6D5m/hYhh4TMKzPz6IKHhZyxAGmOD8?=
 =?us-ascii?Q?6S2hnT+NvfdEamv3avosY6Z+0mcOT0RB2iMrITLhh+9txyF3GtKVbt85qQij?=
 =?us-ascii?Q?w8KBEnIb2ANllegiXBPR2XchDzrPMVjQRzv5L7exLG2sW7wgahpfiY/NUKp5?=
 =?us-ascii?Q?3FJRao/4lVM9F95zr3+PH15C2g62+L1ww+DUGfacBttpiPnJ7oCOw2+Jqv9O?=
 =?us-ascii?Q?UHnODctj1In2dpxSH7pI3En+vonK8j5l9THIBl5w6iBSuh0C9jCjSGzo6RfG?=
 =?us-ascii?Q?Tx6VEzkYiRhzmuM/3bIXTIA3MxI87byETWvTfLRzxpH4jaTnqk8tTNux1ZHQ?=
 =?us-ascii?Q?LAXWndydL7lbej6mNbcLBO4SQB8drDqUBbSdUIT+IbbPmDTgViqOqM+Sup8J?=
 =?us-ascii?Q?tIDtRwhidFEPFGC6/HFfhcsNSQYtXPeCtnkjAsPcxpTGKhSNWBzjWge5SqrB?=
 =?us-ascii?Q?hoG5+CH9Ojd0Ct7ygdkgS/qGR5k8TrYAThkEsoxvgQN4/vMZMb54zjRqb8VR?=
 =?us-ascii?Q?otC4cWdhx/33X/BviRBE98eP2jJab4PdbfS29BWgD0EhOKuU6f55/WK4UhLF?=
 =?us-ascii?Q?fxD/qn0tQkD7/McJ1RUehR5UO08L7g365NBZP55WgtjhFZ7IFpuE5RUzt49t?=
 =?us-ascii?Q?upB8LeWpLHTO6cOs1fVxpg2jNa+s/T9dNgMxXlftiVG+scGbxuMbvRG2Weiw?=
 =?us-ascii?Q?yyafMab9PPNKE7+zjIEKV/m6bc6x/rDKieKtJPfT6KkeDrljdhXwuvR7tyj2?=
 =?us-ascii?Q?ImZjEh7j7ywyeGiLpYJH6Qp7Q89JHJUhZnxhpuaBlJj0j8DNx6h/5Xnv4feu?=
 =?us-ascii?Q?AvTAMQ64/8VaAhs6BI18j6Hp1M9ZZ9y9azcokoVV7Mi7c0YQUvmQiwKdssed?=
 =?us-ascii?Q?jDw4Dd3IJ5gg4UycyZ/vzHED9nn+2K5xl1w2VDNz66Q5AwDP28HBGIt4bcnx?=
 =?us-ascii?Q?KP11y2gSFs7OHKmhVfDLH25iFcXbgVZnWvyDurCzuHDkPBVABonQb8XD7GoV?=
 =?us-ascii?Q?Vl716XfeLDJ6WwsfH4RtqC9vCpSXZL9Wukkt0pG9b665WrBD9zUQ0iFTbTFN?=
 =?us-ascii?Q?N5QvLUhleWlrL1Z7i1myx42r2D+GI7n4wZAtG0iUgMrD2k9MqyxMz0gvaNzi?=
 =?us-ascii?Q?UYKl51OWwfq3O25abAcQ7TCX47PKGY48mmyElGXrBn6lbNtkP7Vswa2PCVhK?=
 =?us-ascii?Q?DcC15twTQdiBgh+j3dWbSEyZGB8WO8j0I/Pmk0rmVaOsVQytPNGd6+A77mE4?=
 =?us-ascii?Q?aVcBN0aOLkWesSQuM6gj4Girs6yAdDnmfjnE5XEr5g8JVEcckAqImjgXUFOf?=
 =?us-ascii?Q?VEvWddDnEeasgm07nheeTqUwRl2G9bMZO2oNJoFlMSBFgolsd7hZNcv5/XVM?=
 =?us-ascii?Q?Rsr76wX99yx3LJOjC/0JqPaW/1QLULn3Bt0mWA0lEjL2Yhl0/5g1+Nf9lBLt?=
 =?us-ascii?Q?D27BHQI6NpUNe59qcoe8feUf/xllBfwYOuv4IDOcPUzdp/bQ4SJbCAMUKLdr?=
 =?us-ascii?Q?TXl/7ZN0nNH8SKnYIC90N3oamGMq/MKJUhngiNDN33tl0bUg6nLGr2IG9cPZ?=
 =?us-ascii?Q?3rW2D4ioTQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: YtzrAlNP+0hJZAB6w8EobEm6TJRqzLjzQyzYNqC3jErGuUx92LiZPYx+EAYbPpKvgUShzh/OX+49QxU4jvC4KqTbrqQJyR0PA0WqrceoE4yFMtBTFeFW9lVE31XLOF9YSPVS6GYRCmA3wwWADuKadGaOwVKBe9NkkzUxX04VHP1Nhm0XtEBncyKKa7+9pJbim4MZPqYCsJDZeeLJKa5VNT9ni6ivnBTbO13u4a6XtrM01vtfSkdcuUGZUkCpPwhD14bRZuOq91V9RN59opg+XVz/i2lVVwTsfnqlq1bg0wD+1ANDIXZtHPiyn1NJEGC526dtiIaqWioTwK+njKJ8YQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 3531b7fe-d99b-4242-d08c-08de80e6dadd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 09:56:53.8061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qTreeyPQz8wMr0wP6aIKpv82AHVIvvp1EUMT9d1iiF8SoTVTSi1NKr3AWvN+7cZRZDxGVzJdav1GsrOIipuA8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6522
X-OriginatorOrg: intel.com



Hello,

kernel test robot noticed "BUG:KASAN:slab-out-of-bounds_in_xor_gen_avx" on:

commit: ebbbf58989215f5c76b68c93e7d7a43e3a4b620a ("xor: pass the entire operation to the low-level ops")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master f90aadf1c67c8b4969d1e5e6d4fd7227adb6e4d7]

in testcase: xfstests
version: xfstests-x86_64-63a29724-1_20260218
with following parameters:

	disk: 6HDD
	fs: btrfs
	test: btrfs-group-14



config: x86_64-rhel-9.4-func
compiler: gcc-14
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4770 CPU @ 3.40GHz (Haswell) with 8G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202603131751.7ba6ffc8-lkp@intel.com


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260313/202603131751.7ba6ffc8-lkp@intel.com


[   79.007394][   T66] ==================================================================
[   79.015339][   T66] BUG: KASAN: slab-out-of-bounds in xor_gen_avx+0x166/0x1b0 [xor]
[   79.023007][   T66] Read of size 8 at addr ffff888135d50260 by task kworker/u32:2/66
[   79.030748][   T66] 
[   79.032935][   T66] CPU: 4 UID: 0 PID: 66 Comm: kworker/u32:2 Tainted: G S                  7.0.0-rc3-00077-gebbbf5898921 #1 PREEMPT(lazy) 
[   79.032940][   T66] Tainted: [S]=CPU_OUT_OF_SPEC
[   79.032941][   T66] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
[   79.032943][   T66] Workqueue: btrfs-rmw rmw_rbio_work [btrfs]
[   79.033052][   T66] Call Trace:
[   79.033054][   T66]  <TASK>
[   79.033056][   T66]  dump_stack_lvl+0x47/0x70
[   79.033062][   T66]  print_address_description+0x88/0x320
[   79.033067][   T66]  ? xor_gen_avx+0x166/0x1b0 [xor]
[   79.033071][   T66]  print_report+0x106/0x1f4
[   79.033074][   T66]  ? __virt_addr_valid+0xc4/0x230
[   79.033077][   T66]  ? xor_gen_avx+0x166/0x1b0 [xor]
[   79.033081][   T66]  kasan_report+0xb5/0xf0
[   79.033084][   T66]  ? xor_gen_avx+0x166/0x1b0 [xor]
[   79.033088][   T66]  xor_gen_avx+0x166/0x1b0 [xor]
[   79.033092][   T66]  rmw_rbio+0xa8e/0x1230 [btrfs]
[   79.033197][   T66]  ? __pfx_rmw_rbio+0x10/0x10 [btrfs]
[   79.033294][   T66]  ? __pfx__raw_spin_lock+0x10/0x10
[   79.033298][   T66]  ? __switch_to+0x4c9/0xe70
[   79.033303][   T66]  ? lock_stripe_add+0x2a6/0x930 [btrfs]
[   79.033390][   T66]  process_one_work+0x668/0xf70
[   79.033394][   T66]  ? assign_work+0x131/0x3f0
[   79.033396][   T66]  worker_thread+0x505/0xd70
[   79.033400][   T66]  ? __pfx_worker_thread+0x10/0x10
[   79.033405][   T66]  kthread+0x353/0x470
[   79.033419][   T66]  ? recalc_sigpending+0x159/0x1f0
[   79.033423][   T66]  ? __pfx_kthread+0x10/0x10
[   79.033425][   T66]  ret_from_fork+0x32f/0x670
[   79.033428][   T66]  ? __pfx_ret_from_fork+0x10/0x10
[   79.033431][   T66]  ? switch_fpu+0x13/0x1f0
[   79.033434][   T66]  ? __switch_to+0x4c9/0xe70
[   79.033446][   T66]  ? __switch_to_asm+0x33/0x70
[   79.033450][   T66]  ? __pfx_kthread+0x10/0x10
[   79.033452][   T66]  ret_from_fork_asm+0x1a/0x30
[   79.033465][   T66]  </TASK>
[   79.033467][   T66] 
[   79.207744][   T66] Allocated by task 8668:
[   79.211925][   T66]  kasan_save_stack+0x1e/0x70
[   79.216456][   T66]  kasan_save_track+0x10/0x30
[   79.220993][   T66]  __kasan_kmalloc+0x8b/0xb0
[   79.225435][   T66]  __kmalloc_noprof+0x1d8/0x5f0
[   79.230156][   T66]  alloc_rbio+0x230/0xcb0 [btrfs]
[   79.235116][   T66]  raid56_parity_write+0x41/0x530 [btrfs]
[   79.240768][   T66]  btrfs_submit_chunk+0x503/0x1670 [btrfs]
[   79.246499][   T66]  btrfs_submit_bbio+0x16/0x30 [btrfs]
[   79.251882][   T66]  submit_one_bio+0x20a/0x3b0 [btrfs]
[   79.257189][   T66]  submit_extent_folio+0x24e/0xb70 [btrfs]
[   79.262928][   T66]  extent_writepage_io+0x4ad/0x9f0 [btrfs]
[   79.268666][   T66]  extent_writepage+0x701/0x9b0 [btrfs]
[   79.274145][   T66]  extent_write_cache_pages+0x2c6/0xb70 [btrfs]
[   79.280317][   T66]  btrfs_writepages+0x1a9/0x470 [btrfs]
[   79.285809][   T66]  do_writepages+0x1d5/0x530
[   79.290249][   T66]  filemap_writeback+0x1d1/0x2b0
[   79.295037][   T66]  btrfs_fdatawrite_range+0x4f/0xf0 [btrfs]
[   79.300861][   T66]  btrfs_direct_write+0x4c0/0xaf0 [btrfs]
[   79.306504][   T66]  btrfs_do_write_iter+0x599/0x7b0 [btrfs]
[   79.312240][   T66]  vfs_write+0x4de/0xcf0
[   79.316335][   T66]  __x64_sys_pwrite64+0x18d/0x1f0
[   79.321209][   T66]  do_syscall_64+0x108/0x5b0
[   79.325651][   T66]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[   79.331392][   T66] 
[   79.333578][   T66] The buggy address belongs to the object at ffff888135d50240
[   79.333578][   T66]  which belongs to the cache kmalloc-32 of size 32
[   79.347302][   T66] The buggy address is located 0 bytes to the right of
[   79.347302][   T66]  allocated 32-byte region [ffff888135d50240, ffff888135d50260)
[   79.361549][   T66] 
[   79.363733][   T66] The buggy address belongs to the physical page:
[   79.369994][   T66] page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x135d50
[   79.378686][   T66] flags: 0x17ffffc0000000(node=0|zone=2|lastcpupid=0x1fffff)
[   79.385905][   T66] page_type: f5(slab)
[   79.389740][   T66] raw: 0017ffffc0000000 ffff88810c842780 dead000000000100 dead000000000122
[   79.398171][   T66] raw: 0000000000000000 0000000800400040 00000000f5000000 0000000000000000
[   79.406604][   T66] page dumped because: kasan: bad access detected
[   79.412867][   T66] 
[   79.415052][   T66] Memory state around the buggy address:
[   79.420534][   T66]  ffff888135d50100: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   79.428454][   T66]  ffff888135d50180: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   79.436375][   T66] >ffff888135d50200: fa fb fb fb fc fc fc fc 00 00 00 00 fc fc fc fc
[   79.444285][   T66]                                                        ^
[   79.451328][   T66]  ffff888135d50280: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   79.459237][   T66]  ffff888135d50300: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
[   79.467146][   T66] ==================================================================
[   79.475064][   T66] Disabling lock debugging due to kernel taint

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


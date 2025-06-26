Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49DE230981
	for <linux-raid@vger.kernel.org>; Thu, 26 Jun 2025 06:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750918405; cv=fail; b=fEWaNh4u+cTv4dngRW2VM3BBC4wlTYQ0BRFPuYbonN3eywSvgxU0hAgYRJrto3LKkZ4N8aO5Nc/JR1tSlwMFYdo9afuKcnQ7NZ9ZvnnRQ1krT4UJnaza09DuQRXIomS9O1aMnAc/2eynLe/8Sg9dzhAX02ACc2W9fLI26+QpEPY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750918405; c=relaxed/simple;
	bh=o4RGUuByjYOqS7Lls2fVLvEs56jJLY/huApjgPT1R6M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=T7Xm4XoXxagYJuTdHcEDW8mkM1Vcb/uOtIHraiPD4SFKs3x/63SG/P8MT6kPvYAm1m5my0yRPX6JL0FUrGnqaBhgRqICWSLjDD7B3Hu8pEDwYrTgU+qs2cSbU9zil3SzIr4mCcCVDY2VMZn7IZ8lWQTVLvZAGwKgwbcyQj5Wwrw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Slp+Q6ad; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Slp+Q6ad"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750918404; x=1782454404;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=o4RGUuByjYOqS7Lls2fVLvEs56jJLY/huApjgPT1R6M=;
  b=Slp+Q6ad2rmNkrhhVu4/a+pihAhqqAAEy0L67NosfJ525N7eLOQqHB9g
   oQI9M8PFC0Lfivrsy+C88eSU3lcEjJ+RJ7WnfsiqcV7SrHEyuoL0n78TY
   DQwVrxAPxUI57N4jDZenIsTIXWU1bqaELX60XnZ0MjFERbWIqfLceiPfd
   HF+vYA5HooKV8csPJc9WJQvcYA/iGS0f7/hO2bgUat1Pi81tbL3aG2qIQ
   1vxhgo1dSO0yKpg3OX1cPcyHw5G32UnZfqshcT179WyCgPWlqQQ71c/MQ
   WZkMqPvSl2mDB0yGjk3KCCjxT/9mWsEGi+RyH1eyeq8+wbjB6RVnk9V4a
   Q==;
X-CSE-ConnectionGUID: WRLc0kqyQkGg2XswQwSPFw==
X-CSE-MsgGUID: xNPCBS8CS/iyT5HeHj3UFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64635781"
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="64635781"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 23:13:24 -0700
X-CSE-ConnectionGUID: hU6GVIwUS6Kq+pSb+vIPTw==
X-CSE-MsgGUID: UihgHu9GQtu4bw2j+i67UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,266,1744095600"; 
   d="scan'208";a="152542902"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 23:13:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 23:13:22 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 23:13:22 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.78)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 23:13:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bPL94HkNzp4TnFMhS352zKFd+c4cLGrLk9t7AWbBNGG8DDwBW5whBLXhQyht0hEM0gwu75vfCTwHlT0C07RX5ae+c8yxdCGGcbOYUTFUZY3oQS/hqrjbW3VKYH/wMFIO41G1s+ZE301Qo0SMNr9ZBpxvdz1GiqFraQ5oLnHnVMqMgKc/Gjz6gVA/LadGp3WxHuEOb+s9N9Td+PrqFT6+gs7TNB0XQZ4v2rcVs4mK1U0+T0bDnTEET4lkH7kh3USLNKw8xJC2O3RRXjeEOe1SIXNmSuBGz8Cr9sqzYG9C+n2DtNm/9K1GyPf0yv5MbOAHNym9zmLJ33cxEFJm1EFTeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uO33c8jW60/Bs5xN9GbjEiiIICDnXH+Tb7eSszCRbn8=;
 b=Wd2TOgn+IG/dvqsLhS3iBaBE0EuSgRSweBLKQfwtkRpXMEJnPEdW3H/IsNEhfZQP2YKINQGq/p1Ccy/8CP7HKOjcIu06FuedmVNN16yOgrKgUBRix20fSlRo8ZbBxKLtFIpc89txi+Wnf2bXoOvgFzI/FY+Eq3BR2oWYfCnuB7hOZZY2n4fPfvWJUS0NWkvinFjTzEL9Qm5en6f+F/Dqcv0k3ZeqYFlcBDxwbc0hHs3bqbljk7+DBJkS5Xj7QcgHVm2a5gs8Y02Kxcnto3qehRIoi56VpXA4B7Yw5kcwJrwEzSlUw7Idp9hm06+nqqgyk7YOWao+mpy8AWG+NtGbFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ2PR11MB7645.namprd11.prod.outlook.com (2603:10b6:a03:4c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.17; Thu, 26 Jun
 2025 06:12:52 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%3]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 06:12:52 +0000
Date: Thu, 26 Jun 2025 14:12:43 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Xiao Ni <xni@redhat.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Yu Kuai <yukuai3@huawei.com>,
	<linux-raid@vger.kernel.org>, <oliver.sang@intel.com>
Subject: Re: [mdraid:md-6.16] [md] bc8ce8eaa2:
 mdadm-selftests.05r1-failfast.fail
Message-ID: <aFzk2xKgrWAvdtAz@xsang-OptiPlex-9020>
References: <202506201427.baf6fdc2-lkp@intel.com>
 <CALTww28=jOrcKTpKQPAcYQV1btic-_wwE3PjfA-hUAokZGhXwA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CALTww28=jOrcKTpKQPAcYQV1btic-_wwE3PjfA-hUAokZGhXwA@mail.gmail.com>
X-ClientProxiedBy: SGAP274CA0003.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::15)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ2PR11MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: 27f33fea-4c96-4b77-9931-08ddb4787bd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NFS0qB3H0ZF6SUDFDBoklaRiY79I9J/eN7YxF3FQEvXy0o2hxbjCNAyLhuOK?=
 =?us-ascii?Q?+Rhiovqv26vQFizFnQQ7tre24mqd2ShdLifRVNgO3M85QCmHJy0X/f5P518f?=
 =?us-ascii?Q?Sqsr+mhCqnO/ZCDZsVlr7srNs1J827XXS0LDaN4S+p0vVeKv2pm/nJ92Ew1t?=
 =?us-ascii?Q?Z2InXlagMM36N23HWn8DSLbvXhfNCn0OIePaeJ36pEpqFK2LKmKKfJ4p2foN?=
 =?us-ascii?Q?x0PxGtDAEFtb1KnSwGR37eQXfpF5K5Y1BecHYUEZBdJzwWu0w38ZP+vxUxMM?=
 =?us-ascii?Q?TY5natS26yBGucp58hfiogpWfwoiyUpTsxtA5YG7ZyXuB5Vejepm3MFqFJDk?=
 =?us-ascii?Q?beXAk/v0mNTRhBSy1Dop1dpyd6MMMJpe0yvm/0A81QiHBifznxUKUD6PQHCT?=
 =?us-ascii?Q?NBVdpmxzpYOhTsEXX1oB9N17o0uaaenbpb/T34xAFcgNsnCRsFg4VArFyhzb?=
 =?us-ascii?Q?ybp1rrTWynWN37oEvA19+S4DUkXnr1UmeO7wYHw06YrRCeqRe9lwaW+wCkHw?=
 =?us-ascii?Q?OMq44fGEMEZCCqCzsVoMDoicJt1sm9V1/2QGQ2TiIOrHStMFix6Vbxn22dfz?=
 =?us-ascii?Q?V0JvxUahfgydR+td7/dSIuXMLKoKW8B0Ub8mtpAe0clZSDX80WzH6CdFSYXL?=
 =?us-ascii?Q?eIJmP3GPOuOPnlde1g+Be+fMYWBBxfZX4u4PgFoyLy3v/4gHpXV3W+8l7J5o?=
 =?us-ascii?Q?YlmMLTzA6ETlgOlZMBaaTEQVUWUcO6qqqKmsOoTSRBtxNlhm0BI8XpVH9eO2?=
 =?us-ascii?Q?NlyyfGGH0tEtABYO0OG7nyco15t3wzXOqRTzXUaSQXYpET1nvNPotm+zWDin?=
 =?us-ascii?Q?bPCUTu4V+LbHnK8gP8WJeTqFHKn/VjDSE0vV0/06H88845mKID2FAT2Z2NKI?=
 =?us-ascii?Q?0EiRkhgxC8Kmi9yCmJxm/WhCWoKMbj1QUrvsfmcGUb0xKkKpXV9HVAlgy8on?=
 =?us-ascii?Q?j40v7GBgYkPAOQVTJWXF6Wp3Jlp/J3Ysqwl2E+sTb567zIw+myDaxrPBrr66?=
 =?us-ascii?Q?Mbu3Mmldtv03egyUwfCQq5sKh4sZ8nMt1NYH6Gqq7IbxwX/qxbc6TKNI6Qo7?=
 =?us-ascii?Q?LaGes7bvhWpq3WfmFF+IGimMd8CSgR70ynSNkrV9V8CgHK+M3vwfb7n3r3Jx?=
 =?us-ascii?Q?JX1GDKNn2psrt5I3FHCrKp6H00WisyJo2Wy2GOq+qjBVjPSc4umWN431cUoU?=
 =?us-ascii?Q?p+fjQRl6pW/pBkv7wARk+zcNB1SAuZYc5zN2D+hLRZTb4/YgJsPa4qeREkRu?=
 =?us-ascii?Q?TVjH/ZuZB3jjqMkkfka+MBQ8CAQqDhpOr+3b5h16uvm+Rv8WRzxvmHgzHgZR?=
 =?us-ascii?Q?xBtncvCyHLbABgqVbOOrBPfI8k9Uz+NRrKOVWmjUKBrTj0qQGOND0cx73aid?=
 =?us-ascii?Q?nT5p9DQPC/hqzF9F9olUC93rxfUHEkx4wVfjfRZNona8DSQ4h7fAVdAi4ksB?=
 =?us-ascii?Q?zbINJtq6spE=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8Uk7nODtig3KsvedkEDxfA6SCERLGelB8oXseDhb9KjAcNC0SA5N8qcslamb?=
 =?us-ascii?Q?jIcoaYCcV+70eI1NmxlkO45+lDnMIIZXxOdcDc/ZbL6f5A/d70EF58Z3r5Iy?=
 =?us-ascii?Q?r98sSw0ES7z9QeGFZqq14DAeldBubn33G+PLOh0FdL33G0C4kWK0FE+14ktM?=
 =?us-ascii?Q?DVW3RfqMWoz49gFRF8+ZnksHh5okzulRrSwfCtlm/jj7gs4xMxCcRJYTFqrz?=
 =?us-ascii?Q?VcQq0/X94+N+LsqSPnjjE3KG+p6A3P/8Q8yuy9HBegc+mxDkmOFfpcz/7TIv?=
 =?us-ascii?Q?hsCcWxEiGGQjAkcLamRvzuB6CAkx/RqKhA1QUqv5Dxh6OaRItMO2Ovmkcc7t?=
 =?us-ascii?Q?JfhE9K9BgyF71fNqXqblIN6sbObT/wibKnfxxYMnd6jFynm6odK+fcAK9lVE?=
 =?us-ascii?Q?VgwhdR5fWdhwCZhvPrfwhN6zcB/kGceHfZ4NX5v0ygBbnnCtpzsQHlQXM1kq?=
 =?us-ascii?Q?HLx2Tbpne6kwq00FhgdeIQ+DQmQEXMZJX1vYQSLFSgSLXfeqpOpfZ1rmX8lf?=
 =?us-ascii?Q?0ynaZzifCQQ81UmISDOV/fSrCL4ws4evF6kZ3IanEKwQHbvwd0ETNVZfF388?=
 =?us-ascii?Q?d2Z8d8vzVz/vZGZpgWk2vq5ZbtPzAHMQrKHw8upA7RZvNVJRNuAG+T+uyaoq?=
 =?us-ascii?Q?UjTvNZ+b/4FQo0oAShXWeYLbNOiiwCwEsEdGvQXABOcAWWlRdF8VR8ue/Z3I?=
 =?us-ascii?Q?L/ah7yFgKN8iyyobVepmIi8AuIHGzHUSSKX64qNNSzjxe+51j4Aiw6ZvFBGo?=
 =?us-ascii?Q?YHhV1R85w5o2EXgeVxDS76Z1kBceEJPYE5eIcLfg3D35NAI9qFjF2GRr/TQD?=
 =?us-ascii?Q?Es38gXtvrj6Jj6dqeBCuD+Mqq5WdKuQW+QrPpY1T0FlhTqoQNbbpRqPOzhPU?=
 =?us-ascii?Q?h7xQ6+H0SINdYKyfFQhXIWyHbRmzn38m3Jy+u4hkvzDvHAh5Hp9iZQkrkor9?=
 =?us-ascii?Q?eKeNVBUoJEnkc/uA+WCw531wmOhrbmJjH+2TVPQ1wY/dFTe6CHVDxTcudp+1?=
 =?us-ascii?Q?PlMoeDi/81m3AVe+o/cAKjjPG3kdqimQt/vm5bL60E4+7n4yB6ud0hrM2qeR?=
 =?us-ascii?Q?faA9WiOLeR3eKuadv2PIYaEwzor938hAcCFxdUf+N3xWRmpMmhlm9M8VNUl/?=
 =?us-ascii?Q?08wD8vtT/5U1pAHTujwWALsf5/irkB7LKsybTw1+BjFR/0rdrCras/BhmVM/?=
 =?us-ascii?Q?nBsbel5eZjSP5CvpnBpurITkSAECj4gQrIh/FauYz06uoHcHlfsXmcz+lAC5?=
 =?us-ascii?Q?/vsAV+IeIb4FXlGpNP/YyxYUhOxKcmY+IVNHvtafDvPAhaopj5wwUUIQVuIj?=
 =?us-ascii?Q?5mwqYkzgQFxf9PbP5uplUxO3R343YllDT88rVbbtRjWPRE6xTzApo0w1i+vt?=
 =?us-ascii?Q?UlED2eqDXb/8Ge1agAD/YVQspZ2P1U9aNKWcVf2Ed6wO+Jy9zEavnwGwmA2o?=
 =?us-ascii?Q?UyIVKCAvdsytofyjcwlNrerINQFHtfHJ0BmADBXlN+8ZhQfWcvcPN8kEasVo?=
 =?us-ascii?Q?BWlORTSYF3JYojVzyXkOGca2kTVNJs0kEHeKkM5IBLNSy375QkpRIy6ocb2L?=
 =?us-ascii?Q?n7Fcs2dJ4yzsT0/LA0r2QnprfBsOFHfoa31oTdX0BrU5d5vcFcWVtxa5sNW1?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 27f33fea-4c96-4b77-9931-08ddb4787bd6
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jun 2025 06:12:52.5637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qKkJe+pXtkqH5ju69a0UDX8fWaIcvvZV1oJBhCXJW0e1m3m62RBelGhA4i61UCi4B2G/8VyrQK8VqWP6QU7/MA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB7645
X-OriginatorOrg: intel.com

hi, Xiao,

On Wed, Jun 25, 2025 at 03:43:58PM +0800, Xiao Ni wrote:
> Hi all
> 
> I've run 05r1-failfast about 50 times and can't reproduce this problem.
> 
> The kernel version: branch md-6.16 of
> https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git
> The mdadm version: main branch of https://github.com/md-raid-utilities/mdadm

sorry for this. we checked again, when this bisect done, we were still using
an old version mdadm that we pulled in May.

now we updated to use latest mdadm and the mdadm-selftests.05r1-failfast can
pass on bc8ce8eaa2 now.

> 
> Regards
> Xiao
> 

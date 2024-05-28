Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1762E6E614
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 08:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716886284; cv=fail; b=S8CawnG8FqL79rtkJ12/afy6QUNKkJEgvgsJRO3PKOwPmNRXCk8s0NVDe61Ix9kE5pDHz3/YEdD+iUvHWbI8CZabpN/1v85GpPJquNvst+lI++hPb+6YNCmgtCDAB2pOIlAAFxZY6zSX6gdw/HeQ9Ra2u9h/iPrVqAtoV+RTa/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716886284; c=relaxed/simple;
	bh=E2xmBXfUtz5PxkfcnRD4FK4K2I3Mo5atOAgB++ZTU68=;
	h=Date:From:To:CC:Subject:Message-ID:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QclxX2D3SVKPqBe3ykplZtbwn8nC/+B/ctWnWZF1ws0+AbYSwoz8peXlEv4K/DIhWFJvxyAGd7sh4ti4J0+EPmuZ4Ly0mVJvxY3Y9Rs8Oiazul/2Vd3FCCvx8KCncPKE74UtGbxIquJV6aT1wq9YIMAN83X90qCHfB1J0I85rJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jPSRJ+Yi; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jPSRJ+Yi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716886282; x=1748422282;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=E2xmBXfUtz5PxkfcnRD4FK4K2I3Mo5atOAgB++ZTU68=;
  b=jPSRJ+YiAUWihjiNKuLPjQh+qwm/vRNDHPLVwdOR5e6ZAxT1xTWgFLCX
   dpmiQnkC0fiJPJGvS4JHnL8pIPhPg6qL77rWyKuLN1dRwhmdAtaVn/g2l
   4YG7n5x0eR3XkmRE3c8puBgetqcaDEpSwSBM/UpaK8JKidD+9MMIFXCaH
   zoHVILIswJulEUCUKAODgw6uFhtmOoz44VjyJPmwd/5rOP+BVim4O7X5D
   ENFxWzBjt5F5p+WzKdv5c50Yh7SG+RcTdHChmuqz2Pa5X84Z/odUI2ne3
   6K43dmLz5ZpwFF93OHcv73v6iZ+55+bA5LGaAxXhjMEpzTjMszZdq6M0t
   Q==;
X-CSE-ConnectionGUID: PVD/072WSamzdS3/YenfqQ==
X-CSE-MsgGUID: rWM4zEumTDWXzIWMLz1FVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="13387185"
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="13387185"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 01:51:22 -0700
X-CSE-ConnectionGUID: qCmDwVaKQrCeI5VNehvG7g==
X-CSE-MsgGUID: fliwAF4UTR6yGIurnQXzmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,194,1712646000"; 
   d="scan'208";a="34910929"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 28 May 2024 01:51:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 28 May 2024 01:51:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 28 May 2024 01:51:21 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 28 May 2024 01:51:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jO1JmOsH3FkRryVSIHNULPKDVhSLH5z2P8FYbAW1f3ZQfy/bouUiDUcv+XqetpiHXYxUdl3I9MAbG5wC0sBqBwzDkzTEHA/MHopuM0m3YGl3veVSKf/pAA2YEIdSswOwWL9O/JDdtpZk+tLVPf1oj9eXvskggRyJV3ASM9a5HBvikSwtkGz1BoQjOo54fcLcBbcqAlEJR+NGcZPrESgdEVOZH0CwyhrGMYpa1HGwqrC5t/KYtYEOCg/oS11wng+GmSnWLD1O1aqFx+eYf2rw7U/p/u4/SRyuJ0sxxIWGMjwfGHoU5v2KXahFoeMQnGcyZS5b0cx35q6pU06mzy6WmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TAJDX2zTYAtvGyiFO+0NO0IEOosg9mIfdiVRdFW6xhU=;
 b=ezpgbiKMcDm9PnH3QOyBcXfHiFbd2fxgYCDHCZJaIHab9CZEvh1bJhdd9WkqjfSe+hGnqgqRdzCv4FY6jylBrCE4hV079VH9A0GB3CLOv+qngzRDdU+L/E7/+B4pPLQd+IpNgu6xmwfjkOVlbXu/53RClgOxXluodWVmiqJWibaQ3nXJzocty2gWv6yRKpplapJ54xPQqRbwFfxraEh7QmtZbNAr/RSIiFiQpa9+GQxCqRWOEQk/mUnYizG7/tBHt8dLpe67vQDskk5FGJtDNDPaEkQN0QSkBacug23rjL0//2ksWDNOjOLaqQk6sl8SLliqWNXMd9Nv2a7JPEHIFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CY5PR11MB6368.namprd11.prod.outlook.com (2603:10b6:930:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.17; Tue, 28 May
 2024 08:51:19 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%2]) with mapi id 15.20.7611.025; Tue, 28 May 2024
 08:51:11 +0000
Date: Tue, 28 May 2024 16:51:04 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Mateusz Grzonka
	<mateusz.grzonka@intel.com>, <linux-raid@vger.kernel.org>, <song@kernel.org>,
	<oliver.sang@intel.com>
Subject: Re: [PATCH v6 1/1] md: generate CHANGE uevents for md device
Message-ID: <202405281639.be74a40e-oliver.sang@intel.com>
Content-Type: multipart/mixed; boundary="xv00Vt9IRxnYNsUx"
Content-Disposition: inline
In-Reply-To: <20240522073310.8014-2-kinga.stefaniuk@intel.com>
X-ClientProxiedBy: SG2PR01CA0186.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::14) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CY5PR11MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: 706b2826-1e1c-42f9-bb22-08dc7ef35330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|366007|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?opNwudxm7DfgznMuigfU6avgGdu3bf2Q41Ge8HuvekScL80HxCMuWF7GX2rV?=
 =?us-ascii?Q?mkAj0SQpTWCVvan81KYbi5g7tz8daceaaM7zQnyqUEkyiOCmjoS1bbyembU+?=
 =?us-ascii?Q?thnsc8CU7c6O1lLFubVKjdu9GHALrmUV4aRGLkpVhfgok9T6ih/bXLF+2sAf?=
 =?us-ascii?Q?cWoKMPUmun1ghuP55OkSs9jXb929o/S3e4kw+LPOkab1LcpgoIT6YEES1I13?=
 =?us-ascii?Q?McsNs8i4SSVQ/QWdbJm5uEdyQJaQ58DuzVAjONLxnxEXu9cqv5C8LTEsArt4?=
 =?us-ascii?Q?gNtnjFvZRv+RmSoXxT8cjykHYBIQCxHUSpdlidqMGr4iTHznJ30YlXi30+0C?=
 =?us-ascii?Q?ZCpWL8UUrWe7HOFAngOKJCUJPRi4YmPy0RqoomSK2gHs4up9yRIyVPgKuSjM?=
 =?us-ascii?Q?zpZ3SNPg8r5xKOnR6DDh9PYkqkxhuzhQ1Vq4gKLbcahWlZP+4xVHdNGJ9AYh?=
 =?us-ascii?Q?uiwVcfUOfOZCbBNBR7WC8DohE6gzgZFfQRokH8rCGKfdBlLaHuxRMVxxgRUN?=
 =?us-ascii?Q?eXZextns/rYBkOT+QLshjzEmlxF/1n6lRt7Ekojb+H+T9i7NqETRcW5HcvIP?=
 =?us-ascii?Q?s9LUTKGdkzTG4rw1WFm6egm6sv4e7AIh8a4w1fvhYI2ZiM2HY1biNDMxvS/W?=
 =?us-ascii?Q?UezrFFSJs43PWdHhoRCrTiCOndppk9diIFdHmHM01OEsHcuB+dUHtVb7CQKV?=
 =?us-ascii?Q?yxwTvQnLbPj9LjybBQG/E2UeL+GRquaKnwakas1lGvoOy5AtYuxDzUij1rT7?=
 =?us-ascii?Q?6QbnPHhS/Qb0M88EJuqvNLqpW+1ySDjUJUpixSkZcV3cuk3vMuZZJE3SaRXz?=
 =?us-ascii?Q?eDijjBvPw5EJtlfBBKHi73LFUDMA3tIC42b45XZu3Ur/WCPxIjRXgb4Fi407?=
 =?us-ascii?Q?1Smpksl332crLo+gaJmWi3geTVnsoyuMx93NsQo+RGi+4Tdffqyk2Y08B8DU?=
 =?us-ascii?Q?SeCEaN2EHsp8tFOgc6zkskRhFvqwojPuZm1JGL4UbieWSrtXfeQpc2D473S6?=
 =?us-ascii?Q?LoJMk8vZfQypZ+Q9JPj3Y5Uqyl+wGXm9aFerip1Du5jx0OTgK4z/sj63zgYK?=
 =?us-ascii?Q?fUWmGAv8UJWRc8wKELLLini7kPEY+ZpbIDUCCHKxkW4vDVCRukpaGw/TinQE?=
 =?us-ascii?Q?S0LGMdBWAnO055NUZILT6g7HUNrewQIEQQwv6ky7Y5hg1DfQ3vAEp/W4A0Zf?=
 =?us-ascii?Q?HXIV8F4So3eK51Fqmc3XPxCMqZQa6T3SU2D//2BMBF6mT8n9YTgCNYCqKL0?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4DFucHoCrvtyehyndMkzItjMXOuFe3GWshWRW2YVu9g9vn5mTkN3vV4WH98D?=
 =?us-ascii?Q?AQEaGx4bUmmfXT1LexOJrNvSDHuVKROVgOr/zC98r6Dyvaozl7g4W2MxwTr4?=
 =?us-ascii?Q?AOP3tm6aR78Hxf8SHVD07KHPIianrdHxrUCV8WGXHMVWyX0xDEYUdfXsN+ar?=
 =?us-ascii?Q?PGSeC/eENjapMjuALTkiCMyWwm4oXAniu/JyAqXT2Qal8y0V7+ieQUuLyYVA?=
 =?us-ascii?Q?MsSxjSkgk7z4D37ghE3HfINFL5u6hOa+id6oMB/5ar1bRn/IzrII2Q2Ac6vs?=
 =?us-ascii?Q?0TirUNj3eH9R6+AZcQqSCsesEK3tS3mXZPF6ZEFSl0ItLOfTm/fwilntjOp2?=
 =?us-ascii?Q?01AE1/750rukyvsvq+O7QYhK0G4QWXm6/i8UiXFf+pxRrn0P5QQPEd8PPcoP?=
 =?us-ascii?Q?VRWblo92xelENgyH0JxQvn6umLP/Xh/kij73kegLJipfYNaCGG20HUO6aWiN?=
 =?us-ascii?Q?0kQjlMjYmVh16CWZkKxymeMtg0jnJxVApauRNaNGqCM1H+K0E7jrBt4LhdO4?=
 =?us-ascii?Q?Od+4rjkNGPI1r03p6hRLOosEFm62p4EcPayOYExAKVTqZzI+ADzOIm13jN0P?=
 =?us-ascii?Q?ORr7s5PHw8mLDSI6rZNeiG8OfDzEv0gC4+0/TuZg9mX06bYIrS93V4CsySlW?=
 =?us-ascii?Q?Lrx1pU2S4LmKapgmsK2ANtjOe4p/p2gndazpW1CvJLvTKrDEf+1b3pnIGKu9?=
 =?us-ascii?Q?t7JpF8se4RNI2XPWNTP2mhCPbLjljorqfj7HKFolGeSLJDqBqkrncndhZKeN?=
 =?us-ascii?Q?RnBxe/1BpTk8dqYE/tH3MQ8agSrtEBx0z3i/n1TQjW5IJrWgZOlXf6XRSqcG?=
 =?us-ascii?Q?qdULPd9MgBzqYbWct8XPuzB445vSdeAARH635aRRBQ3RFcXYjVx0TEJlYb9Z?=
 =?us-ascii?Q?zGRWkZJoyvfzsrOsamHgzbsD+ue3U8edyVFP3H5bYngy6KIOiM6Fruk194dF?=
 =?us-ascii?Q?HSVLUZlgH0epSnW1rJk0yRC+Ky57vARlO4pQo74dxd5Bx8jr0/LKWjnRi2+3?=
 =?us-ascii?Q?kYV1qjJWwG8OBhRdkBesW/am4i+QlQh4K+uRwA4ymofTw4bSAUiKzPYO4wYP?=
 =?us-ascii?Q?AK+3Jy90pPtjVNKgPK8dggZnY+VLPnFgzQaE0w6QCjj583nhCizU75OrezgB?=
 =?us-ascii?Q?qhgmhJE5irHxw/uWxCNj+WELli3yypnY7T0qZ6nT5rFBFoqZbvT2qUsP/FyS?=
 =?us-ascii?Q?7ViqpRwsBMJvRhPQfu4UbpPGlsuLFWzm7x7zmFzr13vCFSsUrn/pan4b6Ckj?=
 =?us-ascii?Q?MgqYvmthMsinbRGjPUrZ+0J+EU7qCrwgu/LuQQMT5VYGdrrwaw4BfBTjrU7l?=
 =?us-ascii?Q?AmUA0Q+qJzikKLfPcxM3uIf1Pf5Svey3eQxVSLKoh8X2nvwHAkk+oL5pBTrq?=
 =?us-ascii?Q?WbhVR6/e2Egw4qiTg3MQvi2x3HEa/Xmze8YLL/tCTFg2jBEsM5IK+K0MXavK?=
 =?us-ascii?Q?swH278WZFzGZfdtPPtJVzAGzce1/8ynY51JABxCzo9Easu8tLaydi+VCz6Nv?=
 =?us-ascii?Q?zxuraczlJvDdLiBrezm+O8uzoj9KFaUUNb58zydRv26q2zD2sal1EMHNBsyE?=
 =?us-ascii?Q?xfQjb/5ycjpByEl/V76IsCpbx6C006fI2tIvMrWE24i91F0yYXpU7WKIXY8h?=
 =?us-ascii?Q?IQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 706b2826-1e1c-42f9-bb22-08dc7ef35330
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2024 08:51:11.9195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NoKTK4Hlt/P0VvrYyUNvcJxduNwBC8+eW1MveYg4F7JxI/79e88JG8joSRWQsYdVcQ2bPE1/C78xWtSYx4GEHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6368
X-OriginatorOrg: intel.com

--xv00Vt9IRxnYNsUx
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline



Hello,

kernel test robot noticed "mdadm-selftests.07revert-inplace.fail" on:

commit: 14a629abdd2e5e55a5122a59e338d9b6570c2c81 ("[PATCH v6 1/1] md: generate CHANGE uevents for md device")
url: https://github.com/intel-lab-lkp/linux/commits/Kinga-Stefaniuk/md-generate-CHANGE-uevents-for-md-device/20240522-153509
base: v6.9
patch link: https://lore.kernel.org/all/20240522073310.8014-2-kinga.stefaniuk@intel.com/
patch subject: [PATCH v6 1/1] md: generate CHANGE uevents for md device

in testcase: mdadm-selftests
version: mdadm-selftests-x86_64-5f41845-1_20240412
with following parameters:

	disk: 1HDD
	test_prefix: 07revert-inplace



compiler: gcc-13
test machine: 8 threads 1 sockets Intel(R) Core(TM) i7-4790T CPU @ 2.70GHz (Haswell) with 16G memory

(please refer to attached dmesg/kmsg for entire log/backtrace)




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202405281639.be74a40e-oliver.sang@intel.com

2024-05-26 00:53:50 mkdir -p /var/tmp
2024-05-26 00:53:50 mke2fs -t ext3 -b 4096 -J size=4 -q /dev/sdb1
2024-05-26 00:54:20 mount -t ext3 /dev/sdb1 /var/tmp
sed -e 's/{DEFAULT_METADATA}/1.2/g' \
-e 's,{MAP_PATH},/run/mdadm/map,g'  mdadm.8.in > mdadm.8
/usr/bin/install -D -m 644 mdadm.8 /usr/share/man/man8/mdadm.8
/usr/bin/install -D -m 644 mdmon.8 /usr/share/man/man8/mdmon.8
/usr/bin/install -D -m 644 md.4 /usr/share/man/man4/md.4
/usr/bin/install -D -m 644 mdadm.conf.5 /usr/share/man/man5/mdadm.conf.5
/usr/bin/install -D -m 644 udev-md-raid-creating.rules /lib/udev/rules.d/01-md-raid-creating.rules
/usr/bin/install -D -m 644 udev-md-raid-arrays.rules /lib/udev/rules.d/63-md-raid-arrays.rules
/usr/bin/install -D -m 644 udev-md-raid-assembly.rules /lib/udev/rules.d/64-md-raid-assembly.rules
/usr/bin/install -D -m 644 udev-md-clustered-confirm-device.rules /lib/udev/rules.d/69-md-clustered-confirm-device.rules
/usr/bin/install -D  -m 755 mdadm /sbin/mdadm
/usr/bin/install -D  -m 755 mdmon /sbin/mdmon
Testing on linux-6.9.0-00001-g14a629abdd2e kernel
/lkp/benchmarks/mdadm-selftests/tests/07revert-inplace... FAILED - see /var/tmp/07revert-inplace.log and /var/tmp/fail07revert-inplace.log for details


(log is attached)



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20240528/202405281639.be74a40e-oliver.sang@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


--xv00Vt9IRxnYNsUx
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: attachment; filename="log"

+ . /lkp/benchmarks/mdadm-selftests/tests/07revert-inplace
++ set -e -x
++ mdadm -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ for args in $*
++ [[ -CR =~ /dev/ ]]
++ for args in $*
++ [[ --assume-clean =~ /dev/ ]]
++ for args in $*
++ [[ /dev/md0 =~ /dev/ ]]
++ [[ /dev/md0 =~ md ]]
++ for args in $*
++ [[ -l5 =~ /dev/ ]]
++ for args in $*
++ [[ -n4 =~ /dev/ ]]
++ for args in $*
++ [[ -x1 =~ /dev/ ]]
++ for args in $*
++ [[ /dev/loop0 =~ /dev/ ]]
++ [[ /dev/loop0 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop0
mdadm: Unrecognised md component device - /dev/loop0
++ for args in $*
++ [[ /dev/loop1 =~ /dev/ ]]
++ [[ /dev/loop1 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop1
mdadm: Unrecognised md component device - /dev/loop1
++ for args in $*
++ [[ /dev/loop2 =~ /dev/ ]]
++ [[ /dev/loop2 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop2
mdadm: Unrecognised md component device - /dev/loop2
++ for args in $*
++ [[ /dev/loop3 =~ /dev/ ]]
++ [[ /dev/loop3 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop3
mdadm: Unrecognised md component device - /dev/loop3
++ for args in $*
++ [[ /dev/loop4 =~ /dev/ ]]
++ [[ /dev/loop4 =~ md ]]
++ /lkp/benchmarks/mdadm-selftests/mdadm --zero /dev/loop4
mdadm: Unrecognised md component device - /dev/loop4
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -CR --assume-clean /dev/md0 -l5 -n4 -x1 /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --auto=yes
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ check raid5
++ case $1 in
++ grep -sq 'active raid5 ' /proc/mdstat
++ testdev /dev/md0 3 19992 512
++ '[' -b /dev/md0 ']'
++ '[' loop == disk ']'
++ udevadm settle
++ dev=/dev/md0
++ cnt=3
++ dvsize=19992
++ chunk=512
++ '[' -z '' ']'
++ mkfs.ext3 -F -j /dev/md0
++ fsck -fn /dev/md0
fsck from util-linux 2.38.1
e2fsck 1.47.0 (5-Feb-2023)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/md0: 11/13440 files (0.0% non-contiguous), 8346/53760 blocks
++ dsize=39
++ dsize=19968
++ rasize=119808
++ '[' -n '' ']'
+++ /sbin/blockdev --getsize /dev/md0
++ '[' 107520 -eq 0 ']'
+++ /sbin/blockdev --getsize /dev/md0
++ _sz=107520
++ '[' 119808 -lt 107520 -o 95846 -gt 107520 ']'
++ return 0
++ mdadm -G /dev/md0 -l 6
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -G /dev/md0 -l 6
++ rv=0
++ case $* in
++ cat /var/tmp/stderr
++ return 0
++ sleep 2
++ mdadm -S /dev/md0
++ rm -f /var/tmp/stderr
++ case $* in
++ udevadm settle
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 20000
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -S /dev/md0
++ rv=0
++ case $* in
++ udevadm settle
++ echo 2000
++ cat /var/tmp/stderr
++ return 0
++ mdadm -A /dev/md0 --update=revert-reshape /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --backup-file=/tmp/md-backup
++ rm -f /var/tmp/stderr
++ case $* in
++ case $* in
++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -A /dev/md0 --update=revert-reshape /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --backup-file=/tmp/md-backup
++ rv=1
++ case $* in
++ cat /var/tmp/stderr
mdadm: No active reshape to revert on /dev/loop0
++ return 1
++ check wait
++ case $1 in
+++ cat /proc/sys/dev/raid/speed_limit_max
++ p=2000
++ echo 2000000
++ sleep 0.1
++ grep -Eq '(resync|recovery|reshape|check|repair) *=' /proc/mdstat
++ grep -v idle '/sys/block/md*/md/sync_action'
grep: /sys/block/md*/md/sync_action: No such file or directory
++ echo 2000
++ check raid6
++ case $1 in
++ grep -sq 'active raid6 ' /proc/mdstat
++ die 'active raid6 not found'
++ echo -e '\n\tERROR: active raid6 not found \n'

	ERROR: active raid6 not found 

++ save_log fail
++ status=fail
++ logfile=fail07revert-inplace.log
++ cat /var/tmp/stderr
++ cp /var/tmp/log /var/tmp/07revert-inplace.log
++ echo '## lkp-hsw-d05: saving dmesg.'
++ dmesg -c
++ echo '## lkp-hsw-d05: saving proc mdstat.'
++ cat /proc/mdstat
++ array=($(mdadm -Ds | cut -d' ' -f2))
+++ mdadm -Ds
+++ rm -f /var/tmp/stderr
+++ cut '-d ' -f2
+++ case $* in
+++ case $* in
+++ /lkp/benchmarks/mdadm-selftests/mdadm --quiet -Ds
+++ rv=0
+++ case $* in
+++ cat /var/tmp/stderr
+++ return 0
++ '[' fail == fail ']'
++ echo 'FAILED - see /var/tmp/07revert-inplace.log and /var/tmp/fail07revert-inplace.log for details'
FAILED - see /var/tmp/07revert-inplace.log and /var/tmp/fail07revert-inplace.log for details
++ '[' loop == lvm ']'
++ '[' loop == loop -o loop == disk ']'
++ '[' '!' -z /dev/md127 -a 1 -ge 1 ']'
++ echo '## lkp-hsw-d05: mdadm -D /dev/md127'
++ /lkp/benchmarks/mdadm-selftests/mdadm -D /dev/md127
++ cat /proc/mdstat
++ grep -q 'linear\|external'
++ md_disks=($($mdadm -D -Y ${array[@]} | grep "/dev/" | cut -d'=' -f2))
+++ /lkp/benchmarks/mdadm-selftests/mdadm -D -Y /dev/md127
+++ grep /dev/
+++ cut -d= -f2
++ cat /proc/mdstat
++ grep -q bitmap
++ '[' 1 -eq 0 ']'
++ exit 2

--xv00Vt9IRxnYNsUx--

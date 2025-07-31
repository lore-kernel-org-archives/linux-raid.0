Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42363522A;
	Thu, 31 Jul 2025 05:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753938160; cv=fail; b=eox3LmOPbElCrDP+xLJwowfdQXpS6JhDRIDAfQNIalTMT1IpXLhoJ6ldATp3hl80PCJ1fjGTHuBzLDQatkOHrl4ZbZO8LQyGIgzHDJCUBlYNzSItusnyJVH4hkSDjXomRJmnKnRHqamWhCsR0J4q08Z/6w/AMdAn64B3ayrLkmM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753938160; c=relaxed/simple;
	bh=twy1+GhkQYp7njJQjfXcepg+eS+6NfInJaqeRAp5xKk=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=m1YX197YKQYLnIexlE4i3bjkRZU+vHug1cddxIkNaUXaTzVVnd2h5yca0QodxF2MXB37odiywk3j6V61JNJ20jW+jvlTkHR7ZRTWSoHOxPWqACvran/TSAizg4/54V4IS9QlML4CIakkDoESM+qZPa3aqst8dcSOQE3ot5A853w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HYSUFyd8; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=HD+qsriw; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HYSUFyd8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="HD+qsriw"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fxG2001927;
	Thu, 31 Jul 2025 05:02:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=BvHfn1REDrkARGqELY
	fL2UdUO+YUd6kr8kZSDT/WcZk=; b=HYSUFyd8U/31YnlQuUTKwZwgxND8sR/6qy
	KOOtwqyEfkvZAFVUQyeGMobFP5+qSVZ01bv13hwTTjdGT6b8Ds+lyP4+m3ATVztw
	4hp+4d8KWqgSryregjxeQpWdksvVlKX0IWUYHN9fhd/f2lMkLdXqn32AjuIxh9jz
	dzTYiPPAZTva+6X3LJfQj9zogF9Lp46LTX7Wlh0JVj1UGgTCHMPiPAZUK87Af77I
	0TBtJF3rcXqBiKAO7fQBeb2I9ukfFCZpvIxkdy3AvzuIj0u+HsautaZNrw7GZSel
	6Bqm0HMXu60/Hs6WpC23zP0+iG7xtWDG4b7dXGr31chpCVPVhhuA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q29ue3t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:02:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2OZQB002467;
	Thu, 31 Jul 2025 05:02:02 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 484nfc1jgf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 05:02:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JeTHLROFW2WPyxeddCh1PYjhWiqMuvNld1HFi8HeVxj8vpywoQsqd4zlVlUvIBBpbqXi53ohQHLydKY2fkArQprh9sS+RUOBqH+WIZHG2RwKiwbwUTGxcZszaMIOlaz+d4jGMzrQt1keV2mTCSyxFAe0dG4+rgmko0Ue7nBt1FPhL4KeeRlFCqon2goOpKEYNO/Bp5s/X8cXL3fEa9LkPwL74QFeBzmnM0AKMrqD+x4D68ZWfp6JZEejuuDIUD0LljXNCTW/FEN8NUZQ70MuufvR3pO1Xo6r72OcstEt+w5sR3rcFXVcn6E5a0FCRJYh+hxnYIm6Liiftmng89tVRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BvHfn1REDrkARGqELYfL2UdUO+YUd6kr8kZSDT/WcZk=;
 b=ReIX4lIY7nEt3DVFMs1Tow7i/40Cd3NrEVnjAz8XW1/A0Vi7xj3KgstTOyZLUZmmFnh0C9WIyWsZXCwxYxPQs4FNX/g3zGBV/siZ1pQs2anfXMc2AndVNEXTZxOhSpIqa5mczHr0k5LvDIKHw5i6Q1oGwU17Kirb7BQR1EtOV2RS8NAWhQK4HFBJcZk53YtNgsH92JIIL/Q7e50YqeTXxv0gTAhy+eDqxIOD/IqkY2bvu6d+6SCbkDricnJMjp2/kKNqiQuFqn7IRdM1IpvwkIBafEr2EV/5Z3IJ07jAJan6zn7xgg6Xf8enZYBr2tPv2SZGwM6SYxE/DZoFDtrDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BvHfn1REDrkARGqELYfL2UdUO+YUd6kr8kZSDT/WcZk=;
 b=HD+qsriwgn67MAV57kkNOXGKd1k5/x9dx/DywbcXWKFb23xVfCVo4OEUQfGQsNsonhNYOZqKxFiat9ba0NfeUO/fszXnLDCNEJbvEihDlgqXph0YRIRKPEFUYm5IL3WhVwH8SoS9RwafKzHC3y71VznSm2IHKB6bI6m2wNA1SLA=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH8PR10MB6623.namprd10.prod.outlook.com (2603:10b6:510:221::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.35; Thu, 31 Jul
 2025 05:01:58 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8989.011; Thu, 31 Jul 2025
 05:01:58 +0000
To: linan666@huaweicloud.com
Cc: <song@kernel.org>, <yukuai3@huawei.com>, <martin.petersen@oracle.com>,
        <hare@suse.de>, <axboe@kernel.dk>, <linux-raid@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bvanassche@acm.org>,
        <hch@infradead.org>, <filipe.c.maia@gmail.com>, <yangerkun@huawei.com>,
        <yi.zhang@huawei.com>
Subject: Re: [PATCH v2 1/3] md: prevent adding disks with larger
 logical_block_size to active arrays
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250719083119.1068811-2-linan666@huaweicloud.com> (linan's
	message of "Sat, 19 Jul 2025 16:31:17 +0800")
Organization: Oracle Corporation
Message-ID: <yq15xf9gdhs.fsf@ca-mkp.ca.oracle.com>
References: <20250719083119.1068811-1-linan666@huaweicloud.com>
	<20250719083119.1068811-2-linan666@huaweicloud.com>
Date: Thu, 31 Jul 2025 01:01:56 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:510:23d::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH8PR10MB6623:EE_
X-MS-Office365-Filtering-Correlation-Id: f40ecbae-351a-413f-c615-08ddcfef60bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3qq6BiqJGVJH895XOHwzGboDWMKj5MLgFnrvJdsDcSxlDDpyBObkzisjwJKn?=
 =?us-ascii?Q?gqqR2WGGKUUqbVrss+O4hB838CxXgSfp3B4zhtlUAp66l/7glSqiFWG80If/?=
 =?us-ascii?Q?MFvQ/n1TWXVnHilQ/+NZjKmoQDl6iGvi4pfHEhBvm91hhoZ4Oc92K4ZFnib5?=
 =?us-ascii?Q?h3q5j4HdeqrYMaluN7cM2REnNHBY9sx7H6fbmF/XrB+bWzCIsPtBYzQ18FOC?=
 =?us-ascii?Q?ELW8bLQdJzkd/ITUhxHwBol2k8u/8u7N3R5E9kRtA/1Kw6scm+LQrp8gjZJ7?=
 =?us-ascii?Q?7A/LjDeSS9yneQZgbisq/svvCSiOba/hWxEm7a0RiMyPdasO0QILNms8gacF?=
 =?us-ascii?Q?Np0734OvQmyP73dUXtyO3+h1B2IvAR/zIm5mL6vn3fO4/RVnhOVqAPzSYRnV?=
 =?us-ascii?Q?YfecK+b761EQmBOrOm1iPaPU3GNCVvah28MPaLSQHmIXA/LknK/LumIf82la?=
 =?us-ascii?Q?Wmn9C037OT854ndKxrxkX9boK7AwTvwDRdOjt4jhK5Jnk7gG8L9DMxL3uP+0?=
 =?us-ascii?Q?uI3vb3sYyzKNYvUu79I3X+IJruN0u2Iqs1q0LuB5HZqH1ZwXAdRX8CCVR0HQ?=
 =?us-ascii?Q?9hkpZWgeY7041dwpsT7WxI65ZPctDc7H5OW6irWvMfC8tm/KAKI1Z7+EEA27?=
 =?us-ascii?Q?oSGnTEaaGJpdjHW0vcJAN9oZzn0OMpyum7Fftym0kYd3CQij75k3bye28ax3?=
 =?us-ascii?Q?EaqhrGnYXn9ws0nnImR0svssWluffvShBW9sQ6czI9JX1eC6xD72a3dQxneN?=
 =?us-ascii?Q?nP0dWNoBzeBnFTc7y6UrEPJ5auvdcOi/WMjYsqRwL97b01qfWnBHoQgInuIF?=
 =?us-ascii?Q?1+RpdOsd06olAvf8XQi8ZOHbF7SYUE8WTjJkTdj3ljCI//jCMzopFNQdPblz?=
 =?us-ascii?Q?58wWC1HuMiCev7eRAxk3D7vQHnoGb3jzLsgDZ8aD0Cg1yBdUEabVCwnehLAD?=
 =?us-ascii?Q?z/EHmzs5DwdoUsWWAQAKox5jA48lXHxHvY9eLbcl9jDILOt7giEgC0HQ2Bby?=
 =?us-ascii?Q?/acpgOcSl2YVUinx8xsdtFyCKu5JCx52CGMMY8E8+LXs8SdSrsVF1HG71BNr?=
 =?us-ascii?Q?Cyhtm1O+Mx4+yoWYFsk0t8A8xbbwMoaDVSj4ilubyUUeUM+GA3+/thpFBynh?=
 =?us-ascii?Q?O1B6SWRiRvAiuMoa5CPcf6XkqsB87jTNTEAi4zyxCorboi9Rx/oylhMcKv9x?=
 =?us-ascii?Q?Ff894cRPwmEpnd7CpeSSgQNcES6mzX5U+ItJrYNMMKI3bEeF1QFIkDzuQ4L7?=
 =?us-ascii?Q?Y84m1/QPj04vzIId+u3X8BXDi6WAzLvbgC5A5+xSfka/tcT9TdqyLR81fZaP?=
 =?us-ascii?Q?nGbevvJe3BMCmD4SYvXxSUJpASax4y4IrJPU+QAOAkWzdMFg49RxIbkAzkjY?=
 =?us-ascii?Q?g6Wz+frg2Gup8qBbrYrlXFRUIfdzzD/9yxo/M5veVCNi+s47E/kYgvzVDRWM?=
 =?us-ascii?Q?mviYhY2BEPE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?F6G7/M2jgzhKdq0EiNsaL4ObkEmftJz01O3aWR/xsfJkJkrRJERKfHWoyf5A?=
 =?us-ascii?Q?yLDTDtZdPQnurwanF1N9UzOEEmB8nVG9Oo9Yj393OeHdgnmGNJ0i+RARqYsK?=
 =?us-ascii?Q?l5yrIXIW9ktS4q3Ha2JTzKKSgfUEXm0DhY7S7AGDcTaYC6GdI0lzuhdNNwBq?=
 =?us-ascii?Q?BvXneSgLNZ6SEz9x3m/MEWoFbVTlWdqmHBFW3alj8w5w1g50Da1My8DDlru1?=
 =?us-ascii?Q?bk4ExI2wcWrqOhQOOF5XZjvtO6DhBls9vL2JnvGVC+08cFYCr8eOL3L4boVV?=
 =?us-ascii?Q?qWM4Hv9KV4URptWcKLUQAHc5gxNMb1VaDAJ9F7xGq52OvBN8g7xxhdxh7yMi?=
 =?us-ascii?Q?9A9i4sl4uXPUPPOeqgmWvr7GdwTvlOE4pJ/fRGL9XHD+I64gUDR5kfIYK0Da?=
 =?us-ascii?Q?SVcUSxAA7yKphtUxgjqD1vlCQlSL0nlBV/ukXzZRtERXE5UbwCQBfu1wu5YC?=
 =?us-ascii?Q?L2eLfKxQucYstQcL1QPqcmXsB5y0XwZ1K4m4NpNAnuYVb1nlt0KaHPbWID2e?=
 =?us-ascii?Q?xEtql+hhQ9mQ04465mlyuAOTBf3IWOGLfFFi8JnZdzCyeWMy3hg9BeceVuQL?=
 =?us-ascii?Q?Ph7UmOWf8y5AFiwlIvhzwhnBkqe5LvKxkKvba7SPOsMV0Phzt9ysPSdw02yV?=
 =?us-ascii?Q?Wf7vOlHhw5G3EAXaz2xe4hkvmDWMQ7j4CDImKqdI1xthMfMkKWLotadjcx7/?=
 =?us-ascii?Q?BvGw0XyzeuxFhq3Uv9LvlsI6jW37mGKPoprG2rIUKwY5eZ1csckolsdv6hH4?=
 =?us-ascii?Q?Ac+FvfBZMBi2Y67jMXmEaRgMGHLkTDeTLF3bfbMm4ZbMk7tPV7xiOhouGXtl?=
 =?us-ascii?Q?3fP67YCwrw2dSm8/RrNOaVcMUqJAVTbt9Oc+1+hwyQgyFG6NdNT8M/y2uCf4?=
 =?us-ascii?Q?DVpd9dj3T1e47WXfyEpuU7ZgkK9oSsYxAmOTNaUjVJ4BQvKS+ucjp0Ynmbmv?=
 =?us-ascii?Q?UakXrOMa6MoXR+2bUf8bJQAwlLyK51Kc3vtLVUJaxREnxxnVGviHhgbfeMIO?=
 =?us-ascii?Q?5BtjdLuFGyCpJc2+rYA/yGe/PPs/MnqbaVRxxu84HER9CI21xOgGCcSUWnpY?=
 =?us-ascii?Q?N6Qxqz5R4wuwsMX6uOcPpFdWWnIudkvSACEqVY5rmkEv67p9m6v46oVKBjuE?=
 =?us-ascii?Q?MatJKv/3apwo2IhvMguGEWE4akE1hFGmlJfRZov+bZPhcrLV78Ookr/b1a67?=
 =?us-ascii?Q?VrR2cZ3+XNQKdzdbS9vABvEQ65dhTSfRGPQAlZTIloX92zOxC3vYbG8gKjWd?=
 =?us-ascii?Q?J4wvFtopc2wF3dMLnpGzeIDdOiWs9Nv1+fVT2JU3Re7NsYu3hTjElUBnAkXT?=
 =?us-ascii?Q?Ze+IE5OEDIQ5Y9u4v9YU/dXkjVGVtuVl2wj5c2l/S25NFlcU09J5+kLPGH64?=
 =?us-ascii?Q?v8OL7JiwRd5ZY0OY8x2xRAVlberUnVhopes7FumM6bdZT2/iWyi1Mc8jIfyK?=
 =?us-ascii?Q?sJhS1QpzB85NmnB+ItaqzWJS+SUmb9HMRuifvmAngrwL8OJRPAtvNksy2IRD?=
 =?us-ascii?Q?rUSYGTp1m9O6bsUdsgf+aFQk7A5zt/Q8vwMSxdYslLKQ3fUpXgIVlzV5qwfp?=
 =?us-ascii?Q?5znb3fkWm4LMM8dnd16Lcdos1qbnbOBWAA3SxNGqx6oM9DJsJJWd65GnK6dr?=
 =?us-ascii?Q?2w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sFtlGvcPXvLR0dyMPkmwQQjMRMhKoShQP1QwMMgq0xKfqkJXQJHUUfo6Nbo0JhNrFnOq/EM6PfLO5CB9wt342fmN+kEu7kDn6fuoD0eQx+pWIOtJ9afktae8n4Z9jg36tYORF4IdRODp3Shl6UOtyDpMU7uoykkB0Dvij47nIUTnflKzxAPWlAVZfidZqLix2KMu9SghMrLy6qrFIETRCwMlTH3hqIJi7mFXowIzB/xtd18zxpBGxhCSJDr2h5UqShN9y5lw29mZ0JadvVA+sA50RanOzCjWb3jOwx8X/7N7waLaRD2mKC0WhxkVabwu8KJjI+hU0Mqzo/zIgLBiHPGKyy5v4E77aqicGoxq5bF3baesq0ErEOzZWQvdhQItl/QD+ETKVLICPo00td39+fjGIE/1XWRJetSN6lE2npfz9qzrUlcugJ5BmBKcr3V/srw5k3zqnscyBlQOOs0ZnJAldpk4xJNVDSIqSuKqjw9XTBpvKe3eYxbQ/gSKtTgXiS97/1s6RWWy+1op1+uFyzdVGf3HsbH8ARX7H7ACJwPnqhfkrt6ut+OAqwWB1KhR5DQlwZ9b3sa0vovbfCqE+Sl0gMmo2fUXGaALb845JOo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f40ecbae-351a-413f-c615-08ddcfef60bd
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 05:01:58.4754
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kCFKsiZhJfIDgHC7D3RwYNVXYvD01g3RMmtZb/VijgBtkR+ruJ4dXta+7bynDCDBs+Nh/fcF2qFB1YioAz+dOvkBgmbkqtvj4OoanHj46Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6623
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=937
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310032
X-Proofpoint-ORIG-GUID: 9DvNKkvivtvYoTV3VXNrXJDroEp6Maxo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMyBTYWx0ZWRfX+63N0qzAInHu
 AcLBKTrSg2HZcaEHP8+rYvVDSBtzo9yYsaRoLQ2YofHXKn6+p7W78NqIkmk1L7cnXDUBlU2c1xH
 iP1zwBfAOE/5lJbVPQYEpMo0C8lYTWdmIIPbfNrMeRmNfc/bQdweJLB6HbPXN0tdM7CsGYbY8eM
 iVqrSn8bF7jFcG83lp2WlDNpDK0hxx5Aq1XDO748bBigFg6PkXHaKL5zCLLHWlwumJ3lpOfo1na
 s0s6mH6IiV8CavzYZcn30O9vmYfhavg+Bw65MsB613YrVGwluAY7FvcukYo98OzDGDdPd2cyDnP
 F+7NmqcU+phUz3WzyuibuLOL0He2RzozNBLFZ3CeSDY1AGc6cc2xo5GacZDPItKWPt/40YZkMbj
 X/Cs6zo9gNaPLzrHypG/3xAXgGRsBFHQbEfSLi7xW1FtvK7/3IfjSTc1vg4LuYxvS1fL9Sjq
X-Authority-Analysis: v=2.4 cv=FvIF/3rq c=1 sm=1 tr=0 ts=688af8ca cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=ikBoMZQHXwTdqLo04pYA:9 a=UzISIztuOb4A:10
 a=zZCYzV9kfG8A:10
X-Proofpoint-GUID: 9DvNKkvivtvYoTV3VXNrXJDroEp6Maxo


> When adding a disk to a md array, avoid updating the array's
> logical_block_size to match the new disk. This prevents accidental
> partition table loss that renders the array unusable.
>
> The later patch will introduce a way to configure the array's
> logical_block_size.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen

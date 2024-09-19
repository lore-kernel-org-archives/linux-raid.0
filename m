Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A621DFF7;
	Thu, 19 Sep 2024 15:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761026; cv=fail; b=QVUGQMB3bDCLE1m6oOgn/W9gjCvnclSuOKrqOUCnTvWSsdEzMQNrYwDTGH935ENbGpmA4Ss0oT1a1bJF5d4X/pwazf997CumbyMvzV5NAuUro2Ttkl6UetNYOW+jvOgIotY/GSlHjymAefLnruptV6Cfb2m3ZfOABajTyg0scDQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761026; c=relaxed/simple;
	bh=j0HB5VSPaRxlS9I7mHtd2ul/0vGcjJIGdiWjauTuQbM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q8VqEKQBWgfARVTu5NXic4ohVMgHteMdl4CRd1ut8M+LnasYEUEDSS5/2LixQO3Nrbqt4cTflKVqKhw5G41MksFQs+fWDKAkWCtBHa2yFGN21BjF4vTQX1MVtpT9E+A/HNPoELFpA9IaFqxxAlH6WZhjMDj/zoff/jIFmL8ayWE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com; spf=pass smtp.mailfrom=wdc.com; dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b=CHxCb4yH; dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b=nuWHIJFk; arc=fail smtp.client-ip=216.71.154.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wdc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wdc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CHxCb4yH";
	dkim=pass (1024-bit key) header.d=sharedspace.onmicrosoft.com header.i=@sharedspace.onmicrosoft.com header.b="nuWHIJFk"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1726761024; x=1758297024;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=j0HB5VSPaRxlS9I7mHtd2ul/0vGcjJIGdiWjauTuQbM=;
  b=CHxCb4yHZIuMllMgaIz0TNGJv8BT9ZYGAZIwDzKeeozheDYw0IiZHdfB
   WKYBEjxkScSBNQ/XY3QrtxbEN5TlsXf33LUMeTIMW4Eo2PoLEcemXTF6e
   DpL/3bs9LXyAAAcxf/MFVQZQNNZWUcckmeBIzd0DlPlJ/E88+Y9lEv51I
   O+X7D4lLIwQhrJBzPfS9sN2lUVtM/PLhH3t24XpcwHXm8L99OB3iFBEI9
   tMaLBNwoq4bI7YWsht35XvJCajQC6Rtx2GfXIWKdOit20tZrKr/TGOUG4
   B0g86X/A4ajFVmD+PIgQ8RD3HG187oameqQNb1ugFni7ogkIov0q3n8LG
   w==;
X-CSE-ConnectionGUID: kik12147Tj2orVLI02+2Vw==
X-CSE-MsgGUID: z4hGxcplSdmL3yfltO51qQ==
X-IronPort-AV: E=Sophos;i="6.10,242,1719849600"; 
   d="scan'208";a="26441751"
Received: from mail-eastusazlp17010000.outbound.protection.outlook.com (HELO BL2PR02CU003.outbound.protection.outlook.com) ([40.93.11.0])
  by ob1.hgst.iphmx.com with ESMTP; 19 Sep 2024 23:50:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ciD8IdE7sGpqxxILcaqudr37yE99NYX9SUl0w0Cne6JB2MLEOWX1IWHRIJUtED12kz0F22pf4hktW1Ym4m+frix4HkloWUn1Z06+Vu97Bys0UjLEbGJnUDCw5Hgg4t826v9jU93Sgfr7PT5197lMz6cDIs2pzyQ2nqhh8MocT+Bt96vwuB75Hp+eoCKbsCVBdr9N6EB6FuySOXa1EkwlVPTsfAW1VNSa6GzOj+4OUKO3GJr92czEc/XdNo7ZMNcOZ1PSBDF7MeDPrSeEFCnWZNPJUWdhVj0isj+OaJRIjDSgv45/P6Tp8OfW/OAmcCzCWrQVUn4NZVt0JxYYaZZj/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j0HB5VSPaRxlS9I7mHtd2ul/0vGcjJIGdiWjauTuQbM=;
 b=JtJ4exHQzS5/dS9ct/So9IX3hJcelfW55FI1jp0Nd3DYlNarL7zSPv1kHqZ30nc+sLqNDsrwkOZajSM7WZoJY4IRdrWY48iFoaSFRE8SiQKfLBCbvCIqoIgckqgAxcDdNwEb1MArI+OAo3ln93X+ZvWnTjbcP0yD1N3MHe9fHMpftxSIJDZFmMK3hwmcdVwizlbe4xOwJMMhs5k/6ALrUeZljFMhzO+KZ6xvnBXnj4QfjSnBqBFX1lK2IMBn+iigodP+OQafLcA47Bq/3ibevNgpzSa4n8jHaOYyAFflgayQWsD0z3LWaaDgL8Un0o9Ryrsc1DgWW0lcbQR6yUHwRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j0HB5VSPaRxlS9I7mHtd2ul/0vGcjJIGdiWjauTuQbM=;
 b=nuWHIJFkLMV3MFHJ+VDV7QrCtORr1c2ozjQ/jfyqZi5ZCv2ZpSCmuZnVT0FkwgiWXrRluNM1WjxdgcSG9sLnD0Xb78CQLn4GfiQeORf7nSobsLUe85kF4LT2ZDGiKPuePU8/JrdQojtSh+ar+5nn89WiUzzhEZCoM5xEJTdmYfA=
Received: from PH0PR04MB7416.namprd04.prod.outlook.com (2603:10b6:510:12::17)
 by SJ0PR04MB7325.namprd04.prod.outlook.com (2603:10b6:a03:29d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.25; Thu, 19 Sep
 2024 15:50:08 +0000
Received: from PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969]) by PH0PR04MB7416.namprd04.prod.outlook.com
 ([fe80::ee22:5d81:bfcf:7969%5]) with mapi id 15.20.7982.012; Thu, 19 Sep 2024
 15:50:08 +0000
From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
To: John Garry <john.g.garry@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
	hch <hch@lst.de>
CC: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>
Subject: Re: [PATCH RFC 1/6] block: Rework bio_split() return value
Thread-Topic: [PATCH RFC 1/6] block: Rework bio_split() return value
Thread-Index: AQHbCnXOOAQPt3iRyE29R+sz4/1Lv7JfQkeA
Date: Thu, 19 Sep 2024 15:50:08 +0000
Message-ID: <cbe3c6f0-cc84-4e92-bae4-5433ee0549e2@wdc.com>
References: <20240919092302.3094725-1-john.g.garry@oracle.com>
 <20240919092302.3094725-2-john.g.garry@oracle.com>
In-Reply-To: <20240919092302.3094725-2-john.g.garry@oracle.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla Thunderbird
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR04MB7416:EE_|SJ0PR04MB7325:EE_
x-ms-office365-filtering-correlation-id: 439eb631-0df6-4bfa-08e6-08dcd8c2bcb1
x-ld-processed: b61c8803-16f3-4c35-9b17-6f65f441df86,ExtAddr
wdcipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?cElXazBqb3kvUDRSN29vTHdlT3ZlZUdTSHVjZnVveFN6OTVFUFlqRFh2cjNk?=
 =?utf-8?B?a0ZZQkJlS2oyU1ljT1BoZkN4MDY1YlJGYnFWblUvalZpa1UzbUppdkpsTlhD?=
 =?utf-8?B?aXBDWGJ6ZDlsWUErTDJGaStUU3ZNMENici9aYTRLK2phSkFtVmhjTGY5djZa?=
 =?utf-8?B?V2ViQVFuSGlXMHlEVVpVTHczMGpCMDN3SU50d0Y4emlML2k4WG9kdWo0SXdI?=
 =?utf-8?B?UzRaNGlPbEpMd0djcmEvRmRvQzdRa21jeks5SnZBT1pXK1U0cGN0WjNpYXhE?=
 =?utf-8?B?ZGJhNVcxVmZGaUtkY1BCeE5IdXZoRDljQjZFR1ZnS0FMR1FrcGFTYTRrcWcw?=
 =?utf-8?B?RXNQNno1ZWhTb3Qza2kzQUlTTDJLRC9JSXRjaVFuRWgzSUh6NUwrbUZZcHAw?=
 =?utf-8?B?N3V3eEpEWHZXb1ZMVFUrQ3BqZGl0b1Urazh1S1JqckxOcFd2dVFHR1lqaldP?=
 =?utf-8?B?dnlDREZZZ1QvbDU5aVU1dmU0OGROVzhRZTBTc0FpS3FVM0dnSFQzY2hndVE5?=
 =?utf-8?B?QVF5VVgrYnUrSDNweVE4Vm9WejAyd1Bqd0VxNXVxbGpqaTBPNGJCdTJsdFli?=
 =?utf-8?B?T05oTDdXMlFYQnJzMDNuWXlwaldFMENSMGlIRWZYOUEyb1B3NTVaME1VVUVP?=
 =?utf-8?B?MDZubGVXeVp6Y25qeHFtbjBSM0xYTzh2eVdqaDZzb2owZEVCZnhTVGxFWEdE?=
 =?utf-8?B?Q0NIQk9Mbjc2Yk1TdmxyUWhoaWFRK3E4SFZOMktXNzlZY3FQM2phdWpzcnZI?=
 =?utf-8?B?Wm14WnlqTTNwRlZsaXExcEN2T2ZTRjBHL2R1OUxDdVBXWmNUUGlVcW1NR1E2?=
 =?utf-8?B?WkFaaisyMXhSZW9sZEdpN3FGY1l4dnF6UU8vTG53a2ZwbGtLbGloeTV1Y0w1?=
 =?utf-8?B?R2VaZjhtYVp5RDh2MXZYUDV2bXFZeTNUenJpT2lZUjNjdnlqVjduaVpTZ090?=
 =?utf-8?B?L0hXSnJ2QkN4QTZTT2QrbHRrRWhMbTFtb2Nha0JDVkNzL2xpcVlydVo2NWsw?=
 =?utf-8?B?aFI4dDJEdlVNK2Q4aERobFBEVUJudUdNY2gvVkoxaVNBNE96YlAzVnNYOW5M?=
 =?utf-8?B?MUplVEV5R3Axa3A0QXJQUTcyYWhzZGlkN2l6MXZTaCtOTlFSZnJGNGZJc3Qw?=
 =?utf-8?B?ZzVhSmNLenNSV21KSDI3SSt1dmFMSDRmUDV1Z2k2cHl5bGEyK2tmVzhJNTh5?=
 =?utf-8?B?alk2MTl6T0ZCOXZQV1hjV1lwY2RtMUZSU3NNOURnbkxnb1FOMjVJdU10RlVr?=
 =?utf-8?B?eUg3ZnZIREs4OS90Mlh4WitaK0FoTjJYSFZzbzI0MU9NdGoxd0dldmRqRkoy?=
 =?utf-8?B?TnIrWWZRWmJMZEI0NUpCRFFTOVl5KzNFR1VSWERXdHJSK1d2TFZCVnpWeHQ4?=
 =?utf-8?B?OWJuajdtY1NvSTc2ZjBWYUI4eWlnZXFGdThJdlNyQStsTmNZYWhBdHdVNDR6?=
 =?utf-8?B?YURTVzIyNzlFQXRyUDYrUXJBaW9UY1J6TXVOYXJqczdQSmJFbXd3R3hmOXF3?=
 =?utf-8?B?bkV4MS9DcjBpTUcxV0RRT3hqZFBaMDZrMzdVODI5UG0yQ2JuUXZsa0w4bE9N?=
 =?utf-8?B?b3VaTE5IRllTa0liSUxtazF6OUFrVG1RTnllc1BKTUNDWnFCVXQvTG5lWFR5?=
 =?utf-8?B?SU1MQzlBdGFMeFVzblJ6RFZrTENsNTJBbFZEYnRrZzhhUjFUcEo0dHFTa3lL?=
 =?utf-8?B?VUlVYnQ5QXNVM2NNcmwwQ1luanlWMjQrQWZzQmRkTHVjd2EwUGlaTSs5emNI?=
 =?utf-8?B?UGNKSExJVzNta3ozUGZ6WW9mMzRoWTI3aHRNRkZLa2ltNk81dFF0MllnanZO?=
 =?utf-8?B?cnhUZ3F5blJqeWNxVFAyY0QwcTJDZ0krU2M2WlVNNDFuOFk0K09TS1huVE9s?=
 =?utf-8?B?ZnNSb295YVBudEhUTFhxMjhhZ3lJZUFjbk5iUnVWT0xNdFE9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR04MB7416.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?Snp1QjRLNjRKaTk5N2gxcExlOVkvNFBTaWNrMUdweUt2LzhhdHNuS05SUUxz?=
 =?utf-8?B?ZHFhNGxSR05mL1Z6S25OdW51UzVXQmdiVjExc0lRUlozK2ZqeFF6YkxrWlBa?=
 =?utf-8?B?OThWdFVUUEdrMzloaThWTGZmMXFPWkF2SmxxTHVVTUNNeFJTOGRwSHJjODdp?=
 =?utf-8?B?eG8yQkFHTEViWVQ5dFZDdlVnOWJkamVsZGRmUmNEV1plR01zbW56Mm1CSHRX?=
 =?utf-8?B?aGwwOWNpNGlZb2dzVVlvRTM2T0duRHBMNStoQnFnellLOCtyZFZGNEdHbmM5?=
 =?utf-8?B?cWlMZENwaXljcytHdEV6YlZNay9TWU1rRlAzVU83b09tQmFPTVRzN2tnSCtW?=
 =?utf-8?B?UU1pQTU4NUR2c1VKMkxKaDZlTWFsQ0pPODZCME45T0JlUXhMbzhJQ3N1N2tX?=
 =?utf-8?B?ZnYybVBYMVZHaWVLcnBQMlp5SXlBSGp6REtwdWFUQXZYVkZreUU1VnFnR1o2?=
 =?utf-8?B?YnNvbU5QNUtXM1BXUXlYVDlFRE1WUUZhanBSK3ZzS0VSdkFVZC9lRnMva0t1?=
 =?utf-8?B?Q2VkdWhCUVYrMlRQRzJIdkphZVFvYk8wMnRHNDl5TmVWMzd5ajdyQWlBUlN5?=
 =?utf-8?B?UlZEbDZlcGdNQkx0OEZ1cCtNeFFhK2l4bmFsVVVXd3h1Mm5MVE0wcDVjWFVO?=
 =?utf-8?B?Q1BUNnYwN2pPZTEyNWJ3R1h4VDdHMGVtb1dPRFQ0bThpRjd6N0s5NmxHNVhM?=
 =?utf-8?B?bGVWZTJGQmk0QXo4NUc2RkVrODEwNzk1azdsNzRBdFlGS1NiM2lLZW5YZS9r?=
 =?utf-8?B?eUNmamtNdzN0S1Y5RjhtVG9LaXNyM3QyTUhrbkFHNXoxSHpDTW9mNEJDMmNX?=
 =?utf-8?B?MEx3NlhjdXJLQzhnLzZmMEo4UjlVQUNOQ2lJV3g2ZHYwU2xMcWpBZzNobGFj?=
 =?utf-8?B?ZjVJTHFhcVNmUm93ZXkwTGp1UGtURC9sWUJuSGtJaktxUFE0MXJPdW00MUN2?=
 =?utf-8?B?eEdQOUxzS0hBamp5V3hHc2k4cktzZWQ1UXE1bFR3TVdyWGlEaHZ6Q0VzQzRY?=
 =?utf-8?B?NWFyby9hMnBLY21ZSnNTRE9XV295Z295UlZKVStPODNzUHBQTDMyVkF5cFly?=
 =?utf-8?B?M3pxZmNpUVFMWm8wVEkxWmZXZ3NNdjZETGNnOStUbmxESkxLdDBVZktMN2Na?=
 =?utf-8?B?K1ZvbkZoZmVpOThQLzdrQ2xrUmRtRFJsUk5ScnNXa1JCdDUvNDhMT04wZGFG?=
 =?utf-8?B?bGx3bi9nWTNSOThXRGN6OWRDb2hmT2NVK1AvMTZSbEVJcEVzc1JNV1Q2NHcw?=
 =?utf-8?B?cUloVlh1RHlJUWxkUUZBRCswNS95WDg4d2N3TDMxQ0QwWWRFVXVYcVk5Lzhn?=
 =?utf-8?B?L2JlY0MwVTFpTkVlbXM1T2hSOHRYTlY1eTBCa0Y4YWpZNmlVYmE4bmhLLzhK?=
 =?utf-8?B?WCtJQk1FekhFclhLdVBIRW05a3p0NU9xaHZSd3hyZTFZM3dxaDhuN3RvRGFJ?=
 =?utf-8?B?Q0M5Z0Y1aHdzRGh3OGM5cFdPN0s4ZGpFNmlyK09PdUhDcXJ3d1dPcmlsY0hn?=
 =?utf-8?B?SEd4eTJ5RFY2ZlRGQlZIU044N054cTNDVWpMVVFwbGxubFVMQlRDT3NZdFly?=
 =?utf-8?B?VWxiMmRXWHRuQW5ISWdhYVBIU0RVOUhRdU5CSjU3cVR0T1V2VERVU2hZeVlv?=
 =?utf-8?B?OTM3MGtvU2FTVS9uZVJodElLVE0xN1FqY0YwdVNxQURRbGwxb0xuZm05R1Yw?=
 =?utf-8?B?cFZCdEFhbW5xc1FBYXcrdkRZeGFWTFhlTEJhbDhkZ0NEbFRiYjJ4aFQyVnYr?=
 =?utf-8?B?Q25ERU1Ceng3anNCVDZqdFZ4bXpxOHdhZXhjMmtZUkxlNzBLWWhIam5hRlh1?=
 =?utf-8?B?NklSamQwZnQxYjgxaFh1RC9vYzJnRTlrVXFwcU0xU05sQjVtcUpKMFRSTHk1?=
 =?utf-8?B?VDdXTVRpVWNJK3NmcHEzdCtLVHRSdUFGS3RQVGJETkVKeXRCTElYUFJCSWRH?=
 =?utf-8?B?Qk5qZkdWc1crVmxoWnJGMFNXc1o3UjI2dXh1MzVjZVhWUld2ei9Ma0FRNUNM?=
 =?utf-8?B?SGZRL0l5ckFra3JqYkRpVXBLd2U0SFhOY2h6ZURROVNZWktIaWJqQTgvMDBX?=
 =?utf-8?B?eTJlNGFqMmpQMFhwbi9ETXZucjJYdDM2NnprWWpITWQwSTNpOXorTTh3VTFV?=
 =?utf-8?B?R0p5Z3FvdmtzYVdmcU1jYTRaRllWdmhiRU5JSXIyWnNWMWVFcElTVEpzaVJr?=
 =?utf-8?B?M1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <08EBA11B7D0FCD409C059664B3657769@namprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HhUIPMlvFnoY8mct8yvqUbXD0Q+JWCIU/3YhcDhvhm5sWBjPPPONp/i2jk1G8nhOB4SUCSzJZ6PJ2Fdjp1w+uyp708Ke6t1RK+8IZwltBraPgXfD8bF7h3qi4s4euIwnUopSHiMmyqU2yLzWylMWK9giVL7yNOTNmKOGd3wIiA2YG+amRCclcjIHyEXvFGhbFjXpRsw7E6OQAA/bAjouHiebaxTgHXEQaci2bYrgvpF8gG8UXcaLADGwwvfvJczmcl4Y9n9ABgixAYGU1TZbmFAjoBm0xlk8JRsYdYhxMkNEurV3hgNjC2K6KxxGjPBZ0VIZLpqWVbOlZVEW2wBoyBGlfC8p0wENwdBWN3kFvQSXxLG1s4yMlkvCCgjWXVanhCMxcpRH8yguRirGeFsLIXCtYMB20hCdGdAeZXWy6oURXSnAsEm5zMRSHpyxt3PSCBqqOmG/V5H0SWYKUIaSN/zNQgBB1NZQWZZppkz+JH2qb1UUBUoJt8RvFEZfuEE/qxeGG58b7+sPeHDajm6FZ08Hn9jiso7OufiGwD0JPrxq7ZiM2+9QcfymQulVrW1LM1Bo2SilpujMJslix/rT9Bpks9q2lYY/qV1LT0hYlv1t7P2IjHV66oqWIH9ud/hU
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR04MB7416.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 439eb631-0df6-4bfa-08e6-08dcd8c2bcb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Sep 2024 15:50:08.0519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HdyzWHrajTYCSB8ScDajKShQ+BH7psljiicYNZSsDl7e0rjZp12mlPim5QNDXbfvVpID0+dLumZiugDtmc1Ht/1wSzouNigXXuRuoPPq1iE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR04MB7325

T24gMTkuMDkuMjQgMTE6MjUsIEpvaG4gR2Fycnkgd3JvdGU6DQo+IC0JQlVHX09OKHNlY3RvcnMg
PD0gMCk7DQo+IC0JQlVHX09OKHNlY3RvcnMgPj0gYmlvX3NlY3RvcnMoYmlvKSk7DQo+ICsJaWYg
KFdBUk5fT04oc2VjdG9ycyA8PSAwKSkNCj4gKwkJcmV0dXJuIEVSUl9QVFIoLUVJTlZBTCk7DQo+
ICsJaWYgKFdBUk5fT04oc2VjdG9ycyA+PSBiaW9fc2VjdG9ycyhiaW8pKSkNCj4gKwkJcmV0dXJu
IEVSUl9QVFIoLUVJTlZBTCk7DQoNCk5pdDogV0FSTl9PTl9PTkNFKCkgb3RoZXJ3aXNlIGl0J2xs
IHRyaWdnZXIgZW5kbGVzcyBhbW91bnRzIG9mIA0Kc3RhY2t0cmFjZXMgaW4gZG1lc2cuDQo=

Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2125.outbound.protection.outlook.com [40.107.241.125])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 876A6DDD9
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 07:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.241.125
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717745380; cv=fail; b=QNqI245GYfH3RqoAg4qOcZvaBLy4KslFBrzTrFDho7ZaP+khhawFhgfkm00kzAq7O3yBwO+7XNq/oEh09MFz5RtMQhpVL48Z73tXAJ3rP/TACc4O3OuJxRWyiTjiXzWr0HMMZekqndc1gHt/thVkOJ5P+6h4dfMMWGYeycSbpP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717745380; c=relaxed/simple;
	bh=E5SFnatWx4miI6mJPaP0S+a+TZL04UTUuvV/2tQ1qxE=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=nJ1hHm52IFfKYQRYb5LvFm76mzjs6gxJPEbku+x7gFc7jvBKmkT5S5C0w3zi3Gje8/eys9+kVRCpgAf7CJIa41b4ATnwydyQAHaeu7yuttyr8wngW6YIeU2w5jSitIC+LvBWArUuOjbe/pKA5mDe+8R6M2YVTfzkDm7pPOoLbiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com; spf=pass smtp.mailfrom=volumez.com; dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b=gv9Gwgy0; arc=fail smtp.client-ip=40.107.241.125
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=volumez.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=volumez.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=storingio.onmicrosoft.com header.i=@storingio.onmicrosoft.com header.b="gv9Gwgy0"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kfcQkwV9/cSDu8BF8WMk/+rTFMNpujKu+EdJulD+7xIBvqyJkN3FnyKQQ0Kw1SKZIdAf8KkaaVbZmue2FmwBNczUaZMQRQrgw6eEME0tvKZRai5Ya4/ujBj3s5AMR51G94idMQ1fjeZy+/F4OLcCC8FGcVUoIVBakBXXJogs5Gc31GrRNVgwfKO6uFk0aTs/kJp08+hFo8Yj9yWgxnkD5HXB6M7Ld5JOdTtdPHJfhRUowLOkHyxi3tEqPXf9JapmlokNoCTt8HBpN/tm8909YGaSVDcGXW2VdcDysriL5bagSDiPtNQYivpGEh9Sjr4M9C9tkDXm8OreUky079gcJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OK+qM9V2Noycz6kZk/3gDJaWj2ehTJsxlOvZgRHeiWg=;
 b=JCEDYFgn7+1M9EiQ4PycpZDil5JYt0wU2LDkWqcYHP6miOrLKrh4yk4u+h2N8oqXjaXMHvWJSrmhDI3o0THruXsl+g978Hyha5A2IiEyNMbnmvk6P9Vr+qJ1z+y3zYJT2DcDqui/CcviJAsTTXiKQnE6tBVbHtivCiXa/cS2KA5XIviZGnQsFdcAVsbk+bJJdHv/SK83wI87ns8wAqK0aEaS8Ol5goX+l5yQx+L9McmDqX0lMNp8otvHUlZekCr+9jZLpBfeVadq7kHTRHv+vxx3uxWplba71RUBXtcsz7mN8PP6xhoneu1fcywrv2GMyAgg+MtrHxzde6JvBOn01g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=volumez.com; dmarc=pass action=none header.from=volumez.com;
 dkim=pass header.d=volumez.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=storingio.onmicrosoft.com; s=selector1-storingio-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OK+qM9V2Noycz6kZk/3gDJaWj2ehTJsxlOvZgRHeiWg=;
 b=gv9Gwgy0z53nszU0e5kH3Le0oTAZdcmbBpzKIthfMUw9SIXS9t3/yb5Xt+S/vnB0+gTSiH4prdXTFWqmHhfEEVc94Ja2XNvSHe6nJW7lshY7qgcZ4ycWdtd61jMF3PCzM3K7QsPNPXSVb/8ErXZFiW/ta2A+osTO0TunnEDfjdgBWvJG5jhmrfnA1dfrDp+m3g8Vb2pF3O204pc6P8mX9Hir3QHO8tkikkYOdk6HeBsCPsasQcPS5vuq6kV/QJkAmB4Ymp3fNtqwlQSDeqsdsAaK9bgRqC4Wb8som+098xQ3JalhPXF9BCe4VjptC+Idq1Sr6QIDRvAbZ7aTrWwxgA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=volumez.com;
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com (2603:10a6:208:cb::11)
 by VI0PR04MB10461.eurprd04.prod.outlook.com (2603:10a6:800:216::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.31; Fri, 7 Jun
 2024 07:29:34 +0000
Received: from AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb]) by AM0PR04MB5107.eurprd04.prod.outlook.com
 ([fe80::de53:c058:7ef:21fb%4]) with mapi id 15.20.7633.033; Fri, 7 Jun 2024
 07:29:34 +0000
Message-ID: <37ef3707-d99a-4a08-bcb1-fcd9bc041abe@volumez.com>
Date: Fri, 7 Jun 2024 10:29:30 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-bitmap: fix writing non bitmap pages
To: Christoph Hellwig <hch@lst.de>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
References: <20240606153223.2460253-1-ofir.gal@volumez.com>
 <20240607045336.GA2857@lst.de>
Content-Language: en-US
From: Ofir Gal <ofir.gal@volumez.com>
In-Reply-To: <20240607045336.GA2857@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TL2P290CA0005.ISRP290.PROD.OUTLOOK.COM
 (2603:1096:950:2::15) To AM0PR04MB5107.eurprd04.prod.outlook.com
 (2603:10a6:208:cb::11)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB5107:EE_|VI0PR04MB10461:EE_
X-MS-Office365-Filtering-Correlation-Id: 548a0ee9-3fa2-4c9d-fa16-08dc86c39406
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|376005|366007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?b0NMVkw1WWtKRUtDZy8xaHE4aWM4NDJ5R3dPU3VaUENKWCtrUW95VFgvUFJG?=
 =?utf-8?B?clVVcGdCWFpidENXOVk1U2x0dnpxSUdUNFZtSWtJVGtJNGlFeHpzNXlScFpv?=
 =?utf-8?B?a3ZoaUxFMitpTUM1bGhrUkxkRmZYbCs2U094ci9Semdhek80MlZieVcwVzhT?=
 =?utf-8?B?dExaK3ltWGh2SDBXbUc5L29NalVSTklaMGFqZGR5UmV1bHFTVWVQbXV0WFdX?=
 =?utf-8?B?YW9HUG1pcFU1bW5MZW45SXVqTUZ0emNqRDBGQ01nM0ZLZ09EYStRVFllZmtG?=
 =?utf-8?B?SDBQS1BCYVdWYnhtTVphdmEybzZLN2FEeisxTnluK05jdi9xRkZMUEtMd2R5?=
 =?utf-8?B?T1Bob3F2QVVNTTFkMDEza3lmREIyU0ZCNWNLYi94TXpBWnpvN254c2p6bEdp?=
 =?utf-8?B?UlRYclF1Z2paK1dDbUQ4dUJ4eGFmbWpsYkNtV1lMYWpDSmpsbzkvaUU5R0w4?=
 =?utf-8?B?c2xEc3ZaNTdsYUdTZE8zbGZ3MWtxOXNpTEY5UEdNMVhwd2xjT2xwc3FQQ1I3?=
 =?utf-8?B?QkZpaXg1Q041Z2hBTGhON01oSXh1amNzeWRtLytiZjI0Rjd2TmxyYjBhSUVy?=
 =?utf-8?B?dUVZUzBHa2hIa0VHOTNkeGI1aHNMRzdvM2puSTl1OExSSFd3UlQ1Rlo5T0F4?=
 =?utf-8?B?NkVFcXZicmlQQTJ4UkRhQy9VU05YZWtYa0UxV3VrMkxXclFaaGtqamtIaU8z?=
 =?utf-8?B?R1FXWVJGQ3p4dTM1bk1WaDBnOENNbFg3dnk2REN1Ykg4TllUTUg2NXhoVXhz?=
 =?utf-8?B?bjB0eUZMQVpWV3d6RnBRTlhwY3MzN3VpTXNMV2dUcHJQQ0x1bG54OE1GaGds?=
 =?utf-8?B?YlFheCtVanB6YXEvRmFpOXQ3K0plTzB5VW1wakR5KzIxdWJiSXJQdEw0azNO?=
 =?utf-8?B?MHY5ZTdiRXg2ZDUxeE9QZytMTGpkd29zQldVcUpLa2xBdGZVVzl5bG9JQjdT?=
 =?utf-8?B?TWlXWllPaGNSbzJYNjIrWHNCUEg4eUVZQURYVncvUEpVVlZENVJFNmtwbjIx?=
 =?utf-8?B?Y0hnS3FuSXVYRWk1QlRha0NyQzZ3bHlhVDVjdUY2czdTcHJZMDZMOTBtbWI1?=
 =?utf-8?B?YjJOdzY2RC85eXdmYXNKYVpKb1dkeENBaTF3MFZ2a2FqVlpKK1NiV2drZTJM?=
 =?utf-8?B?NmFJdEtFY1FNaTFYbWxyeWlsZEVBM09vSlNQQ2ZxV202Y21vd2JveWVlNWJk?=
 =?utf-8?B?N3NhNWY4WGZ2Nk1OekhYWm5vbDJ5dmd1Rm1PbW9BNmhQbDRPZnBjWXEzblpm?=
 =?utf-8?B?VkFFbzJPOEpTUGw5SFdtaE9qRUlSR3BLUWdJTFE3c1VOYURjb0ZmUFAzVWJO?=
 =?utf-8?B?b1M1TENIcUtWeGNPNVNFMllFVk84WHRWbGJpVjcxcUhCWGNnZzhqczlBcXRr?=
 =?utf-8?B?WlA2RGpPdG5RQ2w0dytiS1E5c3JrZ3lIY1NjM3dYczVmS0d2Ykh4Rmk2blJz?=
 =?utf-8?B?NUE5ZU4yaU1CWkVPdFQ4Q2htNjNnL1VrYkJObXpiMGRnTUluWlVudjRmRWVL?=
 =?utf-8?B?MXVIUmFxTW11Z0hGbjZvQVZGaXZiR1kzZUtGNXhkSUgwVDlzaXVzRnFhd3l2?=
 =?utf-8?B?dHVnRDlpSk4rZ2hLZzNWSHZOWEZCanYvQng4Ti9HTGl6UmFEQ0hrMW5qNytp?=
 =?utf-8?B?ZFZPSXh4eFg5NDVjaEx3SnVtU2FuenJlQlVsQ1hJRnQ0b1NTK0tSK2RvaTZt?=
 =?utf-8?B?SnBhM09Scm5ZK1N5UFI4YmFGL24rR0JFTTlQc0ZjYnE3M1ljbjV2M3RQQlJl?=
 =?utf-8?Q?A2ZhSD1EkAeKY1/BTMCcGESAAEPMgu9RwL9kBSi?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5107.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?SHVvYmpFNWw2S3ZnNWZqdThkVVVQeUZlRk9rM24zUnl2T3FSVzY1aFZHcUxm?=
 =?utf-8?B?MTdaS01RdGtFRjJsTDlHbitsMndmdGk3OWhuZlMvTVdsYlBVMEtEZGgvRGM2?=
 =?utf-8?B?T0N5d2lUbW5qVVdNRnVrd0VxWDhBSkFnK3JMR0xUNkxKNVRVWUYyMGdqMlV0?=
 =?utf-8?B?ZStzY2NCOGJrUUQ1QW5NbWtkTnJvMXpvYmNTd2lsMTgyWndLUFNVb25SanhI?=
 =?utf-8?B?bkFFSG9QN0FxbUgzYStsL0k1SGpQUDZ4aGtTVnlUTjdQS2lZTFAxb3dFYlNN?=
 =?utf-8?B?Yll5UzJPSzVibUtqdWxEZTRqMVRqTkZVMERrcUx2VC9EaEJrblJVdHhjcG5o?=
 =?utf-8?B?aG1ZUnBkcVgxV1BtTWZ1emdTWlArcVV0T0JUNjVLV01oaE9sWGF3N0hMdW4z?=
 =?utf-8?B?dlFtN0hQREIybDdpczErSUxvaEJML2wrQWVvRExKR3FxdUtEN0dibEhBaUJ6?=
 =?utf-8?B?dkFGRUZTSlA4elRpczdPTlJHci9jYmlHQXJCRG9MOWFUK1RnQnpPOHFNeDAx?=
 =?utf-8?B?WVBCZ1MxVTMvNVl0aTRjaldpa2pUSkZnSkdnWXpIaUcrcFZWdWxPWUVxck9x?=
 =?utf-8?B?UDZYME1DYUVOWTVwVktuRTVYQkJYdDNnN2V4Z0R0MXVaZllTQTB4ZjFzZUFj?=
 =?utf-8?B?Yng1M24yVmNvOWxGSG9CR2VIL0hiZk1vN3AzakY2NkJPTkNERUEyc01kMzlm?=
 =?utf-8?B?ajVsS1FYYkRyYjhIMTBONnNHTnFkUEl3UzZ6RUhjV0gvcjRaYkZmdUp0OEZa?=
 =?utf-8?B?SW8wemE4UHBvckJBa1p1TURLekZBclE3WmNIaHZzZjRTNFRtMHlsczNZNGYz?=
 =?utf-8?B?V3ZYdG9pUERRN0I1ak5kcnVvSlIvZ1BrNkVmaVFtMmthMWg3Zm5POU1nVzds?=
 =?utf-8?B?ZXFodkNCUnRyWEFlbVhDV1daSi9RWmpwOGxzc3JFUjkrbUhaVHM3WGd4UVlL?=
 =?utf-8?B?SWJJa01FNjBZTzNxdUl4MzBvNWpHQ3FQb1VrQ1YyT3NwWnJjcGY3TFZYNWhr?=
 =?utf-8?B?RzNSQW9YYnpnK0FobGtYV3lzRG15RFd6T1k3Yy9heDBiUGFNMTBLSWZSL1M5?=
 =?utf-8?B?UVBTYlg0Wm9uV1cxUTl6aytHOHlvWW1MY3p5bEsvdW9UUlE2VkIxREhGbHFI?=
 =?utf-8?B?bzJXTmRTODdjWnpHVklFZ0o5MlFGN3FVdnU0a2NaYmJtNjFBQ1pCWUZlN1Nm?=
 =?utf-8?B?SmYwM0pqOHdXMnNoY1JCclFGajYxZGlpWEFPeDIyVklIRFZNR0VWVDR5WVZR?=
 =?utf-8?B?M0YrdjB4ODBNWXNoNGxJd1QyWnFQUTZSbm5hQ3RNNGRFTlg1NGxlWFpIM1Ja?=
 =?utf-8?B?VzJOZkJGcUR2VDY3RC9BbXk0QW9YMnhJQ2lKdDdLMjFpZkZuelh6dEcwNnlF?=
 =?utf-8?B?cTlQOWJqK2htMVg0ZG13VHFWUVZYSTM3dFBvM0dpVFppZHVYWXREY01NRTFv?=
 =?utf-8?B?UzQ5dVl2N2V0MGNlZmNlMDdsOGE1NDRaaEZ0QnE4MmtQQXVxYnZoeFNBVjZi?=
 =?utf-8?B?aTZXdTBCWWs4SjZuUjBacTlYZWRoTS84RGk5dW03cVlGTjRRT2d2bEtGVVZ4?=
 =?utf-8?B?dW5tUU95Yk10MjJDNmU1bUVKZ3RaK1U2a2N4bDI5OVFqUHVlQkljaWl5Ry9s?=
 =?utf-8?B?TVd2L1FsQVhjMXAzU1BzbDF6UlNhVkNBdlN2MzFmZ0tERVB3dVB1ZUlkNXB2?=
 =?utf-8?B?MkhlbjIrbVFPdDkvSE9GQXVpZkcvaU9VUFZGOTAvUUI5MVl3R01nZmpMVWhw?=
 =?utf-8?B?TVNpSVk1OXFUL1MvY3BQdGFqRW1MbWVtbUpxZklUR2M4eHNhU3cxQmRHbjJH?=
 =?utf-8?B?Z3ZGaUQzQnIrOHZLcVpudFRObGdxUE1yRDV1VEZJUGoyTWw2bDZjcUVoYUJB?=
 =?utf-8?B?UG54VjNnL0xwNEhHbU84WXV5WGthKzNjcVZsM01DczJNZWhLUThoUXpNZ3B1?=
 =?utf-8?B?MWhLbVpTYVUyaDEwZWlpRjdUNGZFVDZlM1R5NGJ1Y0E0Vy9lVHlDaFJ1M1g0?=
 =?utf-8?B?SVRQeEZoTzI4YU1VUVh3S1Q3QmxhSkh3OHVuMU8yaGpTVnFBM3RVWXAxMnEw?=
 =?utf-8?B?ZUpzbDl6dERBVXY1OHFLcVhVclRSUjR5MmZYOWxNTWs3VGZVS1JyTGRwQURl?=
 =?utf-8?Q?+OQB8VpzBnf//RyLo4k194YQg?=
X-OriginatorOrg: volumez.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548a0ee9-3fa2-4c9d-fa16-08dc86c39406
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5107.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2024 07:29:34.8189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b1841924-914b-4377-bb23-9f1fac784a1d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AMFo76az0ug02PoC6YK9dPB6q/IO+UhXH1kAona4pdMHS36uqefMYmJfMMk8I60Q8Vl8SmFSMuthWJUs8gjLOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR04MB10461



On 07/06/2024 7:53, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 06:32:20PM +0300, Ofir Gal wrote:
>> +	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) << PAGE_SHIFT;
> Please split the line after the "<<".
>
>>  	loff_t sboff, offset = mddev->bitmap_info.offset;
>>  	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
>>  	unsigned int size = PAGE_SIZE;
>> @@ -273,7 +274,7 @@ static int __write_sb_page(struct md_rdev *rdev, struct bitmap *bitmap,
>>  		/* DATA METADATA BITMAP - no problems */
>>  	}
>>  
>> -	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
>> +	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
> and drop the pointless case here.
>
> With that:
>
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
Thanks for the review! applied to v2.

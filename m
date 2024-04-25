Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2911433BE
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=67.231.153.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714076981; cv=fail; b=jhmwgnaz4GcPKDEmwswXLCCQTO0P03gBXxPrZ9C2D/L95DDIbcVbeqZ2DR3kJor25HoJ/ieT49r6DGh18Lki0Fsrm+WQiR/v+UiLn8O4zK+zTLCqIRBhmAO2i1MxfdaEJf4o2q+BQPrXTDEubl4eLiNkmkqEaSz2enHiQRLwIms=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714076981; c=relaxed/simple;
	bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=p0X0tkFGqbKqTlsSqnanXnVhs+b5RM2NP0bL8HTLII7xcAZKf5JHlRlW/m0Nz/JBz/81DfxkuNarZQuIDRugVdFkXVZwekWAZ7GFNERauBAiY73ZENyQZAoq2pWR6vQm955bXsLMbKFia02emPN3adI5x/sfb7cGjsYc5ZmPdl4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=X/a61YFc; arc=fail smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="X/a61YFc"
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 43PJ39md010697
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 13:29:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
 b=X/a61YFcxKPiemMe+9+hg0NO5VeFczd/+gUg6u9lUFDNu0mFoI2Q31CBi0t0xhyfQqvb
 PhC9TGGKjT/bh+he4XSpAd6W2QdTt/Rip/JlSG0k9rYhmDKH2fjSzqsQ6RMyuAeGpOy+
 prQ258yuMyLsmcKNShjW7JekzPMgeGm30nlMmr2U04twGcoBDKK3weYUISk9PufeyniA
 0hDUCl+U0DhhUiq0RtlTPhakHiqQo2ylBS+0kwDbc2WvemyxoUOm8xoUrdcPBCOVv3id
 abTkVjEAniQkCzZSWRePR5wGVDiV6l0LKEpWA7i0tSYIfwgVzGtr0fIbe4Nsb1TBRK0D Ww== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
	by m0089730.ppops.net (PPS) with ESMTPS id 3xqepbnb19-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 13:29:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JUsqVFZWgJScIk+xQ+BN2GpiI7DVx0F80LDBLXLs3U8Um+QnYbLhiY7KGx8KRebRqz+BNKpad8PXqh1irgKt7itbUtaia8v86slOf2r8H5VpG8Xyx39+rX9tkjM4OffUVVHxmIiyNJKMUBEBSgbFZCoGTs5vkmQ11WOfk/LJ7eLrzQLW2bVgYbaaI/YoHV1Yt/Ldm63WA262T6FGkbEAKCaP/VFCMvJgXG+sy7teojN/Dg99XdO6hr0bTCZyS6rzLFWA0pCv8J9XHMAdppKvBDLQHv0dQ/cpLi2FulYX5MQMcZePeOTE1BPswTZPQ33B/WAWv6qKTPrNCKw+wbmScg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RCleVhV6Qe2dyiWG2CLhPYpcT2NUIbaFPh3+gJXZpTc=;
 b=fh3aYhG7kzTWhMRqnhY/rASuRKK6ThRgJv3NdJFSQEHmGqt5ZvV9VrbSw/5MFAIe3mCcRhSKX08B4JaSi3QJTnrl4/TnQuYeY7gqWfShlhpgiVkmprxydt2wAYWx3fXj5uKqOZARWK8GYzrDeoU9ZoT2nBUoDXIWU5MaJfXYWPaoeSiYj6yrbcckr29WAhkFB4FABwlxy+EmeurCVC4rZAj/cpLyTPa3EHksSVQAvYNtDo4IwcoNNyWFMS3Y4DgVBOySkHfbj688c/fRiyGmnjmk3FoY/EWacHYh5fijlHR+UvNWq7UTICkL1VYn2LBYxUlgBueRRN/XD1XgfRZhng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SA1PR15MB5109.namprd15.prod.outlook.com (2603:10b6:806:1dc::10)
 by SA3PR15MB5727.namprd15.prod.outlook.com (2603:10b6:806:311::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Thu, 25 Apr
 2024 20:29:35 +0000
Received: from SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610]) by SA1PR15MB5109.namprd15.prod.outlook.com
 ([fe80::662b:d7bd:ab1b:2610%4]) with mapi id 15.20.7472.044; Thu, 25 Apr 2024
 20:29:35 +0000
From: Song Liu <songliubraving@meta.com>
To: Jens Axboe <axboe@kernel.dk>
CC: Song Liu <songliubraving@meta.com>,
        linux-raid
	<linux-raid@vger.kernel.org>, Li Nan <linan122@huawei.com>,
        Yu Kuai
	<yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
        Florian-Ewald
 Mueller <florian-ewald.mueller@ionos.com>,
        Song Liu <song@kernel.org>
Subject: Re: [GIT PULL] md-6.10 20240425
Thread-Topic: [GIT PULL] md-6.10 20240425
Thread-Index: AQHal0n6nxF7uwzaVkaFmIZMUUkCybF5aGsAgAAHhgA=
Date: Thu, 25 Apr 2024 20:29:35 +0000
Message-ID: <D2619D49-53C2-476C-BC73-EEB09ED4557D@fb.com>
References: <CE08A995-B84A-4B4B-BC7A-0EB73319877E@fb.com>
 <6addafce-5a59-47d0-b580-9ec3e54fc805@kernel.dk>
In-Reply-To: <6addafce-5a59-47d0-b580-9ec3e54fc805@kernel.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3774.500.171.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR15MB5109:EE_|SA3PR15MB5727:EE_
x-ms-office365-filtering-correlation-id: 0b6853c4-5a98-4225-4b7d-08dc65666c57
x-fb-source: Internal
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 =?utf-8?B?VzRXNkNsUzY2K1VxZGlPdG9kT0RqbzYyT0pHMlhNRFlzN3Z2Lzl5Rms4S0lL?=
 =?utf-8?B?SFgwOUtVdFdBeU03UjVlb1RJSmgzbUk3dTUrS296Uk13TFNWRmhlZjgwSGhH?=
 =?utf-8?B?ZVJuMlN4UVJYU1N3WU43T2kyb1FIbmxJbnVBM3UzNWUzTU9vWUlDV0ZRa2F5?=
 =?utf-8?B?dkIvdjRwR3ZibzlyVlJFSHBza0hnTmVJRHpldFlhcnM0ZmtEMnRjNndrZkU0?=
 =?utf-8?B?K1d0NjBGTkorU3djdDYrdExzOEY3YkYrN3hJQUhZaHphNkdyemVEeFYrOXNW?=
 =?utf-8?B?MFR6TUs0WGY5S3p1ZG05d0ZZVCsvektNUm9qVGJsdGF3ejJhUitCVm1paGdL?=
 =?utf-8?B?RE9VNmxpaG5xVzNiUWVlM3FIWGRHODd0K1BzMlVOTlJKbXorcklmczNsSjJC?=
 =?utf-8?B?VTJYL2s3cGk2UTlTaFIwRzhJUWdmaHFYZ3c4Szh3Nlk1WlVFR1kyd0g0MEFu?=
 =?utf-8?B?cUh2cUEyV2Z2TXBiL2lraFYvUFVTbCtxU3ZkOUZRa3BmcmpmVjk2dHdxcURB?=
 =?utf-8?B?NnR1K2U5dDZGWjRNYVNjTlBpRzlzQVJlMXVINWRLcnRWM1JIblB6dThqTy9r?=
 =?utf-8?B?VDhUT2dsUG1PWUxBSWVUUDRjUjdwbzdlZlZydHkwN2hDUmphRk50THQweEFE?=
 =?utf-8?B?Nm5ZcENFc3Y2QXBOZ1JpZGRQOURISWtsNE5iQklmS3RqYnZ1ZlVaOVpDSVgw?=
 =?utf-8?B?c3ZkaG11TmNpM1RtRS9CQWMvell4ZXlBVnljZ3ZuT2hKMFE0U1RMSmI1OXR5?=
 =?utf-8?B?Q252MXJBTXlWczB2TFc4L09ZYmljMG81Ymhyb24rdnRFS3BFYzhLQ092QzRT?=
 =?utf-8?B?a24rYjZkSnpJTmt1NDNQVnp5a29LNmw1ell5eHZJOFN2VjV5VlY1MGE0Zlpq?=
 =?utf-8?B?aXBCeWZuSVdYNE15Z2FGVkFhQ0lDeEwrSnRSQWlVMDN4eXNyL2RXYkR4WTJS?=
 =?utf-8?B?dTZCRUlVeERoNHA1ZnN5V01NbHVPU2grRFNBdVpnMGNYZWhhNmlRUjU3SEtX?=
 =?utf-8?B?T1dndnFLTEtDVUhrQzdlOUdqL2FwY2l3NDNxbTZtaU1Wenk2alRRWWlHRzM4?=
 =?utf-8?B?WUplSDB5RFhCUXMxaDlRcjB3SmswbnZTNkFIUko5NDZycGpFbGxGVWZZbXJI?=
 =?utf-8?B?cEE5QjFUR1pGeEVpUjZYOXEySFlCK0owb01YRnFWdUV6UFQzdzRDbEE1Kzh3?=
 =?utf-8?B?TnhjRFRkYllZRVpGcmpqMDFkMFNOdTJlU29zTm1vem9TL2EyOGhDcThkeG1t?=
 =?utf-8?B?eXdjZkJ0Nk5leTc3NDlyRUFwSUhzQUlob2lWZW5rTUVWUVNjWW9nM1pDQkwx?=
 =?utf-8?B?dldmdlFCZUVWYWJ6S29KbkZHQ2h3Q3ZPMVJiczFkR2NvZ2NNeVRDZlhyL0Ra?=
 =?utf-8?B?R3VLVGJvdHFOMnUrdmIya2dwK2czYytIc0R3N3E4bklxNHVYSWEybmVhL0pz?=
 =?utf-8?B?cENZZTZlYTVwdys1T0VXQnZ0bnhJQlNIMk9oOW5Rb3RpODEydDBPSGZscEhH?=
 =?utf-8?B?cjhXUHRPWVNkRnpVeDljNWZ4Zkp4UEFTK1d1M0tBQnhJd2lta0hPWk9XQVdH?=
 =?utf-8?B?UHpuc1JXcnJtN3ZuR2hwZSs3bUZ4elFZQ3JkUTBHOTFYb1NFMkFpT2ZzZGor?=
 =?utf-8?B?am8yTjJrL01CdUtjSndzRFR6Q1V6NUdubFBHWXE3dUEzeko4cUl1WUVteGtr?=
 =?utf-8?B?QWdjZTVMRUxmdFhacUFTQUhXSXp4MnRWMkRaUjU1L1lZL3J6dEtuaHc3RW5D?=
 =?utf-8?B?ZkVEa1FTemQ3empaNDU5NkF5YlhKUnRzTEMzWXB4TGE3RE50QzMwenV2cEd5?=
 =?utf-8?B?ZWxwSGVLc3dob2FpWmxyUT09?=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR15MB5109.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?djU5b3NWL01Zd0JjN1BBano0QXRRdmFFNHQweHRWQ2tVcFBxTDgzb2dVNWFp?=
 =?utf-8?B?N1NNV1FzSTdSUTFQSTMzWU9aUUJ3T09ndzF5S21KbktJMU9YQW5VajdoaHpi?=
 =?utf-8?B?QlR4OGdvOVRVeFZlc0JyWUZaU3Fwb2lJUkZBakZVZmdFOFExVnRERFdqTlk5?=
 =?utf-8?B?WEFxY1N4WTEzN2FzQUQzOE5Ua2ZmRVN4R2Y3L05JcjZ2N2xXb0RCQ0NHSHRB?=
 =?utf-8?B?Y0JqMzlyUkQyb3dhUkNUUzhDdXl5eXhMcmZ3TEtWdGdINituV3hsYXlhWnBt?=
 =?utf-8?B?VkhjR1paNGFlQVliWjhaVTRRVUZkYmJqNnlCRGRCMm9QSDdHckpZMW42TC9J?=
 =?utf-8?B?cEw2bXArVTJMbE4rRHhGazNYQmpnTWZFWldtdmIvallrMG03Y3JHWGhwaExr?=
 =?utf-8?B?OTBJb2lKNDFsbEJmOXF0d24rcUhqSlFkek13Mitwc2o1VlR0S3hJOVBJaGdP?=
 =?utf-8?B?Z3d1SXBtUndybWtXdGZycTZzeUcvZWlCTnZLWSsxRFhhMC9nUkZGaHlqQ0w5?=
 =?utf-8?B?eUVLY0liOExVcWR6aFRRY2VwOU41M2JWcU5zdnRjLzduWVl5RWc3N3ltVjN1?=
 =?utf-8?B?K0lNYk81enU4ZXE2TGJvamNjdkhmSFZBS25FbXJrOXJnREhBUlNTT3NuR1ZG?=
 =?utf-8?B?c0RjOGxUenVVSkUwMW9Xdml2bGtXRGJyV0VFWndZaDc2MTErZGU3NFI4a3h0?=
 =?utf-8?B?UWFOamx0Y0FwYTdkYWRPVnlHR3NaN0tManRkR1NtbENCbmpXTWorY3EzT282?=
 =?utf-8?B?MlhOb2hXRUdDSFdGWlFiTjE5SzUzaFovQ0I2RTJBcm9weWhUcXIyMTFMM0hF?=
 =?utf-8?B?Q0FnNW1JYWltT2I3U2hLOW1kNUoxTkJLSmpSZ3BtNDNvTHFUN1JXTDRoZ3RP?=
 =?utf-8?B?ZFVhYnVvd1BaZE1ESzhBbmJHbHZvWWMvL3VyK2Zuc2U1ZDJrSGZVL1YzTmx5?=
 =?utf-8?B?dXpleVMzZEFVajRIZ1BBdlZ0SkYvTnM3eXFYdDE4SVlXVG5aUFZTWlY1VC9r?=
 =?utf-8?B?T05vYjZLUFRwQ0h5WnZwbEQ2b2ZLZXlObm9ucDVudHhTY05rZkNXaEF0ZGpY?=
 =?utf-8?B?dnFDaU1LK05oc3ZlNE9ZUGlYZXJhQlN2TkNQSjRNbERjSFBTQ3pWZ1RLblEx?=
 =?utf-8?B?N0NpZjY3ZkxXR2JleUI4amlPMDJiUlBnZkRmeUJjbUtSOG1oVnkySjZYSnNL?=
 =?utf-8?B?djQ2ZzZKTHhzYUNuRXlrNDYwb0FGUENUaWtYWDJRZGNVM3R3QkdBbjJDSDJY?=
 =?utf-8?B?RlRQUmtzSU9rT05qRUFYZ3drQTR1VGxXT2U4VlF5aXlIcUJmeDF3bkdFZ1VM?=
 =?utf-8?B?N3BUVExUZE9pS1hXWUUyQWVNODg5T3NhRDdKMW9Sbk5kU1d3djg1TkRlRmpU?=
 =?utf-8?B?dDZ4MGVjZ0l5RVdtWk9JT25NRmNDa1lUejlzNDR3TUlYOFFHc2hLZmZhM2ph?=
 =?utf-8?B?TDdQVTlJemppY3NBWERGNzM5aW55TWlGWnNyKzNlaVZkamx2QzJMMVJXM3d5?=
 =?utf-8?B?RzdCTjcxVjVQRHhZTjhFZk9GMGtqbXp2d3JEVEVEbUZtVzlZc1oydHhMTldE?=
 =?utf-8?B?bzJxdlpuK3pDRmJ0L0RnY2VvUEhjZm9zazNrTVp1UWRRWU9sa2tRMjZkSVBL?=
 =?utf-8?B?WGRtUXdGYlBJZ3hNU2xFRlU1Z05jeTFxY0l6aVA1dEFJYnVjL09mbnF4R3k0?=
 =?utf-8?B?Q1hscm5EbVppQXZCQnBObVg3M1VmcS9yUGVEZDlycUxFUWpNWWduM00rcnhJ?=
 =?utf-8?B?WTFCS01NSnN5WGoycjU4NWxMbW54dXFNMmNyc09mTUd5ZjFPOEFjVzArK1h4?=
 =?utf-8?B?bW9Hc1MvK1RCeDdPYXRObWYrckJnaHo0M1dMdlZhRlArZGdtQmFLay9Tc0hq?=
 =?utf-8?B?ZU4xYnV4MmdHWnhXSnN6d0NUR01MSWdHOWZwWmFTNGxkcmdlazdPTlRSTzZ3?=
 =?utf-8?B?V3NHVGlDRHVCSkZ3YXV4cnl2WGFIZjlubVR2WHAxTTZSNVlCRlp3c2ZNeFhW?=
 =?utf-8?B?ZW4vazN5YVZLek9EVkg3L1dwNTVZTGsrL3M5RkFOdkxGT2tuSGY2RTdhMFhK?=
 =?utf-8?B?Sk5wcm1oVEI1SDVNS2xvUzNhTU10aFVBVy9MaXF3ZWk5RzBITzBvVmdxeSt0?=
 =?utf-8?B?MWxhVmJMMTlhZ2lZa2pTb3FRK2x2Y1lFdTJoMlFxaGlkZVFkNEUrU0Q3L2R2?=
 =?utf-8?Q?pAjaIbuxZ2Sm8oES80RGnQg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D70D0AA957B974AAC303FA94354807C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR15MB5109.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6853c4-5a98-4225-4b7d-08dc65666c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 20:29:35.8115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vKDs1y/ivh9ia/PUA829VZvWBlNyerWdlXMa84JlNzCEU0v6NYPW3YwU1BIUxw9JICiQHYZwGbvOwziclQ2sUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR15MB5727
X-Proofpoint-GUID: DUyFVxZuwinhfH9ATM_mE4DRhjUfZWIX
X-Proofpoint-ORIG-GUID: DUyFVxZuwinhfH9ATM_mE4DRhjUfZWIX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-25_20,2024-04-25_01,2023-05-22_02

SGkgSmVucywNCg0KPiBPbiBBcHIgMjUsIDIwMjQsIGF0IDE6MDLigK9QTSwgSmVucyBBeGJvZSA8
YXhib2VAa2VybmVsLmRrPiB3cm90ZToNCj4gDQo+IE9uIDQvMjUvMjQgMTo1MSBQTSwgU29uZyBM
aXUgd3JvdGU6DQo+PiBIaSBKZW5zLCANCj4+IA0KPj4gUGxlYXNlIGNvbnNpZGVyIHB1bGxpbmcg
dGhlIGZvbGxvd2luZyBjaGFuZ2VzIGZvciBtZC02LjEwIG9uIHRvcCBvZiB5b3VyDQo+PiBmb3It
Ni4xMC9ibG9jayBicmFuY2guIFRoZXNlIGNoYW5nZXMgY29udGFpbiB2YXJpb3VzIGZpeGVzIGJ5
IFl1IEt1YWksDQo+PiBMaSBOYW4sIGFuZCBGbG9yaWFuLUV3YWxkIE11ZWxsZXIuIA0KPj4gDQo+
PiBQbGVhc2Ugbm90ZSB0aGF0IGNoYW5nZSAibWQ6IEZpeCBvdmVyZmxvdyBpbiBpc19tZGRldl9p
ZGxlIiBjaGFuZ2VzIA0KPj4gZ2VuZGlzay0+c3luY19pbyBmcm9tIGJsa2Rldi5oLiBUaGlzIGlz
IG9ubHkgdXNlZCBieSBtZCwgc28gSSBpbmNsdWRlZCANCj4+IHRoaXMgY2hhbmdlIGluIHRoaXMg
cHVsbCByZXF1ZXN0Lg0KPiANCj4gQSBiaXQgZHViaW91cyB0byBqdXN0IGJ1bXAgdGhlIGNvdW50
cyB0byA2NC1iaXQsIEkgdGhpbmsuIFlvdSBvbmx5IGNhcmUNCj4gYWJvdXQgdGhlIGRpZmZlcmVu
Y2UsIHNvIHJlZ3VsYXIgaW50ZWdlciBtYXRoIHNob3VsZCBzdWZmaWNlLiBJbiBmYWN0DQo+IHlv
dSBvbmx5IGNhcmUgYWJvdXQgdGhlIGRpZmZlcmVuY2UuIEZlZWxzIGxpa2UgYSBiaXQgb2YgYSBs
YXp5IGZpeCB0byBiZQ0KPiBob25lc3QuDQo+IA0KPiBJJ3ZlIHB1bGxlZCB0aGlzLCBidXQgSSB3
b3VsZCBzdHJvbmdseSBzdWdnZXN0IHRvIHJlLXZpc2l0IHRoaXMgY2hhbmdlDQo+IGFuZCBzcGVu
ZCBhIGJpdCBtb3JlIHRpbWUgZ2V0dGluZyB0aGlzIHJpZ2h0LCByYXRoZXIgdGhhbiBqdXN0IGJs
aW5kbHkNCj4gYnVtcGluZyBldmVyeXRoaW5nIHRvIGEgNjQtYml0IHZhbHVlLiBJIGRvbid0IGNh
cmUgYWJvdXQgdGhlIG1kIGJpdHMNCj4gaGVyZSwganVzdCB0aGUgZ2VuZGlzayBzaWRlLg0KDQpU
aGFua3MgZm9yIHRoZSBhZHZpY2UhIFdlIHdpbGwgbG9vayBtb3JlIGludG8gdGhpcyBhbmQgY29t
ZSB1cCB3aXRoIGENCmZvbGxvdy11cCBvciB1cGRhdGUuIA0KDQpTb25nDQogDQoNCg==

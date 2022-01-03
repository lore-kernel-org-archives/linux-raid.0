Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6C9BC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jan 2022 14:10:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiACOKY (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 09:10:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:14897 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233248AbiACOKX (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 3 Jan 2022 09:10:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641219022; x=1672755022;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=z8BkqiZmdcSB+F0oh5qiEM0R+K1cvEMlB71QgaKD7zc=;
  b=J52wPOrKIUtil1haS11TpkT6U8HnWdPSCOYXP56Bnr/W2VS9AyzI3GtI
   FG7/a5498HmqMegxsxFokTm4zdLGKxQrN8LUyr3OAd91XX5H3HIOCyN2W
   rx3erwZVqri1ld7IkafvMB5LQMr6aUKXpSSGrCcZrwatNwNeWKl6NJLsR
   EA28oXg2RkeGBeroTTuXVjozdelsea3HQqZOeqQZruf5NpW6Zor+SRdgd
   tuwHEpgD0eEDVpk8ajjQTD0qF9ca5+1AqspTc8XvVPk+eNPMJ7birnT8I
   KeiL2rsvH4ktknQs5j1xEydafDYSLmvy72yE53895mwJr+XfzdHz1dHbR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10215"; a="241864969"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="241864969"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 06:08:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="487853455"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 03 Jan 2022 06:08:20 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 3 Jan 2022 06:08:20 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 3 Jan 2022 06:08:20 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 3 Jan 2022 06:08:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZPlpnEGlAFvYA31SZzsvjkHUaENHMDC5cFgi7ajZ7eJ+I9Eg2Qh1xIOskw34cOrkNxfQCAMP/4YkZAJsVXMAwsbYOaZX0hz39yjThrZojSbCBL9IS0rLWiiWXWPFTLzlpzzdO+F6AWgJqYHdes0Ro5kNg6cMJKbw/t3O73K3i5eNCuBs/ZHYsO6mGrpMhLSqXnWkr4xgghUR5Q52LhYoKYvPd0SUAaZOJlZU9tY4E7OAJOOIx2UKtpgqv5OmrIhm8jUHe3YnF7pPoKJskIKHXrcvAuU5fmlyZKTSDoTLdByeeVvquEcVpmZT020o3Bwz4E2iWTPcXchmbH3revYxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PS6jFtT/BIYNS4nyluuhS+sfyqBLqv4MbqSBbxZsICs=;
 b=NgxLeqKGf52ehnV/vyvJdKBDVZSi1ylJHm24RU09gUOj6i7T3MLDvX6b5X+x7vu1J56PNm7TfeBA267RvMOurKK9BM790ja5YbZGvTofCqlHFYg5SKquv8S785NzYGlVUSnYhiWC7J3LTiXdfr5ZAJfSxnigq32fmBxXJoYV//zViM+sfjxkeHsdYGZWeLR6v/EKopPeZosPRdPTzsxYK5D/WaNsob4Albv4zQWtpqdchCmzhL9kxYGmaTbAfDfW7qM7I8GH/VrYOdksY0rklXxIeIN/GYJYR//isY6d4Y2mVPZ4Ero9Roziztrg6qTtlEYC7uQd0bK+MxqnORBUrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH2PR11MB4293.namprd11.prod.outlook.com (2603:10b6:610:40::25)
 by CH0PR11MB5539.namprd11.prod.outlook.com (2603:10b6:610:d6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.15; Mon, 3 Jan
 2022 14:08:18 +0000
Received: from CH2PR11MB4293.namprd11.prod.outlook.com
 ([fe80::5113:54e9:180a:fe3b]) by CH2PR11MB4293.namprd11.prod.outlook.com
 ([fe80::5113:54e9:180a:fe3b%3]) with mapi id 15.20.4844.016; Mon, 3 Jan 2022
 14:08:18 +0000
From:   "Grzonka, Mateusz" <mateusz.grzonka@intel.com>
To:     "jes@trained-monkey.org" <jes@trained-monkey.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: RE: [PATCH v2] imsm: Remove possibility for get_imsm_dev to return
 NULL
Thread-Topic: [PATCH v2] imsm: Remove possibility for get_imsm_dev to return
 NULL
Thread-Index: AQHX4fG+/DE1osLIq0maX5zvhNHfaaxRkVzg
Date:   Mon, 3 Jan 2022 14:08:18 +0000
Message-ID: <CH2PR11MB4293F9F6CC25E8282A72A506E4499@CH2PR11MB4293.namprd11.prod.outlook.com>
References: <20211125113014.23920-1-mateusz.grzonka@intel.com>
In-Reply-To: <20211125113014.23920-1-mateusz.grzonka@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7d17768c-83ba-4788-3fc1-08d9cec27e57
x-ms-traffictypediagnostic: CH0PR11MB5539:EE_
x-microsoft-antispam-prvs: <CH0PR11MB55398BD6758B35B67E661779E4499@CH0PR11MB5539.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vIp5KI1lAC9fY5Ewht0lKM8BdeU3tTVoSVURNayDXzUDzSqykN32pRdT1ZEWfjIIPN9xbYXCmkpwNSaEWUHOpAqyuBCy3/EsZ2SVhHHM4Tuo/8/pqNEzHnhj4QwQFppkDBDv4qW9kSk/L3cjcMWI0KzzaNzbcGphtDIfo029PsBCLUoXd8LBsOWAG0z6A8UpVF2yvpkBmr9jgx1gr8/rdCNgGdznT2M0gcUr2tSNq7gvTimTzaGjh/hro0ky3v1vPEdTqiHq9xfSryLZOqn/IRVRvuN5gxXfJsSFEaxyp98wDXJNl7mzBqG/167x3dSs9tNvIpvY/nTJeKUOlMxTVbacEM/OtJcg3x0eykX0mo5KWXnYx3N+P7O1q5/+i7yVkiw7HQUK1otPHEl8ZfdwrTQdo7E49AIIRnM3FPGPySn/lNthVM3gwJey3zKbStXqmQsYy2caiU85zBCKBwhCy9b1K/LeTUrmwXfLTKLhDLcnL1rex51E7XWANtTooXFhkpn3FOkeL4HMlapHb8/9gGQE4Q+TKYOEjRuM8olnbUR34RO0J6et34ErQ88MUXw3S7JvZeSBVbpLefXPxAFzdcYtHhoH5I1ilERxRyup325Q/JCEd6GRxr2XSoBl6/jgtgEVh8SEn92FM9HlyISR2kTVX0nWjXDGAow51Hyly1Kh63utEF4G7jtcsDpUokeihyHsBCIC63xHtQTLxBT0jg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR11MB4293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(66476007)(508600001)(66556008)(8676002)(316002)(110136005)(64756008)(76116006)(66446008)(8936002)(2906002)(38100700002)(33656002)(52536014)(66946007)(122000001)(55016003)(186003)(7696005)(5660300002)(26005)(9686003)(83380400001)(86362001)(6506007)(53546011)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?DVbugVxKHY4de/wANYbJttXxAYX0HMogisy6EwF7fnQuhn84VyiyWp/0le+e?=
 =?us-ascii?Q?G4gA0A1dgjkXwfRknVtVRuwzOXjms88dNB2Qo3DXvqSG6ZJDNKiDZgcX/Ido?=
 =?us-ascii?Q?oyMi1GNbA/qvIUw6aRRkrgxV+ZTRL1Sk0hivV2K9c9O4TjYjqjr+xSwbAGIJ?=
 =?us-ascii?Q?T/2XPR/v1MM7eXJJojNp/HebKf9uM0K2j2IQNvKiSRxJyfgTluhLUaVox2vO?=
 =?us-ascii?Q?vFruk7vABr1aEoePsKLuXwvEfKlLILFlhvZin2DdpUgVCGqYtBZLDgo6cBDD?=
 =?us-ascii?Q?ANwYIwCtcA9LMJUMPveY73iWD3TZv3YwE9AC6jKrlon9miLq2lpWnkwjU00g?=
 =?us-ascii?Q?KcmXiKTRTrlnhu9R8Tql/mQhPwNmofoNJ1v/4+vO1uSDb3EqkBGKzyyj8Qc3?=
 =?us-ascii?Q?/Bu+MWksUlKf42WQHI1b/RB3YP6a72jUjWeU8dRsWCbiotZICgBrl9gcg79J?=
 =?us-ascii?Q?vAOJcbpl1jg9oi2HvgsC/jkpTalDwELgYkrcxETgaznlW6n/wW2DY/txeXrB?=
 =?us-ascii?Q?U367JTK9PJm/4fRb5LMWccxszctAVUbnJQNkyZTqKKR+KP9yXd6mTZcNXtW2?=
 =?us-ascii?Q?AmxL0zNl02A2NeyoOmLG2gzihXG/HjgDXXsnH2Djfj50Nx8+0WTpkPHKkX00?=
 =?us-ascii?Q?bU2zrrwpURY7kzNyrSjJDa6CMxNH4wol/i526tom+rPSRExsaF9+0Q9QjStZ?=
 =?us-ascii?Q?ALggtOhCnUWjfJ+IDEPM0hjA8zWc9MnO1vhr6x8lXaF8XEOwjpDEPfnalaf7?=
 =?us-ascii?Q?p2KYuxgJqeWUWlQds8A1QptAbEHsa9cd0bRNc3FcbZcbltMHQLjNoV/AxLXB?=
 =?us-ascii?Q?9uC/Ymn7U1HDdbrvbAob3KBhBxNRixwAhl9yI+eLs9UWLYC8PY802T2itflZ?=
 =?us-ascii?Q?kMtlOWCiSC1C1FAwufKpxmllfpfZ6gv+/HP3Jhk5roOWwMr3135jGFfQK1Ar?=
 =?us-ascii?Q?ImbUtEPYafJSnJLnHOT/T2yItMr+A3wwSIBnFO6eGgk55hSXRbP4AD0skF1e?=
 =?us-ascii?Q?5gJmpCKbXdJfgn2sqS8xk47v9sSq3fs8bH+SJexqQQGriFJfuZ/Ni2JRIQtd?=
 =?us-ascii?Q?nqTA+yVk/rpP4qUGKxxeBJWcvZQ4OLfxKbvE1UQtfXg0iUj8jQklippfSNiL?=
 =?us-ascii?Q?N2fi4Lswkvgf/jnxDnOjqk9d7BEdXyheyZvhlhFlQ9hF2h4MUiYukUTd5g/t?=
 =?us-ascii?Q?8C8rGntBeKDnLE6OFu3wXVwWklR+C+VPKRZk81O+mUOYArP8T9RZLh0CVecz?=
 =?us-ascii?Q?M9FaWM6SzqunxwI9DoWsW9C/IvJnYUqIxOfcwREBiAuUCu271kk/6lGZh80l?=
 =?us-ascii?Q?mAUAwHyCoiZ+ASZlNwX8TTalzoJuWDtazqdXr94iTRHrz1A9LC9afRGLzJzy?=
 =?us-ascii?Q?HQCN2/i0eu4KxNSoULl6T/PakCjTaU+WiMIrXe2M3D0bInHHptx3raIrp9sZ?=
 =?us-ascii?Q?WyrmhCjdn2eL5KSEtZzxRpvvwbAKyHjoVONs52zOqfyl00DdQmWKwoL+y8+7?=
 =?us-ascii?Q?zKG8Sy3CPvVrPiil/6a0cBOjsNcwf0TmWflmiQaL9nKCTsmJWqcMWALA+rXr?=
 =?us-ascii?Q?GJ+g56yVh8zhQb/Q5BfuHDJ/r5SvBzip2x06QP3JG/cHoT4Wzn7jMjyvGZAq?=
 =?us-ascii?Q?X7Tx9G5S01dSoDAdGU/mt6k2k22lzlhMCnY0nTvF5C4/sZ0u1BurD+WfmW3+?=
 =?us-ascii?Q?dAeocQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR11MB4293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d17768c-83ba-4788-3fc1-08d9cec27e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2022 14:08:18.7635
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6ZoMttPevMjEzK1hCYOi70i11+xqqDlfowl0rBOfJsS1jna527bFg3mdmMRCwjvyFoX0wBiDp3LcUmqda1A0DUNM080hgmukg9BNdlrNHFc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5539
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,
Any updates?

On 11/25/21 12:30 PM, Mateusz Grzonka wrote:
> Returning NULL from get_imsm_dev or __get_imsm_dev will cause segfault.
> Guarantee that it never happens.
>
> Signed-off-by: Mateusz Grzonka <mateusz.grzonka@intel.com>
> ---
> super-intel.c | 153 +++++++++++++++++++++++++-------------------------
> 1 file changed, 78 insertions(+), 75 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c index 28472a1a..b7441716 10064=
4
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -851,6 +851,21 @@ static struct disk_info *get_disk_info(struct imsm_u=
pdate_create_array *update)
>  	return inf;
> }
>=20
> +/**
> + * __get_imsm_dev() - Get device with index from imsm_super.
> + * @mpb: &imsm_super pointer, not NULL.
> + * @index: Device index.
> + *
> + * Function works as non-NULL, aborting in such a case,
> + * when NULL would be returned.
> + *
> + * Device index should be in range 0 up to num_raid_devs.
> + * Function assumes the index was already verified.
> + * Index must be valid, otherwise abort() is called.
> + *
> + * Return: Pointer to corresponding imsm_dev.
> + *
> + */
>  static struct imsm_dev *__get_imsm_dev(struct imsm_super *mpb, __u8 inde=
x)  {
>  	int offset;
> @@ -858,30 +873,47 @@ static struct imsm_dev *__get_imsm_dev(struct imsm_=
super *mpb, __u8 index)
>  	void *_mpb =3D mpb;
> =20
>  	if (index >=3D mpb->num_raid_devs)
> -		return NULL;
> +		goto error;
> =20
>  	/* devices start after all disks */
>  	offset =3D ((void *) &mpb->disk[mpb->num_disks]) - _mpb;
> =20
> -	for (i =3D 0; i <=3D index; i++)
> +	for (i =3D 0; i <=3D index; i++, offset +=3D sizeof_imsm_dev(_mpb + off=
set,=20
> +0))
>  		if (i =3D=3D index)
>  			return _mpb + offset;
> -		else
> -			offset +=3D sizeof_imsm_dev(_mpb + offset, 0);
> -
> -	return NULL;
> +error:
> +	pr_err("cannot find imsm_dev with index %u in imsm_super\n", index);
> +	abort();
>  }
> =20
> +/**
> + * get_imsm_dev() - Get device with index from intel_super.
> + * @super: &intel_super pointer, not NULL.
> + * @index: Device index.
> + *
> + * Function works as non-NULL, aborting in such a case,
> + * when NULL would be returned.
> + *
> + * Device index should be in range 0 up to num_raid_devs.
> + * Function assumes the index was already verified.
> + * Index must be valid, otherwise abort() is called.
> + *
> + * Return: Pointer to corresponding imsm_dev.
> + *
> + */
>  static struct imsm_dev *get_imsm_dev(struct intel_super *super, __u8 ind=
ex)  {
>  	struct intel_dev *dv;
> =20
>  	if (index >=3D super->anchor->num_raid_devs)
> -		return NULL;
> +		goto error;
> +
>  	for (dv =3D super->devlist; dv; dv =3D dv->next)
>  		if (dv->index =3D=3D index)
>  			return dv->dev;
> -	return NULL;
> +error:
> +	pr_err("cannot find imsm_dev with index %u in intel_super\n", index);
> +	abort();
>  }
> =20
>  static inline unsigned long long __le48_to_cpu(const struct bbm_log_bloc=
k_addr @@ -4358,8 +4390,7 @@ int check_mpb_migr_compatibility(struct intel_=
super *super)
>  	for (i =3D 0; i < super->anchor->num_raid_devs; i++) {
>  		struct imsm_dev *dev_iter =3D __get_imsm_dev(super->anchor, i);
> =20
> -		if (dev_iter &&
> -		    dev_iter->vol.migr_state =3D=3D 1 &&
> +		if (dev_iter->vol.migr_state =3D=3D 1 &&
>  		    dev_iter->vol.migr_type =3D=3D MIGR_GEN_MIGR) {
>  			/* This device is migrating */
>  			map0 =3D get_imsm_map(dev_iter, MAP_0); @@ -4508,8 +4539,6 @@ static =
void clear_hi(struct intel_super *super)
>  	}
>  	for (i =3D 0; i < mpb->num_raid_devs; ++i) {
>  		struct imsm_dev *dev =3D get_imsm_dev(super, i);
> -		if (!dev)
> -			return;
>  		for (n =3D 0; n < 2; ++n) {
>  			struct imsm_map *map =3D get_imsm_map(dev, n);
>  			if (!map)
> @@ -5830,7 +5859,7 @@ static int add_to_super_imsm_volume(struct supertyp=
e *st, mdu_disk_info_t *dk,
>  		struct imsm_dev *_dev =3D __get_imsm_dev(mpb, 0);
> =20
>  		_disk =3D __get_imsm_disk(mpb, dl->index);
> -		if (!_dev || !_disk) {
> +		if (!_disk) {
>  			pr_err("BUG mpb setup error\n");
>  			return 1;
>  		}
> @@ -6165,10 +6194,10 @@ static int write_super_imsm(struct supertype *st,=
 int doclose)
>  	for (i =3D 0; i < mpb->num_raid_devs; i++) {
>  		struct imsm_dev *dev =3D __get_imsm_dev(mpb, i);
>  		struct imsm_dev *dev2 =3D get_imsm_dev(super, i);
> -		if (dev && dev2) {
> -			imsm_copy_dev(dev, dev2);
> -			mpb_size +=3D sizeof_imsm_dev(dev, 0);
> -		}
> +
> +		imsm_copy_dev(dev, dev2);
> +		mpb_size +=3D sizeof_imsm_dev(dev, 0);
> +
>  		if (is_gen_migration(dev2))
>  			clear_migration_record =3D 0;
>  	}
> @@ -9032,29 +9061,26 @@ static int imsm_rebuild_allowed(struct supertype =
*cont, int dev_idx, int failed)
>  	__u8 state;
> =20
>  	dev2 =3D get_imsm_dev(cont->sb, dev_idx);
> -	if (dev2) {
> -		state =3D imsm_check_degraded(cont->sb, dev2, failed, MAP_0);
> -		if (state =3D=3D IMSM_T_STATE_FAILED) {
> -			map =3D get_imsm_map(dev2, MAP_0);
> -			if (!map)
> -				return 1;
> -			for (slot =3D 0; slot < map->num_members; slot++) {
> -				/*
> -				 * Check if failed disks are deleted from intel
> -				 * disk list or are marked to be deleted
> -				 */
> -				idx =3D get_imsm_disk_idx(dev2, slot, MAP_X);
> -				idisk =3D get_imsm_dl_disk(cont->sb, idx);
> -				/*
> -				 * Do not rebuild the array if failed disks
> -				 * from failed sub-array are not removed from
> -				 * container.
> -				 */
> -				if (idisk &&
> -				    is_failed(&idisk->disk) &&
> -				    (idisk->action !=3D DISK_REMOVE))
> -					return 0;
> -			}
> +
> +	state =3D imsm_check_degraded(cont->sb, dev2, failed, MAP_0);
> +	if (state =3D=3D IMSM_T_STATE_FAILED) {
> +		map =3D get_imsm_map(dev2, MAP_0);
> +		for (slot =3D 0; slot < map->num_members; slot++) {
> +			/*
> +			 * Check if failed disks are deleted from intel
> +			 * disk list or are marked to be deleted
> +			 */
> +			idx =3D get_imsm_disk_idx(dev2, slot, MAP_X);
> +			idisk =3D get_imsm_dl_disk(cont->sb, idx);
> +			/*
> +			 * Do not rebuild the array if failed disks
> +			 * from failed sub-array are not removed from
> +			 * container.
> +			 */
> +			if (idisk &&
> +			    is_failed(&idisk->disk) &&
> +			    (idisk->action !=3D DISK_REMOVE))
> +				return 0;
>  		}
>  	}
>  	return 1;
> @@ -10088,7 +10114,6 @@ static void imsm_process_update(struct supertype =
*st,
>  		int victim =3D u->dev_idx;
>  		struct active_array *a;
>  		struct intel_dev **dp;
> -		struct imsm_dev *dev;
> =20
>  		/* sanity check that we are not affecting the uuid of
>  		 * active arrays, or deleting an active array @@ -10104,8 +10129,7 @@ =
static void imsm_process_update(struct supertype *st,
>  		 * is active in the container, so checking
>  		 * mpb->num_raid_devs is just extra paranoia
>  		 */
> -		dev =3D get_imsm_dev(super, victim);
> -		if (a || !dev || mpb->num_raid_devs =3D=3D 1) {
> +		if (a || mpb->num_raid_devs =3D=3D 1 || victim >=3D=20
> +super->anchor->num_raid_devs) {
>  			dprintf("failed to delete subarray-%d\n", victim);
>  			break;
>  		}
> @@ -10139,7 +10163,7 @@ static void imsm_process_update(struct supertype =
*st,
>  			if (a->info.container_member =3D=3D target)
>  				break;
>  		dev =3D get_imsm_dev(super, u->dev_idx);
> -		if (a || !dev || !check_name(super, name, 1)) {
> +		if (a || !check_name(super, name, 1)) {
>  			dprintf("failed to rename subarray-%d\n", target);
>  			break;
>  		}
> @@ -10168,10 +10192,6 @@ static void imsm_process_update(struct supertype=
 *st,
>  		struct imsm_update_rwh_policy *u =3D (void *)update->buf;
>  		int target =3D u->dev_idx;
>  		struct imsm_dev *dev =3D get_imsm_dev(super, target);
> -		if (!dev) {
> -			dprintf("could not find subarray-%d\n", target);
> -			break;
> -		}
> =20
>  		if (dev->rwh_policy !=3D u->new_policy) {
>  			dev->rwh_policy =3D u->new_policy;
> @@ -11396,8 +11416,10 @@ static int imsm_create_metadata_update_for_migra=
tion(
>  {
>  	struct intel_super *super =3D st->sb;
>  	int update_memory_size;
> +	int current_chunk_size;
>  	struct imsm_update_reshape_migration *u;
> -	struct imsm_dev *dev;
> +	struct imsm_dev *dev =3D get_imsm_dev(super, super->current_vol);
> +	struct imsm_map *map =3D get_imsm_map(dev, MAP_0);
>  	int previous_level =3D -1;
> =20
>  	dprintf("(enter) New Level =3D %i\n", geo->level); @@ -11414,23 +11436,=
15 @@ static int imsm_create_metadata_update_for_migration(
>  	u->new_disks[0] =3D -1;
>  	u->new_chunksize =3D -1;
> =20
> -	dev =3D get_imsm_dev(super, u->subdev);
> -	if (dev) {
> -		struct imsm_map *map;
> +	current_chunk_size =3D __le16_to_cpu(map->blocks_per_strip) / 2;
> =20
> -		map =3D get_imsm_map(dev, MAP_0);
> -		if (map) {
> -			int current_chunk_size =3D
> -				__le16_to_cpu(map->blocks_per_strip) / 2;
> -
> -			if (geo->chunksize !=3D current_chunk_size) {
> -				u->new_chunksize =3D geo->chunksize / 1024;
> -				dprintf("imsm: chunk size change from %i to %i\n",
> -					current_chunk_size, u->new_chunksize);
> -			}
> -			previous_level =3D map->raid_level;
> -		}
> +	if (geo->chunksize !=3D current_chunk_size) {
> +		u->new_chunksize =3D geo->chunksize / 1024;
> +		dprintf("imsm: chunk size change from %i to %i\n",
> +			current_chunk_size, u->new_chunksize);
>  	}
> +	previous_level =3D map->raid_level;
> +
>  	if (geo->level =3D=3D 5 && previous_level =3D=3D 0) {
>  		struct mdinfo *spares =3D NULL;
> =20
> @@ -12517,9 +12531,6 @@ static int validate_internal_bitmap_imsm(struct s=
upertype *st)
>  	unsigned long long offset;
>  	struct dl *d;
> =20
> -	if (!dev)
> -		return -1;
> -
>  	if (dev->rwh_policy !=3D RWH_BITMAP)
>  		return 0;
> =20
> @@ -12565,16 +12576,8 @@ static int add_internal_bitmap_imsm(struct super=
type *st, int *chunkp,
>  		return -1;
> =20
>  	dev =3D get_imsm_dev(super, vol_idx);
> -
> -	if (!dev) {
> -		dprintf("cannot find the device for volume index %d\n",
> -			vol_idx);
> -		return -1;
> -	}
>  	dev->rwh_policy =3D RWH_BITMAP;
> -
>  	*chunkp =3D calculate_bitmap_chunksize(st, dev);
> -
>  	return 0;
>  }
> =20
> --
> 2.26.2
>

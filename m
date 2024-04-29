Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12olkn2058.outbound.protection.outlook.com [40.92.22.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81D1947B
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 14:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.22.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714400647; cv=fail; b=hFhvFndofhRbc1aAxgIx5jeOfXe0ETzn9059zM9BLjMPlnUuiH9qZrozmV1H81q6tbS9pJ28oygR2OLEvOKWNjI+BiQn3MUx37YpGRLDVz6IUsEgFEDkF7JLKteXs3miv5lfAu/J+WA2U14NOhODzZ8tiZroFYS5CMZ5wGTOZUA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714400647; c=relaxed/simple;
	bh=LZhbyS97JruqhHh0BS/mBNY51izGFqk/tkNNCL6lW5Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZO4yyeMbcghntUvx6NDJXn7rO4Ea6c4Uzl1DB7wzTCNEs53GBwbbfY1ZlrRGho50DDf97GoZhgxxhLLxU9X2R8lJ6xUmOfE7JNGTnSvhAvNuU6XHZd0wzEebRnEt27IFR5kC03l9xUnfd3fSVpA59rpxxmKQvJ90A2PKCgpOkRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=kYISFeIi; arc=fail smtp.client-ip=40.92.22.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="kYISFeIi"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jOl8XgskGrjLACJs0ZFVtjQiXz1HtQ+gvOb53WuD/ejSfTIZbkqy1lvVsE2KWL+bAn+G7f7QJDHBMHg8TXiIt+UvVAh/ini0r0X1TS681itgk90IVUksRDHqSbYMkx8zDU18NL12zVxY3llErKINUpvbd08KyLFYkBMRBsl4RroBsniH2orRYPjFDWKbyH8bs874zqcdhF3cDxDxFnLQFzXmVRKxSxOhSmOoLmbxV+Epembw/0EcelEvVjfPJZ2HKOGXzLFt79qWXHrwBEHnKWCw2QQM8v/wP0EqdJNUDS1hoERzr8npbIMemiI5+U4Xh7mwKjXGKiOlLJH/HTVD7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jKq/dcB/vMuA0pqHpfkFFlwyPx2+4U4LYs7MAExV7nQ=;
 b=iMdqCzs77XHxDNMlkrjALLu2h9PQGSJ5SsxB0/LAY2sy/4D5pNG31FBZNFy1yZzQe68tRZQbeW0hf2btCT/UB7d/6dyjPY9zJVN+vCqkRd3X2cZBPZeyGhoqrz4dG2TCVT8PM0bzPcV+EG3xo/tQ3o8+0U0uzNHMubsCxB+8DpPDStHnKgF4Is4HVlnai3eRi92Gffk2rJlRcn0IjABQZqsW97/eJtNgLhGt3sqw1WCCLkrHJ/iTWFB2GDO/OUTWVLAVenoUP3vmj04Ys1fkptmJPCuA9ragC5b7dV8wU0YgMOZaxw+LBunGljpXVBeKCltYDOzYr2J8bqCVGcOjcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jKq/dcB/vMuA0pqHpfkFFlwyPx2+4U4LYs7MAExV7nQ=;
 b=kYISFeIicU3WqdLBsZe+aZAhulB8uO+15bwg3T4iqjDUDzy6EG9kzyz529U3haGjLA1V67f01JJqd5lMVV8hqnLF1L2CVE7WvpJjKFHX37533oTqwLZcsVeC3iHNZ5OnwbNjMvZUzZRP56S/s41WZa6So0YPgTHIYnFKZ0votIw656NJdQ+nXiLYNK4Rmda3wTbdrR0vZncOatlxB5YDcLTJWeLlVa+w+smj9+rDvU6CVmt1rqfEAqP2WJYLs/lKzM0kL/zFEbEt8oDXkX6QyhPMOmtBS+B//sVpimOxihWS0jZeZP6aaPElgt0ThPBaqrPdSVbx+Vi+B1IOGCsFIw==
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com (2603:10b6:a03:3ec::20)
 by BN0PR10MB4854.namprd10.prod.outlook.com (2603:10b6:408:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.35; Mon, 29 Apr
 2024 14:24:02 +0000
Received: from SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1]) by SJ0PR10MB5741.namprd10.prod.outlook.com
 ([fe80::51c4:f423:321e:5e1%4]) with mapi id 15.20.7519.031; Mon, 29 Apr 2024
 14:24:02 +0000
From: "teddyxym@outlook.com" <teddyxym@outlook.com>
To: Paul E Luse <paul.e.luse@linux.intel.com>
CC: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"firnyee@gmail.com" <firnyee@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"hch@infradead.org" <hch@infradead.org>, "paul.e.luse@intel.com"
	<paul.e.luse@intel.com>
Subject: Re: [RFC V4] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
Thread-Topic: [RFC V4] md/raid5: optimize Scattered Address Space and
 Thread-Level Parallelism to improve RAID5 performance
Thread-Index: ATJFMEU1f33YBGojGJVMCKmTB2oIODlmLjQyzt7sDk8=
X-MS-Exchange-MessageSentRepresentingType: 1
Date: Mon, 29 Apr 2024 14:23:56 +0000
Message-ID:
 <SJ0PR10MB57416095FE931F007FB79186D81B2@SJ0PR10MB5741.namprd10.prod.outlook.com>
References:
 <SJ0PR10MB5741964ECA25920AD608FEADD8082@SJ0PR10MB5741.namprd10.prod.outlook.com>
 <20240423234836.42bfbf39@peluse-desk5>
In-Reply-To: <20240423234836.42bfbf39@peluse-desk5>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-TMN: [R8ZfGwFqU/b/rsRL1nNfSR1a7RlT12jU3mlgHVhdlv8=]
X-ClientProxiedBy: BY5PR04CA0025.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::35) To SJ0PR10MB5741.namprd10.prod.outlook.com
 (2603:10b6:a03:3ec::20)
X-Microsoft-Original-Message-ID:
 <SJ2PR16MB5595465FE3A891E460E49FE2A21B2@SJ2PR16MB5595.namprd16.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB5741:EE_|BN0PR10MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 52c9611f-cd84-43a8-8b84-08dc68580432
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|461199019|440099019|3412199016|56899024;
X-Microsoft-Antispam-Message-Info:
	UFJx5l/aKpHXI/dYTHuCkzAsoFJX1VH0YlCqMyBDvQALsCpR3dcat6ATNEBy/1H8alnRe1UZPhHlAYONXuRq/t0XEHHFQjDjCfVSsBdrfVOhzLmGhl9I3QOeTtaiPYZIFjEosCpO/+57K01rGNo3Mj0/7SAp5tRI/pwrhXOhW/1GrDG5Ebp/4RjU5LZU8UICNvpZ9IkrPOu9LSLu6qeqkIMLTyhGoqa7KifMMjRGpr0Affi4zxsggzyUZ7IhKKYah8HeBeVAis6Lngpb1byf9u8233iPIS0iHQqNFynCNn9zLuNQxiqPuXdPVnHqYPULjc/onwYEPsLjZnWB44nXj5TidIpqpzHkzOMA11+8KMxalPshrqooPIwb+JtR6ykq96Y1DUYNj+CbPUB2G3Ps5ryxedxLRsrdnyngo8bFxvaDun/nUfJcQ+MmAD5xS/8Uzn+d0FJu5SSwxO3Igv45si7TvB2/mTHEsvTTJ+7oGxQFc8rHadRD36V1fI2kNWIYm/EIN8GTdEWmht0Uhf5CHYsIvTtmY+oT51Xqr/zw4mKjsyiIFvMyny4P8Dx0ARhiSN22U+wGMLwcf7ykAHGk4JwcKda7e6eHcgDuhlb9akI=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?99KJcB6i1D7CqN3XaHyhM76fECN6pX/a4rfrqoSyDSMKm+67JTiL8bzz7H?=
 =?iso-8859-1?Q?U4ar+n8rIHRvHnsY4oPkHpYQP9ta45U4IlutSuX98yVEf1K08bCizLIkXN?=
 =?iso-8859-1?Q?e2Xhq8/k4004CnY/64WmpQhZbSHNaZeMpGJGs0Y5bbaMhe3+tR1rxcj1lz?=
 =?iso-8859-1?Q?evV14hqPLKRAGGNHTM7yuDE7n1n6sJP9YwhWf6eyWJJL1Z6YVafmlaOu2N?=
 =?iso-8859-1?Q?iFUt1InABDYVK9ddtXOCzUKi574VSE0RxxnRkqqJvTMxr2uSh1Y4A+DxF/?=
 =?iso-8859-1?Q?uSlpAGhfyu1flG/73BYrFR/aMMsD1TDCwILypP5WlTC1wb6ooIpgAbqUh6?=
 =?iso-8859-1?Q?kHL3JHqM9CKvLyYtBpc+TKbrKfNtY9GSOEfl3YXaTS8de30OjQjxNlr/dR?=
 =?iso-8859-1?Q?788cP4G8lJazEZGzvSfueBkvkGivmW/Y1hsnfjgAW0t177bMGLxRlzCuUo?=
 =?iso-8859-1?Q?tBDt26wIyxnuicVqoQ1zqUyoVe9HHnxrpB+9A68qTacZhYie3rNPktX/dJ?=
 =?iso-8859-1?Q?IQo9OzjhY5iGmeqr59CXM8OyPHs0tCF7XdmhQB0g63MdwR/FtlLxfqB+xj?=
 =?iso-8859-1?Q?qc3Kn7jdTM22JIqWqBk3Em4gzZ7uuiTiWAmkQ4NUkZYhYNVvjZ02HftyBA?=
 =?iso-8859-1?Q?ExvoG++A16SYNZChEuXJqbnEdy7n1RRAueUkDiHljyuz1t2QaZjzFSdY11?=
 =?iso-8859-1?Q?QbWsZCP9HIOrKCsAcaqZP+jA7i82GNfLluZJzTgdn0Eb97KJaEYWdxTA02?=
 =?iso-8859-1?Q?xtWvUQEi7PN8fLd8UrVJlwqb3xwgozzNkvE6O7qJr3aV5cU4thlRbVIwDj?=
 =?iso-8859-1?Q?Ws17Gq6OmC8tGkn9g7xaQDPjGVBa359wn0/Zo4uH/oNPRJfx+hNJrHjW+6?=
 =?iso-8859-1?Q?sbk+C+xcAqx4oSsJ014vw/ElC8d96Wb360xug0KFTDbPRfZPDVs/VFgOW3?=
 =?iso-8859-1?Q?sGL0DtnA5TFaE9GUVY/uHpzink7LYPBhKLcb25X3gtQdKVjv09itkPhr7J?=
 =?iso-8859-1?Q?C8IYQdhby9Zdo55B3u2gnrWcH7+aLoLQXODM3Q9a+1vQd67s22TeWzV7ii?=
 =?iso-8859-1?Q?dK/TcU84TLOrd4GMMZ0v1NF2bsrQA7RGcr3gBRxjuykRfBMM0LTLcOd8hb?=
 =?iso-8859-1?Q?FrdOVxQHyPXYabQk0Zn351XiEnIGRKRD25PQKUkUwsPRjaROccKrCMgiP8?=
 =?iso-8859-1?Q?UgL24pfWAUrIV32uHpDmgK8sv/YoL+tY5FEI8BJhzsMy4yf3wRXUsBEpiY?=
 =?iso-8859-1?Q?5lDvrm2xQumMPDQtPW25xHlUUc5noMNhkinZ8RjL8hhXdhVAS7Lgs36NNe?=
 =?iso-8859-1?Q?2LW1?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52c9611f-cd84-43a8-8b84-08dc68580432
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB5741.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 14:24:01.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854

Thanks Paul for testing the patch! Here are some detailed data and test set=
up mentioned in the patch changelog to improve performance.=0A=
=0A=
"increased overall storage throughput by 89.4%": Set the iodepth to 32 and =
employ libaio. Configure the I/O size as 4 KB with sequential write and 16 =
threads. In RAID5 consist of 2+1 1TB Samsung 980Pro SSDs, throughput went f=
rom 5218MB/s to 9884MB/s when apply this patch.=0A=
=0A=
"decrease the 99.99th percentile I/O latency by 85.4%": Set the iodepth to =
32 and employ libaio. Configure the I/O size as 4 KB with sequential write.=
 In RAID5 consist of 4+1 1TB Samsung 980Pro SSDs, 99.99th tail latency went=
 from 6325us to 922us when apply this patch.=0A=
=0A=
On Wed, 24 Apr 2024, 14:48=0A=
Paul E Luse <paul.e.luse@linux.intel.com> wrote:=0A=
=0A=
> Thanks Shushu! Apprecaite the continued follow-ups for sure.  Wrt the=0A=
> performance claims below can you provide the full details on test setup=
=0A=
> and results?=0A=
> =0A=
> Within the next few days I should have a chance to run this again on=0A=
> latest Xeon with gen5 Samsungs.=0A=
> =0A=
> -Paul=0A=
> =0A=
> On Tue, 16 Apr 2024 13:22:53 +0800=0A=
> Shushu Yi <teddyxym@outlook.com> wrote:=0A=
> =0A=
> > Optimize scattered address space. Achieves significant improvements in=
=0A=
> > both throughput and latency.=0A=
> >=0A=
> > Maximize thread-level parallelism and reduce CPU suspension time=0A=
> > caused by lock contention. Achieve increased overall storage=0A=
> > throughput by 89.4% and decrease the 99.99th percentile I/O latency=0A=
> > by 85.4% on a system with four PCIe 4.0 SSDs.=0A=
> >=0A=
> > Note: Publish this work as a paper and provide the URL=0A=
> > (https://www.hotstorage.org/2022/camera-ready/hotstorage22-5/pdf/=0A=
> > hotstorage22-5.pdf).=0A=
> >=0A=
> > Co-developed-by: Yiming Xu <teddyxym@outlook.com>=0A=
> > Signed-off-by: Yiming Xu <teddyxym@outlook.com>=0A=
> > Signed-off-by: Shushu Yi <firnyee@gmail.com>=0A=
> > Tested-by: Paul Luse <paul.e.luse@intel.com>=0A=
> > ---=0A=
> > V1 -> V2: Cleaned up coding style and divided into 2 patches (HemiRAID=
=0A=
> > and ScalaRAID corresponding to the paper mentioned above). ScalaRAID=0A=
> > equipped every counter with a counter lock and employ our D-Block.=0A=
> > HemiRAID increased the number of stripe locks to 128=0A=
> > V2 -> V3: Adjusted the language used in the subject and changelog.=0A=
> > Since patch 1/2 in V2 cannot be used independently and does not=0A=
> > encompass all of our work, it has been merged into a single patch.=0A=
> > V3 -> V4: Fixed incorrect sending address and changelog format.=0A=
> >=0A=
> >  drivers/md/md-bitmap.c | 197=0A=
> > ++++++++++++++++++++++++++++++----------- drivers/md/md-bitmap.h |=0A=
> > 12 ++- 2 files changed, 154 insertions(+), 55 deletions(-)=0A=
> >=0A=
> > diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c=0A=
> > index 059afc24c08b..5ed5fe810b2f 100644=0A=
> > --- a/drivers/md/md-bitmap.c=0A=
> > +++ b/drivers/md/md-bitmap.c=0A=
> > @@ -47,10 +47,12 @@ static inline char *bmname(struct bitmap *bitmap)=
=0A=
> >   * if we find our page, we increment the page's refcount so that it=0A=
> > stays=0A=
> >   * allocated while we're using it=0A=
> >   */=0A=
> > -static int md_bitmap_checkpage(struct bitmap_counts *bitmap,=0A=
> > -                            unsigned long page, int create, int=0A=
> > no_hijack) -__releases(bitmap->lock)=0A=
> > -__acquires(bitmap->lock)=0A=
> > +static int md_bitmap_checkpage(struct bitmap_counts *bitmap,=0A=
> > unsigned long page,=0A=
> > +                            int create, int no_hijack, spinlock_t=0A=
> > *bmclock, int locktype) +__releases(bmclock)=0A=
> > +__acquires(bmclock)=0A=
> > +__releases(bitmap->mlock)=0A=
> > +__acquires(bitmap->mlock)=0A=
> >  {=0A=
> >       unsigned char *mappage;=0A=
> >=0A=
> > @@ -65,8 +67,10 @@ __acquires(bitmap->lock)=0A=
> >               return -ENOENT;=0A=
> >=0A=
> >       /* this page has not been allocated yet */=0A=
> > -=0A=
> > -     spin_unlock_irq(&bitmap->lock);=0A=
> > +     if (locktype)=0A=
> > +             spin_unlock_irq(bmclock);=0A=
> > +     else=0A=
> > +             write_unlock_irq(&bitmap->mlock);=0A=
> >       /* It is possible that this is being called inside a=0A=
> >        * prepare_to_wait/finish_wait loop from=0A=
> > raid5c:make_request().=0A=
> >        * In general it is not permitted to sleep in that context=0A=
> > as it @@ -81,7 +85,11 @@ __acquires(bitmap->lock)=0A=
> >        */=0A=
> >       sched_annotate_sleep();=0A=
> >       mappage =3D kzalloc(PAGE_SIZE, GFP_NOIO);=0A=
> > -     spin_lock_irq(&bitmap->lock);=0A=
> > +=0A=
> > +     if (locktype)=0A=
> > +             spin_lock_irq(bmclock);=0A=
> > +     else=0A=
> > +             write_lock_irq(&bitmap->mlock);=0A=
> >=0A=
> >       if (mappage =3D=3D NULL) {=0A=
> >               pr_debug("md/bitmap: map page allocation failed,=0A=
> > hijacking\n"); @@ -399,7 +407,7 @@ static int read_file_page(struct=0A=
> > file *file, unsigned long index, }=0A=
> >=0A=
> >       wait_event(bitmap->write_wait,=0A=
> > -                atomic_read(&bitmap->pending_writes)=3D=3D0);=0A=
> > +                atomic_read(&bitmap->pending_writes) =3D=3D 0);=0A=
> >       if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))=0A=
> >               ret =3D -EIO;=0A=
> >  out:=0A=
> > @@ -458,7 +466,7 @@ static void md_bitmap_wait_writes(struct bitmap=0A=
> > *bitmap) {=0A=
> >       if (bitmap->storage.file)=0A=
> >               wait_event(bitmap->write_wait,=0A=
> > -                        atomic_read(&bitmap->pending_writes)=3D=3D0);=
=0A=
> > +                        atomic_read(&bitmap->pending_writes) =3D=3D=0A=
> > 0); else=0A=
> >               /* Note that we ignore the return value.  The writes=0A=
> >                * might have failed, but that would just mean that=0A=
> > @@ -1248,16 +1256,28 @@ void md_bitmap_write_all(struct bitmap=0A=
> > *bitmap) static void md_bitmap_count_page(struct bitmap_counts=0A=
> > *bitmap, sector_t offset, int inc)=0A=
> >  {=0A=
> > -     sector_t chunk =3D offset >> bitmap->chunkshift;=0A=
> > -     unsigned long page =3D chunk >> PAGE_COUNTER_SHIFT;=0A=
> > +     sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);=0A=
> > +     sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift -=0A=
> > (PAGE_SHIFT - SECTOR_SHIFT));=0A=
> > +     unsigned long bits =3D totblocks ? fls((totblocks - 1)) : 0;=0A=
> > +     unsigned long mask =3D ULONG_MAX << bits | ~(ULONG_MAX <<=0A=
> > +                                     (bits - (bitmap->chunkshift=0A=
> > + SECTOR_SHIFT - PAGE_SHIFT)));=0A=
> > +     unsigned long cntid =3D blockno & mask;=0A=
> > +     unsigned long page =3D cntid >> PAGE_COUNTER_SHIFT;=0A=
> > +=0A=
> >       bitmap->bp[page].count +=3D inc;=0A=
> >       md_bitmap_checkfree(bitmap, page);=0A=
> >  }=0A=
> >=0A=
> >  static void md_bitmap_set_pending(struct bitmap_counts *bitmap,=0A=
> > sector_t offset) {=0A=
> > -     sector_t chunk =3D offset >> bitmap->chunkshift;=0A=
> > -     unsigned long page =3D chunk >> PAGE_COUNTER_SHIFT;=0A=
> > +     sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);=0A=
> > +     sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift -=0A=
> > (PAGE_SHIFT - SECTOR_SHIFT));=0A=
> > +     unsigned long bits =3D totblocks ? fls((totblocks - 1)) : 0;=0A=
> > +     unsigned long mask =3D ULONG_MAX << bits | ~(ULONG_MAX <<=0A=
> > +                                     (bits - (bitmap->chunkshift=0A=
> > + SECTOR_SHIFT - PAGE_SHIFT)));=0A=
> > +     unsigned long cntid =3D blockno & mask;=0A=
> > +     unsigned long page =3D cntid >> PAGE_COUNTER_SHIFT;=0A=
> > +=0A=
> >       struct bitmap_page *bp =3D &bitmap->bp[page];=0A=
> >=0A=
> >       if (!bp->pending)=0A=
> > @@ -1266,7 +1286,7 @@ static void md_bitmap_set_pending(struct=0A=
> > bitmap_counts *bitmap, sector_t offset)=0A=
> >  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts=0A=
> > *bitmap, sector_t offset, sector_t *blocks,=0A=
> > -                                            int create);=0A=
> > +                                            int create,=0A=
> > spinlock_t *bmclock, int locktype);=0A=
> >  static void mddev_set_timeout(struct mddev *mddev, unsigned long=0A=
> > timeout, bool force)=0A=
> > @@ -1349,7 +1369,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)=
=0A=
> >        * decrement and handle accordingly.=0A=
> >        */=0A=
> >       counts =3D &bitmap->counts;=0A=
> > -     spin_lock_irq(&counts->lock);=0A=
> > +     write_lock_irq(&counts->mlock);=0A=
> >       nextpage =3D 0;=0A=
> >       for (j =3D 0; j < counts->chunks; j++) {=0A=
> >               bitmap_counter_t *bmc;=0A=
> > @@ -1364,7 +1384,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)=
=0A=
> >                       counts->bp[j >> PAGE_COUNTER_SHIFT].pending=0A=
> > =3D 0; }=0A=
> >=0A=
> > -             bmc =3D md_bitmap_get_counter(counts, block, &blocks,=0A=
> > 0);=0A=
> > +             bmc =3D md_bitmap_get_counter(counts, block, &blocks,=0A=
> > 0, 0, 0); if (!bmc) {=0A=
> >                       j |=3D PAGE_COUNTER_MASK;=0A=
> >                       continue;=0A=
> > @@ -1380,7 +1400,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)=
=0A=
> >                       bitmap->allclean =3D 0;=0A=
> >               }=0A=
> >       }=0A=
> > -     spin_unlock_irq(&counts->lock);=0A=
> > +     write_unlock_irq(&counts->mlock);=0A=
> >=0A=
> >       md_bitmap_wait_writes(bitmap);=0A=
> >       /* Now start writeout on any page in NEEDWRITE that isn't=0A=
> > DIRTY. @@ -1413,17 +1433,25 @@ void md_bitmap_daemon_work(struct=0A=
> > mddev *mddev)=0A=
> >  static bitmap_counter_t *md_bitmap_get_counter(struct bitmap_counts=0A=
> > *bitmap, sector_t offset, sector_t *blocks,=0A=
> > -                                            int create)=0A=
> > -__releases(bitmap->lock)=0A=
> > -__acquires(bitmap->lock)=0A=
> > +                                            int create,=0A=
> > spinlock_t *bmclock, int locktype) +__releases(bmclock)=0A=
> > +__acquires(bmclock)=0A=
> > +__releases(bitmap->mlock)=0A=
> > +__acquires(bitmap->mlock)=0A=
> >  {=0A=
> >       /* If 'create', we might release the lock and reclaim it.=0A=
> >        * The lock must have been taken with interrupts enabled.=0A=
> >        * If !create, we don't release the lock.=0A=
> >        */=0A=
> > -     sector_t chunk =3D offset >> bitmap->chunkshift;=0A=
> > -     unsigned long page =3D chunk >> PAGE_COUNTER_SHIFT;=0A=
> > -     unsigned long pageoff =3D (chunk & PAGE_COUNTER_MASK) <<=0A=
> > COUNTER_BYTE_SHIFT;=0A=
> > +     sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);=0A=
> > +     sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift -=0A=
> > (PAGE_SHIFT - SECTOR_SHIFT));=0A=
> > +     unsigned long bits =3D totblocks ? fls((totblocks - 1)) : 0;=0A=
> > +     unsigned long mask =3D ULONG_MAX << bits | ~(ULONG_MAX <<=0A=
> > +                                     (bits - (bitmap->chunkshift=0A=
> > + SECTOR_SHIFT - PAGE_SHIFT)));=0A=
> > +     unsigned long cntid =3D blockno & mask;=0A=
> > +     unsigned long page =3D cntid >> PAGE_COUNTER_SHIFT;=0A=
> > +     unsigned long pageoff =3D (cntid & PAGE_COUNTER_MASK) <<=0A=
> > COUNTER_BYTE_SHIFT; +=0A=
> >       sector_t csize;=0A=
> >       int err;=0A=
> >=0A=
> > @@ -1435,7 +1463,7 @@ __acquires(bitmap->lock)=0A=
> >                */=0A=
> >               return NULL;=0A=
> >       }=0A=
> > -     err =3D md_bitmap_checkpage(bitmap, page, create, 0);=0A=
> > +     err =3D md_bitmap_checkpage(bitmap, page, create, 0, bmclock,=0A=
> > 1);=0A=
> >       if (bitmap->bp[page].hijacked ||=0A=
> >           bitmap->bp[page].map =3D=3D NULL)=0A=
> > @@ -1461,6 +1489,28 @@ __acquires(bitmap->lock)=0A=
> >                       &(bitmap->bp[page].map[pageoff]);=0A=
> >  }=0A=
> >=0A=
> > +/* set-association */=0A=
> > +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts=0A=
> > *bitmap, sector_t offset); +=0A=
> > +static spinlock_t *md_bitmap_get_bmclock(struct bitmap_counts=0A=
> > *bitmap, sector_t offset) +{=0A=
> > +     sector_t blockno =3D offset >> (PAGE_SHIFT - SECTOR_SHIFT);=0A=
> > +     sector_t totblocks =3D bitmap->chunks << (bitmap->chunkshift -=0A=
> > (PAGE_SHIFT - SECTOR_SHIFT));=0A=
> > +     unsigned long bitscnt =3D totblocks ? fls((totblocks - 1)) : 0;=
=0A=
> > +     unsigned long maskcnt =3D ULONG_MAX << bitscnt | ~(ULONG_MAX=0A=
> > << (bitscnt -=0A=
> > +                                     (bitmap->chunkshift +=0A=
> > SECTOR_SHIFT - PAGE_SHIFT)));=0A=
> > +     unsigned long cntid =3D blockno & maskcnt;=0A=
> > +=0A=
> > +     unsigned long totcnts =3D bitmap->chunks;=0A=
> > +     unsigned long bitslock =3D totcnts ? fls((totcnts - 1)) : 0;=0A=
> > +     unsigned long masklock =3D ULONG_MAX << bitslock | ~(ULONG_MAX=0A=
> > <<=0A=
> > +                                     (bitslock -=0A=
> > BITMAP_COUNTER_LOCK_RATIO_SHIFT));=0A=
> > +     unsigned long lockid =3D cntid & masklock;=0A=
> > +=0A=
> > +     spinlock_t *bmclock =3D &(bitmap->bmclocks[lockid]);=0A=
> > +     return bmclock;=0A=
> > +}=0A=
> > +=0A=
> >  int md_bitmap_startwrite(struct bitmap *bitmap, sector_t offset,=0A=
> > unsigned long sectors, int behind) {=0A=
> >       if (!bitmap)=0A=
> > @@ -1480,11 +1530,15 @@ int md_bitmap_startwrite(struct bitmap=0A=
> > *bitmap, sector_t offset, unsigned long s while (sectors) {=0A=
> >               sector_t blocks;=0A=
> >               bitmap_counter_t *bmc;=0A=
> > +             spinlock_t *bmclock;=0A=
> >=0A=
> > -             spin_lock_irq(&bitmap->counts.lock);=0A=
> > -             bmc =3D md_bitmap_get_counter(&bitmap->counts, offset,=0A=
> > &blocks, 1);=0A=
> > +             bmclock =3D md_bitmap_get_bmclock(&bitmap->counts,=0A=
> > offset);=0A=
> > +             read_lock(&bitmap->counts.mlock);=0A=
> > +             spin_lock_irq(bmclock);=0A=
> > +             bmc =3D md_bitmap_get_counter(&bitmap->counts, offset,=0A=
> > &blocks, 1, bmclock, 1); if (!bmc) {=0A=
> > -                     spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +                     spin_unlock_irq(bmclock);=0A=
> > +                     read_unlock(&bitmap->counts.mlock);=0A=
> >                       return 0;=0A=
> >               }=0A=
> >=0A=
> > @@ -1496,7 +1550,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap,=
=0A=
> > sector_t offset, unsigned long s */=0A=
> >                       prepare_to_wait(&bitmap->overflow_wait,=0A=
> > &__wait, TASK_UNINTERRUPTIBLE);=0A=
> > -                     spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +                     spin_unlock_irq(bmclock);=0A=
> > +                     read_unlock(&bitmap->counts.mlock);=0A=
> >                       schedule();=0A=
> >                       finish_wait(&bitmap->overflow_wait, &__wait);=0A=
> >                       continue;=0A=
> > @@ -1513,7 +1568,8 @@ int md_bitmap_startwrite(struct bitmap *bitmap,=
=0A=
> > sector_t offset, unsigned long s=0A=
> >               (*bmc)++;=0A=
> >=0A=
> > -             spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +             spin_unlock_irq(bmclock);=0A=
> > +             read_unlock(&bitmap->counts.mlock);=0A=
> >=0A=
> >               offset +=3D blocks;=0A=
> >               if (sectors > blocks)=0A=
> > @@ -1542,11 +1598,15 @@ void md_bitmap_endwrite(struct bitmap=0A=
> > *bitmap, sector_t offset, sector_t blocks;=0A=
> >               unsigned long flags;=0A=
> >               bitmap_counter_t *bmc;=0A=
> > +             spinlock_t *bmclock;=0A=
> >=0A=
> > -             spin_lock_irqsave(&bitmap->counts.lock, flags);=0A=
> > -             bmc =3D md_bitmap_get_counter(&bitmap->counts, offset,=0A=
> > &blocks, 0);=0A=
> > +             bmclock =3D md_bitmap_get_bmclock(&bitmap->counts,=0A=
> > offset);=0A=
> > +             read_lock(&bitmap->counts.mlock);=0A=
> > +             spin_lock_irqsave(bmclock, flags);=0A=
> > +             bmc =3D md_bitmap_get_counter(&bitmap->counts, offset,=0A=
> > &blocks, 0, bmclock, 1); if (!bmc) {=0A=
> > -                     spin_unlock_irqrestore(&bitmap->counts.lock,=0A=
> > flags);=0A=
> > +                     spin_unlock_irqrestore(bmclock, flags);=0A=
> > +                     read_unlock(&bitmap->counts.mlock);=0A=
> >                       return;=0A=
> >               }=0A=
> >=0A=
> > @@ -1568,7 +1628,8 @@ void md_bitmap_endwrite(struct bitmap *bitmap,=0A=
> > sector_t offset, md_bitmap_set_pending(&bitmap->counts, offset);=0A=
> >                       bitmap->allclean =3D 0;=0A=
> >               }=0A=
> > -             spin_unlock_irqrestore(&bitmap->counts.lock, flags);=0A=
> > +             spin_unlock_irqrestore(bmclock, flags);=0A=
> > +             read_unlock(&bitmap->counts.mlock);=0A=
> >               offset +=3D blocks;=0A=
> >               if (sectors > blocks)=0A=
> >                       sectors -=3D blocks;=0A=
> > @@ -1582,13 +1643,16 @@ static int __bitmap_start_sync(struct bitmap=0A=
> > *bitmap, sector_t offset, sector_t int degraded)=0A=
> >  {=0A=
> >       bitmap_counter_t *bmc;=0A=
> > +     spinlock_t *bmclock;=0A=
> >       int rv;=0A=
> >       if (bitmap =3D=3D NULL) {/* FIXME or bitmap set as 'failed' */=0A=
> >               *blocks =3D 1024;=0A=
> >               return 1; /* always resync if no bitmap */=0A=
> >       }=0A=
> > -     spin_lock_irq(&bitmap->counts.lock);=0A=
> > -     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, blocks,=0A=
> > 0);=0A=
> > +     bmclock =3D md_bitmap_get_bmclock(&bitmap->counts, offset);=0A=
> > +     read_lock(&bitmap->counts.mlock);=0A=
> > +     spin_lock_irq(bmclock);=0A=
> > +     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, blocks,=0A=
> > 0, bmclock, 1); rv =3D 0;=0A=
> >       if (bmc) {=0A=
> >               /* locked */=0A=
> > @@ -1602,7 +1666,8 @@ static int __bitmap_start_sync(struct bitmap=0A=
> > *bitmap, sector_t offset, sector_t }=0A=
> >               }=0A=
> >       }=0A=
> > -     spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +     spin_unlock_irq(bmclock);=0A=
> > +     read_unlock(&bitmap->counts.mlock);=0A=
> >       return rv;=0A=
> >  }=0A=
> >=0A=
> > @@ -1634,13 +1699,16 @@ void md_bitmap_end_sync(struct bitmap=0A=
> > *bitmap, sector_t offset, sector_t *blocks {=0A=
> >       bitmap_counter_t *bmc;=0A=
> >       unsigned long flags;=0A=
> > +     spinlock_t *bmclock;=0A=
> >=0A=
> >       if (bitmap =3D=3D NULL) {=0A=
> >               *blocks =3D 1024;=0A=
> >               return;=0A=
> >       }=0A=
> > -     spin_lock_irqsave(&bitmap->counts.lock, flags);=0A=
> > -     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, blocks,=0A=
> > 0);=0A=
> > +     bmclock =3D md_bitmap_get_bmclock(&bitmap->counts, offset);=0A=
> > +     read_lock(&bitmap->counts.mlock);=0A=
> > +     spin_lock_irqsave(bmclock, flags);=0A=
> > +     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, blocks,=0A=
> > 0, bmclock, 1); if (bmc =3D=3D NULL)=0A=
> >               goto unlock;=0A=
> >       /* locked */=0A=
> > @@ -1657,7 +1725,8 @@ void md_bitmap_end_sync(struct bitmap *bitmap,=0A=
> > sector_t offset, sector_t *blocks }=0A=
> >       }=0A=
> >   unlock:=0A=
> > -     spin_unlock_irqrestore(&bitmap->counts.lock, flags);=0A=
> > +     spin_unlock_irqrestore(bmclock, flags);=0A=
> > +     read_unlock(&bitmap->counts.mlock);=0A=
> >  }=0A=
> >  EXPORT_SYMBOL(md_bitmap_end_sync);=0A=
> >=0A=
> > @@ -1738,10 +1807,15 @@ static void md_bitmap_set_memory_bits(struct=0A=
> > bitmap *bitmap, sector_t offset, in=0A=
> >       sector_t secs;=0A=
> >       bitmap_counter_t *bmc;=0A=
> > -     spin_lock_irq(&bitmap->counts.lock);=0A=
> > -     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, &secs,=0A=
> > 1);=0A=
> > +     spinlock_t *bmclock;=0A=
> > +=0A=
> > +     bmclock =3D md_bitmap_get_bmclock(&bitmap->counts, offset);=0A=
> > +     read_lock(&bitmap->counts.mlock);=0A=
> > +     spin_lock_irq(bmclock);=0A=
> > +     bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, &secs,=0A=
> > 1, bmclock, 1); if (!bmc) {=0A=
> > -             spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +             spin_unlock_irq(bmclock);=0A=
> > +             read_unlock(&bitmap->counts.mlock);=0A=
> >               return;=0A=
> >       }=0A=
> >       if (!*bmc) {=0A=
> > @@ -1752,7 +1826,8 @@ static void md_bitmap_set_memory_bits(struct=0A=
> > bitmap *bitmap, sector_t offset, in }=0A=
> >       if (needed)=0A=
> >               *bmc |=3D NEEDED_MASK;=0A=
> > -     spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +     spin_unlock_irq(bmclock);=0A=
> > +     read_unlock(&bitmap->counts.mlock);=0A=
> >  }=0A=
> >=0A=
> >  /* dirty the memory and file bits for bitmap chunks "s" to "e" */=0A=
> > @@ -1806,6 +1881,7 @@ void md_bitmap_free(struct bitmap *bitmap)=0A=
> >  {=0A=
> >       unsigned long k, pages;=0A=
> >       struct bitmap_page *bp;=0A=
> > +     spinlock_t *bmclocks;=0A=
> >=0A=
> >       if (!bitmap) /* there was no bitmap */=0A=
> >               return;=0A=
> > @@ -1826,6 +1902,7 @@ void md_bitmap_free(struct bitmap *bitmap)=0A=
> >=0A=
> >       bp =3D bitmap->counts.bp;=0A=
> >       pages =3D bitmap->counts.pages;=0A=
> > +     bmclocks =3D bitmap->counts.bmclocks;=0A=
> >=0A=
> >       /* free all allocated memory */=0A=
> >=0A=
> > @@ -1834,6 +1911,7 @@ void md_bitmap_free(struct bitmap *bitmap)=0A=
> >                       if (bp[k].map && !bp[k].hijacked)=0A=
> >                               kfree(bp[k].map);=0A=
> >       kfree(bp);=0A=
> > +     kfree(bmclocks);=0A=
> >       kfree(bitmap);=0A=
> >  }=0A=
> >  EXPORT_SYMBOL(md_bitmap_free);=0A=
> > @@ -1900,7 +1978,9 @@ struct bitmap *md_bitmap_create(struct mddev=0A=
> > *mddev, int slot) if (!bitmap)=0A=
> >               return ERR_PTR(-ENOMEM);=0A=
> >=0A=
> > -     spin_lock_init(&bitmap->counts.lock);=0A=
> > +     /* initialize metadata lock */=0A=
> > +     rwlock_init(&bitmap->counts.mlock);=0A=
> > +=0A=
> >       atomic_set(&bitmap->pending_writes, 0);=0A=
> >       init_waitqueue_head(&bitmap->write_wait);=0A=
> >       init_waitqueue_head(&bitmap->overflow_wait);=0A=
> > @@ -2143,6 +2223,8 @@ int md_bitmap_resize(struct bitmap *bitmap,=0A=
> > sector_t blocks, int ret =3D 0;=0A=
> >       long pages;=0A=
> >       struct bitmap_page *new_bp;=0A=
> > +     spinlock_t *new_bmclocks;=0A=
> > +     int num_bmclocks, i;=0A=
> >=0A=
> >       if (bitmap->storage.file && !init) {=0A=
> >               pr_info("md: cannot resize file-based bitmap\n");=0A=
> > @@ -2211,7 +2293,7 @@ int md_bitmap_resize(struct bitmap *bitmap,=0A=
> > sector_t blocks, memcpy(page_address(store.sb_page),=0A=
> >                      page_address(bitmap->storage.sb_page),=0A=
> >                      sizeof(bitmap_super_t));=0A=
> > -     spin_lock_irq(&bitmap->counts.lock);=0A=
> > +     write_lock_irq(&bitmap->counts.mlock);=0A=
> >       md_bitmap_file_unmap(&bitmap->storage);=0A=
> >       bitmap->storage =3D store;=0A=
> >=0A=
> > @@ -2227,18 +2309,28 @@ int md_bitmap_resize(struct bitmap *bitmap,=0A=
> > sector_t blocks, blocks =3D min(old_counts.chunks <<=0A=
> > old_counts.chunkshift, chunks << chunkshift);=0A=
> >=0A=
> > +     /* initialize bmc locks */=0A=
> > +     num_bmclocks =3D DIV_ROUND_UP(chunks,=0A=
> > BITMAP_COUNTER_LOCK_RATIO); +=0A=
> > +     new_bmclocks =3D kvcalloc(num_bmclocks, sizeof(*new_bmclocks),=0A=
> > GFP_KERNEL);=0A=
> > +     bitmap->counts.bmclocks =3D new_bmclocks;=0A=
> > +     for (i =3D 0; i < num_bmclocks; ++i) {=0A=
> > +             spinlock_t *bmclock =3D &(bitmap->counts.bmclocks)[i];=0A=
> > +=0A=
> > +             spin_lock_init(bmclock);=0A=
> > +     }=0A=
> > +=0A=
> >       /* For cluster raid, need to pre-allocate bitmap */=0A=
> >       if (mddev_is_clustered(bitmap->mddev)) {=0A=
> >               unsigned long page;=0A=
> >               for (page =3D 0; page < pages; page++) {=0A=
> > -                     ret =3D md_bitmap_checkpage(&bitmap->counts,=0A=
> > page, 1, 1);=0A=
> > +                     ret =3D md_bitmap_checkpage(&bitmap->counts,=0A=
> > page, 1, 1, 0, 0); if (ret) {=0A=
> >                               unsigned long k;=0A=
> >=0A=
> >                               /* deallocate the page memory */=0A=
> > -                             for (k =3D 0; k < page; k++) {=0A=
> > +                             for (k =3D 0; k < page; k++)=0A=
> >                                       kfree(new_bp[k].map);=0A=
> > -                             }=0A=
> >                               kfree(new_bp);=0A=
> >=0A=
> >                               /* restore some fields from=0A=
> > old_counts */ @@ -2261,11 +2353,12 @@ int md_bitmap_resize(struct=0A=
> > bitmap *bitmap, sector_t blocks, bitmap_counter_t *bmc_old, *bmc_new;=
=0A=
> >               int set;=0A=
> >=0A=
> > -             bmc_old =3D md_bitmap_get_counter(&old_counts, block,=0A=
> > &old_blocks, 0);=0A=
> > +             bmc_old =3D md_bitmap_get_counter(&old_counts, block,=0A=
> > &old_blocks, 0, 0, 0); set =3D bmc_old && NEEDED(*bmc_old);=0A=
> >=0A=
> >               if (set) {=0A=
> > -                     bmc_new =3D=0A=
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks, 1);=0A=
> > +                     bmc_new =3D=0A=
> > md_bitmap_get_counter(&bitmap->counts, block, &new_blocks,=0A=
> > +=0A=
> >               1, 0, 0); if (bmc_new) {=0A=
> >                               if (*bmc_new =3D=3D 0) {=0A=
> >                                       /* need to set on-disk bits=0A=
> > too. */ @@ -2301,7 +2394,7 @@ int md_bitmap_resize(struct bitmap=0A=
> > *bitmap, sector_t blocks, int i;=0A=
> >               while (block < (chunks << chunkshift)) {=0A=
> >                       bitmap_counter_t *bmc;=0A=
> > -                     bmc =3D md_bitmap_get_counter(&bitmap->counts,=0A=
> > block, &new_blocks, 1);=0A=
> > +                     bmc =3D md_bitmap_get_counter(&bitmap->counts,=0A=
> > block, &new_blocks, 1, 0, 0); if (bmc) {=0A=
> >                               /* new space.  It needs to be=0A=
> > resynced, so=0A=
> >                                * we set NEEDED_MASK.=0A=
> > @@ -2317,7 +2410,7 @@ int md_bitmap_resize(struct bitmap *bitmap,=0A=
> > sector_t blocks, for (i =3D 0; i < bitmap->storage.file_pages; i++)=0A=
> >                       set_page_attr(bitmap, i, BITMAP_PAGE_DIRTY);=0A=
> >       }=0A=
> > -     spin_unlock_irq(&bitmap->counts.lock);=0A=
> > +     write_unlock_irq(&bitmap->counts.mlock);=0A=
> >=0A=
> >       if (!init) {=0A=
> >               md_bitmap_unplug(bitmap);=0A=
> > diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h=0A=
> > index bb9eb418780a..1b9c36bb73ed 100644=0A=
> > --- a/drivers/md/md-bitmap.h=0A=
> > +++ b/drivers/md/md-bitmap.h=0A=
> > @@ -2,7 +2,9 @@=0A=
> >  /*=0A=
> >   * bitmap.h: Copyright (C) Peter T. Breuer (ptb@ot.uc3m.es) 2003=0A=
> >   *=0A=
> > - * additions: Copyright (C) 2003-2004, Paul Clements, SteelEye=0A=
> > Technology, Inc.=0A=
> > + * additions:=0A=
> > + *           Copyright (C) 2003-2004, Paul Clements, SteelEye=0A=
> > Technology, Inc.=0A=
> > + *           Copyright (C) 2022-2023, Shushu Yi=0A=
> > (firnyee@gmail.com) */=0A=
> >  #ifndef BITMAP_H=0A=
> >  #define BITMAP_H 1=0A=
> > @@ -103,6 +105,9 @@ typedef __u16 bitmap_counter_t;=0A=
> >  #define PAGE_COUNTER_MASK  (PAGE_COUNTER_RATIO - 1)=0A=
> >=0A=
> >  #define BITMAP_BLOCK_SHIFT 9=0A=
> > +/* how many counters share the same bmclock? */=0A=
> > +#define BITMAP_COUNTER_LOCK_RATIO_SHIFT 0=0A=
> > +#define BITMAP_COUNTER_LOCK_RATIO (1 <<=0A=
> > BITMAP_COUNTER_LOCK_RATIO_SHIFT)=0A=
> >  #endif=0A=
> >=0A=
> > @@ -116,7 +121,7 @@ typedef __u16 bitmap_counter_t;=0A=
> >  enum bitmap_state {=0A=
> >       BITMAP_STALE       =3D 1,  /* the bitmap file is out of=0A=
> > date or had -EIO */ BITMAP_WRITE_ERROR =3D 2, /* A write error has=0A=
> > occurred */=0A=
> > -     BITMAP_HOSTENDIAN  =3D15,=0A=
> > +     BITMAP_HOSTENDIAN  =3D 15,=0A=
> >  };=0A=
> >=0A=
> >  /* the superblock at the front of the bitmap file -- little endian */=
=0A=
> > @@ -180,7 +185,8 @@ struct bitmap_page {=0A=
> >  struct bitmap {=0A=
> >=0A=
> >       struct bitmap_counts {=0A=
> > -             spinlock_t lock;=0A=
> > +             rwlock_t mlock;                         /*=0A=
> > lock for metadata */=0A=
> > +             spinlock_t *bmclocks;           /* locks for=0A=
> > bmc */ struct bitmap_page *bp;=0A=
> >               unsigned long pages;            /* total number=0A=
> > of pages=0A=
> >                                                * in the bitmap */=0A=
=0A=

From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4] md/r5cache: handle alloc_page failure
Date: Thu, 24 Nov 2016 06:44:28 +0000
Message-ID: <9AD662B3-E1D4-43A7-B825-73360663663E@fb.com>
References: <20161124051404.1969242-1-songliubraving@fb.com>
 <87y4099z9i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87y4099z9i.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <CA100568C12F0F479CF72FADF30F1AFC@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Nov 23, 2016, at 10:18 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Thu, Nov 24 2016, Song Liu wrote:
>=20
>> +void r5c_use_extra_page(struct stripe_head *sh)
>> +{
>> +	struct r5conf *conf =3D sh->raid_conf;
>> +	int i;
>> +	struct r5dev *dev;
>> +	struct page *p;
>> +
>> +	for (i =3D sh->disks; i--; ) {
>> +		dev =3D &sh->dev[i];
>> +		if (dev->orig_page !=3D dev->page) {
>> +			p =3D dev->orig_page;
>> +			dev->orig_page =3D dev->page;
>> 			put_page(p);
>> 		}
>> +		dev->orig_page =3D conf->disks[i].extra_page;
>=20
> It seems a bit pointless to assign to dev->orig_page twice.
> Why not:
>=20
>  if (dev->orig_page !=3D dev->page)
>      put_page(dev->orig_page);
>  dev->orig_page =3D conf->......
>=20
> ??
>=20
>> @@ -2255,8 +2258,27 @@ static int resize_stripes(struct r5conf *conf, in=
t newsize)
>> 	if (ndisks) {
>> 		for (i=3D0; i<conf->raid_disks; i++)
>> 			ndisks[i] =3D conf->disks[i];
>> -		kfree(conf->disks);
>> -		conf->disks =3D ndisks;
>> +
>> +		/* allocate extra_page for ndisks */
>> +		for (i =3D 0; i < newsize; i++) {
>> +			ndisks[i].extra_page =3D alloc_page(GFP_NOIO);
>> +			if (!ndisks[i].extra_page)
>> +				err =3D -ENOMEM;
>> +		}
>> +
>> +		if (err) {
>> +			/* if any error, free extra_page for ndisks */
>> +			for (i =3D 0; i < newsize; i++)
>> +				if (ndisks[i].extra_page)
>> +					put_page(ndisks[i].extra_page);
>> +			kfree(ndisks);
>> +		} else {
>> +			/* if no error, free extra_page for old disks */
>> +			for (i =3D 0; i < conf->previous_raid_disks; i++)
>> +				put_page(ndisks[i].extra_page);
>> +			kfree(conf->disks);
>> +			conf->disks =3D ndisks;
>> +		}
>=20
> This looks a bit odd too.  We never reduce conf->pool_size, so we never
> need to free anything.
>=20
> for (i =3D conf->pool_size; i < newsize; i++)
>     if ((ndisks[i].extra_page =3D alloc_page(GFP_NOIO)) =3D=3D NULL)
>         err =3D -ENOMEM;
> for (i =3D conf->pool_size; err =3D=3D -ENOMEM && i < newsize; i++)
>     if (ndisks[i].extra_page)
>         put_page(ndisks[i].extra_page);
>=20
>=20
> Maybe that it a little terse, but something like that would be better I
> think.
> Certainly you don't need to free ndisks.  If the allocation succeeds,
> just use the new array whether other allocations succeed or fail.
>=20
>> @@ -6466,6 +6515,12 @@ static void free_conf(struct r5conf *conf)
>> 	free_thread_groups(conf);
>> 	shrink_stripes(conf);
>> 	raid5_free_percpu(conf);
>> +	for (i =3D 0; i < conf->raid_disks; i++)
>> +		if (conf->disks[i].extra_page) {
>> +			put_page(conf->disks[i].extra_page);
>> +			conf->disks[i].extra_page =3D NULL;
>=20
> There is no point setting extra_page to NULL, as the whole array is
> freed on the next line.
>=20
>=20
> Apart from those few little things, it looks good.  Thanks.
>=20
> NeilBrown

Thanks for these feedback! New patch coming. =20

Song=

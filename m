From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v5 4/8] md/r5cache: write part of r5cache
Date: Fri, 21 Oct 2016 20:42:08 +0000
Message-ID: <91067ABE-F658-4C6E-8856-8D32ADD986B5@fb.com>
References: <20161013054944.1038806-1-songliubraving@fb.com>
 <20161013054944.1038806-5-songliubraving@fb.com>
 <87lgxrzaja.fsf@notabene.neil.brown.name>
 <00D21118-73D2-42D1-8062-D468D0C134B4@fb.com>
 <87r37dxipq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r37dxipq.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <219E04D3662D0541B2268CED8333E1B1@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 18, 2016, at 5:53 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Fri, Oct 14 2016, Song Liu wrote:
>=20
>>> On Oct 1st of the work.=20
>>=20
>> Or we can force the code to rcw, which does not need extra page.=20
>> But rcw, does not always work in degraded mode. So, this is a good=20
>> reason not to do write-back in degraded mode...
>=20
> Prohibiting write-back in degraded mode would not be enough to ensure
> that you can always use rcw.  The array can become degraded after you
> make the decision to use caching, and before to need to read old data
> for rmw.
>=20
> I would suggest a small (2 entry?) mempool where each entry in the
> mempool holds enough pages to complete an rmw.  Only use the mempool if
> an alloc_page() fails.
>=20
This is a great idea. I will try it.=20


>>>=20
>>>> +
>>>> +void r5c_handle_cached_data_endio(struct r5conf *conf,
>>>> +	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
>>>> +{
>>>> +	int i;
>>>> +
>>>> +	for (i =3D sh->disks; i--; ) {
>>>> +		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
>>>> +		    sh->dev[i].written) {
>>>=20
>>> Is it possible for R5_InCache to be set, but 'written' to be NULL ???
>>=20
>> Yes, it is possible. A stripe may go through "write data to journal, ret=
urn IO" multiple
>> times before parity calculation. When it comes here the second time, dev=
 written in the=20
>> first time will have R5_InCache set, but its written will be NULL.=20
>=20
> OK, that makes sense.
> So is it possible for 'written' to be set, but R5_InCache to be clear?
> i.e. do we really need to test R5_InCache here?

In current implementation, there is only one log_io per sh, so we should be=
 fine just check=20
'written'. Let me double check.=20

>=20
>>>>=20
>>>> static void r5l_io_run_stripes(struct r5l_io_unit *io)
>>>> @@ -483,7 +566,8 @@ static int r5l_log_stripe(struct r5l_log *log, str=
uct stripe_head *sh,
>>>> 	io =3D log->current_io;
>>>>=20
>>>> 	for (i =3D 0; i < sh->disks; i++) {
>>>> -		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
>>>> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
>>>> +		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
>>>> 			continue;
>>>=20
>>> If changed R5_Wantcache to R5_Wantjournal, and always set it on blocks
>>> that were destined for the journal, then this would just be
>>>=20
>>> 		if (!test_bit(R5_Wantjournal, &sh->dev[i].flags))
>>>=20
>>> which would make lots of sense...  Just a thought.
>>=20
>> We set R5_Wantwrite in multiple places. If we simplify the code here, we=
 will need to make
>> those places aware of journal. I guess that is not ideal either?=20
>=20
> Maybe...
> We have so many state flags that I like to be very cautious about adding
> more, and to make sure they have a very well defined meaning that
> doesn't overlap with other flags too much.
> The above code suggests that Wantwrite and Wantcache overlap to some
> extent.
>=20
> Could we discard Wantcache and just use Wantwrite combined with InCache?
> Wantwrite means that the block needed to be written to the RAID.
> If InCache isn't set, it also needs to be written to the cache (if the
> cache is being used).
> Then the above code would be
>   if (!test_bit(R5_Wantwrite) || test_bit(R5_InCache))
>      continue;
>=20
> which means "if we don't want to write this, or if it is already in the
> cache, then nothing to do here".
>=20
> Maybe.

I am not sure whether we can totally remove Wantcache. Let me try it.=20

Thanks,
Song=

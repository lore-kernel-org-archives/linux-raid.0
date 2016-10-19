From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v5 4/8] md/r5cache: write part of r5cache
Date: Wed, 19 Oct 2016 11:53:21 +1100
Message-ID: <87r37dxipq.fsf@notabene.neil.brown.name>
References: <20161013054944.1038806-1-songliubraving@fb.com> <20161013054944.1038806-5-songliubraving@fb.com> <87lgxrzaja.fsf@notabene.neil.brown.name> <00D21118-73D2-42D1-8062-D468D0C134B4@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00D21118-73D2-42D1-8062-D468D0C134B4@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14 2016, Song Liu wrote:

>> On Oct 13, 2016, at 11:53 PM, NeilBrown <neilb@suse.com> wrote:
>>=20
>> On Thu, Oct 13 2016, Song Liu wrote:
>>>=20
>>> For RMW, the code allocates an extra page for each data block
>>> being updated.  This is stored in r5dev->page and the old data
>>> is read into it.  Then the prexor calculation subtracts ->page
>>> from the parity block, and the reconstruct calculation adds the
>>> ->orig_page data back into the parity block.
>>=20
>> What happens if the alloc_page() fails?
>
> That will be tough, but solvable.. We can
>     read old data to page
>     do prexor=20
>     read new data from journal device to page
>     do xor=20
>     do the rest of the work.=20
>
> Or we can force the code to rcw, which does not need extra page.=20
> But rcw, does not always work in degraded mode. So, this is a good=20
> reason not to do write-back in degraded mode...

Prohibiting write-back in degraded mode would not be enough to ensure
that you can always use rcw.  The array can become degraded after you
make the decision to use caching, and before to need to read old data
for rmw.

I would suggest a small (2 entry?) mempool where each entry in the
mempool holds enough pages to complete an rmw.  Only use the mempool if
an alloc_page() fails.

>>=20
>>> +
>>> +void r5c_handle_cached_data_endio(struct r5conf *conf,
>>> +	  struct stripe_head *sh, int disks, struct bio_list *return_bi)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i =3D sh->disks; i--; ) {
>>> +		if (test_bit(R5_InCache, &sh->dev[i].flags) &&
>>> +		    sh->dev[i].written) {
>>=20
>> Is it possible for R5_InCache to be set, but 'written' to be NULL ???
>
> Yes, it is possible. A stripe may go through "write data to journal, retu=
rn IO" multiple
> times before parity calculation. When it comes here the second time, dev =
written in the=20
> first time will have R5_InCache set, but its written will be NULL.=20

OK, that makes sense.
So is it possible for 'written' to be set, but R5_InCache to be clear?
i.e. do we really need to test R5_InCache here?

>>>=20
>>> static void r5l_io_run_stripes(struct r5l_io_unit *io)
>>> @@ -483,7 +566,8 @@ static int r5l_log_stripe(struct r5l_log *log, stru=
ct stripe_head *sh,
>>> 	io =3D log->current_io;
>>>=20
>>> 	for (i =3D 0; i < sh->disks; i++) {
>>> -		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags))
>>> +		if (!test_bit(R5_Wantwrite, &sh->dev[i].flags) &&
>>> +		    !test_bit(R5_Wantcache, &sh->dev[i].flags))
>>> 			continue;
>>=20
>> If changed R5_Wantcache to R5_Wantjournal, and always set it on blocks
>> that were destined for the journal, then this would just be
>>=20
>> 		if (!test_bit(R5_Wantjournal, &sh->dev[i].flags))
>>=20
>> which would make lots of sense...  Just a thought.
>
> We set R5_Wantwrite in multiple places. If we simplify the code here, we =
will need to make
> those places aware of journal. I guess that is not ideal either?=20

Maybe...
We have so many state flags that I like to be very cautious about adding
more, and to make sure they have a very well defined meaning that
doesn't overlap with other flags too much.
The above code suggests that Wantwrite and Wantcache overlap to some
extent.

Could we discard Wantcache and just use Wantwrite combined with InCache?
Wantwrite means that the block needed to be written to the RAID.
If InCache isn't set, it also needs to be written to the cache (if the
cache is being used).
Then the above code would be
   if (!test_bit(R5_Wantwrite) || test_bit(R5_InCache))
      continue;

which means "if we don't want to write this, or if it is already in the
cache, then nothing to do here".

Maybe.

>
>=20=20
>>=20
>>> }
>>>=20
>>> -static void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>>> +void r5l_wake_reclaim(struct r5l_log *log, sector_t space)
>>=20
>> Why are you removing the 'static' here?  You don't call it from any
>> other file.
>
> In next patch, it is called in raid.c.

So remove 'static' in the next patch please.


Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYBsQBAAoJEDnsnt1WYoG5XgIQAJd/kOTLOB7pGbZvdAJm7mCx
84EFyZmZcVavOS7+IOYMHzC4WjmL19MpFK3C5fBA4XPbVS9h5g73VYquLXVn20Ek
FUA/rtTSZcFh6ufFSmCI0HyTZ945EDgO204KxjfOqxE7DgxdFrEA2J+7eOtHDfPf
0buZ1OVL5sMRdg8gHIm6Zt9lvWRgaX5awl4TOoF4dlGU/aDAu0/8glbxGq8PMrk6
ZKkpVhKPN2tHJV7DpZPKCQKNM/8ddcApK+OBJdaY8hnqChD9H1OwNTNF64X8MSnv
sx511U98N+0DkIQ4RhPIG1xZaTQdx4sQ03/g54DSAYsEcTmEJlchGxrOM2mmPhCl
FSjk5Chww9rSsrI/HIRQy+PCP8OzKGdHkzWXF/ynxheY3ffkVUrhNMxM76VAs3cm
dAdMYPK2XG0DE/abAusBLVOe6dc3M69wA7CqMy0raujsIYxZSPpHYe7v1F/H6QvX
DU/fQiyQvMF3sRddhUt3MDvSXMfXYwvZ5mEjxnp/RsCPezJ6AfdqPgwLDgi/xlbh
Nyj6yyCOEaestrTC4NPUXnJgPQGu8MrrQwARGUlaf6eGJw3eYT+NEXfeKGeF6Sy8
5rX+qPm+wfUmFJQny1Uc/1TyN8UW5gGczoQuPjKVUNzyhehjmdfa546pMOzFQA56
J99lHp/UCIjJGEKDBesB
=q5Gu
-----END PGP SIGNATURE-----
--=-=-=--

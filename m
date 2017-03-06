From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 3/3] md/raid5: sort bios
Date: Mon, 06 Mar 2017 17:40:16 +1100
Message-ID: <87bmtekiwf.fsf@notabene.neil.brown.name>
References: <cover.1487373517.git.shli@fb.com> <01c6067566d787a815fc29aa07b36ad4dd0280f0.1487373517.git.shli@fb.com> <87k287m3d6.fsf@notabene.neil.brown.name> <20170303175909.q2t2hoxsorjhk77k@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170303175909.q2t2hoxsorjhk77k@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, kernel-team@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 03 2017, Shaohua Li wrote:

> On Fri, Mar 03, 2017 at 02:43:49PM +1100, Neil Brown wrote:
>> On Fri, Feb 17 2017, Shaohua Li wrote:
>>=20
>> > Previous patch (raid5: only dispatch IO from raid5d for harddisk raid)
>> > defers IO dispatching. The goal is to create better IO pattern. At that
>> > time, we don't sort the deffered IO and hope the block layer can do IO
>> > merge and sort. Now the raid5-cache writeback could create large amount
>> > of bios. And if we enable muti-thread for stripe handling, we can't
>> > control when to dispatch IO to raid disks. In a lot of time, we are
>> > dispatching IO which block layer can't do merge effectively.
>> >
>> > This patch moves further for the IO dispatching defer. We accumulate
>> > bios, but we don't dispatch all the bios after a threshold is met. This
>> > 'dispatch partial portion of bios' stragety allows bios coming in a
>> > large time window are sent to disks together. At the dispatching time,
>> > there is large chance the block layer can merge the bios. To make this
>> > more effective, we dispatch IO in ascending order. This increases
>> > request merge chance and reduces disk seek.
>>=20
>> I can see the benefit of batching and sorting requests.
>>=20
>> I wonder if the extra complexity of grouping together 512 requests, then
>> submitting the "first" 128 is really worth it.  Have you measured the
>> value of that?
>
> I'm pretty sure I tried. The whole point of dispatching the first 128 is =
we
> don't have a better pipeline. Grouping 512 and then dispatching them toge=
ther
> definitely improve the IO patter, but the request accumulation takes time=
, we
> will have no IO running in the window.

But we don't wait for the first batch before we start collecting the
next batch - do we?  Why would there be a window with no IO running?


>
>> If you just submitted every time you got 512 requests, you could use
>> list_sort() on the bio list and wouldn't need an array.
>>=20
>> If an array really is best, it would be really nice if "sort" could pass
>> a 'void*' down to the cmp function,
>> and it could sort all bios that are
>> *after* last_bio_pos first, and then the others.  That would make the
>> code much simpler.  I guess sort() could be changed (list_sort() already
>> has a 'priv' argument like this).
>
> Ok, I'll change this to a list. And add extra pointer to record the last =
sorted
> entry. I didn't see the sort uses much time in my profile, but the merge =
sort
> looks better. Will do the change.

I think both sorts are O(log(N)).
I had thought that list_sort() would work on a bio_list, but it requires
a list_head (even though it doesn't use the prev pointer).
If it worked on a bio_list and if you could just submit the whole batch,
then using list_sort would have meant that you don't need to allocate a
table of r5pending_data.
Now with the struct list_head in there, the data is twice the size.

I guess that doesn't matter too much.

It just feels like there should be a cleaner solution, but I cannot find
it without writing a new sort function (not that it would be so hard do
to that).

Thanks,
NeilBrown


>
>> If we cannot change sort(), then maybe use lib/bsearch.c for the binary
>> search.  Performing two comparisons in the loop of a binary search
>> should get a *fail* in any algorithms class!!
>> The "pending_data" array that you have added to the r5conf structure
>> adds 4096 bytes.  This means it is larger than a page, which is best
>> avoided (though it is unlikely to cause problems).  I would allocate it
>> separately.
>
> Yep, already fixed internally.
>
>>=20
>> So there is a lot that I don't really like, but it seems like a good
>> idea in principle.
>
> ok, thanks for your time!
>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli9BFAACgkQOeye3VZi
gbko9RAAv9s0rSkGsHBHnNRZ5X31wZnvZMfgKdO0TAxrWdufMFnNA8DqVJTzy3LU
G3jhZa+jKa6eZ4PlX8Ra4gxG+1ik+GJfG5mSJf0i9IrWKUhK4h+3Avan9ODayMz+
yeZ4+JwePOSTwwA5YUjVKpEJtuMKhOJ4ujya+MbVkoO4ofENGWe35DwKytQscMA7
dIB2Y6nENi4WCP+fJj+uZKFod+SD8tBpOAqPHGVcWrZmDGy7qRDVTvPHyH155h0x
nyaw2A+PB/d+xpkTTd9oocRcHEdBkZs6aLvC2JAmeRcI5R3VvQmj+yRHRqZwmLso
mG+F9QXcg/6zR1/IzXwWYkUx71O0q1WEh6mxjvmcdbHDDgTMVKeCDCqUlHVjI+Uf
yIpm90TAL4Vu5PdZwYrL5dUinlUaIBE0OhEVgVpN8+2vfREKEhSUEBJkY0S8uRkQ
C1O0zRTfjrCWRsiMeOdK5lIK5FH/tVHZUNIw20WGJXGVG8DmAzRvLaZENejyB+lr
oTs0JagEW5M8t6ALddQC1gidy3rSFtrNg3xeG2aLmLXbVHkgajkw4HIi8rQcBWLM
3ojiPkKJ0OTr58uwBdhe6Cu9MsLYHQ7IlHjNZaR8LqBHfapbUTAHS6VUq+1l8Uuf
u4wKol+uQCim2GQiY0BUdmcp3PASfU/Xs5aG3d3Orgae+XpbITM=
=IyQp
-----END PGP SIGNATURE-----
--=-=-=--

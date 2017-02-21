From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Tue, 21 Feb 2017 11:29:59 +1100
Message-ID: <878tp0s7w8.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de> <87shn9spsy.fsf@notabene.neil.brown.name> <87k28lshg5.fsf@notabene.neil.brown.name> <20170220070430.4mca7clpaw7kpj4j@kernel.org> <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7178ADEA-6263-4FB0-95A5-96E5F71A9740@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20 2017, Coly Li wrote:

> =E5=8F=91=E8=87=AA=E6=88=91=E7=9A=84 iPhone
>> =E5=9C=A8 2017=E5=B9=B42=E6=9C=8820=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=883=
:04=EF=BC=8CShaohua Li <shli@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>>> On Mon, Feb 20, 2017 at 01:51:22PM +1100, Neil Brown wrote:
>>>> On Mon, Feb 20 2017, NeilBrown wrote:
>>>>=20
>>>>> On Fri, Feb 17 2017, Coly Li wrote:
>>>>>=20
>>>>>> On 2017/2/16 =E4=B8=8B=E5=8D=883:04, NeilBrown wrote:
>>>>>> I know you are going to change this as Shaohua wantsthe spitting to
>>>>>> happen in a separate function, which I agree with, but there is=20
>>>>>> something else wrong here. Calling bio_split/bio_chain repeatedly
>>>>>> in a loop is dangerous. It is OK for simple devices, but when one
>>>>>> request can wait for another request to the same device it can
>>>>>> deadlock. This can happen with raid1.  If a resync request calls
>>>>>> raise_barrier() between one request and the next, then the next has
>>>>>> to wait for the resync request, which has to wait for the first
>>>>>> request. As the first request will be stuck in the queue in=20
>>>>>> generic_make_request(), you get a deadlock.
>>>>>=20
>>>>> For md raid1, queue in generic_make_request(), can I understand it as
>>>>> bio_list_on_stack in this function? And queue in underlying device,
>>>>> can I understand it as the data structures like plug->pending and
>>>>> conf->pending_bio_list ?
>>>>=20
>>>> Yes, the queue in generic_make_request() is the bio_list_on_stack.  Th=
at
>>>> is the only queue I am talking about.  I'm not referring to
>>>> plug->pending or conf->pending_bio_list at all.
>>>>=20
>>>>>=20
>>>>> I still don't get the point of deadlock, let me try to explain why I
>>>>> don't see the possible deadlock. If a bio is split, and the first part
>>>>> is processed by make_request_fn(), and then a resync comes and it will
>>>>> raise a barrier, there are 3 possible conditions,
>>>>> - the resync I/O tries to raise barrier on same bucket of the first
>>>>> regular bio. Then the resync task has to wait to the first bio drops
>>>>> its conf->nr_pending[idx]
>>>>=20
>>>> Not quite.
>>>> First, the resync task (in raise_barrier()) will wait for ->nr_waiting=
[idx]
>>>> to be zero.  We can assume this happens immediately.
>>>> Then the resync_task will increment ->barrier[idx].
>>>> Only then will it wait for the first bio to drop ->nr_pending[idx].
>>>> The processing of that first bio will have submitted bios to the
>>>> underlying device, and they will be in the bio_list_on_stack queue, and
>>>> will not be processed until raid1_make_request() completes.
>>>>=20
>>>> The loop in raid1_make_request() will then call make_request_fn() which
>>>> will call wait_barrier(), which will wait for ->barrier[idx] to be
>>>> zero.
>>>=20
>>> Thinking more carefully about this.. the 'idx' that the second bio will
>>> wait for will normally be different, so there won't be a deadlock after
>>> all.
>>>=20
>>> However it is possible for hash_long() to produce the same idx for two
>>> consecutive barrier_units so there is still the possibility of a
>>> deadlock, though it isn't as likely as I thought at first.
>>=20
>> Wrapped the function pointer issue Neil pointed out into Coly's original=
 patch.
>> Also fix a 'use-after-free' bug. For the deadlock issue, I'll add below =
patch,
>> please check.
>>=20
>> Thanks,
>> Shaohua
>>=20
>
> Hmm, please hold, I am still thinking of it. With barrier bucket and
> hash_long(), I don't see dead lock yet. For raid10 it might happen,
> but once we have barrier bucket on it , there will no deadlock.
>
> My question is, this deadlock only happens when a big bio is split,
> and the split small bios are continuous, and the resync io visiting
> barrier buckets in sequntial order too. In the case if adjacent split
> regular bios or resync bios hit same barrier bucket, it will be a very
> big failure of hash design, and should have been found already. But no
> one complain it, so I don't convince myself tje deadlock is real with
> io barrier buckets (this is what Neil concerns).

I think you are wrong about the design goal of a hash function.
When feed a sequence of inputs, with any stride (i.e. with any constant
difference between consecutive inputs), the output of the hash function
should appear to be random.
A random sequence can produce the same number twice in a row.
If the hash function produces a number from 0 to N-1, you would expect
two consecutive outputs to be the same about once every N inputs.

Even if there was no possibility of a deadlock from a resync request
happening between two bios, there are other possibilities.

It is not, in general, safe to call mempool_alloc() twice in a row,
without first ensuring that the first allocation will get freed by some
other thread.  raid1_write_request() allocates from r1bio_pool, and then
submits bios to the underlying device, which get queued on
bio_list_on_stack.  They will not be processed until after
raid1_make_request() completes, so when raid1_make_request loops around
and calls raid1_write_request() again, it will try to allocate another
r1bio from r1bio_pool, and this might end up waiting for the r1bio which
is trapped and cannot complete.

As r1bio_pool preallocates 256 entries, this is unlikely  but not
impossible.  If 256 threads all attempt a write (or read) that crosses a
boundary, then they will consume all 256 preallocated entries, and want
more. If there is no free memory, they will block indefinitely.

bio_alloc_bioset() has punt_bios_to_rescuer() to attempt to work around
a deadlock very similar to this, but it is a very specific solution,
wouldn't help raid1, and is much more complex than just rearranging the
code.


>
> For the function pointer asignment, it is because I see a brach
> happens in a loop. If I use a function pointer, I can avoid redundant
> brach inside the loop. raid1_read_request() and raid1_write_request()
> are not simple functions, I don't know whether gcc may make them
> inline or not, so I am on the way to check the disassembled code..

It is a long time since I studied how CPUs handle different sorts of
machine code, but I'm fairly sure that and indirect branch (i.e. a
branch through a function pointer) is harder to optimize than a
conditional branch.

But I think the readability of the code is more important, and having an
if-then-else in a loop is more familiar to most readers than using a
function pointer like this.

>
> The loop in raid1_make_request() is quite high level, I am not sure
> whether CPU brach pridiction may work correctly, especially when it is
> a big DISCARD bio, using function pointer may drop a possible brach.
>
> So I need to check what we get and lose when use function pointer or
> not. If it is not urgent, please hold this patch for a while.=20
>
> The only thing I worry in the bellowed patch is, if a very big DISCARD
> bio comes, will the kernel space stack trend to be overflow=EF=BC=9F

How would a large request cause extra stack space to be used?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlirigcACgkQOeye3VZi
gbklLw/9GAdUQXi1FSXhLF84O2NlKKSbrjEf2Ue419JPc8ippIdbs9FyxFBA53yv
LnSwE/f27liF5jVrp+JcukkBr1AUL6482YROp6c9nRVXFmUEGwnfpJvGYDSbriv0
3syvRjznBKijBMMXy8dObcAD07F+Rnl1Z7EYrw9rKF16tpFRxBKeBZ5MqXKiNRR5
xDYQ4wKFZicbulyj/Igo+abSmFI3/95If3QBlZ/B9bRX79kccyCaSiEN42WuMIEe
TcVq2NBlPymu81qs5YWehDOEn09iaaKM/hyXWOF/pzyWi7mRiTqT7pCGkonWEkXL
JSKzOuqAlpIj0vBl/zm23rqGfjtK4/EBCZQE8PYXco4OnWJdIHK9DazJJRx8fjFj
D01rIsxbBzK5PJ801BxfJaFhaCdXbWEjFULU/xXbcSAIkQUanksOxcIbeCK032Pf
HpAWBxiwg072JVkq9psdZEis0PK6C2A33vVdlbR05qmrfwZ3njQk1vTIxpH0udSg
tZKuSzViWRLEOHIZZ1ztMX8p3kyDken1YVjDVM3zfRzgi3bxP3500clv+6RvHBws
VAQW0qZXE2txgket4tztkPsg2h3gW4KY0k2hzplbPJpSGJxG9rgWNegkUBamHO7M
+CqGAmO3B45NQQvRnHv9p/VbcWMXG+ou78aV8CkUbFsORoro31c=
=0xll
-----END PGP SIGNATURE-----
--=-=-=--

From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Mon, 20 Feb 2017 13:51:22 +1100
Message-ID: <87k28lshg5.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de> <87shn9spsy.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shn9spsy.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 20 2017, NeilBrown wrote:

> On Fri, Feb 17 2017, Coly Li wrote:
>
>> On 2017/2/16 =E4=B8=8B=E5=8D=883:04, NeilBrown wrote:
>>> I know you are going to change this as Shaohua wantsthe spitting to
>>> happen in a separate function, which I agree with, but there is=20
>>> something else wrong here. Calling bio_split/bio_chain repeatedly
>>> in a loop is dangerous. It is OK for simple devices, but when one
>>> request can wait for another request to the same device it can
>>> deadlock. This can happen with raid1.  If a resync request calls
>>> raise_barrier() between one request and the next, then the next has
>>> to wait for the resync request, which has to wait for the first
>>> request. As the first request will be stuck in the queue in=20
>>> generic_make_request(), you get a deadlock.
>>
>> For md raid1, queue in generic_make_request(), can I understand it as
>> bio_list_on_stack in this function? And queue in underlying device,
>> can I understand it as the data structures like plug->pending and
>> conf->pending_bio_list ?
>
> Yes, the queue in generic_make_request() is the bio_list_on_stack.  That
> is the only queue I am talking about.  I'm not referring to
> plug->pending or conf->pending_bio_list at all.
>
>>
>> I still don't get the point of deadlock, let me try to explain why I
>> don't see the possible deadlock. If a bio is split, and the first part
>> is processed by make_request_fn(), and then a resync comes and it will
>> raise a barrier, there are 3 possible conditions,
>> - the resync I/O tries to raise barrier on same bucket of the first
>> regular bio. Then the resync task has to wait to the first bio drops
>> its conf->nr_pending[idx]
>
> Not quite.
> First, the resync task (in raise_barrier()) will wait for ->nr_waiting[id=
x]
> to be zero.  We can assume this happens immediately.
> Then the resync_task will increment ->barrier[idx].
> Only then will it wait for the first bio to drop ->nr_pending[idx].
> The processing of that first bio will have submitted bios to the
> underlying device, and they will be in the bio_list_on_stack queue, and
> will not be processed until raid1_make_request() completes.
>
> The loop in raid1_make_request() will then call make_request_fn() which
> will call wait_barrier(), which will wait for ->barrier[idx] to be
> zero.

Thinking more carefully about this.. the 'idx' that the second bio will
wait for will normally be different, so there won't be a deadlock after
all.

However it is possible for hash_long() to produce the same idx for two
consecutive barrier_units so there is still the possibility of a
deadlock, though it isn't as likely as I thought at first.

NeilBrown


>
> So raid1_make_request is waiting for the resync to progress, and resync
> is waiting for a bio which is on bio_list_on_stack which won't be
> processed until raid1_make_request() completes.
>
> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliqWaoACgkQOeye3VZi
gbldtA/9HgO0LpHR5DHExEeIoPHpe043RB6qzwMtBb/kzlOos8vq86iuBOolzVux
SKGJu5RwO1Up0Zrxn+yV0FJYAHN7+FzMUluAi72Eukhlj/p9k5VjXclvqVRxphku
eZE8nyPCA05CapYm9BcLMSyPHJp72JVH7Nbwibclb5JIuMUI53OwXuCKE8UkJK+b
3/lety3ygdodEOdv9XOgMrQadJCGK6slRR9zPMoNV77h0XCRSFM9jObXN9mmFDgM
KEAQs4eWGhwkkEtmIKduKfuwtrCn/1u2vVZPUNKvs1bO0RBa/sxU2693801uG8tw
wAbcIiXilrGINw1dDx44ucLzzaJDxT4YgDsfbHmjBHF5QE262y7buv+zh6oy5Y4T
PfEriYMVjbKUG6oNzp7zd3geqiMenU/X4mx4DcTvXHaHuIFbnODQ115sJ23BhREU
vJumBheE46/CCtrILRbR1m7PaonBgC/g7/UDmMWWAbx8O1AXik0lcNZUEES8J9zi
5mtMuSw85k8skTFe61zq4Br+ufoLqS1q2nEcXUlZ9+XmAqcMNaBmqz5Bxx1GbB1M
N+oW0Bk75E4FzMNMNi9IdaxwcWk+ZKLCPkjSInAjKsziOrxgbE+xHfziN8iW5lMV
HrKZpv8K7Bp94jlYuc5sqUIw91xcuv7CYvZI80qM1oUgyRkGjPQ=
=QwVl
-----END PGP SIGNATURE-----
--=-=-=--

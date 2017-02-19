From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V3 1/2] RAID1: a new I/O barrier implementation to remove resync window
Date: Mon, 20 Feb 2017 10:50:53 +1100
Message-ID: <87shn9spsy.fsf@notabene.neil.brown.name>
References: <1487176523-109075-1-git-send-email-colyli@suse.de> <87shnevcpr.fsf@notabene.neil.brown.name> <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2f6b3d68-1536-3167-7362-78fdfa91e149@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Coly Li <colyli@suse.de>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Johannes Thumshirn <jthumshirn@suse.de>, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17 2017, Coly Li wrote:

> On 2017/2/16 =E4=B8=8B=E5=8D=883:04, NeilBrown wrote:
>> I know you are going to change this as Shaohua wantsthe spitting to
>> happen in a separate function, which I agree with, but there is=20
>> something else wrong here. Calling bio_split/bio_chain repeatedly
>> in a loop is dangerous. It is OK for simple devices, but when one
>> request can wait for another request to the same device it can
>> deadlock. This can happen with raid1.  If a resync request calls
>> raise_barrier() between one request and the next, then the next has
>> to wait for the resync request, which has to wait for the first
>> request. As the first request will be stuck in the queue in=20
>> generic_make_request(), you get a deadlock.
>
> For md raid1, queue in generic_make_request(), can I understand it as
> bio_list_on_stack in this function? And queue in underlying device,
> can I understand it as the data structures like plug->pending and
> conf->pending_bio_list ?

Yes, the queue in generic_make_request() is the bio_list_on_stack.  That
is the only queue I am talking about.  I'm not referring to
plug->pending or conf->pending_bio_list at all.

>
> I still don't get the point of deadlock, let me try to explain why I
> don't see the possible deadlock. If a bio is split, and the first part
> is processed by make_request_fn(), and then a resync comes and it will
> raise a barrier, there are 3 possible conditions,
> - the resync I/O tries to raise barrier on same bucket of the first
> regular bio. Then the resync task has to wait to the first bio drops
> its conf->nr_pending[idx]

Not quite.
First, the resync task (in raise_barrier()) will wait for ->nr_waiting[idx]
to be zero.  We can assume this happens immediately.
Then the resync_task will increment ->barrier[idx].
Only then will it wait for the first bio to drop ->nr_pending[idx].
The processing of that first bio will have submitted bios to the
underlying device, and they will be in the bio_list_on_stack queue, and
will not be processed until raid1_make_request() completes.

The loop in raid1_make_request() will then call make_request_fn() which
will call wait_barrier(), which will wait for ->barrier[idx] to be zero.

So raid1_make_request is waiting for the resync to progress, and resync
is waiting for a bio which is on bio_list_on_stack which won't be
processed until raid1_make_request() completes.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAliqL10ACgkQOeye3VZi
gbnpsxAAs1HwRtIUi8pdBkr77HHBasN0bj7BcIuEOg8oAQ4F2qD5bFNrUs8XG3d0
/ek4T5Pm2u8Pc4vTCRw717v4LliY5QocFIWsf6Uad5/IwL1n5EGU6ecL+m2ikVvo
FM8AtEyn9vY4gfQj07ke3jaJNansu8k/UTb7C4nWGU5xZPt6h9J8zJNnBrC0dJHj
WIcLCCRi+8mB5RabiIplqEBJyCimwpogkgTC6vmyHriRlhxVcEBCNQouxSqTEErE
X5ezYmIEj6a924qsUWSVLm7f6xjJ+xIaOF5YBKvZH8lzunluw+WhzTQn/NkPvhkF
tB1KtQlUYsiq3yeW6BZSH5fJWwUaa0ZlL53sct1VaCOxLwZSIE8XWkX81R0TJHVA
mV9oLsMJvk1GGRgeVBY7ddfkn4U3RZ7wM710n6wiVWJWruFJr7dbY6WqsohSWEK3
yxAtfp8I49yr3AGF88mTfVbrL/fPrKqIMw5x+L79HZ+GJJbFDlHWD950/bu3RzFg
9Cd9gzqWZG8myqap5emY7JACMz7Y1fVyQNR9/+ic4daGNefcOh86XbJUoIlmyNWG
KGisbAeJXiA/cR8IoXJddt9F68Md8wiKask4uqYGlPoBMpEcnBoBGqZfq7ryTX8B
8p2nnJ5/WX0hgf2bNmiBsMcpiNw3Z3Iz24uUCAOnIpt35CZ1YFM=
=Tkyt
-----END PGP SIGNATURE-----
--=-=-=--

From: NeilBrown <neilb@suse.com>
Subject: Re: [RFC PATCH] blk: reset 'bi_next' when bio is done inside request
Date: Tue, 04 Apr 2017 19:37:17 +1000
Message-ID: <871st8jyya.fsf@notabene.neil.brown.name>
References: <9505ff12-7307-7dec-76b5-2a233a592634@profitbricks.com> <877f31kwti.fsf@notabene.neil.brown.name> <9be3ca00-d802-bf64-bcdc-1e76608147f0@profitbricks.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9be3ca00-d802-bf64-bcdc-1e76608147f0@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Wang <yun.wang@profitbricks.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shli@kernel.org>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Michael Wang wrote:

> Hi, Neil
>
> On 04/03/2017 11:25 PM, NeilBrown wrote:
>> On Mon, Apr 03 2017, Michael Wang wrote:
>>=20
>>> blk_attempt_plug_merge() try to merge bio into request and chain them
>>> by 'bi_next', while after the bio is done inside request, we forgot to
>>> reset the 'bi_next'.
>>>
>>> This lead into BUG while removing all the underlying devices from md-ra=
id1,
>>> the bio once go through:
>>>
>>>   md_do_sync()
>>>     sync_request()
>>>       generic_make_request()
>>=20
>> This is a read request from the "first" device.
>>=20
>>>         blk_queue_bio()
>>>           blk_attempt_plug_merge()
>>>             CHAINED HERE
>>>
>>> will keep chained and reused by:
>>>
>>>   raid1d()
>>>     sync_request_write()
>>>       generic_make_request()
>>=20
>> This is a write request to some other device, isn't it?
>>=20
>> If sync_request_write() is using a bio that has already been used, it
>> should call bio_reset() and fill in the details again.
>> However I don't see how that would happen.
>> Can you give specific details on the situation that triggers the bug?
>
> We have storage side mapping lv through scst to server, on server side
> we assemble them into multipath device, and then assemble these dm into
> two raid1.
>
> The test is firstly do mkfs.ext4 on raid1 then start fio on it, on storage
> side we unmap all the lv (could during mkfs or fio), then on server side
> we hit the BUG (reproducible).

So I assume the initial resync is still happening at this point?
And you unmap *all* the lv's so you expect IO to fail?
I can see that the code would behave strangely if you have a
bad-block-list configured (which is the default).
Do you have a bbl?  If you create the array without the bbl, does it
still crash?

>
> The path of bio was confirmed by add tracing, it is reused in sync_reques=
t_write()
> with 'bi_next' once chained inside blk_attempt_plug_merge().

I still don't see why it is re-used.
I assume you didn't explicitly ask for a check/repair (i.e. didn't write
to .../md/sync_action at all?).  In that case MD_RECOVERY_REQUESTED is
not set.
So sync_request() sends only one bio to generic_make_request():
   r1_bio->bios[r1_bio->read_disk];

then sync_request_write() *doesn't* send that bio again, but does send
all the others.

So where does it reuse a bio?

>
> We also tried to reset the bi_next inside sync_request_write() before
> generic_make_request() which also works.
>
> The testing was done with 4.4, but we found upstream also left bi_next
> chained after done in request, thus we post this RFC.
>
> Regarding raid1, we haven't found the place on path where the bio was
> reset... where does it supposed to be?

I'm not sure what you mean.
We only reset bios when they are being reused.
One place is in process_checks() where bio_reset() is called before
filling in all the details.


Maybe, in sync_request_write(), before

	wbio->bi_rw =3D WRITE;

add something like
  if (wbio->bi_next)
     printk("bi_next!=3D NULL i=3D%d read_disk=3D%d bi_end_io=3D%pf\n",
          i, r1_bio->read_disk, wbio->bi_end_io);

that might help narrow down what is happening.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljjaU0ACgkQOeye3VZi
gbmzZBAAwqm8fRgBgGlGtBGzKrnyCP2J685kyaVVYtA0fxxLgjk7dAndNnQ/LUvh
ZHvlHO8GDU0vPdzyIJrBg842vuU0tv/ZklMnEYByFFexc0mLW7qcpIXXaKN0ErX+
QgYeykFCcY9yZo8K5EBXFn/jje8Kk3T3QZYNEhlOXrz+mbCZty2CwLRONj4QggxT
5jfCXNZYEPNVCqn8dKYabKFB1kHGELUwQiCnFDArZh3j18dlQHAhMrJeUHXr6JKh
jDNqIjBMP5mPZM4Kr8d5EuWEarBgfQ0xq6W3dscSSpIaUAuYnCYDaaBjxM5LqgIe
vF7597xaIkR4Rxn9Z/NFTTSnbQfx9ao0inROO84vvld+b4l0VEo9xWbb08OU2E+7
LChiT72ov/NujtvtXL3uiSztpdcJIsneQuWORPd8lindQMuHG+aw5+fMXSkkwoJ5
CC1ye+xsVGX4mf2vy0vZVw/DBgESWu5dqLlNyXomkIwxPyrPijP1VBrh2ajWa02v
uFedzersRqMaJvy6UeazR006maDsIqz7340mHxSbtkKLB/ewA0usoXSPNWpCdRJb
drAe7XV/ohpY+Ba4uDDmMQb8ac3aG+aT/nFHdKgjquuby3F+gONfly+KrAXAmOP/
9ytnUNcJCI7uVBvKWFeRGl/iSptAmYhJJFOX7Y8Vsjai55DPQnE=
=Ei52
-----END PGP SIGNATURE-----
--=-=-=--

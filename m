From: NeilBrown <neilb@suse.com>
Subject: Re: very large data-offset?
Date: Wed, 06 Dec 2017 08:53:12 +1100
Message-ID: <878tegu9iv.fsf@notabene.neil.brown.name>
References: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk> <87po7vtiw2.fsf@notabene.neil.brown.name> <216131fc-ef9d-2650-18a4-d2512e8b6f81@evenson.tk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <216131fc-ef9d-2650-18a4-d2512e8b6f81@evenson.tk>
Sender: linux-raid-owner@vger.kernel.org
To: Duane <duane@evenson.tk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 04 2017, Duane wrote:

> On 2017-12-03 05:51 PM, NeilBrown wrote:
>> On Thu, Nov 30 2017, Duane wrote:
>>
>>> Why is the data offset set so big? I created a 3x4TB RAID5 array and the
>>> data offset was 128MB. Chunk size was the default 512kB.
>> It is less than 0.1% of the device...
>>
>>> I cannot see why such a large offset is used. I would think the data
>>> offset need only be at most the chunk size plus the space (1 sector) for
>>> the superblock and bitmap.
>> It is insurance.  If you want to change the chunksize later, having a
>> lot of head-room will allow the reshape to go much faster.
>>
>>> When reshaping the array, I am prompted to use an external file, so I
>>> don't see that mdadm ever uses the space.
>> Citation needed.... what version of mdadm, what kernel?  What reshape
>> command?
> kernel:=C2=A0 9.64-1-lts

I don't know what that means?  Maybe 4.9.64-1-lts.
That's nice and recent.

> mdadm:=C2=A0 mdadm - v4.0 - 2017-01-09
> action:=C2=A0 reduce the number of raid devices

Ahh.  Reducing the number of devices doesn't use the head-space, it used
the end-space.  As you reduce the size of the array when doing this,
there is always lots of end-space.  So I'm surprised that it would want
a backup file.
However without specifics (mdadm -E of devices before the reshape, and
exact command given) I won't be looking into why it might.

Thanks,
NeilBrown


>>>
>>> I tried making some test arrays and got much smaller sizes. A 3x1GB
>>> RAID5 array with 64k chunks had a 1MB data offset.
>>>
>>>
>>> If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with
>>> setting the data offset to around 2MB?
>> Only that it might reduce your options in the future, though probably
>> not by much.
>>
>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlonFUkACgkQOeye3VZi
gblESA//Y5Gry8EXDEoTSl2GuPSu607BsTQ5Krin7Nt+Qhb7GU6kHXwyf8c4c/BW
gBK97GZpeFzs/eJSh8wuqyIS82d5aLuonr8xVMaxc92w6KWzTgL8G+TpfvRzoVN2
RtceIL5Uv/oTlvgGx8dfHYgiQbTs7sxXhfQ7+TnLgNV1mSIReOVfM86M+5PdSeUQ
fkufxuapfpPa9oUu6n0CGCRMezQJ7wR134kcGpGH8nLa7A3p01EXnFcV0BJpToc+
7vO+1GeD9RVme7XbuKfKOcax24FAVl5gNFscSTCRSZzAMQsluxMDQrO+Q2oy6XHi
9polQzsxhLUHjFXehbK0gvnYydxpV5Hgylwu6nNstpN+gDTM9MEYC7d43KWPR2b0
jHJTe6ejRKX4XGbZ5hsT53nit7GS6wGl+KlqzJsQR1H2q7B8DxlIgP3n6dHdgp/e
f3Yji4p5FifshrbXOgfTnDDHR0KQYQqoQEP2QhrMEiIpckoQQPJ3A60kDKIwdV5n
8vy3pWCjWZNwbJ1/n0wkiIrHSBBlw2/cP3rdDQep7Dhi0bAFp/uDexAAj/BTiUW+
HVz2oSEPJfCUXpDOlJ+hXp6DqY1Vw8PWeS/l/oPIN4TztVLkf0yb85O0bAgbsror
QPCiM4UtLFUn9WAEmFwwEZsF+EEscuoSVA0P4I4k/pcHI+qU3/Y=
=Q0BJ
-----END PGP SIGNATURE-----
--=-=-=--

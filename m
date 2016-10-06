From: NeilBrown <neilb@suse.com>
Subject: Re: Bug#837964: 95a05b3 broke mdadm --add on my superblock 1.0 array
Date: Thu, 06 Oct 2016 12:26:41 +1100
Message-ID: <87shsa469a.fsf@notabene.neil.brown.name>
References: <20160919163229.uccdr6bxiwetqvwo@derobert.net> <57E0CB6C.2040000@suse.com> <63417807-ae42-ed60-8c8b-3b699994c34c@derobert.net> <57E10311.7040601@suse.com> <1931152f-f5bc-bc1f-76a8-91921ffc1bed@derobert.net> <57E22C76.6040600@suse.com> <57E34496.8020108@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57E34496.8020108@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, 837964@bugs.debian.org, Anthony DeRobertis <anthony@derobert.net>, linux-raid@vger.kernel.org837964@bugs.debian.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22 2016, Guoqing Jiang wrote:

> On 09/21/2016 02:45 AM, Guoqing Jiang wrote:
>>
>>
>> On 09/20/2016 02:31 PM, Anthony DeRobertis wrote:
>>> Sorry for the amount of emails I'm sending, but I noticed something=20
>>> that's probably important. I'm also appending some gdb log from=20
>>> tracing through the function (trying to answer why it's doing cluster=20
>>> mode stuff at all).
>>>
>>> While tracing through, I noticed that *before* the write-bitmap loop,=20
>>> mdadm -E considers the superblock valid. That agrees with what I saw=20
>>> from strace, I suppose. To my first glance, it figures out how much=20
>>> to write by calling this function:
>>>
>>> static unsigned int calc_bitmap_size(bitmap_super_t *bms, unsigned=20
>>> int boundary)
>>> {
>>>     unsigned long long bits, bytes;
>>>
>>>     bits =3D __le64_to_cpu(bms->sync_size) /=20
>>> (__le32_to_cpu(bms->chunksize)>>9);
>>>     bytes =3D (bits+7) >> 3;
>>>     bytes +=3D sizeof(bitmap_super_t);
>>>     bytes =3D ROUND_UP(bytes, boundary);
>>>
>>>     return bytes;
>>> }
>>>
>>> That code looked familiar, and I figured out where=E2=80=94it's also in=
=20
>>> 95a05b37e8eb2bc0803b1a0298fce6adc60eff16, the commit that I found=20
>>> originally broke it. But that commit is making a change to it: it=20
>>> changed the ROUND_UP line from 512 to 4096 (and from the gdb trace,=20
>>> boundary=3D=3D4096).
>>>
>>> I tested changing that line to "bytes =3D ROUND_UP(bytes, 512);", and=20
>>> it works. Adds the new disk to the array and produces no warnings or=20
>>> errors.
>>
>> I think it is is a coincidence that above change works,  4a3d29e=20
>> commit made
>> the change but it didn't change the logic at all.
>
> Hmm, seems bitmap is aligned to 512 in previous mdadm, but with commit=20
> 95a05b3
> we made it aligned to 4k, so it causes the latest mdadm can't work with=20
> previous
> created array.
>
> Does the below change work? Thanks.
>
> diff --git a/super1.c b/super1.c
> index 9f62d23..6a0b075 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2433,7 +2433,10 @@ static int write_bitmap1(struct supertype *st,=20
> int fd, enum bitmap_update update
>                          memset(buf, 0xff, 4096);
>                  memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
>
> -               towrite =3D calc_bitmap_size(bms, 4096);
> +               if (__le32_to_cpu(bms->nodes) =3D=3D 0)
> +                       towrite =3D calc_bitmap_size(bms, 512);
> +               else
> +                       towrite =3D calc_bitmap_size(bms, 4096);
>                  while (towrite > 0) {

(sorry for the late reply ... travel, jetlag, ....)

I think a better, simpler, fix is:

> -               towrite =3D calc_bitmap_size(bms, 4096);
> +               towrite =3D calc_bitmap_size(bms, 512);

The only reason that we are rounding up here is that we are using
O_DIRECT writes and they require 512-byte alignment.

Any bytes beyond the end of the actual bitmap will be ignored, so it
doesn't matter whether they are written or not.

Current mdadm always aligns bitmaps on a 4K boundary, but older version
of mdadm didn't.  If the bitmap was less than 4K before the superblock
(quite possible), writing 4K for bitmap would corrupt the superblock.
This can certainly happen with 1.0 metadata.

However ... the reason that everything is now 4K aligned is that some
drives use a 4K block size.  For those, we really should be doing 4K
writes, not 512-byte writes.

So it would make sense to round up to 4K sometimes, and use 512 at other
times.  However the correct test isn't whether cluster-raid is in use.

The metadata has always been aligned on a 4K boundary.
If data_offset and bblog_offset and bitmap_offset all have 4K alignment,
then rounding up to 4K for the bitmap writes would be correct.
If anything have a smaller alignment, then it isn't necessary and so
should be avoided.

So the best fix would be to test those 3 offsets, and round up to a
multiple of 4096 only if all of them are on a 4K boundary.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJX9ahRAAoJEDnsnt1WYoG50XoQAJr9UBi7wMK9qBZa5Wj7pIZs
bIVhf1MvCFoen5zacQ7i+HbebTWjFiHRrWG/FbyUJbYzEXnvdqjm8bBeXe+eXCPy
a4Ql0/jgKgi7KwWOu/Fw1W+L2Q8wEv0daOULuz2iYf+ibkGnIk4imxh5sdVTyY4F
zSYtx9sF3xigAwAGCG+MjkiOvJAXmoMQCOZrP5IjFsG5k731f/yXKc5NKPcy1iQQ
4pBudmbsv8M+WS9VhlDCOtyaTn8IkDL8WqxYdWSACbRHc+ptCGoPIboxJ5OOqfTU
hq/1BZG8f0ck+nIPGjboUeGpucWQZHAfFvxX2Jd+BnsTNyHxgyliXlUY4skMsXr3
m/SnwRYdcIubYG4FJEp+NoB3QEf7xCH9IA+MPkw4MDLGXmV5hWMfl/Tdjf/GlvRq
Ipn6p8M71/dhAxWyqqD08mkJlRm94bHtecySeoUAk8FJNh/y1IB6AB9J4lvXaT9L
7H2oXqA7fX9m0Si2Dn/bGyZwGorikpQ2agqdXR67wQwPilwcjA8lRqh4xmNqzyh3
2WZkuCdZcUQn7ESpomXuDa6JPbr9ig7TL9zRfPN8rlqXU23NX6pkYnTunLPHUHRO
FRdmgTWZ0jnD4Jf1lsaVSBb52kNGrpqBJBYh9NlcbpEQUPg0DC9OPkZAVvzA5sMt
Pj0jD8gXgsoGXqQ8VfYN
=LCI1
-----END PGP SIGNATURE-----
--=-=-=--

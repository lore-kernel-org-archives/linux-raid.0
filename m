From: NeilBrown <neilb@suse.com>
Subject: Re: RAID creation resync behaviors
Date: Fri, 05 May 2017 08:00:07 +1000
Message-ID: <874lx0p9js.fsf@notabene.neil.brown.name>
References: <20170503202748.7r243wj5h4polt6y@kernel.org> <fe3c30e4-b0dd-639e-7db7-344aa93ce198@hesbynett.no> <20170504015454.d4obiuume6e3yrdv@kernel.org> <590B4DCE.3070801@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <590B4DCE.3070801@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Shaohua Li <shli@kernel.org>, David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org, jes.sorensen@gmail.com, neilb@suse.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, May 04 2017, Wols Lists wrote:

> On 04/05/17 02:54, Shaohua Li wrote:
>> On Wed, May 03, 2017 at 11:06:01PM +0200, David Brown wrote:
>>> On 03/05/17 22:27, Shaohua Li wrote:
>>>> Hi,
>>>>
>>>> Currently we have different resync behaviors in array creation.
>>>>
>>>> - raid1: copy data from disk 0 to disk 1 (overwrite)
>>>> - raid10: read both disks, compare and write if there is difference (c=
ompare-write)
>>>> - raid4/5: read first n-1 disks, calculate parity and then write parit=
y to the last disk (overwrite)
>>>> - raid6: read all disks, calculate parity and compare, and write if th=
ere is difference (compare-write)
>>>>
>>>> Write whole disk is very unfriendly for SSD, because it reduces lifeti=
me. And
>>>> if user already does a trim before creation, the unncessary write coul=
d make
>>>> SSD slower in the future. Could we prefer compare-write to overwrite i=
f mdadm
>>>> detects the disks are SSD? Surely sometimes compare-write is slower th=
an
>>>> overwrite, so maybe add new option in mdadm. An option to let mdadm tr=
im SSD
>>>> before creation sounds reasonable too.
>>>>
>>>
>>> When doing the first sync, md tracks how far its sync has got, keeping a
>>> record in the metadata in case it has to be restarted (such as due to a
>>> reboot while syncing).  Why not simply /not/ sync stripes until you fir=
st
>>> write to them?  It may be that a counter of synced stripes is not enoug=
h,
>>> and you need a bitmap (like the write intent bitmap), but it would redu=
ce
>>> the creation sync time to 0 and avoid any writes at all.
>>=20
>> For raid 4/5/6, this means we always must do a full stripe write for any=
 normal
>> write if it hits a range not synced. This would harm the performance of =
the
>> norma write. For raid1/10, this sounds more appealing. But since each bi=
t in
>> the bitmap will stand for a range. If only part of the range is written =
by
>> normal IO, we have two choices. sync the range immediately and clear the=
 bit,
>> this sync will impact normal IO. Don't do the sync immediately, but sinc=
e the
>> bit is set (which means the range isn't synced), read IO can only access=
 the
>> first disk, which is harmful too.
>>=20
> We're creating the array, right? So the user is sitting in front of
> mdadm looking at its output, right?

No, it might be anaconda or yast or some other sysadmin tool that is
running mdadm under the hood.

Presumably those tools could ask the question themselves.

NeilBrown

>
> So we just print a message saying "the disks aren't sync'd. If you don't
> want a performance hit in normal use, fire up a sync now and take the
> hit up front".
>
> The question isn't "how do we avoid a performance hit?", it's "we're
> going to take a hit, do we take it up-front on creation or defer it
> until we're using the array?".
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkLpGcACgkQOeye3VZi
gbm/uw//Yb+eAYbBhU0gVpqLGhidX1ciX0I+jUbCjsVqC0MU95qbHiN+eW80U8rF
NtiIfdnTNtvU1iJMBva62nrKqErvBhOOrH+82Vf7UqGttJUTdyx0vd6Q8CTcJ47i
v0uE8CkWIqP8b8XuDqc7eYi8Pss3ffCv1NYkI/0kQz9JGvV5iEujUGQVSUXdHjhq
peIp51BSXwyKZhPYElRhQmOYnXjfJQx/x9xqmR+kyXebzAUAeqtKrhJ0feodnv0o
Oguz9ja2l4e1yZcuERPJceTBtvKgHpc7i9Yy2gHJQXBGvE+3UKYHGPGT/wRsv3Rv
85tc9jyHIDDn5sDu7joXqasE5sRnyVJDM9w7r9jxFc3XINoOdGO++NvaJVmDp1h5
euffMbVfox2Ojvw9B2EOJxBvJWEGMfRu0o3328/r15iQHGeGKAPs4iHxyHOKypZ3
Cl3u3cWBajbZjvGPBhwU5EpgYVs1/y5iK/Q/oOM1hTVRQwim+dW24li8Ah8ba5QT
qpcrR4MJqLQvgD+tBYE3+dXFVUVAvDZX93gnan7bWRdfba+Bgq2xYp9XnBk1/TEw
FMmRzbh4cyBcAAw+kaH7pnM4QHFdqga1EY1y0yq+jGF1/f2sVTXe53ccWqWkWkSm
j/o4jrvxcoUqNmvGmAmANOTQW9Uoy8c+M3FLczGKgXjoghx2IS0=
=ZeNL
-----END PGP SIGNATURE-----
--=-=-=--

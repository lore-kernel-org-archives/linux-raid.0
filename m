From: NeilBrown <neilb@suse.com>
Subject: Re: very large data-offset?
Date: Mon, 04 Dec 2017 11:51:41 +1100
Message-ID: <87po7vtiw2.fsf@notabene.neil.brown.name>
References: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f5ff4798-5717-8b00-a293-463f202259b1@evenson.tk>
Sender: linux-raid-owner@vger.kernel.org
To: Duane <duane@evenson.tk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 30 2017, Duane wrote:

> Why is the data offset set so big? I created a 3x4TB RAID5 array and the=
=20
> data offset was 128MB. Chunk size was the default 512kB.

It is less than 0.1% of the device...

>
> I cannot see why such a large offset is used. I would think the data=20
> offset need only be at most the chunk size plus the space (1 sector) for=
=20
> the superblock and bitmap.

It is insurance.  If you want to change the chunksize later, having a
lot of head-room will allow the reshape to go much faster.

>
> When reshaping the array, I am prompted to use an external file, so I=20
> don't see that mdadm ever uses the space.

Citation needed.... what version of mdadm, what kernel?  What reshape
command?

>
>
> I tried making some test arrays and got much smaller sizes. A 3x1GB=20
> RAID5 array with 64k chunks had a 1MB data offset.
>
>
> If I make a 7x4TB RAID5 array with 64kB chunks, is there a problem with=20
> setting the data offset to around 2MB?

Only that it might reduce your options in the future, though probably
not by much.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAloknB0ACgkQOeye3VZi
gblzKQ/+P65rCrOXYjdZb07kUBzCdGUYHah7wa5WEqU6g9zLLnrLTQJuVlES0/Cr
g1L4JmT+gn1mpYgtVdyyXLUz5H3iGVJ6BhoUpWpOLg5k3fxWDrwZJZdrxQ75rL0q
cWqNmTvgRNQV9l68LKdbYLjQFgyCXvQ9seJad//r18OJJlakCDwerKmAaJfONowd
KFCHCd8hFNxAyk+gNUEmljj6sadBZEtrOP4DxmU0xUtan/2uWTA9JhB5Nyth+6yK
SM3RoiFNQiiqghMbzGeOsejb2mo+Y2lxp7YcCvikmaox/OLrnZduBkCkZthD1HcF
gdg8Ec+uCsHtVxlziWZk2OYlDc4IbK5tv/StIgzGCaanIKnhopwKkwhnvttryImJ
vZhrb0ZyVPoq5n2UkBR3r1JfH78keX9trFP5sMts73o7lb/nJgpYm0YJmdo7yta2
pfIy19rzT0oKSO/iHAVzrMcmSG3Fjv00Fb0Ib7WQnL1xMTOgUqMVjHSL1urqwNDL
FJ4VKsDSR7PLUkUVa8Q0SXkdVED/FF44q/SnZ+6E7G5wHOUUi9+hntOoAjvxr2rC
nOKiEZVLYNVuhra7R0AP3DC/ZkHOoqXxiK4e692lx/KKGcu8675wrcCpB3fUufmt
lfLBDbClK+zyMMH2FswFKUF3+92/Sr3Fn9Ws2jyLhhLaUKa0aJ8=
=Apg8
-----END PGP SIGNATURE-----
--=-=-=--

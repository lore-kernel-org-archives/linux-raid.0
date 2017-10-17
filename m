From: NeilBrown <neilb@suse.com>
Subject: Re: Wiki, raid 10, and my new system :-)
Date: Wed, 18 Oct 2017 07:14:06 +1100
Message-ID: <87bml5jzw1.fsf@notabene.neil.brown.name>
References: <59E4BA29.4050907@youngman.org.uk> <e3ee3a5d-a6b0-49aa-1949-18a248e1397f@thelounge.net> <87y3oak3zj.fsf@notabene.neil.brown.name> <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <67a81e49-37b6-b0f7-f9e2-16301ecd4f9a@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17 2017, Anthony Youngman wrote:

> On 17/10/17 01:33, NeilBrown wrote:
>> On Mon, Oct 16 2017, Reindl Harald wrote:
>>=20
>>> Am 16.10.2017 um 15:54 schrieb Wols Lists:
>>>> Raid 10 is a complicated subject what with near and far, and whether it
>>>> will grow, etc etc.
>>>>
>>>> I'm planning to raid-10 my swap partition, and while it doesn't matter
>>>> in the slightest because destroying and recreating will be no hassle f=
or
>>>> swap, I'd like to understand what's going on.
>>>>
>>>> If I remember correctly, there was a thread a little while back on
>>>> growing a raid-10? And you can't (for certain values of "can't" :-) do=
 it?
>>>>
>>>> Where's the best place to find info about near, far and offset layouts?
>>>
>>> http://xmodulo.com/setup-raid10-linux.html
>>=20
>> This patch has some good stuff, but
>>=20
>>    Chunk Size, as per the Linux RAID wiki, is the smallest unit of data
>>    that can be written to the devices
>>=20
>> I wonder where the Linux RAID wiki say that.  It is wrong.
>> The smallest unit of data that can be written to the devices is the
>> block size, which is hardware dependant and typically 512bytes or 4K.
>> This is not the same as the chunk size.
>>=20
> https://raid.wiki.kernel.org/index.php/RAID_setup#Chunk_sizes
>
> I understand what it's saying - this is the smallest size passed down to=
=20
> the disk, not the smallest size that the disk can write ... :-)

Well that is wrong too.  It is not the smallest size passed down to the
disk. That is also 512b or 4K.  Maybe it is the largest size that might
be passed down to a single disk.

It is the granularity at which the address-space of the array is divided
up before being shared around the address space of the member devices.
It has (almost) nothing to do with the size of IO requests.

NeilBrown

>
> This page has made it into the archaeology section so I don't plan to=20
> update it. And in context, it's reasonably clear what it means.
>
> Cheers,
> Wol

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnmZI8ACgkQOeye3VZi
gbnC+g/+PIMRJqHKr/ephWSQR1ffPUNRxXylFjcHS6nrkcLqCsEt3jSwjKg+COiX
HvSHGshSRU/mAPzOu8TXAUlbedmdf6Gf/hY8tpH+31iEe4XEHgNaDhCwOJyDBZKh
UEjbS/TxtERgWkYtr41z2NZfIs/c6Zz88kksH0dIkVLJm/LC9XLhLAlnNAkns+I7
V0iAo7XkrD1CUUULJg4Ou7UXl2inNDNqr8c6fr+HjqcJK8K+eDsyiuVT4k1i0ZQv
v28Z+VplNHoAPvuBIP9Ud0XRlmZ2FzbUNZEE8rEZdYCbeqgiHgSeVwdUPg4uMQww
dfcYt+o/7bWdwr2v68kYi0byUcTbgPcpk/2XJ+FMzMdA1oXkVd9woN6T5ZCKNpWz
rq818uI1fdw2JaOC+EpVduHD45xD6hVbnvpvUrHY3+x50XfhALPcu/x7GHSPD+4f
AJw0F9apPblPali0HlnfuxBgrjmEIPValeUJr9CmCY10YLBiwtuETfwr1QiYlQdv
tpj9s04z8kiqhylzfBWGrnrBrwSSfvBn2lT2dOeaXt6uLPMycqiHPy9xDULyaoRz
my1VyJ3mdnFcRkHwDL65sS5tZqXhtvd3TcMqLHMTW1Fu0dUc/bGsYJbXbXI/1gcX
HfZRFaGK3KrK7bQpK7zx+GtGEzVZIzQp7KPLfaHCALy10NtEWGE=
=VBvH
-----END PGP SIGNATURE-----
--=-=-=--

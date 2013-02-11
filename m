From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [PATCH 1/2] Modernize udev rules
Date: Mon, 11 Feb 2013 11:48:19 +0100
Message-ID: <5118CC73.80005@archlinux.org>
References: <1360432119-15910-1-git-send-email-thomas@archlinux.org> <20130211112016.3059ef95@notabene.brown> <5118ACE1.5020503@msgid.tls.msk.ru> <5118C3C0.2030708@archlinux.org> <CANBHLUh6TTWuq24iYKfKxkMoA65TNeq5wVCNnvKsYzNTzLz=Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2SFIBBRIVRCSHTLRUJKGO"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANBHLUh6TTWuq24iYKfKxkMoA65TNeq5wVCNnvKsYzNTzLz=Eg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <xnox@debian.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2SFIBBRIVRCSHTLRUJKGO
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 11.02.2013 11:44, schrieb Dmitrijs Ledkovs:
> On 11 February 2013 10:11, Thomas B=E4chler <thomas@archlinux.org> wrot=
e:
>> Am 11.02.2013 09:33, schrieb Michael Tokarev:
>>> 11.02.2013 04:20, NeilBrown wrote:
>>>> On Sat,  9 Feb 2013 18:48:38 +0100 Thomas B=E4chler
>>>> <thomas@archlinux.org> wrote:
>>>
>>>>> -IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
>>>>> +IMPORT{builtin}=3D"blkid"
>>>
>>> Does this has additional udev version constrain?
>>> I mean, which is the minimum udev version to support this properly,
>>> do we care?
>>
>> Udev relies on devtmpfs and thus does not create devices since version=

>> 176, therefore $tempnode is deprecated and only $devnode should be use=
d
>> ($tempnode seems to be around for compatibility, no idea if/when it wi=
ll
>> be dropped).
>>
>> The blkid builtin is also available since udev 176. In latest
>=20
> So 175 or 176? Neither debian nor ubuntu have 176 yet, only 175.
> And upgrading udev in debian/ubuntu is proving to be a hard task.

If I see this correctly, this was added after 175, so it first appeard
in 176.



------enig2SFIBBRIVRCSHTLRUJKGO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJRGMxzAAoJEChPw0yOSxolCBYQAJalLHUenF1jgFrMe6qsYQnY
crSkZYMqca5NoZq+mdEpmt1wZKuv7MYToeb2ZNH16QzGP3kp3yxlclsr0oH3BR1H
6sLu9EY2jNdUeV6A8+0l2ZQ90GG07WDg9Q9eFnVmja3Yi/ktVwk6ndH2FTEp5bDF
E0wOz6jrdhKrATEx4zBnKXTmVXvgyijrkgd9KQIcwfIpB/lw0/xbBsw4z0Mcc/4B
sP8q5LKeuEByMVZUUq7CC0bes+ilRVYYLwxOVKle9efZ9nSJ8DshfYfkI6KQAS25
CptvwgqbUP5eyWpD3V2onAqM4vYJCShftBzQPeeRXosHPfG48WjrSCV28eWphGUs
GviYdrcUmH58tVmNlLddHtHNMG4Z1nBIXOIOwHZqiMpclPwUB78qx16mZrWC5sK5
N/BYPLhqS7B+guxi/PW012Vdj0JR03owp6L1DeM+bfLBZDh3EY6CT0vJZL39Kwh4
L1MVwzUTniOX+VOTIF+Af7Bi0hgPmEAxZdZjSYbkvK1bukMypzGRihs4/Ka7cU5Y
0l5Hx3OGDovjGKtfniVOiLQ5xaOp0rC/tL+8E1/qV4/bFUU4/mBI5iGyA9Wmy5OA
plQXwATmjdyOxvWdTNX/anMAE1PibUZ8EcjAe9rpoKeKZxnHN3R3W0cTVawKcRGG
mAHnXHcyOqmnMkzgXQA3
=qvFV
-----END PGP SIGNATURE-----

------enig2SFIBBRIVRCSHTLRUJKGO--

From: Paul VanGundy <pvangundy@bradfordnetworks.com>
Subject: Re: Kernel Module - Raid
Date: Mon, 05 Nov 2007 15:58:55 -0500
Message-ID: <472F840F.2060607@bradfordnetworks.com>
References: <472F7AED.1030207@bradfordnetworks.com> <472F81B9.2070100@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <472F81B9.2070100@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Thanks for the prompt replay David. Below are the answers to your quest=
ions:

>> Hello. I don't know if this is the right place to post this issue bu=
t it
>> does deal with RAID so I thought I would try.
> It deals primarily with linux *software* raid.
> But stick with it - you may end up doing that...
>=20
> What hardware/distro etc are you using?
> Is this an expensive (hundreds of =A3) card? Or an onboard/motherboar=
d chipset?
The distro is Suse 10.1. It is an onboard chipset.
>=20
> Once you answer this then it may be worth suggesting using sw-raid (i=
n which
> case we can help out) or pointing you elsewhere...
>=20
>> I successfully built a new kernel and am able to boot from it.
>> However, I need to incorporate a specific RAID driver (adpahci.ko) s=
o we
>> can use the on-board RAID.
> I think this is the adaptec proprietary code - in which case you may =
need a very
> specific kernel to run it. You may find others on here who can help b=
ut you'll
> probably need an Adaptec forum/list.
Oi. This is a pain... ;)
>=20
>> I have the adpahci.ko and am unable to get
>> it to compile against any other kernel because I don't have the orig=
inal
>> kernel module (adpahci.c I assume is what I need). Is there any way =
I
>> can view the adpahci.ko and copy the contents to make a adpahci.c?
> No
That sucks. :)
>=20
>> Is it
>> possible to get the kernel object to compile with another kernel onl=
y
>> using the adpahci.ko?
> No
>=20
>> Am I making sense?  :)
> Yes
Good, because sometimes I don't make sense to myself. :)
>=20
> That's one of the big reasons proprietary drivers suck on linux.
>=20
Ok. So this chipset has the ability to use an Intel based RAID. Would
that be better?

Thanks again.

/paul
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHL4QOul+dQkHY548RAgF7AJ49tcLXtEp9DgZugK1ozhBNyP0tOgCeNygd
HVtJmjZR8qYm7+7lCwH7gLI=3D
=3DEQwg
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

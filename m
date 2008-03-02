From: Robin Hill <robin@robinhill.me.uk>
Subject: Re:  Strange RAID-5 rebuild problem
Date: Sun, 2 Mar 2008 12:29:00 +0000
Message-ID: <20080302122900.GA20333@cthulhu.home.robinhill.me.uk>
References: <656D8E57-804D-4A63-B9CA-D3C899616F61@it-loops.com> <3816592D-B75C-4B00-B3B7-65AE3B403DB0@it-loops.com> <20080301222326.GA20435@cthulhu.home.robinhill.me.uk> <2BABB51E-7701-44D4-AD07-6394CCF77941@it-loops.com> <A5F6B52A-00BB-4096-9A8D-367F61989186@it-loops.com> <244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <244F7F54-081B-462E-A0AD-8E5E1056B90B@it-loops.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Mar 02, 2008 at 09:14:29AM +0100, Michael Guntsche wrote:

>
> On Mar 2, 2008, at 8:38, Michael Guntsche wrote:
>
>
>> Changing this sysfs entry to 0, gives me the expected result if I do a=
=20
>> stop -> assemble with my 1.0 array.
>> It starts reysncing and everything is ok. According to the replies in th=
is=20
>> bug, setting start_ro to 1 should NOT stop the automatic resync after a=
=20
>> write to it, but this seems to have changed now.
>> So, is this a change in behaviour or is it a bug. If it is the former, I=
=20
>> probably need to talk with the debian guys about it, if it is a bug I wa=
it=20
>> for a fix and comment the entry in the mean time.
>>
>
> Answering myself here after reading through the manapges, this seems to b=
e=20
> a regression. Furthermore this may yield to some nasty data corruption,=
=20
> well at least I think it will.
>
> * --stop the array while resyncing.
> * set start_ro to 1
> * Start the array, automatic reconstruction does not start even after the=
=20
> data is been written to the ARRAY
> * stop the array again
> * set start_ro to 0
> * Start the array again
> The array picks up the resync process where it stopped the first time eve=
n=20
> if there has already been data written to it, while it was started with=
=20
> start_ro =3D 1.
> Won't this yield corrupted data, since data BEFORE that offset might=20
> actually have changed in the mean time?
>
That depends on the behaviour of the RAID system (and I've not dug
through the code to check on this).  Realistically this situation is no
different to writing to the array while it's rebuilding - in either case
the safe thing to do is read from the (n-1) known good disks, and write
to all the (n) disks in the array (i.e. never just do any fast XORing
with the parity block).  Any data written before the offset will still
be okay, and any data written after the offset will get recalculated
(which wastes a bit of time), but will still be valid.

Cheers,
        Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHyp2LShxCyD40xBIRAuYVAKDD3Jbev1T1K4IPs4lkU5+8jwWI0wCeL0TS
n504/drmqkOsVGWjNpMtOZo=
=uji8
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--

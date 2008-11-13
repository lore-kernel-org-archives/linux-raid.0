From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: Superblock limits / conversion
Date: Thu, 13 Nov 2008 15:43:14 +0000
Message-ID: <20081113154314.GD25751@cthulhu.home.robinhill.me.uk>
References: <7d86ddb90811130646k440676aakecc62defc8d42b7a@mail.gmail.com> <20081113151206.GB25751@cthulhu.home.robinhill.me.uk> <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3Gf/FFewwPeBMqCJ"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0811131019350.7992@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--3Gf/FFewwPeBMqCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu Nov 13, 2008 at 10:20:25AM -0500, Justin Piszcz wrote:

>
>
> On Thu, 13 Nov 2008, Robin Hill wrote:
>
>> On Thu Nov 13, 2008 at 09:46:23AM -0500, Ryan Wagoner wrote:
>>
>>> I have a RAID 5 array with 3 TB drives. When reading through the list
>>> I realized that the v0.90 superblock doesn't support arrays over 2TB.
>>> This means I can never grow this array to 4 drives?
>>>
>> That's my understanding, yes.
>
> I grew 400GiB drives in a raid5 configuration  from 1.8TiB to 3.3TiB one =
at=20
> a time with the 0.90 superblock (I believe), is that limit correct?
>
> It was awhile ago but FYI.
>
You're right - it's definitely not correct.  I actually have a 2.7TiB
RAID array with 0.90 superblock right here as well *oops*.  According to
the manual pages, the limit is on _component devices_, not on the
overall RAID array.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--3Gf/FFewwPeBMqCJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkcSxEACgkQShxCyD40xBL6cgCeLRHJRVCzBygb9UFTypUSP+p4
hxoAnjcXni07MwalLPtvRqQvLIvuMxHf
=TbwP
-----END PGP SIGNATURE-----

--3Gf/FFewwPeBMqCJ--

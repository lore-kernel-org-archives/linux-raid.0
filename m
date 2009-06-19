From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: filesystem stripe parameters
Date: Fri, 19 Jun 2009 10:36:03 +0100
Message-ID: <20090619093603.GA20316@cthulhu.home.robinhill.me.uk>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com> <4A3B573D.5020206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A3B573D.5020206@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri Jun 19, 2009 at 01:15:41PM +0400, Michael Tokarev wrote:

> Wil Reichert wrote:
>> When using LVM on top of RAID 5, is it still worthwhile to pass RAID
>> stripe information to the filesystem on creation?  Or do the PE's in
>> LVM blur the specific stripe sizes & I'd want to use some multiple of
>> those instead?
>
> It's a very good question, especially in context of RAID5.
>
> Yes it is still a good idea to pass that info because it is still a
> RAID5 which requires proper treatment wrt unaligned writes and keeping
> redundancy.
>
> But the thing is that RAID5 and LVM are not good to each other UNLESS
> RAID5 consists of 3, 5 or 9 (or 17 etc) drives -- i.e. 2^N+1, so that
> there's 2^N data drives.
>
> This is because LVM can only have blocksize as a power of two and in
> order to be useful that blocksize should be a multiple of RAID5 data
> row size (stripe size etc).
>
> This is only possible when RAID5 has 2^N data drives or 2^N+1 total
> drives.  The same is for RAID4, and for RAID6 it's 2^N+2 since RAID6
> has 2 parity drives.
>
> But if you can't match LVM blocksize and RAID strip size, there's
> *almost* no point at telling raid parameters to the filesystem: no
> matter how hard you'll try, LVM will make the whole thing non-optimal.
>
> Ok, depending on the number of drives, *some* logical volumes will
> be properly aligned, but definitely not all of them.  For example
> on a 4-drive RAID5 array, only every 3rd volume will be ok, --
> provided the volumes are allocated in full one after another,
> without holes and fragmentation.
>
> When everything is properly aligned, it's still worth the effort
> IMHO to tell the filesystem about true raid properties.
>
You'll also need to get the LVM header padding right, otherwise the
filesystem won't start on a stripe boundary and the alignment will all
go wrong.  I've no idea of the syntax but I recall seeing it discussed
on here several times.  A quick search throws up:
    http://www.issociate.de/board/goto/1859627/stride_/_stripe_alignment_on=
_LVM_?.html

Cheers,
    Robin

--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko7XAIACgkQShxCyD40xBL1AACggJboDw76ToS2854xN8GccbaL
+w8AoL0nGIZr6dX8DLkBxpWeZ2blRX38
=oJRF
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--

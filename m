From: NeilBrown <neilb@suse.de>
Subject: Re: Re-adding disks to RAID6 in a Fujitsu NAS: old mdadm?
Date: Fri, 29 Jun 2012 07:39:38 +1000
Message-ID: <20120629073938.4270fd76@notabene.brown>
References: <4FE9BFC1.5070607@xunil.at>
	<20120628163205.2c6a1122@notabene.brown>
	<4FEC1CE7.5010709@xunil.at>
	<4FEC2071.8010504@xunil.at>
	<20120628212257.5ca8fb05@notabene.brown>
	<4FEC7EB7.1000401@xunil.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F8eYrz+jbJkD7XBfA12bS3a"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FEC7EB7.1000401@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/F8eYrz+jbJkD7XBfA12bS3a
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 28 Jun 2012 17:56:39 +0200 "Stefan G. Weichinger" <lists@xunil.at>
wrote:

> Am 28.06.2012 13:22, schrieb NeilBrown:
>=20
> >> Do I have to fear read-errors as with RAID5 now?
> >=20
> > If you get a read error, then that block in the new devices cannot
> > be recovered, so the recovery will abort.  But you have nothing to
> > fear except fear itself :-)
>=20
> Ah, yes. Not exactly raid-specific, but I agree ;-) (we have a poem by
> Mischa Kaleko in german reflecting this, btw ...)
>=20
> So if there is one non-readable block on the 2 disks I started with
> (the degraded array) the recovery will fail?
>=20
> As sd[ab]3 were part of the array earlier, would that mean that maybe
> they bring the missing bit, just in case?
>=20
>=20
> >> I still don't fully understand if there are also 2 bits of=20
> >> parity-informations available in a degraded RAID6 array on 2
> >> disks only.
> >=20
> > In a 4-drive RAID6 like yours, each stripe contains 2 data blocks
> > and 2 parity blocks (Called 'P' and 'Q'). When two devices are
> > failed/missing, some stripes will have 2 data blocks and no parity,
> > some will have both parity blocks and no data (but can of course=20
> > compute the data blocks from the parity blocks). Some will have one
> > of each.
> >=20
> > Does that answer the question?
>=20
> Yes, it does.
>=20
> But ... I still don't fully understand it :-P
>=20
> What I want to understand and know:
>=20
> There is this issue with RAID5: resyncing the array after swapping a
> failed disk for a new one stresses the old drives, and if there is one
> read-problem on them the whole array blows up.
>=20
> As far as I read RAID6 protects me against this because of the 2
> parity blocks (instead of one) because it is much more unlikely that I
> can't read both of them, right?

Right.

>=20
> Does this apply to only a N-1 degraded RAID6 or also an N-2 degraded
> array? As far as I understand, it is correct for both cases.

Only an N-1 degraded array.
An N-2 degraded RAID6 is much like an N-1 degraded RAID5 and would suffer t=
he
same fate on a read error during recovery.


>=20
> -
>=20
> I faced this RAID5-related problem 2 times already (breaking the array
> ...) and therefore started to use RAID6 for the servers I deploy,
> mostly using 4 disks, sometimes 6 or 8.
>=20
> If this doesn't really protect things better, I should rethink that,
> maybe.

Your current array had lost 2 drives.  If it had been a RAID5 you would be
wishing you had better backups right now.  so I think RAID6 really does
provide better protection :-)  However it isn't perfect - it cannot protect
against concurrent failures on 3 drives...

NeilBrown



>=20
> -
>=20
> Right now my recovery still needs around 80mins to go:
>=20
> md0 : active raid6 sdb3[4](S) sda3[5] sdc3[2] sdd3[3]
>       3903891200 blocks level 6, 64k chunk, algorithm 2 [4/2] [__UU]
>       [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>....]  recovery =
=3D 83.0%
> (1621636224/1951945600) finish=3D81.5min speed=3D67477K/sec
>=20
> I assume it is OK in this state of things that sdb3 is marked as
> (S)pare ...
>=20
> Thanks, greetings, Stefan


--Sig_/F8eYrz+jbJkD7XBfA12bS3a
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+zPGjnsnt1WYoG5AQL+oA/+P7X/ij+0fTJBsx2T1b62zRu56fHFYXw/
29rQMKDOVUpv4ktcYizgsbIaPD5MmhpvPKktqYxKevhdWyZg9S/BNB1UDNUpU+hd
FVbguRwSdudnF6BnpsjcnUetythCxZXPgweG/E7jBUm6O1bYlIoSrBxLSdGuqCjK
0muBkYkurqS0p9BZGmbbOiLBfHHkT6U3D5ruotPXRb6k9DZpwvzbcmA2PP90nKzy
7y6Q0lELEDl/ozDMDsGHrolpPhn7//rM9MK5xu0ZYa0tNU9RaU/DrQ0WEvU8FQVZ
KXkyDgKJORJDoFs8zpDvCsd4vLTcl4Ayxq6DOzhHOT6FRfhmSQ4foqrwwssxcZ8i
XxGkJl1xk2JlpZv8EtGhD7w58KkExOvJGTcir79Ym/NrNeFUiL+gLzEwxVnoEy/Y
1qplluU0QI0OS8SopmqahzG076R6eZdjPS8PKtrfWCPaB/ermzzDssuoxT3Z7DXq
mT4ZkVgV90fjxy7qd0/cQhHOFyoZ7MvsJBOO6dx4FqZU+28//DT7lf5Q0EqIxI3e
S5EpMm2LPA2bCYna5UZQ2+tN5canvB9YG/ZjTgUV/lfaL1jWipPpof7aYMSGf2i1
uY02cQKY9cIliK4B4BjdHa2hAa4OfNUr3sey3Cb9jW/IYi4FvVrsd4O/AXJTLUFn
zNSIrwfk7Mo=
=JVUl
-----END PGP SIGNATURE-----

--Sig_/F8eYrz+jbJkD7XBfA12bS3a--

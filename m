From: NeilBrown <neilb@suse.de>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Wed, 29 Oct 2014 20:05:01 +1100
Message-ID: <20141029200501.1f01269d@notabene.brown>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/I3I_+sA==el0OXhfaAn63pe"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/I3I_+sA==el0OXhfaAn63pe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Oct 2014 12:45:34 +0530 Anshuman Aggarwal
<anshuman.aggarwal@gmail.com> wrote:

> I'm outlining below a proposal for a RAID device mapper virtual block
> device for the kernel which adds "split raid" functionality on an
> incremental batch basis for a home media server/archived content which
> is rarely accessed.
>=20
> Given a set of N+X block devices (of the same size but smallest common
> size wins)
>=20
> the SplitRAID device mapper device generates virtual devices which are
> passthrough for N devices and write a Batched/Delayed checksum into
> the X devices so as to allow offline recovery of block on the N
> devices in case of a single disk failure.
>=20
> Advantages over conventional RAID:
>=20
> - Disks can be spun down reducing wear and tear over MD RAID Levels
> (such as 1, 10, 5,6) in the case of rarely accessed archival content
>=20
> - Prevent catastrophic data loss for multiple device failure since
> each block device is independent and hence unlike MD RAID will only
> lose data incrementally.
>=20
> - Performance degradation for writes can be achieved by keeping the
> checksum update asynchronous and delaying the fsync to the checksum
> block device.
>=20
> In the event of improper shutdown the checksum may not have all the
> updated data but will be mostly up to date which is often acceptable
> for home media server requirements. A flag can be set in case the
> checksum block device was shutdown properly indicating that  a full
> checksum rebuild is not required.
>=20
> Existing solutions considered:
>=20
> - SnapRAID (http://snapraid.sourceforge.net/) which is a snapshot
> based scheme (Its advantages are that its in user space and has cross
> platform support but has the huge disadvantage of every checksum being
> done from scratch slowing the system, causing immense wear and tear on
> every snapshot and also losing any information updates upto the
> snapshot point etc)
>=20
> I'd like to get opinions on the pros and cons of this proposal from
> more experienced people on the list to redirect suitably on the
> following questions:
>=20
> - Maybe this can already be done using the block devices available in
> the kernel?
>=20
> - If not, Device mapper the right API to use? (I think so)
>=20
> - What would be the best block devices code to look at to implement?
>=20
> Neil, would appreciate your weighing in on this.

Just to be sure I understand, you would have N + X devices.  Each of the N
devices contains an independent filesystem and could be accessed directly if
needed.  Each of the X devices contains some codes so that if at most X
devices in total died, you would still be able to recover all of the data.
If more than X devices failed, you would still get complete data from the
working devices.

Every update would only write to the particular N device on which it is
relevant, and  all of the X devices.  So N needs to be quite a bit bigger
than X for the spin-down to be really worth it.

Am I right so far?

For some reason the writes to X are delayed...  I don't really understand
that part.

Sounds like multi-parity RAID6 with no parity rotation and=20
  chunksize =3D=3D devicesize

I wouldn't use device-mapper myself, but you are unlikely to get an entirely
impartial opinion from me on that topic.

NeilBrown


--Sig_/I3I_+sA==el0OXhfaAn63pe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVFCtvTnsnt1WYoG5AQLEXQ//d0avhhMqnf9dZOYNA02xAUPDhoTwL45J
NYdXWNsaOr4o5IW7eBsqUv+DUJs79NPnyFocn9Qs5wgkQTnvsUCLVtnXlMVI57Rs
cl90BITB/I8af5rglREG/8RsMwdTaM89gBGAOEudlSk+Y9M+3tWjHrGAPI97EgT7
KuTicvUguxh1cyQ0UpWBev/9G055q4CaWsM3zxx+Kv8CLGrNxEhDTV8F9kjrevSz
sWaZnLx1FTspzI3D6UVcTsl2+LK6KQdk6fJm1+IDd8A5No4vFSVIZ0tFpvuX1LwA
1oeD459aFQYMCEYF7CwCI/pfN5ZWHkJMAYVs9mXxb5GUK7Hp8dzCzH1gNiu3yo2h
UExGQEXIEXYMUzEnupKaYdQftYzDT6yBfXWH3Mg562bkImaXALkygwK4XvTKWIqW
GK+6Do/n8rRP5urLf1pF0C2scBFHzAOuugp6YYgCD3H2UgGHLu92SrubK1KmZzrW
gM+shsmwi/QNdY7lWlSNIjLrTnqj3eO9edzrcnUBeN4xcTg6c6w1Z4fNIgjNC/yT
oVRkA7fS3wWAK5KwDH//7a89wmeOJ5mxQxhzaqBzyBPyOEivcAtnE3OIuqRCwSPJ
6shRzzTjm5jkTTq/pXpBr5XkwpoEcSQFdKrmWCTR4mbVzZHk5+i+efVDuS4zvsxi
Zy62EYYT0J0=
=KGMW
-----END PGP SIGNATURE-----

--Sig_/I3I_+sA==el0OXhfaAn63pe--

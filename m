From: NeilBrown <neilb@suse.de>
Subject: Re: RAID10 Performance
Date: Wed, 2 Mar 2011 22:16:02 +1100
Message-ID: <20110302221602.52961e88@notabene.brown>
References: <4D6E04E7.6060605@cendio.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/.vCuTy81nH/._MK2xNXdB1."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D6E04E7.6060605@cendio.se>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Sowry <aaron@cendio.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/.vCuTy81nH/._MK2xNXdB1.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



On Wed, 02 Mar 2011 09:50:47 +0100 Aaron Sowry <aaron@cendio.se> wrote:

> Hello,
>=20
> I have been testing different RAID configurations on a 2-disk setup, and
> have a couple of questions regarding performance. The information I have
> found online so far seems to contradict itself fairly regularly so I was
> hoping for a more coherent answer :)
>=20
> 1) As I understand it, a RAID10 'near' configuration using two disks is
> essentially equivalent to a RAID1 configuration. Is this correct?

"equivalent" in that the data is stored in the same places.  However as
different code is used to access it, performances could be different.

>=20
> 2) Does md RAID1 support 'striped' reads? If not, is RAID1 read
> performance in any way related to the number of disks in the array?

Not sure exactly what you mean by "striped" reads.  There is no concept of a
stripe in RAID1.
A single sequential read will tend to read from just one device.
Random reads will tend to use all devices.

>=20
> 3) From what I have read so far, a RAID10 'far' configuration on 2 disks
> provides increased read performance over an equivalent 'near'
> configuration, however I am struggling to understand exactly why. I
> understand the difference between the 'near' and 'far' configurations,
> but not *why* this should provide any speed increases. What am I missing?

A sequential read on raid10-far2 will read from both devices in parallel
(once read-ahead kicks in or large enough reads are submitted).  So a single
sequential read from a RAID10-far2 should be (nearly) twice as fast as a
single sequential read from a RAID1 - as twice as many drives are used.

>=20
> 4) I have performed a(n admittedly fairly basic) benchmark on the same
> system under two different configurations - RAID10,n2 and RAID10,f2
> using tiobench with default settings. In short, the results showed a
> significant speed increase for single-threaded sequential reads (83Mb/s
> vs 166MB/s), some increase for single-threaded random reads (1.85Mb/s vs
> 2.25Mb/s), but a decrease for every other metric, including
> multi-threaded sequential and random reads. I was expecting write
> performance to decrease slightly under RAID10,f2 compared to RAID10,n2,
> but am slightly confused about the multi-threaded read performance. Is
> it my expectations or my testing that needs to be reviewed?

If the  random reads are smaller than the chunk size and suitably aligned,
then you should get much the same performance - f2 might be a bit faster
because it always reads from the 'faster' region of the device.

If the random reads are larger than the chunk size, then each read will hit
both disks in f2, but only one disk in n2, so f2 will have more contention.

Writes (sequential or random) are certainly slower with f2 as the head keeps
seeking from one half of the device to the other.  Large chunk sizes will
reduce this a little.

What chunk size did you use?  What block size for random IO?
Do the results change as you vary these sizes?

NeilBrown


>=20
> Cheers,
> Aaron
>=20


--Sig_/.vCuTy81nH/._MK2xNXdB1.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFNbib3G5fc6gV+Wb0RApmTAJ9nV8xtQD4RfVkYcVYesVMGEsaqLwCfeFRR
un80fW4VovqWx2bk1IeK82s=
=XFrI
-----END PGP SIGNATURE-----

--Sig_/.vCuTy81nH/._MK2xNXdB1.--

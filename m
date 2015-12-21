From: NeilBrown <neilb@suse.de>
Subject: Re: clustered MD - beyond RAID1
Date: Tue, 22 Dec 2015 09:03:09 +1100
Message-ID: <8737uv4fz6.fsf@notabene.neil.brown.name>
References: <56742652.5040304@nasa.gov> <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov> <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56786EA4.2020209@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 22 2015, Tejas Rao wrote:

> GPFS guarantees that only one node will write to a linux block device=20
> using disk leases.

Do you have a reference to documentation explaining that?
A few moments searching the internet suggests that a "disk lease" is
much like a heart-beat.  A node uses it to say "I'm still alive, please
don't ignore me".  I could find no evidence that only one node could
hold a disk lease at any time.

NeilBrown


>                    Only a node with a disk lease has the right to submit=
=20
> I/O and disk leases expire every 30 secs and needs to be renewed. Lustre=
=20
> and other distributed file systems have other ways of handing this.
>
> Using md devices in a shared/clustered environment is something not=20
> supported by Redhat on RHEL6 or RHEL7 kernels, so this is something we=20
> would not try in our production environments.
>
> Tejas.
>
> On 12/21/2015 15:47, NeilBrown wrote:
>> On Tue, Dec 22 2015, Tejas Rao wrote:
>>
>>> What if the application is doing the locking and making sure that only 1
>>> node writes to a md device at a time? Will this work? How are rebuilds
>>> handled? This would be helpful with distributed filesystems like
>>> GPFS/lustre etc.
>>>
>> You would also need to make sure that the filesystem only wrote from a
>> single node at a time (or access the block device directly).  I doubt
>> GPFS/lustre make any promise like that, but I'm happy to be educated.
>>
>> rebuilds are handled by using a cluster-wide lock to block all writes to
>> a range of addresses while those stripes are repaired.
>>
>> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWeHcdAAoJEDnsnt1WYoG5v6EP/jT8//MkxBu4cVvPFw1e7LbW
swUFVVPGSFIZE/pWVLIMD7mukO0A2H8Fx4j73lECJ/ozO+mMrDwCfU8Z5UPV+zYy
LTod7tgJhL57mLxINQuqhRSR0Zvhzr0tgXZ0HrgncjmResqphyDvA6SUUNwsX7ev
5ovPJtRpBkV8CyHhgU/HXCAJnjUnFY+oa9oKHIqjAVMrc97Nxze36AK6gZZSTDtf
wehkSu0jTXoL9EGghTBlXjlecKMpGkid+mHRKjgol4rupK6bNKC1bZnTFOCwvifT
fntjcxIETi+UIc5wyckViUOyzh0Al1WZGquCFeG6rEnCTSUs8xAvL1fzCT5ao8/v
Q/bqN6DmGv5/K+KsiawsCeFhcW8TshRIc8Z9pOKF/3kVid81bDtxUR8lBE4Jptu2
tkVuAV1FYdWQNPWE2hpBa9vwUVq/HstAkC1z6KLzwD1zIzY8Ia5AU10O/1MnzeJm
Oe2BSCLQX4QSJpGHN2MAqPAwnJzqHhshCpB1tU7clXNP7wbjckfWNgmNrbhXrZfp
4rMmvIwRgrDOKgmw4Q0GBZgwhu3PaMAyYUxGs1PdTyiL7G8nE9mOgnIbSm68bkTR
TjhgU1626pstKAxx2w2W4L8es398xqKyO9C6+lFNhvi3C9/vntQaUIISdJnFZ5Y7
qI9NUTzHGvLHMLYCKS23
=Ji3L
-----END PGP SIGNATURE-----
--=-=-=--

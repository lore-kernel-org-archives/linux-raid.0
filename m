From: NeilBrown <neilb@suse.de>
Subject: Re: problems with lots of arrays
Date: Thu, 12 May 2016 11:55:50 +1000
Message-ID: <87eg98rqe1.fsf@notabene.neil.brown.name>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com> <wrfj8tzhk5by.fsf@redhat.com> <87wpn1sfk6.fsf@notabene.neil.brown.name> <20160511004550.GB127453@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160511004550.GB127453@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, Mike Lovell <mike.lovell@endurance.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 11 2016, Shaohua Li wrote:

> On Wed, May 11, 2016 at 08:39:53AM +1000, NeilBrown wrote:
>> On Wed, May 11 2016, Jes Sorensen wrote:
>>=20
>> > Mike Lovell <mike.lovell@endurance.com> writes:
>> >> we have a number of systems that have a large number of software
>> >> arrays running. its in the couple hundred range. we have been using a
>> >> custom built kernel based on 3.4 but are wanting to update to a
>> >> mainline kernel and have been experimenting with 4.4. the systems are
>> >> running recent centos 6 releases but we have been downgrading the
>> >> mdadm version from 3.3.2 in 6.7 to a custom build 3.2.6. we installed
>> >> the downgraded version due to a problem with array numbering. i
>> >> emailed the list a while ago explaining the issue and submitting a
>> >> patch to fix [1]. i never heard anything back and since we had a
>> >> simple fix i didn't follow up on it.
>> >
>> > [snip]
>> >
>> >> what do you all think?
>> >>
>> >> thanks
>> >> mike
>> >>
>> >> [1] http://marc.info/?l=3Dlinux-raid&m=3D142387809409798&w=3D2
>> >
>> > Staying consistent in using dev_t rather than casting back and forth to
>> > int seems a reasonable fix to apply to mdadm. It obviously won't change
>> > the issues with the newer kernels, but I don't see any reason why we
>> > shouldn't apply that fix to mdadm.
>> >
>> > Neil any thoughts on this?
>>=20
>> I agree that changing "int" to "dev_t" is a good idea.
>>=20
>> We should really fix the more general problem too.
>>=20
>> On any kernel with  /sys/module/md_mod/parameters/new_array
>> find_free_devnm avoid trying anything above 511. (1<<9)-1.
>>=20
>> If that fails to find a free number, then it should probably try a name
>> like "md_NN" and act as though ci->name is set.
>>=20
>> Also, when a "name" given for the md array that is longer than 28 bytes
>> we need to fall back to choose an array name ourselves even if ci->name
>> is set.  Start with md_512 and work upwards.
>> Rather than probing we should read /sys/block looking for "md_*" and
>> maybe choose 1 more than the largest number found.
>
> I'm wondering why udev open the device with major/minor without checking =
if the
> device exists. A simple 'stat' check is neat.

A big part of the role of udev is to create the device nodes in /dev.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXM+KnAAoJEDnsnt1WYoG5VZwP/RqCH1i7rMZp9o05ceSQdxiC
UMgae8pwbrWDzrfyZKmTXA/7U5dxoB22KwNOFFtQEqnnMrYLBFkqx9Qv6WKgs+ey
gAFifCG1KYE4K9+Kqd+3VSs3ObviDvOjuloiyXzbCnee/H/2tsNmvR56QBcYvdk8
BEUaRegC4EfcbZCwVex5D7YDGrCVAacJabzZvdGv0VD3+dYZ28iMQp7g5Gp5dOSW
T+SEWrV2ArWgh6qi05Sxie18pKVKH/Hngf1YtrRHkNnZmS+SeLaQYyaJD9lBN3UR
uX5X19uNAniE0s9H7zCkBVZXPVMgEt6bJX3O/9xo8kdNr0arhJC/lIgECABrxYjN
jhcm+gMzGsF7GvvKpnwP0vMukN+LOs43g7+92YgK6oIOxlMnva16SgyDtV3IgJNW
jU0WKBS0sY/cwjScLx0HttWN2PwXgo9IrASdAMwSrJCk6JfZ51+MA2QyXXs1UMOp
jCUwL8APFaTOjrPQRFvbpwP6q29b2Xym1KkBRtY7sHHunA/sCAA2WsNAIlVT1QCk
KE30Bb7dw/x7onZaC+C0klmBoA49LGguBtaNtwLCaAZhDVal74vQNN8kiauHA2mD
+mWDlt4jypoUvzzwQhXIEi1e5OeeNWW3QwjHSRtJW/0GHGuv2mjKvs0vCU3J7LHw
X4xVOwo0d2OQpgKKAL8T
=mHrT
-----END PGP SIGNATURE-----
--=-=-=--

From: NeilBrown <nfbrown@novell.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." - recovery advice?
Date: Mon, 21 Dec 2015 12:35:44 +1100
Message-ID: <87d1u060sv.fsf@notabene.neil.brown.name>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com> <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com> <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: George Rapp <george.rapp@gmail.com>, Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Dec 11 2015, George Rapp wrote:
>
> I appear to be too early in the reshape for auto-recovery, but too far
> along to just say "never mind on that whole reshape business". Any
> other thoughts?
>

What this means is that you've hit a corner case that was never thought
through properly and isn't handled correctly.

The current state of the array is (I think) that it looks like a reshape
to reduce the number of devices in the array has very nearly completed.
Only the first stripe needs to be completed.  Whether that first stripe
is still in the old "N+1" device layout or the new "N" device layout is
unknown to the kernel - this information is only in the backup file
(which doesn't exist).
By telling mdadm --invalid-backup, you effectively tell mdadm that there
is nothing useful in the backup file so it should know that the reshape
has actually completed.  But it has no way to tell the kernel that.
What it should do in this case is (I think) rewrite the metadata to
record that the reshape is complete.  But it doesn't.

I shouldn't be too hard to fix, but it isn't trivial either and I'm
unlikely to get anywhere before the Christmas break.

If you can get reshape to work at all (disable selinux?) you could try
--update=revert-reshape and let the reshape to more devices progress for
a while, and then revert it.

If you cannot get anywhere, then use
  "mdadm --dump=/tmp/whatever /dev/mdthing"

to create a copy of the metadata in some spares files.
Then tar those up (a compressed tarchive should be tiny) and email them.
Then I can try and see if I can make something work on exactly the array
you have.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd1dwAAoJEDnsnt1WYoG5TpoP/iiR2Bnd8TfOkO2Ukhe0aKG5
/4s7hgaK34b12TAwJGjHtMrgKVrYVhOcts32HOu812uxXQ5xPlLNWjSJuuzYrQ3b
w5uRpKv21sL5g2LSAGqxkIjloBvSsyMsU63JmtoQN2dQnSnGH9kiK4pQdp2G856G
LpCvoCjPvgdiSNTkr0adpD8OHPwM6Hum9Ystgm5mzyo7kSdkK4YLeV+Iy7azLm9z
kihbwh7z+mIgkgzu24d3Qs0cbUDnv57VL2GFdCOxohxfTGag1ZmEWQ8sVK09fYA9
4vmFAiYq6MclIGxrmJqDeS6uyxmzOZ1L0P5W+FKD9VytJcvNgaxZ2aoUGeafDS+J
eptRXaqyet1erU1duXLbfw21JWOYiwDXHMial8+N195lePzi7E2YH/SiobDBM+b9
6aYJ8JQJp1WaoBWePiGrZFGGTCRYsg1ThvtLZhtkQ11aPxksdiDtK6AFn1FMQo21
nW8jGKILIiCsZ9W8F2m1vWL6VmQ8SyoYWE609cHgv1WgBL2q4UrvqB8m6bzL7RBE
8PqE7VQTP0mQiTP8C8C/rF9LkHUHxY0fh167ouoo9O1eGioAa3cCV8/Fz4hVXa58
AJ6e9DK1N1CT3qja2Px6x5+Kvz8Y9uGOQ9sxzbSkVU8Esr7qXirkZHMmMyF2e5pX
IH5rk6ncfubNygGRtC47
=ojAA
-----END PGP SIGNATURE-----
--=-=-=--

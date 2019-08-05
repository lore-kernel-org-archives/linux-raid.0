From: NeilBrown <neilb@suse.com>
Subject: Re: Bisected: Kernel 4.14 + has 3 times higher write IO latency than Kernel 4.4 with raid1
Date: Tue, 06 Aug 2019 09:46:27 +1000
Message-ID: <87h86vjhv0.fsf@notabene.neil.brown.name>
References: <CAMGffEkotpvVz8FA78vNFh0qZv3kEMNrXXfVPEUC=MhH0pMCZA@mail.gmail.com> <0a83fde3-1a74-684c-0d70-fb44b9021f96@molgen.mpg.de> <CAMGffE=_kPoBmSwbxvrqdqbhpR5Cu2Vbe4ArGqm9ns9+iVEH_g@mail.gmail.com> <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAMGffEkcXcQC+kjwdH0iVSrFDk-o+dp+b3Q1qz4z=R=6D+QqLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jinpu Wang <jinpu.wang@cloud.ionos.com>, linux-raid <linux-raid@vger.kernel.org>
Cc: Alexandr Iarygin <alexandr.iarygin@cloud.ionos.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05 2019, Jinpu Wang wrote:

> Hi Neil,
>
> For the md higher write IO latency problem, I bisected it to these commit=
s:
>
> 4ad23a97 MD: use per-cpu counter for writes_pending
> 210f7cd percpu-refcount: support synchronous switch to atomic mode.
>
> Do you maybe have an idea? How can we fix it?

Hmmm.... not sure.

My guess is that the set_in_sync() call from md_check_recovery()
is taking a long time, and is being called too often.

Could you try two experiments please.

1/ set  /sys/block/md0/md/safe_mode_delay=20
   to 20 or more.  It defaults to about 0.2.

2/ comment out the call the set_in_sync() in md_check_recovery().

Then run the least separately after each of these changes.

I the second one makes a difference, I'd like to know how often it gets
called - and why.  The test
	if ( ! (
		(mddev->sb_flags & ~ (1<<MD_SB_CHANGE_PENDING)) ||
		test_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
		test_bit(MD_RECOVERY_DONE, &mddev->recovery) ||
		(mddev->external =3D=3D 0 && mddev->safemode =3D=3D 1) ||
		(mddev->safemode =3D=3D 2
		 && !mddev->in_sync && mddev->recovery_cp =3D=3D MaxSector)
		))
		return;

should normally return when doing lots of IO - I'd like to know
which condition causes it to not return.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAl1Iv9MACgkQOeye3VZi
gbmI5g/+JKHQonxW3qKWWf3giQwBF/hwLPxqfbX1AfXyzbJvMgMgptQWQo/Vce6W
O0OApPtiUrkkpC7KIYc5fSwFfPXFZt+TT7e+eRSOyVWpHU1B8OkJmEnMtI6MEqOU
AKKwJ6LdxcSJaP1Z/8b+2r7M2d5jFRgo10GdRDkn2a9RV4oD2LsyydIf5lTq8yvH
vD45/5YbDwmaiEqmG2HYh9+lm5AH4jqrOEimT90KpERZjW0/vWRm8ZilN2o62+Or
oSMcaC7YtgYE4MMWoiMLbRPD3CbT4Iitytggn29v+ZxrTvumat1hYEkcnWSz2oZs
CHMMP7vI6XIPATZ5wzL7YA0w9mgkanW+nsE3geZ4x5K+wmXTUZNiQzxKINagQ33Y
vmcMsY7uLZejWrajOXmmg/nNi0zCmRbfm1sKikz50H9ysGaAJhhBUzqwt7jb6UFo
c23oKdS8KYNIQ4AuxmXyMM+w2Nnix9GSGc3cM5jsC5ZGFrMk9P7GiZz6UzoMcTVQ
tB0p8nJ5EsS6Ook7kEKpG5BUs3N++fq78EF0xwfdOd+UIkIBOa7DPTyihM8b6sUM
aWgSLsXtWjPHxt/7mm20lL1F2SJ3cfrCz77cCOg6X1VHE5h3PsoeghG/oQIRd9LZ
6aWzsj/W/fByGG4wsPm2aCL1bWMgnXl2mBb4d4dILAG+3gbQ50M=
=PJk4
-----END PGP SIGNATURE-----
--=-=-=--

From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm:compiled warning in mdadm.c:1974:29 treats as errors
Date: Fri, 07 Apr 2017 09:36:25 +1000
Message-ID: <87r315yupy.fsf@notabene.neil.brown.name>
References: <F21EB93E-F788-4981-A8BD-7DA4AFC295F6@suse.com> <wrfjd1cqeugb.fsf@gmail.com> <0492b02e-1c4d-02e7-a196-f15e8684e4f3@suse.com> <a5f537c0-9b73-9a58-7566-0a242e0ff840@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a5f537c0-9b73-9a58-7566-0a242e0ff840@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Liu Zhilong <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 06 2017, Jes Sorensen wrote:

> On 04/06/2017 04:21 AM, Liu Zhilong wrote:
>> hi,
>>
>> I found this compiling warning, and can reproduce on my Leap42.1,
>> Leap42.2 and SLES12 SP2 with v4.8.5 version of gcc.
>>
>> # gcc -v
>> Using built-in specs.
>> COLLECT_GCC=3Dgcc
>> COLLECT_LTO_WRAPPER=3D/usr/lib64/gcc/x86_64-suse-linux/4.8/lto-wrapper
>> Target: x86_64-suse-linux
>> Configured with: ../configure --prefix=3D/usr --infodir=3D/usr/share/info
>> --mandir=3D/usr/share/man --libdir=3D/usr/lib64 --libexecdir=3D/usr/lib64
>> --enable-languages=3Dc,c++,objc,fortran,obj-c++,java,ada
>> --enable-checking=3Drelease --with-gxx-include-dir=3D/usr/include/c++/4.8
>> --enable-ssp --disable-libssp --disable-plugin
>> --with-bugurl=3Dhttp://bugs.opensuse.org/ --with-pkgversion=3D'SUSE Linu=
x'
>> --disable-libgcj --disable-libmudflap --with-slibdir=3D/lib64
>> --with-system-zlib --enable-__cxa_atexit
>> --enable-libstdcxx-allocator=3Dnew --disable-libstdcxx-pch
>> --enable-version-specific-runtime-libs --enable-linker-build-id
>> --enable-linux-futex --program-suffix=3D-4.8 --without-system-libunwind
>> --with-arch-32=3Di586 --with-tune=3Dgeneric --build=3Dx86_64-suse-linux
>> --host=3Dx86_64-suse-linux
>> Thread model: posix
>> gcc version 4.8.5 (SUSE Linux)
>>
>> # make everything
>> ... ...
>> mdadm.c: In function =E2=80=98main=E2=80=99:
>> mdadm.c:1974:29: error: =E2=80=98mdfd=E2=80=99 may be used uninitialized=
 in this
>> function [-Werror=3Dmaybe-uninitialized]
>>    if (dv->devname[0] =3D=3D '/' || mdfd < 0)
>>                              ^
>> mdadm.c:1914:7: note: =E2=80=98mdfd=E2=80=99 was declared here
>>    int mdfd;
>>        ^
>> cc1: all warnings being treated as errors
>> Makefile:206: recipe for target 'mdadm.Os' failed
>> make: *** [mdadm.Os] Error 1
>
> Crappy compiler, you're running an old gcc. But sure, send me a patch=20
> that initializes mdfd to -1.

I would rather make the code more obviously correct.

		if (dv->devname[0] =3D=3D '/' ||
		    (mdfd =3D open_dev(dv->devname)) < 0)
			mdfd =3D open_mddev(dv->devname, 1);

well... it is more obvious to me.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljm0PoACgkQOeye3VZi
gbkBSBAAsbQSocpMNzdeNoHr9n160K6SvdGZQceI67D32wcaqBeKyHNMgUnLGoDw
joJBvPlB6lGMCDzu9gTMzALZDdEYw/L43ohcftYH7zLgfBOcQViIIM5JU5/ZJHu7
VnJ0uEALS5mLxDj9XaqqP50zz+lQiQct/JHVoB3XiOGJQlpeLsdW31jRxNZCL/86
tvNFE6bqAVp1y9zyhq5ctmcZb8yNikAKNq+evmmBep1ZkMx+8zKCuLINUZ7NWS0Y
i2Qgb6HMYOU7v7Y5d1/7beFZ6sT0o/HFa6pqwMvUILi5fuCz+dmU9LMpl5MHwl3D
skFNCm7fAqba0mlDx9I8J8bqIBW1N0czUrC6axba6fDEFQIteR6biNxBn2WdvtPI
PfG3+wNUWgKLZH8yyU433bbQ7jgLm1rj3Od4gUO303Ow64biaZykJZP/uyE/HoMO
7uo7BJraI4fPLF/+RlQyYXeikIB1b6dUxgaq4sO0+iKtGH6fdoWk8o0SFtMiqpPu
UAXHr+/ECVS1iLw07C/ZbbydM2xAuGjjIahfDEmCqq3lDrAK9F6kExbaFuebOv2F
8V4cmrE2+KKDVPswqR84t8+LFFFHjqd9NLUEaJisbjxrm946vL3vaDNAZcammq5v
aczVNfKFyzJ7nzteFJ1sal5bdFjAdGfnXikfdv+ggdTh6Sfuzmw=
=UiQ0
-----END PGP SIGNATURE-----
--=-=-=--

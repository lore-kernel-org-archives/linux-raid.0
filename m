From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Possible to change chunk size on RAID-1 without re-init or
 destructive result?
Date: Wed, 27 Mar 2013 22:44:46 +0600
Message-ID: <20130327224446.287a114e@natsu>
References: <CAFCYAsfriik8VAPV9MVhsDtgqHTaKs3kzYoSLVQHaiYKfzjXZw@mail.gmail.com>
	<16639206.20.1364400094382.JavaMail.root@zimbra>
	<CAFCYAsfWTC+Yjkh-XO89M44bxt_7cjBB6kT+xdEfrr4L9QPZRw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/VS=KVP7c7gHQJS4iYgvEt_F"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFCYAsfWTC+Yjkh-XO89M44bxt_7cjBB6kT+xdEfrr4L9QPZRw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/VS=KVP7c7gHQJS4iYgvEt_F
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Mar 2013 09:23:52 -0700
Jeff Johnson <jeff.johnson@aeoncomputing.com> wrote:

> And yet I have this output from /proc/mdstat:
>=20
> md1 : active raid1 sdb3[1] sda3[0]
>       288567164 blocks super 1.1 [2/2] [UU]
>       bitmap: 3/3 pages [12KB], 65536KB chunk
>=20
> It is very strange. the responsiveness on small file i/o tends to
> support the notion that this mirror really has a 64MB chunk size. This
> is practically an order of magnitude larger than what is prudent. The
> iowait on simple things like a sync or writing out small files seems
> to support what mdstat is reporting. Of course, I'd like to change
> this but how to do so without breaking the RAID or risking data is not
> obvious.

This is the array _bitmap_ chunk size. In simple terms, it determines
granularity of array resyncs on unclean shutdowns.

You can change it by

  mdadm --grow /dev/md1 --bitmap=3Dnone

  mdadm --grow /dev/md1 --bitmap=3Dinternal --bitmap-chunk=3D131072

But the size you already have is okay, there is no need to change it, and I=
'd
say certainly no need to lower it (this will decrease performance).

--=20
With respect,
Roman

--Sig_/VS=KVP7c7gHQJS4iYgvEt_F
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFTIf4ACgkQTLKSvz+PZwg+JgCfU1B0VZ4FSmVQAQOYLlsi1G47
L2QAn1k8rW6ZFaMqi5nW++g0gdpG9FFa
=8+Iz
-----END PGP SIGNATURE-----

--Sig_/VS=KVP7c7gHQJS4iYgvEt_F--

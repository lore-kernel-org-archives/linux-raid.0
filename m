From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/2] add support for launching mdmon via systemd
Date: Fri, 18 Jan 2013 20:02:32 +1100
Message-ID: <20130118200232.59d328da@notabene.brown>
References: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pD80d_wuVi0RnNpj95cD7R2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1358498592-20827-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: linux-raid@vger.kernel.org, dledford@redhat.com, harald@redhat.com
List-Id: linux-raid.ids

--Sig_/pD80d_wuVi0RnNpj95cD7R2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Jan 2013 09:43:10 +0100 Jes.Sorensen@redhat.com wrote:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>=20
> Hi,
>=20
> It's been an ongoing issue for a while trying to figure out how to
> handle launching mdmon from the initrd in Fedora and avoid it getting
> killed by systemd due to it ending up in the wrong cgroup (udev).
>=20
> We tried simply attaching mdmon to the cgroup of systemd but it didn't
> really work, and in the end it seems to be more in line with the
> systemd mentality to have systemd spawn it. With these patches and a
> few pending changes to dracut, I am finally able to boot and reboot
> systems with 1 or 2 IMSM arrays.
>=20
> The patch for systemctl is implemented as a compile time option rather
> than a command line option, since I think it is something that the
> distro will decide. However we can make it a command line option if
> preferred.
>=20
> I also have matching systemd .service files for this, which I am happy
> to contribute, but I am not sure if they are useful to other distros
> or not? We haven't had a history of including .service files with
> mdadm.

Thanks.
I'll have a proper look next week, however:
 - I would rather it was a run-time option, not compile time.
   I believe in giving choice to the admin.
 - I would like to include the .service files.  I don't know if we can get
   all distros to use the same one, but we certainly won't if we don't try.

NeilBrown

--Sig_/pD80d_wuVi0RnNpj95cD7R2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUPkPqDnsnt1WYoG5AQL5lxAAwmdVxQwrv9/n7u6r2J8Kc5fUbnqiqn0I
iitqe+zXUlTfl/ymr6tvCTTRvEWNHbmAdYOwibeetS3bCNR/FZEoTN4B8giJ0VYc
sDiMU8EKVmdVoH2XULLH/pEWV+4FweFOljlgyZeEEI7lLVd03SdqwhVtlxGZL9Ow
3bNIzWLvCcvrwy1i1+5jM4EuTl/VxHO7WCftk90XqeS0hnckd/ceYX6X+jAOnXiV
MtxGt2E5SYGC8H1ax/V+wsC/bZxoNrA0dKKwKVIrfML6K3xwKiiZXmoXGLZmTMjE
GM6TUvXKULPyZuQxOs1pJKV0oJSbwWVa7Jy+dwdstP3nuU3J302JaKS3fzv1YCum
dym4zyq/5DkvuLthpnDl3FvWw0mLbCDnk7deA3+2sDx9Yo+exWCc1qxLXe6Y1JJG
YKr7AAN8bC9vIbo6AEwDUsaZDKwPemxQrL6B9ZFYqd4qWbrmCAbYcJqmhM035j7B
oLXTGHkRjLU7q+4Vcgo6k490J4k7qytjk7DHXRvtYpzL1ahEkJXHhCBIpFzVefWE
+ge7JHw0t2UeS1KAa5zYfmHrSUBDu48Ngxa/Dmit2XAGK9i5K9vallp3EVdZ54wC
pOiY9QnfP9Y/Ybbp3P1u1d9STteZjM/Oxl+1nt1YubcKu2jgwZ/rCawZBEX1DrkP
rFZVUsWA2B4=
=Lh7L
-----END PGP SIGNATURE-----

--Sig_/pD80d_wuVi0RnNpj95cD7R2--

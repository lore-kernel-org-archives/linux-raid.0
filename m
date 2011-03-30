From: Roman Mamedov <rm@romanrm.ru>
Subject: Network-based RAID6
Date: Wed, 30 Mar 2011 13:11:57 +0600
Message-ID: <20110330131157.49fd2521@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dFrV2V0C60Mn4zw8vCu3.3J"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/dFrV2V0C60Mn4zw8vCu3.3J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

Let's say I have 10 machines, each having 1TB of free disk space. They
communicate over a gigabit network.

I would like to create a fault-tolerant array from these machines and their
storage, that would match RAID6 in overhead and fault resilience.
That is, it should provide 8 TB of usable space and tolerate a 2-member
failure without data loss.

Does anyone know if any of the current distributed filesystems will meet th=
ese
requirements? Working/stable/non-experimental level code is preferred.

The simple and obvious solution is mdadm over AoE/iSCSI, but maybe there is
something else built with network awareness from ground up, that would be a
better choice?

--=20
With respect,
Roman

--Sig_/dFrV2V0C60Mn4zw8vCu3.3J
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2S170ACgkQTLKSvz+PZwgGsQCbB/Q/h604SWs9juHmKA9xFgRw
e9IAn1WC0wQnfflJDsu5KlF6a1xuhiau
=eI6b
-----END PGP SIGNATURE-----

--Sig_/dFrV2V0C60Mn4zw8vCu3.3J--

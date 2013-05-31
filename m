From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: SSD + Rust as raid1
Date: Fri, 31 May 2013 13:30:18 +0600
Message-ID: <20130531133018.77cd9285@natsu>
References: <51A7C36F.4030605@timedicer.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9hqQiKvd41qoCRqCffm8QOK"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51A7C36F.4030605@timedicer.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Dominic Raferd <dominic@timedicer.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/9hqQiKvd41qoCRqCffm8QOK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 May 2013 22:23:59 +0100
Dominic Raferd <dominic@timedicer.co.uk> wrote:

> I am wanting to (re)set up my raid1 array with 1 SSD partition=20
> (/dev/sda2) and 1 'rust' drive partition (/dev/sdb1) , both 240GB. SSD=20

Sorry but what is "Rust drive partition"? At first I thought it's some
software layer like 'bcache' or some other non-regular block device. Then I
think I got it, but can you please leave at home your own petty cutesy
terminology when asking a serious question on a serious mailing list?

And yes I use a HDD+SSD RAID1 for a very long time, to get some improvement
(though debatable how much) you can also mark the HDD as "write-mostly"
(see man md).

--=20
With respect,
Roman

--Sig_/9hqQiKvd41qoCRqCffm8QOK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGoUYoACgkQTLKSvz+PZwiowwCfdjkVRqOd3GkmWzUUc7R052U4
804AnRA9GvmcFq9R4dWsdcuYtpA82Zra
=Lgwg
-----END PGP SIGNATURE-----

--Sig_/9hqQiKvd41qoCRqCffm8QOK--

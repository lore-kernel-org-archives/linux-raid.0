From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: Problems with invalid superblock
Date: Fri, 17 Feb 2006 14:11:33 -0800
Message-ID: <43F64A15.5040606@ucolick.org>
References: <43F64759.1060503@scinergy.com.br>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1BA10174114B9B25C9021803"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43F64759.1060503@scinergy.com.br>
Sender: linux-raid-owner@vger.kernel.org
To: william@scinergy.com.br
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1BA10174114B9B25C9021803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

William Marques wrote:
> Hi,
> 
> I trying to setup a raid0 without success, using the mdadm 2.3.1
> package, compiled from sources.
> No matters if its linear or stripping raid0 mode, the errors are the same:
> 
> master# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2
> /dev/sda2 /dev/sda3
> master:~# mdadm -E /dev/md0
> mdadm: No md superblock detected on /dev/md0.
...

> But I cant mount the device:
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>        missing codepage or other error
>        In some cases useful info is found in syslog - try
>        dmesg | tail  or so

You did make a file system on md0, right?

/Patrik

--------------enig1BA10174114B9B25C9021803
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFD9kocT+KvsdUW5p8RAu/YAJ9sqmQyWnMDzgc4p+Aa8KEHClboPgCgjV02
rhhssumX6nndMVDoc5/FeyU=
=7u3T
-----END PGP SIGNATURE-----

--------------enig1BA10174114B9B25C9021803--

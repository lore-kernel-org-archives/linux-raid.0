From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/6] imsm: Add --controller-path option for
 --detail-platform.
Date: Wed, 3 Oct 2012 13:37:58 +1000
Message-ID: <20121003133758.6793dbde@notabene.brown>
References: <20121002143506.22678.259.stgit@gklab-128-174.igk.intel.com>
	<506AFC2D.4020308@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=2YjyBUsplY.V.ZXWNnEMdM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <506AFC2D.4020308@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maciej Naruszewicz <maciej.naruszewicz@intel.com>
Cc: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>, linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/=2YjyBUsplY.V.ZXWNnEMdM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Oct 2012 16:37:33 +0200 Maciej Naruszewicz
<maciej.naruszewicz@intel.com> wrote:

> Usually, 'mdadm --detail-platform -e imsm' scans all the controllers
> looking for IMSM capabilities. This patch provides the possibility
> to specify a controller to scan, enabling custom usage by other
> processes - especially with the --export switch.
>=20
> $ mdadm --detail-platform
>         Platform : Intel(R) Matrix Storage Manager
>          Version : 9.5.0.1037
>      RAID Levels : raid0 raid1 raid10 raid5
>      Chunk Sizes : 4k 8k 16k 32k 64k 128k
>      2TB volumes : supported
>        2TB disks : not supported
>        Max Disks : 7
>      Max Volumes : 2 per array, 4 per controller
>   I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
>=20
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.2
>         Platform : Intel(R) Matrix Storage Manager
>          Version : 9.5.0.1037
>      RAID Levels : raid0 raid1 raid10 raid5
>      Chunk Sizes : 4k 8k 16k 32k 64k 128k
>      2TB volumes : supported
>        2TB disks : not supported
>        Max Disks : 7
>      Max Volumes : 2 per array, 4 per controller
>   I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
>=20
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.2 --export
> MD_FIRMWARE_TYPE=3Dimsm
> IMSM_VERSION=3D9.5.0.1037
> IMSM_SUPPORTED_RAID_LEVELS=3Draid0 raid1 raid10 raid5
> IMSM_SUPPORTED_CHUNK_SIZES=3D4k 8k 16k 32k 64k 128k
> IMSM_2TB_VOLUMES=3Dyes
> IMSM_2TB_DISKS=3Dno
> IMSM_MAX_DISKS=3D7
> IMSM_MAX_VOLUMES_PER_ARRAY=3D2
> IMSM_MAX_VOLUMES_PER_CONTROLLER=3D4
>=20
> $ mdadm --detail-platform /sys/devices/pci0000:00/0000:00:1f.0 # This=20
> isn't an IMSM-capable controller
> mdadm: no active Intel(R) RAID controller found under=20
> /sys/devices/pci0000:00/0000:00:1f.0
>=20
> Signed-off-by: Maciej Naruszewicz <maciej.naruszewicz@intel.com>

Much better, thanks.

However there is a lot of line wrapping so I cannot apply it as-is.
Can you send it the same way you've sent previous patches?

Also there is no need to create c.controller_path.  The path name should get
put into devlist->devname, so just pass
    devlist ? devlist->devname : NULL
as the path to Detail_Platform.


Thanks,
NeilBrown


--Sig_/=2YjyBUsplY.V.ZXWNnEMdM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGuzFjnsnt1WYoG5AQLv/hAAvCsDGp4Ja8Pu6gh8/efcEO5+s+gNQ5mn
wC7d/U9EptSQxQLO4danBN57A0DqtOUZWUTCtvGudIQ90217Leu+A/uXXkze4dYw
qBSn3P3FAqoMO5RJ/dh0jjWWc4fTCQtEEygeWnYTJuQUOCaHcM0DIyMZgACrAiLY
7oZKRpepjBjhb965wljbA8+j4lgd+XmcdlPDWlPlJVf/xhLM1RUvwJMwsbdqVIM+
axQ+eDAh6tWsElD1PvAeZuANrV1+cQNA9RRnA037SH14sdmePAL4V6cI2KAb2Uqs
1sXpw1X+OnSUd5ZMbedYKUxuGpmoIK9gZbX8gBgEoXmBZfuDSkzdoR+KHKwDxIvg
73AMSy52beDWlIIv4k7R+9KSyxsydhYQNP+WwYuHnhtADEo/vD0Bu6tEJecZiuNW
f2TLlgayzLowYDa8Uyo9WfRnAQCOVQpFERVa81q3/9sIB1ZNvAxPktd1lhPCoAZw
vI2g85a0NdegbdClNbMAuZ9GjOrcf4UBs+LOIo9yd39OCf/38fA4Mzr61+px7ZF6
YVFM/QajPNjL2BV1nyT4VLPjBjXdfG8t8+Pnpm0w0QF0sUGyobr16fQxFEpcRl3q
3La9id/0uCi4s7jHghXWxBS/8RPbS3FJZG8fo9l+aIgLTMhf8aaQ4LToEEIBdD8W
wqDDciby98Y=
=AObS
-----END PGP SIGNATURE-----

--Sig_/=2YjyBUsplY.V.ZXWNnEMdM--

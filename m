From: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Subject: Re: Script to save array info
Date: Thu, 21 Jun 2012 15:26:13 +0100
Message-ID: <20120621142613.GA28130@calhariz.com>
References: <20120620232149.GA7767@animx.eu.org>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120620232149.GA7767@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 20, 2012 at 07:21:49PM -0400, Wakko Warner wrote:
> After reading some of the stories about lost metadata, I was wondering if
> anyone had a script that would output the member info for each device with
> the device's physical serial number.
>=20
> For a crude one I did this while in /sys/block:
> for x in sd*;do
> 	echo /dev/$x
> 	/lib/udev/scsi_id --export --page=3D0x80 --whitelisted /dev/$x
> 	mdadm -E /dev/$x
> done
>=20
> And saved the output.  It works for me because all but 3 of my raid membe=
rs
> are full disks.
>=20

I made a script for myself, that collects the information by
inspecting /sys instead of doing mdadm -E.  The script see all mdraid
devices and all devices that belong to a mdraid.  I would like to know
if the script works or not.  It works for me.



#!/bin/bash

# $1 - procfile
# $2 - File to log
function cat-file () {
    echo $1 >> $2
    if [ -e $1 ] ; then
        ${CAT} $1 >> $2
    else
        echo "$1 don't exist" >> $2
    fi
    echo >> $2
}


FILEMD=3Dmd-list

echo "Get slot positions of the devices in mdraid" >> ${FILEMD}
for file in /sys/block/md* ; do
    echo $file    >> ${FILEMD}
    for dev in $file/md/rd* ; do
        echo $dev    >> ${FILEMD}
        ls -alF $dev >> ${FILEMD}
    done
    echo >> ${FILEMD}
done

echo "Get more info about devices in mdraid" >> ${FILEMD}
# get info about all devices that are in a mdraid.
# similar to mdadm --examine ?
for file in /sys/block/md* ; do
    echo $file    >> ${FILEMD}
    for dev in $file/md/rd* ; do
        echo $dev    >> ${FILEMD}
        ls -alF $dev >> ${FILEMD}
        for fi in $dev/* ; do
            if test `basename $fi` =3D "block"; then
                ls -alF $fi >> ${FILEMD}
            else
                cat-file $fi ${FILEMD}
            fi
        done
        echo >> ${FILEMD}
    done
    echo >> ${FILEMD}
done



--=20
--

     Jose Calhariz

A coisa mais dif=C3=ADcil de entender no mundo =C3=A9 o imposto de renda

--Albert Einstein

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP4y8FAAoJEDSKd41ohe+PHcYQAKAUZHy1qFRdynDf9Vw5NDXQ
cGX5onb3vvXcud/pufeGoL0GCmMqU25Q+TYl3hr9s5mjFP+18BgRF/s9lMrvAPQi
PBB9HkWnKdMfbrU8Cgj8najfJqpQp7Ku5/0BTcJAeHZys3HrWCIhvxiBEWcl5GE7
RGtO8zokf/9aWe9zjp9I7jokibnHpTPo54H15u4WB+YQNck2I/0o4ajTRP8DkBsN
OjxWvvDLTpd7giAWAv+3iAnCzRr/802+9QWho3E3b+QmHG/wi+xTewQaqCq34vL7
duSbX8+o2YNVeqNYNTL6LG8jbk02h2j/S9/yKZ/XdnWm5ALmVg+3OwVC4giRhvla
M1awVMW9538GETx1kr2NIRtQvxZYK04r+bAh4G+4yEM66OKpW57OoWXpdigGmIo3
RcbarFN3ZT3ynYqO+l1wxDUzSIDGodxT/fB4dKSeRd05aZAhKesUizYhD5udm2Vt
t45bzzWmyoTyj3sR+G1/0TX93t7pW8ir5AHt3KSxpM8cIkxZQa0xzh+kIwT7p/5G
m2pggshxXDz/gWMWvSBonrb8Pr/ILlZ8Cqj0dExIXvmosCRxMTveYI7IcwvAWbAW
iVJfDXsAbZ+ZEJ6g06qTD3EIVLEnCR63XJR3YQX7BRTpV8AYs/Um+3DD2hEmReNn
l6iAEpR6UuUYblniZBcG
=6wk6
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--

From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Mon, 21 Nov 2016 15:32:42 +1100
Message-ID: <877f7xe9lh.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com> <87lgwihc2v.fsf@notabene.neil.brown.name> <20161117150954.GH21587@bitfolk.com> <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com> <87poltfq2d.fsf@notabene.neil.brown.name> <20161118034716.GI21587@bitfolk.com> <87k2c1fn0o.fsf@notabene.neil.brown.name> <20161118041759.GE1804@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161118041759.GE1804@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Andy Smith wrote:

> Hi Neil,
>
> On Fri, Nov 18, 2016 at 03:08:23PM +1100, NeilBrown wrote:
>> Up to you, but I have an idea.
>> The udev rules files depends on 'blkid' having been run.
>>   /lib/udev/rules.d/60-persistent-storage.rules
>> does this, but not for
>>   KERNEL=3D=3D"fd*|mtd*|nbd*|gnbd*|btibm*|dm-*|md*|zram*|mmcblk[0-9]*rpm=
b"
>>=20
>> ... though that wouldn't apply to you.
>>=20
>> what does
>>   udevadm info /dev/sdc
>
> (Since mpt3sas got loaded early the device identifiers have all
> changed; what was sd{a,b} have now shifted to the end as sd{e,f}, so
> the two members of md5 are now sd{a,b})
>
> $ sudo udevadm info /dev/sda
> P: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/end_devic=
e-0:0/target0:0:0/0:0:0:0/block/sda
> N: sda
> S: disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
> S: disk/by-id/wwn-0x5002538c0007e7a8
> S: disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
> E: DEVLINKS=3D/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH2006=
33 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.=
0-sas-0x4433221100000000-lun-0
> E: DEVNAME=3D/dev/sda
> E: DEVPATH=3D/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0=
/end_device-0:0/target0:0:0/0:0:0:0/block/sda
> E: DEVTYPE=3Ddisk
> E: ID_ATA=3D1
> E: ID_ATA_DOWNLOAD_MICROCODE=3D1
> E: ID_ATA_FEATURE_SET_HPA=3D1
> E: ID_ATA_FEATURE_SET_HPA_ENABLED=3D1
> E: ID_ATA_FEATURE_SET_PM=3D1
> E: ID_ATA_FEATURE_SET_PM_ENABLED=3D1
> E: ID_ATA_FEATURE_SET_SECURITY=3D1
> E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=3D0
> E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=3D32
> E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=3D32
> E: ID_ATA_FEATURE_SET_SMART=3D1
> E: ID_ATA_FEATURE_SET_SMART_ENABLED=3D1
> E: ID_ATA_ROTATION_RATE_RPM=3D0
> E: ID_ATA_SATA=3D1
> E: ID_ATA_SATA_SIGNAL_RATE_GEN1=3D1
> E: ID_ATA_SATA_SIGNAL_RATE_GEN2=3D1
> E: ID_ATA_WRITE_CACHE=3D1
> E: ID_ATA_WRITE_CACHE_ENABLED=3D1
> E: ID_BUS=3Data
> E: ID_FS_LABEL=3Dtbd:5
> E: ID_FS_LABEL_ENC=3Dtbd:5
> E: ID_FS_TYPE=3Dlinux_raid_member

This is encouraging.  It means that blkid ran and udev knows that this
is part of an md array.

However there are no "MD_" ... I guess that is normal if the latest udev
event happened after the array was assembled.

If you still want to get to the bottom of this, you might need to revert
your work-around, the try the "udevadm monitor" and "udevadm info" and "ude=
vadm
trigger" while the array is not assembled.

You could possibly try stopping the array, then running "udevadm
trigger".
If that works, you revert the recent change to module loading.
If it doesn't result in the array being assembled, then would be a good
time to try "udevadm info" again.

NeilBrown


> E: ID_FS_USAGE=3Draid
> E: ID_FS_UUID=3D957030cf-c09f-023d-ceae-bb27e546f095
> E: ID_FS_UUID_ENC=3D957030cf-c09f-023d-ceae-bb27e546f095
> E: ID_FS_UUID_SUB=3D4ac82c29-2d10-9465-7fff-9b228c411c1e
> E: ID_FS_UUID_SUB_ENC=3D4ac82c29-2d10-9465-7fff-9b228c411c1e
> E: ID_FS_VERSION=3D1.2
> E: ID_MODEL=3DSAMSUNG_MZ7KM1T9HAJM-00005
> E: ID_MODEL_ENC=3DSAMSUNG\x20MZ7KM1T9HAJM-00005\x20\x20\x20\x20\x20\x20\x=
20\x20\x20\x20\x20\x20\x20\x20
> E: ID_PATH=3Dpci-0000:01:00.0-sas-0x4433221100000000-lun-0
> E: ID_PATH_TAG=3Dpci-0000_01_00_0-sas-0x4433221100000000-lun-0
> E: ID_REVISION=3DGXM1003Q
> E: ID_SERIAL=3DSAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
> E: ID_SERIAL_SHORT=3DS2HNNAAH200633
> E: ID_TYPE=3Ddisk
> E: ID_WWN=3D0x5002538c0007e7a8
> E: ID_WWN_WITH_EXTENSION=3D0x5002538c0007e7a8
> E: MAJOR=3D8
> E: MINOR=3D0
> E: SUBSYSTEM=3Dblock
> E: TAGS=3D:systemd:
> E: UDEV_LOG=3D7
> E: USEC_INITIALIZED=3D38597
>
> Cheers,
> Andy

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYMnjqAAoJEDnsnt1WYoG5SMcP/A41AYNyverfcA7pwp4pdy5e
B22fl4hLAhwHz+QBC67yioViFtUxyYfvpZQpneM9I2pfs2VURiKHkPZo47D/VEpq
Bhc8cs7ekGfLQh45/XgOWVQpTlRV8pJj9YtLFdfaVPXzeSvzCQGkNYSVXriUd8qb
I8t7w9iTwX/G+iOWGRHjSuW4MIW7DL3JdXrQOq16GsG8a6fnJAUwV1K8zMsz84E9
5MOaa7lMgOZBUG/uRmM8Ned46aedw3Y9rtZLptxqB53xmicM7iyhzOn1y39yKqfS
117ccmjTT6Y08zbCYa4DjL/41rEfadgnKYef77te4VuOhO5pYCki/lkFyaAJj1UZ
SbxpW5/HD5Bc2u1CvVd89S+bRBHhKCB+qvFr3XriVPYdGLqpQZ4XrPXEZnwmQ1ZG
V/nQ1/mcXxaKik4eYcRM1NbOITvonrIqAWg+XE2yo2pmpBCGh54PphUdllvj/nV7
2ynzLb0/BPkW8f2NDk9GpmltCZZH6c64Ku9PNiUcJe2cwmzT2vEyu8Z3EFsCxd2M
qJ8HVzrLVKjavgAhfu0qdiv0AuPdxkJ/f371X8wYhuX8lXBzoY6/w4o2Sx0ecm62
4ZQgi2sT3lHcwyAJbc0HpBbGgndT1TwtboMzoWIGvsCKbopA3qVP9Bgj32RgkjlS
zn0Qds0tW5tL3+C2CDPg
=IIjH
-----END PGP SIGNATURE-----
--=-=-=--

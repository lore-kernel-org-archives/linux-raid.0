From: NeilBrown <neilb@suse.de>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Thu, 18 Sep 2014 21:09:42 +1000
Message-ID: <20140918210942.113acb17@notabene.brown>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com>
	<20140912082403.549fc298@notabene.brown>
	<164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com>
	<BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com>
	<20140915101830.3c85d423@notabene.brown>
	<DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com>
	<20140918200347.762845bb@notabene.brown>
	<D28F9C01-C75C-4B69-932F-FA2425DEDDB4@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ibZ38w9WlEBwIngqv2DvJIj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D28F9C01-C75C-4B69-932F-FA2425DEDDB4@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Schindler <marco.schindler@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ibZ38w9WlEBwIngqv2DvJIj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Sep 2014 12:38:55 +0200 Marco Schindler
<marco.schindler@gmail.com> wrote:

>=20
> On 18.09.2014, at 12:03, NeilBrown <neilb@suse.de> wrote:
>=20
> > Getting a "change" even on spindown is causing the problem I suspect.
> > A change in 3.3.1 causes "mdadm -I" to be run on a device when it 'chan=
ges'.
> > That will read from the device which will wake it up.
> > (commit 25392f5fc59f96fb76 - revert it and the symptom will probably go=
 away).
> >=20
> > I really think the "bug" here is that the change event is emitted on
> > 'spindown', but maybe the bug is that the exact meaning of 'change' isn=
't
> > well documented.
> >=20
> > I can probably get "mdadm -I" to use O_EXCL which will fail on devices
> > already in an array, but I'm not sure that is a complete solution.  You=
 could
> > still get wakeups on other devices.
> >=20
> > Can you rung the 'udevadm monitor' again, but this time with '--propert=
y'.
> > Maybe there is some property associated with spindown events which we c=
an use
> > to ignore them.
> >=20
> > NeilBrown
>=20
> sure. I also took separate logs for standby and wakeup.
>=20
> change events only occur when the drive goes standby (see below).
> strangely enough, there are no events when the drive wakes up.
>=20
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
...


Thanks.  There is nothing there which point to the device being spun down.
I tried spinning down disks on a couple of machines and no udev events were
created.  So I'm a bit suspicious that there is something I'm missing.

How exactly do you spin down the devices?
I use "hdparm -Y /dev/sda" or "hdparm -S 1 /dev/sda".

NeilBrown






>=20
> KERNEL[558130.868218] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/sda
> DEVPATH=3D/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/en=
d_device-0:0/target0:0:0/0:0:0:0/block/sda
> DEVTYPE=3Ddisk
> MAJOR=3D8
> MINOR=3D0
> SEQNUM=3D3239
> SUBSYSTEM=3Dblock
>=20
> KERNEL[558132.028485] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
> ACTION=3Dchange
> DEVNAME=3D/dev/sdb
> DEVPATH=3D/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/en=
d_device-0:1/target0:0:1/0:0:1:0/block/sdb
> DEVTYPE=3Ddisk
> MAJOR=3D8
> MINOR=3D16
> SEQNUM=3D3240
> SUBSYSTEM=3Dblock
>=20
> UDEV  [558139.263973] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
> ACTION=3Dchange
> DEVLINKS=3D/dev/disk/by-id/ata-WDC_WD20EARS-00S8B1_WD-WCAVY1872131 /dev/d=
isk/by-id/wwn-0x50014ee203dca984 /dev/disk/by-path/pci-0000:09:00.0-sas-0x4=
433221103000000-lun-0
> DEVNAME=3D/dev/sda
> DEVPATH=3D/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/en=
d_device-0:0/target0:0:0/0:0:0:0/block/sda
> DEVTYPE=3Ddisk
> ID_ATA=3D1
> ID_ATA_DOWNLOAD_MICROCODE=3D1
> ID_ATA_FEATURE_SET_AAM=3D1
> ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=3D254
> ID_ATA_FEATURE_SET_AAM_ENABLED=3D0
> ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=3D128
> ID_ATA_FEATURE_SET_HPA=3D1
> ID_ATA_FEATURE_SET_HPA_ENABLED=3D1
> ID_ATA_FEATURE_SET_PM=3D1
> ID_ATA_FEATURE_SET_PM_ENABLED=3D1
> ID_ATA_FEATURE_SET_PUIS=3D1
> ID_ATA_FEATURE_SET_PUIS_ENABLED=3D0
> ID_ATA_FEATURE_SET_SECURITY=3D1
> ID_ATA_FEATURE_SET_SECURITY_ENABLED=3D0
> ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=3D408
> ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=3D408
> ID_ATA_FEATURE_SET_SMART=3D1
> ID_ATA_FEATURE_SET_SMART_ENABLED=3D1
> ID_ATA_SATA=3D1
> ID_ATA_SATA_SIGNAL_RATE_GEN1=3D1
> ID_ATA_SATA_SIGNAL_RATE_GEN2=3D1
> ID_ATA_WRITE_CACHE=3D1
> ID_ATA_WRITE_CACHE_ENABLED=3D1
> ID_BUS=3Data
> ID_FS_LABEL=3Dalina.o81.5:media3
> ID_FS_LABEL_ENC=3Dalina.o81.5:media3
> ID_FS_TYPE=3Dlinux_raid_member
> ID_FS_USAGE=3Draid
> ID_FS_UUID=3D058bd7b0-455c-0d7e-6de0-a845ea05ee38
> ID_FS_UUID_ENC=3D058bd7b0-455c-0d7e-6de0-a845ea05ee38
> ID_FS_UUID_SUB=3Dda1c1cad-6661-174c-b0b9-4bc1a712902d
> ID_FS_UUID_SUB_ENC=3Dda1c1cad-6661-174c-b0b9-4bc1a712902d
> ID_FS_VERSION=3D1.2
> ID_MODEL=3DWDC_WD20EARS-00S8B1
> ID_MODEL_ENC=3DWDC\x20WD20EARS-00S8B1\x20\x20\x20\x20\x20\x20\x20\x20\x20=
\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
> ID_PATH=3Dpci-0000:09:00.0-sas-0x4433221103000000-lun-0
> ID_PATH_TAG=3Dpci-0000_09_00_0-sas-0x4433221103000000-lun-0
> ID_REVISION=3D80.00A80
> ID_SERIAL=3DWDC_WD20EARS-00S8B1_WD-WCAVY1872131
> ID_SERIAL_SHORT=3DWD-WCAVY1872131
> ID_TYPE=3Ddisk
> ID_WWN=3D0x50014ee203dca984
> ID_WWN_WITH_EXTENSION=3D0x50014ee203dca984
> MAJOR=3D8
> MINOR=3D0
> SEQNUM=3D3239
> SUBSYSTEM=3Dblock
> USEC_INITIALIZED=3D2003
>=20
> UDEV  [558139.293742] change   /devices/pci0000:00/0000:00:06.0/0000:09:0=
0.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
> ACTION=3Dchange
> DEVLINKS=3D/dev/disk/by-id/ata-WDC_WD20EARS-00S8B1_WD-WCAVY1879365 /dev/d=
isk/by-id/wwn-0x50014ee25931e63a /dev/disk/by-path/pci-0000:09:00.0-sas-0x4=
433221102000000-lun-0
> DEVNAME=3D/dev/sdb
> DEVPATH=3D/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/en=
d_device-0:1/target0:0:1/0:0:1:0/block/sdb
> DEVTYPE=3Ddisk
> ID_ATA=3D1
> ID_ATA_DOWNLOAD_MICROCODE=3D1
> ID_ATA_FEATURE_SET_AAM=3D1
> ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=3D254
> ID_ATA_FEATURE_SET_AAM_ENABLED=3D0
> ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=3D128
> ID_ATA_FEATURE_SET_HPA=3D1
> ID_ATA_FEATURE_SET_HPA_ENABLED=3D1
> ID_ATA_FEATURE_SET_PM=3D1
> ID_ATA_FEATURE_SET_PM_ENABLED=3D1
> ID_ATA_FEATURE_SET_PUIS=3D1
> ID_ATA_FEATURE_SET_PUIS_ENABLED=3D0
> ID_ATA_FEATURE_SET_SECURITY=3D1
> ID_ATA_FEATURE_SET_SECURITY_ENABLED=3D0
> ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=3D408
> ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=3D408
> ID_ATA_FEATURE_SET_SMART=3D1
> ID_ATA_FEATURE_SET_SMART_ENABLED=3D1
> ID_ATA_SATA=3D1
> ID_ATA_SATA_SIGNAL_RATE_GEN1=3D1
> ID_ATA_SATA_SIGNAL_RATE_GEN2=3D1
> ID_ATA_WRITE_CACHE=3D1
> ID_ATA_WRITE_CACHE_ENABLED=3D1
> ID_BUS=3Data
> ID_FS_LABEL=3Dalina.o81.5:media3
> ID_FS_LABEL_ENC=3Dalina.o81.5:media3
> ID_FS_TYPE=3Dlinux_raid_member
> ID_FS_USAGE=3Draid
> ID_FS_UUID=3D058bd7b0-455c-0d7e-6de0-a845ea05ee38
> ID_FS_UUID_ENC=3D058bd7b0-455c-0d7e-6de0-a845ea05ee38
> ID_FS_UUID_SUB=3Dade4cbb9-501c-cd2c-00b2-607f1699133b
> ID_FS_UUID_SUB_ENC=3Dade4cbb9-501c-cd2c-00b2-607f1699133b
> ID_FS_VERSION=3D1.2
> ID_MODEL=3DWDC_WD20EARS-00S8B1
> ID_MODEL_ENC=3DWDC\x20WD20EARS-00S8B1\x20\x20\x20\x20\x20\x20\x20\x20\x20=
\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
> ID_PATH=3Dpci-0000:09:00.0-sas-0x4433221102000000-lun-0
> ID_PATH_TAG=3Dpci-0000_09_00_0-sas-0x4433221102000000-lun-0
> ID_REVISION=3D80.00A80
> ID_SERIAL=3DWDC_WD20EARS-00S8B1_WD-WCAVY1879365
> ID_SERIAL_SHORT=3DWD-WCAVY1879365
> ID_TYPE=3Ddisk
> ID_WWN=3D0x50014ee25931e63a
> ID_WWN_WITH_EXTENSION=3D0x50014ee25931e63a
> MAJOR=3D8
> MINOR=3D16
> SEQNUM=3D3240
> SUBSYSTEM=3Dblock
> USEC_INITIALIZED=3D2361

--Sig_/ibZ38w9WlEBwIngqv2DvJIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVBq9djnsnt1WYoG5AQJJTw/7BTBZ5cpXbwTU6DHS9cFwlstCCFjs0SdY
UVO5wUsz5qnuhxZ6f5g3J2ZliBUYJmfkC6fELe/yrF6r4F46lrEtEfzbWXl9HCKY
TLvr8oVz4AAj7ERKoFeryWz41VTaJVlGr9kllu9GhvPGjRHtUVXXBeBSER2OrdLB
wWAq1MC4O1pV8ZfnH7fb0c4c85GjGGvqJVS62l3HPUdZH+VGNLDxxYK9e6pbY/DR
DNw6OyyUf6bJFXmn1sKiIJTykZeUoimfhFzksNdnJP/1uZ0QXWDgtySo6gZRXUtw
cU+gwbZIBzy2o2VGvzQUimAi+vZGakzx6vce8XKbkqxx8IW0DAtVTD+JyFFjRqU2
OCYCEZsR/qzz1Pu2MyWUkP8NOZTQn6w/jd41b7wHNh5O/Ye/fztPo3BFMI4Ccrka
jE2iw23hBHUEIuHgouShzQ6rdiz/YdK5DLSudGykUhHRgkOE5GAaPZM9CoVF/5PW
h0R9Uk2PgHeV+PZXQ9vwrD/sTPOsK+Ls6Net1m5jb57r2BGJuAr+P1CLY4bgJe6h
/4MP585yuqp7E5wPELe5F4wfRZefckhElqTsA2Jm5kdW/yQi3irLVguINBcf2e5w
IewyJTTAsb7wM7QrfTUUCz5ED05u+cZg4Z+mD236VUsdD+TqkKHgcZNJOVr4vNSO
so1/UZBqesc=
=fZsS
-----END PGP SIGNATURE-----

--Sig_/ibZ38w9WlEBwIngqv2DvJIj--

From: NeilBrown <neilb@suse.com>
Subject: Re: Recover filenames from failed RAID0
Date: Fri, 15 Jul 2016 14:07:37 +1000
Message-ID: <87a8hjczna.fsf@notabene.neil.brown.name>
References: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAVC+N5m74MyDqZamHgy71vRMhcEY8w_OkiG-GMQKU=JG-QkxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michel Dubois <michel.dubois.mtl@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Jul 11 2016, Michel Dubois wrote:

> Dear linux-raid mailing list,
>
> I have a RAID0 array of four 3TB disks that failed on the "third" disk.

Posting to the list is sensible.  Posting to lots of over vaguely
related people like you did is not appreciated.

>
> I am aware of the non-redundancy of RAID0 but I would like to recover the
> filenames from that RAID0. If I could recover some data it would be a
> bonus.

If you lose one drive from a RAID0, you have effectively lost
everything.  This includes file names and data.

An expert in filesystem forensics might be able to recover some bits,
but it would be a lot of work very fairly little expected reward.

>
> Below you'll find the outputs of the following commands
>  mdadm --examine /dev/sd[abcd]1
>  fdisk -l
>
> where sda1, sdb1, sdc1 and sdd1 should be the 4 RAID devices.

The information you provide describes a 4-drive RAID1, not RAID0.

All the data should equally be on all devices.

Can't you just
  mount /dev/md0 /mnt

and access the files?
What does "fsck -n /dev/md0" report?

what sort of filesystem did you have on /dev/md0??

NeilBrown


>
> What could be my next step?
>
> I thank you for your time
>
> Michel Dubois
>
> ======================
> mdadm --examine /dev/sd[abcd]1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db60 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     0       8        1        0      active sync   /dev/sda1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db72 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     1       8       17        1      active sync   /dev/sdb1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 7d247a6e:7b5d46c8:f52d9c89:db304b21
>   Creation Time : Mon Apr 23 19:55:36 2012
>      Raid Level : raid1
>   Used Dev Size : 20980800 (20.01 GiB 21.48 GB)
>      Array Size : 20980800 (20.01 GiB 21.48 GB)
>    Raid Devices : 4
>   Total Devices : 3
> Preferred Minor : 0
>
>     Update Time : Mon Jun 27 21:12:23 2016
>           State : clean
>  Active Devices : 3
> Working Devices : 3
>  Failed Devices : 1
>   Spare Devices : 0
>        Checksum : 1a57db86 - correct
>          Events : 164275
>
>
>       Number   Major   Minor   RaidDevice State
> this     3       8       33        3      active sync   /dev/sdc1
>
>    0     0       8        1        0      active sync   /dev/sda1
>    1     1       8       17        1      active sync   /dev/sdb1
>    2     2       0        0        2      faulty removed
>    3     3       8       33        3      active sync   /dev/sdc1
>
> ======================
> fdisk -l
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk
> doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sda: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x03afffbe
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1      267350  2147483647+  ee  EFI GPT
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdb'! The util fdisk
> doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sdb: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x142a889c
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdb1               1      267350  2147483647+  ee  EFI GPT
>
> WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fdisk
> doesn't support GPT. Use GNU Parted.
>
>
> Disk /dev/sdc: 3000.5 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders
> Units = cylinders of 16065 * 512 = 8225280 bytes
> Disk identifier: 0x3daebd50
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdc1               1      267350  2147483647+  ee  EFI GPT
>
> Disk /dev/md0: 21.4 GB, 21484339200 bytes
> 2 heads, 4 sectors/track, 5245200 cylinders
> Units = cylinders of 8 * 512 = 4096 bytes
> Disk identifier: 0x00000000
>
> Disk /dev/md0 doesn't contain a valid partition table

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXiGGLAAoJEDnsnt1WYoG59ugP/Am//yXowmEi/3WbMnMlrBQT
aIHXjiFrlx37dw6bXm0ShKB1cMOlEgwU1r6lPy+aOvS1BaY477/vgJzjmco6zmmZ
JFa3sJZ/JGoYaaxGSn8sXLdFuVQoGo9k9c+V878uE/kcL+aGOnLYxtDu2w/dBNdG
CWw5qrlnu6q5DKOqIeYJiD+Q8LfYDczffRsi7dZMNQ8oYM6JDnfTJcDOWpEzNMw6
K5YirUvtaxPJCOZRqsRcWhBxtyo7KmAMz808uECssFPaLZ6QUNesXSFrNG1Yz/f4
6Q990hP9EO7G4pOi7TIaJ98WBFY82xvWmGXb8q+CDyUyWyQbzNnYHNuLiB7Oz1Dv
p292yMD7I9XY/r4ivptvvpKV1/135c/AUGg2CwgTTAJcFkSQj5Klha31TrwO49Fh
c9rHSbESsBJV6sFbMWuPXCWSWbWxSv960zkq/KbGP1rUCUPRswYnNtaajWH48zPn
hKbGvd5vDJDirc4eu+GCPMebhaBUn0vTLX1Z2o+WQtcc3fnt2EpuEQnjyPn5CiCm
n9k84RWzLuNDqxMZrl9hVyV50Ovpgwr9/o+m7i2Y15MoeSS3bPzaF9fT8P2uxTTg
7JH1IEtsv9F7iPRN0RWtXzsntfXnYt4qI5rYfWGnIHtP07o1kXVDrbroe/WlD37X
AG/NRhJBeUYyPn3aMUre
=C/2w
-----END PGP SIGNATURE-----
--=-=-=--

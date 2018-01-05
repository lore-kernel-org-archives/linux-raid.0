From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: SMART detects pending sectors; take offline?
Date: Fri, 5 Jan 2018 18:32:13 +0800
Message-ID: <3C0276EA-F63E-4CD8-A41E-2EEAAADA9A22@fnarfbargle.com>
References: <629d29b4-a3ae-533f-bdba-f115e99d8ce4@shenkin.org> <7bf0a71e-6cb7-59bc-695b-54ed6b08112b@turmel.org> <d86c80ba-7703-1591-7816-00d0d9408386@shenkin.org> <a5487193-24e6-879b-bd09-caf5f75c8fcc@turmel.org> <05e4489d-98ea-4d12-02d6-f13a98e3d5d4@shenkin.org> <201ea04e-1a03-fc83-c31c-146b50bb8624@thelounge.net> <47ec07c3-25ae-9595-78a2-8420c106f2a0@fnarfbargle.com> <20497c70-140d-c4dd-0201-816477bd467f@shenkin.org> <14f1fce1-2959-e051-f7c8-1d98951d744a@fnarfbargle.com> <07170cf8-d951-013b-7e67-eee54aa60c65@shenkin.org> <61e91b55-5b96-143e-15c8-4a320f89eeb2@turmel.org> <ae183814-248b-2d45-8074-85787fcd0d61@shenkin.org> <6572ed42-8559-84eb-0468-7823786c3001@turmel.org> <7bce6228-0695-ff30-7cc0-60486be128ff@shenkin.org> <c24ffbc6-6ba6-ef04-76f3-2217fe5f4926@shenkin.org> <97c75be5-1988-0e
 66-0d50-f06188418b3b@fnarfbargle.com> <cd34964a-e269-6dd7-3c36-73a9c8dbb61d@shenkin.org> <bc2e597b-1585-f9b6-ef1a-f1aa3e1f39a0@fnarfbargle.com> <85891f3d-eaf6-9127-b55a-dea9d21d180b@fnarfbargle.com> <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <35f51be7-7dbd-88f8-e743-3976bef51de2@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: Phil Turmel <philip@turmel.org>, Reindl Harald <h.reindl@thelounge.net>, Edward Kuns <eddie.kuns@gmail.com>, Mark Knecht <markknecht@gmail.com>, Wols Lists <antlists@youngman.org.uk>, Carsten Aulbert <carsten.aulbert@aei.mpg.de>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yep, it's in swap. Check the sector you wrote against the sector ranges list=
ed in the parted print. All good to go.

> On 5 Jan 2018, at 6:10 PM, Alexander Shenkin <al@shenkin.org> wrote:
>=20
>> On 1/5/2018 5:25 AM, Brad Campbell wrote:
>>> On 05/01/18 13:20, Brad Campbell wrote:
>>> You re-wrote Sectors 5857843312+7 on the disk.
>>> Add those two and we get 5844545408 sectors. So if my maths is any good
>>> you wrote a block 13297904 sectors from the end of the data area.
>> I can't believe I did that. No, you wrote a block ~6M *after* the data ar=
ea and you should be fine.
>> I'm going to go and write a letter of apology to my primary school maths t=
eacher now.
>=20
> Thanks much, Brad.  fdisk & parted output are below.  I have swap space mo=
unted on /dev/sda4, 15,984,640 sectors long, after the partitions used for r=
aid.  I'm not sure where exactly the parity data sits... Looks to me like th=
is happened in swap space, no?  Currently, swapon reports 552,272 kb (=3D 1,=
104,544 sectors) in use (i think).  If that's contiguous, then the write sho=
uld have happened after the used space (13,297,904 > 1,104,544). But I'm not=
 sure swap is contiguous.  In this case, regardless, I suspect I should just=
 reboot, and then run checkarray to be safe?
>=20
> One followup: is parity info stored in a separate area than data info on t=
he disk?  If the write *had* fallen within the raid partition area, would yo=
u indeed be able to tell if it overwrote data vs parity vs both?  Google wou=
ldn't tell me...
>=20
> Thanks again,
> Allie
>=20
>=20
> user@machinename:~$ sudo fdisk -l /dev/sda*
>=20
> WARNING: GPT (GUID Partition Table) detected on '/dev/sda'! The util fdisk=
 doesn't support GPT. Use GNU Parted.
>=20
>=20
> Disk /dev/sda: 3000.6 GB, 3000592982016 bytes
> 255 heads, 63 sectors/track, 364801 cylinders, total 5860533168 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
>   Device Boot      Start         End      Blocks   Id  System
> /dev/sda1               1  4294967295  2147483647+  ee  GPT
> Partition 1 does not start on physical sector boundary.
>=20
> Disk /dev/sda1: 1998 MB, 1998585856 bytes
> 255 heads, 63 sectors/track, 242 cylinders, total 3903488 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sda1 doesn't contain a valid partition table
>=20
> Disk /dev/sda2: 1 MB, 1048576 bytes
> 255 heads, 63 sectors/track, 0 cylinders, total 2048 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sda2 doesn't contain a valid partition table
>=20
> Disk /dev/sda3: 2990.4 GB, 2990407680000 bytes
> 255 heads, 63 sectors/track, 363563 cylinders, total 5840640000 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sda3 doesn't contain a valid partition table
>=20
> Disk /dev/sda4: 8184 MB, 8184135680 bytes
> 255 heads, 63 sectors/track, 994 cylinders, total 15984640 sectors
> Units =3D sectors of 1 * 512 =3D 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disk identifier: 0x00000000
>=20
> Disk /dev/sda4 doesn't contain a valid partition table
>=20
>=20
>=20
>=20
>=20
> user@machinename:~$ sudo parted /dev/sda 'unit s print'
> Model: ATA ST3000DM001-9YN1 (scsi)
> Disk /dev/sda: 5860533168s
> Sector size (logical/physical): 512B/4096B
> Partition Table: gpt
>=20
> Number  Start        End          Size         File system     Name Flags
> 1      2048s        3905535s     3903488s                     boot  raid
> 2      3905536s     3907583s     2048s                        grubbios  bi=
os_grub
> 3      3907584s     5844547583s  5840640000s  ext4            main  raid
> 4      5844547584s  5860532223s  15984640s    linux-swap(v1)  swap
>=20
>=20
> user@machinename:~$ swapon --summary
> Filename                                Type            Size    Used Prior=
ity
> /dev/sda4                               partition       7992316 552272  -1=

> /dev/sdb4                               partition       7992316 0       -2=

> /dev/sdc4                               partition       7992316 0       -3=

>=20
>=20


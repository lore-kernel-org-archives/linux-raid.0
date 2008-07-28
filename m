From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: Re: 64k Page size + ext3 errors
Date: Mon, 28 Jul 2008 16:42:55 -0700 (PDT)
Message-ID: <153154.27693.qm@web81301.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Roger,
=A0=A0 I did sync after I copied the 128MB data. Isn't that should guar=
antee data is flushed to disk ? I am using "sum" command to check if da=
ta file is copied to Disk is valid or not.=20
Here=A0is more information.
setup: Created /dev/md0 of 30GB size , created ext3 files system. Then =
started SAMBA server to export mountded /dev/md0 to a windows machine t=
o run IO and copy files.
4K Page size:
-------------------
1. IO Meter Test: Works just fine.
2. Copied 1.8 GB file and check sum is good.
3. Performance is not good because of small page size.
16k Page size:
---------------------
1. RAID-5 fails some times with " Attempt to access beyond the end of d=
evice"
2. Copied 128MB and 385MB file. Checked check sum, they are matching ch=
eck sum.
3. Copied 1.8 GB file , this failed checksum test using "sum" command. =
I see "EXT3-fs errors".
64K Page size:
----------------------
1. RAID-5 failes some times with "Attempt to access beyond the end of d=
evice"
2. Able to copy 128MB data and check sum test passed.
3. Copying 385MB and 1.8 GB file with EXT3-fs errors.
Thanks,
Marri


----- Original Message ----
=46rom: Roger Heflin <rogerheflin@gmail.com>
To: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Cc: linux-raid@vger.kernel.org
Sent: Sunday, July 27, 2008 7:10:07 PM
Subject: Re: 64k Page size + ext3 errors

tirumalareddy marri wrote:
> I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-fs=
 errors when I use 64K page size. When I use 4K page size I don't see a=
ny issue. As many of you know, we will get better performance when we s=
tore bigger files like videos.
>=A0=20
> When I copy 128MB size files using 64k page size no issues seen. When=
 I tried to copy 1.8 GB file with 64KB page size support I am seeing th=
e following errors. Any clue what could be wrong.=20
>=A0=20
> Errors 1:
> EXT3-fs error (device md0): ext3_new_block: Allocating block in syste=
m zone - blocks from 65533, length 1
> EXT3-fs error (device md0): ext3_new_block: Allocating block in syste=
m zone - blocks from 65534, length 1
>=A0=20
>=A0=20
> Errors2:
> EXT3-fs error (device md0): ext3_readdir: bad entry in directory #2: =
rec_len % 4 !=3D 0 - offset=3D0, inode=3D3040
>=20


All that error means is that something screwed up the filesystem stuff =
when you=20
copied the large file.

The lack of an error in the first case does not mean that the correct s=
tuff was=20
written to the filesystem, just that nothing screwed up the internal fi=
lesystem=20
data, or that the cache saved you.

I would suggest setting up a simple test using no filesystem and all, a=
nd make=20
sure that the correct data can be read and written (and a large enough =
amount of=20
data that you are not reading out of cache) from the MD device directly=
, write a=20
=A0 specific pattern that would have lots of unique data.=A0 If you don=
't do enough=20
data then things *WILL* be coming from cache and still could be screwed=
 up on=20
disk, and this may be what is going on in the case of the 128MB=A0 vs 1=
=2E8GB case,=20
in both cases it may be wrong on disk, but with the 128MB case is comin=
g from=20
cache, and in the 1.8GB case is coming off disk.

=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 Rog=
er
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: tirumalareddy marri <tirumalareddymarri@yahoo.com>
Subject: 64k Page size + ext3 errors
Date: Sun, 27 Jul 2008 16:28:18 -0700 (PDT)
Message-ID: <576234.24141.qm@web81307.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am using HW accelerated XOR engine for RAID-5 . I am seeing EXT3-fs e=
rrors when I use 64K page size. When I use 4K page size I don't see any=
 issue. As many of you know, we=A0will get better performance when we s=
tore bigger files like videos.
=A0
When I copy 128MB size files using 64k page size no issues seen. When I=
 tried to copy 1.8 GB file with 64KB page size support I am seeing the =
following errors. Any clue what could be wrong.=20
=A0
Errors 1:
EXT3-fs error (device md0): ext3_new_block: Allocating block in system =
zone - blocks from 65533, length 1
EXT3-fs error (device md0): ext3_new_block: Allocating block in system =
zone - blocks from 65534, length 1
=A0
=A0
Errors2:
EXT3-fs error (device md0): ext3_readdir: bad entry in directory #2: re=
c_len % 4 !=3D 0 - offset=3D0, inode=3D3040

=A0
Thanks in Advance,
Marri
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

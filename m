From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT corruption on Primary Header, backup OK, fixing primary nuked
 array -- help?
Date: Tue, 26 Jul 2016 09:55:59 -0600
Message-ID: <CAJCQCtTUO9nLRDUVQ+nkykiQ2ebc-SO8Oh9VP3_WMVKO2fs7dw@mail.gmail.com>
References: <5796B46B.6060905@suddenlinkmail.com> <413b1150-ca38-1907-ea5d-b68ad2f75710@websitemanagers.com.au>
 <5796F4E0.9070206@suddenlinkmail.com> <57971D3C.8040602@suddenlinkmail.com> <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQ73Tp_ps57qgDm=S_qdFMHy8J0Z=kB+_TfQD2ugj_6ow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

#  tr '\0' '\377' < /dev/zero > /dev/VG/1
## then used gdisk to create new GPT and a single partition
# hexdump -C /dev/VG/1

[root@f24s ~]# hexdump -C /dev/VG/1
00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
000001b0  ff ff ff ff ff ff ff ff  00 00 00 00 00 00 00 fe  |................|
000001c0  ff ff ee ff ff ff 01 00  00 00 ff ff 9f 00 00 00  |................|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI PART....\...|
00000210  6d c0 57 bd 00 00 00 00  01 00 00 00 00 00 00 00  |m.W.............|
00000220  ff ff 9f 00 00 00 00 00  22 00 00 00 00 00 00 00  |........".......|
00000230  de ff 9f 00 00 00 00 00  dc 74 3e 4a 76 e2 b6 44  |.........t>Jv..D|
00000240  8d 30 bd d8 07 62 45 f8  02 00 00 00 00 00 00 00  |.0...bE.........|
00000250  80 00 00 00 80 00 00 00  3f d0 39 d5 00 00 00 00  |........?.9.....|
00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000400  0f 88 9d a1 fc 05 3b 4d  a0 06 74 3f 0f 84 91 1e  |......;M..t?....|
00000410  b9 3b b1 50 5f 9f 80 47  a7 82 44 cc 2b 52 56 98  |.;.P_..G..D.+RV.|
00000420  00 08 00 00 00 00 00 00  de ff 9f 00 00 00 00 00  |................|
00000430  00 00 00 00 00 00 00 00  4c 00 69 00 6e 00 75 00  |........L.i.n.u.|
00000440  78 00 20 00 52 00 41 00  49 00 44 00 00 00 00 00  |x. .R.A.I.D.....|
00000450  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00004400  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
^C

And then wiping with 1's again, mdadm -C with default v1.2 metadata on
the whole device.

00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00001000  fc 4e 2b a9 01 00 00 00  00 00 00 00 00 00 00 00  |.N+.............|
00001010  f9 b7 39 86 d6 37 9b c4  04 b8 f2 a8 91 ef 8b 8b  |..9..7..........|
00001020  66 32 34 73 3a 30 00 00  00 00 00 00 00 00 00 00  |f24s:0..........|
00001030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00001040  3a 85 97 57 00 00 00 00  01 00 00 00 00 00 00 00  |:..W............|
00001050  00 e0 9f 00 00 00 00 00  00 00 00 00 02 00 00 00  |................|
00001060  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001080  00 20 00 00 00 00 00 00  00 e0 9f 00 00 00 00 00  |. ..............|
00001090  08 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000010a0  00 00 00 00 00 00 00 00  8d 69 45 42 e9 a4 ad c2  |.........iEB....|
000010b0  c1 b1 f8 8c d5 8d 7e 22  00 00 08 00 48 00 00 00  |......~"....H...|
000010c0  43 85 97 57 00 00 00 00  04 00 00 00 00 00 00 00  |C..W............|
000010d0  00 4b 07 00 00 00 00 00  28 cd 5d 00 80 00 00 00  |.K......(.].....|
000010e0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001100  00 00 01 00 fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
00001110  fe ff fe ff fe ff fe ff  fe ff fe ff fe ff fe ff  |................|
*
00001200  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
^C



So yeah, if gdisk is used first, then mdadm second, and mdadm is
pointed to the whole block device rather than a partition, mdadm does
not step on any part of the GPT. Therefore something else hit LBA 1 in
the OP's case (I previously said LBA 2, that's a typo, the header is
on LBA 1 at least on 512 byte logical sector drives). Maybe it's a
rare case of silent data corruption on that sector?

However, it does appear that in the OP's case that the array was
created on the whole disk device, not on the partition. If true, I
would remove the signatures on the GPT primary and secondary headers
to make sure they're invalidated. Otherwise it's ambiguous what these
drives are all about, are they single partition drives that are empty?
Or are they whole device md members?

I'd look at using wipefs -b -t or -o to remove the GPT signatures,
while avoiding the mdadm and file system signatures.


Chris Murphy

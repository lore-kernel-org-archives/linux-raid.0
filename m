From: "David Lethe" <david@santools.com>
Subject: RE: mismatch_cnt, random bitflips, silent corruption(?), mdadm/sw raid[156]
Date: Thu, 25 Dec 2008 19:41:44 -0600
Message-ID: <A20315AE59B5C34585629E258D76A97C031B2765@34093-C3-EVS3.exchange.rackspace.com>
References: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <alpine.DEB.1.10.0812250435260.12329@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: xfs@oss.sgi.com, smartmontools-support@lists.sourceforge.net, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Justin Piszcz
> Sent: Thursday, December 25, 2008 12:04 PM
> To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
> Cc: xfs@oss.sgi.com; smartmontools-support@lists.sourceforge.net; Ala=
n
> Piszcz
> Subject: mismatch_cnt, random bitflips, silent corruption(?), mdadm/s=
w
> raid[156]
>=20
> I have many backups of data from the late 1990s onward, each of which
> have
> been combined into tar files and then encrypted with gpg, each is abo=
ut
> 4
> gigabytes so I can store them on DVD.  For quicker access, I also kep=
t
> them on software raid.  In the past, I have always kept them on eithe=
r
> SW
> RAID5 or SW RAID6 using XFS.  All of the machines in question that I
> have/had the data on never exhibited any bad memory and all pass
> memtest
> OK.  However, what is worrisome, is, on occasion, the mismatch_cnt
> would be some crazy number on different machines, 2000 or 5000, I
> checked
> all of the disks with smart, they appear to be OK and when I run a
> check
> and repair against the raid then the count will usually go back down =
to
> zero.
>=20
> However, in reality, are these "mismatches" really an indication of
> silent
> data corruption?  In my case, I have 199 of these backup files and wh=
en
> I
> tried to unencrypt the data, I got these errors on several volumes:
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> gpg: block_filter 0x1c8e200: read error (size=3D10266,a->size=3D10266=
)
> gpg: mdc_packet with invalid encoding
> gpg: decryption failed: invalid packet
> gpg: block_filter: pending bytes!
> gpg: fatal: zlib inflate problem: invalid stored block lengths
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid block type
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid code lengths set
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid block type
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid block type
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: [don't know]: invalid packet (ctb=3D1f)
> gpg: [don't know]: invalid packet (ctb=3D2d)
> gpg: mdc_packet with invalid encoding
> gpg: decryption failed: invalid packet
> gpg: [don't know]: invalid packet (ctb=3D30)
> gpg: fatal: zlib inflate problem: invalid stored block lengths
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid stored block lengths
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid code lengths set
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid stored block lengths
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid distance code
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid distance code
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid code lengths set
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
> gpg: fatal: zlib inflate problem: invalid block type
> secmem usage: 2368/2496 bytes in 6/7 blocks of pool 3104/32768
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> This resulted in partial-sized corrupted tarballs, I am decompressing
> each
> of the 199 backups now to isolate which are affected so I can come up
> with
> a better count on how many files were affected.
>=20
> The total amount of data is:
> 832G in 199 files (4.18gig/file average)
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Bad files (out of the 199):
>=20
> Thu Dec 25 05:44:16 EST 2008: Decompressing backup038.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 08:18:00 EST 2008: Decompressing backup103.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 08:34:39 EST 2008: Decompressing backup111.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 08:43:26 EST 2008: Decompressing backup115.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 08:54:39 EST 2008: Decompressing backup120.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 09:36:02 EST 2008: Decompressing backup137.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 09:36:39 EST 2008: Decompressing backup138.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 09:52:06 EST 2008: Decompressing backup145.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 10:10:14 EST 2008: Decompressing backup153.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 10:10:32 EST 2008: Decompressing backup154.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 10:36:50 EST 2008: Decompressing backup166.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 10:40:19 EST 2008: Decompressing backup168.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 11:20:00 EST 2008: Decompressing backup181.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 11:39:11 EST 2008: Decompressing backup187.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
> Thu Dec 25 12:05:27 EST 2008: Decompressing backup194.tar
> tar: Unexpected EOF in archive
> tar: Unexpected EOF in archive
> tar: Error is not recoverable: exiting now
>=20
>=20
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Example of one file:
> -rw-r--r--  1 root root   40M 2008-12-24 20:08 backup038.tar
> -rw-r--r--  1 root root  4.3G 2008-12-23 17:45 backup038.tar.gpg
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> I have restored the data off of DVD and confirmed the data that had
> resided on disk must have suffered from a bit-flip/corruption:
>=20
> $ md5sum backup038.tar.gpg
> 9958813aa22e4307f2101f87b8820bff  backup038.tar.gpg (from dvd)
>=20
> $ md5sum backup038.tar.gpg
> 9437138a01fc2429ca2131f6a10295b5  backup038.tar.gpg (from disk)
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Splitting these files up we can isolate how many corruptions occured =
in
> the
> file:
>=20
> dvd$ split -b 100M backup038.tar.gpg
> hdd$ split -b 100M backup038.tar.gpg
>=20
> $ diff dvd.md5 ../hdd/hdd.md5
> 1c1
> < 9dfcab90fd6590705ba4293994f10a85  xaa
> ---
> > cce57047ac869ef3e603d4d6bd3579e9  xaa
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Dig further:
> $ mv xaa dvd.xaa
> $ mv xaa hdd.xaa
>=20
> $ split -b 1M dvd.xaa
> $ split -b 1M hdd.xaa
>=20
> $ diff dvd.md5  ../../hdd/xaa_split/hdd.md5
> 40c40
> < 439e4291ea67240c0b083abe5f041319  xbn
> ---
> > 95e548284fa78f750b50f3e6a8e1b847  xbn
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Further..
> $ split -a 100 -b 1k dvd.xbn
> $ split -a 100 -b 1k hdd.xbn
>=20
> $ diff dvd.md5  ../../../hdd/xaa_split/xbn_split/hdd.md5 |wc
>      132     392   17960
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Quite a big 'chunk' of the file suffered corruption.
>=20
> $ diff dvd.md5  ../../../hdd/xaa_split/xbn_split/hdd.md5 | awk '{prin=
t
> $3}' | xargs -n1 ls  | xargs du -ach
> 520K    total
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> dvd$ md5sum one_part_with_corruption
> c131c2f7dea3c316cbcd2c26360e4b03  one_part_with_corruption
> hdd$ md5sum one_part_with_corruption
> 35968f907c5e6f986d9c5a171dd0a7ac  one_part_with_corruption
>=20
> Taking an octal dump and checking the ASCII characters:
>=20
> dvd:
> < 0000000 034   =E5   =E2 201   f   =AE   =E7   =B9   e   D 221   =CA=
   =C1  \b   =F7
> $
> < 0000020   >   p   M   | 212 236 034   =D8  \b   =FF   z   =E5   =ED=
  \a   =C8
> i
> < 0000040 212  \f   =E7   ] 200   l   =AA 234   Y 224   =B3   =E9   =FB=
   =F3   =CC
> < 0000060 233   }   G   =E4   W   : 236   b   =B0   } 215   ) 224   R=
   R
> =B8
> < 0000100 237   =A8   =BE 227   =DA   1   =A4   O   =E7   =FD 003 177=
   $   e 032
> =C1
> < 0000120   !   ^   j   =DE 235   8   5   a   J   =A1   =F6   <   =C6=
   H 223
> =D5
>=20
> hdd:
> > 0000000  \r   =C6   =A6 033 034   =E5   =E2 201   f   =AE   =E7   =B9=
   e   D 221
> =CA
> > 0000020   =C1  \b   =F7   $   >   p   M   | 212 236 034   =D8  \b  =
 =FF   z
> =E5
> > 0000040   =ED  \a   =C8   i 212  \f   =E7   ] 200   l   =AA 234   Y=
 224   =B3
> =E9
> > 0000060   =FB   =F3   =CC     233   }   G   =E4   W   : 236   b   =B0=
   } 215
> )
> > 0000100 224   R   R   =B8 237   =A8   =BE 227   =DA   1   =A4   O  =
 =E7   =FD 003
> 177
> > 0000120   $   e 032   =C1   !   ^   j   =DE 235   8   5   a   J   =A1=
   =F6
> <
>=20
> The hdd image seems 'shifted' see the following sequence:
> (201..f..R..c) on
> the first line.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> So the question then becomes where did the shift begin?  Way above we
> see
> the initial error began on xaa (100M) -> xbn (1M)
>=20
> dvd$ md5sum xbm
> 2524788769acf2b0f98346f488a58441  xbm
> hdd$ md5sum xbm
> 2524788769acf2b0f98346f488a58441  xbm
>=20
> So then we want to take an od of xbn and then diff that:
>=20
> It starts at the following segment:
>=20
> dvd:
> < 2006000   =FB   r 222 235   =A9   z   8   d 035   =B4 230   # 207  =
 =CD   =F5
> u
>=20
> hdd:
> > 2006000   =FB   r 222 235   =FB   r 222 235   =A9   z   8   d 035  =
 =B4 230
> #
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> So let's look at it a few lines before as well:
>=20
> dvd:
> 2005720   '   0   =C3 001   =F2   =BB   [   ( 037 024   . 211   M 023=
 001   =C3
> 2005740   V 021   \   =D0   Y   =C7   =D6 207 206   =AC   n   =AC 234=
   z   =AF 034
> 2005760   =BF 206 002   +   w   =CE 200   =CE   3   =E8   =C0   K   $=
   =EA   e   n
> 2006000   =FB   r 222 235   =A9   z   8   d 035   =B4 230   # 207   =CD=
   =F5   u
> 2006020   R   =AF   =CD 025   =C1   =BC 022   =F6 024   =AF 200   Q 2=
17   =C3   =AF   =A3
> 2006040 203   =AD   =F4   c   3   =ED 207   #   ]   =C4   =F4   H   (=
   =FD   5 207
> 2006060   =EB   C   C   a   @  \r 200   =DC   =E2   =A1  \r 204 230  =
 U   =E6   O
>=20
> hdd:
> 2005720   '   0   =C3 001   =F2   =BB   [   ( 037 024   . 211   M 023=
 001   =C3
> 2005740   V 021   \   =D0   Y   =C7   =D6 207 206   =AC   n   =AC 234=
   z   =AF 034
> 2005760   =BF 206 002   +   w   =CE 200   =CE   3   =E8   =C0   K   $=
   =EA   e   n
> 2006000   =FB   r 222 235   =FB   r 222 235   =A9   z   8   d 035   =B4=
 230   #
> 2006020 207   =CD   =F5   u   R   =AF   =CD 025   =C1   =BC 022   =F6=
 024   =AF 200   Q
> 2006040 217   =C3   =AF   =A3 203   =AD   =F4   c   3   =ED 207   #  =
 ]   =C4   =F4   H
> 2006060   (   =FD   5 207   =EB   C   C   a   @  \r 200   =DC   =E2  =
 =A1  \r 204
>=20
> The same sequence still seems to exist after the flip for the 5th
> character
> on line 2006000.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> On the linux-raid mailing list, this issue is often discussed:
> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07541.html
>=20
> The solution seems to be repair and keep on trucking along, which is
> probably fine for a filesystem with hundreds/thousands of files, most
> likely, you would never notice the corruption.  However, with gpg, th=
e
> files
> obviously cannot suffer any corruption. It is only when I tried to
> extract the
> data did I notice this problem.
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> =3D=3D server 1 (965 chipset) =3D=3D
> Root filesystem (Raid-1):
> Sat Nov 15 11:39:03 EST 2008: cat /sys/block/md2/md/mismatch_cnt
> Sat Nov 15 11:39:03 EST 2008: 128
>=20
> Storage array (Raid-6):
> Wed Nov 26 10:14:21 EST 2008: cat /sys/block/md3/md/mismatch_cnt
> Wed Nov 26 10:14:21 EST 2008: 1208
>=20
> =3D=3D server 2 (p35-chipset) =3D=3D
> Swap (Raid-1): I understand this is 'normal' for swap:
> Fri Jan 18 22:51:47 EST 2008: cat /sys/block/md0/md/mismatch_cnt
> Fri Jan 18 22:51:47 EST 2008: 4096
> Fri May 30 21:00:07 EDT 2008: cat /sys/block/md0/md/mismatch_cnt
> Fri May 30 21:00:07 EDT 2008: 896
> Fri Nov 14 23:30:10 EST 2008: cat /sys/block/md0/md/mismatch_cnt
> Fri Nov 14 23:30:10 EST 2008: 384
>=20
> =3D=3D server 3 (also 965 chipset) =3D=3D
> Root filesystem (Raid-1):
> Fri May 18 20:50:05 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Fri May 18 20:50:05 EDT 2007: 128
> Sat May 26 04:40:09 EDT 2007: cat /sys/block/md2/md/mismatch_cnt
> Sat May 26 04:40:09 EDT 2007: 128
>=20
> Swap (Raid-1): Again, normal but a very high mismatch_cnt:
> Fri Oct  5 20:50:05 EDT 2007: cat /sys/block/md0/md/mismatch_cnt
> Fri Oct  5 20:50:05 EDT 2007: 27904
>=20
> Storage array (RAID-5)
> Fri Apr  4 22:00:09 EDT 2008: cat /sys/block/md3/md/mismatch_cnt
> Fri Apr  4 22:00:09 EDT 2008: 512
> Fri May 23 22:00:10 EDT 2008: cat /sys/block/md3/md/mismatch_cnt
> Fri May 23 22:00:10 EDT 2008: 256
>=20
> =3D=3D server 4 (intel 875 chipset, raid-5)
> # grep mismatches\ found *
> daemon.log:Jan  3 11:27:27 p26 mdadm: RebuildFinished event detected =
on
> md device /dev/md0, component device  mismatches found: 11896
> daemon.log:Nov 14 12:25:59 p26 mdadm[1956]: RebuildFinished event
> detected on md device /dev/md0, component device  mismatches found:
> 11664
> daemon.log:Nov 14 18:19:01 p26 mdadm[1956]: RebuildFinished event
> detected on md device /dev/md0, component device  mismatches found:
> 11664
> syslog:Jan  3 11:27:27 p26 mdadm: RebuildFinished event detected on m=
d
> device /dev/md0, component device  mismatches found: 11896
> syslog:Nov 14 12:25:59 p26 mdadm[1956]: RebuildFinished event detecte=
d
> on md device /dev/md0, component device  mismatches found: 11664
> syslog:Nov 14 18:19:01 p26 mdadm[1956]: RebuildFinished event detecte=
d
> on md device /dev/md0, component device  mismatches found: 11664
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Options/alternatives for maintaining data integrity?
>=20
> 1. Obviously DVD and/or LTO-tape (multiple copies of data at rest)
> http://epoka.dk/media/Linear_Tape_Open_(LTO)_Ultrium_Data_Cartridges.=
pd
> f
> -> For LTO-2/LTO-3
> -> Uncorrected bit error rate 1x10-17 1x10-17
> -> Undetected bit error rate 1x10-27 1x10-27
>=20
> 2. ZFS, but only runs in user-space in Linux.
>=20
> 3. Keep an md5sum for each file on the filesystem and run daily check=
s?
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =3D
>=20
> Other options?
>=20
> How do others maintain data integrity?  Just not worry about it until
> you have
> to, rely on backups.. or?
>=20
> Justin.

4GB files using gpg and tar in the '90s?=20
I know gpg had 2GB file-related bugs as late as 2005 that caused corrup=
tion, and
there was a heck of a lot of 2GB-related bugs in 2.2 and 2.4 kernels wh=
ich you
must have been running back then.  You are also using later versions of=
 these=20
programs on the new systems, and I'd be willing to bet they compound th=
e problem by
assuming there was no corruption to begin with. =20

I use:
- gzipped tar archives, but I gzip the individual files, rather than th=
e tarball. That way=20
any compression-related bugs are limited to a single file. I copy them =
to DVDs.

- For online/nearline, I now use a ZFS, but on a native Solaris system =
that functions as my primary
NFS/CIFS/iSCSI server with and a ZFS software-RAID based file system.  =
 I am profoundly impressed with=20
it, and when they release the deduplication enhancement for ZFS, I'll a=
dopt it and won't have to buy
any more DVDs, except for offsite archiving purposes.

David=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

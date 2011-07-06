From: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Subject: dm-crypt over raid6 unreadable after crash
Date: Wed, 6 Jul 2011 18:12:28 +0200
Message-ID: <20110706161228.GA1491@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

After a hardware crash I can no longer open a dm-crypt partition located
directly over a md-raid6 partition. I get this error:

	root@grml ~ # cryptsetup isLuks /dev/md1 
	Device /dev/md1 is not a valid LUKS device

It seems the LUKS header has been shifted a few bytes forward, but looks
otherwise fine to specialists on the dm-crypt mailing list. Normally the
"LUKS" signature should be at 0x00000000

Is there some way that the md layer could have shifted its contents?

Is there a way to shift it back in place?

Thanks,


Here is a hexdum of /dev/md1 done with "hd /dev/md1 | head -n 40"

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00100000  4c 55 4b 53 ba be 00 01  61 65 73 00 00 00 00 00  |LUKS....aes.....|
00100010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100020  00 00 00 00 00 00 00 00  63 62 63 2d 65 73 73 69  |........cbc-essi|
00100030  76 3a 73 68 61 32 35 36  00 00 00 00 00 00 00 00  |v:sha256........|
00100040  00 00 00 00 00 00 00 00  73 68 61 31 00 00 00 00  |........sha1....|
00100050  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100060  00 00 00 00 00 00 00 00  00 00 18 00 00 00 00 20  |............... |
00100070  d3 67 34 b9 7b 55 fe 0d  e7 cc 5d df 6e ae f7 1f  |.g4.{U....].n...|
00100080  96 78 43 c5 d2 55 58 4b  a9 2a 73 8b 28 45 6b 8c  |.xC..UXK.*s.(Ek.|
00100090  cd 26 45 61 6b f4 5a 58  6d 8e 1b 85 c2 60 4f 7c  |.&Eak.ZXm....`O||
001000a0  00 39 48 89 00 00 6d dd  66 37 38 31 66 62 34 30  |.9H...m.f781fb40|
001000b0  2d 37 65 34 31 2d 34 30  63 62 2d 62 65 66 66 2d  |-7e41-40cb-beff-|
001000c0  61 39 66 37 61 65 61 63  64 35 63 36 00 00 00 00  |a9f7aeacd5c6....|
001000d0  00 ac 71 f3 00 01 b8 3f  f7 9d c2 ef e0 07 78 c3  |..q....?......x.|
001000e0  f6 90 73 57 39 be 8e 79  59 44 a1 23 35 11 6f 6a  |..sW9..yYD.#5.oj|
001000f0  6c b0 36 fc 7d 9b 15 0f  00 00 00 08 00 00 0f a0  |l.6.}...........|
00100100  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100110  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100120  00 00 00 00 00 00 00 00  00 00 01 08 00 00 0f a0  |................|
00100130  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100140  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100150  00 00 00 00 00 00 00 00  00 00 02 08 00 00 0f a0  |................|
00100160  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100170  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100180  00 00 00 00 00 00 00 00  00 00 03 08 00 00 0f a0  |................|
00100190  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
001001a0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
001001b0  00 00 00 00 00 00 00 00  00 00 04 08 00 00 0f a0  |................|
001001c0  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
001001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
001001e0  00 00 00 00 00 00 00 00  00 00 05 08 00 00 0f a0  |................|
001001f0  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100200  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100210  00 00 00 00 00 00 00 00  00 00 06 08 00 00 0f a0  |................|
00100220  00 00 de ad 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100230  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00100240  00 00 00 00 00 00 00 00  00 00 07 08 00 00 0f a0  |................|
00100250  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|


From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested
Date: Mon, 2 Nov 2015 20:55:18 -0500
Message-ID: <56381406.7070608@turmel.org>
References: <CAPpdf58rFk95KYGc3WkOQGg+ytJ3rcmWtu23ZU3-ss=vx_GfhQ@mail.gmail.com>
 <56367C33.6060703@turmel.org>
 <CAPpdf5_PUpR7GhBHUaQfWb8Q+7FZenxXgFqbaN3f3r0r6NQNDA@mail.gmail.com>
 <5637842D.1070000@turmel.org>
 <CAPpdf59MFX1oVwLC-bmQBaQp9K_9-+h0v64OGMnV1-k=eCzO0w@mail.gmail.com>
 <5637BCE4.8000006@turmel.org>
 <CAPpdf58En1ARr9YiFSgvPN5Ke_t7=EfxiaN9cZtGVtvR4NUdmA@mail.gmail.com>
 <5637FBAC.8000900@turmel.org>
 <CAPpdf59mkRiyNYF1dT6Xp9tcofTU8hOdih+tz+i=wPJfRQrTnQ@mail.gmail.com>
 <56380690.5030600@turmel.org>
 <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-HbrFESY_zhfkZ4=2CtYjgO4bA4LmA+1AHkT+Gv9iY2w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/02/2015 08:02 PM, o1bigtenor wrote:

> root@debianbase:/# dd if=/dev/md0 bs=1M count=16 |hexdump -C |head -n 1000
> 00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 00100400  00 20 47 07 00 14 1c 1d  99 9a 74 01 f0 80 72 18  |. G.......t...r.|
> 00100410  83 b0 3d 07 00 00 00 00  02 00 00 00 02 00 00 00  |..=.............|
> 00100420  00 80 00 00 00 80 00 00  00 20 00 00 fa 46 d5 55  |......... ...F.U|
> 00100430  78 80 e0 55 5a 00 27 00  53 ef 01 00 01 00 00 00  |x..UZ.'.S.......|
> 00100440  1e de 6d 52 00 4e ed 00  00 00 00 00 01 00 00 00  |..mR.N..........|
> 00100450  00 00 00 00 0b 00 00 00  00 01 00 00 3c 00 00 00  |............<...|
> 00100460  42 02 00 00 7b 00 00 00  49 55 20 36 b4 6f 49 56  |B...{...IU 6.oIV|
> 00100470  ad e9 35 41 a3 dd 7f 0a  00 00 00 00 00 00 00 00  |..5A............|
> 00100480  00 00 00 00 00 00 00 00  2f 6d 65 64 69 61 2f 64  |......../media/d|
> 00100490  61 72 61 6c 64 2f 34 39  35 35 32 30 33 36 2d 62  |arald/49552036-b|
> 001004a0  34 36 66 2d 34 39 35 36  2d 61 64 65 39 2d 33 35  |46f-4956-ade9-35|
> 001004b0  34 31 61 33 64 64 37 66  30 61 00 00 00 00 00 00  |41a3dd7f0a......|
> 001004c0  00 00 d8 60 0f fa 0f 88  00 00 00 00 00 00 8b 03  |...`............|
> 001004d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 001004e0  08 00 00 00 00 00 00 00  00 00 00 00 c7 2a e8 cd  |.............*..|
> 001004f0  c2 6f 4d 09 8f c2 2b 44  fc 95 b6 5e 01 01 00 00  |.oM...+D...^....|
> 00100500  00 00 00 00 00 00 00 00  a1 25 65 4f 0a f3 02 00  |.........%eO....|
> 00100510  04 00 00 00 00 00 00 00  00 00 00 00 ff 7f 00 00  |................|
> 00100520  00 80 88 0e ff 7f 00 00  01 00 00 00 ff ff 88 0e  |................|
> 00100530  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00100540  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 08  |................|
> 00100550  00 00 00 00 00 00 00 00  00 00 00 00 1c 00 1c 00  |................|
> 00100560  01 00 00 00 80 00 00 00  00 00 00 00 00 00 00 00  |................|
> 00100570  00 01 00 00 04 00 00 00  a8 96 ac 12 00 00 00 00  |................|
> 00100580  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *

Woo hoo!  There's your ext4 superblock.

Use "gdisk /dev/md0" and create a partition starting at sector 2048 and
occupying the rest of the array.  After you save that, you may need
"partprobe /dev/md0" to rescan it.

You'll probably end up with a device named something like /dev/md0p1.
The output of dmesg will likely show you the device name.

Use "fsck -n /dev/md0p1" to verify the filesystem, and if that has
relatively few errors, you may mount it and start making backups.

Phil


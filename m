From: kyle <kyle.upton.is@gmail.com>
Subject: Re: HELP! RAID5 array disappeared after partitions deleted
Date: Fri, 20 Jan 2017 09:12:23 +1000
Message-ID: <510dda0b-fd97-45f5-9e23-8005dd7c200a@gmail.com>
References: <e3f5d5ff-cea5-8cdc-c235-768e73293283@gmail.com>
 <5880C49C.5090508@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5880C49C.5090508@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> Search for the following thread(s) and read them:
>
> Please help RAID1 complete fail no superblock 22/11/16
I have started working through this.

Of the three drives, 2 are WD (sdd&f), and one is a Seagate (sde). The 
hexdump for the Seagate is much larger than that for the WDs (i may have 
made my problem twice as hard by not sticking with the same drives :/ )

Here is the hexdump for /dev/sdd and /dev/sdf (/dev/sde will be in the 
next message)

$ sudo dd if=/dev/sdd bs=4k count=4k | hexdump -C
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001c0  01 00 ee fe ff ff 01 00  00 00 ff ff ff ff 00 00 
|................|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa 
|..............U.|
00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI 
PART....\...|
00000210  82 b9 5d 28 00 00 00 00  01 00 00 00 00 00 00 00 
|..](............|
00000220  af 2a 81 a3 03 00 00 00  22 00 00 00 00 00 00 00 
|.*......".......|
00000230  8e 2a 81 a3 03 00 00 00  9b bf e9 57 db 21 e4 41 
|.*.........W.!.A|
00000240  b5 d1 4a 76 63 a1 ac e6  02 00 00 00 00 00 00 00 
|..Jvc...........|
00000250  80 00 00 00 80 00 00 00  86 d2 54 ab 00 00 00 00 
|..........T.....|
00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
00005b30  00 00 00 00 00 00 00 80  ff ff ff ff ff ff ff ff 
|................|
00005b40  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff 
|................|
*
00005c00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
4096+0 records in
4096+0 records out
16777216 bytes (17 MB, 16 MiB) copied, 0.302533 s, 55.5 MB/s
01000000

$ sudo dd if=/dev/sdf bs=4k count=4k | hexdump -C | head -n 1000
4096+0 records in
4096+0 records out
16777216 bytes (17 MB, 16 MiB) copied, 0.300609 s, 55.8 MB/s
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001c0  01 00 ee fe ff ff 01 00  00 00 ff ff ff ff 00 00 
|................|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa 
|..............U.|
00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI 
PART....\...|
00000210  c6 60 c9 53 00 00 00 00  01 00 00 00 00 00 00 00 
|.`.S............|
00000220  af 2a 81 a3 03 00 00 00  22 00 00 00 00 00 00 00 
|.*......".......|
00000230  8e 2a 81 a3 03 00 00 00  a5 7f 6e 34 93 21 53 44 
|.*........n4.!SD|
00000240  89 0e 8c 55 4c 39 aa e3  02 00 00 00 00 00 00 00 
|...UL9..........|
00000250  80 00 00 00 80 00 00 00  86 d2 54 ab 00 00 00 00 
|..........T.....|
00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
00005b30  00 00 00 00 00 00 00 80  ff ff ff ff ff ff ff ff 
|................|
00005b40  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff 
|................|
*
00005c00  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
01000000


> RAID10 with 2 drives auto-assembled as RAID1 05/11/16
>
> Dates are DMY European format. You want to hexdump the likely disk
> locations and try and find partition superblocks, raid superblocks, etc
> etc. If you can find anything like that and post it to the list, then
> the experts can chime in and help you get it back.
>
> There's probably a few more threads like that, but those are the ones
> I've just found.
>
> Cheers,
> Wol


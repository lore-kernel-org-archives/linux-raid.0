From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: how to handle bad sectors in md control areas?
Date: Fri, 28 Feb 2014 12:35:14 +1100
Message-ID: <530FE7D2.30809@eyal.emu.id.au>
References: <530DA2DE.9030705@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530DA2DE.9030705@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/26/14 19:16, Eyal Lebedinsky wrote:
> In another thread I investigated an issue with a pending sector, which now seems to be
> a bad sector inside the md header (the first 256k sectors).
>
> The question now remaining: what is the correct approach to fixing this problem?
>
> The more general issue is what to do when any md control area develops an error. does
> all data have redundant copies?
>
> The simple way that I see is to fail the member, remove it, clear it (at least
> --zero-superblock and write to the bad sector) and then add it. However this
> will incur a full resync (about 10 hours).
>
> Is there a faster, yet safe way? I was thinking that a clean umount and raid stop
> should allow a create with --assume-clean (which will write to the bad sector and
> "fix" it), but the doco discourages this.
>
> Also, it is not impossible to think that the specific bad sector (toward the end
> of the header) is not actually used today, meaning I can live with it as is, or
> write anything to the bad sector as it does not get used. Too involved though.
>
> A bad sector in the data area should be fixed with a standard raid 'check' action.
>
> TIA

Adding more details to the above, examining my specific situation.

Dumping the first 128MB of each component (examples below) shows that only
0x1000-0x4000 is used, the rest is zeros (at least when the array is at rest).

Can I assume that it really is safe to write zeroes to the offending sector (note
how the dd of sdi1 fails at offset 0x7ec8000 [sector 259648], toward the very end
at 0x8000000 [sector 262144]).

Eyal

sd[c-i]1 are the 7 components with sdi1 having the bad sector.
sd[c-h]1 all look very similar.

# dd if=/dev/sdh1 bs=1M count=128 | od -x -Ax
128+0 records in
128+0 records out
134217728 bytes (134 MB) copied, 0.20988 s, 639 MB/s
000000 0000 0000 0000 0000 0000 0000 0000 0000
*
001000 4efc a92b 0001 0000 0001 0000 0000 0000
001010 a4c6 6ac1 b5f7 aa51 2976 c0ec 9f10 1e7e
001020 3765 652e 6179 2e6c 6d65 2e75 6469 612e
001030 3a75 0031 0000 0000 0000 0000 0000 0000
001040 fca8 51c2 0000 0000 0006 0000 0002 0000
001050 ac00 d1bc 0001 0000 0400 0000 0007 0000
001060 0008 0000 0000 0000 0000 0000 0000 0000
001070 0000 0000 0000 0000 0000 0000 0000 0000
001080 0000 0004 0000 0000 b000 d1bc 0001 0000
001090 0008 0000 0000 0000 0000 0000 0000 0000
0010a0 0005 0000 0000 0000 2c6a a754 f403 5b99
0010b0 9b05 5407 a33e 41c4 0000 0000 0000 0000
0010c0 df7e 530f 0000 0000 32ad 0017 0000 0000
0010d0 ffff ffff ffff ffff e563 a205 0080 0000
0010e0 0000 0000 0000 0000 0000 0000 0000 0000
*
001100 0000 0001 0002 fffe 0004 0005 0006 0003
001110 fffe fffe fffe fffe fffe fffe fffe fffe
*
001200 0000 0000 0000 0000 0000 0000 0000 0000
*
002000 6962 6d74 0004 0000 a4c6 6ac1 b5f7 aa51
002010 2976 c0ec 9f10 1e7e 32ad 0017 0000 0000
002020 32ad 0017 0000 0000 ac00 d1bc 0001 0000
002030 0000 0000 0000 0400 0005 0000 0000 0000
002040 0000 0000 0000 0000 0000 0000 0000 0000
*
002f80 0000 0000 0000 0000 0000 0000 2000 0000
002f90 0000 0000 0000 0000 0000 0000 0000 0000
*
003690 0000 0000 0000 0000 0000 0000 0000 0200
0036a0 0000 0000 0000 0000 0000 0000 0000 0000
*
003ab0 4000 0000 0000 0000 0000 0000 0000 0000
003ac0 0000 0000 0000 0000 0000 0000 0000 0000
*
003e10 0000 0000 0000 0000 0000 8000 ffff ffff
003e20 ffff ffff ffff ffff ffff ffff ffff ffff
*
004000 0000 0000 0000 0000 0000 0000 0000 0000
*
8000000

# dd if=/dev/sdi1 bs=1M count=128 | od -x -Ax
dd: error reading '/dev/sdi1': Input/output error
126+1 records in
126+1 records out
132939776 bytes (133 MB) copied, 12.3209 s, 10.8 MB/s
000000 0000 0000 0000 0000 0000 0000 0000 0000
*
001000 4efc a92b 0001 0000 0001 0000 0000 0000
001010 a4c6 6ac1 b5f7 aa51 2976 c0ec 9f10 1e7e
001020 3765 652e 6179 2e6c 6d65 2e75 6469 612e
001030 3a75 0031 0000 0000 0000 0000 0000 0000
001040 fca8 51c2 0000 0000 0006 0000 0002 0000
001050 ac00 d1bc 0001 0000 0400 0000 0007 0000
001060 0008 0000 0000 0000 0000 0000 0000 0000
001070 0000 0000 0000 0000 0000 0000 0000 0000
001080 0000 0004 0000 0000 b000 d1bc 0001 0000
001090 0008 0000 0000 0000 0000 0000 0000 0000
0010a0 0006 0000 0000 0000 9d01 1bb7 9ebe 9ff8
0010b0 95d4 53b1 0ddb 9a2d 0000 0000 0000 0000
0010c0 df88 530f 0000 0000 32ae 0017 0000 0000
0010d0 0000 0000 0000 0000 662d b2da 0080 0000
0010e0 0000 0000 0000 0000 0000 0000 0000 0000
*
001100 0000 0001 0002 fffe 0004 0005 0006 0003
001110 fffe fffe fffe fffe fffe fffe fffe fffe
*
001200 0000 0000 0000 0000 0000 0000 0000 0000
*
002000 6962 6d74 0004 0000 a4c6 6ac1 b5f7 aa51
002010 2976 c0ec 9f10 1e7e 32ae 0017 0000 0000
002020 32ad 0017 0000 0000 ac00 d1bc 0001 0000
002030 0000 0000 0000 0400 0005 0000 0000 0000
002040 0000 0000 0000 0000 0000 0000 0000 0000
*
002f80 0000 0000 0000 0000 0000 0000 2000 0000
002f90 0000 0000 0000 0000 0000 0000 0000 0000
*
003ab0 c000 0000 0000 0000 0000 0000 0000 0000
003ac0 0000 0000 0000 0000 0000 0000 0000 0000
*
003e10 0000 0000 0000 0000 0000 8000 ffff ffff
003e20 ffff ffff ffff ffff ffff ffff ffff ffff
*
004000 0000 0000 0000 0000 0000 0000 0000 0000
*
7ec8000



-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)

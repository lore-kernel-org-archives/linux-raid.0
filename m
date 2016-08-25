From: Chris Murphy <lists@colorremedies.com>
Subject: Re: bootsect replicated in p1, RAID enclosure suggestions?
Date: Thu, 25 Aug 2016 16:32:12 -0600
Message-ID: <CAJCQCtSWOwf6pHD2O7CtaNwF4BDbHO+hh7XrXpcaRsqPkvmFrQ@mail.gmail.com>
References: <20160823050947.GL32250@subspacefield.org> <CAJCQCtSY=D-ASQ22km8GJjfju4jUgJSOBTAH5+XveCZq1BvT7w@mail.gmail.com>
 <20160825062501.GN32250@subspacefield.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160825062501.GN32250@subspacefield.org>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 25, 2016 at 12:25 AM,
<travis+ml-linux-raid@subspacefield.org> wrote:

> $ sudo mdadm -E /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : <elided>
>            Name : <elided>
>   Creation Time : Wed Aug 10 11:33:41 2016
>      Raid Level : raid0
>    Raid Devices : 4
>
>  Avail Dev Size : 7814035071 (3726.02 GiB 4000.79 GB)
>     Data Offset : 16 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : <elided)
>
>     Update Time : Wed Aug 10 11:33:41 2016
>        Checksum : 490b562f - correct
>          Events : 0
>
>      Chunk Size : 512K
>
>    Device Role : Active device 0
>    Array State : AAAA ('A' == active, '.' == missing)

I'm confused by Events: 0, even though I see the same thing with raid0
and linear arrays. As writes happen, array stopped and started, this
Events count does not increase. Parity raid only thing I guess?

Anyway, sdd1 has both an mdadm superblock on it, as shown above, and
it also has a GPT on it as show in your first message and below -
that's not good, but not unfixable. The mdadm super block starts at
LBA 8, 4096 bytes from the start of that partition, so it's safe to
zero the first 4096 bytes. The GPT is mainly in the first three
sectors so you could just write zeros for a count of 3, although it is
more complete to zero with a count=8, for the partition, not the whole
device.


>
> Here is what should be the same, only device 2 in the array
> (device 3 is similar or identical):
>
> $ sudo mdadm -E /dev/sdf1
> /dev/sdf1:
>    MBR Magic : aa55
> Partition[0] :   4294967295 sectors at            1 (type ee)

Looks like the mdadm super block might have been stepped on by
something. You'd need to look for some evidence of it using something
like

dd if=/dev/sdf1 count=9 2>/dev/null | hexdump -C

If it's intact it should be at offset x1000 and again just a matter of
wiping the first 8 sectors, again of the partition, not the whole
device.






> $ sudo mdadm -D /dev/sdf1
> mdadm: /dev/sdf1 does not appear to be an md device

You're getting the commands confused. -E applies to /dev/sdXY member
devices, and -D applies to /dev/mdX arrays.


>
> Sadly, I can't do a mdadm -D because I can't assemble the RAID.
> $ sudo mdadm -E /dev/md127

Again, wrong command, you should use -D for this.


> $
>
> The command history is gone, but I would imagine that the RAID was
> created with something like this:
>
> mdadm --create /dev/md/bu --level=0 --raid-devices=4 /dev/sd{b,c,d,e}1
>
> Although it could have been level=linear.
>
> To summarize my email:
> "Is this is a known problem? If not, here is a bug report"

This is not a bug report. There's no reproduce steps, there's no
evidence of a bug. I'm not experiencing random replacement of mdadm
superblock data with MBR and GPT signatures. That's not really what
I'd expect of drive or enclosure firmware which by design should be
partition agnostic, as there's more than one or two valid kinds of
partitioning. Plus, it'd be scary even if it picked the right one, it
could clobber a legitimate existing one.

So I'd say it's something else.


>> It's purely speculation, but it sounds like to me in the history of
>> one or more drives, the previous signatures weren't removed before the
>> drive was retasked for its new purpose. That's the folly of not wiping
>> the signatures in the reverse order they were created, and just
>> expecting that starting over will wipe those old signatures.
>
> It's possible, but why would you ever end up with a GPT in a partition?

In every case I've seen, it was user error. I haven't heard of things
putting GPTs in partitions, and in a sense I'd say it's a bug if any
utility lets a user do that. Nesting GPT's in partitions, bad idea,
although it *should* be innocuous because it shouldn't be seen/honored
by anything that doesn't go looking for it because it doesn't belong
there.



>
> I've certainly encountered this "GPT outside cylinder 0" on these two
> drives before,

Keep in mind cylinders are gone, they don't exist anymore. Drives all
speak in LBAs now. *shrug* The GPT typically involves LBAs 0, 1 and 2
at least, more if there are more than 4 partitions.

> but it goes away with a forcible reassemble or recreate
> (which I did last time), because the mdlabel blows it away.

Umm, I think that only happens with -U, --update.


>Unless
> it's something this list knows about, I suspect it is a firmware
> glitch in the USB enclosure.

Doubtful.




>
>> But I think there is a legitimate gripe that parted probably should
>> not operate on partitions like this. It's not valid to have nested
>> GPTs like this. And I have no idea if parted is showing you valid or
>> bogus information. You'd need to do something like:
>>
>> dd if=/dev/sdd1 count=2 2>/dev/null | hexdump -C
>
> ## Good disk (for comparison):
> $ sudo dd if=/dev/sdd1 count=2 2> /dev/null | file -
> /dev/stdin: data
> $ sudo dd if=/dev/sdd1 count=2 2> /dev/null | hexdump -C | head -20
> 00000000  ff 02 19 2e 03 ee fa d8  6d d7 24 78 e1 d4 04 3d  |........m.$x...=|
> 00000010  c9 92 33 97 17 7a 10 d3  05 bd 39 36 b4 a9 7c 14  |..3..z....96..|.|
> 00000020  a7 de 66 b6 cd d9 ff ef  45 27 74 6e 94 0a 03 49  |..f.....E'tn...I|
> 00000030  d4 43 26 2d 45 39 d1 93  8a 35 91 91 ff c9 a4 8e  |.C&-E9...5......|
> 00000040  bd 9a 06 6d cc f2 89 65  c0 91 87 1c 1b f0 da 2f  |...m...e......./|
> 00000050  83 c2 12 eb 80 3c c2 4c  68 cc 65 40 26 13 e0 77  |.....<.Lh.e@&..w|
> 00000060  38 15 ed 78 27 76 4c 91  71 99 3e 9f 99 f1 3f 51  |8..x'vL.q.>...?Q|
> 00000070  19 db 12 a3 ac b6 61 12  ff d9 37 87 31 1f 8b dd  |......a...7.1...|
> 00000080  88 82 de fb db f2 a5 31  10 2a d2 03 be 12 be bd  |.......1.*......|
> 00000090  19 46 9f c1 3b ea a1 37  81 d2 4d 00 54 e7 b4 55  |.F..;..7..M.T..U|
> 000000a0  b7 65 6c 3f 95 40 b0 f4  28 ff 90 62 22 cb 22 fd  |.el?.@..(..b".".|
> 000000b0  6b 4d 90 56 32 4b c6 22  35 b1 62 76 e1 fd 82 d5  |kM.V2K."5.bv....|
> 000000c0  03 40 c0 85 4b ac 5a 44  9e 6a 25 97 d3 7f bd fe  |.@..K.ZD.j%.....|
> 000000d0  0c 2d a8 bb 33 f4 00 df  7a 05 ae 6d b3 3e f3 7d  |.-..3...z..m.>.}|
> 000000e0  34 9e 0e 57 14 de d8 e0  28 63 82 a6 2a 8a 1f fc  |4..W....(c..*...|
> 000000f0  fe 2f b0 69 67 ac 0a e9  c2 53 a7 d8 36 1a 18 5a  |./.ig....S..6..Z|
> 00000100  d6 d4 e6 ce df f7 fc 67  13 eb 25 08 45 50 10 7b  |.......g..%.EP.{|
> 00000110  c6 23 1e 59 dc 2d c2 65  53 90 ca ec 21 e7 28 74  |.#.Y.-.eS...!.(t|
> 00000120  41 7f 3e 58 72 08 75 c1  d5 ca d0 91 55 5f 43 6a  |A.>Xr.u.....U_Cj|
> 00000130  4e 84 d5 7f aa f2 b5 27  e4 86 5d 28 ae 6c 29 a1  |N......'..](.l).|

OK I don't know why you used head, I needed to see past offset 0x130.
Offset lines 0x1f0 and x200 have the MBR and GPT signatures, so the
above doesn't really tell me anything.

I don't recognize the above stuff, so I'm not sure what it is. I'd
usually expect it to be zeros if it's not a boot drive.

>
> ## Bad disk:
> $ sudo dd if=/dev/sdf1 count=2 2> /dev/null | file -
> /dev/stdin: x86 boot sector; partition 1: ID=0xee, starthead 0, startsector 1, 4294967295 sectors, code offset 0x6f
> $ sudo dd if=/dev/sdf1 count=2 2> /dev/null | hexdump -C
> 00000000  38 6f 96 52 ea 9c 31 cd  10 a2 84 58 a2 f0 f5 43  |8o.R..1....X...C|
> 00000010  0f f2 5a 9b c7 ff 82 b2  d8 59 86 60 15 bc 31 65  |..Z......Y.`..1e|
> 00000020  bc d7 77 f9 31 6a c8 16  3f 13 90 24 b7 57 ff 6b  |..w.1j..?..$.W.k|
> 00000030  64 7e e2 99 2a 99 f7 32  69 be aa 56 36 31 f7 db  |d~..*..2i..V61..|
> 00000040  8c 4c 4c 12 68 19 77 0f  f6 3b 92 bf 18 92 c2 45  |.LL.h.w..;.....E|
> 00000050  73 d5 b7 93 cc ae 6b b9  b0 bd 0c 85 a9 c3 19 f7  |s.....k.........|
> 00000060  87 34 b8 be 0a 95 cd 03  03 d5 01 49 b5 b0 86 fe  |.4.........I....|
> 00000070  71 1c d2 f6 42 ed ce b0  eb c3 5f 4c 07 34 30 c7  |q...B....._L.40.|
> 00000080  8a 1f 91 c4 8b 28 b9 07  8e da ae 7d 7d c5 24 2b  |.....(.....}}.$+|
> 00000090  6d f9 ea a3 6a 83 9d b8  6a 1f 6d db 3a 01 22 c7  |m...j...j.m.:.".|
> 000000a0  56 fc 2a 46 f8 b2 84 31  d1 8b 58 55 b6 5a 36 7b  |V.*F...1..XU.Z6{|
> 000000b0  48 5d 98 2a 3f f0 ae 80  2b f8 6b b2 7f 1e 27 c2  |H].*?...+.k...'.|
> 000000c0  59 65 d0 bf c7 f0 5b 18  dc 59 8e 68 46 03 b6 ca  |Ye....[..Y.hF...|
> 000000d0  42 06 7a 52 7a 49 36 03  0d d5 9b 67 a2 03 3b 13  |B.zRzI6....g..;.|
> 000000e0  40 23 19 f5 1a a6 bd fb  c8 d5 5b 26 f5 6a 86 ab  |@#........[&.j..|
> 000000f0  89 77 98 d8 09 cb b7 59  80 03 81 48 ba c6 ce 77  |.w.....Y...H...w|
> 00000100  3c 6c d2 ba a0 71 c3 20  18 fd 77 db ca a8 8a e3  |<l...q. ..w.....|
> 00000110  8d 6c 1f 17 d5 9f e5 81  bf 50 62 c3 bc f8 6c 5d  |.l.......Pb...l]|
> 00000120  f7 3f a6 37 6b a9 53 2b  88 15 5d 6e 1e 48 4f b4  |.?.7k.S+..]n.HO.|
> 00000130  db af b4 f7 f5 7b 4d f3  3f 60 44 60 6e a2 c4 6d  |.....{M.?`D`n..m|
> 00000140  b9 6c 88 04 e8 66 d1 7c  a0 09 10 66 32 de 70 e1  |.l...f.|...f2.p.|
> 00000150  98 40 54 5e 1d f2 af b8  2e d1 75 0d 3c 46 1f f8  |.@T^......u.<F..|
> 00000160  85 72 49 87 ad 92 59 28  fd 9d 22 8e 1b 9f 2c 00  |.rI...Y(.."...,.|
> 00000170  87 58 74 01 63 a5 94 13  e3 9c ea ec 3f 21 22 41  |.Xt.c.......?!"A|
> 00000180  05 13 78 f3 a8 46 b3 02  9e 23 cb 9d 21 db a6 ae  |..x..F...#..!...|
> 00000190  08 a8 70 48 18 6c e2 38  e4 ac 03 6e 06 74 17 7c  |..pH.l.8...n.t.||
> 000001a0  90 ca 9f 5e 2e 2b 84 ef  52 2c 08 9a 48 98 f9 46  |...^.+..R,..H..F|
> 000001b0  f4 9f 00 cd ec a0 11 d7  00 00 00 00 00 00 00 00  |................|
> 000001c0  02 00 ee ff ff ff 01 00  00 00 ff ff ff ff 00 00  |................|
> 000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
> 00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI PART....\...|
> 00000210  3a dc 43 c4 00 00 00 00  01 00 00 00 00 00 00 00  |:.C.............|
> 00000220  8e b6 c0 d1 01 00 00 00  22 00 00 00 00 00 00 00  |........".......|
> 00000230  6d b6 c0 d1 01 00 00 00  a5 4f bd 75 f6 c8 4f 43  |m........O.u..OC|
> 00000240  92 31 ab b6 a9 59 aa 04  02 00 00 00 00 00 00 00  |.1...Y..........|
> 00000250  80 00 00 00 80 00 00 00  59 04 3d 4a 00 00 00 00  |........Y.=J....|
> 00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|


OK it does in fact have a PMBR and GPT in the 1st and 2nd sector of
this partition. Pretty weird how it got there. There is a UUID
starting at offset 0x238 so you can look around and see if anything
else has that UUID or if that UUID ever changed or comes back after
you fix this. If it's not the same UUID, something is creating it with
a random UUID each time, which would mean it's not just being copied
from somewhere.


>
> ## is that the same as the boot sector itself?  Interesting q.
> # dd if=/dev/sdd count=2 of=/tmp/foo && dd if=/dev/sdd1 count=2 of=/tmp/bar && cmp /tmp/foo /tmp/bar
> ## Nope, how do they differ?  Well that's a bit unpleasant to do manually but here...
> # dd if=/dev/sdd count=2 2> /dev/null | hexdump -C
> 00000000  10 06 27 48 33 df bb 55  8b 28 fe 60 5e 18 6d 38  |..'H3..U.(.`^.m8|
> 00000010  fc b3 17 36 55 de fd 83  d0 52 72 19 d0 76 12 f0  |...6U....Rr..v..|
> 00000020  1e 23 bc 4d c5 4d c2 d6  5a d4 2b cd 16 78 c9 28  |.#.M.M..Z.+..x.(|
> 00000030  77 21 c4 9f c4 b7 48 ad  e0 7b 08 d6 f5 8e 92 a7  |w!....H..{......|
> 00000040  bc 88 35 02 e7 f8 b8 3b  05 97 db a3 ad e7 96 4b  |..5....;.......K|
> 00000050  84 d9 e2 a4 3a 5a 07 ac  fc a2 78 58 d7 c8 5a 19  |....:Z....xX..Z.|
> 00000060  88 9c f6 f2 c0 ec 99 55  d9 5d 00 87 3a 86 52 01  |.......U.]..:.R.|
> 00000070  92 58 25 82 99 50 8e 28  0f 42 07 71 9a a3 db 82  |.X%..P.(.B.q....|
> 00000080  00 d9 b8 28 9d d8 97 85  9d c6 fb 5e 4d 94 3a 6e  |...(.......^M.:n|
> 00000090  19 3c a6 ce 57 6b a0 52  d6 72 0c 41 2e cd cb a2  |.<..Wk.R.r.A....|
> 000000a0  15 c8 d4 c8 8c 90 34 5f  15 ab 69 96 af 3d 7e 30  |......4_..i..=~0|
> 000000b0  25 e1 72 35 d6 c4 b2 5e  78 72 0b 3f 9a 96 40 7e  |%.r5...^xr.?..@~|
> 000000c0  c6 aa 0e 5a da 99 ae fe  a3 93 8b 5b c4 bf 91 64  |...Z.......[...d|
> 000000d0  d5 62 12 ea 70 15 a9 05  81 8d e4 fb 36 15 c9 63  |.b..p.......6..c|
> 000000e0  ba f9 d2 5c f6 df 28 71  d8 d5 82 95 2b 83 40 db  |...\..(q....+.@.|
> 000000f0  9b fe e2 a7 9b 38 5e 5f  51 a6 6e e6 7b 4e bf 02  |.....8^_Q.n.{N..|
> 00000100  d2 fb aa f9 2c 7a 5b f5  47 ad ac 7e d1 1c f3 1b  |....,z[.G..~....|
> 00000110  a3 8e 54 9f a4 8d 1a 02  3f cc 81 f0 ca e9 28 1e  |..T.....?.....(.|
> 00000120  33 9e d8 71 dd f2 aa b7  d4 06 96 cb 0c 8e f1 6a  |3..q...........j|
> 00000130  88 1d 2a 8a a3 33 00 8c  ef d4 d8 39 3e 70 18 34  |..*..3.....9>p.4|
> 00000140  e6 3a cd e7 0b d6 82 a8  a4 aa ff bd b3 69 0a cc  |.:...........i..|
> 00000150  32 9e e3 26 34 bb cc 0e  b0 69 5f 9a c5 f3 57 7d  |2..&4....i_...W}|
> 00000160  47 82 bc 66 44 55 c4 de  3c 2c 14 d0 9a 73 6a da  |G..fDU..<,...sj.|
> 00000170  3c 5e f8 99 26 5b f4 8a  13 a1 f1 c8 a9 20 4c 3a  |<^..&[....... L:|
> 00000180  bd 03 4e e9 83 25 46 32  3f 80 3e 42 58 e7 18 27  |..N..%F2?.>BX..'|
> 00000190  8a c8 7c 8c 74 99 96 61  d4 e2 58 c2 27 71 8c 3b  |..|.t..a..X.'q.;|
> 000001a0  da 33 f8 7f b5 c1 a7 a0  c2 7b 54 29 0d 47 b4 b5  |.3.......{T).G..|
> 000001b0  4c 62 5b f8 e9 6f bc 29  00 00 00 00 00 00 00 00  |Lb[..o.)........|
> 000001c0  02 00 ee ff ff ff 01 00  00 00 ff ff ff ff 00 00  |................|
> 000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
> *
> 000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
> 00000200  45 46 49 20 50 41 52 54  00 00 01 00 5c 00 00 00  |EFI PART....\...|
> 00000210  62 01 85 1f 00 00 00 00  01 00 00 00 00 00 00 00  |b...............|
> 00000220  af be c0 d1 01 00 00 00  22 00 00 00 00 00 00 00  |........".......|
> 00000230  8e be c0 d1 01 00 00 00  e2 89 58 78 77 63 52 44  |..........XxwcRD|
> 00000240  93 9e 4a 93 16 06 86 6b  02 00 00 00 00 00 00 00  |..J....k........|
> 00000250  80 00 00 00 80 00 00 00  5d ff 7e 02 00 00 00 00  |........].~.....|
> 00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|

We kinda expect sdd to have a valid PMBR and GPT though... so that's
sane. I just don't know what to make of the stuff in LBA 0 before the
PMBR.


> I understand and can probably acquire the most recent stable and
> compile from source, if you think that would prove useful enough to
> justify the effort.  TBH once GPT came out I lost track of which
> partitioning tool was appropriate to use, it seemed like (IIRC)
> cfdisk, sfdisk, parted were all vying for my attention... is parted
> now the standard?

It is common. I prefer gdisk, which has a nomenclature similar to
fdisk. The nomenclature of parted is confusing.


>
> At the current moment I am backing up the drives so that I can try a
> forcible reassemble.  I think that last time this happened, that
> effectively relabeled the mdraid partitions and fixed the problem.
> The underlying mdraid has an LVM on LUKS, but last time this happened
> I managed to fsck and get 99% of the data back, with only a few things
> ending up in lost+found.  Presumably there might have been some data
> corruption, but since it's a backup server only I consider it
> tolerable, modulo the failed Windows system which needs to restore
> from it.

FWIW it's probably a lot simpler layout if you wanted to do either
linear or raid0, to just blow away all four drives with hdparm and ATA
security erase to get rid of all signatures; and then make all of them
into LVM physical volumes without any partitioning first, and then
make a logical volume, which by default is linear/concat, or you can
choose to use raid0 (this is a per logical volume characteristic), and
then encrypt the LV, and then format the LUKS volume. There's no
advantage to adding either partitions or mdadm RAIDs if you're going
to use LVM anyway and this is a Linux only storage enclosure.


-- 
Chris Murphy

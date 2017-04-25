From: =?UTF-8?Q?Patrik_Dahlstr=c3=b6m?= <risca@powerlamerz.org>
Subject: Re: Recover array after I panicked
Date: Wed, 26 Apr 2017 01:01:14 +0200
Message-ID: <a2667d99-84b6-29cd-8580-db4e377949c3@powerlamerz.org>
References: <3957da08-6ff4-3c15-e499-157244a767aa@powerlamerz.org>
 <807de641-043c-41a0-cffe-e28710503aba@fnarfbargle.com>
 <20170423144835.GB12093@metamorpher.de>
 <f353b7fc-a63a-5503-5cda-6a62698f69ae@powerlamerz.org>
 <20170423154240.GA3494@metamorpher.de>
 <718f75d1-b74f-f788-783a-6ffbdff275a8@powerlamerz.org>
 <63d6d0f5-d9b1-1218-b98e-48f9cf21a8bc@fnarfbargle.com>
 <CAHKno4AZukKvOEkVXPYMtnu1nypXLi95HaiFw+WNhAKP4KoLkg@mail.gmail.com>
 <20170424110455.GA4949@metamorpher.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170424110455.GA4949@metamorpher.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 04/24/2017 01:04 PM, Andreas Klauer wrote:
> On Mon, Apr 24, 2017 at 09:34:04AM +0200, Patrik Dahlström wrote:
> Now create two RAID sets:
> 
> # losetup -D
> # for f in ? ; do cp "$f" "$f".a ; done;
> # for f in ? ; do cp "$f" "$f".b ; done;
> # for a in *.a ; do losetup --find --show "$a" ; done
> # for b in *.b ; do losetup --find --show "$b" ; done
> # mdadm --create /dev/md42 --assume-clean --level=5 --raid-devices=5 /dev/loop{0,1,2,3,4}
> # mdadm --create /dev/md42 --assume-clean --level=5 --raid-devices=6 /dev/loop{5,6,7,8,9,10}
> 
> # cat /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] 
> md42 : active raid5 loop4[4] loop3[3] loop2[2] loop1[1] loop0[0]
>       405504 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>       
> md43 : active raid5 loop10[5] loop9[4] loop8[3] loop7[2] loop6[1] loop5[0]
>       506880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/6] [UUUUUU]
> 
> And compare:
> 
> # hexdump -C -n 64 /dev/md42
> 00000000  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 0a  |000000000000000.|
> 00000010  30 30 30 30 30 30 30 30  30 30 30 30 30 31 30 0a  |000000000000010.|
> 00000020  30 30 30 30 30 30 30 30  30 30 30 30 30 32 30 0a  |000000000000020.|
> 00000030  30 30 30 30 30 30 30 30  30 30 30 30 30 33 30 0a  |000000000000030.|
> 00000040
> # hexdump -C -n 64 /dev/md43
> 00000000  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 0a  |000000000000000.|
> 00000010  30 30 30 30 30 30 30 30  30 30 30 30 30 31 30 0a  |000000000000010.|
> 00000020  30 30 30 30 30 30 30 30  30 30 30 30 30 32 30 0a  |000000000000020.|
> 00000030  30 30 30 30 30 30 30 30  30 30 30 30 30 33 30 0a  |000000000000030.|
> 00000040
> 
> This is identical because in this example, the offset didn't change.
> 
> # hexdump -C -n 64 -s 80808080 /dev/md42
> 04d10890  30 30 30 30 30 30 30 30  35 66 31 30 38 39 30 0a  |000000005f10890.|
> 04d108a0  30 30 30 30 30 30 30 30  35 66 31 30 38 61 30 0a  |000000005f108a0.|
> 04d108b0  30 30 30 30 30 30 30 30  35 66 31 30 38 62 30 0a  |000000005f108b0.|
> 04d108c0  30 30 30 30 30 30 30 30  35 66 31 30 38 63 30 0a  |000000005f108c0.|
> 04d108d0
> # hexdump -C -n 64 -s 80808080 /dev/md43
> 04d10890  30 30 30 30 30 30 30 30  34 64 31 30 38 39 30 0a  |000000004d10890.|
> 04d108a0  30 30 30 30 30 30 30 30  34 64 31 30 38 61 30 0a  |000000004d108a0.|
> 04d108b0  30 30 30 30 30 30 30 30  34 64 31 30 38 62 30 0a  |000000004d108b0.|
> 04d108c0  30 30 30 30 30 30 30 30  34 64 31 30 38 63 30 0a  |000000004d108c0.|
> 04d108d0
> 
> For this offset, md42 was wrong, md43 is correct.
> 
> # hexdump -C -n 64 -s 300808080 /dev/md42
> 11edf790  30 30 30 30 30 30 30 31  31 65 64 66 37 39 30 0a  |000000011edf790.|
> 11edf7a0  30 30 30 30 30 30 30 31  31 65 64 66 37 61 30 0a  |000000011edf7a0.|
> 11edf7b0  30 30 30 30 30 30 30 31  31 65 64 66 37 62 30 0a  |000000011edf7b0.|
> 11edf7c0  30 30 30 30 30 30 30 31  31 65 64 66 37 63 30 0a  |000000011edf7c0.|
> 11edf7d0
> # hexdump -C -n 64 -s 300808080 /dev/md43
> 11edf790  30 30 30 30 30 30 30 31  31 65 64 66 37 39 30 0a  |000000011edf790.|
> 11edf7a0  30 30 30 30 30 30 30 31  31 65 64 66 37 61 30 0a  |000000011edf7a0.|
> 11edf7b0  30 30 30 30 30 30 30 31  31 65 64 66 37 62 30 0a  |000000011edf7b0.|
> 11edf7c0  30 30 30 30 30 30 30 31  31 65 64 66 37 63 30 0a  |000000011edf7c0.|
> 11edf7d0
> 
> For this offset, md42 and md43 overlapped. Grow progressed that far yet 
> without writing into the original data of the 5disk raid5. This could be 
> a suitable merge point for a linear device mapping.
> 
> # hexdump -C -n 64 -s 400008080 /dev/md42
> 17d7a390  30 30 30 30 30 30 30 31  37 64 37 61 33 39 30 0a  |000000017d7a390.|
> 17d7a3a0  30 30 30 30 30 30 30 31  37 64 37 61 33 61 30 0a  |000000017d7a3a0.|
> 17d7a3b0  30 30 30 30 30 30 30 31  37 64 37 61 33 62 30 0a  |000000017d7a3b0.|
> 17d7a3c0  30 30 30 30 30 30 30 31  37 64 37 61 33 63 30 0a  |000000017d7a3c0.|
> 17d7a3d0
> # hexdump -C -n 64 -s 400008080 /dev/md43
> 17d7a390  30 30 30 30 30 30 30 31  33 31 37 61 33 39 30 0a  |00000001317a390.|
> 17d7a3a0  30 30 30 30 30 30 30 31  33 31 37 61 33 61 30 0a  |00000001317a3a0.|
> 17d7a3b0  30 30 30 30 30 30 30 31  33 31 37 61 33 62 30 0a  |00000001317a3b0.|
> 17d7a3c0  30 30 30 30 30 30 30 31  33 31 37 61 33 63 30 0a  |00000001317a3c0.|
> 17d7a3d0
> 
> For this offset, md42 is correct and md43 is wrong.
> Grow did not progress that far.
> 
> That's the general outline of the idea. 
> The problem in your case is of course, your data is not that easy to verify.
I've been experimenting with this idea today by writing a small program
that looks for a mkv (matroska) header in a file, prints the offset and
then exit. I then extract 10 MB from that offset and try to play the
file with mpv.

$ ./find_matroska /dev/md1 0x202C0000000
Offset: 0x202C0000000 (2059 GB)
Offset: 0x20300000000 (2060 GB)
Found magic @ 0x2030CFCDDD7
Not matroska
Offset: 0x20340000000 (2061 GB)
Offset: 0x20380000000 (2062 GB)
Found magic @ 0x203A0005A49
Not matroska
Found magic @ 0x203AA800000
It's matroska

$ dd if=/dev/md1 bs=524288 count=20 skip=$((0x203AA800000/524288)) of=/tmp/raw.mkv
20+0 records in
20+0 records out
10485760 bytes (10 MB, 10 MiB) copied, 0.0748999 s, 140 MB/s

(copy to laptop and play)

On the 6 disk raid, I had no problem finding an mkv file at relatively
low offset (< 4 TB) that would play the whole 10 MB without issues.
Somewhere between 4-5 TB I start to get corrupted videos again. I
actually stumbled upon the exact same video on offsets:
0x400C1800000 (4 TB) : Intact, grow has come here
0x500F2B00000 (5 TB) : Corrupted, grow did not progress here yet

However, I was not able to do that on the 5 disk raid. It didn't matter
if I started the search at 1 TB or 16 TB, it would always have errors.

Would this mean that my data offset is wrong for the 5 disk raid?

Best regards
// Patrik

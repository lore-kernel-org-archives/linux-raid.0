From: Phil Turmel <philip@turmel.org>
Subject: Re: Brocken Raid & LUKS
Date: Thu, 21 Feb 2013 14:45:12 -0500
Message-ID: <51267948.60505@turmel.org>
References: <5123A1CC.2000003@heisl.org> <5123EF45.6080405@heisl.org> <5123F7C7.7000406@turmel.org> <5123FB71.3060509@heisl.org> <5124196F.6090000@turmel.org> <512516C2.3010105@heisl.org> <5125184A.6040707@turmel.org> <5125C6E9.4050802@heisl.org> <5125EBFD.3050802@heisl.org> <51262137.3040609@turmel.org> <51262CE0.3000809@heisl.org> <51263785.2010001@turmel.org> <51263D9D.1080002@heisl.org> <51263F7E.7040207@turmel.org> <5126421E.3040702@turmel.org> <51264C18.8000201@heisl.org> <51264E26.9050100@turmel.org> <51264EBF.9090000@heisl.org> <51264F7F.3020508@turmel.org> <512650A1.7070103@heisl.org> <51265132.7070706@turmel.org> <512656B5.4090505@heisl.org> <51265824.4030407@heisl.org> <51265B0B.9020108@turmel.org> <51265DA7.2030209@heisl.org> <512660B9.8090609@turmel.org> <5126629A.1090002@heis
 l.org> <51266360.9030402@turmel.org> <5126678D.9030101@heisl.org> <51266D73.5020700@turmel.org> <51267192.6090205@heisl.org> <51267467.9040603@turmel.org> <512675A6.1000801@heisl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512675A6.1000801@heisl.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stone <stone@heisl.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/21/2013 02:29 PM, Stone wrote:

> ok i let the hexdump running for 30-60 min and then i check mehr
> chunk. if i can open the luks i should check again the superblocks? 
> fsck.ext4 -n -b <superblock> /dev/mapper/md2_nas ?
> 
> but i see there is a result from hex:

[trim /]

None of those look like real superblocks.  Here's the beginning of that
report for a simple fs here:

00000430  1d 22 26 51 3b 00 ff ff  53 ef 01 00 01 00 00 00  |."&Q;...S.......|
0371f730  98 73 ed 8f 60 6a f0 5f  53 ef 43 bd 58 f0 b0 11  |.s..`j._S.C.X...|
0377dc30  24 18 c0 32 ef f2 c0 4a  53 ef ac 90 d1 30 9c 01  |$..2...JS....0..|
03951c30  26 0d 5f ef 3a a9 10 07  53 ef aa 87 3c 17 d1 32  |&._.:...S...<..2|
03a7ec30  77 6b fb 23 cf 1a d6 7f  53 ef ce 73 70 b4 8c ce  |wk.#....S..sp...|
05816930  22 00 f6 22 e8 a7 89 49  53 ef 56 00 e1 8d 5c b7  |".."...IS.V...\.|
06265630  e9 c3 a0 10 29 cc 70 b2  53 ef 8c 07 0d aa 30 90  |....).p.S.....0.|
066dae30  c1 c0 aa 32 6c 56 33 43  53 ef d4 bd 5f 03 fc 06  |...2lV3CS..._...|
06ee0730  88 8a 99 09 0e e8 af ba  53 ef db 77 83 62 6e a0  |........S..w.bn.|
07842630  c6 ff d7 79 f8 5d 20 87  53 ef cf df 67 90 91 19  |...y.] .S...g...|
08000030  42 5b f8 4f 00 00 ff ff  53 ef 00 00 01 00 00 00  |B[.O....S.......|
08826630  e2 ac 97 4a 7e 2e 17 26  53 ef 9f 59 22 5d 3a 28  |...J~..&S..Y"]:(|
0d2d6330  95 f6 5e c6 7c 1d 04 8e  53 ef d7 69 e1 0a d3 73  |..^.|...S..i...s|
0e077d30  c7 18 fa 82 4c e3 9f 78  53 ef 57 49 fb 1b 64 f9  |....L..xS.WI..d.|
0f213830  6e 1d 0b c1 85 d4 07 e5  53 ef f1 2c d7 2e b1 19  |n.......S..,....|
11ff3230  4c 22 10 55 c5 95 fa 7d  53 ef 57 22 6a 25 46 3d  |L".U...}S.W"j%F=|

The "candidates" at 00000430 and 08000030 are really part of a superblock.
The others are not.

Phil

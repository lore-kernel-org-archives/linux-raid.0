From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: SSD & mechanical disc in RAID 1
Date: Mon, 1 Feb 2010 12:56:29 -0800
Message-ID: <7a329d911002011256p61d13b33n9adc1850eec34b88@mail.gmail.com>
References: <7a329d911001090953j17829cd9qca0888fbcd7b4805@mail.gmail.com>
	 <20100109192326.GB16383@rap.rap.dk>
	 <87bpgmyu37.fsf@frosties.localdomain>
	 <7c2a12e21001311221r57f41ae8r7ee20470adcd8d6a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7c2a12e21001311221r57f41ae8r7ee20470adcd8d6a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aryeh Gregor <Simetrical+list@gmail.com>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Keld Jorn Simonsen <keld@keldix.com>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Jan 31, 2010 at 12:21 PM, Aryeh Gregor
<Simetrical+list@gmail.com> wrote:
> On Fri, Jan 22, 2010 at 11:37 AM, Goswin von Brederlow
> <goswin-v-b@web.de> wrote:
>> I think his initial idea of raid1 is verry good. With write-mostly a=
ll
>> reads should come from the fast SSD. I would also add write-behind.
>> That way writes will not wait for the rotating disk and get the full
>> SSD speed as well.
>
> Recently I got an Intel X25-M 80G, and have been trying this out. =C2=
=A0I
> figured some people here might be interested in the results. =C2=A0I'=
ve
> mirrored the SSD to a slow 80G partition on an old spinning-rust 160G
> disk, which is set to write-mostly, with write-behind of 16384 (the
> max). =C2=A0The bitmap is on a separate unmirrored partition on the S=
SD.
> My root filesystem is on it, ext4 on top of LVM, using 60G out of
> 73.77G allocated to LVM, with a separate 500M-ish mirrored boot
> partition at the start, and a gap in between for storing unmirrored
> things (like all my RAID bitmaps).
>
> I did six runs of bonnie++ overnight:
>
> 1) 128 files, both disks working.
> 2) 1024 files, both disks working.
> 3) 128 files, conventional disk failed and removed.
> 4) 1024 files, conventional disk failed and removed.
> 5) Same as (2).
> 6) Same as (4). =C2=A0(Note that in this case, the disk ended up bein=
g
> failed but not removed, but this should make no difference.)
>
> At the end of this e-mail, I've attached the full script I ran and it=
s
> full output. =C2=A0These are the bonnie++ numbers for the six tests, =
best
> viewed in a fixed-width font on a pretty wide screen (126 chars):
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0Sequential out =C2=A0=
 =C2=A0 =C2=A0| =C2=A0Sequential in =C2=A0 | Random =C2=A0|
> | =C2=A0 =C2=A0 Sequential create =C2=A0 =C2=A0 | =C2=A0 =C2=A0 =C2=A0=
 Random create =C2=A0 =C2=A0 =C2=A0|
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 |per char| block =C2=A0|rewrite |per char=
| =C2=A0block =C2=A0| Seeks =C2=A0 |
> | Create | =C2=A0Read =C2=A0 | Delete | Create | =C2=A0Read =C2=A0 |D=
elete |
> monoid,6G,47571,90,55343,30,41390,24,55803,96,233594,54,4923.0,36,
> 128,25973,94,+++++,+++,15910,41,27179,85,+++++,+++,11922,38
> monoid,6G,48358,90,55378,25,41338,25,56883,95,233689,52,4233.0,29,102=
4,19819,70,64728,
> 75, =C2=A0848, 4,14928,60,55484, 79, =C2=A0463, 3
> monoid,6G,48751,90,77485,27,45263,25,55660,94,238757,49,5107.7,33,
> 128,28027,86,+++++,+++,20161,49,29618,88,+++++,+++,14780,43
> monoid,6G,44503,83,73894,29,42975,26,56463,95,237173,53,5052.9,36,102=
4,18073,73,66151,
> 81, 5348,28,18102,65,60213, 77, 3441,23
> monoid,6G,48580,91,55567,24,40748,22,56803,95,237006,49,4828.2,29,102=
4,20332,67,73175,
> 80, =C2=A0783, 4,13615,45,58066, 74, =C2=A0489, 3
> monoid,6G,48966,92,77517,29,43999,24,56863,94,198557,38,3553.8,16,102=
4,19273,68,72414,
> 86, 6326,31,16499,60,56438, 75, 2784,15
>
> (Where two numbers are given, the first is KB out per second and the
> second is CPU usage, as far as I can figure.) Note that there was lot=
s
> of memory free here, about 2.5G (-/+ buffers/cache as reported by
> free). =C2=A0My conclusions:
>
> 1) The file creation tests with only 128 files should just be ignored=
,
> they look like they're in-memory. =C2=A0The 1024-file tests look more
> plausible.
>
> 2) All reads perform comparably whether the extra disk is present or
> not, as expected. =C2=A0There's some variation, but then, I wasn't be=
ing
> very scientific.
>
> 3) Tests 3, 4, and 6 (only SSD) are about 35% faster on the sequentia=
l
> out rewrite test. =C2=A0The per-char sequential out test was CPU-boun=
d, and
> everything performed the same. =C2=A0Everything also performed the sa=
me on
> the rewrite test; I'm not sure why.
>
> 4) Sequential file creation is about the same between tests 4 and 6
> (only SSD) and tests 2 and 5 (both disks). =C2=A0Random file creation=
 gives
> the disk+SSD about a 20% lead. =C2=A0But both sequential and random
> deletion have an order-of-magnitude difference between the two. =C2=A0=
I
> don't know why this might be -- lots of buffering for some operations
> but not others?
>
> Overall, this seems like a very feasible setup, and I'll certainly be
> sticking with it, even though it will obviously slow down some writes=
=2E
> =C2=A0Hope this data will be useful (or at least interesting) to some=
one.
>
> The script that I ran from the at job follows, with a couple of
> comments added. =C2=A0I ran it using ionice -c1 to reduce the effects=
 of
> any concurrent operations.
>
>
>
> #!/bin/bash
> cd /tmp
> echo Test 1; echo
> free -m
> bonnie -u 0 -n 128
> echo; echo Test 2; echo
> free -m
> echo
> bonnie -u 0 -n 1024
> echo; echo Test 3; echo
> free -m
> echo
> mdadm --fail /dev/md1 /dev/sda2
> sleep 5
> mdadm --remove /dev/md1 /dev/sda2
> echo
> bonnie -u 0 -n 128
> echo; echo Test 4; echo
> free -m
> echo
> bonnie -u 0 -n 1024
> echo
> free -m
> echo; echo 'Re-adding sda2 and waiting for sync'; echo
> sudo mdadm --add /dev/md1 --write-mostly /dev/sda2
> sleep 1800
> cat /proc/mdstat
> echo; echo Test 5; echo
> free -m
> echo
> bonnie -u 0 -n 1024
> echo
> mdadm --fail /dev/md1 /dev/sda2
> # The second command was run too fast and failed, I forgot the sleep =
5
> from above.
> mdadm --remove /dev/md1 /dev/sda2
> echo; echo Test 6; echo
> free -m
> echo
> bonnie -u 0 -n 1024
> echo
> free -m
> echo
> # Also failed, since the device hadn't been removed.
> sudo mdadm --add /dev/md1 --write-mostly /dev/sda2
>
>
>
>
> Output of script:
>
>
>
>
> Test 1
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 2085=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0938 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0589 =C2=A0 =C2=A0 =C2=A0 =C2=A0973
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0522 =C2=A0 =C2=A0 =C2=A0=
 2501
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0526=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0497
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 47571 =C2=A090 55343 =C2=
=A030 41390 =C2=A024 55803 =C2=A096 233594 =C2=A054 =C2=A04923 =C2=A036
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 128 25973 =C2=A094 +=
++++ +++ 15910 =C2=A041 27179 =C2=A085 +++++ +++ 11922 =C2=A038
> monoid,6G,47571,90,55343,30,41390,24,55803,96,233594,54,4923.0,36,128=
,25973,94,+++++,+++,15910,41,27179,85,+++++,+++,11922,38
>
> Test 2
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
544 =C2=A0 =C2=A0 =C2=A0 2480 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 51 =C2=A0 =C2=A0 =C2=A0 =C2=A0 30
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0462 =C2=A0 =C2=A0 =C2=A0=
 2562
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0526=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0497
>
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 48358 =C2=A090 55378 =C2=
=A025 41338 =C2=A025 56883 =C2=A095 233689 =C2=A052 =C2=A04233 =C2=A029
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01024 19819 =C2=A070 6=
4728 =C2=A075 =C2=A0 848 =C2=A0 4 14928 =C2=A060 55484 =C2=A079 =C2=A0 =
463 =C2=A0 3
> monoid,6G,48358,90,55378,25,41338,25,56883,95,233689,52,4233.0,29,102=
4,19819,70,64728,75,848,4,14928,60,55484,79,463,3
>
> Test 3
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
788 =C2=A0 =C2=A0 =C2=A0 2235 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0332 =C2=A0 =C2=A0 =C2=A0 =C2=A0 50
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0405 =C2=A0 =C2=A0 =C2=A0=
 2619
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0565=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0458
>
> mdadm: set /dev/sda2 faulty in /dev/md1
> mdadm: hot removed /dev/sda2
>
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 48751 =C2=A090 77485 =C2=
=A027 45263 =C2=A025 55660 =C2=A094 238757 =C2=A049 =C2=A05108 =C2=A033
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 128 28027 =C2=A086 +=
++++ +++ 20161 =C2=A049 29618 =C2=A088 +++++ +++ 14780 =C2=A043
> monoid,6G,48751,90,77485,27,45263,25,55660,94,238757,49,5107.7,33,128=
,28027,86,+++++,+++,20161,49,29618,88,+++++,+++,14780,43
>
> Test 4
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
441 =C2=A0 =C2=A0 =C2=A0 2582 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 48 =C2=A0 =C2=A0 =C2=A0 =C2=A0 25
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0367 =C2=A0 =C2=A0 =C2=A0=
 2656
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0594=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0429
>
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 44503 =C2=A083 73894 =C2=
=A029 42975 =C2=A026 56463 =C2=A095 237173 =C2=A053 =C2=A05053 =C2=A036
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01024 18073 =C2=A073 6=
6151 =C2=A081 =C2=A05348 =C2=A028 18102 =C2=A065 60213 =C2=A077 =C2=A03=
441 =C2=A023
> monoid,6G,44503,83,73894,29,42975,26,56463,95,237173,53,5052.9,36,102=
4,18073,73,66151,81,5348,28,18102,65,60213,77,3441,23
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
734 =C2=A0 =C2=A0 =C2=A0 2289 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0329 =C2=A0 =C2=A0 =C2=A0 =C2=A0 42
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0362 =C2=A0 =C2=A0 =C2=A0=
 2661
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0609=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0414
>
> Re-adding sda2 and waiting for sync
>
> mdadm: re-added /dev/sda2
> Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5]
> [raid4] [raid10]
> md2 : active raid1 sdb1[0] sda1[1](W)
> =C2=A0 =C2=A0 521984 blocks [2/2] [UU]
> =C2=A0 =C2=A0 bitmap: 0/64 pages [0KB], 4KB chunk, file: /mnt/ssd-jun=
k/boot-bitmap
>
> md3 : active raid10 sdc2[2] sdd2[1]
> =C2=A0 =C2=A0 488102656 blocks super 1.2 64K chunks 2 far-copies [2/2=
] [UU]
> =C2=A0 =C2=A0 bitmap: 1/466 pages [4KB], 512KB chunk, file: /mnt/ssd-=
junk/extra-bitmap
>
> md1 : active raid1 sda2[1](W) sdb2[0]
> =C2=A0 =C2=A0 77352896 blocks [2/2] [UU]
> =C2=A0 =C2=A0 bitmap: 29/296 pages [116KB], 128KB chunk, file: /mnt/s=
sd-junk/root-bitmap
>
> unused devices: <none>
>
> Test 5
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 1374=
 =C2=A0 =C2=A0 =C2=A0 1649 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0357 =C2=A0 =C2=A0 =C2=A0 =C2=A0621
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0396 =C2=A0 =C2=A0 =C2=A0=
 2627
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0602=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0421
>
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 48580 =C2=A091 55567 =C2=
=A024 40748 =C2=A022 56803 =C2=A095 237006 =C2=A049 =C2=A04828 =C2=A029
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01024 20332 =C2=A067 7=
3175 =C2=A080 =C2=A0 783 =C2=A0 4 13615 =C2=A045 58066 =C2=A074 =C2=A0 =
489 =C2=A0 3
> monoid,6G,48580,91,55567,24,40748,22,56803,95,237006,49,4828.2,29,102=
4,20332,67,73175,80,783,4,13615,45,58066,74,489,3
>
> mdadm: set /dev/sda2 faulty in /dev/md1
> mdadm: hot remove failed for /dev/sda2: Device or resource busy
>
> Test 6
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
720 =C2=A0 =C2=A0 =C2=A0 2303 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0335 =C2=A0 =C2=A0 =C2=A0 =C2=A0 40
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0345 =C2=A0 =C2=A0 =C2=A0=
 2678
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0653=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0370
>
> Using uid:0, gid:0.
> Writing with putc()...done
> Writing intelligently...done
> Rewriting...done
> Reading with getc()...done
> Reading intelligently...done
> start 'em...done...done...done...
> Create files in sequential order...done.
> Stat files in sequential order...done.
> Delete files in sequential order...done.
> Create files in random order...done.
> Stat files in random order...done.
> Delete files in random order...done.
> Version 1.03c =C2=A0 =C2=A0 =C2=A0 ------Sequential Output------ --Se=
quential Input- --Random-
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Per C=
hr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
> Machine =C2=A0 =C2=A0 =C2=A0 =C2=A0Size K/sec %CP K/sec %CP K/sec %CP=
 K/sec %CP K/sec %CP =C2=A0/sec %CP
> monoid =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6G 48966 =C2=A092 77517 =C2=
=A029 43999 =C2=A024 56863 =C2=A094 198557 =C2=A038 =C2=A03554 =C2=A016
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ------=
Sequential Create------ --------Random Create--------
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 -Creat=
e-- --Read--- -Delete-- -Create-- --Read--- -Delete--
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 files =C2=A0/sec %CP =C2=A0=
/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP =C2=A0/sec %CP
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01024 19273 =C2=A068 7=
2414 =C2=A086 =C2=A06326 =C2=A031 16499 =C2=A060 56438 =C2=A075 =C2=A02=
784 =C2=A015
> monoid,6G,48966,92,77517,29,43999,24,56863,94,198557,38,3553.8,16,102=
4,19273,68,72414,86,6326,31,16499,60,56438,75,2784,15
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0total =C2=A0 =C2=A0 =C2=A0 u=
sed =C2=A0 =C2=A0 =C2=A0 free =C2=A0 =C2=A0 shared =C2=A0 =C2=A0buffers=
 =C2=A0 =C2=A0 cached
> Mem: =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A03024 =C2=A0 =C2=A0 =C2=A0 2174=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0849 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0545 =C2=A0 =C2=A0 =C2=A0 1261
> -/+ buffers/cache: =C2=A0 =C2=A0 =C2=A0 =C2=A0366 =C2=A0 =C2=A0 =C2=A0=
 2657
> Swap: =C2=A0 =C2=A0 =C2=A0 =C2=A0 1023 =C2=A0 =C2=A0 =C2=A0 =C2=A0674=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0349
>
> mdadm: Cannot open /dev/sda2: Device or resource busy
>

Thanks for providing this information, its quite useful.  I suspect
I'll be trying something like this myself in the near future.

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

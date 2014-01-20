From: Ian Kumlien <ian.kumlien@gmail.com>
Subject: Re: [BUG] at drivers/md/raid5.c:291! kernel 3.13-rc8
Date: Mon, 20 Jan 2014 01:49:17 +0100
Message-ID: <1390178957.587.9.camel@localhost>
References: <1390168823.587.1.camel@localhost>
	 <20140120113851.3b476ed8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140120113851.3b476ed8@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On m=C3=A5n, 2014-01-20 at 11:38 +1100, NeilBrown wrote:
> On Sun, 19 Jan 2014 23:00:23 +0100 Ian Kumlien <ian.kumlien@gmail.com=
> wrote:
>=20
> > Ok, so third try to actually email this...=20
> > ---
> >=20
> > Hi,
> >=20
> > I started testing 3.13-rc8 on another machine since the first one s=
eemed
> > to be working fine...
> >=20
> > One spontaneous reboot later i'm not so sure ;)
> >=20
> > Right now i captured a kernel oops in the raid code it seems...
> >=20
> > (Also attached to avoid mangling)
> >=20
> > [33411.934672] ------------[ cut here ]------------
> > [33411.934685] kernel BUG at drivers/md/raid5.c:291!
> > [33411.934690] invalid opcode: 0000 [#1] PREEMPT SMP=20
> > [33411.934696] Modules linked in: bonding btrfs microcode
> > [33411.934705] CPU: 4 PID: 2319 Comm: md2_raid6 Not tainted 3.13.0-=
rc8 #83
> > [33411.934709] Hardware name: System manufacturer System Product Na=
me/Crosshair IV Formula, BIOS 3029    10/09/2012
> > [33411.934716] task: ffff880326265880 ti: ffff880320472000 task.ti:=
 ffff880320472000
> > [33411.934720] RIP: 0010:[<ffffffff81a3a5be>]  [<ffffffff81a3a5be>]=
 do_release_stripe+0x18e/0x1a0
> > [33411.934731] RSP: 0018:ffff880320473d28  EFLAGS: 00010087
> > [33411.934735] RAX: ffff8802f0875a60 RBX: 0000000000000001 RCX: fff=
f8800b0d816b0
> > [33411.934739] RDX: ffff880324eeee98 RSI: ffff8802f0875a40 RDI: fff=
f880324eeec00
> > [33411.934743] RBP: ffff8802f0875a50 R08: 0000000000000000 R09: 000=
0000000000001
> > [33411.934747] R10: 0000000000000000 R11: 0000000000000000 R12: fff=
f880324eeec00
> > [33411.934752] R13: ffff880324eeee58 R14: ffff880320473e88 R15: 000=
0000000000000
> > [33411.934756] FS:  00007fc38654d700(0000) GS:ffff880337d00000(0000=
) knlGS:0000000000000000
> > [33411.934761] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> > [33411.934765] CR2: 00007f0cb28bd000 CR3: 00000002ebcf6000 CR4: 000=
00000000407e0
> > [33411.934769] Stack:
> > [33411.934771]  ffff8800bba09690 ffff8800b4f16588 ffff880303005a40 =
0000000000000001
> > [33411.934779]  ffff8800b33e43d0 ffffffff81a3a62d ffff880324eeee58 =
0000000000000000
> > [33411.934786]  ffff880324eeee58 ffff880326660670 ffff880326265880 =
ffffffff81a41692
> > [33411.934794] Call Trace:
> > [33411.934798]  [<ffffffff81a3a62d>] ? release_stripe_list+0x4d/0x7=
0
> > [33411.934803]  [<ffffffff81a41692>] ? raid5d+0xa2/0x4d0
> > [33411.934808]  [<ffffffff81a65ed6>] ? md_thread+0xe6/0x120
> > [33411.934814]  [<ffffffff81122060>] ? finish_wait+0x90/0x90
> > [33411.934818]  [<ffffffff81a65df0>] ? md_rdev_init+0x100/0x100
> > [33411.934823]  [<ffffffff8110958c>] ? kthread+0xbc/0xe0
> > [33411.934828]  [<ffffffff81110000>] ? smpboot_park_threads+0x70/0x=
70Hi,
>=20
> Thanks for the report.
> Can you provide any more context about the details of the array in qu=
estion?
> I see it was RAID6.  Was it degraded?  Was it resyncing?  Was it bein=
g
> reshaped?
> Was there any way that it was different from the array one the machin=
e where
> it seemed to work?

Yes, it's a raid6 and no, there is no reshaping or syncing going on...=20

Basically everything worked fine before:
reboot   system boot  3.13.0-rc8       Sun Jan 19 21:47 - 01:42  (03:55=
)   =20
reboot   system boot  3.13.0-rc8       Sun Jan 19 21:38 - 01:42  (04:04=
)   =20
reboot   system boot  3.13.0-rc8       Sun Jan 19 12:13 - 01:42  (13:29=
)   =20
reboot   system boot  3.13.0-rc8       Sat Jan 18 21:23 - 01:42 (1+04:1=
9)  =20
reboot   system boot  3.12.6           Mon Dec 30 16:27 - 22:21 (19+05:=
53) =20

As in, no problems before the 3.13.0-rc8 upgrade...

cat /proc/mdstat:
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4] [multipath]=20
md2 : active raid6 sdf1[2] sdd1[9] sdj1[8] sdg1[4] sde1[5] sdi1[11] sdc=
1[0] sdh1[10]
      11721074304 blocks super 1.2 level 6, 64k chunk, algorithm 2 [8/8=
] [UUUUUUUU]
      bitmap: 0/15 pages [0KB], 65536KB chunk

What i do do is:
echo 32768 > /sys/block/*/md/stripe_cache_size

Which has caused no problems during intense write operations before...=20

I find it quite surprising since it only requires ~3 gigabytes of write=
s
to die and almost assume that it's related to the stripe_cache_size.
(Since all memory is ECC and i doubt it would break, quite literally,
over night i haven't run extensive memory tests)

I don't quite know what other information you might need...

> Thanks,
> NeilBrown

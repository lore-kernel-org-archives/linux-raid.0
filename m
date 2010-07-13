From: Sebastian Reichel <elektranox@gmail.com>
Subject: Re: power outage while raid5->raid6 was in progress
Date: Wed, 14 Jul 2010 00:14:12 +0200
Message-ID: <20100713221412.GA29708@earth.universe>
References: <20100707204110.GB1207@earth.universe>
 <20100708084450.7abb19d8@notabene.brown>
 <20100707231316.GA6496@earth.universe>
 <20100708112144.1b70d6da@notabene.brown>
 <20100708084837.GA7410@earth.universe>
 <20100709084808.72fc8fd4@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100709084808.72fc8fd4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I just did as you told:
 * upgrading to 2.6.34.1
 * go back to 5 disk raid5
 * start raid5 -> raid6 again

This time I got no error and it began reshaping:
md0 : active raid6 sdk1[0] sdf1[5] sdg1[6] sdh1[7] sdi1[4] sdj1[3] sdl1[2] sde1[1]
      5860543744 blocks super 0.91 level 6, 64k chunk, algorithm 18 [8/7] [UUUUU_UU]
      [>....................]  reshape =  2.8% (41047020/1465135936) finish=32916.5min speed=721K/sec

The reshaping got stuck again. Checking top I can see ksoftirqd uses 100% CPU on one
of the 2 cores. But there is one difference. This time there are no complains about any
disk device(s). Here is the dmesg output - The lower part (from 'blocked for more than
120 seconds') is repeated multiple times.

[  612.736649] raid5: device sdk1 operational as raid disk 0
[  612.736653] raid5: device sdi1 operational as raid disk 4
[  612.736656] raid5: device sdj1 operational as raid disk 3
[  612.736658] raid5: device sdl1 operational as raid disk 2
[  612.736660] raid5: device sde1 operational as raid disk 1
[  612.737301] raid5: allocated 6386kB for md0
[  612.749007] 0: w=1 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
[  612.749011] 4: w=2 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
[  612.749014] 3: w=3 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
[  612.749016] 2: w=4 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
[  612.749018] 1: w=5 pa=0 pr=6 m=2 a=18 r=6 op1=0 op2=0
[  612.749021] raid5: raid level 6 set md0 active with 5 out of 6 devices, algorithm 18
[  612.749065] RAID5 conf printout:
[  612.749067]  --- rd:6 wd:5
[  612.749069]  disk 0, o:1, dev:sdk1
[  612.749071]  disk 1, o:1, dev:sde1
[  612.749073]  disk 2, o:1, dev:sdl1
[  612.749075]  disk 3, o:1, dev:sdj1
[  612.749077]  disk 4, o:1, dev:sdi1
[  612.779095] RAID5 conf printout:
[  612.779099]  --- rd:8 wd:7
[  612.779102]  disk 0, o:1, dev:sdk1
[  612.779104]  disk 1, o:1, dev:sde1
[  612.779105]  disk 2, o:1, dev:sdl1
[  612.779107]  disk 3, o:1, dev:sdj1
[  612.779109]  disk 4, o:1, dev:sdi1
[  612.779111]  disk 5, o:1, dev:sdf1
[  612.779117] RAID5 conf printout:
[  612.779118]  --- rd:8 wd:7
[  612.779120]  disk 0, o:1, dev:sdk1
[  612.779122]  disk 1, o:1, dev:sde1
[  612.779123]  disk 2, o:1, dev:sdl1
[  612.779125]  disk 3, o:1, dev:sdj1
[  612.779127]  disk 4, o:1, dev:sdi1
[  612.779129]  disk 5, o:1, dev:sdf1
[  612.779130]  disk 6, o:1, dev:sdg1
[  612.779134] RAID5 conf printout:
[  612.779135]  --- rd:8 wd:7
[  612.779136]  disk 0, o:1, dev:sdk1
[  612.779138]  disk 1, o:1, dev:sde1
[  612.779140]  disk 2, o:1, dev:sdl1
[  612.779142]  disk 3, o:1, dev:sdj1
[  612.779143]  disk 4, o:1, dev:sdi1
[  612.779145]  disk 5, o:1, dev:sdf1
[  612.779147]  disk 6, o:1, dev:sdg1
[  612.779149]  disk 7, o:1, dev:sdh1
[  612.779233] md: reshape of RAID array md0
[  612.779235] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  612.779237] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reshape.
[  612.779244] md: using 128k window, over a total of 1465135936 blocks.
[ 2846.784515] Clocksource tsc unstable (delta = 4398042075725 ns)
[ 3000.536656] INFO: task md0_reshape:5554 blocked for more than 120 seconds.
[ 3000.536675] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 3000.536699] md0_reshape   D 0000000100099eb1     0  5554      2 0x00000000
[ 3000.536704]  ffff88007e08f700 0000000000000046 0000000000000082 ffff88006d3d1290
[ 3000.536707]  ffffffff81632020 0000000000015280 0000000000015280 0000000000015280
[ 3000.536711]  ffff88007e1f3fd8 0000000000015280 ffff88007e08f700 ffff88007e1f3fd8
[ 3000.536714] Call Trace:
[ 3000.536735]  [<ffffffffa019e735>] ? reshape_request+0x1e7/0x7a8 [raid456]
[ 3000.536741]  [<ffffffff8105d519>] ? autoremove_wake_function+0x0/0x2a
[ 3000.536746]  [<ffffffffa019ee87>] ? sync_request+0x191/0x2d1 [raid456]
[ 3000.536754]  [<ffffffffa0180a0b>] ? is_mddev_idle+0xa2/0xf5 [md_mod]
[ 3000.536760]  [<ffffffffa0181171>] ? md_do_sync+0x713/0xb0f [md_mod]
[ 3000.536764]  [<ffffffff8103767e>] ? update_curr+0xa2/0x145
[ 3000.536771]  [<ffffffffa0181d4a>] ? md_thread+0xf2/0x110 [md_mod]
[ 3000.536777]  [<ffffffffa0181c58>] ? md_thread+0x0/0x110 [md_mod]
[ 3000.536779]  [<ffffffff8105d0e5>] ? kthread+0x75/0x7d
[ 3000.536783]  [<ffffffff810097e4>] ? kernel_thread_helper+0x4/0x10
[ 3000.536786]  [<ffffffff8105d070>] ? kthread+0x0/0x7d
[ 3000.536788]  [<ffffffff810097e0>] ? kernel_thread_helper+0x0/0x10

-- Sebastian

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw85TQACgkQH0JwilpTmKgfggCeKs3AMcaTT3CEOWsfgHN3pYQW
ZPsAniYirK09ytDPSXPLKUAx4O/DSK6r
=ObYP
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--

From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: Strange CPU occupation... and system hangs
Date: Thu, 01 Nov 2007 10:25:04 +0100
Message-ID: <47299B70.9030507@systella.fr>
References: <4728773C.7010802@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <iscsitarget-devel-bounces@lists.sourceforge.net>
In-Reply-To: <4728773C.7010802@systella.fr>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=iscsitarget-devel>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: iscsitarget-devel-bounces@lists.sourceforge.net
Errors-To: iscsitarget-devel-bounces@lists.sourceforge.net
To: sparclinux@vger.kernel.org, linux-raid@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

BERTRAND Jo=EBl wrote:

<snip>

> and some process are in D state :
> Root gershwin:[/etc] > ps auwx | grep D
> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
> root       270  0.0  0.0      0     0 ?        D    Oct27   1:17 [pdflush]
> root      3676  0.9  0.0      0     0 ?        D    Oct27  56:03 [nfsd]
> root      5435  0.0  0.0      0     0 ?        D<   Oct27   3:16 [md7_rai=
d1]
> root      5438  0.0  0.0      0     0 ?        D<   Oct27   1:01 [kjourna=
ld]
> root      5440  0.0  0.0      0     0 ?        D<   Oct27   0:33 [loop0]
> root      5441  0.0  0.0      0     0 ?        D<   Oct27   0:05 [kjourna=
ld]
> root     16442  0.0  0.0  20032  1208 pts/2    D+   13:23   0:00 iftop =

> -i eth2
> =

> 	Why md7_raid is in D state ? Same question about iftop ?

	Some bad news... After ten or eleven hours, kernel crashes on this =

server. The last top screen is :

top - 04:59:46 up 4 days, 16:24,  3 users,  load average: 19.72, 19.22, =

19.05
Tasks: 285 total,   5 running, 279 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.0%us,  4.2%sy,  0.0%ni, 68.5%id, 27.3%wa,  0.0%hi,  0.0%si, =

0.0%st
Mem:   4139024k total,  4130800k used,     8224k free,    38984k buffers
Swap:  7815536k total,      304k used,  7815232k free,    79056k cached
PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND =


5426 root      15  -5     0    0    0 R  100  0.0 970:17.21 md_d0_raid5
26923 root      20   0  3120 1568 1112 R    2  0.0  13:32.24 top =


...

	I have rebooted. I don't have any message in log files. I don't have =

any screen but I haven't seen anything on serial console. In ker.log, I =

have :
Oct 31 15:36:15 gershwin kernel: swapper: page allocation failure. =

order:2, mode:0x4020
Oct 31 15:36:15 gershwin kernel: Call Trace:
Oct 31 15:36:15 gershwin kernel:  [00000000004b6568] =

__slab_alloc+0x1b0/0x720
Oct 31 15:36:15 gershwin kernel:  [00000000004b87a8] =

__kmalloc_track_caller+0xb0/0xe0
Oct 31 15:36:15 gershwin kernel:  [0000000000601d68] __alloc_skb+0x50/0x120
Oct 31 15:36:15 gershwin kernel:  [0000000000642ee0] =

tcp_collapse+0x1e8/0x440
Oct 31 15:36:15 gershwin kernel:  [0000000000643298] =

tcp_prune_queue+0x160/0x3a0
Oct 31 15:36:15 gershwin kernel:  [0000000000643d08] =

tcp_data_queue+0x830/0xde0
Oct 31 15:36:15 gershwin kernel:  [0000000000645d74] =

tcp_rcv_established+0x35c/0x840
Oct 31 15:36:15 gershwin kernel:  [000000000064cf7c] =

tcp_v4_do_rcv+0xe4/0x4a0
Oct 31 15:36:15 gershwin kernel:  [000000000064fdd8] tcp_v4_rcv+0xb00/0xb20
Oct 31 15:36:15 gershwin kernel:  [000000000062e2ac] =

ip_local_deliver+0x194/0x3a0
Oct 31 15:36:15 gershwin kernel:  [000000000062dd98] ip_rcv+0x360/0x6e0
Oct 31 15:36:15 gershwin kernel:  [0000000000607f64] =

netif_receive_skb+0x1ec/0x480
Oct 31 15:36:15 gershwin kernel:  [00000000005a5fe0] tg3_poll+0x6c8/0xc40
Oct 31 15:36:15 gershwin kernel:  [000000000060a940] =

net_rx_action+0x88/0x160
Oct 31 15:36:15 gershwin kernel:  [0000000000468078] __do_softirq+0x80/0x100
Oct 31 15:36:15 gershwin kernel:  [000000000046815c] do_softirq+0x64/0x80
Oct 31 15:36:15 gershwin kernel: Mem-info:
Oct 31 15:36:15 gershwin kernel: Normal per-cpu:
Oct 31 15:36:15 gershwin kernel: CPU    0: Hot: hi:   90, btch:  15 usd: =

  15   Cold: hi:   30, btch:   7 usd:   5
Oct 31 15:36:15 gershwin kernel: CPU    1: Hot: hi:   90, btch:  15 usd: =

  31   Cold: hi:   30, btch:   7 usd:   4
Oct 31 15:36:15 gershwin kernel: CPU    2: Hot: hi:   90, btch:  15 usd: =

   4   Cold: hi:   30, btch:   7 usd:   3
Oct 31 15:36:15 gershwin kernel: CPU    3: Hot: hi:   90, btch:  15 usd: =

  82   Cold: hi:   30, btch:   7 usd:   2
Oct 31 15:36:15 gershwin kernel: CPU    4: Hot: hi:   90, btch:  15 usd: =

  84   Cold: hi:   30, btch:   7 usd:   0
Oct 31 15:36:15 gershwin kernel: CPU    5: Hot: hi:   90, btch:  15 usd: =

  65   Cold: hi:   30, btch:   7 usd:   4
Oct 31 15:36:15 gershwin kernel: CPU    6: Hot: hi:   90, btch:  15 usd: =

  85   Cold: hi:   30, btch:   7 usd:   6
Oct 31 15:36:15 gershwin kernel: CPU    7: Hot: hi:   90, btch:  15 usd: =

  69   Cold: hi:   30, btch:   7 usd:   4
Oct 31 15:36:15 gershwin kernel: CPU    8: Hot: hi:   90, btch:  15 usd: =

  11   Cold: hi:   30, btch:   7 usd:   5
Oct 31 15:36:15 gershwin kernel: CPU    9: Hot: hi:   90, btch:  15 usd: =

  75   Cold: hi:   30, btch:   7 usd:   1
Oct 31 15:36:15 gershwin kernel: CPU   10: Hot: hi:   90, btch:  15 usd: =

  84   Cold: hi:   30, btch:   7 usd:   2
Oct 31 15:36:15 gershwin kernel: CPU   11: Hot: hi:   90, btch:  15 usd: =

  13   Cold: hi:   30, btch:   7 usd:   1
Oct 31 15:36:15 gershwin kernel: CPU   12: Hot: hi:   90, btch:  15 usd: =

  17   Cold: hi:   30, btch:   7 usd:  23
Oct 31 15:36:15 gershwin kernel: CPU   13: Hot: hi:   90, btch:  15 usd: =

   7   Cold: hi:   30, btch:   7 usd:  25
Oct 31 15:36:15 gershwin kernel: CPU   14: Hot: hi:   90, btch:  15 usd: =

  64   Cold: hi:   30, btch:   7 usd:  27
Oct 31 15:36:15 gershwin kernel: CPU   15: Hot: hi:   90, btch:  15 usd: =

  12   Cold: hi:   30, btch:   7 usd:   6
Oct 31 15:36:15 gershwin kernel: CPU   16: Hot: hi:   90, btch:  15 usd: =

   2   Cold: hi:   30, btch:   7 usd:   1
Oct 31 15:36:15 gershwin kernel: CPU   17: Hot: hi:   90, btch:  15 usd: =

  80   Cold: hi:   30, btch:   7 usd:   1
Oct 31 15:36:15 gershwin kernel: CPU   18: Hot: hi:   90, btch:  15 usd: =

   4   Cold: hi:   30, btch:   7 usd:  17
Oct 31 15:36:15 gershwin kernel: CPU   19: Hot: hi:   90, btch:  15 usd: =

  58   Cold: hi:   30, btch:   7 usd:   1
Oct 31 15:36:16 gershwin kernel: CPU   20: Hot: hi:   90, btch:  15 usd: =

  13   Cold: hi:   30, btch:   7 usd:   4
Oct 31 15:36:16 gershwin kernel: CPU   21: Hot: hi:   90, btch:  15 usd: =

  87   Cold: hi:   30, btch:   7 usd:   2
Oct 31 15:36:16 gershwin kernel: CPU   22: Hot: hi:   90, btch:  15 usd: =

  77   Cold: hi:   30, btch:   7 usd:   6
Oct 31 15:36:16 gershwin kernel: CPU   23: Hot: hi:   90, btch:  15 usd: =

  10   Cold: hi:   30, btch:   7 usd:   2
Oct 31 15:36:16 gershwin kernel: Active:72131 inactive:275943 dirty:6433 =

writeback:1041 unstable:0
Oct 31 15:36:16 gershwin kernel:  free:2187 slab:131941 mapped:1732 =

pagetables:258 bounce:0
Oct 31 15:36:16 gershwin kernel: Normal free:17496kB min:8144kB =

low:10176kB high:12216kB active:577048kB inactive:2207544kB =

present:4149440kB pages_scanned:0 all_unreclaimable? no
Oct 31 15:36:16 gershwin kernel: lowmem_reserve[]: 0 0
Oct 31 15:36:16 gershwin kernel: Normal: 1786*8kB 173*16kB 0*32kB 1*64kB =

0*128kB 0*256kB 1*512kB 0*1024kB 0*2048kB 0*4096kB 0*8192kB =3D 17632kB
Oct 31 15:36:16 gershwin kernel: Swap cache: add 39, delete 39, find =

0/0, race 0+0
Oct 31 15:36:16 gershwin kernel: Free swap  =3D 7815232kB
Oct 31 15:36:16 gershwin kernel: Free swap  =3D 7815232kB
Oct 31 15:36:16 gershwin kernel: Total swap =3D 7815536kB
Oct 31 15:36:16 gershwin kernel: Free swap:       7815232kB
Oct 31 15:36:17 gershwin kernel: 524260 pages of RAM
Oct 31 15:36:17 gershwin kernel: 6882 reserved pages
Oct 31 15:36:17 gershwin kernel: 278965 pages shared
Oct 31 15:36:17 gershwin kernel: 0 pages swap cached
Oct 31 15:36:17 gershwin kernel: 6435 pages dirty
Oct 31 15:36:17 gershwin kernel: 1041 pages writeback
Oct 31 15:36:17 gershwin kernel: 1732 pages mapped
Oct 31 15:36:17 gershwin kernel: 131941 pages slab
Oct 31 15:36:17 gershwin kernel: 258 pages pagetables

	Any idea ?

	Regards,

	JKB

-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >> http://get.splunk.com/

From: NeilBrown <neilb@suse.de>
Subject: Re: Raid1 resync problem with leap seconds ?
Date: Mon, 9 Jul 2012 11:09:56 +1000
Message-ID: <20120709110956.0a66d577@notabene.brown>
References: <4FF6DB2B.1090905@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/qY8BlqMTX6c/H7nQBK7oqHE"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FF6DB2B.1090905@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Arnold Schulz <arnysch@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/qY8BlqMTX6c/H7nQBK7oqHE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 06 Jul 2012 14:33:47 +0200 Arnold Schulz <arnysch@gmx.net> wrote:

> Hi all,
>=20
> about 8 seconds after inserting the leap second, a running raid1
> resync crashed.

Thanks for the report.

I think you mean "8 minutes" (though it was really 7 minutes and 12 seconds=
).

Also it was a 'data-check' rather than a 'resync' :-)

It is extremely unlikely that the two are related.

There appears to be a use-after-free bug in the data-check code which you
have manage to hit.  It has been there since 2006 (2.6.16) when data-check =
was
added to raid1, and you are the first known victim.  Well done!

I'll submit a patch shortly.

>=20
> Not being able to assess if it is the raid code or some kernel
> timer function to blame, I just present the log here.

Thanks for providing the complete log.  It was very helpful.

NeilBrown


>=20
> Regards,
> Arnold
>=20
> --------------------------------------------
> Jul  1 01:03:24 ip4-router kernel: md: data-check of RAID array md2
> Jul  1 01:03:24 ip4-router kernel: md: minimum _guaranteed_  speed: 1000 =
KB/sec/disk.
> Jul  1 01:03:24 ip4-router kernel: md: using maximum available idle IO ba=
ndwidth (but not more than 200000 KB/sec) for data-check.
> Jul  1 01:03:24 ip4-router kernel: md: using 128k window, over a total of=
 1924209408k.
> Jul  1 01:59:59 ip4-router kernel: Clock: inserting leap second 23:59:60 =
UTC
> Jul  1 02:07:12 ip4-router kernel: BUG: unable to handle kernel NULL poin=
ter dereference at 0000000000000050
> Jul  1 02:07:12 ip4-router kernel: IP: [<ffffffff81300e18>] sync_request+=
0x628/0x970
> Jul  1 02:07:12 ip4-router kernel: PGD 0
> Jul  1 02:07:12 ip4-router kernel: Oops: 0000 [#1] PREEMPT SMP
> Jul  1 02:07:12 ip4-router kernel: CPU 1
> Jul  1 02:07:12 ip4-router kernel: Modules linked in: parport_pc parport =
binfmt_misc deflate zlib_deflate zlib_inflate ctr=20
> twofish_generic twofish_x86_64_3way twofish_x86_64 camellia_generic twofi=
sh_common camellia_x86_64 serpent_sse2_x86_64=20
> serpent_generic cryptd lrw blowfish_generic blowfish_x86_64 blowfish_comm=
on cast5 des_generic xcbc rmd160 sha512_generic=20
> sha256_generic sha1_generic crypto_null af_key fuse mt2060 dvb_usb_dib070=
0 dib3000mc dib8000 dvb_usb dib0070 dib7000m dib7000p=20
> dibx000_common dib0090 dvb_core hfcpci mISDN_core
> Jul  1 02:07:12 ip4-router kernel:
> Jul  1 02:07:12 ip4-router kernel: Pid: 17823, comm: md2_resync Not taint=
ed 3.4.4 #109 To Be Filled By O.E.M. To Be Filled By=20
> O.E.M./N68PV-GS
> Jul  1 02:07:12 ip4-router kernel: RIP: 0010:[<ffffffff81300e18>]  [<ffff=
ffff81300e18>] sync_request+0x628/0x970
> Jul  1 02:07:12 ip4-router kernel: RSP: 0018:ffff8800224e9c30  EFLAGS: 00=
010202
> Jul  1 02:07:12 ip4-router kernel: RAX: 0000000000000002 RBX: 00000000000=
00002 RCX: 0000000000000001
> Jul  1 02:07:12 ip4-router kernel: RDX: 0000000000000002 RSI: ffff88006d7=
c4d30 RDI: 0000000000000000
> Jul  1 02:07:12 ip4-router kernel: RBP: ffff8800224e9ce0 R08: ffff8800224=
e8000 R09: 0000000000000001
> Jul  1 02:07:12 ip4-router kernel: R10: 000000000000013e R11: 00000000000=
00000 R12: 0000000000000080
> Jul  1 02:07:12 ip4-router kernel: R13: ffff88006b403840 R14: ffff88006c7=
11680 R15: ffffea0000ca7580
> Jul  1 02:07:12 ip4-router kernel: FS:  00007f441eafa700(0000) GS:ffff880=
06fd00000(0000) knlGS:0000000000000000
> Jul  1 02:07:12 ip4-router kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 00000=
0008005003b
> Jul  1 02:07:12 ip4-router kernel: CR2: 0000000000000050 CR3: 000000005c5=
3f000 CR4: 00000000000007e0
> Jul  1 02:07:12 ip4-router kernel: DR0: 0000000000000000 DR1: 00000000000=
00000 DR2: 0000000000000000
> Jul  1 02:07:12 ip4-router kernel: DR3: 0000000000000000 DR6: 00000000fff=
f0ff0 DR7: 0000000000000400
> Jul  1 02:07:12 ip4-router kernel: Process md2_resync (pid: 17823, thread=
info ffff8800224e8000, task ffff88006d7c4d30)
> Jul  1 02:07:12 ip4-router kernel: Stack:
> Jul  1 02:07:12 ip4-router kernel: 00000000e5623600 ffff880000000000 0000=
000029ca6880 0000008029ca5f00
> Jul  1 02:07:12 ip4-router kernel: ffff8800224e9e2c 0000000000000000 0000=
000200000000 0000000029ca6900
> Jul  1 02:07:12 ip4-router kernel: 0000000029ca6900 0000000000000080 0000=
000000001000 ffff88006b68dc00
> Jul  1 02:07:12 ip4-router kernel: Call Trace:
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff813163e3>] md_do_sync+0x7d3/=
0xc60
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104ac90>] ? abort_exclusive=
_wait+0xb0/0xb0
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff81312f7e>] md_thread+0x10e/0=
x140
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff81312e70>] ? md_register_thr=
ead+0x110/0x110
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104a4ee>] kthread+0x8e/0xa0
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff8146b4f4>] kernel_thread_hel=
per+0x4/0x10
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff8104a460>] ? kthread_worker_=
fn+0x130/0x130
> Jul  1 02:07:12 ip4-router kernel: [<ffffffff8146b4f0>] ? gs_change+0xb/0=
xb
> Jul  1 02:07:12 ip4-router kernel: Code: 0f 84 35 02 00 00 8b 45 84 41 89=
 06 41 8b 55 10 48 8b 45 98 8d 0c 12 85 c9 0f 8e 85 fa=20
> ff ff 31 db 66 90 48 63 c3 49 8b 7c c6 58 <48> 81 7f 50 10 f4 2f 81 0f 84=
 b2 01 00 00 8d 04 12 ff c3 39 d8
> Jul  1 02:07:12 ip4-router kernel: RIP  [<ffffffff81300e18>] sync_request=
+0x628/0x970
> Jul  1 02:07:12 ip4-router kernel: RSP <ffff8800224e9c30>
> Jul  1 02:07:12 ip4-router kernel: CR2: 0000000000000050
> Jul  1 02:07:12 ip4-router kernel: ---[ end trace 79aec5e8bd378abc ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/qY8BlqMTX6c/H7nQBK7oqHE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT/ovZDnsnt1WYoG5AQK+Wg/9GMxtGj6URhNsOQzTjM+JEt+ELbWSB5Zf
MaMhy2LNoijHOqU3Ayg0QLqhLkamTSFX6Fib7svp5CoFbiXcleLsbvW58/D2W0FV
rJilBA9dvCIiT3frZx1IqAQ56p8al04q8TLEilWuMCexIinyriPJdFfIOFh30FBI
5I6QbjT22Y29D44yc1wZoP7h+rjgeTG6w861YrRtxnqKt1rkEVquu5e59BAYpFpa
P0ShZDZHAYCOpSiFNHOyP3vKWtRN7h6ViK6bvMbJP750knZ6/XNompkYtQ1P4WJM
rqOgJpEUOiatrF6+43TWJCgle9HyW8fvrkYRzmbGfg3S57fFilcUJrErev9SEDnM
4yxjDvraTKM39hW9kAM1yxBkIfUvLatZwyQv/Ij73f1aESMmFIVURet1phKXc5QZ
JKL+8lMF+Ne2A5xjB2lGbbmgmu7kxeAZ5fQBzru4TnlLebQhTj9RxXCZoWrytgX6
DU1wpMvD9Pbk9ZbYY1q5Tlzevps4Krf2BqJYiCxSXPIXzguXIa9+TD5FHLKuehaX
AcBA2dMxyrEY+ya8h7vaGsWquSUednMIf1qcMQq/8SOhTwJpmq1RJaJRsM47CQOO
JKh8kDpNVVG/A1RtthAHAobEDLZwbUw0LPdIIpkd1eJlMREyeUokkZpeeiSBZYcN
w9Gq9+HiFRA=
=loXA
-----END PGP SIGNATURE-----

--Sig_/qY8BlqMTX6c/H7nQBK7oqHE--

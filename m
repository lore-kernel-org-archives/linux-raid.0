From: djani22@dynamicweb.hu
Subject: Oops in raid1?
Date: Sat, 20 Aug 2005 11:55:59 +0200
Message-ID: <017a01c5a56d$63127720$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene><E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au><009001c58ac8$9ab25d40$0400a8c0@LocalHost><17114.55335.687696.686786@cse.unsw.edu.au><03e501c5a120$f3a79a00$0400a8c0@LocalHost><17151.60931.26972.713074@cse.unsw.edu.au><011101c5a187$3bc8cf00$0400a8c0@LocalHost> <17156.4079.67097.825741@cse.unsw.edu.au> <007001c5a40b$03f7e3a0$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0175_01C5A57E.2134D4E0"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

------=_NextPart_000_0175_01C5A57E.2134D4E0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

Hello list, Neil!

I found this, bud don't know what is this exactly...
It is not look like the *NBD's deadlock. :-/

Neil!
It is the "original" 2.6.13-rc6, not with your patch!
Only with two mods, what I get from netdev list, and attached to this
letter....


Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] Unable to handle
kernel paging request at virtual address a014d7a5
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000]  printing eip:
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] c0118cee
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] *pde = f7bedd02
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] Oops: 0000 [#1]
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] SMP
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] Modules linked in:
netconsole gnbd
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] CPU:    0
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] EIP:
0060:[<c0118cee>]    Not tainted VLI
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] EFLAGS: 00010296
(2.6.13-rc6)
Aug 20 01:07:23 192.168.2.50 kernel: [42992885.040000] EIP is at
kmap+0x1e/0x54
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] eax: 00000246   ebx:
a014d7a5   ecx: c11ef260   edx: cabbc400
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] esi: 00008000   edi:
00000001   ebp: f6c7fe00   esp: f6c7fdf4
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] ds: 007b   es: 007b
ss: 0068
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Process md3_raid1
(pid: 2769, threadinfo=f6c7e000 task=f7eef020)
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Stack: c0577800
00000006 f5f93cfc f6c7fe54 f895a9cc a014d7a5 00000001 c
f793000
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]        00001000
00004000 d3fc3180 f73e9bf0 f895e718 cabbc400 007ea037 0
1000000
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]        d4175a4c
f895e6f0 65000000 00f03d8d 00100000 d4175a4c f895e6f0 f
895e700
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Call Trace:
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0103ca2>]
show_stack+0x9a/0xd0
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0103e6d>]
show_registers+0x175/0x209
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c010408c>]
die+0xfa/0x17c
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0117b68>]
do_page_fault+0x269/0x7bd
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01038d7>]
error_code+0x4f/0x54
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895a9cc>]
__gnbd_send_req+0x196/0x28d [gnbd]
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895af12>]
do_gnbd_request+0xe5/0x198 [gnbd]
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0383a0d>]
__generic_unplug_device+0x28/0x2e
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c038150f>]
__elv_add_request+0xaa/0xac
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0384e5b>]
__make_request+0x20d/0x512
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0385490>]
generic_make_request+0xb2/0x27a
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04748a2>]
raid1d+0xbf/0x2cb
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04825c9>]
md_thread+0x134/0x16f
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01010d5>]
kernel_thread_helper+0x5/0xb
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Code: 89 c1 81 e1 ff
ff 0f 00 eb b0 90 90 90 55 89 e5 53 83 ec 08 8b 5d
 08 c7 44 24 04 06 00 00 00 c7 04 24 00 78 57 c0 e8 72 47 00 00 <8b> 03 c1
e8 1e 8b 14 85 14 db 73 c0 8b 82 0c 04 00 00 05 00
09
Aug 20 01:07:24 192.168.2.50 Fatal exception: panic in 5 seconds
Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  <0>Fatal exception:
panic in 5 seconds
Aug 20 01:07:27 192.168.2.50 [42992890.060000] Kernel panic - not syncing:
Fatal exception


Janos

------=_NextPart_000_0175_01C5A57E.2134D4E0
Content-Type: text/plain;
	name="p.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="p.txt"

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1474,6 +1474,10 @@ static void tcp_mark_head_lost(struct so
 	int cnt =3D packets;
=20
 	BUG_TRAP(cnt <=3D tp->packets_out);
+	if (unlikely(cnt > tp->packets_out)) {
+		printk("packets_out =3D %d, fackets_out =3D %d, reordering =3D %d, =
sack_ok =3D 0x%x, mss_cache=3D%d\n", tp->packets_out, tp->fackets_out, =
tp->reordering, tp->rx_opt.sack_ok, tp->mss_cache);
+		dump_stack();
+	}
=20
 	sk_stream_for_retrans_queue(skb, sk) {
 		cnt -=3D tcp_skb_pcount(skb);

------=_NextPart_000_0175_01C5A57E.2134D4E0
Content-Type: text/plain;
	name="fix.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="fix.txt"

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1370,15 +1370,21 @@ int tcp_retransmit_skb(struct sock *sk, 
 
 	if (skb->len > cur_mss) {
 		int old_factor = tcp_skb_pcount(skb);
-		int new_factor;
+		int diff;
 
 		if (tcp_fragment(sk, skb, cur_mss, cur_mss))
 			return -ENOMEM; /* We'll try again later. */
 
 		/* New SKB created, account for it. */
-		new_factor = tcp_skb_pcount(skb);
-		tp->packets_out -= old_factor - new_factor;
-		tp->packets_out += tcp_skb_pcount(skb->next);
+		diff = old_factor - tcp_skb_pcount(skb) -
+		       tcp_skb_pcount(skb->next);
+		tp->packets_out -= diff;
+
+		if (diff > 0) {
+			tp->fackets_out -= diff;
+			if ((int)tp->fackets_out < 0)
+				tp->fackets_out = 0;
+		}
 	}
 
 	/* Collapse two adjacent packets if worthwhile and we can. */

------=_NextPart_000_0175_01C5A57E.2134D4E0--


From: djani22@dynamicweb.hu
Subject: Re: Oops in raid1?
Date: Sat, 20 Aug 2005 18:26:23 +0200
Message-ID: <025a01c5a5a3$ee160540$0400a8c0@LocalHost>
References: <20050717182650.24540.patches@notabene> <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au> <009001c58ac8$9ab25d40$0400a8c0@LocalHost> <17114.55335.687696.686786@cse.unsw.edu.au> <03e501c5a120$f3a79a00$0400a8c0@LocalHost> <17151.60931.26972.713074@cse.unsw.edu.au> <011101c5a187$3bc8cf00$0400a8c0@LocalHost> <17156.4079.67097.825741@cse.unsw.edu.au> <007001c5a40b$03f7e3a0$0400a8c0@LocalHost> <017a01c5a56d$63127720$0400a8c0@LocalHost> <1124553238.3810.133.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Pallai Roland <dap@mail.index.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


----- Original Message -----
From: "Pallai Roland" <dap@mail.index.hu>
To: <djani22@dynamicweb.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, August 20, 2005 5:53 PM
Subject: Re: Oops in raid1?


>
> Hi,
>
> On Sat, 2005-08-20 at 11:55 +0200, djani22@dynamicweb.hu wrote:
> > I found this, bud don't know what is this exactly...
> > It is not look like the *NBD's deadlock. :-/
>  it's exactly a GNBD bug, imho

Hmmm.
Possibly...
I get this message, when high upload. (disk write)
But the GNBD generates this, in that situation, and thats why I think, this
is something else...

Jul 17 23:05:10 dy-base kernel: ------------[ cut here ]------------
Jul 17 23:05:10 dy-base kernel: kernel BUG at mm/highmem.c:183!
Jul 17 23:05:10 dy-base kernel: invalid operand: 0000 [#1]
Jul 17 23:05:10 dy-base kernel: PREEMPT SMP
Jul 17 23:05:10 dy-base kernel: Modules linked in: gnbd
Jul 17 23:05:10 dy-base kernel: CPU:    0
Jul 17 23:05:10 dy-base kernel: EIP:    0060:[<c0155aff>]    Tainted: G    B
VLI
Jul 17 23:05:10 dy-base kernel: EFLAGS: 00010246   (2.6.13-rc3-plus-NFS)
Jul 17 23:05:10 dy-base kernel: EIP is at kunmap_high+0x1f/0xa0
Jul 17 23:05:10 dy-base kernel: eax: 00000000   ebx: c1a98cc0   ecx:
c1a98cc0   edx: 00000202
Jul 17 23:05:10 dy-base kernel: esi: dc9f0900   edi: 00000000   ebp:
d5a1e600   esp: ee6c3e74
Jul 17 23:05:10 dy-base kernel: ds: 007b   es: 007b   ss: 0068
Jul 17 23:05:10 dy-base kernel: Process md4_raid1 (pid: 15185,
threadinfo=ee6c2000 task=d224e020)
Jul 17 23:05:10 dy-base kernel: Stack: c1a98cc0 00001000 f883fa7e c1a98cc0
00000001 c009c000 00001000 00000000
Jul 17 23:05:10 dy-base kernel:        40e38500 003d2431 007ea037 01000000
e593104c ee6c2000 5d000000 0000faff
Jul 17 23:05:10 dy-base kernel:        00200000 c055b2c6 e593104c f8842d08
f8842d18 f6e7abf0 f884001b f8842d08
Jul 17 23:05:10 dy-base kernel: Call Trace:
---> Jul 17 23:05:10 dy-base kernel:  [<f883fa7e>]
__gnbd_send_req+0x15e/0x280 [gnbd]
Jul 17 23:05:10 dy-base kernel:  [<c055b2c6>] preempt_schedule+0x56/0x80
Jul 17 23:05:10 dy-base kernel:  [<f884001b>] do_gnbd_request+0xeb/0x1a0
[gnbd]
Jul 17 23:05:10 dy-base kernel:  [<c03788f6>]
__generic_unplug_device+0x36/0x40
Jul 17 23:05:10 dy-base kernel:  [<c037891e>]
generic_unplug_device+0x1e/0x30
Jul 17 23:05:10 dy-base kernel:  [<c0461018>] unplug_slaves+0xe8/0x100
Jul 17 23:05:10 dy-base kernel:  [<c0462405>] raid1d+0x205/0x2a0
Jul 17 23:05:10 dy-base kernel:  [<c0470919>] md_thread+0x159/0x1a0
Jul 17 23:05:10 dy-base kernel:  [<c0137370>]
autoremove_wake_function+0x0/0x60
Jul 17 23:05:10 dy-base kernel:  [<c01030d2>] ret_from_fork+0x6/0x14
Jul 17 23:05:10 dy-base kernel:  [<c0137370>]
autoremove_wake_function+0x0/0x60
Jul 17 23:05:10 dy-base kernel:  [<c04707c0>] md_thread+0x0/0x1a0
Jul 17 23:05:10 dy-base kernel:  [<c0101205>] kernel_thread_helper+0x5/0x10
Jul 17 23:05:10 dy-base kernel: Code: ff 8d 74 26 00 8d bc 27 00 00 00 00 83
ec 08 89 5c 24 04 89 c3 b8 80 10 6d c0 e8 0d 68 4
Jul 17 23:05:10 dy-base kernel:  <6>note: md4_raid1[15185] exited with
preempt_count 1


Thanks

Janos

>
> > [...]
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Process md3_raid1
> > (pid: 2769, threadinfo=f6c7e000 task=f7eef020)
> > [...]
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0117b68>]
> > do_page_fault+0x269/0x7bd
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01038d7>]
> > error_code+0x4f/0x54
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895a9cc>]
> > __gnbd_send_req+0x196/0x28d [gnbd]
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895af12>]
> > do_gnbd_request+0xe5/0x198 [gnbd]
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0383a0d>]
> > __generic_unplug_device+0x28/0x2e
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c038150f>]
> > __elv_add_request+0xaa/0xac
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0384e5b>]
> > __make_request+0x20d/0x512
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0385490>]
> > generic_make_request+0xb2/0x27a
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04748a2>]
> > raid1d+0xbf/0x2cb
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04825c9>]
> > md_thread+0x134/0x16f
> > Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01010d5>]
> > kernel_thread_helper+0x5/0xb
>
>
> --
>  dap
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


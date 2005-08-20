From: Pallai Roland <dap@mail.index.hu>
Subject: Re: Oops in raid1?
Date: Sat, 20 Aug 2005 17:53:58 +0200
Message-ID: <1124553238.3810.133.camel@localhost.localdomain>
References: <20050717182650.24540.patches@notabene>
	 <E1Du4Uu-0006O7-84@notabene.cse.unsw.edu.au>
	 <009001c58ac8$9ab25d40$0400a8c0@LocalHost>
	 <17114.55335.687696.686786@cse.unsw.edu.au>
	 <03e501c5a120$f3a79a00$0400a8c0@LocalHost>
	 <17151.60931.26972.713074@cse.unsw.edu.au>
	 <011101c5a187$3bc8cf00$0400a8c0@LocalHost>
	 <17156.4079.67097.825741@cse.unsw.edu.au>
	 <007001c5a40b$03f7e3a0$0400a8c0@LocalHost>
	 <017a01c5a56d$63127720$0400a8c0@LocalHost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <017a01c5a56d$63127720$0400a8c0@LocalHost>
Sender: linux-raid-owner@vger.kernel.org
To: djani22@dynamicweb.hu
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi,

On Sat, 2005-08-20 at 11:55 +0200, djani22@dynamicweb.hu wrote:
> I found this, bud don't know what is this exactly...
> It is not look like the *NBD's deadlock. :-/
 it's exactly a GNBD bug, imho

> [...]
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000] Process md3_raid1
> (pid: 2769, threadinfo=f6c7e000 task=f7eef020)
> [...]
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0117b68>]
> do_page_fault+0x269/0x7bd
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01038d7>]
> error_code+0x4f/0x54
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895a9cc>]
> __gnbd_send_req+0x196/0x28d [gnbd]
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<f895af12>]
> do_gnbd_request+0xe5/0x198 [gnbd]
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0383a0d>]
> __generic_unplug_device+0x28/0x2e
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c038150f>]
> __elv_add_request+0xaa/0xac
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0384e5b>]
> __make_request+0x20d/0x512
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c0385490>]
> generic_make_request+0xb2/0x27a
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04748a2>]
> raid1d+0xbf/0x2cb
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c04825c9>]
> md_thread+0x134/0x16f
> Aug 20 01:07:24 192.168.2.50 kernel: [42992885.040000]  [<c01010d5>]
> kernel_thread_helper+0x5/0xb


--
 dap


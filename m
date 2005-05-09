From: Tyler <pml@dtbb.net>
Subject: Re: Failed assertion in the MegaRAID driver
Date: Mon, 09 May 2005 16:07:03 -0700
Message-ID: <427FED17.9010906@dtbb.net>
References: <OMEKLMBKKEOEENCKLEIDEEACCKAA.ryan@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OMEKLMBKKEOEENCKLEIDEEACCKAA.ryan@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.com
List-Id: linux-raid.ids

I would suggest checking/swapping your RAM out for some known good RAM, 
we were having RAID oopses that cleared up after replacing a bad stick 
of memory (or, possibly the fact that when we took it out, it was no 
longer trying to do dual-channel memory timing).

Regards,
Tyler.

J. Ryan Earl wrote:

>I'm having a problem on an Java application server under load.  It's kernel
>panicing, which prevents me from creating new sessions but I can check dmesg
>with a sessions opened before the panic.  It's happened a few times,
>typically with over 1000 clients connected--ie some level of concurrency.
>The last time I got an additional error after the megaraid problem, could
>just be further failout from the first failure.  Output follows:
>
>Assertion failure in journal_commit_transaction() at fs/jbd/commit.c:138:
>"journal->j_running_transaction != NULL"
>------------[ cut here ]------------
>kernel BUG at fs/jbd/commit.c:138!
>invalid operand: 0000 [#1]
>SMP
>Modules linked in: nls_utf8 cifs nfs lockd md5 ipv6 autofs4 sunrpc button
>battery ac ohci_hcd tg3 floppy sg dm_snapshot dm_zero dm_mirror ext3 jbd
>dm_mod megaraid_mbox megaraid_mm sd_mod scsi_mod
>CPU:    2
>EIP:    0060:[<f885f268>]    Not tainted VLI
>EFLAGS: 00010212   (2.6.9-5.0.5.ELsmp)
>EIP is at journal_commit_transaction+0x5d/0xfb1 [jbd]
>eax: 00000076   ebx: f7ec4e14   ecx: f74c5de0   edx: f88647de
>esi: f7ec4e00   edi: 00000001   ebp: 00000000   esp: f74c5ddc
>ds: 007b   es: 007b   ss: 0068
>Process kjournald (pid: 235, threadinfo=f74c5000 task=c2248330)
>Stack: f88647de f8863e9c f88647ce 0000008a f88647a7 f61970b0 00000000
>00000000
>       00000000 00000000 00000000 c0771c8c f7ec4e00 f6a3c71c 0000100b
>00000000
>       c2248330 c011e8a2 f74c5e44 f74c5e44 f754a054 f8836f26 f74c5e44
>00000000
>Call Trace:
> [<c011e8a2>] autoremove_wake_function+0x0/0x2d
> [<f8836f26>] megaraid_isr+0x1ad/0x1bf [megaraid_mbox]
> [<c011e8a2>] autoremove_wake_function+0x0/0x2d
> [<c0127dda>] del_timer_sync+0x7a/0x9c
> [<f8861e6d>] kjournald+0xc7/0x213 [jbd]
> [<c011e8a2>] autoremove_wake_function+0x0/0x2d
> [<c011e8a2>] autoremove_wake_function+0x0/0x2d
> [<c011bcf0>] schedule_tail+0x12/0x55
> [<f8861da0>] commit_timeout+0x0/0x5 [jbd]
> [<f8861da6>] kjournald+0x0/0x213 [jbd]
> [<c01041f1>] kernel_thread_helper+0x5/0xb
>Code: 3b 00 00 8b 44 24 1c 83 78 38 00 75 29 68 a7 47 86 f8 68 8a 00 00 00
>68 ce 47 86 f8 68 9c 3e 86 f8 68 de 47 86 f8 e8 a2 18 8c c7 <0f> 0b 8a 00 ce
>47 86 f8 83 c4 14 8b 54 24 1c 83 7a 3c 00 74 29
> <1>Unable to handle kernel NULL pointer dereference at virtual address
>00000010
> printing eip:
>f8b7aada
>*pde = 35d53001
>Oops: 0000 [#2]
>SMP
>Modules linked in: nls_utf8 cifs nfs lockd md5 ipv6 autofs4 sunrpc button
>battery ac ohci_hcd tg3 floppy sg dm_snapshot dm_zero dm_mirror ext3 jbd
>dm_mod megaraid_mbox megaraid_mm sd_mod scsi_mod
>CPU:    0
>EIP:    0060:[<f8b7aada>]    Not tainted VLI
>EFLAGS: 00010a02   (2.6.9-5.0.5.ELsmp)
>EIP is at is_valid_oplock_break+0xc8/0x19b [cifs]
>eax: 00004ead   ebx: 00000010   ecx: 0000ff00   edx: f8b91d14
>esi: c220d480   edi: d1299580   ebp: 00000037   esp: f7417f9c
>ds: 007b   es: 007b   ss: 0068
>Process cifsd (pid: 2956, threadinfo=f7417000 task=f5c34d30)
>Stack: c220c280 00000000 c220c2f0 f8b6fcbe f649ad00 d1299580 00000037
>d12995b7
>       00000000 f621c130 00000000 f7417fb8 00000001 00000000 00000000
>00000000
>       00000000 f8b6f79c 00000000 00000000 00000000 c01041f1 c220c280
>00000000
>Call Trace:
> [<f8b6fcbe>] cifs_demultiplex_thread+0x522/0x782 [cifs]
> [<f8b6f79c>] cifs_demultiplex_thread+0x0/0x782 [cifs]
> [<c01041f1>] kernel_thread_helper+0x5/0xb
>Code: 35 f0 1c b9 f8 8b 06 0f 18 00 90 81 fe f0 1c b9 f8 0f 84 c0 00 00 00
>0f b7 47 1c 66 39 86 84 00 00 00 0f 85 a8 00 00 00 8b 5e 08 <8b> 03 0f 18 00
>90 8d 46 08 39 c3 74 7e 0f b7 43 18 66 39 47 29
>
>
>/snip
>
>Now I'm wondering if this is more of a hardware problem, or a software
>problem.  I was running Gentoo with a 2.6.11.4 derived kernel on the same
>box before switching to RHEL4, and was getting panics inside of ReiserFS,
>which prompted the switch to RHEL4.  My hardware vendor is trying to
>replicate the problem now.  I'm going to try replacing the RAID card, but
>what else should I check?  Anyone seen this problem before?
>
>Thanks in advance for any help, please respond directly to me as well as the
>lists,
>
>J. Ryan Earl
>Systems/Network Engineer
>dynaConnections Corporation
>512.306.9898
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>  
>


From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: libata badness
Date: Tue, 5 Oct 2004 08:47:15 +1000
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <16737.54003.419130.575839@cse.unsw.edu.au>
References: <Pine.LNX.4.60-041.0410040656001.2350@unix48.andrew.cmu.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: message from William Knop on Monday October 4
To: William Knop <wknop@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Monday October 4, wknop@andrew.cmu.edu wrote:
> CPU:    0
> EIP:    0060:[<229e4d8c>]    Not tainted
> EFLAGS: 00010206   (2.6.8-1.521)
> EIP is at handle_stripe+0x29a/0x1407 [raid5]
> eax: 00000001   ebx: 00000000   ecx: 00915cb8   edx: 21f7e1c0
> esi: 1ccbd118   edi: 21f7e1c0   ebp: 01000000   esp: 1d300f28
> ds: 007b   es: 007b   ss: 0068
> Process md0_raid5 (pid: 2626, threadinfo=1d300000 task=1d317970)
> Stack: 2283eb57 20db8000 21f7e1c0 21c30288 1ccbd204 20db8000 00000001 
> 1ccbd158
>         00000002 00000000 00000000 00000001 00000000 00000000 00000001 
> 00000000
>         00000001 00000001 00000000 00000003 1ccbd0ac 21f7e1c0 1ccbd0ac 
> 21f76c00
> Call Trace:
>   [<2283eb57>] ata_scsi_queuecmd+0xbe/0xc7 [libata]
>   [<229e6b1c>] raid5d+0x1ce/0x2f8 [raid5]
>   [<0228f5d2>] md_thread+0x227/0x256
>   [<0211be05>] autoremove_wake_function+0x0/0x2d
>   [<0211be05>] autoremove_wake_function+0x0/0x2d
>   [<0228f3ab>] md_thread+0x0/0x256
>   [<021041d9>] kernel_thread_helper+0x5/0xb
> Code: 8b 55 04 83 c1 08 8b 45 00 83 d3 00 39 da 72 0e 0f 87 e0 01

This code starts:

   0:   8b 55 04                  mov    0x4(%ebp),%edx
   3:   83 c1 08                  add    $0x8,%ecx

and as %ebp is 01000000, this oopses.  
It looks very much like a single-bit memory error (as has already been
suggested as a possibility).

NeilBrown

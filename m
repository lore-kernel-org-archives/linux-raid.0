From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: SW RAID5 + high memory support freezes 2.6.3 kernel
Date: Mon, 23 Feb 2004 15:27:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16441.33071.218049.163976@notabene.cse.unsw.edu.au>
References: <20040223024124.GA1590@psilocybus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Pavol Luptak on Monday February 23
To: Pavol Luptak <P.Luptak@sh.cvut.cz>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 23, P.Luptak@sh.cvut.cz wrote:
> Hello,
> issue http://www.spinics.net/lists/lvm/msg10322.html could be still present
> in the current 2.6.3 kernel. I am able to repeat the conditions to halt the 
> 2.6.3 kernel (using mkfs.ext3 on RAID device):

To be fair, your subject should say that 
   SW RAID5 + high memory + loop device freezes 2.6.3 kernel
                          ^^^^^^^^^^^^^^

Would you be able to try the same tes without using "loop" in the
middle and see what happens?

The trace you sent:

> Feb 23 02:52:12 psilocybus kernel: Unable to handle kernel NULL pointer dereference at virtual address 00000008
> Feb 23 02:52:12 psilocybus kernel: printing eip:
> Feb 23 02:52:12 psilocybus kernel: f9885205
> Feb 23 02:52:12 psilocybus kernel: *pde = 00000000
> Feb 23 02:52:12 psilocybus kernel: Oops: 0000 [#1]
> Feb 23 02:52:12 psilocybus kernel: CPU:    0
> Feb 23 02:52:12 psilocybus kernel: EIP:    0060:[<f9885205>]    Tainted: PF 
> Feb 23 02:52:12 psilocybus kernel: EFLAGS: 00010246
> Feb 23 02:52:12 psilocybus kernel: EIP is at make_request+0x5/0x210 [raid5]
> Feb 23 02:52:12 psilocybus kernel: eax: f10e2f2b   ebx: f6631800   ecx: f7fe9040   edx: 00001000
> Feb 23 02:52:12 psilocybus kernel: esi: 00000008   edi: c644dbc0   ebp: 025c0e08   esp: c1b8bcd0

seems to suggest that %esi is being dereferenced at make_request+0x5,
but when I disassemble my raid5.o, it doesn't.

I tried disassembling the code:

> Feb 23 02:52:12 psilocybus kernel: 
> Feb 23 02:52:12 psilocybus kernel: Code: a7 c0 09 b6 d3 db 66 06 71 67 67 d7 32 47 2a 92 23 22 ee b1 

but that just produced nonsense.

Could you 
   gdb raid5.o
   disassemble make_request

and send me the output please.

NeilBrown

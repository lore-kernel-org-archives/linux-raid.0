From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: sofware raid5 oops
Date: Mon, 11 Jul 2005 15:39:31 -0400
Message-ID: <42D2CAF3.40706@steeleye.com>
References: <42D22A3B.1000608@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42D22A3B.1000608@bppiac.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Farkas Levente <lfarkas@bppiac.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
> anybody has any useful tip about it?

> Unable to handle kernel NULL pointer dereference at virtual address 00000000
>  printing eip:
> 00000000
> *pde = 0f94a067
> Oops: 0000 [#1]
> Modules linked in: cifs nls_utf8 ncpfs nfsd exportfs lockd sunrpc parport_pc lp parport netconsole netdump i2c_dev i2c_core ipx dm_mod e1000 tg3 floppy ext3 jbd raid5 xor raid1 3w_xxxx sd_mod scsi_mod
> CPU:    0
> EIP:    0060:[<00000000>]    Not tainted VLI
> EFLAGS: 00010246   (2.6.9-11.106.unsupported) 
> EIP is at 0x0
> eax: c1806138   ebx: c018961c   ecx: 00000016   edx: c035c7f4
> esi: e7182200   edi: 00000001   ebp: c18fb380   esp: f7878f34
> ds: 007b   es: 007b   ss: 0068
> Process md2_raid5 (pid: 224, threadinfo=f7878000 task=f7872600)
> Stack: f7b973c0 f8879a26  md_thread+0x20d/0x23a
>  [<c011ceaf>] autoremove_wake_function+0x0/0x2d
>  [<c030ce1a>] ret_from_fork+0x6/0x14
>  [<c011ceaf>] autoremove_wake_function+0x0/0x2d
>  [<c02a183f>] md_thread+0x0/0x23a
>  [<c01041d9>] kernel_thread_helper+0x5/0xb
> Code:  Bad EIP value.
> 
> Pid: 224, comm:            md2_raid5
> EIP: 0060:[<00000000>] CPU: 0
> EIP is at 0x0
>  EFLAGS: 00010246    Not tainted  (2.6.9-11.106.unsupported)
> EAX: c1806138 EBX: c018961c ECX: 00000016 EDX: c035c7f4
> ESI: e7182200 EDI: 00000001 EBP: c18fb380 DS: 007b ES: 007b
> CR0: 8005003b CR2: ffffffd5 CR3: 0fd6b000 CR4: 000006d0
>  [<f8879a26>] handle_stripe+0xfca/0x1207 [raid5]
>  [<f887a7d5>] raid5d+0x197/0x2ab [raid5]
>  [<c02a1a4c>] md_thread+0x20d/0x23a
>  [<c011ceaf>] autoremove_wake_function+0x0/0x2d
>  [<c030ce1a>] ret_from_fork+0x6/0x14
>  [<c011ceaf>] autoremove_wake_function+0x0/0x2d
>  [<c02a183f>] md_thread+0x0/0x23a
>  [<c01041d9>] kernel_thread_helper+0x5/0xb

We're in handle_stripe with an EIP of 0. Perhaps a NULL end io function 
in the following:

(raid5.c, line ~1252):

         while ((bi=return_bi)) {
                 int bytes = bi->bi_size;

                 return_bi = bi->bi_next;
                 bi->bi_next = NULL;
                 bi->bi_size = 0;
                 bi->bi_end_io(bi, bytes, 0);
         }


Is it valid to assume that bi_end_io is non-NULL in this context?

--
Paul

From: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Subject: Re: Question about recovery via mdadm
Date: Sun, 16 Feb 2003 20:05:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <42790000.1045443956@pcmy.sei.cmu.edu>
References: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com>	<15948.9979.534439.238616@notabene.cse.unsw.edu.au>	<28330000.1045391539@shieldbreaker.l33tskillz.org> <15952.3121.511942.788471@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15952.3121.511942.788471@notabene.cse.unsw.edu.au>
Content-Disposition: inline
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-02-17 at 09:09:53+1100 Neil Brown <neilb@cse.unsw.edu.au> wrote:

> > https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=82815
> 
> I think that bug should be fixed by the follow patch which has been
> submitted and accepted and should be in 2.4.21.

I already tried backporting the md driver from 2.4.21-pre3 (which
contains the patch you included).  Unfortunately, not only does it not
fix the problem, but it makes it worse: with the patch applied, after
the Oops occurs, touching the md device in any way hangs.  This
includes the "md: stopping all md devices" which occurs at shutdown,
so as a result, at shutdown, the entire machine hangs, and you have to
go physically reset or power cycle the machine.

I've appended the Oops I generated using the md driver from
2.4.21-pre3 in Red Hat's kernel-2.4.18-19.8.0.  This is how I produced
it:

    $ mdadm --create /dev/md0 --verbose --level=mirror --raid-devices=2 /dev/sdb1 /dev/sdc1
    <wait for sync>
    $ mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1 -a /dev/sdc1
    <wait for sync>
    $ mdadm /dev/md0 -f /dev/sdb1 -r /dev/sdb1 -a /dev/sdb1
    <mdrecovery generates Oops>

As I said before, I'm at a loss to figure out where the bug is, but if
you have any further things to try, I'd be happy to give them a
whirl...

Regards,
James

Feb 16 19:40:55 kernel: md: sdc1 [events: 0000000b]<6>(write) sdc1's sb offset: 72192
Feb 16 19:40:55 kernel: md: <1>Unable to handle kernel NULL pointer dereference at virtual address 00000f90
Feb 16 19:40:55 kernel:  printing eip:
Feb 16 19:40:55 kernel: c01e0f3a
Feb 16 19:40:55 kernel: *pde = 00000000
Feb 16 19:40:55 kernel: Oops: 0000
Feb 16 19:40:55 kernel: tg3 iptable_filter ip_tables ide-cd cdrom raid1 mousedev keybdev hid input usb-ohci usbcore ext3 jbd aic7xxx sd_mod scsi_mod  
Feb 16 19:40:55 kernel: CPU:    0
Feb 16 19:40:55 kernel: EIP:    0010:[<c01e0f3a>]    Not tainted
Feb 16 19:40:55 kernel: EFLAGS: 00010202
Feb 16 19:40:55 kernel: 
Feb 16 19:40:55 kernel: EIP is at md_update_sb [kernel] 0xda (2.4.18-19.8.0.ralston.0)
Feb 16 19:40:55 kernel: eax: 00000f80   ebx: dd31ace0   ecx: 00000001   edx: 00000001
Feb 16 19:40:55 kernel: esi: dd31ace0   edi: c257bb74   ebp: c257bb60   esp: daf8df58
Feb 16 19:40:55 kernel: ds: 0018   es: 0018   ss: 0018
Feb 16 19:40:55 kernel: Process raid1d (pid: 755, stackpage=daf8d000)
Feb 16 19:40:55 kernel: Stack: c026ab7e 0000000a dfd74f80 00000064 00000000 daf8c000 00000001 db63a7a8 
Feb 16 19:40:55 kernel:        c257bb60 e089ebe2 c257bb60 daf8dfac dffd55a0 00000000 dfd8c014 daf8dfa0 
Feb 16 19:40:55 kernel:        c011fd0a daf8c000 daf8c000 db63a7a0 db63a7a8 daf8dfd0 c01e4201 dd26a000 
Feb 16 19:40:55 kernel: Call Trace: [<e089ebe2>] raid1d [raid1] 0x332 (0xdaf8df7c))
Feb 16 19:40:55 kernel: [<c011fd0a>] __run_task_queue [kernel] 0x5a (0xdaf8df98))
Feb 16 19:40:55 kernel: [<c01e4201>] md_thread [kernel] 0xf1 (0xdaf8dfb0))
Feb 16 19:40:55 kernel: [<e08a029c>] .rodata.str1.1 [raid1] 0x75 (0xdaf8dfb8))
Feb 16 19:40:55 kernel: [<c010745e>] kernel_thread [kernel] 0x2e (0xdaf8dff0))
Feb 16 19:40:55 kernel: [<c01e4110>] md_thread [kernel] 0x0 (0xdaf8dff8))
Feb 16 19:40:55 kernel: 
Feb 16 19:40:55 kernel: 
Feb 16 19:40:55 kernel: Code: f6 40 10 01 74 60 0f b7 43 18 89 04 24 e8 b4 e8 ff ff 89 44 
Feb 16 19:40:55 kernel:  <6>md: trying to hot-add sdb1 to md0 ... 
Feb 16 19:40:55 kernel: md: bind<sdb1,2>
Feb 16 19:40:55 kernel: RAID1 conf printout:


From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Severe, huge data corruption with softraid
Date: Thu, 03 Mar 2005 02:57:59 +0300
Message-ID: <42265307.5040400@tls.msk.ru>
References: <42264AF4.4000600@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <42264AF4.4000600@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev wrote:
[data corruption.. snip]

And finally I managed to get an OOPs.
Created fresh raid5 array out of 4 partitions,
chunk size = 4kb.
Created ext3fs on it.
Tested write speed (direct-io) - it was terrible,
  about 6MB/sec for 64KB blocks - it's very unusual.
Umounted the fs.
Did a direct-write test agains the md device.
And at the same time, did an `rmmod raid0' -
unused in my config at that time. -- not sure
if it's relevant or not.
And get "sigsegv" in my program, and the
following oops:

md: raid0 personality unregistered
Unable to handle kernel paging request at virtual address f8924690
  printing eip:
f8924690
*pde = 02127067
*pte = 00000000
Oops: 0000 [#1]
SMP
Modules linked in: raid10 nfsd exportfs raid5 xor nfs lockd sunrpc 8250 serial_core w83627hf i2c_sensor
i2c_isa i2c_core e1000 genrtc ext3 jbd mbcache raid1 sd_mod md aic79xx scsi_mod
CPU:    1
EIP:    0060:[<f8924690>]    Not tainted VLI
EFLAGS: 00010286   (2.6.9-i686smp-0)
EIP is at 0xf8924690
eax: ecd04028   ebx: c99ead40   ecx: c21dc380   edx: c99ead40
esi: ecd04028   edi: f8924690   ebp: c21dc380   esp: f1d39cac
ds: 007b   es: 007b   ss: 0068
Process dio (pid: 21941, threadinfo=f1d39000 task=f7d40890)
Stack: c015b5dd c99ead40 c10063a0 00001000 00000000 c015b64c 00001000 00000000
        f7d23800 00000000 c01778f2 00000000 f7d23800 c017798d f7d23800 c10063a0
        c0177a4e 00000000 00000001 00000000 f7d2384c f7d23800 c0177e78 00001000
Call Trace:
  [<c015b5dd>] __bio_add_page+0x13d/0x180
  [<c015b64c>] bio_add_page+0x2c/0x40
  [<c01778f2>] dio_bio_add_page+0x22/0x70
  [<c017798d>] dio_send_cur_page+0x4d/0xa0
  [<c0177a4e>] submit_page_section+0x6e/0x140
  [<c0177e78>] do_direct_IO+0x288/0x380
  [<c0178164>] direct_io_worker+0x1f4/0x520
  [<c017869d>] __blockdev_direct_IO+0x20d/0x308
  [<c015d770>] blkdev_get_blocks+0x0/0x70
  [<c015d83f>] blkdev_direct_IO+0x5f/0x80
  [<c015d770>] blkdev_get_blocks+0x0/0x70
  [<c013c304>] generic_file_direct_IO+0x74/0x90
  [<c013b352>] generic_file_direct_write+0x62/0x170
  [<c016f7cb>] inode_update_time+0xbb/0xc0
  [<c013bcfe>] generic_file_aio_write_nolock+0x2ce/0x490
  [<c013bf51>] generic_file_write_nolock+0x91/0xc0
  [<c011ae9e>] scheduler_tick+0x16e/0x470
  [<c0115135>] smp_apic_timer_interrupt+0x85/0xf0
  [<c011c850>] autoremove_wake_function+0x0/0x50
  [<c015e6c0>] blkdev_file_write+0x0/0x30
  [<c015e6e0>] blkdev_file_write+0x20/0x30
  [<c0156770>] vfs_write+0xb0/0x110
  [<c0156897>] sys_write+0x47/0x80
  [<c010603f>] syscall_call+0x7/0xb
Code:  Bad EIP value.

/mjt

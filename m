From: Mark Rustad <MRustad@aol.com>
Subject: Re: PROBLEM: kernel crashes on RAID1 drive error
Date: Thu, 21 Oct 2004 11:31:21 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A45B093E-237E-11D9-8A48-0003934F6348@aol.com>
References: <8FA83ADB-22E4-11D9-AC9C-0003934F6348@aol.com> <20041021084514.GY10531@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041021084514.GY10531@suse.de>
To: Jens Axboe <axboe@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jens,

On Oct 21, 2004, at 3:45 AM, Jens Axboe wrote:

> On Wed, Oct 20 2004, Mark Rustad wrote:
>> Folks,
>>
>> I have been having trouble with kernel crashes resulting from RAID1
>> component device failures. I have been testing the robustness of an
>> embedded system and have been using a drive that is known to fail 
>> after
>> a time under load. When this device returns a media error, I always
>> wind up with either a kernel hang or reboot. In this environment, each
>> drive has four partitions, each of which is part of a RAID1 with its
>> partner on the other device. Swap is on md2 so even it should be
>> robust.

<snip>

> This should be fixed by this patch, can you test it?
>
> ===== drivers/block/ll_rw_blk.c 1.273 vs edited =====
> --- 1.273/drivers/block/ll_rw_blk.c 2004-10-19 11:40:18 +02:00
> +++ edited/drivers/block/ll_rw_blk.c    2004-10-20 17:06:12 +02:00

<snip>

I applied this patch and the raid1/raid10 patch referenced in another 
message. I had to mess with this patch a bit to get it to apply, but 
because there was such good context, I know that I got the correct end 
result. The raid1/raid10 patch applied cleanly unchanged. Unfortunately 
I still get the oops. As I was looking at this I realized that I am 
running with elevator=cfq simply because that is how SuSE sets things 
up (just in case that has some bearing on things).

Because of the differences in the patch compared to the 2.6.9 base I 
was applying it to, I wonder if there are other changes required. 
Anyway, here is the oops that I now get:

ksymoops 2.4.9 on i686 2.6.5-7.97-bigsmp.  Options used
      -v vmlinux (specified)
      -K (specified)
      -L (specified)
      -O (specified)
      -m System.map (specified)

kernel BUG at /usr/src/linux-2.6.9/fs/buffer.c:614!
invalid operand: 0000 [#1]
CPU:    1
EIP:    0060:[<c014faf9>]    Not tainted VLI
Using defaults from ksymoops -t elf32-i386 -a i386
EFLAGS: 00010246   (2.6.9-3d-1)
eax: 00000019   ebx: c0b24adc   ecx: c0b24adc   edx: 00000001
esi: 00000001   edi: 00000000   ebp: 00000001   esp: df9f7cc8
ds: 007b   es: 007b   ss: 0068
Stack: ded502c0 c0152128 00000000 00000001 c015214b ded502c0 c0153338 
00000000
        00000000 f7cb65b0 df9f7d14 f7cd1240 f7cd1240 df8ada00 c02f2738 
df9b5300
        f7cd1240 00000001 df8ada00 00000001 c02f2815 c1814220 deced450 
df5c7be4
Call Trace:
  [<c0152128>] end_bio_bh_io_sync+0x0/0x3b
  [<c015214b>] end_bio_bh_io_sync+0x23/0x3b
  [<c0153338>] bio_endio+0x3b/0x65
  [<c02f2738>] raid_end_bio_io+0x22/0xb8
  [<c02f2815>] raid1_end_read_request+0x47/0xcb
  [<c011bb08>] try_to_wake_up+0x1f4/0x273
  [<c02f27ce>] raid1_end_read_request+0x0/0xcb
  [<c0153338>] bio_endio+0x3b/0x65
  [<c0279dd4>] __end_that_request_first+0xe3/0x22d
  [<c011d280>] __wake_up_common+0x35/0x58
  [<c02ac212>] scsi_end_request+0x1b/0xa6
  [<c02ac56d>] scsi_io_completion+0x16a/0x4a3
  [<c0136257>] mempool_alloc+0x66/0x121
  [<c02a851e>] scsi_finish_command+0x7d/0xd1
  [<c02a846d>] scsi_softirq+0xbf/0xcd
  [<c0124342>] __do_softirq+0x62/0xcd
  [<c01243da>] do_softirq+0x2d/0x35
  [<c0108b38>] do_IRQ+0x112/0x129
  [<c0106cc0>] common_interrupt+0x18/0x20
  [<c027007b>] uart_block_til_ready+0x18e/0x193
  [<c0279627>] __make_request+0x244/0x4ac
  [<c027994e>] generic_make_request+0xbf/0x16c
  [<c011d2d5>] __wake_up+0x32/0x43
  [<c02f2ab5>] read_balance+0x16b/0x181
  [<c0120c64>] __printk_ratelimit+0x8a/0xa5
  [<c02f3ab6>] raid1d+0x113/0x18e
  [<c02f85ac>] md_thread+0x174/0x19a
  [<c011e5b9>] autoremove_wake_function+0x0/0x37
  [<c011e5b9>] autoremove_wake_function+0x0/0x37
  [<c02f8438>] md_thread+0x0/0x19a
  [<c01047fd>] kernel_thread_helper+0x5/0xb
Code: ff f0 0f ba 2f 01 eb a0 8b 02 a8 04 74 2a 5b 89 ea b8 f4 28 3e c0 
5e 5f 5d


 >>EIP; c014faf9 <__find_get_block_slow+112/128>   <=====

 >>ebx; c0b24adc <pg0+593adc/3fa6d400>
 >>ecx; c0b24adc <pg0+593adc/3fa6d400>
 >>esp; df9f7cc8 <pg0+1f466cc8/3fa6d400>

Trace; c0152128 <block_write_full_page+8/fa>
Trace; c015214b <block_write_full_page+2b/fa>
Trace; c0153338 <bio_dirty_fn+35/4d>
Trace; c02f2738 <r1buf_pool_alloc+6b/11d>
Trace; c02f2815 <r1buf_pool_free+2b/72>
Trace; c011bb08 <try_to_wake_up+a4/273>
Trace; c02f27ce <r1buf_pool_alloc+101/11d>
Trace; c0153338 <bio_dirty_fn+35/4d>
Trace; c0279dd4 <blk_recalc_rq_segments+10b/154>
Trace; c011d280 <scheduler_tick+343/452>
Trace; c02ac212 <scsi_single_lun_run+35/ce>
Trace; c02ac56d <scsi_release_buffers+d/83>
Trace; c0136257 <mempool_resize+b7/158>
Trace; c02a851e <scsi_init_cmd_from_req+159/15e>
Trace; c02a846d <scsi_init_cmd_from_req+a8/15e>
Trace; c0124342 <sys_adjtimex+2/4e>
Trace; c01243da <getnstimeofday+b/22>
Trace; c0108b38 <do_IRQ+112/198>
Trace; c0106cc0 <common_interrupt+18/20>
Trace; c027007b <uart_block_til_ready+6e/193>
Trace; c0279627 <__make_request+124/4ac>
Trace; c027994e <__make_request+44b/4ac>
Trace; c011d2d5 <scheduler_tick+398/452>
Trace; c02f2ab5 <raid1_end_write_request+3c/b1>
Trace; c0120c64 <unregister_console+3/85>
Trace; c02f3ab6 <sync_request_write+17e/24b>
Trace; c02f85ac <md_open+3/5d>
Trace; c011e5b9 <add_wait_queue+27/30>
Trace; c011e5b9 <add_wait_queue+27/30>
Trace; c02f8438 <md_ioctl+558/6c9>
Trace; c01047fd <kernel_thread_helper+5/b>

Code;  c014faf9 <__find_get_block_slow+112/128>
00000000 <_EIP>:
Code;  c014faf9 <__find_get_block_slow+112/128>   <=====
    0:   ff f0                     push   %eax   <=====
Code;  c014fafb <__find_get_block_slow+114/128>
    2:   0f ba 2f 01               btsl   $0x1,(%edi)
Code;  c014faff <__find_get_block_slow+118/128>
    6:   eb a0                     jmp    ffffffa8 <_EIP+0xffffffa8>
Code;  c014fb01 <__find_get_block_slow+11a/128>
    8:   8b 02                     mov    (%edx),%eax
Code;  c014fb03 <__find_get_block_slow+11c/128>
    a:   a8 04                     test   $0x4,%al
Code;  c014fb05 <__find_get_block_slow+11e/128>
    c:   74 2a                     je     38 <_EIP+0x38>
Code;  c014fb07 <__find_get_block_slow+120/128>
    e:   5b                        pop    %ebx
Code;  c014fb08 <__find_get_block_slow+121/128>
    f:   89 ea                     mov    %ebp,%edx
Code;  c014fb0a <__find_get_block_slow+123/128>
   11:   b8 f4 28 3e c0            mov    $0xc03e28f4,%eax
Code;  c014fb0f <invalidate_bdev+0/17>
   16:   5e                        pop    %esi
Code;  c014fb10 <invalidate_bdev+1/17>
   17:   5f                        pop    %edi
Code;  c014fb11 <invalidate_bdev+2/17>
   18:   5d                        pop    %ebp

  <0>Kernel panic - not syncing: Fatal exception in interrupt

-- 
Mark Rustad, MRustad@aol.com


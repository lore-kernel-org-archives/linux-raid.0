From: Anthony Wright <anthony@overnetdata.com>
Subject: Re: Panic doing BLKDISCARD on a raid 5 array on linux 3.17.3
Date: Thu, 18 Dec 2014 10:58:33 +0000
Message-ID: <5492B359.6060804@overnetdata.com>
References: <5491704D.1080709@overnetdata.com> <20141218162858.47310158@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141218162858.47310158@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 18/12/2014 05:28, NeilBrown wrote:
> I suspect md/raid5 is sending down a discard request in some way that the
> scsi/sata layer or driver doesn't like, but without the full oops, I really
> cannot guess what it might be.
We've tried 4 times to reproduce the panic we got originally, but
unforunately with no luck. Below are the outputs from all four crashes
as captured by netconsole, in case they are any help.

Crash #1
[63207.177400] BUG: unable to handle kernel paging request at
0000001e00008000

Crash #2
[  531.210340] BUG: unable to handle kernel paging request at
0000000100000000
[  531.210514] IP:[  531.210340] BUG: unable to handle kernel 
[<ffffffff8128788e>] __blk_segment_map_sg+0x5e/0x1b0
paging request[  531.210632] PGD 20187f067 PUD 0  at 0000000100000000

[  531.210514] IP: [<ffffffff8128788e>] __blk_segment_map_sg+0x5e/0x1b0
[  531.210632] PGD 20187f067 PUD 0
[  531.210783] Oops: 0000 [#1] SMP
[  531.210932] Modules linked in: eql netconsole configfs raid456[ 
531.210783] Oops: 0000 [#1] SMP
[  531.210932] Modules linked in: eql netconsole configfs raid456
async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq
xt_multiport async_raid6_recov async_memcpy async_pq async_xor xor
async_tx raid6_pq xt_multiport xt_tcpudp iptable_filter ip_tables
x_tables aesni_intel aes_x86_64 glue_helper lrw xt_tcpudp iptable_filter
ip_tables x_tables aesni_intel aes_x86_64 glue_helper lrw gf128mul
ablk_helper cryptd ppdev gf128mul ablk_helper cryptd ppdev

Crash #3
[  268.115094] general protection fault: 0000 [#1] SMP
[  268.115263] Modules linked in:[  268.115094] general protection
fault: 0000 [#1] SMP
[  268.115263] Modules linked in:

Crash #4
[  276.325157] general protection fault: 0000 [#1] SMP




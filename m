From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 submirror failure causes reboot?
Date: Fri, 10 Nov 2006 19:41:24 +1100
Message-ID: <17748.15156.405065.904318@cse.unsw.edu.au>
References: <1007879814.20061110111729@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Klimov on Friday November 10
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>, jens.axboe@oracle.com
List-Id: linux-raid.ids

On Friday November 10, klimov@2ka.mipt.ru wrote:
> Hello Linux RAID,
> 
>   One of our servers using per-partition mirroring has a
>   frequently-failing partition, hdc11 below.
> 
>   When it is dubbed failing, the server usually crashes
>   with a stacktrace like below. This seems strange, because
>   the other submirror, hda11 is alive and well, and this
>   should all be transparent thru the RAID layer? This is
>   what it's for?
> 
>   After the reboot I usually succeed in hot-adding hdc11
>   back to the mirror, although several times it was not
>   marked dead at all and rebuilt by itself after reboot.
>   Also seems rather incorrect: if it died, it should be
>   marked so (perhaps in metadata on a live mirror)?
> 
>   Overall, uncool (although mirroring has saved us many
>   times, thanks!)
> 
--snip--
> [87392.564004] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87392.572790] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
> [87392.582454] ide: failed opcode was: unknown
> [87392.635961] ide1: reset: success
> [87397.528687] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87397.537607] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315718
> [87397.547335] ide: failed opcode was: unknown
> [87397.551897] end_request: I/O error, dev hdc, sector 176315718
> [87398.520820] raid1: Disk failure on hdc11, disabling device. 
> [87398.520826]  Operation continuing on 1 devices
> [87398.531579] blk: request botched
                 ^^^^^^^^^^^^^^^^^^^^

That looks bad.  Possible some bug in the IDE controller or elsewhere
in the block layer.  Jens: What might cause that?

--snip--
> [87403.678603] Call Trace:
> [87403.681462]  [<c0103bba>] show_stack_log_lvl+0x8d/0xaa
> [87403.686911]  [<c0103ddc>] show_registers+0x1b0/0x221
> [87403.692306]  [<c0103ffc>] die+0x124/0x1ee
> [87403.696558]  [<c0104165>] do_trap+0x9f/0xa1
> [87403.700988]  [<c0104427>] do_invalid_op+0xa7/0xb1
> [87403.706012]  [<c0103871>] error_code+0x39/0x40
> [87403.710794]  [<c0180e0a>] mpage_end_io_read+0x5e/0x72
> [87403.716154]  [<c0164af9>] bio_endio+0x56/0x7b
> [87403.720798]  [<c0256778>] __end_that_request_first+0x1e0/0x301
> [87403.726985]  [<c02568a4>] end_that_request_first+0xb/0xd
> [87403.732699]  [<c02bd73c>] __ide_end_request+0x54/0xe1
> [87403.738214]  [<c02bd807>] ide_end_request+0x3e/0x5c
> [87403.743382]  [<c02c35df>] task_error+0x5b/0x97
> [87403.748113]  [<c02c36fa>] task_in_intr+0x6e/0xa2
> [87403.753120]  [<c02bf19e>] ide_intr+0xaf/0x12c
> [87403.757815]  [<c013e5a7>] handle_IRQ_event+0x23/0x57
> [87403.763135]  [<c013e66f>] __do_IRQ+0x94/0xfd
> [87403.767802]  [<c0105192>] do_IRQ+0x32/0x68

That doesn't look like raid was involved.  If it was you would expect
to see raid1_end_write_request or raid1_end_read_request in that
trace. 
Do you have any other partitions of hdc in use but not on raid?
Which partition is sector 176315718 in ??

NeilBrown

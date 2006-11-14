From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Re[2]: RAID1 submirror failure causes reboot?
Date: Tue, 14 Nov 2006 08:28:57 +0100
Message-ID: <20061114072857.GI15031@kernel.dk>
References: <1007879814.20061110111729@2ka.mipt.ru> <17748.15156.405065.904318@cse.unsw.edu.au> <208777171.20061110155306@2ka.mipt.ru> <17752.7205.373640.220014@cse.unsw.edu.au> <20061113201105.GD15031@kernel.dk> <17752.60436.276119.191856@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17752.60436.276119.191856@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Jim Klimov <klimov@2ka.mipt.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 14 2006, Neil Brown wrote:
> On Monday November 13, jens.axboe@oracle.com wrote:
> > 
> > It doesn't sound at all unreasonable. It's most likely either a bug in
> > the ide driver, or a "bad" bio being passed to the block layer (and
> > later on to the request and driver). By "bad" I mean one that isn't
> > entirely consistent, which could be a bug in eg md. 
> 
> I just noticed (while tracking raid6 problems...) that bio_clone calls
> bio_phys_segments and bio_hw_segments (why does it do both?).
> This calls blk_recount_segments which does calculations based on
>      ->bi_bdev.
> Only immediately after calling bio_clone, raid1 changes bi_bdev, thus
> creating potential inconsistency in the bio.  Would this sort of
> inconsistency cause this problem?

raid1 should change it first, you are right. But it should not matter,
as the real device should have restrictions that are at least equal to
the md device. So it may be a bit more conservative, but I don't think
there's a problem bug there.

> > Agree, that would be a good plan to enable. Other questions: are you
> > seeing timeouts at any point? The ide timeout code has some request/bio
> > "resetting" code which might be worrisome.
> 
> Jim could probably answer this with more authority, but there aren't
> obvious timeouts from the logs he posted.  A representative sample is:
> [87338.675891] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87338.685143] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
> [87338.694791] ide: failed opcode was: unknown
> [87343.557424] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87343.566388] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
> [87343.576105] ide: failed opcode was: unknown
> [87348.472226] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87348.481170] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
> [87348.490843] ide: failed opcode was: unknown
> [87353.387028] hdc: task_in_intr: status=0x59 { DriveReady SeekComplete DataRequest Error }
> [87353.395735] hdc: task_in_intr: error=0x01 { AddrMarkNotFound }, LBAsect=176315718, sector=176315711
> [87353.405500] ide: failed opcode was: unknown
> [87353.461342] ide1: reset: success

Then lets wait for Jim to repeat his testing with all the debugging
options enabled, that should make us a little wiser.

-- 
Jens Axboe


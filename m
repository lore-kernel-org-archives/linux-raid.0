From: nick black <dank@reflexsecurity.com>
Subject: properly using badblocks with degraded raid5
Date: Fri, 27 Feb 2004 12:47:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040227174758.GA23422@suburbanjihad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
Cc: neilb@cse.unsw.edu.au, tytso@alum.mit.edu
List-Id: linux-raid.ids

Hello.  I initially created a RAID5 in degraded mode and copied my data
over, wanting to play with the RAID a little bit before committing to
it.  After a few weeks, I decided to merge in the third drive
(previously holding another copy of my data).  The kernel used was
2.6.3, and still likely will be.  The resync was going swimmingly, 
until a bunch of errors showed up regarding hdc (drives in question are 
hdc, hde and hdg, hdg is the new one, mdadm --manage /dev/md0 -a /dev/hdg):

hdc: dma_intr: status=0x51 { DriveReady SeekComplete Error }
hdc: dma_intr: error=0x40 { UncorrectableError }, LBAsect=336986835, high=20, low=1442515,
sector=336986687
end_request: I/O error, dev hdc, sector 336986687
.... continue every 8th sector to 336986831

the md0:  sync done message was generated, but hdc then seemed to be killed:
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:1 fd:2
kernel:  disk 0, o:0, dev:hdc1
kernel:  disk 1, o:1, dev:hde1
kernel:  disk 2, o:1, dev:hdg1
kernel: RAID5 conf printout:
kernel:  --- rd:3 wd:1 fd:2
kernel:  disk 1, o:1, dev:hde1
kernel:  disk 2, o:1, dev:hdg1

at this point, the kernel began to tightly spin on resyncing/sync done.
After a reboot and removal of the third drive (leaving it in started
another full resync), my data seems fine on the degraded array.  I'd
like to run badblocks.  I know badblocks can handle a md device just
fine as a whole, but what about degraded ones?  When I add the third
drive, will any bad block list be properly used?  If I kill that drive,
will old bad blocks be removed?

If badblocks cannot/should not be run on a degraded array, I'd like to
copy whatever I can from the dying /dev/hdc to the badblock-tested hdg.
If I simply (without the filesystem being mounted) dd --ifile=/dev/hdc
--ofile=/dev/hdg, will that work (different models of the same Maxtor
disk)?  Then I can swap them, badblock test old hdc independently, and
merge it in.

Thanks a lot for any help!

-- 
nick black <dank@reflexsecurity.com>
"np:  nondeterministic polynomial-time
the class of dashed hopes and idle dreams." - the complexity zoo

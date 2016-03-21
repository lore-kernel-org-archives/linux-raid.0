From: Phil Turmel <philip@turmel.org>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 08:42:16 -0400
Message-ID: <56EFEC28.7020207@turmel.org>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
 <trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
 <20160320223727.GA29895@EIS>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160320223727.GA29895@EIS>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Patrick Tschackert <Killing-Time@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Patrick,

On 03/20/2016 06:37 PM, Andreas Klauer wrote:
> On Sun, Mar 20, 2016 at 10:44:57PM +0100, Patrick Tschackert wrote:
>> After rebooting the system, one of the harddisks was missing from my md raid 6 (the drive was /dev/sdf), so i rebuilt it with a hotspare that was already present in the system.
>> I physically removed the "missing" /dev/sdf drive after the restore and replaced it with a new drive.

Your smartctl output shows pending sector problems with sdf, sdh, and
sdj.  The latter are WD Reds that won't keep those problems through a
scrub, so I guess the smartctl report was from before that?

> Exact commands involved for those steps?
> 
> mdadm --examine output for your disks?

Yes, we want these.

>> $ cat /sys/block/md0/md/mismatch_cnt
>> 311936608
> 
> Basically the whole array out of whack.

Wow.

> This is what you get when you use --create --assume-clean on disks 
> that are not actually clean... or if you somehow convince md to 
> integrate a disk that does not have valid data on, for example 
> because you copied partition table and md metadata - but not  
> everything else - using dd.
> 
> Something really bad happened here and the only person who 
> can explain it, is probably yourself.

This is wrong.  Your mdadm -D output clearly shows a 2014 creation date,
so you definitely hadn't done --create --assume-clean at that point.
(Don't.)

> Your best bet is that the data is valid on n-2 disks.
> 
> Use overlay https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
> 
> Assemble the overlay RAID with any 2 disks missing (try all combinations) and see if you get valid data.

No.  Something else is wrong, quite possibly hardware.  You don't get a
mismatch count like that without it showing up in smartctl too, unless
corrupt data was being written to one or more disks for a long time.

It's unclear from your dmesg what might have happened.  Probably bad
stuff going back years.

If you used ddrescue to replace sdf instead of letting mdadm reconstruct
it, that would have introduced zero sectors that would scramble your
encrypted filesystem.  Please let us know that you didn't use ddrescue.

The encryption inside your array will frustrate any attempt to do
per-member analysis.  I don't think there's anything still wrong with
the array (anything fixable, that is).

If an array error stomped on the key area of your dm-crypt layer, you
are totally destroyed, unless you happen to have a key backup you can
restore.

Otherwise you are at the mercy of fsck to try to fix your volume.  I
would use an overlay for that.

Phil

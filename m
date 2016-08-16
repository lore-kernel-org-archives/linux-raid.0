From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: read errors with md RAID5 array
Date: Tue, 16 Aug 2016 14:27:49 +0200
Message-ID: <20160816122749.konfspsxudorrurk@metamorpher.de>
References: <78aab29c-9b7b-ff8b-f9c7-fab286f16243@buttersideup.com>
 <20160815145937.dsjtzpjdnwfpmxyv@metamorpher.de>
 <d1ccb93d-6856-4b07-04ea-3c4ff9541d60@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d1ccb93d-6856-4b07-04ea-3c4ff9541d60@buttersideup.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Small <tim@buttersideup.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 12:40:45PM +0100, Tim Small wrote:
> I didn't know about the bad block functionality in md.

I don't know how it's supposed to work either. I disable it everywhere.
(the option was --update=no-bbl but if I remember correctly it will 
accept that only if the bbl is empty)

I don't want arrays to have bad blocks. I don't want disks with bad blocks 
to be left in the array. I don't trust disks that develop defects or lose 
data so the only choice for me is to replace it with a new one.

Silently ignoring disk errors, silently fixing errors in the background, 
keeping bad disks around, in my point of view this will only cause much 
more trouble later on.

I want to be notified about any and all problems md encounters so I can 
decide what to do... unfortunately not many people seem to share this 
view and the "read errors are normal" faction seems to be growing...

Identical bad blocks on multiple devices should be the reason why your 
md is reporting I/O layers; those blocks are already marked bad by md, 
it does not even try to read them from the disks.

The last time I encountered these I ended up editing metadata 
or doing a (dangerous) re-create since I found no other way to 
get rid of them.

> In the meantime I'm trying to work out what data (if any) is now
> inaccessible.  This is made slightly more interesting because this array
> has 'bcache' sitting in front of it, so I might have good data in the
> cache on the SSD which is marked bad/inaccessible on the raid5 md device.

md won't be able to use that to repair by itself. Does bcache have some 
recovery mode that makes it dump back everything that is cached to disk? 
This comes with its own dangers, if the cache is wrong or other bugs...

Usually for such dangerous experiments you would use an overlay 
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
but I'm not sure how well that plays together with bcache either.

If you want to go with re-create in your case it would be something like

mdadm --create /dev/md42 --assume-clean \
    --metadata=1.2 --data-offset=128M --level=5 --chunk=512 --layout=ls \
    --raid-devices=3 /dev/overlay/sd{a,c,d}2

You have to specify all varaibles because mdadm defaults change over time.

Then --stop and --assemble with --update=no-bbl before the horrors repeat...

Mount and verify files for correctness (files larger than disks*chunksize).

Then --add a fourth drive and --replace the one you said has bad sectors 
according to SMART. Book a flight to Olympics in Rio and win a gold medal 
in hard disk long-cast throwing.

Once your RAID is running with three drives that are fully operational 
you can do your RAID6 or whatever.

If you don't have a backup, make one before doing anything else, 
as long as you still have somewhat access to your stuff.

Regards
Andreas Klauer

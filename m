From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: adding a missing drive(s), which drives get written to? a thank
 you.
Date: Tue, 10 Dec 2013 22:16:02 +0000
Message-ID: <BLU0-SMTP14816803676F341D602402898D20@phx.gbl>
References: <BLU0-SMTP144CE5F6040BC17EDAE8A9E98D30@phx.gbl>
	 <20131210085920.GB441@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131210085920.GB441@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org, bernd.schubert@fastmail.fm
List-Id: linux-raid.ids

On Tue, 2013-12-10 at 08:59 +0000, Robin Hill wrote:
> On Mon Dec 09, 2013 at 02:09:11PM +0000, Wilson Jonathan wrote:
> 
> > After recovering from a failed raid6, now running with 2 missing drives
> > and soon to be finally backed up (is still backing up), I have 2 related
> > questions...
> > 
> > The first is, can I add in both drives at the same time, or do I need to
> > add them in singly, just checking for clarity?
> > 
> You can add both together. Older versions of mdadm would kick off the
> rebuild before the addition of both disks had been completed though, so
> you might want to freeze the array first:
> 
>  echo freeze > /sys/block/md0/md/sync_action                                    
>  mdadm /dev/md0 --add /dev/foo /dev/bar                                         
>  echo idle > /sys/block/md0/md/sync_action                                      
> 
> > The second question is far more important... during the re-creation of
> > data on the newly added missing disk/partition(s) does mdadm just read
> > the data from the original array and write to the new disk(s) or does it
> > potentially write new/update existing data (excluding bitmap/superblock)
> > to the existing disks.
> > 
> The rebuild process will only write data to the new disks. The only
> cases where data will be written to the old disks during a rebuild is if
> a read error is triggered and the data has to be reconstructed (not
> applicable in your case as you have no redundancy to rebuild the data
> from in the case of a read error), or if new data is written to the
> array.
> 
> Cheers,
>     Robin

Wow that was a bum tightening 7 hours (I set the recovery to be
slow[er], so I didn't tax the existing 4 drives, probably would have
made no difference had I maxed it out but I do occasionally get a sata
reset if doing things like DD and other things on disks that are under
heavy load)

The echo > freeze didn't work and came up with an error, so I tried >
idle which it accepted... then did some googling and found that doing an
idle to an array with multiple drive adds should stop and re-start it so
even if the mdadm only tried to add 1 drive, it would then re-start and
then add the 2 drives (was in a post on here by Niel Brown in 2012.)

Thank you for your help, and Bernd Schubert who posted to my initial
thread when I had problems, it was much appreciated.

Jon.




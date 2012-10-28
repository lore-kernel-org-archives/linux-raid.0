From: Chris Murphy <lists@colorremedies.com>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 16:35:41 -0600
Message-ID: <D28CB381-95EB-4400-B9D7-E2A1E0B372D5@colorremedies.com>
References: <11510711257.20121028131527@oudeis.org> <DB91871A-731F-44B4-9381-8FBF7D9CC3BF@colorremedies.com> <20121029015910.018efb17@natsu> <F548750F-8D0E-4D05-813B-58D85D652226@colorremedies.com> <20121029021643.1c9e3195@natsu> <46B8932A-58A5-4C1A-9C8C-DCCD5D3A1CD9@colorremedies.com> <A9ED9351-3430-43B8-AEA8-031B3DE29522@colorremedies.com> <6FAB7F92-66E2-4276-9774-B80DAC92E450@colorremedies.com> <20121029031851.42a5e1e9@natsu> <508DA794.9030106@meetinghouse.net>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DA794.9030106@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 28, 2012, at 3:45 PM, Miles Fidelman <mfidelman@meetinghouse.net> wrote:

> Roman Mamedov wrote:
>> I do not think there is a state in modern HDDs that there would be a sector which consistently takes 30-120 seconds to read. Those are either unreadable at all, or readable after a delay -- and then already remapped by the HDD into the reserved zone, so the delay is not there the next time. 
> 
> Umm... yes.  This is a common near-failure mode with WD disks, as I learned the hard way when I discovered that I had a server that had been built with desktop drives rather than enterprise drives.  Took quite some time to figure out why my server was slowing WAY down. I still kind of wonder why md doesn't consider exceptionally long read times as a reason to drop a drive from a RAID array.

Drives should be more reliable than this and if they aren't, it's the wrong drive for the task. I'm pretty sure that's the XFS dev position on this too: this sort of data integrity question is drive and application domain, not really kernel or filesystem domain.

And better than dropping a drive from an array, which significantly increases your risk of contact with any subsequent error the system encounters, is to contend with the error. Otherwise you're just exchanging the location of the problem from a hardware controller prematurely dropping multiple drives leading to a collapsed array, to md raid doing the same thing and that's not an improvement worthy of a feature. But it may not be so easy to put md into a 2 minute degraded mode, restoring the array to useful operation, while waiting for that drive to get a grip. Once it has returned, it's anywhere from seconds to 2 minutes behind the array state. So some way to quickly bring it back up to speed would be needed, or you'd have a resync delay on your hands. And that sounds to ignorant me fairl
 y non-trivial.

Honestly I think there are better ways to manage this. Don't use this class of drives for this purpose is one. Another is you take exception measures to make sure they're really working well: I'm not sure if the SATA spec defines transient vs persistent read/write failure unambiguously. Or if each manufacturer's firmware can play loosey goosey with what exactly is a persistent vs transient fail. If it's loose, even an ATA Secure Erase could mean you get "transient" and thus acceptable fail on some sectors than some other firmware (maker, model or even version) would mark as persistent.


On Oct 28, 2012, at 3:59 PM, joystick <joystick@shiftmail.org> wrote:

> Suppose that in one disk you are hitting a bad area where all sectors are unreadable: that's a 256-sectors sequence of 7 seconds waits, that means HALF AN HOUR wait!
> it's total nonsense

That's a lot of bad sectors to have happen all of a sudden. I think I'd be concerned about that, even though the delay is the immediate crisis. 

> I want the SCSI command to be aborted, device RESET, bus RESET or whatever (without the drive dropping out of the controller if possible), then an error to be returned to MD so that it starts the sector rewrite and goes on immediately. Do you think this would be possible or it would puzzle the drive?

My vague recollection of slides comparing SATA and SAS was that once SATA is in an error condition it's non-responsive until it's reconstructed the sector(s) or fails them. If failure, anything in the command queue is flushed, which is not the case for SAS. Maybe this is better dealt elsewhere than directly with the drive, like with AHCI if it could be informed "hey, could you just pretend this drive over here has been hot disconnected? thanks".


Chris Murphy


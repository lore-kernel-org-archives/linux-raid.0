From: Adam Luter <luterac@bellsouth.net>
Subject: Re: Creating in degraded mode...
Date: Wed, 26 Feb 2003 12:11:25 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030226181125.GH15283@smeagol>
References: <Pine.LNX.4.44.0302260819010.10893-100000@mackman.net> <Pine.LNX.4.44.0302260819010.10893-100000@mackman.net> <5.2.0.9.0.20030226094459.056a4a08@lain.mindwaresystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5.2.0.9.0.20030226094459.056a4a08@lain.mindwaresystems.com>
To: Kourosh Ghassemieh <linux-raid@mindwaresystems.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Devices, was a mistake, I meant to say device.  You're wanting to do
the same as Ryan.  No reason it shouldn't work.  Just know that RAID-5
in degraded mode can be kinda slow.

-Adam

On Wed, Feb 26, 2003 at 09:59:19AM -0800, Kourosh Ghassemieh wrote:
> 
> I'm interested in this as well.
> 
> Isn't a RAID-5 array with two missing drives broken?
> 
> Has anyone actually tried this?  I don't have any spare
> drives to play with to test.
> 
> The other option is to break the RAID-1, create a new
> RAID-5 with the two drives and the third, RAID-1, drive
> as the missing drive in the RAID-5 set.  Copy over the
> data from the RAID-1 drive and then add that drive back
> into the RAID-5 array and it should rebuild.
> 
> Any thoughts?
> 
> Regards,
> 
> Kourosh
> 
> At 08:57 AM 2/26/2003, Adam Luter wrote:
> >Using 'missing' for the device name for the missing devices.
> >
> >-Gryn (Adam Luter)
> >
> >On Wed, Feb 26, 2003 at 08:22:13AM -0800, rmack@mackman.net wrote:
> >> I currently have a 2 drive RAID-1 array.  I would like to convert it into
> >> a 3 drive RAID-5 array.  I'd rather avoid raidreconf because I'v never
> >> used it before.  It seems to me, that I should be able to run the 
> >existing
> >> RAID-1 in degraded mode (only one drive), and then copy it's contents to 
> >a
> >> degraded (only two drive) RAID-5 array.  The question, of course, is how
> >> do I create a RAID-5 array in degraded mode?  After the copy, I would 
> >then
> >> hotadd the other former RAID-1 drive into the RAID-5 and let it
> >> reconstruct the array.
> >>
> >> Any thoughts?  Please reply to me directly, I'm off the list for now.
> >>
> >> Thanks, Ryan Mack
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

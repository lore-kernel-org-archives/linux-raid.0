From: Adam Luter <luterac@bellsouth.net>
Subject: Re: Creating in degraded mode...
Date: Wed, 26 Feb 2003 10:57:13 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030226165713.GG15283@smeagol>
References: <Pine.LNX.4.44.0302260819010.10893-100000@mackman.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0302260819010.10893-100000@mackman.net>
To: rmack@mackman.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Using 'missing' for the device name for the missing devices.

-Gryn (Adam Luter)

On Wed, Feb 26, 2003 at 08:22:13AM -0800, rmack@mackman.net wrote:
> I currently have a 2 drive RAID-1 array.  I would like to convert it into 
> a 3 drive RAID-5 array.  I'd rather avoid raidreconf because I'v never 
> used it before.  It seems to me, that I should be able to run the existing 
> RAID-1 in degraded mode (only one drive), and then copy it's contents to a 
> degraded (only two drive) RAID-5 array.  The question, of course, is how 
> do I create a RAID-5 array in degraded mode?  After the copy, I would then 
> hotadd the other former RAID-1 drive into the RAID-5 and let it 
> reconstruct the array.
> 
> Any thoughts?  Please reply to me directly, I'm off the list for now.
> 
> Thanks, Ryan Mack
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

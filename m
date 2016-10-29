From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: recovering failed raid5
Date: Sat, 29 Oct 2016 14:02:30 +0200
Message-ID: <20161029120230.GA4725@metamorpher.de>
References: <CAM97BgQLPUN=t7VKHaVG-=SrJmS_tvaxGDbo3yqMwHm8B-do_Q@mail.gmail.com>
 <20161027160400.GA21042@metamorpher.de>
 <715b259f-1e56-9606-edc4-3e5c4d57744b@shenkin.org>
 <20161028133304.GA11564@metamorpher.de>
 <20161029152951.62add3ca@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161029152951.62add3ca@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 29, 2016 at 03:29:51PM +0500, Roman Mamedov wrote:
> And if there's an unreadable sector on rebuild as a drive found its 8th bad
> sector after 3 more years of perfect operation, that's not a problem either,
> because the setup they run in, is RAID6.

But if such disks are acceptable to run in a RAID, and you advertize it 
as such, you have to expect to see RAIDs where every single disk has a 
dozen reallocated sectors and a history of read errors to go with it.
Is that still fine? Do you expect to be lucky every time?

RAID-6 is not magic, either. Sooner or later, it will fail, too. 

Keep ignoring errors in RAID-5 and you'll see double failure.
Keep ignoring errors in RAID-6 long enough and you'll see triple failure.
All disks fail and many of them do silently, undetected if untested.

If you rented a server in a datacenter, thus entitled to working hardware, 
would you create a ticket on read failure or not?

Regards
Andreas Klauer

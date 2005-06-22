From: Mike Hardy <mhardy@h3c.com>
Subject: Re: SMART, was Re: More tales of horror from the linux (HW) raid
 crypt
Date: Wed, 22 Jun 2005 16:35:10 -0700
Message-ID: <42B9F5AE.7040305@h3c.com>
References: <5d96567b05061804477325d743@mail.gmail.com> <200506221316.33178.hjm@tacgi.com> <20050622223833.60b3eba1.pegasus@nerv.eu.org> <200506221433.00321.hjm@tacgi.com> <20050622231513.GC23624@sam.triumf.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050622231513.GC23624@sam.triumf.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Konstantin Olchanski <olchansk@sam.triumf.ca>
Cc: Harry Mangalam <hjm@tacgi.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Konstantin Olchanski wrote:

> But does anybody know what all these SMART parameters *mean* ?!?
> 
> What is this "Raw_Read_Error_Rate"?
> What is this "Seek_Error_Rate"?

Most of them seem to make sense.
I'd guess raw read error rate is the number of read errors corrected by
the firmware in some way (recalibration, ecc, or something).
Seek error rate is probably a calibration thing. The last time I googled
one, I got a pretty good answer.

This was the site I saw:
http://www.ariolic.com/activesmart/smart-attributes/soft-read-error-rate.html

> Then for the SMART "status", it is completely useless- I had SMART
> complain about perfectly good disks ("this disk will fail soon!!!"- a few
> 120GB WDs that sometimes stop seeking, probably through overheating)
> and I had completely unusable disks (i.e. develops about 10 unreadable
> sectors per day) that SMART was perfectly happy with.

Well, I guess anecdotal evidence is just that. At least for the mostly
Maxtor drives I run (which do fail from time to time, alas), the SMART
monitoring has been dead on. Every time. If there's a bad block, SMART
sees it. Right before the drive goes belly-up mysteriously, I'll get
lots of soft read error rate triggers or TA increase count triggers etc.
Its gotten to where if its not a bad block, I should just about hook it
up with an automated dealtime.com query to just buy a drive.

I imagine most folks are somewhere in between. I'm never going to run a
drive without smartd watching it again though, that's for sure.

-Mike

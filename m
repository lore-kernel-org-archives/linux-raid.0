From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: number of global spares?
Date: Sat, 27 Aug 2005 08:56:31 +1000
Message-ID: <17167.40479.3220.155672@cse.unsw.edu.au>
References: <1125082848.25483.23.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Stromberg on Friday August 26
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday August 26, strombrg@dcs.nac.uci.edu wrote:
> 
> I've been working on a RAID setup with dual RAID controllers and
> three expansion boxes - 48 disks in all, including data, parity and
> global spares.

If there are 48 drives, why do your drive-numbers go up to 59?
Confusing but not important.

Presumably these are 360G drives (or there abouts) and you are hoping
to use about 42 for data and the remaining 6 for redundancy.

I feel this a bit tight but could be workable.

If you were using Linux-soft-raid, I would probably suggest 3 16-drive raid6
arrays, possibly making 1 a 15 drive raid6 so there is one global spare.
However I gather you are using hardware RAID - do the controllers
support RAID6 ??
> 
> Please be sure to use a fixed-pitch font when viewing the tables found
> below.  BTW, if people weren't so terrified of HTML, I could just make a
> nice HTML table for easy reading without silly font requirements...

You mean some mail readers use variable-width-fonts to display
text/plain?  How broken!

> 
> 
> Does anyone have any comments on:
> 
> 1) The sanity of these 10 disk RAID 5's?

It depends on the drives.
If you are using you-only-get-what-you-pay-for-IDE-drives, then I
would say it is insane.
If you are using you-pay-for-the-quality SCSI drives, then you should
be fairly safe.

> 
> 2) The degree of loss of reliability incurred by moving 3 disks from
> global spare to data?

That depends a bit on your warranty arrangements on the drives.  If
it's next-day-replacement (Really, truly) then it is probably OK.  If
it is 'send us the bad drive and we'll see what we can do', then I
would suggest thinking again.

> 
> 3) The degree of loss of reliability incurred by moving 2 disks from
> global spare to data?
> 

Should be safe enough.

However I don't understand why you have 4 9+1 arrays, and 1 X+1 for
varying X.  Maybe 9+1 is the largest the controller will give you, so
you have to go to 5 arrays.
In that case, 4 8+1 arrays, 1 9+1 array, and 2 global spares would
seem a more sensible arrangement.


NeilBrown

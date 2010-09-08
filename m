From: Neil Brown <neilb@suse.de>
Subject: Re: 3-way mirrors
Date: Wed, 8 Sep 2010 16:02:07 +1000
Message-ID: <20100908160207.1075c60d@notabene>
References: <20100908054541.3760.qmail@s217.sureserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100908054541.3760.qmail@s217.sureserver.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 08 Sep 2010 05:45:41 +0000
"Michael Sallaway" <michael@sallaway.com> wrote:

> 
> >  -------Original Message-------
> >  From: Neil Brown <neilb@suse.de>
> >  To: Michael Sallaway <michael@sallaway.com>
> >  Cc: linux-raid@vger.kernel.org
> >  Subject: Re: 3-way mirrors
> >  Sent: 08 Sep '10 04:16
> 
> >  > Interesting... will this also work for a rebuild/recovery? If so, how do I start a rebuild from a particular location? (do I just write the sync_min sector before adding the replacement drive to the array, and it will start from there when I add it?)
> >  
> >  Why would you want to?
> 
> (My apologies for hijacking the email thread, I only meant it as a side question!)
> 
> The reason relates to my question I posted yesterday -- I have a 12-drive raid 6 array, with 3 drives that have some bad sectors at varying locations. I planned to swap out one drive with a new one, and let it rebuild that one, then do the same for the other 2. However, when I replace and rebuild drive A, drive B gets read errors and falls out of the array (at about 50% through), but recovery continues. At the 60% mark, however, drive C gets read errors, and also falls out of the array, which now only has 9 working devices, so abandons recovery. (even though drive B has vaild data at that location, so it could be rebuilt).

Hmm.... Drive B shouldn't be ejected from the array for a read error.  md
should calculate the data for both A and B from the other devices and then
write that to A and B.
If the write fails, only then should it kick B from the array.  Is that what
is happening?

i.e. do you see messages like:
   read error corrected
   read error not correctable
   read error NOT corrected

in the kernel logs??

If the write is failing, then you want my bad-block-log patches - only they
aren't really finished yet and certainly aren't tested very well.  I really
should get back to those.

NeilBrown


> 
> One solution I thought of (and please, suggest others!) was to recover 55% of the array onto the new drive (A), and then stop recovery somehow. Then forcibly add drive B back into the array, and keep recovering, so that when it hits the 60% mark, even though drive C fails, it can still get parity data and recover using drive B.
> 
> It sounds crazy, I know, but can't think of a better solution. If you have one, please suggest it! :-)
> 
> 
> > You can add a new device entirely by writing to sysfs files.  In this case
> > you can set the 'recovery_start' for that device.  This tells md that it has
> > already recovered some of the array.
> 
> Interesting, I think this is exactly what I'm after. Is this documented somewhere, or can you give me some pointers as to where to look to find more information/documentation on the sysfs files and what they do, etc.?
> 
> Thanks!
> Michael


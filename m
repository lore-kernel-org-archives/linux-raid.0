From: Neil Brown <neilb@suse.de>
Subject: Re: reshape success story
Date: Sun, 31 Oct 2010 11:46:55 -0400
Message-ID: <20101031114655.36e627e3@notabene>
References: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
	<4CCD7AE1.8000705@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CCD7AE1.8000705@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Florian Dazinger <flockmock@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 31 Oct 2010 14:19:13 +0000
John Robinson <john.robinson@anonymous.org.uk> wrote:

> On 31/10/2010 13:41, Florian Dazinger wrote:
> [...]
> > Unlike what I excpected from the man-page,
> > I had network traffic during the *whole* reshape-process, not just at
> > the beginning.
> 
> Perhaps the man page needs updating then. The backup file is only used 
> at the beginning for grows, or at the end for shrinks, but a same-size 
> reshape (as yours was, going from 4-disc RAID-6 to 3-disc RAID-5) needs 
> to back up everything because there's no spare space.
> 
> Of course when the man page section on reshaping and the use of the 
> backup file was originally written, changing RAID level wasn't 
> supported, and nor were shrinks, so the backup file was only used for 
> grows, so it was only used at the beginning.
> 
> If I've got the above right (someone please correct me if I'm not) 
> perhaps I could make a modest contribution (for a change) by updating/ 
> patching the man page...

That would certainly be appreciated.   Your understanding appear to be
correct!

> 
> Actually that makes me wonder: the man page says spare devices can be 
> used for the backup if there are any. Is that still true with all the 
> grows, shrinks and level-changing reshape options we have now? I'd 
> expect that method of backup to be (slightly) faster than putting the 
> backup on a filesystem (even on a local disc).

I think mdadm insists on a backup file for shrinks and same-size
transformations.  It probably could use a spare, but I think there is
generally less likely to be one - when you are growing an array there is
almost certainly an array to grow to.

Write to a file on a local disk should be just as fast as writing to a raw
device .... I guess there could be a little bit of filesystem overhead, but I
doubt you would be able to measure it.


> 
> > thank you very much for all the good work and user support on this list!!
> 
> It is nice to hear positive feedback, but at the same time I tend to 
> think that since there must be millions of users of md/mdadm, it's 
> pretty encouraging that there are only one or two "arghs" per day...

:-)

Certainly - positive feedback is always welcome!

NeilBrown



> 
> Cheers,
> 
> John.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


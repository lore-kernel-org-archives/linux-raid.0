From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: reshape success story
Date: Sun, 31 Oct 2010 14:19:13 +0000
Message-ID: <4CCD7AE1.8000705@anonymous.org.uk>
References: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinnaRECf9grA6-VEAg7YNvN6M4cHWKBYsfj4v6B@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Dazinger <flockmock@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/10/2010 13:41, Florian Dazinger wrote:
[...]
> Unlike what I excpected from the man-page,
> I had network traffic during the *whole* reshape-process, not just at
> the beginning.

Perhaps the man page needs updating then. The backup file is only used 
at the beginning for grows, or at the end for shrinks, but a same-size 
reshape (as yours was, going from 4-disc RAID-6 to 3-disc RAID-5) needs 
to back up everything because there's no spare space.

Of course when the man page section on reshaping and the use of the 
backup file was originally written, changing RAID level wasn't 
supported, and nor were shrinks, so the backup file was only used for 
grows, so it was only used at the beginning.

If I've got the above right (someone please correct me if I'm not) 
perhaps I could make a modest contribution (for a change) by updating/ 
patching the man page...

Actually that makes me wonder: the man page says spare devices can be 
used for the backup if there are any. Is that still true with all the 
grows, shrinks and level-changing reshape options we have now? I'd 
expect that method of backup to be (slightly) faster than putting the 
backup on a filesystem (even on a local disc).

> thank you very much for all the good work and user support on this list!!

It is nice to hear positive feedback, but at the same time I tend to 
think that since there must be millions of users of md/mdadm, it's 
pretty encouraging that there are only one or two "arghs" per day...

Cheers,

John.

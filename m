From: maarten <maarten@ultratux.net>
Subject: Re: Concatenation with redundancy
Date: Tue, 7 Sep 2004 21:15:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409072115.32413.maarten@ultratux.net>
References: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56EE8176-00EE-11D9-94CF-0005023722B8@ubb.ca>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 07 September 2004 18:52, Tony Mantler wrote:
> Hello,
>
> Recently I've seen a growing trend in creating very ad-hoc storage
> arrays for storing large quantities of media files (videos, music,
> etc). These arrays are usually initially created with a small number of
> concatenated drives, say 2 or 3, but over time can easily grow to span
> 6 or 8 drives as personal budgets allow.
>
> Obviously as time goes by the exposure to a single drive failure taking
> down the whole filesystem increases considerably, and I've seen this
> happen a number of times. Due to the size (frequently 1-2tb) and nature
> of data on the array, backup is usually impractical.

I know (and share) that feeling.  However, as has been said so often, raid is 
no substitute for backups.  Because apart from drive failure there are much 
much more dangers to killing your files, and they are in part even more real 
dangers as well; think about theft, viruses, user-error, fire and lightning 
strikes.  (And a whole bunch more, if you happen to live in Florida...) 

> It would seem that the current options for combining redundancy with
> flexible expansion capability leave a little to be desired. RAID 10
> presents far too much wasted space for this type of application, and
> RAID 50 offers much less flexibility than is desired, and is still too
> inefficient for the number of drives in question.
>
> Thus the idea came to me for creating a somewhat new RAID level, which
> would be a concatenation with dedicated parity. Call it RAID 4C maybe,
> as in "RAID 4, but concatenated rather than striped".
>
> Thus, the data would appear as thus:
>
> drive 1   drive 2   .. parity drive
> block 1 ~ block N+1 .. = parity 1
> block 2 ~ block N+2 .. = parity 2
> ..
> block N ~ block N+M .. = parity N

Don't know if it exists or not, I'm not fully versed on the different raid 
levels.  But wouldn't it be moke akin to a linear array + parity ?  As I 
understand you, all of the 'first' data resides on disk1 until that is full 
and then further data goes on the next drive, etc.
You lose all performance benefits that other raid levels offer this way of 
course, but that might be a drawback that one can live with, depending on the 
scenario you use it for...  
I think it's a nice idea.  Performance-wise it's probably a real bad idea 
(you'll usually use only 1 of the drives, and the parity drive will be hit 
real hard since it is read & written at every access). But, who knows ? 

Maarten

> This would allow for inserting new drives without mangling the block
> order, thus preserving the data on the array. Ideally it would also be
> possible to create a heterogeneous array by ensuring that the parity
> drive was equal to or larger than the largest data drive, and assuming
> zeroed blocks for all non-present sectors.
>
>
> So, am I smoking crack here? Does anyone think this would be worth
> implementing? Has this already been implemented and I just haven't seen
> it?
>
>
> Cheers - Tony 'Nicoya' Mantler :)
>
> --
> Tony 'Nicoya' Mantler -- Master of Code-fu -- nicoya@ubb.ca
> --  http://nicoya.feline.pp.se/  --  http://www.ubb.ca/  --
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
When I answered where I wanted to go today, they just hung up -- Unknown


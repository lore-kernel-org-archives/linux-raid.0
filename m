From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID1 seems not to be able to scrub pending sectors shown by
 smart
Date: Fri, 23 Dec 2011 16:26:39 -0600
Message-ID: <4EF5001F.8050409@gmail.com>
References: <87hb0r2kvq.fsf@poker.hands.com> <CAAMCDedN7nBrt7nLoUq2v26ZoX21ab+htowc3r2A=nOAvfF42A@mail.gmail.com> <878vm32dan.fsf@poker.hands.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <878vm32dan.fsf@poker.hands.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philip Hands <phil@hands.com>
Cc: 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/23/2011 03:22 PM, Philip Hands wrote:
> On Fri, 23 Dec 2011 13:59:21 -0600, Roger Heflin<rogerheflin@gmail.com>  wrote:
>> On Fri, Dec 23, 2011 at 12:39 PM, Philip Hands<phil@hands.com>  wrote:
> ...
>> I had 4 1.5tb seagate drives from 2009 (bought at different times in
>> 2009) and 3 of those 4 started getting lots of bad sector all within a
>> 2 month period and all 3 finally officially failed smart.and when the
>> sectors (one after another...lucky they failed out aover 2-3 weeks so
>> I had got the replacements in before I lost data-I was down to no
>> redundancy for several days in the middle) were failing and being
>> rewritten the performance was just ugly--so even if raid1 was
>> rewriting the drives it does not do anything for performance when the
>> drives are going bad...the only thing that solved my performance was
>> getting all of the failing devices to finally fail smart so they could
>> be RMAed and replaced at minimal cost..
>
> Well, I suppose that's to some extent the reason I mentioned this.
>
> It seems to me that if a disk is throwing _loads_ of read errors, and
> running dreadfully slowly, one could react to that by favouring
> different disk(s), and only occasionally throwing a read at the duff
> disk, until it either sorts itself out or dies.
>
> My performance went from rubbish to fine simply by removing the
> 360-pending-sector disk from the RAID.  OK, so if the problem is that
> writes are being delayed by the dodgy disk, that's not easy to deal
> with, but looking at the logs makes it look like the reads quite often
> keep targeting the same disk even when several reads just failed and
> got redirected.  This seems suboptimal to me.
>
> Cheers, Phil.

In mine I am pretty sure the reads being delayed was causing issues.

I wonder if a patch might be possible that allows one to put an array 
into a mode (or go into said mode once a badblock condition has 
happened) that causes it to read from at least 2 possible data sources 
and return whichever gets there first...in the raid1 case it would 
read from another mirror (esp if one of the data sources was known to 
be flakey), in the raid5/6 case it would need to read one of the 
parity disks and calculate the correct data...that would appear to 
help in this sort of situation...in all other situations the extra 
reads would appear to hurt things, but it may produce less performance 
issues when these sorts of things happen).   No idea how bad this 
would be to implement...and it won't help with the case where the 
writes are getting delayed because the reads are having serious issues 
with bad sectors, in this case the reads would continue to go through, 
but eventually I would think that enough writes backed up to cause 
things to stop anyway...

The recent disk quality does appear to have gone downhill...with the 
previous 160-250 gb drives and the later 500gb drives I had not seen 
many issues...but the 1-2TB drives appear to be a mess and certainly 
don't appear to be aging well, nor the the initial quality appear to 
be that good either...

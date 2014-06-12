From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 10:15:32 +0800
Message-ID: <53990D44.300@fnarfbargle.com>
References: <5397FBCE.3060009@bartk.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5397FBCE.3060009@bartk.us>
Sender: linux-raid-owner@vger.kernel.org
To: Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/06/14 14:48, Bart Kus wrote:
> Hello,
>
> As far as I understand, md-raid relies on the underlying devices to
> inform it of IO errors before it'll seek redundant/parity data to
> fulfill the read request.  I have, however, seen certain hard drives
> report successful reads while returning garbage data.

If you have drives that return garbage as valid data then you have far 
greater problems than what you are suggesting will fix. So much so I 
suggest you document these instances and start banging a drum announcing 
them in a name and shame campaign. That sort of behavior from storage 
devices is never ok, and the manufacturer needs to know that.

This comes up on the list at least once a year, and the upshot is that 
your storage platform needs to be reliable. Storage is *supposed* to be 
reliable. Even the cheapest solution is *supposed* to say "I'm sorry but 
that bit of data you asked for is toast". Even my 35c USB drives do that.

Whether you have a single drive or 10 mirrors, if you have a drive 
returning garbage you need to solve that problem first. Patching 
software that is based on the fundamental assumption that the storage 
stack knows when something is bad, to no longer trust that assumption 
makes all sorts of guarantees go out the window.

 From personal experience, I lost a 12TB RAID-6 and all the data on it 
due to a bad SATA controller. The controller would return corrupt reads 
under heavy load, and months of read/modify/write cycles combined with 
corrupt data spread the corruption all over the array. My immediate 
reaction was the same as yours. "RAID6 should be able to protect against 
this stuff", but after education from people that are more knowledgeable 
than I, it became apparent that bad hardware is JUST insidious and 
papering over one part of the stack would just lead to it biting me 
elsewhere anyway.

I learned 2 very valuable lessons.
- Don't deploy hardware unless you trust it. This may mean a month of 
burn-in testing in a spare machine, or delaying trusting it with 
valuable data. In my case it was a cheap 2 port PCIe SATA card procured 
to get me out of a tight spot, so I plugged it in and strapped drives to 
it blindly believing it would be ok.
- RAID is no substitute for backups.



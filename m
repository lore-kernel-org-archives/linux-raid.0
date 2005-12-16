From: Tobias Hofmann <tobias.hofmann@medien.uni-weimar.de>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 09:01:07 +0100
Message-ID: <43A27443.7050509@medien.uni-weimar.de>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com> <43A1D642.2010301@wasp.net.au> <43A1E0CE.7090805@medien.uni-weimar.de> <dnt6if$q2o$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dnt6if$q2o$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16.12.2005 02:51, Max Waterman wrote:
> Tobias Hofmann wrote:
> 
>> <delurk>
>>
>> On 15.12.2005 21:46, Brad Campbell wrote:

[...]

>>> /me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?
> 
> Just so I am clear on this : while RAID5 consumes a disk's worth of 
> space for parity, resulting in n-1 disk's worth of space available for 
> storage, RAID6 consumes two disk's worth of space for two parities, 
> resulting in n-2 disk's worth of space available for storage.
> 
> Is that correct?

imho yes.

>> Me too. ;) So, with holidays ahead, two questions (as I might tackle 
>> that soon and have not found it mentioned):
> 
> I would guess one reason might be that you only have 3 disks - ok 
> (minimum) for RAID5, but not for RAID6 (minimum is 4?)?

I would, in the long run, probably prefer to shell out the money for 
another disk (RAID6, then) instead of being bitten of a bad block 
showing up while resyncing a RAID5, leading to all the effects mentioned 
on this list before. I have been there already with a commercial EIDE/FC 
raid enclosure - ugly. Of course, this risk can be reduced once the 
infamous passthrough patch for enabling SMART capabilities for SATA 
disks finally makes it into mainline kernel, which seems to be the case 
with 2.6.15, and one can have a daily check for bad blocks...

greets, tobi... :)

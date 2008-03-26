From: David Greaves <david@dgreaves.com>
Subject: Re: What do Events actually mean?
Date: Wed, 26 Mar 2008 08:57:29 +0000
Message-ID: <47EA0FF9.5000304@dgreaves.com>
References: <47DD2CD7.2090802@tuxes.nl>	<20080316161451.0d17fd22@szpak>	<47E26775.3000500@tuxes.nl>	<20080320134747.GA28114@cthulhu.home.robinhill.me.uk>	<47E2725C.1020206@tuxes.nl>	<20080320163551.GG13719@mit.edu>	<47E2EE64.5080101@rabbit.us>	<47E3C504.3010700@tmr.com>	<47E3CBAF.4090808@rabbit.us>	<47E43E57.5010409@tmr.com>	<20080321235557.GA11801@cthulhu.home.robinhill.me.uk>	<47E4D95A.9000505@rabbit.us>	<alpine.DEB.1.00.0803220640550.24697@p34.internal.lan> <18408.30798.940744.724391@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18408.30798.940744.724391@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, Peter Rabbitson <rabbit+list@rabbit.us>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Saturday March 22, jpiszcz@lucidpixels.com wrote:
>>
>> On Sat, 22 Mar 2008, Peter Rabbitson wrote:
>>
>>> Robin Hill wrote:
>>>> On Fri Mar 21, 2008 at 07:01:43PM -0400, Bill Davidsen wrote:
>>>>
>>>>> Peter Rabbitson wrote:
>>>           UUID : b6a11a74:8b069a29:6e26228f:2ab99bd0 (local to host Arzamas)
>>>         Events : 0.183270
>>>
>>> As you can see it is pretty old, and does not have many events to speak of.
>> What do the 'Events' actually represent and what do they mean for RAID0,
>> RAID1, RAID5 etc?
> 
> An 'event' is one of:
>    switch from 'active' to 'clean'
>    switch from 'clean' to 'active'
>    device fails
>    device is added
>    spare replaces a failed device after a rebuild
> 
> I think that it all.
> 
> None of these are meaningful for RAID0, so the 'events' counter on
> RAID0 should be stable.
> 
> Unfortunately, the number looks like a decimal but isn't.
> It is a 64bit number.  We print out the top 32 bits, then the bottom
> 32 bits.  I don't remember why.  Maybe I'll 'fix' it.
> 
>> How are they calculated?
> 
>    events = events + 1;
> 
> 
> Feel free to merge this text into the wiki.

Thanks Neil :)

http://linux-raid.osdl.org/index.php?title=Event

I also added:

== What are they for? ==
When an array is assembled, all the disks should have the same number of events.
If they don't then something odd happened.

eg:
If one drive fails then the remaining drives have their event counter
incremented. When the array is re-assembled the failed drive has a different
event count and is not included in the assembly.


This lead me to ponder: How/when are events reset to equality?
I wrote:
  The event count on a drive is set to zero on creation and reset to the
majority on a resync or a forced assembly.

Is that right?

David

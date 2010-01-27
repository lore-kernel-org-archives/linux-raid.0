From: Giovanni Tessore <giotex@texsoft.it>
Subject: Re: Read errors on raid5 ignored, array still clean .. then disaster
 !!
Date: Wed, 27 Jan 2010 10:56:05 +0100
Message-ID: <4B600DB5.3030309@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> > Is there any way to configure raid in order to have devices marked faulty 
> > on read errors (at least when they clearly become too many)?
> I don't think so
>   
I think it would be useful to be able to configure the number of 
recovered read error allowed before the device goes faulty.

> > This could (and for me did) bring to big disasters!
> Don't agree with you, you had all the info from syslog
> You should have run smart tests on the disks and proactively replace a
> failing disk.
>   
Would be nice if md issues warning on recovered read error events, such 
as it does for other md events (device failure, etc.).

> it does _not_ ignore read errors 
> in case of read errors mdadm rewrites the erroring sector, and only if
> this fails it will kick the member out of the array.
> with modern drives it is possible to have some failed sector, which the
> drive firmware will reallocate on write (all modern drives have a range
> of sectors reserved for this very purpose)
> mdadm does not do any bookkeeping on reallocated_sector_count per drive
> the drive does. the data can be accessed with smartctl
> drives showing excessive reallocated_sector_count should be replaced.
>   
Sorry, with ignore I mean "it silently manage to recover the read error, 
without alerting anybody"
Btw, as I see from kernel sources, it keep track of recovered read error 
per device instead.
And only when they are > 256 it marks the device faulty (I'm preparing 
another post on it).
So, why to wait for just 256 errors?
I think should be configurable ... and a much lower level for me.

> Consider the following scenario:
> raid5 (sda,b,c,d)
> sda has a read error, mdadm kicks it immediately from the array
> a few minutes/hours later sdc fails completely
> lost data and no time to react, that is far worse than having 50 days of
> warnings and ignoring them.
>   
Yes, but suppose that sda has a number of corrected read errors that is 
250; it's still clean.
sdc fails and is kicked off
resync starts
sda get > 6 read erros during resync, it's set as faulty (and it's 
likely to happen as the drive is clearly dying)
lost data the same way
(this is my real scenario actually, really happened)

Much difference?

Personally i'd prefere to know as soon as possible that something is 
going wrong, if not setting the device faulty, with a warning (by mail 
like other md events), saying "this is the n-th revocered error for this 
device"
IMHO the admin have to be clearly awared *by md*, not other monitoring 
tools, that the array is facing a possible critical sistuation.

> I'm sorry for your data, hope you had backups.
>   
Thanks.
I am trying to recover forcing to re-add the drive which gives read 
errors and using the array in degraded mode ... it seems to work.

Giovanni

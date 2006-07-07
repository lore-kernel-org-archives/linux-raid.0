From: Reuben Farrelly <reuben-lkml@reub.net>
Subject: Re: Resizing RAID-1 arrays - some possible bugs and problems
Date: Sat, 08 Jul 2006 10:58:06 +1200
Message-ID: <44AEE6FE.20900@reub.net>
References: <44AE644C.9090408@reub.net> <17582.56369.13427.473503@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17582.56369.13427.473503@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 8/07/2006 10:12 a.m., Neil Brown wrote:
> On Saturday July 8, reuben-lkml@reub.net wrote:

>> And lastly, I felt brave and decided to plunge ahead, resize to 128 blocks 
>> smaller than the device size.  mdadm --grow /dev/md1 --size=
>>
>> The kernel then went like this:
>>
>> md: couldn't update array info. -28
>> VFS: busy inodes on changed media.
>> md1: invalid bitmap page request: 150 (> 149)
>> md1: invalid bitmap page request: 150 (> 149)
>> md1: invalid bitmap page request: 150 (> 149)
> 
> Oh dear, that's bad.
> 
> I guess I didn't think through resizing of an array with an active
> bitmap properly... :-(
> That won't be fixed in a hurry I'm afraid.
> You'll need to remove the bitmap before the grow and re-add it
> afterwards, which isn't really ideal.  
> I'll look at making this more robust when I return from vacation in a
> week or so.
> 
> NeilBrown

Thanks for the response and references to the manpage, Neil.  I had misread the 
reference to 'max' and not realised it was a keyword/option that could be passed 
to --size.

I disabled bitmaps and the machine went into a bit of a spin.  It returned 
immediately at the prompt when I removed the bitmap (--bitmap=none) but each 
session locked up as soon as I attempted any sort of disk I/O, ie attempting 
things like 'df' or using 'less' which is mounted on the root filesystem on md0 
which is one I was disabling bitmaps on.  I had to power cycle the box to get a 
response from it.

Nothing was logged in /var/log/messages so unfortunately I've not anything to 
work with on it.  But I guess it further suggests that it was the disk I/O that 
did fall over.

Then I rebooted into single user mode, noticed that the system had in fact 
removed the bitmaps, and did my resize using --size=max.  It worked!  Now I can 
move on to resizing the filesystems themselves.

In other news, last night I requested an upgrade of mdadm in Fedora Core/Devel 
and this has since been done, so 2.5.2 should come through tonight in the 
nightly FC build (and of course be in FC6 when it comes out).

reuben



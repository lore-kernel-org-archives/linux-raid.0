From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: Stripe Block Size.
Date: Mon, 05 Apr 2004 13:05:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1081188358.4745.20.camel@localhost.localdomain>
References: <40718078.7010303@ocis.net>
 <1081180986.4745.4.camel@localhost.localdomain> <40719048.70705@ocis.net>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <40719048.70705@ocis.net>
To: "Jason C. Leach" <jleach@ocis.net>
Cc: RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2004-04-05 at 11:58, Jason C. Leach wrote:
> Matt Gulick wrote:
> 
> >On Mon, 2004-04-05 at 10:51, Jason C. Leach wrote:
> >  
> >
> >>hi,
> >>
> >>I have a Promise SX6000 in a RAID5 using Linux Debian on an AMD 
> >>AthelonXP 2500+.  This array will store mostly GIS data. So about 30% 
> >>large files (a few hundred megs) and 70% small files (several megs).  I 
> >>am curious what stripe block size to use 4-64k (the fs is reiserfs).  I 
> >>was thinking 32k for the stripe block size.
> >>
> >>Thanks,
> >>J.
> >>    
> >>
> >
> >J,
> >
> >If the large files are Audio/Video for streaming, then you will want a
> >larger stripe size.  If not, go with the smallest that you can (a small
> >~.h or text file will take the same amount of space as your stripe
> >size).
> >
> >The best way to set this is to consider the total volume size.  What
> >will be the allocation block size be for that size of volume if it were
> >on a single disk for that OS?.  Set you allocation size to be the same
> >or some multiple of that value.
> >
> >  
> >
> Thanks for the reply. The total volume size will be 800G. I'm not sure 
> what reiserfs/Linux would use for the block size if that were on one 
> disk.  Can you give me some tips? 
> 
> A significant portion of the files will be a few megs and above, not 
> really any .h or other small text files (say 1%).  No streaming 
> audio/vid. The GIS data will be csv files, shape files, large TIF 
> files.  Is it better to go smaller then larger with the stripe block size?
> 

J.

The stripe size really is dependent on the usage.

For streaming content, large stripes result in fewer head seeks which
take a relatively large amount of time and can impact throughput.

For use with data base type access, a stripe size equal to the record
size would be best.

For what you describe, I would use a stripe size that is no more than
1-2 X the allocation block size.

An example of a bad stripe size:

	Stripe Size = 64K
	Allocation Size = 48k

	Each Stripe read will read 2 or more allocation blocks and have
	to extract the correct data.  This gets real messy when
	allocation blocks require more than a single read.  Writes
	are even worse because now you need to do a read-modify-write
	for each block access unless the data is in a cached block.
	Even then, the fs still has to buffer move the data into the
	cached block before writing the data.

The same is also true where the Strip is smaller than the allocation
blocks.

What I would do is create the stripe using the smallest stripe allowed
by whatever tool you use.

Create a directory or two and save a small (2-3 text bytes with gedit or
vi will do) file.

Do an ls -al on the volume and look at what the size of the directories
and the text file are.  This will be a good indication of the allocation
size.  Now, reformat the RAID with that as your smallest stripe size. 
You can make the stripes larger if you want, but always make them an
integral multiple of the allocation size.

Good luck.

Matt


----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884



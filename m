From: "Conway S. Smith" <beolach@gmail.com>
Subject: Re: RAID5 to RAID6 reshape?
Date: Sun, 17 Feb 2008 07:45:26 -0700
Message-ID: <20080217074526.29d3c5c5@hardcode42.net>
References: <aebf5d970802161958x17a9da92r25663703dc0df05f@mail.gmail.com>
	<18360.8065.335494.142060@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18360.8065.335494.142060@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 17 Feb 2008 11:50:25 +0000
pg_lxra@lxra.to.sabi.co.UK (Peter Grandi) wrote:
> >>> On Sat, 16 Feb 2008 20:58:07 -0700, Beolach
> >>> <beolach@gmail.com> said:
> 
> beolach> [ ... ] start w/ 3 drives in RAID5, and add drives as I
> beolach> run low on free space, eventually to a total of 14
> beolach> drives (the max the case can fit).
> 
> Like for for so many other posts to this list, all that is
> "syntactically" valid is not necessarily the same thing as that
> which is wise. 
> 

Which part isn't wise?  Starting w/ a few drives w/ the intention of
growing; or ending w/ a large array (IOW, are 14 drives more than I
should put in 1 array & expect to be "safe" from data loss)?

> beolach> But when I add the 5th or 6th drive, I'd like to switch
> beolach> from RAID5 to RAID6 for the extra redundancy.
> 
> Again, what may be possible is not necessarily what may be wise.
> 
> In particular it seems difficult to discern which usage such
> arrays would be put to. There might be a bit of difference
> between a giant FAT32 volume containing song lyrics files or an
> XFS filesystem with a collection of 500GB tomography scans in
> them cached from a large tape backup system.
> 

Sorry for not mentioning, I am planning on using XFS.  Its intended
usage is general home use; probably most of the space will end up
being used by media files that would typically be accessed over the
network by MythTV boxes.  I'll also be using it as a sandbox
database/web/mail server.  Everything will just be personal stuff, so
if the I did lose it all I would be very depressed, but I hopefully
will have all the most important stuff backed up, and I won't lose my
job or anything too horrible.  The main reason I'm concerned about
performance is that for some time after I buy it, it will be the
highest speced of my boxes, and so I will also be using it for some
gaming, which is where I expect performance to be most noticeable.

> beolach> I'm also interested in hearing people's opinions about
> beolach> LVM / EVMS.
> 
> They are yellow, and taste of vanilla :-). To say something more
> specific is difficult without knowing what kind of requirement
> they may be expected to satisfy.
> 
> beolach> I'm currently planning on just using RAID w/out the
> beolach> higher level volume management, as from my reading I
> beolach> don't think they're worth the performance penalty, [
> beolach> ... ]
> 
> Very amusing that someone who is planning to grow a 3 drive
> RAID5 into a 14 drive RAID6 worries about the DM "performance
> penalty".
> 

Well, I was reading that LVM2 had a 20%-50% performance penalty,
which in my mind is a really big penalty.  But I think those numbers
where from some time ago, has the situation improved?  And is a 14
drive RAID6 going to already have enough overhead that the additional
overhead isn't very significant?  I'm not sure why you say it's
amusing.

The other reason I wasn't planning on using LVM was because I was
planning on keeping all the drives in the one RAID.  If I decide a 14
drive array is too risky, and I go w/ 2 or 3 arrays then LVM would
appear much more useful to me.


Thanks for the response,
Conway S. Smith

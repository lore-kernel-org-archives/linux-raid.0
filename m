From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: md questions [forwarded from already sent mail]
Date: Sat, 24 Jan 2004 11:27:40 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401241627.i0OGRii26925@dns1.watkins-home.com>
References: <200401241258.38857.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200401241258.38857.maarten@ultratux.net>
To: 'Maarten van den Berg' <maarten@ultratux.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>All of the above ;-) No seriously, it sounds like a problem with the
>hardware 
>somewhere along the line. Can you test the array on the OLD motherboard, by

>just plugging everything in ?  Also, if you're using persistent superblocks

>and type=0xFD, messing with the order in which the drives are attached / 
>recognized should not matter. It is confusing, but the array should 
>nonetheless assemble itself perfectly. At least in my experience.
>
>Maarten

RedHat used mkraid and raidstart.  I have problems starting my arrays.  Even
by hand using raidstart, but mdadm has no problems.  The problem is related
to the drive order.  It seems raidstart "knows" which disks are in the
array.  If their names change, game over.  I upgraded the firmware on a SCSI
card, now the order that the system "sees" the SCSI cards has changed, so
the disk names are different.  Someone tell RedHat to use mdadm!! Please!!
Oh, once I started the arrays with mdadm, it seems to have corrected the
problem with raidstart.  I guess it re-wrote the disk names, or something.
I wasted about a day on this issue, maybe it was something else I did.  I
did not want to customize any of the standard startup scripts.  Once you do,
it gets harder to support with updates and such.

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Maarten van den Berg
Sent: Saturday, January 24, 2004 6:59 AM
To: linux-raid@vger.kernel.org
Subject: Re: md questions [forwarded from already sent mail]

On Saturday 24 January 2004 01:31, Gene Heskett wrote:
> On Thursday 22 January 2004 19:28, Gene Heskett wrote:

> >Recompileing the 2.4.20 kernel that came with rh8.0 to add the md
> >support, then enabling that and formatting the md with the last
> >reiserfs 3.x version (from rh8.0's disks I believe) all went well.
> >This is what we had been using for 2 years, the only diffs being the
> >newer 180Gb drives instead of the former 160's, and the switch from
> > a 2.4.18 to a 2.4.20 kernel on a newer mobo.

I haven't used redhat in ages, but isn't md raid part of the 2.4 kernel ?? 
Why are you messing with 'adding' the md support if it is already there ?  
Or does redhat indeed do something that is inexplicable ?  

> >But, on the restart, with nothing other than the filesystem
> > installed on the 'md' drives, it gave us a resync time of about
> > 29,000 seconds. We cannot even see why a resync should be running
> > since the array was at that point empty.  This was 2 days ago, and
> > I've been informed that allthough the recovered crontab scripts
> > seem to be working, the write speeds are atrocious, something like
> > 16kb/second.  hdparm OTOH, reports the read times to be quite
> > respectable and in the 160Mb/sec area.

A resync will always start, the minute you create a raid device. That is 
transparent so any actions like mkfs can be performed nonetheless.
And this is well documented, if I'm not mistaken. (AFAIK)

The speeds are something to worry about.  I myself had the experience of a 
high reconstruction speed at the start of a resync, but then slowing to a 
crawl during the process. The further it got, the slower. Be advised that 
this was due to a -not so obvious- bad disk, so if you observe the same 
results you know where to look.

> >Also, and not sure if there is any connection, adding a 3rd promise
> >card seems to do a fine job of fscking up the drive scanning during
> >post.  Jim, haveing those 180's laying around, wanted to setup a
> >second md array of 2 of them running in mirror mode in that machine,
> >but thats apparently not possible.  It (post) seems to find several
> >more drives than actually exist, but none appear to be accessable
> >after post.

your hardware is malfunctioning

> >Recommendations?  Things to check?  We're idiots?

All of the above ;-) No seriously, it sounds like a problem with the
hardware 
somewhere along the line. Can you test the array on the OLD motherboard, by 
just plugging everything in ?  Also, if you're using persistent superblocks 
and type=0xFD, messing with the order in which the drives are attached / 
recognized should not matter. It is confusing, but the array should 
nonetheless assemble itself perfectly. At least in my experience.

Maarten

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



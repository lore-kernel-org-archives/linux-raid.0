From: Derek Piper <derek.piper@gmail.com>
Subject: RAID5 on different sized disks on low-end machine
Date: Tue, 11 Jan 2005 14:24:55 -0500
Message-ID: <eaa6dfe05011111244332b640@mail.gmail.com>
References: <eaa6dfe050111104772af6240@mail.gmail.com>
	 <200501112010.05469.maarten@ultratux.net>
	 <eaa6dfe05011111233e4a515f@mail.gmail.com>
Reply-To: Derek Piper <derek.piper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe05011111233e4a515f@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wow, you replied so quick to my first posting already, thanks Maarten! :)

On Tue, 11 Jan 2005 20:10:05 +0100, Maarten <maarten@ultratux.net> wrote:
> On Tuesday 11 January 2005 19:47, Derek Piper wrote:
>
> > My question is this, is it possible (and even a good idea) to use all
> > 4 hard drives as members of a 4 x 60GB RAID5 array by leaving 20GB of
> > the 80GB drive as a non-raided partition? I'll be using a Promise
> > Ultra TX2/100 controller.
>
> That's perfectly okay.

Thank you, good to know. My plan kinda hinges on that. :)

>
> > i.e. RAID5 = 180GB usable size,wherease RAID6 = 120GB .. am I correct
> > in my thinking?
>
> Yes.

Thanks, I've only just started looking at what RAID6 offers. For
bigger arrays than mine I think.

> > I know many of you use far larger hard drives, I'm just trying to use
> > the components I already had spare from a number of machines and
> > reorganize to a RAID-backed fileserver.
>
> My first raid was a raid-0 from two 4.5 GB scsi disks...
> My first raid at home was on 4x40GB drives, raid5.
>
> > The machine is a dual pentium-pro 200 (320MB RAM) .. would that be a
> > dumb idea to use RAID5 on it because of the parity calculations
> > needed?
>
> That raid-5 array above ran on a K6-300...  may not be fast but you can almost
> be sure that a 100Mbit ethernet is still slower...

Okay, that's good to hear.. thank you :)

> > Further to that, would it be a smarter idea to use RAID1 on all 4 of
> > some small partition(s) at the start of the disks to house
> > boot/root/usr partitions, and only RAID5 on a larger 'data' area of
> > the drive that is more likely to be read than written to?
>
> YES !  If only because it is very hard to boot from raid-5.
> But you could use that spare 20GB for the OS, couldn't you ?
> Unless you want that redundant too.

Ah, that's a good point about booting. Yea, I'd want to be able to get
back running as simply as possible if a disk failure happens.

The extra 20GB I was thinking I could use for something un-important,
like downloads, temporary 'scratch' space etc. Maybe squid cache.

Thanks for getting back with me so quick. Nice to bounce ideas off people.

Derek

--
Derek Piper - derek.piper@gmail.com
http://doofer.org/

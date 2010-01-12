From: Tim Bock <jtbock@daylight.com>
Subject: Re: raid failure question
Date: Tue, 12 Jan 2010 08:07:40 -0700
Message-ID: <1263308860.8962.229.camel@kije>
References: <1263232840.8962.193.camel@kije>
	 <20100111205332.GA24486@cthulhu.home.robinhill.me.uk>
	 <4B4C662F.3010305@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B4C662F.3010305@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First, thanks for the replies.

The problem is that the drive is not marked as failed by the array, but
"something" happens to the drive which drives the load avg to 12+ and
makes the array (and server) largely unusable.  It is as if the {OS,
array} is waiting for something to time out.  The first time this
happened, there was a "Medium Error" in the log at 2 am (during an rsync
backup), and I didn't even know about the problem until 7 am.  So it
should have had plenty of time to "time out" if it was going to, yes?
There was a logged error the second time as well, but I didn't save it
before the logs rotated out.

Similarly, upon reboot during this problem, something was happening with
the disk which prevented the system from coming up when the array was in
the fstab.  When I took it out of the fstab, system came up and I was
able to manually fail the disk, the array automatically rebuilt with the
hot spare, birds started singing, and life went on.

I've replaced the offending disk, but as this has happened twice (with
two different disks in a 4+1 array), I'm just trying to figure out what
is going on...and more importantly, how I can fix it, if possible.  As
Thomas implies, the joy of a hot spare is that a disk failure is
hopefully transparent to your users...

Thanks for your time,
Tim
 
On Tue, 2010-01-12 at 06:08 -0600, Roger Heflin wrote:
> Robin Hill wrote:
> > On Mon Jan 11, 2010 at 11:00:40AM -0700, Tim Bock wrote:
> > 
> >> Hello,
> >>
> >> Excluding the obvious multi-disk or bus failures, can anyone describe
> >> what type of disk failure a raid cannot detect/recover from?
> >>
> >> I have had two disk failures over the last three months, and in spite of
> >> having a hot spare, manual intervention was required each time to make
> >> the raid usable again.  I'm just not sure if I'm not setting something
> >> up right, or if there is some other issue.
> >>
> >> Thanks for any comments or suggestions.
> >>
> > Any failure where the disk doesn't actually return an error (within a
> > reasonable time).  For example, consumer grade disks often have very
> > long retry times - this can mean the array in unusable for a long time
> > until the disk eventually fails the read.
> > 
> > If the disk actually returns an error then, AFAIK, the RAID array should
> > always be able to recover from it.
> > 
> > Cheers,
> >     Robin
> 
> The OS will time the disk out at about 30 seconds if it does not 
> answer, and then the disk gets treated as "BAD".
> 
> On fiber channel this is a fairly common type of failure, if something 
> fails in the fabric such that the disk can no longer talk to the machine.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


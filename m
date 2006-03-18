From: "Ewan Grantham" <ewan.grantham@gmail.com>
Subject: Re: ex2fsck showing MANY errors on degraded RAID - out of luck?
Date: Sat, 18 Mar 2006 11:05:38 -0600
Message-ID: <6d5bedd80603180905h452002cau5d5663188ae1c527@mail.gmail.com>
References: <6d5bedd80603180741s6b19ed53x929093fdac803d99@mail.gmail.com>
	 <Pine.LNX.4.56.0603181604390.31603@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0603181604390.31603@lion.drogon.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Well, we'll see what we end up with. I'm still not sure why I had such
a mess in the first place since it was a single disk failure, and I
caught it fairly quickly. Only thing I can figure is that it had
something to do with the fact that failure happened during an e2fsck
run in the first place.

Thanks for at least telling me an option to take the drudgery out of
it. Was driving me crazy having to hit enter so many times :-)

On 3/18/06, Gordon Henderson <gordon@drogon.net> wrote:
> On Sat, 18 Mar 2006, Ewan Grantham wrote:
>
> > OK, managed to use assemble force to get the five remaining drives of
> > the array up in degraded mode. But running ex2fsck (I had an ext3 fs
> > on the RAID) is revealing a number of bad dtimes and invalid blocks.
> > Trying to run ex2fsck with the -p option doesn't work for long, and
> > having to hit enter after each line is testing my patience.
> >
> > So, am I likely to have any good data by the time I finish anyway, or
> > am I wasting my time? Any quicker way to cleanup the filesystem to
> > find out?
>
> You might be able to mount it read-only and copy the data off, but who
> knows what you might actually be copying.
>
> There is a -y option to fsck which assumes a yes answer to all the
> questions. It's never a good option, but sometimes the only option unless
> you have an intimate knowledge of ext2/3 and an infinite amount of time to
> sort it out.
>
> I had to do this recently to a trashed 4-disk Raid-5 array - it had been
> one disk down for some time and despite my telling them that they were
> living on borrowed time, they didn't do anything about it, until a 2nd
> disk died.  I managed to make it start in degraded mode, then fsck'd with
> the -y option. 3 times. The array showed less than half the data it
> originally had, but it seemed to keep them happy.... (and I saw some
> messages from fsck I'd never seen before!) Fortunately they had a partial
> backup that was only a day or 2 old, so they got most of the stuff back,
> but I really suspect some of those file have holes in them and blocks of
> bogus data.
>
> A really quick way to clean up the filessystem is by use of the mkfs
> command ;-)
>
> Good luck!
>
> Gordon
>

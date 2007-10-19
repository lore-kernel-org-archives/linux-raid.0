From: "Mike Snitzer" <snitzer@gmail.com>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Fri, 19 Oct 2007 01:15:32 -0400
Message-ID: <170fa0d20710182215v19756cabp30ddddeb7a7668a2@mail.gmail.com>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	 <18198.62670.605246.270516@notabene.brown>
	 <170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
	 <18200.6319.487833.714355@notabene.brown>
	 <170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <170fa0d20710182152i4763c347r704c9d939e0a4638@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/19/07, Mike Snitzer <snitzer@gmail.com> wrote:
> On 10/18/07, Neil Brown <neilb@suse.de> wrote:
> >
> > Sorry, I wasn't paying close enough attention and missed the obvious.
> > .....
> >
> > On Thursday October 18, snitzer@gmail.com wrote:
> > > On 10/18/07, Neil Brown <neilb@suse.de> wrote:
> > > > On Wednesday October 17, snitzer@gmail.com wrote:
> > > > > mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
> > > > > use of space for bitmaps in version1 metadata"
> > > > > (199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
> > > > > offending change.  Using 1.2 metdata works.
> > > > >
> > > > > I get the following using the tip of the mdadm git repo or any other
> > > > > version of mdadm 2.6.x:
> > > > >
> > > > > # mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
> > > > > -n 2 /dev/sdf --write-mostly /dev/nbd2
> > > > > mdadm: /dev/sdf appears to be part of a raid array:
> > > > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > > > mdadm: /dev/nbd2 appears to be part of a raid array:
> > > > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > > > mdadm: RUN_ARRAY failed: Input/output error
> >                                ^^^^^^^^^^^^^^^^^^
> >
> > This means there was an IO error.  i.e. there is a block on the device
> > that cannot be read from.
> > It worked with earlier version of mdadm because they used a much
> > smaller bitmap.  With the patch you mention in place, mdadm tries
> > harder to find a good location and good size for a bitmap and to
> > make sure that space is available.
> > The important fact is that the bitmap ends up at a different
> > location.
> >
> > You have a bad block at that location, it would seem.
>
> I'm a bit skeptical of that being the case considering I get this
> error on _any_ pair of disks I try in an environment where I'm
> mirroring across servers that each have access to 8 of these disks.
> Each of the 8 mirrors consists of a local member and a remote (nbd)
> member.  I can't see all 16 disks having the very same bad block(s) at
> the end of the disk ;)
>
> I feels to me like the calculation that you're making isn't leaving
> adequate room for the 128K bitmap without hitting the superblock...
> but I don't have hard proof yet ;)

To further test this I used 2 local sparse 732456960K loopback devices
and attempted to create the raid1 in the same manner.  It failed in
exactly the same way.  This should cast further doubt on the bad block
theory no?

I'm using a stock 2.6.19.7 that I then backported various MD fixes to
from 2.6.20 -> 2.6.23...  this kernel has worked great until I
attempted v1.0 sb w/ bitmap=internal using mdadm 2.6.x.

But would you like me to try a stock 2.6.22 or 2.6.23 kernel?

Mike

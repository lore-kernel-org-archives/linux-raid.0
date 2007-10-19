From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm 2.6.x regression, fails creation of raid1 w/ v1.0 sb and internal bitmap
Date: Fri, 19 Oct 2007 12:38:39 +1000
Message-ID: <18200.6319.487833.714355@notabene.brown>
References: <170fa0d20710170837g1b0cd549w3b7fe8e663a01b7e@mail.gmail.com>
	<18198.62670.605246.270516@notabene.brown>
	<170fa0d20710180510o1edff608p22953fa712e217f6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Snitzer on Thursday October 18
Sender: linux-raid-owner@vger.kernel.org
To: Mike Snitzer <snitzer@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Sorry, I wasn't paying close enough attention and missed the obvious.
.....

On Thursday October 18, snitzer@gmail.com wrote:
> On 10/18/07, Neil Brown <neilb@suse.de> wrote:
> > On Wednesday October 17, snitzer@gmail.com wrote:
> > > mdadm 2.4.1 through 2.5.6 works. mdadm-2.6's "Improve allocation and
> > > use of space for bitmaps in version1 metadata"
> > > (199171a297a87d7696b6b8c07ee520363f4603c1) would seem like the
> > > offending change.  Using 1.2 metdata works.
> > >
> > > I get the following using the tip of the mdadm git repo or any other
> > > version of mdadm 2.6.x:
> > >
> > > # mdadm --create /dev/md2 --run -l 1 --metadata=1.0 --bitmap=internal
> > > -n 2 /dev/sdf --write-mostly /dev/nbd2
> > > mdadm: /dev/sdf appears to be part of a raid array:
> > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > mdadm: /dev/nbd2 appears to be part of a raid array:
> > >     level=raid1 devices=2 ctime=Wed Oct 17 10:17:31 2007
> > > mdadm: RUN_ARRAY failed: Input/output error
                               ^^^^^^^^^^^^^^^^^^

This means there was an IO error.  i.e. there is a block on the device
that cannot be read from.
It worked with earlier version of mdadm because they used a much
smaller bitmap.  With the patch you mention in place, mdadm tries
harder to find a good location and good size for a bitmap and to
make sure that space is available.
The important fact is that the bitmap ends up at a different
location. 

You have a bad block at that location, it would seem.

I would have expected an error in the kernel logs about the read error
though - that is strange.

What do
  mdadm -E
and
  mdadm -X

on each device say?

> > > mdadm: stopped /dev/md2
> > >
> > > kernel log shows:
> > > md2: bitmap initialized from disk: read 22/22 pages, set 715290 bits, status: 0
> > > created bitmap (350 pages) for device md2
> > > md2: failed to create bitmap (-5)
> >
> > Could you please tell me the exact size of your device?  Then should
> > be able to reproduce it and test a fix.
> >
> > (It works for a 734003201K device).
> 
> 732456960K, it is fairly surprising that such a relatively small
> difference in size would prevent it from working...

There was a case once where the calculation was wrong, and rounding
sometimes left enough space and sometimes didn't.  That is why I
wanted to know the exact size.  I turns out it wasn't relevant in this
case.

NeilBrown

From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Mon, 14 Jun 2010 09:05:20 +1000
Message-ID: <20100614090520.2ae5a961@notabene.brown>
References: <4C1128C2.4020105@meetinghouse.net>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
	<20100611145019.6f1a5e7d@notabene.brown>
	<201006131628.35037.bernd.schubert@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201006131628.35037.bernd.schubert@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Jun 2010 16:28:34 +0200
Bernd Schubert <bernd.schubert@fastmail.fm> wrote:

> On Friday 11 June 2010, Neil Brown wrote:
> > On Fri, 11 Jun 2010 00:31:57 -0400
> > 
> > "Graham Mitchell" <gmitch@woodlea.com> wrote:
> > > Can you do this on a live array, or can it only be done (as the docs seem
> > > to suggest), with the create, build and grow options?
> > 
> > As 'grow' can (and must) be used on a live array you're question doesn't
> > exactly make sense.
> > Yes: it can be done on a live array.
> 
> While I have done this myself a couple of times, I still do not understand 
> where it takes the disk space for the bitmap journal from? Is this space mdadm 
> reserved for this purpose?

Sort-of.
It uses space that the alignment requirements of the metadata assure us is
otherwise unused.
For v0.90, that is limited to 60K.  For 1.x it is 3K.
With recent kernels it is possible for mdadm to tell the kernel where to put
the bitmap (rather than the kernel *knowing*) so mdadm could use other space
that was reserved when the array was created, but I haven't implemented that
in mdadm yet.

NeilBrown

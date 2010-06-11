From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 14:50:19 +1000
Message-ID: <20100611145019.6f1a5e7d@notabene.brown>
References: <4C1128C2.4020105@meetinghouse.net>
	<20100611005743.43664e5b@natsu>
	<4C11578B.8010202@meetinghouse.net>
	<20100611034108.6a2cdbc4@natsu>
	<4C1169CB.1030903@meetinghouse.net>
	<20100611085112.5f33b06f@natsu>
	<001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001501cb091f$07ac4e40$1704eac0$@woodlea.com>
Sender: linux-raid-owner@vger.kernel.org
To: Graham Mitchell <gmitch@woodlea.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 11 Jun 2010 00:31:57 -0400
"Graham Mitchell" <gmitch@woodlea.com> wrote:

> Can you do this on a live array, or can it only be done (as the docs seem to
> suggest), with the create, build and grow options?
> 

As 'grow' can (and must) be used on a live array you're question doesn't
exactly make sense.
Yes: it can be done on a live array.

NeilBrown

> 
> G
> 
> > -----Original Message-----
> > From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> > owner@vger.kernel.org] On Behalf Of Roman Mamedov
> > Sent: Thursday, June 10, 2010 10:51 PM
> > To: Miles Fidelman
> > Cc: linux-raid@vger.kernel.org
> > Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
> > 
> > On Thu, 10 Jun 2010 18:40:11 -0400
> > Miles Fidelman <mfidelman@meetinghouse.net> wrote:
> > 
> > > Yes... went with internal.
> > >
> > > I'll keep an eye on write performance.  Do you happen to know, off
> > > hand, a magic incantation to change the bitmap-chunk size? (Do I need
> > > to remove the bitmap I just set up and reinstall one with the larger
> > > chunk
> > > size?)
> > 
> > Remove (--bitmap=none) then add again with new --bitmap-chunk.
> > 
> > --
> > With respect,
> > Roman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


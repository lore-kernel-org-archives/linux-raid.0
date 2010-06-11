From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: RAID6 and crashes (reporting back re. --bitmap)
Date: Fri, 11 Jun 2010 08:13:48 -0400
Message-ID: <003d01cb095f$8d006eb0$a7014c10$@woodlea.com>
References: <4C1128C2.4020105@meetinghouse.net>	<20100611005743.43664e5b@natsu>	<4C11578B.8010202@meetinghouse.net>	<20100611034108.6a2cdbc4@natsu>	<4C1169CB.1030903@meetinghouse.net>	<20100611085112.5f33b06f@natsu>	<001501cb091f$07ac4e40$1704eac0$@woodlea.com> <20100611104134.2d3d94eb@natsu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100611104134.2d3d94eb@natsu>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to everyone for replying, it is indeed a simple operation and
completes immediately. I was just worried since I equate grow more to an
array reshape than to a management/tune option. I guess it's just my
paranoia showing thru... :)


G

> -----Original Message-----
> From: Roman Mamedov [mailto:roman@rm.pp.ru]
> Sent: Friday, June 11, 2010 12:42 AM
> To: Graham Mitchell
> Cc: linux-raid@vger.kernel.org
> Subject: Re: RAID6 and crashes (reporting back re. --bitmap)
> 
> On Fri, 11 Jun 2010 00:31:57 -0400
> "Graham Mitchell" <gmitch@woodlea.com> wrote:
> 
> > Can you do this on a live array, or can it only be done (as the docs
> > seem to suggest), with the create, build and grow options?
> 
> It is a variant of the grow operation, but it can be done on a live array,
even
> mounted, and completes instantly:
> 
> mdadm --grow /dev/md0 --bitmap=internal --bitmap-chunk=131072
> 
> In my experience, removing the bitmap (setting it to none) may
occasionally
> fail (probably when the array has a lot of outstanding write requests),
but
> just try again when it's a bit quieter, and it'll work.
> 
> --
> With respect,
> Roman


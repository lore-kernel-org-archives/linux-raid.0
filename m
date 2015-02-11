From: Phil Turmel <philip@turmel.org>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Tue, 10 Feb 2015 21:14:21 -0500
Message-ID: <54DABAFD.6070101@turmel.org>
References: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com>	<54D9B4AD.8010204@websitemanagers.com.au>	<54DA0CDA.2010800@turmel.org> <CAP7a4USu+650JJh9yX-WUU6eyxOGowa5r72W8JABCJpLnO=gtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAP7a4USu+650JJh9yX-WUU6eyxOGowa5r72W8JABCJpLnO=gtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kyle Logue <teque5@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Kyle,

{ Convention on kernel.org lists is reply-to-all, trim replies, and
either bottom post or interleave }

On 02/10/2015 04:50 PM, Kyle Logue wrote:
> Phil:
> 
> Thanks for your detailed response. That link does seem to describe my
> problem and I do understand that desktop grade drives are sub-optimal.
> It was many years ago when I first set up this array on my home
> theater pc.  Until now I had no idea about the cron job - I'll make
> sure to implement that. I am preparing to move to 6 tb disks sometime
> soon and i'll definitely go enterprise this time.
> 
> Regarding the drive timeout: I understand that I need to increase it
> from 30 seconds to something larger (2+ min) but am unaware how to do
> this. Is it a kernel variable? I'll keep googling but this seems like
> it's whats going to save me.
> 
> tl;dr: How do I change the drive timeout?

Put something like this in /etc/rc.local or wherever your distro suggests:

for x in /sys/block/sd[a-f]/device/timeout ; do
  echo 180 > $x
done

Where the [a-f] is adjusted to suit your needs, and only for non-raid
non-scterc drives.

Phil

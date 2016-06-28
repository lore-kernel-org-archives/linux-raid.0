From: keld@keldix.com
Subject: Re: RAID 10 / 2 Devices Layout question
Date: Tue, 28 Jun 2016 14:40:17 +0200
Message-ID: <20160628124017.GA7953@www5.open-std.org>
References: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com> <5770120D.9050809@turmel.org> <20160628142502.7e69983d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160628142502.7e69983d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Phil Turmel <philip@turmel.org>, Paul Roland <paulrolandw@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 28, 2016 at 02:25:02PM +0500, Roman Mamedov wrote:
> On Sun, 26 Jun 2016 13:34:05 -0400
> Phil Turmel <philip@turmel.org> wrote:
> 
> > On 06/26/2016 01:20 PM, Paul Roland wrote:
> > 
> > > I have two SSDs, and I would like to use md/raid10 (2devices) for
> > > performance reasons.
> > 
> > Ok, that's reasonable.
> 
> Maybe I'm missing something, but how is a RAID10 of just two devices is
> considered reasonable without any questions or explanation? What is the actual
> layout that is expected here, and what benefits (or even differences) does it
> have compared to RAID0? I thought you need at least 3 devices (and h/w RAID
> controllers might even require 4) for RAID10 to start making sense.

I think your understanding is a common misunderstanding of the Linux raid10.
There is more on this subject on:

https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

In short: yes Linux MD RAID10 is a different beast than standard RAID 1+0,
It can work with improved performance with just 2 disks, and even perform
like RAID0 for the Linux MD RAID10 far layout

See more on https://raid.wiki.kernel.org/index.php/Performance

best regards
Keld

From: Redeeman <redeeman@metanurb.dk>
Subject: Re: Handling mismatch_cnt
Date: Sun, 26 Jul 2009 06:22:34 +0200
Message-ID: <1248582154.32584.68.camel@localhost>
References: <f1d2d9ca0907240901y60c8d8bdlfb9938de9b374561@mail.gmail.com>
	 <4A6A4C73.2070000@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A6A4C73.2070000@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2009-07-25 at 10:06 +1000, Eyal Lebedinsky wrote:
> Thanassis Tsiodras wrote:
> > Handling mismatch_cnt<>0
> [trim]
> > Am I missing something? Is MD RAID1 in fact better than what I
> > have understood? Is there an answer that would allow me to use it
>  > without the uncertainty of "russian-roulette" fixes when the
>  > inevitable mismatch_cnt<>0 occurs?
> 
> RAID1 will ensure your data is not lost when one disk completely fails.
> This is a rather common mode of failure. You are protected against this
> catastrophic event but not against (minor? damage of a) sector failure.
> I use RAID for just this benefit.
> 
> Unlike RAID5, RAID6 should be able to do better than a random correction
> (does it?).
Nope
> 
> RAID1 with more than two disks should also do better with voting
> (does it?).
Nope.

Theres a previous thread i started about this, with more details..
> 
> > In other words, is there anything a Linux guy can do besides wait
> > for btrfs or trust a FUSE version of ZFS?
> > 
> > Thanks for any feedback,
> > Thanassis.
> 


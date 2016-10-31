From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Panicked and deleted superblock
Date: Tue, 1 Nov 2016 00:03:55 +0100
Message-ID: <20161031230355.GA1825@metamorpher.de>
References: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
 <20161030194326.GA6727@metamorpher.de>
 <7f1dd791-ed1c-5db6-555d-ed377995420e@gmx.net>
 <20161030211103.GA7196@metamorpher.de>
 <9d0bf300-73e8-9109-c630-03f392fc820e@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9d0bf300-73e8-9109-c630-03f392fc820e@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Hoffmann <Hoffmann.P@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Oct 31, 2016 at 11:36:39PM +0100, Peter Hoffmann wrote:
> I'm a bit confused using the overlay function.

There really needs to be a standard utility for this.

Well, the "overlay manipulation functions" on that wiki page come close. 
You can paste/source those once in the shell and use them like commands. 
You need two sets of overlays, so you'd also have to create two sets of 
those functions (using different mapper names).

You should verify that the overlay itself is good by comparing the size 
(blockdev --getsize64 /dev/thing /dev/mapper/overlaything) as well as 
the content (cmp /dev/thing /dev/mapper/thething, no output if there is 
no difference, you can ctrl-c).

>     mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0

This is wrong, or rather, when re-creating RAID you must be much more 
verbose with the options. http://unix.stackexchange.com/a/131927/30851

> Both ways should look exactly the same at least for the first 1200M,
> shouldn't they?

If you deliberately created smaller overlays, mdadm uses different 
defaults depending on device size too. If you expect it to be identical 
also check that --examine (data offset etc.) looks identical.

There's no point in using overlays that are not identical to the 
devices they're overlaying.

Regards
Andreas Klauer

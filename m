From: Gordon Henderson <gordon@drogon.net>
Subject: Re: raid5 - failed disks
Date: Fri, 1 Apr 2005 12:05:09 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0504011110520.6256@lion.drogon.net>
References: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1050401015858.14428C-100000@Maggie.Linux-Consulting.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 1 Apr 2005, Alvin Oga wrote:

>
> hi ya raiders ..
>
> we(they) have 14x 72GB scsi disks config'd as raid5,
> ( no hot spare .. )
>
> - if 1 disk dies, no problem ... ez to recover
>
> - my dumb question is,
> 	- if 2 disks dies at the same time, i
> 	assume the entire raid5 is basically hosed
> 	if it won't reassemble and resync from
> 	the point where it last was before the crash ??

It's possible to recover it - IF one of the failed disks hasn't really
failed. ie. no genuine bad sectors or lost data.

I had a 6-year old 8-disk array a while back that had been retired after 5
years of trouble-free operation, but was subsequently pressed into use on
a different server - it featured some dodgyness about it - it would
occasionally fail a disk because the sun was in the wrong place, or the
moon was full, or something - never got to the bottom of it - the disks
would always surface check OK afterwards - they may have been remapping
sectors, but I never observed data or file system corruption, and I did
occasionally get a 2-disk failure, but I was always able to resurect it
using the last disk to fail as part of the array. Fortunately the stop-gap
it was filling has been replaced by something new now!

> 	- i assume that the similar 2 disk failure
> 	also applies to hw raid controllrs, but it'd
> 	be more dependent upon the raid controller's
> 	firmware for it's ability to recover from
> 	2 of 14 simultaneous disk failures
> 	( lets say the dell powervault 2205 series )
>
> - i think 4x 300GB ide disks is better ( less likely to fail ?? )

Who knows. With the H/W solution, you really are at the mercy of the
hardware supporting software. Less disks might be less risk of failure
though. Some modern disks don't seem to be having a good press recently
though. (eg. Maxtor) I've switched to RAID-6 now, even for a 4-disk system
I built recently. Disks are cheap enough now. (Unless you have to buy them
from Dull or Stun!!!)

> 	and yes it has already crashed twice with
> 	2 different disks running at 78F at nights
> 	and weekends when the air conditioning is off

Um - thats only 25C. Well inside the limits I'd have thought. I have some
disks (Maxtors!) that are hapilly running at 50C (Although for how much
longer, I don't know, but they have survived 15 months so-far, but they
are in a fairly stable temperature environment - at the top of a lift
shaft!)

By comparison, I have another box (same config & age) thats effectively
outside and the temperature cycles are very visible and it's just had a
disk fail )-:

Gordon

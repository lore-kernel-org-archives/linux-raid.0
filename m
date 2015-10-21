From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 21 Oct 2015 17:17:56 +0100
Message-ID: <5627BAB4.7010402@youngman.org.uk>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562660EE.9020504@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: andras@tantosonline.com, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/10/15 16:42, Phil Turmel wrote:
> Don't.  You have another problem: green & desktop drives in a raid
> array.  They aren't built for it and will give you grief of one form or
> another.  Anyways, their problem with timeout mismatch can be worked
> around with long driver timeouts.  Before you do anything else, you
> *MUST* run this command:
> 
> for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done
> 
> (Arrange for this to happen on every boot, and keep doing it manually
> until your boot scripts are fixed.)

tl;dr summary ...

Desktop drives are spec'd as being okay with one soft error per 10TB
read - that's where a read fails, you try again, and everything's okay.

A resync will scan the array from start to finish - if you have 10TB's
worth of disk, you MUST be prepared to handle these errors.

By default, mdadm will assume a disk is faulty and kick it after about
10secs, but a desktop drive will hang for maybe several minutes before
reporting a problem.

In other words, your drives can meet manufacturer's specs, but, with
default settings, your array will never be able to rebuild after a
problem! (Note that many people will say "I've never had a problem", but
most drives are better than spec. You just don't want to be the unlucky
one ...)


Not that I have any (yet), but I'd second the recommendation for WD
Reds. I've got Seagate Barracudas (not raid-compliant), and the Reds are
not much more expensive, and are also the only drives I've found that
support the raid features - mostly that by default they will fail and
report a problem very quickly. (Plus they're spec'd at reading about
40TB per soft error :-)

Cheers,
Wol



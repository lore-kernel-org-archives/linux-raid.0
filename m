From: Phil Turmel <philip@turmel.org>
Subject: Re: raid 5 crashed
Date: Wed, 1 Jun 2016 13:28:22 -0400
Message-ID: <574F1B36.4030401@turmel.org>
References: <CADzS=aoMEaFv5TPYUpYBnLhOpF+u9dtG6aa=JZ5gd=Qv1=OrMQ@mail.gmail.com>
 <20160511131524.GA11811@cthulhu.home.robinhill.me.uk>
 <CADzS=aoKqrG0QV1-Fe5g_b=n11gmbnerTyZ+eY4rBtJieNz_2w@mail.gmail.com>
 <CADzS=apUB=XZRmCWjpOHuRgvk7EhqrbpRQhHQ+MHf8NHyGCU0w@mail.gmail.com>
 <CADzS=are4kkK5Lpm2WTAnqhE1D3XuMFwTKbO8_FzDbGtmqu2Dw@mail.gmail.com>
 <574C8EB9.3070706@youngman.org.uk>
 <CADzS=arbwpZg=VRcaiLaMJrLzr8pOjFTC-EwUtSpC1A3SmaTcQ@mail.gmail.com>
 <574D958F.8060209@turmel.org> <574DDCBD.40801@youngman.org.uk>
 <95079572-f319-ca57-a3e9-e8d00ef40248@fnarfbargle.com>
 <574F0258.5000108@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <574F0258.5000108@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, Brad Campbell <lists2009@fnarfbargle.com>, bobzer <bobzer@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

On 06/01/2016 11:42 AM, Wols Lists wrote:

> Okay - so would this be better (a lot slower, possibly, but safe ...)
> 
> Use dd - so it DOES bomb on error! - and only replace the drive once
> you've got a clean read off it. With 2TB drives, that should work so
> long as they're not faulty. And if it's - JUST - a timeout issue,
> this'll work fine?

If there's errors, you'll never get a clean read.  (Short of the moon
and stars aligning for a near-miracle.)  ddrescue and similar replace
those errors with zeros to successfully retrieve less than 100% of your
data.

The whole point of keeping it in the array is to get the correct data
from the array's redundancy wherever the disk has unfixed read errors.
And with correct timeouts, to *FIX* that read error.  Please read *all*
of the links I posted on why and how this is.

Side note:  In these situations, you should *not* use overlays, as that
prevents the *FIX* part from happening.

Temporarily setting the timeouts for non-raid drives is a one-liner:

for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

Phil


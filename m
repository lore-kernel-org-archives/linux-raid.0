From: Phil Turmel <philip@turmel.org>
Subject: Re: Advice requested re: hard drive setup for RAID arrays
Date: Wed, 4 Nov 2015 15:09:25 -0500
Message-ID: <563A65F5.4090301@turmel.org>
References: <CAPpdf595q7qsU-3e4rm_9qKKdoOzZi6mVTtrr=Hczqk=UsNf5Q@mail.gmail.com>
 <563A0462.9000200@turmel.org>
 <CACsGCyQGChMLXfQ3G-DN+Y7mh9w7wFkmQ9274VFKBzSoOgaoUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CACsGCyQGChMLXfQ3G-DN+Y7mh9w7wFkmQ9274VFKBzSoOgaoUQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Edward Kuns <eddie.kuns@gmail.com>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Edward,

On 11/04/2015 02:36 PM, Edward Kuns wrote:

> Is there a reasonable way of finding out if a shorter setting is 
> appropriate for any specific drive?

When I first learned all this (the hard way) with Seagate drives, 120
seconds was enough.  You'll find that in old archives, 2011-ish.  I
don't remember who, but someone had a drive that took longer and
suggested 180 seconds.

> Or would you say in general it's not worth the effort of trying to
> find out?

Not worth the effort.  It's a work-around for unsuitable devices until
such time as you can retire them.

> Would you expect this behavior to be any different for an SSD?

I'd expect an SSD's worst case error recovery to be much shorter --
there's no positioning to wait for, nor any mechanical effects that'll
make retrys meaningful.

Phil

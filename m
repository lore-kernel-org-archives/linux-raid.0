From: "Andre' Breiler" <andre.breiler@null-mx.org>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sun, 2 Feb 2003 10:41:57 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.33.0302021036530.535-100000@pegasus.teamwerk.com>
References: <Pine.LNX.4.44.0302011449420.12785-100000@redhat1.mmaero.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0302011449420.12785-100000@redhat1.mmaero.com>
To: jlewis@lewis.org
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

On Sat, 1 Feb 2003 jlewis@lewis.org wrote:

> On Sat, 1 Feb 2003, Mikael Abrahamsson wrote:
>
> > You should try to fit another powersupply to drive the disks. ATX
> > powersupplies can be made powermanently on by shorting ping 14 and 15 (I
> > think it was, there is a FAQ page out there I found on when I was looking
> > a month back). If you don't want to do this, get yourself an AT power
> > supply.
>
> So can this trick (connecting 14 to 15) be used as a work-around for brain
> damaged motherboards that won't power-on after power-loss to keep a system
> always on?

No, this won't work in most cases (as the board doesn't know that it
should start up).
What I usally do is an really small mono flop + trigger combination which
waits for 10s to switch an relais (you can draw power from the standby
power) which simulates the atx power switch. Note, that for some boards
to function correctly it's needed to release the relais after 5V are
present on the normal power.

Bye Andre'
-- 


From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: 3ware 9650 tips
Date: Sat, 14 Jul 2007 09:11:58 -0700 (PDT)
Message-ID: <164595.17925.qm@web60020.mail.yahoo.com>
References: <Pine.LNX.4.64.0707141100230.29164@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0707141100230.29164@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Joshua Baker-LePain <jlb17@duke.edu>, linux-ide-arrays@lists.math.uh.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- Mikael Abrahamsson <swmike@swm.pp.se> wrote:

> Take your 3ware HW-raid, do a dd (read or write) to
> the device and see it 
> being very quick (because it can fit all the data
> into its cache as it 
> either reads or writes), then put a filesystem on it
> and do writes there, 
> especially journaled writes, and see write speed go
> down to 1/10 or so.

How does non-cached performance tend to compare?

Andrew





       
____________________________________________________________________________________
Looking for a deal? Find great prices on flights and hotels with Yahoo! FareChase.
http://farechase.yahoo.com/

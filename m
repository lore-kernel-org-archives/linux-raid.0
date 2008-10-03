From: Iustin Pop <iusty@k1024.org>
Subject: Re: SATA errors?
Date: Fri, 3 Oct 2008 18:13:11 +0200
Message-ID: <20081003161311.GA15946@teal.hq.k1024.org>
References: <48E34221.1000008@agenda.si> <20081001100833.3253724847@gemini.denx.de> <48E353D5.1060908@agenda.si> <A20315AE59B5C34585629E258D76A97C02180F8B@34093-C3-EVS3.exchange.rackspace.com> <48E36A61.4020903@dgreaves.com> <A20315AE59B5C34585629E258D76A97C021D052A@34093-C3-EVS3.exchange.rackspace.com> <48E3ED4D.6000409@agenda.si> <alpine.DEB.1.10.0810011803180.30506@p34.internal.lan> <48E5EB42.9050106@agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48E5EB42.9050106@agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: Danilo Godec <danilo.godec@agenda.si>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Oct 03, 2008 at 11:52:02AM +0200, Danilo Godec wrote:
> Well, it's been two full days (48+ hours) and no error... I guess
> smartctrl doesn't like WDC drives (or better yet, vise versa).

I don't know about your specifics, but I had multiple (~10) WDC
harddrives running with smartctl/smartd polling them periodically, and
with various controllers (VIA, Promise, 3ware, but not Intel). I didn't
have any issues like this.

Maybe it's a specific interation between the drive and the controller?
Or the driver?

iustin

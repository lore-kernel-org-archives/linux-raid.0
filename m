From: Gordon Henderson <gordon@drogon.net>
Subject: Re: /proc/partitions
Date: Mon, 20 Dec 2004 12:32:32 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0412201229240.4389@lion.drogon.net>
References: <200411210433.iAL4XIN19967@www.watkins-home.com>
 <Pine.LNX.4.61.0411220909180.5652@treant.hhmi.umbc.edu> <41A281AD.8050404@verizon.net>
 <41A301DA.4010303@robinbowes.com> <1101213077.2244.6.camel@south.rosestar.lan>
 <Pine.LNX.4.56.0412201046050.4389@lion.drogon.net> <20041220114939.GA20243@inara.maison.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20041220114939.GA20243@inara.maison.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 20 Dec 2004, KELEMEN Peter wrote:

> * Gordon Henderson (gordon@drogon.net) [20041220 10:50]:
>
> > Is there any plans to make the entries in /proc/partitions
> > return anything sensible for the md devices?
>
> AFACT not.  Current consensus is that md devices don't do I/O,
> they only dispatch I/O to lower layer devices, hence no stats.
> (OTOH, I personally was in a situation at least once when it
> would have been very useful -- regardless of the obvious double
> accounting.)

Ok, Thanks.

> > If not, is there any other way to get some stats on reading &
> > writing each md device?
>
> Parse /proc/mdstat and cook up your own stat counters based on the
> md member devices' stats.

Sure. No real issue, actually graphing the individual disks might be
interesting anyway, and then it ought to be easy to just sum the values.
I'll drop the mrtg stuff back to the list if anyones intersted..

Gordon


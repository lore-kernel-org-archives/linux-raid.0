From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: Correct way to create multiple RAID volumes with hot-spare?
Date: Fri, 25 Aug 2006 12:17:40 -0400
Message-ID: <44EF22A4.73D45C59@maine.edu>
References: <44EB5579.4020200@maine.edu> <Pine.LNX.4.64.0608230634270.15031@p34.internal.lan> <Pine.LNX.4.62.0608230915580.12782@chaos.egr.duke.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Baker-LePain <jlb17@duke.edu>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Joshua Baker-LePain wrote:

> On Wed, 23 Aug 2006 at 6:34am, Justin Piszcz wrote
>
> > On Tue, 22 Aug 2006, Steve Cousins wrote:
> >
> >> As for system information, it is (was) a Dual Opteron with CentOS 4.3 (now
> >> I'm putting FC5 on it as I write) with a 3Ware 8506-12 SATA RAID card that
> >> I am using in JBOD mode so I could do software RAID6.
> >>
> >
> > If you are using SW RAID, there is no 2TB limit.
>
> Ditto for more recent HW RAIDs.  *However*, there are other considerations
> when dealing with >2TiB devices.  E.g. you can't boot from them.
>

You are both correct. When I said "due to issues with volumes greater than 2TB" I
should have indicated that they were more to do with my issues and/or our
environment.  I probably wasn't persistent enough with it.  I now have a DAS box
with >2TB volumes and it is working fine so I should probably start over using no
partions and see how it goes.

Thanks,

Steve



From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: raid5 - which disk failed ?
Date: Mon, 24 Sep 2007 12:11:52 +1200
Message-ID: <46F700C8.8080204@sauce.co.nz>
References: <1314153413.20070924011710@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1314153413.20070924011710@kaneda.iguw.tuwien.ac.at>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Rainer Fuegenstein wrote:

> 
> 1) when md starts a resync of the array, shouldn't one drive be marked
> as down [_UUU] in mdstat instead of reporting it as [UUUU] ? or, the
> other way round: is hde really the faulty drive ? how can I make sure
> I'm removing and replacing the proper drive ?

If it is not already, install smartmontools.

It certainly looks like hde is failing, so a smartctl -a /dev/hde should 
give you some idea. You will find it also gives you the serial number of 
the drive, which will be attached to a label on the drive, allowing you 
to locate it.

Regards,

Richard

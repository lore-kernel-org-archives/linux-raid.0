From: Daniel Browning <db@kavod.com>
Subject: Re: WD "RED" drives - are they any good for mdadm?
Date: Fri, 8 Feb 2013 15:05:33 -0800
Message-ID: <201302081505.33831.db@kavod.com>
References: <50CF2112.1090406@gmail.com> <5115727E.9050601@tmr.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5115727E.9050601@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: maurice <mhilarius@gmail.com>, Drew <drew.kay@gmail.com>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

On Friday 08 February 2013 1:47:42 pm Bill Davidsen wrote:
> maurice wrote:
> > Thinking about trying some WD "RED" drives for a build.
> > Model # WD20EFRX
> >
> > Does anyone have any experience with these they would care to share?

I've bought 8 of them over the last 6 months. One was DOA. Right now they're 
all in a linux md raid6 (LSI 9220-8i HBA) and working great. The reason I 
selected this model is price per GB, TLER, and warranty.

> But the actual seek time, rpm and such, didn't pop up in the few places
> which I checked.

This is one that I read before buying:

http://www.storagereview.com/western_digital_red_nas_hard_drive_review_wd30efrx

On Friday 08 February 2013 2:31:24 pm Drew wrote:
> I personally have used a 4 pack of these hung off a LSI 9204 raid
> controller and performance is okay but not spectacular.

Agreed. I only get about 145 MB/s seq r/w on the outer edge of the spindle and 
I'm guessing it will probably be around 80 MB/s on the inner edge. Definitely 
not 15K enterprise drives. On the 8-disk raid6 I get about 130 MB/s rebuild, 
1000 MB/s seq read.

--
DB

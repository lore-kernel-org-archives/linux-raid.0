From: Hermann Himmelbauer <dusty@strike.wu-wien.ac.at>
Subject: Re: Antwort: Re: Swap on RAID1?
Date: Tue, 14 Oct 2003 12:31:29 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200310141231.29251.dusty@strike.wu-wien.ac.at>
References: <OFE364D22E.C14CB4FA-ONC1256DBF.00302B9C@pta.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <OFE364D22E.C14CB4FA-ONC1256DBF.00302B9C@pta.de>
Content-Disposition: inline
To: alexander.weber@pta.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 14 October 2003 10:50, alexander.weber@pta.de wrote:
> Hermann Himmelbauer wrote:
> > But what happens if a disk fails and the swap is on this disk? I assume
>
> Linux
>
> > would crash? Wouldn't a swap on a RAID prevent such a crash?
>
> Yes and yes. One other possible alternative would be to fork out the
> money for more RAM rather than a second disk for swap. And just don't
> use swap, if you're worried about swap crashing the system...and
> performance will be much better, too.
>
> <snip>
>
> And how about swap-partitions on both disks? So on disk crash, one swap
> partition would survive.
> This works, won't it?

AFAIK if you create 2 swap devices on 2 disks, they are used similar to disk 
striping (RAID0). This speeds the swap up but if one disk dies a part of your 
swap is concerned. If anything important is swapped out on this swap, I 
assume the machine will crash.

		Best Regards,
		Hermann 

-- 
x1@aon.at
GPG key ID: 299893C7 (on keyservers)
FP: 0124 2584 8809 EF2A DBF9  4902 64B4 D16B 2998 93C7


From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Tue, 6 Feb 2018 14:46:05 -0800
Message-ID: <20180206224605.jhw22hpvehe2flt4@merlins.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <d764a824-fe3e-583a-10ef-040bc32dc78e@websitemanagers.com.au>
 <20180206220225.GE9565@merlins.org>
 <CAAMCDeeFVY_NVnzdZYumyxJ_aUTy9_gybhFDqfazSMOqPOeU2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAAMCDeeFVY_NVnzdZYumyxJ_aUTy9_gybhFDqfazSMOqPOeU2A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 06, 2018 at 04:31:58PM -0600, Roger Heflin wrote:
> What kind of drive is it?   I have had good luck getting seagates to
> remap, on my 3tb WD Red drive with bad sectors the drive does not seem
> to remap them as easily.
 
Device Model:     WL6000GSA6457
Serial Number:    WOL240367065
LU WWN Device Id: 5 0014ee 05932b834
Firmware Version: 82.00A82
User Capacity:    6,001,175,126,016 bytes [6.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   9
ATA Standard is:  Not recognized. Minor revision code: 0x001f

> So far I have a lot of repeat bad sectors, but only 1 has remapped,
> even thought I am given the drive a lot of chances to remap the
> sectors.

Yeah, it seems that things don't work like they should.

Glad to know that it's not just me, then :)

I'll probably return these drives because that behaviour is not ok, but
at the same time it's interesting to learn about failure cases on data
that I could afford to lose (mostly it's the time lost to re-sync a very
big backup, i.e 1 to 2 weeks)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

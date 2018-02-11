From: Marc MERLIN <marc@merlins.org>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Sun, 11 Feb 2018 08:41:43 -0800
Message-ID: <20180211164143.cjclgupqnswtqvbw@merlins.org>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <1934212.TzpEgCIeIR@matkor-lenovo>
 <20180211154158.qiddefzyhm7y2p42@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180211154158.qiddefzyhm7y2p42@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mateusz Korniak <mateusz-lists@ant.gliwice.pl>
Cc: Phil Turmel <philip@turmel.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>, Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 11, 2018 at 07:41:58AM -0800, Marc MERLIN wrote:
> As a last update on those drives, sadly they seem to have real problems
> with SMART, which is why I was confused when using them.
> 
> myth:~# badblocks -fsvn -b512 /dev/sdf
> /dev/sdf is apparently in use by the system; badblocks forced anyway.
> Checking for bad blocks in non-destructive read-write mode
> From block 0 to 3131110575
> Checking for bad blocks (non-destructive read-write test)
> Testing with random pattern: done                                                 
> Pass completed, 0 bad blocks found. (0/0/0 errors)
> 
> That means a full read/write scan ran ok.
> Yet:
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       7
> 
> 7 sectors still marked as pending. This makes no sense...
 
And it gets "better", just re-ran a long self test, and still got:
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%       561         569442000

So, the disk sees bad blocks, SMART says there are bad blocks, and
badblocks run over the entire drive in read/write mode, finds nothing
anymore.

Anyway, those drives are going back in the box and the mail tomorrow,
but that sure is/was weird...

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08

From: Marc MERLIN <marc@merlins.org>
Subject: Re: Intent Bitmap size and performance
Date: Sat, 1 Feb 2014 16:56:46 -0800
Message-ID: <20140202005646.GC25441@merlins.org>
References: <20140202003915.GB25441@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140202003915.GB25441@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Feb 01, 2014 at 04:39:15PM -0800, Marc MERLIN wrote:
> How can I tell I got the size for my array size?

Aah, the clue seems to be in the kernel logs:
[669348.274368] md7: bitmap file is out of date (0 < 38029) -- forcing full recovery
[669348.299174] created bitmap (15 pages) for device md7
[669348.316720] md7: bitmap file is out of date, doing full recovery
[669348.380555] md7: bitmap initialized from disk: read 1 pages, set 29809 of 29809 bits

If I got the math right, 30K bits for 8TB is one bit per 266MB.

Given that, I'm going to assume that this is not going to impact system
performance much for most operations.

Is my assumption and conclusion correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901

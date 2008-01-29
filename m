From: Russell Coker <russell@coker.com.au>
Subject: Re: write-intent bitmaps
Date: Tue, 29 Jan 2008 18:32:14 +1100
Message-ID: <200801291832.18375.russell@coker.com.au>
References: <200801272134.57690.russell@coker.com.au> <200801280212.25381.russell@coker.com.au> <479E1BB3.2080702@tmr.com>
Reply-To: russell@coker.com.au
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479E1BB3.2080702@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

On Tuesday 29 January 2008 05:15, Bill Davidsen <davidsen@tmr.com> wrote:
> You may have missed the "much higher" part of the previous paragraph.
> And given the reliability of modern drives, unless you have a LOT of
> them you may be looking at years of degraded performance to save a few
> hours of slow performance after a power fail or similar. In other words,
> it's not as black and white as it seems.

What is the pathological case?  1/2 or 1/3 write performance?

For serious write performance of a RAID you want a NVRAM write-back cache for 
RAID-5 stripes, and the NVRAM cache removes the need for write-intent 
bitmaps.  AFAIK Linux software RAID doesn't support such things and that 
putting filesystem journals and the write-intent bitmap blocks on NVRAM 
devices is the best that you could achieve.

It seems that if you want the best performance for small synchronous writes 
(EG a mail server - which may be the most pessimal application for 
write-intent bitmaps) then hardware RAID is the only option.

Are there plans for supporting a NVRAM write-back cache with Linux software 
RAID?

-- 
russell@coker.com.au
http://etbe.coker.com.au/          My Blog

http://www.coker.com.au/sponsorship.html Sponsoring Free Software development

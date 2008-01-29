From: Russell Coker <russell@coker.com.au>
Subject: Re: write-intent bitmaps
Date: Tue, 29 Jan 2008 20:40:20 +1100
Message-ID: <200801292040.23532.russell@coker.com.au>
References: <200801272134.57690.russell@coker.com.au> <200801291832.18375.russell@coker.com.au> <479EEE38.9070505@rabbit.us>
Reply-To: russell@coker.com.au
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479EEE38.9070505@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org, pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

On Tuesday 29 January 2008 20:13, Peter Rabbitson <rabbit+list@rabbit.us> 
wrote:
> Russell Coker wrote:
> > Are there plans for supporting a NVRAM write-back cache with Linux
> > software RAID?
>
> AFAIK even today you can place the bitmap in an external file residing on a
> file system which in turn can reside on the nvram...

True, and you can also put the journal of a filesystem on a NVRAM device.  But 
that doesn't give the stripe aggregating benefits for RAID-5 or the general 
write-back cache benefits for everything else.

-- 
russell@coker.com.au
http://etbe.coker.com.au/          My Blog

http://www.coker.com.au/sponsorship.html Sponsoring Free Software development

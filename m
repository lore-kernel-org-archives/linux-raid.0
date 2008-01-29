From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: write-intent bitmaps
Date: Tue, 29 Jan 2008 10:13:28 +0100
Message-ID: <479EEE38.9070505@rabbit.us>
References: <200801272134.57690.russell@coker.com.au> <200801280212.25381.russell@coker.com.au> <479E1BB3.2080702@tmr.com> <200801291832.18375.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200801291832.18375.russell@coker.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: russell@coker.com.au
Cc: linux-raid@vger.kernel.org, pkg-mdadm-devel@lists.alioth.debian.org
List-Id: linux-raid.ids

Russell Coker wrote:
> Are there plans for supporting a NVRAM write-back cache with Linux software 
> RAID?
> 

AFAIK even today you can place the bitmap in an external file residing on a 
file system which in turn can reside on the nvram...

Peter


From: Michal Soltys <soltys@ziu.info>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Fri, 26 Dec 2008 00:02:12 +0100
Message-ID: <495410F4.5010508@ziu.info>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

> 
> I am not worried about the filesystem as the defaults usually get it 
> right but with parted, this is the first time I had to use it for home 
> use and with RAID-6 I am noticing slower performance with 15 disks (1 is 
> a spare) in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting 
> with 10 raptor150s in RAID-6 (but I had used fdisk there).
> 
> Justin.
> 

For best effect - partition should start at 1920th sector (stripe width
boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
case. Parted shows the values normally - from the beginning of the 
volume, 0 based.


ps.

I dropped some of CCs.


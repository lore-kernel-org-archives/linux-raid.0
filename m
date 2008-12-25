From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: How do I tell if my partition is aligned for a 64k/RAID-6?
Date: Thu, 25 Dec 2008 18:46:37 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812251846270.32331@p34.internal.lan>
References: <alpine.DEB.1.10.0812250821360.31386@p34.internal.lan> <495410F4.5010508@ziu.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <495410F4.5010508@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Fri, 26 Dec 2008, Michal Soltys wrote:

>> 
>> I am not worried about the filesystem as the defaults usually get it right 
>> but with parted, this is the first time I had to use it for home use and 
>> with RAID-6 I am noticing slower performance with 15 disks (1 is a spare) 
>> in RAID-6 (albeit slower 7200 ones, RE3s) than I was getting with 10 
>> raptor150s in RAID-6 (but I had used fdisk there).
>> 
>> Justin.
>> 
>
> For best effect - partition should start at 1920th sector (stripe width
> boundary), and su/sw should be appropriately set - su=64k,sw=13 in your
> case. Parted shows the values normally - from the beginning of the volume, 0 
> based.
>
>
> ps.
>
> I dropped some of CCs.

Thanks.

From: David Brown <david@westcontrol.com>
Subject: Re: Mixing 512 bytes and 4K sector harddrives in a raid1?
Date: Mon, 07 Feb 2011 14:56:04 +0100
Message-ID: <iiotq0$gpa$1@dough.gmane.org>
References: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=43ujbivEtgq1fyn0hnRRXvJJKmojf7LZhtid9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/2011 12:41, Henrik Olsson wrote:
> Hi,
>
> One of the drives in my raid1 recently crashed and it looks like all
> the replacement disks (2TB) i can find use 4K sectors, but the old
> ones were 512 bytes.
> Are there any issues with having a raid1 array with different sector
> sizes for the drives?
>
> Regards,
> Henrik

I can't answer for sure, but I would think there would be no problem as 
long as you make sure your partitions are 4 KB aligned.  AFAIUI, Linux 
always writes in 4K blocks to the disks anyway, so alignment is the only 
issue - and that's a performance issue, not a correctness one.



From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: multiple Sata SATAII 150,
 TX4  - how to tell which drive is which?headaches galore!
Date: Tue, 24 Jan 2006 01:30:21 -0500
Message-ID: <200601240130.21378.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 23 January 2006 09:46 pm, Shawn wrote:
> Confirmed.  Using the promise OEM driver, (ulsata2.ko) module the FC4
> discovery order comes in exactly as printed on the board's themselves,
> ports 1-4.

Dear Shawn,

Thank you so much for so much excellent legwork. 

I had looked and seen a "disconnect" between the printed documentation ports 1 
2 3 4, and the actual 3-2-4-1 that you noticed, and decided it was "random". 
Really it was not random it was just "bizarre" :). But I am glad to see it is 
consistently bizarre, across drives (and I hope across PCI slots :) ).

I will check with my two card system to see what happens when I boot them all, 
or partial sets up.  I am curious - I take it from you that it goes

3241
then
3241
on the next machine.

I see from anothe post that I can check what is happening with the drive
serial numbers and  hdparm.

I also will have to take the time to compile my own kernel to check out
 2.6.15 which will give me the smartctl. Thanks to all who let me know about
 that!

I just discovered that I need a second power supply because
a 450W antec smartpower 2.0 is not enough power for 9 active drives and fans
on my system :(.

I must look for a better power supply. What do you recommend for big
multidrive systems?

Thank you very much.

Mitchell Laks

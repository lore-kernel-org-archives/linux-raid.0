From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: powersupply for 16disks +dual xeon
Date: Sat, 1 Feb 2003 20:38:51 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0302012036370.3772-100000@uplift.swm.pp.se>
References: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302011823430.6789@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 1 Feb 2003, Stephan van Hienen wrote:

> any tips how to fix this ?
> (as far as i know there is no spinup delay for ide disks)
> maximum powersupply i found is 550W, not much more than i have in my
> system

You should try to fit another powersupply to drive the disks. ATX 
powersupplies can be made powermanently on by shorting ping 14 and 15 (I 
think it was, there is a FAQ page out there I found on when I was looking 
a month back). If you don't want to do this, get yourself an AT power 
supply.

I run 10 disks off of a 350W power supply (dual 1.13GHz pIII board) and it 
has worked fine, I think you're not too far off the limit. Perhaps that 
550W will do the trick.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se


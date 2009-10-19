From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: HW Raid Question
Date: Mon, 19 Oct 2009 12:22:32 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.0910191221040.5824@uplift.swm.pp.se>
References: <c268e4660909272103r3831e129m68c11899b11be222@mail.gmail.com> <b95c1fdd0910190318s25a8e630l4dcc27eaa291f2ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b95c1fdd0910190318s25a8e630l4dcc27eaa291f2ba@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 19 Oct 2009, Pawe? Brodacki wrote:

> You cannot grow an array on ServeRAID by replacing smaller drives with 
> bigger ones. If you do such a replacement the drive size will be 
> "clipped". That means if you have 5x36 GB drive, remove one, and put in 
> a 140 GB drive, only 36 GB out of it will be used. I'm pretty sure this 
> will also happen if you try to extend the array by adding bigger drives 
> to the already existing array.
>
> The only way is to tear the array down and re-define it with bigger drives.

Just to give input from some other vendor, when I asked 3ware the same 
question they said they could take some dump from the config of the 3ware 
controller, process it, and then you put it back in, and it would support 
the larger drives. Ie, this seems to be something the hw raid crowd 
doesn't feel is an important method of storage migration to support.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

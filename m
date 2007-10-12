From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: RAID6 recover problem
Date: Fri, 12 Oct 2007 18:28:03 +0200
Message-ID: <33C87F4D-68E1-4F05-98AB-FBA0A9746757@bj-ig.de>
References: <8F1D6256-0F63-4B79-8D66-87EFB96DFD6A@bj-ig.de> <20071012175139.o7gz7ka934s0s0gw@cakebox.homeunix.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071012175139.o7gz7ka934s0s0gw@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Nagilum <nagilum@nagilum.org>
List-Id: linux-raid.ids


Am 12.10.2007 um 17:51 schrieb Nagilum:

> Then you can mark them as bad and linux will sync to a spare.

Because it is already running without redundancy - two disks marked  
as failed - it will simply go offline.

> As for your sdc, I'd test it outside of the raid (dd if=/dev/sdc  
> of=/dev/null) to see if this is a real defect or 'just' a checksum  
> error.
> Then you might also try the fridge (if it's a real defect) or just  
> ignore the error.

I assume it simply is a checksum error.

> I think there is a special "dd" version which will not abort on a  
> read error. With that you could also clone that drive (except the  
> failing sectors ofcourse).

I will try to clone this disk and see what happens.

Thanks for the hint
Ralf

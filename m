From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 resize in 2.6.17 - how will it be different from raidreconf?
Date: Mon, 22 May 2006 08:51:54 +1000
Message-ID: <17520.61194.529436.322401@cse.unsw.edu.au>
References: <200605220034.49858.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 22, Dexter.Filmore@gmx.de wrote:
> How will the raid5 resize in 2.6.17 be different from raidreconf? 

It is done (mostly) in the kernel while the array is active, rather
than completely in user-space while the array is off-line.

> Will it be less risky to grow an array that way?

It should be.  In particular it will survive an unexpected reboot (as
long as you don't lose and drives at the same time) which I don't
think raidreconf would.
Testing results so far are quite positive.


> Will it be possible to migrate raid5 to raid6?
> 

Eventually, but no time frame yet.

> (And while talking of that: can I add for example two disks and grow *and* 
> migrate to raid6 in one sweep or will I have to go raid6 and then add more 
> disks?)

Adding two disks would be the preferred way to do it.
Add only one disk and going to raid6 is problematic because the
reshape process will be over-writing live data the whole time, making
crash protection quite expensive.
By contrast, when you are expanding the size of the array, after the
first few stripes you are writing to an area of the drives where there
is no live data.

NeilBrown

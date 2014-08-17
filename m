From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: Re: memory leak with linux-3.14.16
Date: Sun, 17 Aug 2014 10:55:04 +0200
Message-ID: <201408170855.s7H8t420028767@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Neil,

> That won't help.  Data stored in kmalloc-256 won't get swapped out - it stays
> in RAM.  So unless you can hot-plus 20Gig of RAM ....

Thanks for the info. I read it when almost all my memory were in
kmalloc-256. Half an hour later my machine would have crashed despite
the increased swapspace. So I could do a graceful reboot and the reshape
has sucessfully finished in the meantime.

Now I'm going to add those three drives to my array one by one. I'm doing
this because I cannot physically swap drive 13 and 14 (the next maintenance
window for such an operation would be in october). I will grow the array
to 14 drives today since my main concern is to put the data on an even
number of disks where the mirrors are separated correctly.

Then I will add drive 14 and 15 in one step.

By the way: Will a raid10 array with an even number of drives survife
if one half of the drives go offline during a reshape operation that
adds an even number of drives?

Should I download linux 3.14.17 sources and wait for a patch? If only
a missing kfree() has to be added somewhere I can do that by hand and
recompile 3.14.16.

Would it help you if I setup another machine and try to reproduce the
problem with linux 3.15.x, 3.16.x and 3.17.x?

Peter

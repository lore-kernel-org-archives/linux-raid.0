From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: strange test results
Date: Tue, 20 Mar 2007 11:14:39 -0400
Message-ID: <45FFFA5F.5020805@tmr.com>
References: <Pine.LNX.4.64.0703192018130.18749@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703192018130.18749@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Tomka Gergely <gergely@tomka.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomka Gergely wrote:
> Hi!
>
> I am running tests on our new test device. The device has 2x2 core Xeon, 
> intel 5000 chipset, two 3ware sata raid card on pcie, and 15 sata2 disks, 
> running debian etch. More info at the bottom.
>
> The first phase of the test is probing various raid levels. So i 
> configured the cards to 15 JBOD disks, and hacked together a testing 
> script. The script builds raid arrays, waits for sync, and then runs this 
> command:
>
> iozone -eM -s 4g -r 1024 -i0 -i1 -i2 -i8 -t16 -+u
>
> The graphs of the results here:
>
> http://gergely.tomka.hu/dt/index.html
>
> And i have a lots of questions.
>
> http://gergely.tomka.hu/dt/1.html
>
> This graph is crazy, like thunderbolts. But the raid50 is generally slower 
> than raid5. Why?
>
> http://gergely.tomka.hu/dt/3.html
>
> This is the only graph i can explain :)
>
> http://gergely.tomka.hu/dt/4.html
>
> With random readers, why raid0 slowing down? And why raid10 faster than 
> raid0?

Because with two copies of the data there is a better chance that one 
copy will be on a drive which is less busy, and/or has a shorter seek to 
position the heads. If you want to verify this you could create a RAID-1 
with three (or more) copies and run readers against that.

BTW: that's the only one of your questions I could answer quickly.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979


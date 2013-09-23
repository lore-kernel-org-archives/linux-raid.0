From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Desperate: mdadm fails to assemble raid saying devices are
 busy.
Date: Mon, 23 Sep 2013 17:43:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1309231740580.32315@uplift.swm.pp.se>
References: <523DADE5.8050604@gmail.com> <CAAMCDed1UffC4yj9DvKSu_9HhrJo6XLh4tHqkU9ymhP19AD1Ag@mail.gmail.com> <524053D3.4060707@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <524053D3.4060707@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Garg <sgarg.bugreporter@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 23 Sep 2013, Sachin Garg wrote:

> Hi Roger & Mikael,
>
> Thanks a lot for your replies. I tried the following and still to no avail.
>
> Here are the results of the various commands:
>
> # cat /proc/mdstat
> Personalities :
> md0 : inactive sda2[0](S) sdb1[4](S) sdc2[1](S)
>      480215144 blocks super 1.2

Do "mdadm --stop /dev/md0" and then try

"mdadm --assemble /dev/md0 /dev/sda2 /dev/sdb1 /dev/sdc2"

See if this removes the busy problem. Also post output from this 
operation as well as what comes up in dmesg when you do this.


-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

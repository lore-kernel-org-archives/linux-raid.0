From: Huntress Gary B NPRI <HuntressGB@Npt.NUWC.Navy.Mil>
Subject: FW: High System Load
Date: Wed, 28 Jul 2004 20:47:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A506359028CAD21191C10008C75D895C0A06C866@NPRI54EXC14.NPT.NUWC.NAVY.MIL>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 
It turns out that one drive had dma off for some reason and I have corrected that.   I also ran the sysctl as below.   Right when I did that the system load was 21.   After about 5 minutes of getting the system catching up it has recovered to a "nicer" load of 6 and dropping.

Thank you! 

Gary H.




-----Original Message-----
From: Jim Paris
To: Mike Hardy
Cc: Kanoa Withington; Huntress Gary B NPRI; 'linux-raid@vger.kernel.org'
Sent: 7/28/2004 8:17 PM
Subject: Re: High System Load

> #!/bin/tcsh
> while 1
>   cat /proc/mdstat
>   sleep 1
>   clear
> end

.. or just 'watch cat /proc/mdstat' :)

> There's got to be something else happening on the machine...

I find that if the kernel variable dev.raid.speed_limit_max is too
high (the default, 200000, is usually too high), then the rebuild
could taking all available I/O time.  This can cause every other
process trying to do I/O on the machine to block, which may be the
reason your load average is so high.

Try doing 'sysctl -w dev.raid.speed_limit_max=10000' and see if things
improve.

-jim

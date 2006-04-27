From: Konstantin Olchanski <olchansk@triumf.ca>
Subject: Re: disks becoming slow but not explicitly failing anyone?
Date: Wed, 26 Apr 2006 20:31:45 -0700
Message-ID: <20060427033145.GE2828@send.triumf.ca>
References: <17482.35982.996526.551753@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17482.35982.996526.551753@fisica.ufpr.br>
Sender: linux-raid-owner@vger.kernel.org
To: Carlos Carvalho <carlos@fisica.ufpr.br>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Apr 22, 2006 at 05:05:34PM -0300, Carlos Carvalho wrote:
> We've been hit by a strange problem for about 9 months already. Our
> main server suddenly becomes very unresponsive, the load skyrockets
> and if demand is high enough it collapses. top shows many processes
> stuck in D state. There are no raid or disk error messages, either in
> the console or logs.

Yes, I see similar behaviour with IDE and SATA disks, on random
interfaces, including one 3ware 8506-12 SATA 12 port unit.

I am using a disk testing program that basically
does "dd if=/dev/disk of=/dev/null" but does not give up
on i/o errors and that also measures and reports
the response time of every read() system call. I run
this program on all my disks every Tuesday.

Most disks respond to every read in under 1 second. (There
is always some variation and delays caused by other
programs accessing the disks while the test is running).

Sometimes, some disks take 5-10 seconds to respond and
I now consider this "normal". It's "just" "hard to read" sectors.

Sometimes, some disks take 30-40 seconds to respond
and sometimes result in i/o errors to the user code (timeout + reset
on the hardware side). Sometimes SMART errors errors would be logged,
but not always. The "md" driver does not like these errors
and causes RAID5 and "RAID1/mirror" faults. "RAID0/striped" arrays
seem to survive. I consider these disks as "defective" and replace
them as soon as possible. They usually fail vendor diagnostics
and I do warranty exchanges.

I once had a disk that one some days does all reads in under 1 sec,
but on other days, takes more than 30 seconds (ide timeout + reset +
i/o error). It is probably correlated to the disk temperature.

I now have two SATA disks in the same enclosure: one consistently
gives i/o errors (there is one unreadable bad sector, also
reported by SMART), the other one gives errors maybe every other
time (i.e. it has "hard to read" sector). (For logistics reasons
I am slow at replacing both disks).

K.O.


> 
> The machine has 4 IDE disks in a software raid5 array, connected to a
> 3Ware 7506. Only once I saw warnings of scsi resets of the 3Ware due
> to timeouts.
> 
> This 3Ware card has leds which are on when there's activity in the IDE
> channel. As expected, all leds turn on and off almost simultaneously
> during normal operation of the raid5, however when the problem appears
> one of the leds stays on much longer than the others for each burst of
> activity. This shows that the disk is getting much slower than the
> others, holding the whole array.
> 
> Several times a smart test of the disk shows read failures but not
> always. I've changed cables, 3Ware card and even connected the slow
> disk in the IDE channel of the motherboard to no avail. Changing the
> disk and reconstructing the array restores normal operation.
> 
> This has happened with 7 (seven!!) disks already, 80GB and 120GB,
> Maxtor and Seagate. Has anyone else seen this?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada

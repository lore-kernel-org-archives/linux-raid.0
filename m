From: "Diamon" <diamon@io.com>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Fri, 10 May 2002 01:36:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000f01c1f7ec$f84b1fe0$a859aac7@cust.io.com>
References: <5.1.0.14.2.20020509152331.03accca0@mail.harddata.com> <003401c1f7d9$97c7c460$050010ac@niunia.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Artur Jasowicz <arturj@mousebusiness.com>, linux-raid@vger.kernel.org
Cc: Maurice Hilarius <maurice@harddata.com>
List-Id: linux-raid.ids


----- Original Message -----
From: "Artur Jasowicz" <arturj@mousebusiness.com>
To: <linux-raid@vger.kernel.org>
Cc: "Maurice Hilarius" <maurice@harddata.com>
Sent: Thursday, May 09, 2002 11:16 PM
Subject: Re: Fw: DriveReady SeekComplete problems


> From: Maurice Hilarius
> > With regards to your message at 03:13 PM 5/9/02, Artur Jasowicz. Where
you
> > stated:
> > >I am building a file server with 5 drive software RAID5 array. I am
using
> > >three IWill SIDE-100 (Highpoint 370A) controllers as my IDE interfaces,
> > >not using their RAID functionality. One Maxtor 160GB drive per channel,
> > >two channels per controller. I plan on adding hot spare as the sixth
> drive
> > >in the future. There's one 160GB partition on each drive. Linux version
> > >2.4.19-pre7smp-020502b (root@production) (gcc version 2.96 20000731
(Red
> > >Hat Linux 7.1 2.96-98)) #6 SMP Thu May 2 12:15:34 CDT 2002
> > >This is a dual Athlon 2000+ MP on Tyan Tiger S2466N-4 with 1GB RAM. OS
> and
> > >swap runs on separate drives and controllers. This array will be just
for
> > >data once it is configured.
> > >
> > >Below are the most relevant parts of my logs. I will post further
details
> > >if anyone is willing to help, just let me know what info you need. Any
> > >suggestions greatly appreciated.
> >
> > Probably cable problem..
> May be, although I've used original, 18in cables, changed the config to
use
> diferent controllers, the errors came from all drives, randomly. Isn't it
> unlikely, that all cables are bad?
>

    Unless those aren't ATA-100 cables and it's still using ATA-100 mode...
I think ATA-66 or higher you need those 80-wire cables...  Just a thought.
And the solid-core 80 pin cables don't handle folding well at all, maybe
something's gone flaky in them?

> >
> > Maybe cards not getting a clean IRQ status.
> >
> I'm not sure what you mean by that, here's my IRQs is that ok?
> [root@production root]# cat /proc/interrupts
>            CPU0       CPU1
>   0:    1060111     900968    IO-APIC-edge  timer
>   1:       2223       1623    IO-APIC-edge  keyboard
>   2:          0          0          XT-PIC  cascade
>   5:     475613     476603   IO-APIC-level  ide2, ide3, eth1
>   8:          1          0    IO-APIC-edge  rtc
>   9:     464960     465255   IO-APIC-level  ide4, ide5, eth2
>  10:      12405      11231   IO-APIC-level  eth0
>  11:      69567      67494   IO-APIC-level  ide6
>  12:        159       1172    IO-APIC-edge  PS/2 Mouse
>  14:      48388      44855    IO-APIC-edge  ide0
>  15:      48907      47090    IO-APIC-edge  ide1
> NMI:          0          0
> LOC:    1961162    1961161
> ERR:          0
> MIS:          0
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


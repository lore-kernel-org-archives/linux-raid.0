From: =?ISO-8859-1?Q?Jo=EBl?= Bourquard <numlock@freesurf.ch>
Subject: Highpoint 1820 Redux
Date: Thu, 15 Jan 2004 16:29:14 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1074180553.25091.52.camel@localhost.localdomain>
Reply-To: numlock@freesurf.ch
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would appeciate some advice on SATA controllers.. and since many
people appear to be concerned, I'm posting it here.

The arrays will be two software RAID5 of 8 SATA disks each.

The mainboard will probably be a Tyan S2880GNR. In short it provides:
- two 64-bit 66MHz PCI-X slots
- and two 64-bit 66/133MHz PCI-X slots.

Unless it proves to be foolish, I'll probably put 1 CPU on it.

Now I was about to simply take two Highpoint RocketRAID 1820, but
according to some posts here, it seems the guys at Highpoint didn't
provide great Linux support after all. Sigh.

Now it seems they added a "Linux OpenBuild driver" there:
http://www.highpoint-tech.com/USA/brr1820.htm

Does it use libata ? Is it just a marketing joke ? Has anyone tried it
with an actual board ?

It seems Jeff Garzik recommends the Promise or ServerWorks 4- and 8-port
boards instead (from http://www.spinics.net/lists/raid/msg03936.html).

Trouble is, I have seen no such 8-port board. The only thing I found on
the web was a SuperMicro board with a Marvell (?) chip onboard:
http://www.supermicro.com/PRODUCT/Accessories/DAC-SATA-MV8.htm

They seem to have sources for a kernel module there:
ftp://ftp.supermicro.com/driver/SATA/DAC_SATA-MV8/LinuxIAL/

Now I'm a bit lost.. I mean, of these two boards (Highpoint and
SuperMicro), which one (if any) is supposed to work well in Linux
2.4.20+ or 2.6.0+ ? Which one would work with TCQ enabled ?

My primary concern when making a RAID5 is the read performance. So that
would be nice if my controller is among the fastest when using libata.
In particular, TCQ support (when it happens) will be important.

Since hardware RAID is not needed, and there are four PCI-X slots, I
thought about using four 4-port controllers (or maybe three 6-port
controllers).

Now...
- are they slower than 3ware (JBOD) and other 8-port controllers ?
- do they have onboard SRAM ?

Fortunately, since it is a dedicated machine, pretty much any kernel
version can be used if needed.

Sorry for the long post..

Thanks in advance !

Joel


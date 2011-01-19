From: Roberto Spadim <roberto@spadim.com.br>
Subject: RAID0 - cache
Date: Wed, 19 Jan 2011 18:13:23 -0200
Message-ID: <AANLkTik7xBOYVgZJC0sStpK=oPHdX53XzwYC5CVDKy_v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi guys, from a long email i will start this one: (the last one wasn=B4=
t send)

think about this:

/dev/sda (sata disk 1000gb size, latency of 1ms to move head, 100mb/s
to write/read)
/dev/sdb (ssd 1gb size, latency of <100us to find what flash and
position, 500mb/s to write/read)
ram memory (8gb size, with 1gb not used)
/dev/mdxxx (the new device i=B4m calling it as raid0-cache)

how raid0-cache work?


how to create raid?
tell what the sequencial read cache estrategy:
memory(tell fixed memory size) - /dev/sdb - /dev/sda - another device
(maybe just 2 is suficiente /dev/sdb and /dev/sda)...


how to read?
first, read from the first read device (memory)
if information not there -> read from second read device (/dev/sdb),
update information at first read device, return the read value
if information not there -> read from third read device (/dev/sda),
update information at second and first read device, return the read
value

how to write?
flush space from first read device to second read device
write to first read device, return OK

background thread:
sync from first write device (memory) to second write device (/dev/sdb)
flush from second write device (/dev/sdb) to third write device (/dev/s=
da)

startup:
using cache:
 flush everythink from first write device (memory) to second write
device (/dev/sdb)
 flush everythink from second write device (/dev/sdb) to second write
device (/dev/sda)
 since memory is volatille, at startup it can=B4be flushed...
without cache:
 make first write device unusable (memory)
 make second write device unusable
 here we can have write problems, since a wrong power off, can lost
information from cache (first and second write device)



anyidea who can make it?
thanks
--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
